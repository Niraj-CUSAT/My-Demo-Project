/*
    Name:   TaskTriggerTest 
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  08/09/2015
    Modified By:  
    Last Modified Date: 
    Description:
    Methods Used: 
*/
@isTest
private class TaskTriggerTest {

    static testMethod void myUnitTest() {//Positive test
        
       Profile p = [SELECT Id FROM Profile WHERE Name='Service Executive AOSI']; 
       User u2 = new User(Alias = 'TUser1', Email='TestingUser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='TUser1', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='TUser1@testorg.com');
       insert u2;
       Account accDetails = TestHelpUtility.getAccount();
       accDetails.AOSI_Related_Service_Manager__c=u2.Id;
       accDetails.AOSI_Categories__c    =    'Distributor';
       accDetails.AOSI_Related_Sales_Manager__c    =    'TestSalesManager';
       accDetails.AOSI_Sales_manager_Email__c      =    'test@test.com'; 
       accDetails.AOSI_Sales_manager_Phone__c      =    '9633699633';
       accDetails.AOSI_Related_Service_Manager__c  =    u2.Id;
       insert accDetails;
       
       Pin_Master__c pinDetails =TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka'); 
       insert pinDetails; 
       
       Task createTask = new Task();
       createTask.WhatId=accDetails.Id; 
       createTask.Subject='Dealer Visit';
       createTask.priority='Normal';
       createTask.OwnerId=accDetails.AOSI_Related_Service_Manager__c;
       createTask.status = 'Not Started';   
       createTask.ActivityDate=System.today().toStartOfMonth()+15;
       insert createTask;        
       
       Attachment attach=new Attachment();    
       attach.Name='Invoice';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=createTask.id;
       attach.OwnerId=createTask.ownerId;
       insert attach;
        
       createTask.status='Completed';
       update createTask;
        
       delete attach;
        
    }
    static testMethod void negativeTest() {//Negative Test
        
       Profile p = [SELECT Id FROM Profile WHERE Name='Service Executive AOSI']; 
       User u2 = new User(Alias = 'tuser5', Email='TestingUser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='tuser5', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='tuser5@testorg.com');
       insert u2;
       
       Account accDetails = TestHelpUtility.getAccount();
       accDetails.AOSI_Related_Service_Manager__c=u2.Id;
       accDetails.AOSI_Categories__c    =    'Direct Dealer';
       accDetails.AOSI_Categories__c    =    'Distributor';
       accDetails.AOSI_Related_Sales_Manager__c    =    'TestSalesManager';
       accDetails.AOSI_Sales_manager_Email__c      =    'test@test.com'; 
       accDetails.AOSI_Sales_manager_Phone__c      =    '9633699633';
       accDetails.AOSI_Related_Service_Manager__c  =    u2.Id;
       insert accDetails;
       
       Pin_Master__c pinDetails =TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka'); 
       insert pinDetails; 
       
       Task createTask = new Task();
       createTask.WhatId=accDetails.Id; 
       createTask.Subject='Dealer Visit';
       createTask.priority='Normal';
       createTask.OwnerId=accDetails.AOSI_Related_Service_Manager__c;
       createTask.status = 'Not Started';   
       createTask.ActivityDate=System.today().toStartOfMonth()+15;
       insert createTask;        
       
       Attachment attach=new Attachment();    
       attach.Name='Invoice';
       Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
       attach.body=bodyBlob;
       attach.parentId=createTask.id;
       attach.OwnerId=createTask.ownerId;
       insert attach;
       delete attach;
    }
    static testMethod void negative1Test() { //Negative Test1
        
       Profile p = [SELECT Id FROM Profile WHERE Name='Service Executive AOSI']; 
       User u2 = new User(Alias = 'TUser2', Email='TestingUser@testorg.com', 
         EmailEncodingKey='UTF-8', LastName='TUser2', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='TUser2@testorg.com');
       insert u2;
       
       Account accDetails = TestHelpUtility.getAccount();
       accDetails.AOSI_Related_Service_Manager__c=u2.Id;
       accDetails.AOSI_Categories__c               =    'Modern retail';
       accDetails.AOSI_Related_Sales_Manager__c    =    'TestSalesManager';
       accDetails.AOSI_Sales_manager_Email__c      =    'test@test.com'; 
       accDetails.AOSI_Sales_manager_Phone__c      =    '9633699633';
       accDetails.AOSI_Related_Service_Manager__c  =    u2.Id;
       insert accDetails;
       
       Pin_Master__c pinDetails = TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka'); 
       insert pinDetails; 
       
       Task createTask = new Task();
       createTask.WhatId=accDetails.Id; 
       createTask.Subject='Dealer Visit';
       createTask.priority='Normal';
       createTask.OwnerId=accDetails.AOSI_Related_Service_Manager__c;
       createTask.status = 'Not Started';   
       createTask.ActivityDate=System.today().toStartOfMonth()+15;
       insert createTask;        
       
       createTask.status='Completed';
       try{
        update createTask;      
       }catch(Exception e){
          system.assert(e.getMessage().contains('Please add attachment to complete your task.'));
       }  
    }
}