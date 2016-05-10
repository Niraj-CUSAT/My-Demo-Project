/**
* @ClassName      :  TBN_CalCulateLatLangHandler 
* @JIRATicket    :  VIRSYGEN-7
* @CreatedOn      :  9/Jan/2013
* @ModifiedBy     :  V Kumar
* @Developer Name  :  V Kumar
* @Description    :  This is a common handler for all three trigger TBN_Account,Tbn_User,Tbn_Contact which
            updates geolocation field
**/


/**
@Developer Name                         :  V Kumar
Percentage of best practices followed   :  100%
No of SOQL queries used                 :  1
No of collections used                  :  1
Exception Handling implemented          :  Yes
Coding standards followed               :  Yes
Naming conventions followed             :  Yes
Third party integrations                :  No
Maximum of No of records tested with    :  
Customer Approval                       :  
Last Modified Date                      :  9/Jan/2013
Approved by                             :  

*/
public with sharing class LOC_TBN_CalCulateLatLangHandler 
{
  /*Start - Variable Declaration*/
    
    private static double dblLongitude  = null;  
    private static double dblLatitude  = null;
    private static string strObjectType = '';
    private static set<Id> setAccIds = new set<Id>();
    private static map<Account,string> mapAccountToAddress = new map<Account,string>();
    private static map<Contact,string> mapContactToAddress = new map<Contact,string>();
    private static map<User,string> mapUserToAddress = new map<User,string>();
    /*End - Variable Declaration*/
    
    /*Start - Contructor*/
    public LOC_TBN_CalCulateLatLangHandler()
    {
    } 
    /*End - Contructor*/
    
    /**** Start : Before Update methods which sets lattitude and longitude as Null if Address is null****/
    public  void onBeforeUpdateInsert(list<Contact> listContacts)
    {
      for(Contact objContact : listContacts)
    {
      if( (objContact.MailingStreet == null || objContact.MailingStreet == '' ) && (objContact.MailingCity == null || objContact.MailingCity == '' ) && (objContact.MailingState == null || objContact.MailingState == '' ) && (objContact.MailingPostalCode == null ||  objContact.MailingPostalCode == '' ) && (objContact.MailingCountry == null || objContact.MailingCountry == '' ) )
      {
        objContact.LOC_Latitude_x__c = null;
              objContact.LOC_Longitude_x__c = null;
      }
    }
    }
    public  void onBeforeUpdateInsert(list<User> listUsers)
    {
      for(User objUser : listUsers)
    {
      if( (objUser.Street == null || objUser.Street == '' ) && (objUser.City == null || objUser.City == '' ) && (objUser.State == null || objUser.State == '' ) && (objUser.PostalCode == null ||  objUser.PostalCode == '' ) && (objUser.Country == null || objUser.Country == '' ) )
      {
        objUser.LOC_Latitude__c = null;
              objUser.LOC_Longitude__c = null;
      }
    }
    }
  public void onBeforeInsertAndUpdate(list<Account> lstAccount)
    {
    
    for(Account objAccount : lstAccount)
    {
      if( (objAccount.ShippingStreet == null || objAccount.ShippingStreet == '' ) && (objAccount.ShippingCity == null || objAccount.ShippingCity == '' ) && (objAccount.ShippingState == null || objAccount.ShippingState == '' ) && (objAccount.ShippingPostalCode == null ||  objAccount.ShippingPostalCode == '' ) && (objAccount.ShippingCountry == null || objAccount.ShippingCountry == '' ) )
      {
        objAccount.LOC_Latitude_x__c = null;
              objAccount.LOC_Longitude_x__c = null;
      }
    }
    }
  /**** End : Before Update methods which sets lattitude and longitude as Null if Address is null****/
  
    /**** Start :  setIdsToUpdate methods  First stores Ids of records  to be updated into a set and then updates it ****/  
  public  void setIdsToUpdate(map<Id,Contact> mapNewIdToContact , map<Id,Contact> mapOldIdToContact)
  {
    
    set<Id> setContactIds = new set<Id>();
       // call on after Insert of an Account record
    for(Contact objContact : mapNewIdToContact.values())
    {
      
      Contact oldContact = mapOldIdToContact != null ? mapOldIdToContact.get(objContact.Id) : null;
      if(oldContact != null && ( (objContact.MailingStreet != null &&  objContact.MailingStreet != '')  || (objContact.MailingCity != null && objContact.MailingCity != '' ) || (objContact.MailingState != null && objContact.MailingState != '') || (objContact.MailingPostalCode != null && objContact.MailingPostalCode != '') || (objContact.MailingCountry != '' && objContact.MailingCountry != null)) && (objContact.MailingStreet != oldContact.MailingStreet || objContact.MailingCity != oldContact.MailingCity || objContact.MailingState != oldContact.MailingState || objContact.MailingPostalCode != oldContact.MailingPostalCode || objContact.MailingCountry != oldContact.MailingCountry) )
      {
        setContactIds.add(objContact.Id);
      }
      else if(oldContact == null && ( objContact.MailingStreet != null || objContact.MailingCity != null || objContact.MailingState != null || objContact.MailingPostalCode != null || objContact.MailingCountry != null ))
      {
        setContactIds.add(objContact.Id);
      }
    }
    if(setContactIds.size() > 0 && setContactIds.size() <=  10)
        getLocation(setContactIds,'Contact');
  }
  
  public  pageReference setAccountIdsToUpdate(map<Id,Account> mapNewIdToAccount , map<Id,Account> mapOldIdToAccount)
  {
    
    set<Id> setAccountIds = new set<Id>();
       
       // call on after Insert of an Account record
    for(Account objAccount : mapNewIdToAccount.values())
    {
      Account oldAccount = mapOldIdToAccount != null ? mapOldIdToAccount.get(objAccount.Id) : null;
      if(oldAccount != null && ( (objAccount.ShippingStreet != null &&  objAccount.ShippingStreet != '')  || (objAccount.ShippingCity != null && objAccount.ShippingCity != '' ) || (objAccount.ShippingState != null && objAccount.ShippingState != '') || (objAccount.ShippingPostalCode != null && objAccount.ShippingPostalCode != '') || (objAccount.ShippingCountry != '' && objAccount.ShippingCountry != null)) && (objAccount.ShippingStreet != oldAccount.ShippingStreet || objAccount.ShippingCity != oldAccount.ShippingCity || objAccount.ShippingState != oldAccount.ShippingState || objAccount.ShippingPostalCode != oldAccount.ShippingPostalCode || objAccount.ShippingCountry != oldAccount.ShippingCountry) )
      {
        setAccountIds.add(objAccount.Id);
      }
      else if(oldAccount == null && ( (objAccount.ShippingStreet != null &&  objAccount.ShippingStreet != '')  || (objAccount.ShippingCity != null && objAccount.ShippingCity != '' ) || (objAccount.ShippingState != null && objAccount.ShippingState != '') || (objAccount.ShippingPostalCode != null && objAccount.ShippingPostalCode != '') || (objAccount.ShippingCountry != '' && objAccount.ShippingCountry != null)) )
      {
        setAccountIds.add(objAccount.Id);
      }
      
    }
    
    if(setAccountIds.size() > 0 && setAccountIds.size() <=  10 )
        getLocation(setAccountIds,'Account'); 
    return null;  
  }       
    public  void setUsersIdsToUpdate(map<Id,User> mapNewIdToUser , map<Id,User> mapOldIdToUser)
  {
    set<Id> setUserIds = new set<Id>();
       // call on after Insert of an User record
    for(User objUser : mapNewIdToUser.values())
    {
      
      User oldUser = mapOldIdToUser != null ? mapOldIdToUser.get(objUser.Id) : null;
      if(oldUser != null && ( (objUser.Street != null &&  objUser.Street != '')  || (objUser.City != null && objUser.City != '' ) || (objUser.State != null && objUser.State != '') || (objUser.PostalCode != null && objUser.PostalCode != '') || (objUser.Country != '' && objUser.Country != null)) && (objUser.Street != oldUser.Street || objUser.City != oldUser.City || objUser.State != oldUser.State || objUser.PostalCode != oldUser.PostalCode || objUser.Country != oldUser.Country) )
      {
        setUserIds.add(objUser.Id);
      }
      else if(oldUser == null && ( (objUser.Street != null &&  objUser.Street != '')  || (objUser.City != null && objUser.City != '' ) || (objUser.State != null && objUser.State != '') || (objUser.PostalCode != null && objUser.PostalCode != '') || (objUser.Country != '' && objUser.Country != null)) )
      {
        setUserIds.add(objUser.Id);
      }
    }
    if(setUserIds.size() > 0 && setUserIds.size() <=  10)
        getLocation(setUserIds,'User');  
  }       
  /**** End :  setIdsToUpdate methods  First stores Ids of records  to be updated into a set and then updates it ****/  
    
    
    /* Start - Method to returns the address */
    public static void prepareAddressToBeLocated()
    {
       // For selected object type is User
       if(strObjectType == 'User')
       {
            for(User objUser : [ Select LOC_Longitude__c,LOC_Latitude__c, Street, State, PostalCode, Country, City 
                  From User u 
                  WHERE id In: setAccIds ])
            {
              String strAddressToLocate = '';
              if (objUser.Street != null && objUser.Street != '')
                  strAddressToLocate += objUser.Street +',';
              if (objUser.City != null && objUser.City != '')
                  strAddressToLocate += objUser.City +',';
              if (objUser.State != null && objUser.State != '')
                  strAddressToLocate += objUser.State +',';
              if (objUser.PostalCode != null && objUser.PostalCode != '')
                  strAddressToLocate += objUser.PostalCode +',';
              if (objUser.Country != null && objUser.Country != '')
                  strAddressToLocate += objUser.Country;
        mapUserToAddress.put(objUser,strAddressToLocate);
            }
        }
        
        // For selected object type is Contact
        else if(strObjectType == 'Contact')
        {
            list<Contact> lstContact = [SELECT MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity FROM Contact WHERE id In: setAccIds];
       
       for(Contact objContact : lstContact)
       {  
              String strAddressToLocate = '';
              // create an address string
              if (objContact.MailingStreet != null && objContact.MailingStreet != '')
                  strAddressToLocate += objContact.MailingStreet +',';
              if (objContact.MailingCity != null  && objContact.MailingCity != '')
                  strAddressToLocate += objContact.MailingCity +',';
              if (objContact.MailingState != null  && objContact.MailingState != '')
                  strAddressToLocate += objContact.MailingState +',';
              if (objContact.MailingPostalCode != null  && objContact.MailingPostalCode != '')
                  strAddressToLocate += objContact.MailingPostalCode +',';
              if (objContact.MailingCountry != null  && objContact.MailingCountry != '')
                  strAddressToLocate += objContact.MailingCountry;
        mapContactToAddress.put(objContact,strAddressToLocate);
       }
        }
        
        // For selected object type is Account
        if(strObjectType == 'Account')
        {
          list<Account>  lstAccount = [ Select LOC_Longitude_x__c,LOC_Latitude_x__c,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
                     From Account 
                     WHERE id In: setAccIds ];
            for(Account objAccount : lstAccount)
            {
              String strAddressToLocate = '';
              
              if (objAccount.ShippingStreet != null && objAccount.ShippingStreet != '')
                  strAddressToLocate += objAccount.ShippingStreet +',';
              if (objAccount.ShippingCity != null && objAccount.ShippingCity != '')
                  strAddressToLocate += objAccount.ShippingCity +',';
              if (objAccount.ShippingState != null && objAccount.ShippingState != '')
                  strAddressToLocate += objAccount.ShippingState +',';
              if (objAccount.ShippingPostalCode != null && objAccount.ShippingPostalCode != '')
                  strAddressToLocate += objAccount.ShippingPostalCode +',';
              if (objAccount.ShippingCountry != null && objAccount.ShippingCountry != '')
                  strAddressToLocate += objAccount.ShippingCountry;
        mapAccountToAddress.put(objAccount,strAddressToLocate);
            }
        }
    }
    /* End - Method to returns the address */
    
    /* Start - Method to Fetch address from google map */
    public  static String fetchLocationFromGoogleMaps(String strAddressToLocate)
    {
        try
        {
          // Do a http call to fetch location from goolge map
            Http objHTTP = new Http();
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + strAddressToLocate + '&sensor=false');
            req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + strAddressToLocate + '&sensor=true&key=AIzaSyDOMMdKIyGTXPdEYXzGNjkpvuII0uFEzag');
            //req.setEndpoint('https://maps.googleapis.com/maps/api/js?address=' + strAddressToLocate + '&sensor=true&key=AIzaSyDOMMdKIyGTXPdEYXzGNjkpvuII0uFEzag');
            //         https://maps.googleapis.com/maps/api/js?sensor=false&key=
            req.setMethod('GET');
            req.setTimeout(120000);
            HttpResponse res;
            if(!Test.isRunningTest())
            res = objHTTP.send(req);
            // Returns the response result
            if(res != null && res.getBody() != null){
              return res.getBody();
              //return res.toString();
            }
                
            else 
                return null;
        }
        catch(Exception objException)
        {
            return null;
        }
    }
    /* End - Method to Fetch address from google map */
    
    /* Start - Method to Parse the response received from Google map */
    public static  void parseLocationResponseFromGoogleMaps(String strResponse)
    {
      // Parse response received from the endpoint
        JSONParser parser = JSON.createParser(strResponse); 
        while (parser.nextToken() != null) 
        {
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'location'))
            {
                parser.nextToken(); 
                while (parser.nextToken() != JSONToken.END_OBJECT)
                {
                    String txt = parser.getText();
                    parser.nextToken();
                    // Set the latitude value
                    if (txt == 'lat')
                        dblLatitude = parser.getDoubleValue();
                    // Set the longitude value
                    else if (txt == 'lng')  
                        dblLongitude = parser.getDoubleValue();
                } 
                
            }
        } 
    }
    /* End - Method to Parse the response received from Google map */
    
    /* Start - Action method. It parse the address and updates the geolocation field accordingly */
  @future (callout=true)
    static public void getLocation(set<Id> setIds,string strObjType)
    {
      list<Account> lstAccountsToUpdate = new list<Account>();
      list<Contact> lstContactsToUpdate = new list<Contact>();
      list<User> lstUsersToUpdate = new list<User>();
      setAccIds = new set<Id>();
      setAccIds.addAll(setIds);
      strObjectType = strObjType;
      try
      {
          // Call to method that returns the address value    
          prepareAddressToBeLocated();
          for(Account objAccount :mapAccountToAddress.keyset())
          {
            
            String strAddressToLocate = mapAccountToAddress.get(objAccount);
        dblLongitude = null;  
        dblLatitude = null;
            if(strAddressToLocate != null && strAddressToLocate != '')
            {
                strAddressToLocate = EncodingUtil.urlEncode(strAddressToLocate, 'UTF-8');
                    
                String strResponse = fetchLocationFromGoogleMaps(strAddressToLocate);
                
                if(Test.isRunningTest())
                {
                    strResponse = '{"results" : [{' +
                                    '"location" : {' +
                                    ' "lat" : 15.31727750,' +
                                    '"lng" : 75.71388840' +
                                    ' }}]}' ;
                }
                if(strResponse != null && strResponse != '')
                    parseLocationResponseFromGoogleMaps(strResponse);
                 
                if(dblLatitude != null && dblLongitude != null)
                {
                      objAccount.LOC_Latitude_x__c = dblLatitude;
                      objAccount.LOC_Longitude_x__c = dblLongitude;
                      lstAccountsToUpdate.add(objAccount);
                }
            }
          }
          for(Contact objContact :mapContactToAddress.keyset())
          {
            
            string  strAddressToLocate = mapContactToAddress.get(objContact);
        dblLongitude = null;  
        dblLatitude = null;
            if(strAddressToLocate != null && strAddressToLocate != '')
            {
                strAddressToLocate = EncodingUtil.urlEncode(strAddressToLocate, 'UTF-8');
                String strResponse = fetchLocationFromGoogleMaps(strAddressToLocate);
                
                                
                if(Test.isRunningTest())
                {
                    strResponse = '{"results" : [{' +
                                    '"location" : {' +
                                    ' "lat" : 15.31727750,' +
                                    '"lng" : 75.71388840' +
                                    ' }}]}' ;
                }
                if(strResponse != null && strResponse != '')
                    parseLocationResponseFromGoogleMaps(strResponse);
                 
                if(dblLatitude != null && dblLongitude != null)
                {
                      objContact.LOC_Latitude_x__c = dblLatitude;
                      objContact.LOC_Longitude_x__c = dblLongitude;
                      lstContactsToUpdate.add(objContact);
                }
            }
          }
          for(User objUser :mapUserToAddress.keyset())
          {
            
           string strAddressToLocate = mapUserToAddress.get(objUser);
        dblLongitude = null;  
        dblLatitude = null;
            if(strAddressToLocate != null && strAddressToLocate != '')
            {
                strAddressToLocate = EncodingUtil.urlEncode(strAddressToLocate, 'UTF-8');
                    
                String strResponse = fetchLocationFromGoogleMaps(strAddressToLocate);
                                
                if(Test.isRunningTest())
                {
                    strResponse = '{"results" : [{' +
                                    '"location" : {' +
                                    ' "lat" : 15.31727750,' +
                                    '"lng" : 75.71388840' +
                                    ' }}]}' ;
                }
                if(strResponse != null && strResponse != '')
                    parseLocationResponseFromGoogleMaps(strResponse);
                 
                if(dblLatitude != null && dblLongitude != null)
                {
                      objUser.LOC_Latitude__c = dblLatitude;
                      objUser.LOC_Longitude__c = dblLongitude;
                      lstUsersToUpdate.add(objUser);
                }
            }
          }
      if(lstAccountsToUpdate != null && !lstAccountsToUpdate.isEmpty()) 
      
             Database.Saveresult[] updateResultAcc = Database.update(lstAccountsToUpdate);
           if(lstContactsToUpdate != null && !lstContactsToUpdate.isEmpty()) 
             Database.Saveresult[] updateResultCon = Database.update(lstContactsToUpdate);
           if(lstUsersToUpdate != null && !lstUsersToUpdate.isEmpty()) 
             Database.Saveresult[] updateResultUsers = Database.update(lstUsersToUpdate);
             
      }
      catch(exception e)
      {
        system.debug('------- Exception -----'+e.getMessage()+'==@line number=='+e.getLineNumber());
      }
       
    } 
    /* End - Action method. It parse the address and updates the geolocation field accordingly */
    
    
    @isTest()
    static void Test_LOC_TBN_CalCulateLatLangHandler()
    {
        test.startTest();
        
        Account objAccount = new Account();
        objAccount.Name = 'Test objAccount 1';
        objAccount.ShippingState = 'TestState';
        objAccount.ShippingCity = 'TestCity';
        objAccount.ShippingStreet ='TestStreet';
        objAccount.ShippingPostalCode ='340901';
        objAccount.ShippingCountry = 'testCountry';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Test Contact 1';
        objContact.MailingState = 'TestState';
        objContact.MailingCity = 'TestCity';
        objContact.MailingStreet ='TestStreet';
        objContact.MailingPostalCode ='340901';
        objContact.MailingCountry = 'testCountry';
        objContact.Phone = '999999989';
        insert objContact;         

        
        Profile objProfile = [select id from profile limit 1]; 
        User objUser = new User(alias = 'stf', email='stf@test.com', emailencodingkey='UTF-8', lastname='Testingefsfs', languagelocalekey='en_US',
                        localesidkey='en_US',timezonesidkey='America/Los_Angeles',profileid = objProfile.Id,username='stf@test.com');
        objUser.State = 'TestState';
        objUser.City = 'TestCity'; 
        objUser.Street ='TestStreet';
        objUser.PostalCode ='340901';
        objUser.Country = 'testCountry';
        insert objUser;
        
        Account objAccount1 = new Account();
        objAccount1.Name = 'Test objAccount 1';        
        insert objAccount1;
        
        Contact objContact1 = new Contact();
        objContact1.LastName = 'Test Contact 2'; 
        objContact.Phone = '999999989';    
        insert objContact1;         

        
        Profile objProfile1 = [select id from profile limit 1]; 
        User objUser1 = new User(alias = 'stf1', email='stf1@test.com', emailencodingkey='UTF-8', lastname='Testingefsfs1', languagelocalekey='en_US',
                        localesidkey='en_US',timezonesidkey='America/Los_Angeles',profileid = objProfile1.Id,username='stf1@test.com');        
        insert objUser1;        
       
        
        test.stopTest();
    }
}