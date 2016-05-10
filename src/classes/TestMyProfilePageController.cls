/**

Created By : Bhupesh
Date : 23.4.2015

 */
@isTest
private class TestMyProfilePageController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        
        List<User> lstUser = [SELECT id, IsActive, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                              street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                              FROM User where IsActive = true AND Id =: userInfo.getUserId()];
                              
        system.runAs(lstUser[0]){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Pin_Master__c pin = new Pin_Master__c();
        pin.AOSI_Region__c = 'South';
        pin.AOSI_State__c = 'Andra Pradesh';
        pin.AOSI_City__c = 'Hyderabad';               
        pin.Name = '560089';
        pin.AOSI_Type__c = 'City';
        insert pin;
        
        ID recordTypeId = [Select id,name,DeveloperName,SobjectType from RecordType where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
        
        Contact c = new Contact();
        c.Lastname = 'Test2';
        c.RecordTypeId = recordTypeId;
        c.accountid = acc.id;
        c.phone = '9949643991';
        c.AOSI_Pin_Code__c= pin.id;
        insert c;
        	
        User u = lstUser[0];
        
        MyProfilePageController myProfileObject = new MyProfilePageController();
        
        myProfileObject.cancel();
        myProfileObject.changePassword();
        myProfileObject.edit();
        myProfileObject.getIsEdit();
        myProfileObject.getUser();
        myProfileObject.save();
        MyProfilePageController.setContactFields(c,u); 
        
        
        }
    }
}