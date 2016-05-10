@isTest()
  private class Test_TBN_UpdateContactGeolocationInline
  {
    static testmethod void startTest()
     {
    Contact objContact = new Contact();
        objContact.LastName = 'Test Contact 1';
        objContact.MailingState = 'TestState';
        objContact.MailingCity = 'TestCity';
        objContact.MailingStreet ='TestStreet';
        objContact.MailingPostalCode ='340901';
        objContact.MailingCountry = 'testCountry';
        objContact.Phone = '999999989';
        insert objContact;
        
    
    ApexPages.currentPage().getParameters().put('id',objContact.Id);
        Apexpages.Standardcontroller ctrl1 = new Apexpages.Standardcontroller(objContact);
    LOC_TBN_UpdateContactGeolocationInline objMap = new LOC_TBN_UpdateContactGeolocationInline(ctrl1); 
    
   
  }
}