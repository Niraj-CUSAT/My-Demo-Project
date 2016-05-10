/*
*	Name		: TestContactRewardsBatchController
*	Author		: Govind Thathera
*	Date		: 03/12/2014
*	Description	: Test class to test ContactRewardsBatchController, AccountContactsRewardBatchController and ScheduledContactRewardsBatchController class.
*/

@isTest
private class TestContactRewardsBatchController{
    @isTest
    private static void myUnitTest(){
        // Create Sys admin user for test class.
        User u = getTestUser();
        // Execute code as sys admin. 
        System.runAs(u){
            
            // CreatedById__c Custom Setting
            CreatedById__c cbId = new CreatedById__c(Name='UserId', value__c=u.Id);
            insert cbId;
            
            String accRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Account' AND Name='CSP'].Id;
            Account accRecord1 = new Account(Name='Test Account 1', RecordTypeId=accRecordTypeId);
            Account accRecord2 = new Account(Name='Test Account 2', RecordTypeId=accRecordTypeId);
            List<Account> accRecords = new List<Account>{accRecord1, accRecord2};
            insert accRecords;
                          
            String conRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contact' AND Name='Contractor'].Id;
            Contact conRecord1 = new Contact(LastName='Test Contact 1', AccountId=accRecord1.Id, RecordTypeId=conRecordTypeId);
            Contact conRecord2 = new Contact(LastName='Test Contact 2', AccountId=accRecord1.Id, RecordTypeId=conRecordTypeId);
            Contact conRecord3 = new Contact(LastName='Test Contact 3', AccountId=accRecord2.Id, RecordTypeId=conRecordTypeId);
            List<Contact> conRecords = new List<Contact>{conRecord1, conRecord2, conRecord3}; //, conRecord3, conRecord4};
            insert conRecords;
              
            List<Contractor_Rewards__c> conRewards = new List<Contractor_Rewards__c>();
            conRewards.addAll(getContractorRewardsRecords(conRecord1));
            conRewards.addAll(getContractorRewardsRecords(conRecord1));
            conRewards.addAll(getContractorRewardsRecords(conRecord2)); 
            conRewards.addAll(getContractorRewardsRecords(conRecord3));
            insert conRewards; 
                
            test.StartTest();
                ContactRewardsBatchController crBatchObj = new ContactRewardsBatchController();
                database.executeBatch(crBatchObj, 200);
             
                ScheduledContactRewardsBatchController sh1 = new ScheduledContactRewardsBatchController();
                String sch = '0 0 23 ? * FRI'; 
                system.schedule('ScheduledContactRewardsBatchController', sch, sh1);
            
            test.stopTest();    
            
            
                        
                                                                               
        }       
    } 
    
    private static String getDateString(Integer days){
        String dateString = (Date.Today().addDays(days).month()+'').length() == 1 ? '0'+(Date.Today().addDays(days).month()) : (Date.Today().addDays(days).month()+'');
        dateString += (Date.Today().addDays(days).day()+'').length() == 1 ? '0'+(Date.Today().addDays(days).day()) : (Date.Today().addDays(days).day()+'');
        dateString += (Date.Today().addDays(days).year()+'');
        
        System.debug('Date String: '+dateString);
        
        return dateString;
    }
    
    private static List<Contractor_Rewards__c> getContractorRewardsRecords(Contact conRecord){
        List<Contractor_Rewards__c> conRewards = new List<Contractor_Rewards__c>();
        String inPast30Days = getDateString(-20);
        String inPast60Days = getDateString(-40);
        String inPast90Days = getDateString(-70);
        String inPast365Days = getDateString(-110);
        
        // AOS Records.
        conRewards.add(new Contractor_Rewards__c(Name='aosStdGasEle', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                          Reporting_Group__c='Standard Gas & Electric', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='aosHeatPump', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                      Reporting_Group__c='Heat Pump', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='aosHighEffGas', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                      Reporting_Group__c='High Efficiency Gas', DataLoader_DateStatus__c=inPast60Days));
        conRewards.add(new Contractor_Rewards__c(Name='aosTankless', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                      Reporting_Group__c='Tankless', DataLoader_DateStatus__c=inPast90Days));
        conRewards.add(new Contractor_Rewards__c(Name='aosSolar', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                      Reporting_Group__c='Solar', DataLoader_DateStatus__c=inPast90Days));
        conRewards.add(new Contractor_Rewards__c(Name='aosCommercial', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                      Reporting_Group__c='Commercial', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='aosBonus', Contractor__c=conRecord.Id, Brand_Name__c='A. O. Smith',
                                                                      Reporting_Group__c='Bonus', DataLoader_DateStatus__c=inPast365Days));
          
        // State Records
        conRewards.add(new Contractor_Rewards__c(Name='stateStdGasEle', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                          Reporting_Group__c='Standard Gas & Electric', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='stateHeatPump', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                      Reporting_Group__c='Heat Pump', DataLoader_DateStatus__c=inPast60Days));
        conRewards.add(new Contractor_Rewards__c(Name='stateHighEffGas', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                      Reporting_Group__c='High Efficiency Gas', DataLoader_DateStatus__c=inPast60Days));
        conRewards.add(new Contractor_Rewards__c(Name='stateTankless', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                      Reporting_Group__c='Tankless', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='stateSolar', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                      Reporting_Group__c='Solar', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='stateCommercial', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                      Reporting_Group__c='Commercial', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='stateBonus', Contractor__c=conRecord.Id, Brand_Name__c='State',
                                                                      Reporting_Group__c='Bonus', DataLoader_DateStatus__c=inPast90Days));
        
        // American Records
        conRewards.add(new Contractor_Rewards__c(Name='americanStdGasEle', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                          Reporting_Group__c='Standard Gas & Electric', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='americanHeatPump', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                      Reporting_Group__c='Heat Pump', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='americanHighEffGas', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                      Reporting_Group__c='High Efficiency Gas', DataLoader_DateStatus__c=inPast30Days));
        conRewards.add(new Contractor_Rewards__c(Name='americanTankless', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                      Reporting_Group__c='Tankless', DataLoader_DateStatus__c=inPast60Days));
        conRewards.add(new Contractor_Rewards__c(Name='americanSolar', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                      Reporting_Group__c='Solar', DataLoader_DateStatus__c=inPast60Days));
        conRewards.add(new Contractor_Rewards__c(Name='americanCommercial', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                      Reporting_Group__c='Commercial', DataLoader_DateStatus__c=inPast90Days));
        conRewards.add(new Contractor_Rewards__c(Name='americanBonus', Contractor__c=conRecord.Id, Brand_Name__c='American',
                                                                      Reporting_Group__c='Bonus', DataLoader_DateStatus__c=inPast365Days));
        
        // Takagi Record                                                              
        conRewards.add(new Contractor_Rewards__c(Name='takagiStdGasEle', Contractor__c=conRecord.Id, Brand_Name__c='Takagi',
                                                                      Reporting_Group__c='Bonus', DataLoader_DateStatus__c=inPast30Days));
        
        conRewards.add(new Contractor_Rewards__c(Name='takagiStdGasEle', Contractor__c=conRecord.Id, Brand_Name__c='Takagi',
                                                                      Reporting_Group__c='Standard Gas & Electric'));
        
        return conRewards;
    }
    
    private static User getTestUser(){
        // This code runs as the system user
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'sysadm', Email='sysadminuser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='sysadminuser@testorg.com');
      return u;
    }
}