public with sharing class LOC_TBN_UpdateContactGeolocationInline {

  public string strRecId {get;set;}
  public Contact objContact;
  public string strAddress{get;set;}
    
  public LOC_TBN_UpdateContactGeolocationInline(ApexPages.StandardController ctlr)
  {
    strRecId = ApexPages.currentPage().getParameters().get('id');
    objContact = new Contact();
    strAddress ='';
    objContact = [SELECT MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity 
      FROM Contact WHERE id =: strRecId and LOC_Latitude_x__c = null and LOC_Longitude_x__c = null];
    if(objContact != null)
    {
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
  }
  /*@isTest()
  static void Test_TBN_UpdateContactGeolocationInline()
  {
    test.startTest();
    Contact objContact = new Contact();
        objContact.LastName = 'Test Contact 1';
        objContact.MailingState = 'TestState';
        objContact.MailingCity = 'TestCity';
        objContact.MailingStreet ='TestStreet';
        objContact.MailingPostalCode ='340901';
        objContact.MailingCountry = 'testCountry';
        insert objContact;
        
    
    ApexPages.currentPage().getParameters().put('id',objContact.Id);
        Apexpages.Standardcontroller ctrl1 = new Apexpages.Standardcontroller(objContact);
    LOC_TBN_UpdateContactGeolocationInline objMap = new LOC_TBN_UpdateContactGeolocationInline(ctrl1); 
    
    test.stopTest();
  }*/
}