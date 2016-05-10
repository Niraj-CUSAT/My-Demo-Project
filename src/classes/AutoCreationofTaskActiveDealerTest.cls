/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    09/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Test class for Creating Auto creation of tasks for active delaers with catergory
**************************************************************************************************/
@isTest
private class AutoCreationofTaskActiveDealerTest {

    static testMethod void positiveTest() {
       Profile p = [SELECT Id FROM Profile WHERE Name='Service Executive AOSI'];//Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
       
       User u2 = new User(Alias = 'TestUser', Email='TestingUser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='TestUser123', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='TestUser123@testorg.com');
       insert u2;
       
       
       RecordTypeDetails__c accountRT= new RecordTypeDetails__c();//Inserting Product Record Type Custom settings
       accountRT.Name='Account Name';
       accountRT.Developer_Name__c='AOS_India';
       accountRT.SobjectType__c='Account';
       insert accountRT;
       
       Recordtype rtAccount=DAL.getRecordTypeId(accountRT.Developer_Name__c,accountRT.SobjectType__c);//Calling DAL Class
       
       Account accDetails = TestHelpUtility.getAccount();
       accDetails.AOSI_Related_Service_Manager__c=u2.Id;
       accDetails.AOSI_Related_Sales_Manager__c='TestSales';
       accDetails.AOSI_Sales_manager_Email__c='Test@gmail.com';
       accDetails.AOSI_Sales_manager_Phone__c='1234567898';
       accDetails.AOSI_Active__c=true;
       accDetails.AOSI_Categories__c='Direct Dealer';
       accDetails.RecordTypeId=rtAccount.Id;
       insert accDetails;
       
       AutoCreationofTaskActiveDealer activeDealer = new AutoCreationofTaskActiveDealer();
       Database.executeBatch(activeDealer);
    }
}