public with sharing class DemoController {
    public List<Account> accList{get;set;}
    public List<Contact> conList{get;set;}
    public DemoController(){
        accList = new List<Account>();
        accList = [SELECT ID, Name, ShippingStreet, ShippingCity, ShippingPostalCode, ShippingState FROM Account WHERE ShippingPostalCode != null];
        conList= new List<Contact>();
        conList= [SELECT Id,Name,MailingAddress,MailingCity,MailingCountry,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStreet FROM Contact WHERE AccountId = '001e000000dEb6z'];
    }
      
}