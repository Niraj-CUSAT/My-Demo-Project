/***** The Controller for the Page "TBN_MapReps"*****/
/***
@Developer Name : V Kumar
Percentage of best practices followed : 100%
No of SOQL queries used : 3
No of collections used : 2
Exception Handling implemented : Yes 
Coding standards followed : Yes
Naming conventions followed : Yes
Third party integrations :
Maximum of No of records tested with : 
Customer Approval : 
Last Modified Date: 12-12-12
Approved by:
 
@Major Change 1
JIRA Link:https://trekbin.jira.com/browse/VIRSYGEN-15
Short desc:
Impacted methods/areas:
Result:
Changed By:
Approved By:
**********/
public with sharing class LOC_TBN_MapAccounts 
{
  public string googleMapStr {get;set;}
  public list<SelectOption> lstFilterTimeOptions {get;set;}
  public  list<SelectOption> lstZipCodeOptions {get;set;}
  public string selectedTimeRange {get;set;}
  public string selectedZipCode {get;set;} 
  public boolean hasRecords{get;set;}
  public string productName {get;set;}
  public string recId {get;set;}
  
  public LOC_TBN_MapAccounts()
  {
    system.debug('################## LOC_TBN_MapAccounts');
    googleMapStr='https://maps.googleapis.com/maps/api/js?v=3&sensor=false';
    recId = ApexPages.currentPage().getParameters().get('recId');
    
    Date sixMonths = Date.today().addMonths(-5).toStartOfMonth();
    Date lastYear = Date.today().addMonths(-11).toStartOfMonth();
    hasRecords = true ;
    lstFilterTimeOptions = new List<SelectOption> ();
    lstFilterTimeOptions.add(new SelectOption('All Time','All Time'));
    lstFilterTimeOptions.add(new SelectOption('Last Year','Last Year'));
    lstFilterTimeOptions.add(new SelectOption('Last Six Months','Last Six Months'));
    
    if(recId != null && recId != '')
      {
        selectedTimeRange = 'All Time';
        zipCodes();
      }
      else
      {
        hasRecords = false;
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid ID in URL'));
      }
  }
  //Returns list of select options for Zip Codes 
  public void zipCodes()
  {
    Date sixMonths = Date.today().addMonths(-5).toStartOfMonth();
    Date lastYear = Date.today().addMonths(-11).toStartOfMonth();
    lstZipCodeOptions = new list<SelectOption> ();
    lstZipCodeOptions.add(new selectOption('--All--','--All--'));
    selectedZipCode = '--All--';
    string strQuery = 'select Product2ID,Product2.Name ,Id,AccountId,Account.ShippingPostalCode,Account.Name,Account.LOC_Latitude_x__c, Account.LOC_Longitude_x__c  from Asset where Product2ID =: recId and Account.LOC_Latitude_x__c != null and Account.LOC_Longitude_x__c != null ';
    
    if(selectedTimeRange == 'Last Six Months' )
      strQuery += ' and LOC_Shipped_Date__c > : sixMonths ';
    else if(selectedTimeRange == 'Last Year')
      strQuery += ' and LOC_Shipped_Date__c > : lastYear ';
    strQuery += ' limit 999 ';
      
    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@ strQuery'+strQuery);  
    list<Asset> lstAsset = Database.query(strQuery);
    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@ lstAsset'+lstAsset);  
    set<Id> setAccId = new set<Id>();
    
    if(lstAsset != null && lstAsset.size() > 0)
    {
      for(Asset objAsset : lstAsset)
      {
        productName = objAsset.Product2.Name;
        if(!setAccId.contains(objAsset.Account.Id))
        {  
          setAccId.add(objAsset.Account.Id);
          if(objAsset.Account.ShippingPostalCode != null && objAsset.Account.ShippingPostalCode != '')
            lstZipCodeOptions.add(new selectOption(objAsset.Account.ShippingPostalCode,objAsset.Account.ShippingPostalCode));
        }
      }
    }
    
  }
  //This remote method returns list of wrappper class
  @RemoteAction
    public static list<accLatLangWrapper> getAccountLocations(String recordId,string dt ,string zipCode)
    {
      list<accLatLangWrapper> lstWrapper =  new list<accLatLangWrapper>();
      try
      {
        Date sixMonths = Date.today().addMonths(-5).toStartOfMonth();
      Date lastYear = Date.today().addMonths(-11).toStartOfMonth();
      //The below query is based on BillingAddress
      //string strQuery = 'select Id,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingCountry,AccountId,Account.BillingPostalCode,Account.Name,Account.Latitude_x__c, Account.Longitude_x__c  from Asset where Product2ID =: recordId and Account.Latitude_x__c != null and Account.Longitude_x__c != null ';
      //As per the task- VIRSYGEN-18, requested to change BillingAddress to ShippingAddress
      string strQuery = 'select Id,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,AccountId,Account.ShippingPostalCode,Account.Name,Account.LOC_Latitude_x__c, Account.LOC_Longitude_x__c  from Asset where Product2ID =: recordId and Account.LOC_Latitude_x__c != null and Account.LOC_Longitude_x__c != null ';
      if(dt == 'Last Six Months')
        strQuery += ' and LOC_Shipped_Date__c > : sixMonths';
      else if(dt == 'Last Year')
        strQuery += 'and LOC_Shipped_Date__c > : lastYear';
      if(zipCode != '' && zipCode != null && zipCode != '--All--' )
        strQuery += ' and Account.ShippingPostalCode = : zipCode';
      strQuery += ' limit 999 ';
      
      list<Asset> lstAsset = Database.query(strQuery);
      system.debug('!!!!!!!!!!!!!!!!!!! remote method lstAsset'+lstAsset);
        for(Asset objAsset : lstAsset)
      {
        accLatLangWrapper obj = new accLatLangWrapper();
        obj.objName = objAsset.Account.Name;
        obj.lat = objAsset.Account.LOC_Latitude_x__c;
        obj.longt = objAsset.Account.LOC_Longitude_x__c;
        obj.objAccId = objAsset.Account.Id;
        string strAddress = '';
            // creating an address string
              if (objAsset.Account.ShippingStreet != null && objAsset.Account.ShippingStreet != '')
                  strAddress += objAsset.Account.ShippingStreet +',';
              if (objAsset.Account.ShippingCity != null  && objAsset.Account.ShippingCity != '')
                  strAddress += objAsset.Account.ShippingCity +',';
              if (objAsset.Account.ShippingState != null  && objAsset.Account.ShippingState != '')
                  strAddress += objAsset.Account.ShippingState +',';
              if (objAsset.Account.ShippingPostalCode != null  && objAsset.Account.ShippingPostalCode != '')
                  strAddress += objAsset.Account.ShippingPostalCode +',';
              if (objAsset.Account.ShippingCountry != null  && objAsset.Account.ShippingCountry != '')
                  strAddress += objAsset.Account.ShippingCountry +',';
             
              if( strAddress.length() > 1 ) 
              {
                strAddress =  String.escapeSingleQuotes(strAddress);
                strAddress = strAddress.substring(0, strAddress.length()-1);
              }  
              
              system.debug('################# strAddress'+ strAddress);
        obj.address =  strAddress;
        lstWrapper.add(obj);
      }
      
      return lstWrapper;
      }
      catch(Exception e)
      {
        system.debug('Exception============'+e.getMessage());
        return null;
      }
       return null;
    }
    //Method called when clicking on "back" link
    public pageReference goBackToRecord()
    {
      pagereference pr = new pagereference('/'+recId);
    return pr ;
    }
    //Wrapper class to bind Account Name, Lattitude , longitude and address
  public class accLatLangWrapper   
    {
         public Id objAccId {get;set;}
         public String objName{get;set;}
         public Decimal lat {get;set;}
         public Decimal longt {get;set;}
         public string address{get;set;}
    } 
    
    @isTest()
  static void Test_TBN_MapAccounts()
  {
    test.startTest();
    
    Product2 objProduct = new Product2();
        objProduct.Name = 'testProduct1';
        insert objProduct;
    Account objAcc = new Account();
    objAcc.Name = 'Test Account 1';
    objAcc.ShippingState = 'Test';
    objAcc.ShippingPostalCode = '474676';
    objAcc.ShippingCountry = 'India';
    objAcc.Type = 'Test';
    objAcc.LOC_Latitude_x__c = 12.9833;
    objAcc.LOC_Longitude_x__c = 77.5833;
    insert objAcc;
    
    Asset objAsset = new Asset();
      objAsset.Name = '12345678';
      objAsset.AccountId = objAcc.Id;
      objAsset.Product2Id = objProduct.Id;
      objAsset.SerialNumber = objAsset.Id; 
      objAsset.LOC_Shipped_Date__c = Date.today(); 
      insert objAsset;
      
    list<Account> lstAccount = new list<Account>(); 
    lstAccount.add(objAcc);
    
    ApexPages.currentPage().getParameters().put('recId',objProduct.Id);
    LOC_TBN_MapAccounts objMap = new LOC_TBN_MapAccounts(); 
    LOC_TBN_MapAccounts.getAccountLocations(objProduct.Id,'Last Year','--All--');
    objMap.selectedTimeRange = 'Last Six Months';
    objMap.zipCodes();
    objMap.selectedTimeRange = 'Last Year';
    objMap.zipCodes();
    objMap.goBackToRecord(); 
    
    ApexPages.currentPage().getParameters().put('recId','');
    LOC_TBN_MapAccounts objMap2 = new LOC_TBN_MapAccounts(); 
    
    
    test.stopTest();
  }
}