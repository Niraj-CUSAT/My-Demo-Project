/*
##############################################################
# Project Name..........: AOSmith
# File..................: TestRollUpSummaryonContactsandCR
# Version...............: 1
# Created by............: Rahul Nasa
# Created Date..........: 05-December-2011
# Last Modified by......:   Vkumar(Trekbin) 
# Last Modified Date....:  17-Sep-2013 
# Description...........: This is the test class for Contacts After and Contractor Rewards triggers 
              and also for AOS_UtilityUpdateAccountwithRollUp class.      
########################################################################### 
*/ 
@isTest
private class TestRollUpSummaryonContactsandCR {

    static testMethod void myUnitTest() 
    {
      Test.startTest(); 
      Date dtRecentTransactiondate = Date.newInstance(2011,10,10);
      List<Account> lstAccount = new List<Account>();
      
      Id cspAccountRT = [SELECT Id FROM RecordType WHERE SObjectType='Account' and Name='CSP'].Id;
      
      Account testAccount = new Account(Name = 'Test Account',American_Transaction__c =360, RecordTypeId=cspAccountRT, Count_Total_Transaction__c=2,Other_Transaction__c = 180, State_Transaction__c = 180, Other_Count__c = 1, Sum_Total_Transaction__c=360,Recent_CR_Transaction_Date__c=dtRecentTransactiondate);      
      Account testAccount1 = new Account(Name = 'Test Account1', RecordTypeId=cspAccountRT);
      Account testAccount2 = new Account(Name = 'Test Account2', RecordTypeId=cspAccountRT);
      lstAccount.add(testAccount);
      lstAccount.add(testAccount1);
      lstAccount.add(testAccount2);
      insert lstAccount;
      
      
      List<Contact> lstContact = new List<Contact>();
      
      Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];
       // mock user for the same
       User mockUser = new User(alias = 'newUser', email='newuser@tgerm.com',
                 emailencodingkey='UTF-8', lastname='Testing',
                 languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
                 timezonesidkey='America/Los_Angeles', username='newuser@tgerm.com' + System.now().getTime());
       // Custom sobject with no special fields, just for sake of testing
      
        
      Map<String,CreatedById__c> customMessages; 
      customMessages=CreatedById__c.getAll();    
      Id contactRT = [SELECT Id FROM RecordType WHERE SObjectType='Contact' and Name='Contractor'].Id;
      Contact testContact = new Contact(LastName = 'Test Contact', RecordTypeId=contactRT, AccountId = lstAccount[0].Id,CreatedById=customMessages.get('UserId').value__c,EXTERNAL_ID_PARTICIPANT__c='1234512345');      
      Contact testContact1 = new Contact(LastName = 'Test Contact1', RecordTypeId=contactRT, AccountId = lstAccount[0].Id,CreatedById=mockUser.Id);
      Contact testContact2 = new Contact(LastName = 'Test Contact2', RecordTypeId=contactRT, AccountId = lstAccount[0].Id,CreatedById=customMessages.get('UserId').value__c);      
      Contact testContact3 = new Contact(LastName = 'Test Contact3', RecordTypeId=contactRT,  CreatedById=customMessages.get('UserId').value__c);      
      lstContact.add(testContact);
      lstContact.add(testContact1);
      lstContact.add(testContact2);
      lstContact.add(testContact3);
      insert lstContact;
      
      testContact3.LastName = 'Updated Contact3';
      testContact3.EXTERNAL_ID_PARTICIPANT__c = '123451234';
      update testContact3;
      
      List<Contractor_Rewards__c> lstContractorRewards =  new List<Contractor_Rewards__c>();
        Contractor_Rewards__c testCr = new Contractor_Rewards__c(EXTERNAL_ID_Transaction__c = '123789456',Product_ID__c = '3137',Product_Name__c = 'American 9 &12 Yr Gas Models (All vent types)',
                                    Brand_Name__c = 'American Water Heaters',TRANS_AMT__c = 180.00,Promotion_ID__c = '7221',Promotion_Name__c = 'A.O. Smith',Reporting_Group__c = 'American Res.'
                                  ,DataLoader_DateStatus__c = '10102011',Contractor__c = testContact.Id);
                                        
        Contractor_Rewards__c testCr1 = new Contractor_Rewards__c(EXTERNAL_ID_Transaction__c = '456987123',Product_ID__c = '3137',Product_Name__c = 'American 9 &12 Yr Gas Models (All vent types)',
                                    Brand_Name__c = 'American Water Heaters',TRANS_AMT__c = 180.00,Promotion_ID__c = '7221',Promotion_Name__c = 'A.O. Smith',Reporting_Group__c = 'American Res.'
                                  ,DataLoader_DateStatus__c = '10102011',Contractor__c = testContact3.Id); 
        lstContractorRewards.add(testCr);
        lstContractorRewards.add(testCr1);      
        /*lstContractorRewards.add(testCr1);*/
        system.debug('====== lstContractorRewards ====== '+lstContractorRewards);  
        insert lstContractorRewards;        
       //After Insert on Contractor Rewards.
        Account  objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
            system.debug('objAccount........' + objAccount);  
        system.assertEquals(objAccount.Count_Total_Transaction__c,1);
        system.assertEquals(objAccount.Sum_Total_Transaction__c,180);        
        system.assertEquals(objAccount.Recent_CR_Transaction_Date__c,dtRecentTransactiondate);
        
        //After Update on Contractor Rewards for Other.
            lstContractorRewards[0].Brand_Name__c = 'Other';
        update lstContractorRewards[0];
      objAccount = [Select Id,Count_Total_Transaction__c,Other_Count__c,Other_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1]; 
        system.assertEquals(objAccount.Other_Transaction__c,180);
        system.assertEquals(objAccount.Other_Count__c,1);
        
         //After Update on Contractor Rewards for State.
        lstContractorRewards[0].Brand_Name__c='State';
        update lstContractorRewards[0];
        objAccount = [Select Id,Count_Total_Transaction__c,State_Transaction__c,State_Count__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1]; 
        lstContractorRewards[0].Brand_Name__c='Takagi';
        
        //After Update on Contractor Rewards for Takagi.
        // update lstContractorRewards[0];
        objAccount = [Select Id,Count_Total_Transaction__c,Takagi_Transaction__c,Takagi_Count__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1]; 
        lstContractorRewards[0].Brand_Name__c='AO Smith';
        
         //After Update on Contractor Rewards for AO Smith.
        //  update lstContractorRewards[0];
        objAccount = [Select Id,Count_Total_Transaction__c,AOS_Count__c,AOS_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1]; 
        lstContractorRewards[0].Brand_Name__c='American';
         
        //After Update on Contractor Rewards for American.
        // update lstContractorRewards[0];
        objAccount = [Select Id,Count_Total_Transaction__c,American_Count__c,American_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1]; 
        testCr.Brand_Name__c = 'American Water Heaters';
        
        //After Update on Contractor Rewards for American.
        //update lstContractorRewards[0];  
        system.assertEquals(objAccount.Recent_CR_Transaction_Date__c,dtRecentTransactiondate);  
        
        /*
        //After Update on Contractor Rewards for second record.   
        // update lstContractorRewards[1]; 
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
         
        system.assertEquals(objAccount.Recent_CR_Transaction_Date__c,dtRecentTransactiondate); 
        
        //After delete on Contractor Rewards.    
        delete lstContractorRewards[0];
        objAccount=[Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
        system.assertEquals(objAccount.Recent_CR_Transaction_Date__c,dtRecentTransactiondate);
        
        //After undelete on Contractor Rewards.
        undelete lstContractorRewards[0];
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
     
         system.assertEquals(objAccount.Recent_CR_Transaction_Date__c,dtRecentTransactiondate);
        // testContact.AccountId = testAccount1.Id;
        
        
        //After Update of Contact.
        update lstContact[0];
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
        //Making the Account of Contact Null.
        
        // update lstContact[0];
        objAccount=[Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
        
        //REverting to the previous state.
      //  update lstContact[0];
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
         delete lstContractorRewards[0];
       //  update lstContact[0];
        
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
        
        //after deletion of Contact.
        undelete lstContractorRewards[0];
        delete lstContractorRewards[0];
        update lstContact[0];        
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
        //Deleteing the all related Contacts.
         delete lstContact[0];
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];   
        
        delete lstContact[1];
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];   
        
        //After Undeleting the Contact.
        
        undelete lstContact[0];
        objAccount = [Select Id,Count_Total_Transaction__c,Sum_Total_Transaction__c,Recent_CR_Transaction_Date__c from Account where Id=:lstAccount[0].Id limit 1];
        */
        
        delete testContact3;
        Test.stopTest();
        
    }
}