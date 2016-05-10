/***** The Controller for the Page "TBN_MapReps"*****/
/***
@Developer Name : V Kumar
Percentage of best practices followed : 100%
No of SOQL queries used : 3
No of collections used : 0
Exception Handling implemented : Yes
Coding standards followed : Yes
Naming conventions followed : Yes
Third party integrations :
Maximum of No of records tested with : 
Customer Approval : 
Last Modified Date: 7-12-12
Approved by:
 
@Major Change 1
JIRA Link:https://trekbin.jira.com/browse/VIRSYGEN-11
Short desc:
Impacted methods/areas:
Result:
Changed By:
Approved By:
**********/
public with sharing class LOC_TBN_MapReps
{ 
/* Public get set variables and collection */
  public string googleMapstr{get;set;}
  public  string recId {get;set;}
  public static decimal currentLat{get;set;}
  public static decimal currentLong{get;set;}
  public boolean  hasLatLang{get;set;}
  public string strDistance{get;set;}
  public Account objAcc{get;set;}
  public string accAddress{get;set;}
  
  public String strAccountName{get;set;}
  
  /* Private  collection */
  private static map<Id,decimal> mapAccIdToDist;  
  
  public LOC_TBN_MapReps() 
  {
    try
    {
      googleMapstr='https://maps.googleapis.com/maps/api/js?v=3&sensor=false';
      recId = ApexPages.currentPage().getParameters().get('recId'); 
      hasLatLang = true;
      if(recId != null && recId != '')
        {
          objAcc = [Select Name,ShippingState,ShippingStreet,ShippingCity,ShippingPostalCode,ShippingCountry,LOC_Longitude_x__c,LOC_Latitude_x__c,Phone
              From Account Where Id =:recId];
        currentLat = objAcc.LOC_Latitude_x__c;
        currentLong = objAcc.LOC_Longitude_x__c;
        
        strAccountName = String.escapeSingleQuotes(objAcc.Name);
        
        accAddress ='';
        if (objAcc.ShippingStreet != null && objAcc.ShippingStreet != '')
          accAddress += objAcc.ShippingStreet +',';
              if (objAcc.ShippingCity != null  && objAcc.ShippingCity != '')
                  accAddress += objAcc.ShippingCity +',';
              if (objAcc.ShippingState != null  && objAcc.ShippingState != '')
                  accAddress += objAcc.ShippingState +',';
              if (objAcc.ShippingPostalCode != null  && objAcc.ShippingPostalCode != '')
                  accAddress += objAcc.ShippingPostalCode +',';
              if (objAcc.ShippingCountry != null  && objAcc.ShippingCountry != '')
                  accAddress += objAcc.ShippingCountry +',';
        
              if( accAddress.length() > 1 && accAddress.endsWith(','))
              {
                accAddress =  String.escapeSingleQuotes(accAddress); 
                accAddress = accAddress.substring(0,accAddress.length()-1);
              }  
              if(objAcc.Phone != null)  
                accAddress += ' <br/> \' \n  +\' Phone: ' + objAcc.Phone;
               
        if(currentLat == null && currentLong == null )
        {
          hasLatLang = false;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Address could not be located . Update its lattitude and longitude fields'));
        }
        }
        else
        {
          hasLatLang = false;
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid ID in URL'));
        }
    }
      catch(Exception e )
      {
        system.debug('Exception ======================'+e.getMessage());
      }
  }
    
  //Method for calculating distance
  public static void   calculateDistance(decimal lat , decimal longt , list<Contact> lstContacts, list<User> lstUsers)
    {
      mapAccIdToDist =  new map<Id,decimal>();
      decimal R = 3958.7558657440545; // Radius of earth in Miles 
      
    if(lstContacts != null) 
      for(Contact Objcontact : lstContacts)
      {
        if( Objcontact.LOC_Longitude_x__c != null &&  Objcontact.LOC_Latitude_x__c != null )
        {
          decimal lat1 = lat;
            decimal lat2 = Objcontact.LOC_Latitude_x__c;
            decimal lon1 = longt;
            decimal lon2 = Objcontact.LOC_Longitude_x__c;
  
            decimal dLat = ((lat2-lat1)*22)/(180*7);
            decimal dLon = ((lon2-lon1)*22)/(180*7);
            lat1 = lat1*22/(180*7);
        lat2 = lat2*22/(180*7);
            
            decimal a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                    Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
            decimal c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
                            
            decimal milesdistance = R * c;
            mapAccIdToDist.put(Objcontact.Id ,milesdistance);
        }
      }
    
    if(lstUsers != null)
    for(User objUser : lstUsers)
      {
        if( objUser.LOC_Longitude__c != null &&  objUser.LOC_Latitude__c != null )
        {
          decimal lat1 = lat;
            decimal lat2 = objUser.LOC_Latitude__c;
            decimal lon1 = longt;
            decimal lon2 = objUser.LOC_Longitude__c;
  
            decimal dLat = ((lat2-lat1)*22)/(180*7);
            decimal dLon = ((lon2-lon1)*22)/(180*7);
            lat1 = lat1*22/(180*7);
        lat2 = lat2*22/(180*7);
            
            decimal a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                    Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
            decimal c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
                            
            decimal milesdistance = R * c;
            mapAccIdToDist.put(objUser.Id ,milesdistance);
        }
      }
      
    }
    //Method returning  distances
    public List<SelectOption> getDistances() 
    {
    list<SelectOption> lstDistance = new list<SelectOption>();
        lstDistance.add(new SelectOption('10', '10'));
        lstDistance.add(new SelectOption('25', '25'));
        lstDistance.add(new SelectOption('50', '50'));
        lstDistance.add(new SelectOption('100', '100'));
        lstDistance.add(new SelectOption('200', '200'));
    return lstDistance;
  }
    //Wrapper class to bind Account and its lattitude and longitude
  public class accLatLangWrapper   
    {
         public Id objAccId ;
         public string objType{get;set;}
         public String objName{get;set;}
         public Decimal lat {get;set;}
         public Decimal longt {get;set;}
         public String address{get;set;}
         public string strPhone{get;set;}
         public String strCompanyName{get;set;}
  }
    
    //This remote method returns list of wrappper class
  @RemoteAction
    public static list<accLatLangWrapper> getAccountLocations(String recordId, string latitude,string longitude, String strDist)
    {
      mapAccIdToDist =  new map<Id,decimal>();
      list<accLatLangWrapper> lstWrapper =  new list<accLatLangWrapper>();
      try
      {
        list<Contact> lstContact;
      lstContact = [Select Name,Phone, LOC_Longitude_x__c,LOC_Latitude_x__c,MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity, Account.Name
              From Contact
              where  LOC_Longitude_x__c != null and LOC_Latitude_x__c != null 
              and Account.LOC_Manufacturers_Rep__c = true  limit 1000 ];
               

      list<User> lstUsers = [select Name,Phone,Street, CompanyName, State, PostalCode, Country, City, LOC_Longitude__c , LOC_Latitude__c from user where  LOC_Longitude__c != null and LOC_Latitude__c != null limit 1000];
      
      if(latitude != null && longitude != null && ((lstContact != null && lstContact.size() > 0) || (lstUsers != null && lstUsers.size() >0  )))
      {
          calculateDistance(decimal.valueOf(latitude),decimal.valueOf(longitude), lstContact,lstUsers);
        
        for(Contact Objcontact :lstContact)
        {
          if(mapAccIdToDist != null && mapAccIdToDist.size() > 0 && mapAccIdToDist.get(Objcontact.Id) != null && mapAccIdToDist.get(Objcontact.Id) <= Integer.valueOf(strDist ) )
          {
            accLatLangWrapper obj = new accLatLangWrapper();
            obj.objAccId =   Objcontact.Id; 
            obj.objName = Objcontact.Name;
            obj.objType = 'Contact';
            obj.lat =  Objcontact.LOC_Latitude_x__c;
                obj.longt = Objcontact.LOC_Longitude_x__c ; 
                
                string strAddress = '';
                
                // creating an address string
                  if (objContact.MailingStreet != null && objContact.MailingStreet != '')
                      strAddress += objContact.MailingStreet +',';
                  if (objContact.MailingCity != null  && objContact.MailingCity != '')
                      strAddress += objContact.MailingCity +',';
                  if (objContact.MailingState != null  && objContact.MailingState != '')
                      strAddress += objContact.MailingState +',';
                  if (objContact.MailingPostalCode != null  && objContact.MailingPostalCode != '')
                      strAddress += objContact.MailingPostalCode +',';
                  if (objContact.MailingCountry != null  && objContact.MailingCountry != '')
                      strAddress += objContact.MailingCountry +',';
                  if( strAddress.length() > 0 && strAddress.endsWith(',') )
                  {
                    strAddress = String.escapeSingleQuotes(strAddress);
                    strAddress = strAddress.substring(0, strAddress.length()-1);
                  }
                  if(objContact.Phone != null)
                    obj.strPhone =  ' Phone: ' + objContact.Phone;  
                  else
                    obj.strPhone = '';
                  if(objContact.Account.Name != null)
                  {
                    String strAccName =  objContact.Account.Name;
                    strAccName = String.escapeSingleQuotes(strAccName);
                    obj.strCompanyName =  ' Company Name: ' + strAccName ;  
                  }
                  else
                    obj.strCompanyName = '';
                    
                obj.address = strAddress;  
            lstWrapper.add(obj);
          }
        }
        for(User objUser :lstUsers)
        {
          if(mapAccIdToDist != null && mapAccIdToDist.size() > 0 && mapAccIdToDist.get(objUser.Id) != null && mapAccIdToDist.get(objUser.Id) <= Integer.valueOf(strDist ) )
          {
            accLatLangWrapper obj = new accLatLangWrapper();
            obj.objAccId =   objUser.Id; 
            obj.objName = objUser.Name;
            obj.objType = 'User';
            obj.lat =  objUser.LOC_Latitude__c;
                obj.longt = objUser.LOC_Longitude__c ; 
                string strAddress = '';
                // creating an address string
                if (objUser.Street != null && objUser.Street != '')
                      strAddress += objUser.Street +',';
                  if (objUser.City != null && objUser.City != '')
                      strAddress += objUser.City +',';
                  if (objUser.State != null && objUser.State != '')
                      strAddress += objUser.State +',';
                  if (objUser.PostalCode != null && objUser.PostalCode != '')
                      strAddress += objUser.PostalCode +',';
                  if (objUser.Country != null && objUser.Country != '')
                      strAddress += objUser.Country +',';
                      
            if(strAddress != '' && strAddress.length() > 1 )
            {  
              strAddress = String.escapeSingleQuotes(strAddress);
              strAddress = strAddress.substring(0, strAddress.length()-1);  
            }
            if(objUser.Phone != null)  
                    obj.strPhone = '  Phone: ' + objUser.Phone;  
                  else
                    obj.strPhone = '';
                  if(objUser.CompanyName != null)
                  {
                    String strComName = objUser.CompanyName;
                    strComName = String.escapeSingleQuotes(strComName);
                    obj.strCompanyName =  ' Company Name: ' + strComName ;  
                  }
                  else
                    obj.strCompanyName = '';  
            obj.address = strAddress;    
            lstWrapper.add(obj);
          }
        }

      }
      return lstWrapper;
      }
      catch(Exception e)
      {
        system.debug('Exception============'+e.getMessage());
        return null;
      }
       
    }
    
    //Method called when clicking on "back" link
     public pageReference goBackToRecord()
    {
      pagereference pr = new pagereference('/'+recId);
    return pr ;
    }

    
    @isTest()
  static void Test_TBN_MapRep()
  {
    test.startTest();
      
        RecordType objRecordType = [select id, Name, DeveloperName, SobjectType from RecordType where SobjectType='Account' AND Name=:'CSP' Limit 1];
    
    Account objAccount = new Account();
    objAccount.Name = 'Test Account 1';
    objAccount.ShippingState = 'test';
    objAccount.ShippingCountry = 'test';
    objAccount.ShippingStreet ='test' ;
    objAccount.ShippingCity = 'test';
    objAccount.ShippingPostalCode = '678678';
    objAccount.RecordTypeId = objRecordType.Id;
    objAccount.Type = 'Test';
    objAccount.Phone = '588789';
    insert objAccount;
    
    Profile objProfile = [select id from profile limit 1];

    User objUser = new User(alias = 'stf', email='stf@test.com', emailencodingkey='UTF-8', lastname='Testingefsfs', languagelocalekey='en_US',
                       localesidkey='en_US',timezonesidkey='America/Los_Angeles',profileid = objProfile.Id,username='stf@test.com');
    objUser.State = 'TestState';
    objUser.City = 'TestCity';
    objUser.Street ='TestStreet';
    objUser.PostalCode ='340901';
    objUser.Country = 'testCountry';
    objUser.LOC_Latitude__c = 28.42626;
    objUser.LOC_Longitude__c= -81.41005;
    objUser.Phone = '588789';
    objUser.LOC_Receive_Serial_Number_Interface_Log__c = true;
    insert objUser;
    list<User> lstUsers = new list<User>();
    lstUsers.add(objUser);
    Account objAcc = new Account();
    objAcc.Name = 'Test Account 2';
    objAcc.ShippingState = 'test';
    objAcc.ShippingCountry = 'test';
    objAcc.RecordTypeId = objRecordType.Id;
    objAcc.Type = 'Test';
    objAcc.Phone = '588789';
    if(objUser.LOC_Latitude__c != null )
      objAcc.LOC_Latitude_x__c = objUser.LOC_Latitude__c; 
    else 
      objAcc.LOC_Latitude_x__c = 28.42626;
    if(objUser.LOC_Longitude__c != null )
      objAcc.LOC_Longitude_x__c = objUser.LOC_Longitude__c; 
    else
      objAcc.LOC_Longitude_x__c =-81.41005;
    objAcc.LOC_Manufacturers_Rep__c = true;
    insert objAcc;
    list<Account> lstAccount = new list<Account>();
    lstAccount.add(objAcc);
    Contact objContact = new Contact();
    objContact.LastName = 'Test Contact ';
    objContact.MailingState = 'TestState';
    objContact.MailingCity = 'TestCity';
    objContact.MailingStreet =	'TestStreet';
    objContact.MailingPostalCode ='340901';
    objContact.MailingCountry = 'testCountry';
    objContact.Phone = '999999989';
    if(objUser.LOC_Latitude__c != null )
      objContact.LOC_Longitude_x__c = objUser.LOC_Latitude__c; 
    else 
      objContact.LOC_Longitude_x__c = 28.42626;
    if(objUser.LOC_Latitude__c != null )
      objContact.LOC_Latitude_x__c = objUser.LOC_Latitude__c; 
    else
      objContact.LOC_Latitude_x__c =-81.41005;
    objContact.LOC_Longitude_x__c = -81.41005;
    objContact.LOC_Latitude_x__c= 28.42626;
    objContact.AccountId = objAcc.Id;
        insert objContact;
        
    list<Contact> lstContacts = new list<Contact>();
    lstContacts.add(objContact);
    ApexPages.currentPage().getParameters().put('recId',objAcc.Id);
    LOC_TBN_MapReps objMap = new LOC_TBN_MapReps(); 
    if(objUser.LOC_Longitude__c != null  && objUser.LOC_Latitude__c != null  )
      LOC_TBN_MapReps.getAccountLocations(objAccount.Id,string.valueOf(objUser.LOC_Latitude__c), string.valueOf(objUser.LOC_Longitude__c),'5000');
    else
      LOC_TBN_MapReps.getAccountLocations(objAccount.Id,'28.42626', '-81.41005','5000');
    
    if(objUser.LOC_Longitude__c != null && objUser.LOC_Latitude__c != null  )
      LOC_TBN_MapReps.calculateDistance(objUser.LOC_Latitude__c, objUser.LOC_Longitude__c, lstContacts,lstUsers);  
    else
    LOC_TBN_MapReps.calculateDistance(28.42626 , -81.41005, lstContacts,lstUsers);
    objMap.getDistances();    
    
    ApexPages.currentPage().getParameters().put('recId','');
    LOC_TBN_MapReps objMap2 = new LOC_TBN_MapReps(); 
    
    ApexPages.currentPage().getParameters().put('recId',objAccount.Id);
    LOC_TBN_MapReps objMap3 = new LOC_TBN_MapReps(); 
    
    objMap.goBackToRecord();
    test.stopTest();
  } 
      
   }