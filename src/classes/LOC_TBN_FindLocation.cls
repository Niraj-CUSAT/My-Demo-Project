/***** The Controller for the Page "TBN_FindLocation"*****/
/***
@Developer Name : V Kumar
Percentage of best practices followed : 100%
No of SOQL queries used : 2
No of collections used : 0
Exception Handling implemented : Yes 
Coding standards followed : Yes
Naming conventions followed : Yes
Third party integrations :
Maximum of No of records tested with : 
Customer Approval : 
Last Modified Date: 6-12-12
Approved by:

@Major Change 1
JIRA Link:Virsygen-12
Short desc:
Impacted methods/areas:
Result:
Changed By:
Approved By:


**********/
public with sharing class LOC_TBN_FindLocation 
{
   public string strRecId {get;set;}
  public Contact objContact ;
  public User objUser;
  public Account objAccount;
  public String strType {get;set;}
  public string strAddress{get;set;} 
    
  public LOC_TBN_FindLocation ()
  {
    strRecId = ApexPages.currentPage().getParameters().get('id');
    strType = ApexPages.currentPage().getParameters().get('Object'); 
    objContact = new Contact();
    objUser = new User();
    objAccount = new Account();
    strAddress ='';
    if(strType == 'Contact')
    {
      objContact = [SELECT MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity 
      FROM Contact WHERE id =: strRecId];
      // create an address string
            if (objContact.MailingStreet != null && objContact.MailingStreet != '')
                strAddress += objContact.MailingStreet +', ';
            if (objContact.MailingCity != null  && objContact.MailingCity != '')
                strAddress += objContact.MailingCity +', ';
            if (objContact.MailingState != null  && objContact.MailingState != '')
                strAddress += objContact.MailingState +' ';
            if (objContact.MailingPostalCode != null  && objContact.MailingPostalCode != '')
                strAddress += objContact.MailingPostalCode +', ';
            if (objContact.MailingCountry != null  && objContact.MailingCountry != '')
                strAddress += objContact.MailingCountry;
        
    }
 
    if(strType == 'Account')
    {
      objAccount = [ Select LOC_Longitude_x__c,LOC_Latitude_x__c,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
                     From Account 
                     WHERE id =: strRecId ];
            if (objAccount.ShippingStreet != null && objAccount.ShippingStreet != '')
                  strAddress += objAccount.ShippingStreet +',';
            if (objAccount.ShippingCity != null && objAccount.ShippingCity != '')
                strAddress += objAccount.ShippingCity +',';
            if (objAccount.ShippingState != null && objAccount.ShippingState != '')
                strAddress += objAccount.ShippingState +',';
            if (objAccount.ShippingPostalCode != null && objAccount.ShippingPostalCode != '')
                strAddress += objAccount.ShippingPostalCode +',';
            if (objAccount.ShippingCountry != null && objAccount.ShippingCountry != '')
                strAddress += objAccount.ShippingCountry;
           system.debug('######################## strAddress'+strAddress);           
    }
    if(strType == 'User')
    {
       objUser = [Select Street, State,PostalCode,Country, City 
             From User  
             WHERE id =: strRecId];
      if (objUser.Street != null && objUser.Street != '')
                strAddress += objUser.Street +', ';
            if (objUser.City != null && objUser.City != '')
                strAddress += objUser.City +', ';
            if (objUser.State != null && objUser.State != '')
                strAddress += objUser.State +' ';
            if (objUser.PostalCode != null && objUser.PostalCode != '')
                strAddress += objUser.PostalCode +', ';
            if (objUser.Country != null && objUser.Country != '')
                strAddress += objUser.Country;
    }
  } 
  public pageReference returnToDetailPage()
  {
     
     string strRedirect = '';
     if(strType == 'User' )
        strRedirect ='?noredirect=1';
          Pagereference pr = new Pagereference('/'+strRecId+strRedirect);
          pr.setRedirect(true);
          return pr;
  }
  @isTest()
    static void Test_TBN_FindLocation()
    {
        test.startTest();
        
        Contact objContact = new Contact();
        objContact.LastName = 'Test Contact 1';
        objContact.MailingState = 'TestState';
        objContact.MailingCity = 'TestCity';
        objContact.MailingStreet ='TestStreet';
        objContact.MailingPostalCode ='340901';
        objContact.MailingCountry = 'testCountry';
        objContact.Phone = '999999989';
        insert objContact;
        
        ApexPages.currentPage().getParameters().put('Object','contact');
        ApexPages.currentPage().getParameters().put('id',objContact.Id);
        LOC_TBN_FindLocation objFL = new LOC_TBN_FindLocation(); 
        objFL.returnToDetailPage();
        
        
        Profile objProfile = [select id from profile limit 1]; 
        User objUser = new User(alias = 'stf', email='stf@test.com', emailencodingkey='UTF-8', lastname='Testingefsfs', languagelocalekey='en_US',
                        localesidkey='en_US',timezonesidkey='America/Los_Angeles',profileid = objProfile.Id,username='stf@test.com');
        
        objUser.State = 'TestState';
        objUser.City = 'TestCity';
        objUser.Street ='TestStreet';
        objUser.PostalCode ='340901';
        objUser.Country = 'testCountry';
        insert objUser;
        
            
        ApexPages.currentPage().getParameters().put('Object','user');
        ApexPages.currentPage().getParameters().put('id',objUser.Id);
        LOC_TBN_FindLocation objFL1 = new LOC_TBN_FindLocation(); 
        objFL1.returnToDetailPage();
        
        Account objAccount = new Account();
    objAccount.Name = 'Test Account 1';
    objAccount.ShippingState = 'test';
    objAccount.ShippingCountry = 'test';
    objAccount.ShippingStreet ='test' ;
    objAccount.ShippingCity = 'test';
    objAccount.ShippingPostalCode = '678678';
    objAccount.Type = 'Test';
    insert objAccount;
        
        
        
        ApexPages.currentPage().getParameters().put('Object','Account');
        ApexPages.currentPage().getParameters().put('id',objAccount.Id);
        LOC_TBN_FindLocation objFL2 = new LOC_TBN_FindLocation(); 
        objFL2.returnToDetailPage();
        test.stopTest();
    }  
}