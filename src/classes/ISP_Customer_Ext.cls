public with sharing class ISP_Customer_Ext {

    public Contact contact{get;set;}
    public ISP_Customer_Ext(ApexPages.StandardController controller) {
       User u   = [select city,state,country from user where id=: userinfo.getUserId()];
       
       contact  = new Contact();
       contact  =  (Contact)controller.getRecord();
       contact.recordTypeId   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('ISP Customer').getRecordTypeId();
       contact.mailingcity    = u.city;
       contact.mailingState   = u.state;
       contact.mailingCountry = u.country;
    }  
    
    
    public PageReference Save(){
         PageReference pr;
        try{
            upsert contact;
            //pr = new PageReference('/contact.id');
            pr = new ApexPages.StandardController(contact).view();
        }Catch(Exception e){
            Apexpages.addMessage(new Apexpages.message(Apexpages.severity.ERROR,e.getMessage()));
        }
        
        return pr;
    }

}