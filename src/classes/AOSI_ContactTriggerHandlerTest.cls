/*****************************************************************************************************************************************************
 * Class Name   : AOSI_ContactTriggerHandlerTest
 * Created By   : Pooja P Bhat
 * Created Date : 6-OCT-2015
 * Description  : Test Class for AOSI_ContactTrigger and AOSI_ContactTriggerHandler
 * Methods      : static testMethod void unitTestMethod()
******************************************************************************************************************************************************/
@isTest
private class AOSI_ContactTriggerHandlerTest {
    
    static testMethod void unitTestMethod() {
        
        list<RecordTypeDetails__c> lRecTypes    =   TestHelpUtility.getRecTyCustomSettings();
        insert lRecTypes;
        
        list<Pin_Master__c> lInsertPin  =   new list<Pin_Master__c>();
        Pin_Master__c oPin1 =   TestHelpUtility.getPinMaster('574111', 'South', 'Mangalore', 'Karnataka'); 
        lInsertPin.add(oPin1);
        Pin_Master__c oPin2 =   TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Tamilnadu'); 
        lInsertPin.add(oPin2);
        insert lInsertPin;
        
        list<Locality__c> lInsertLocality   =   new list<Locality__c>();
        Locality__c oLoc1   =   TestHelpUtility.getLocality('Hampankatta', oPin1); 
        lInsertLocality.add(oLoc1);
        Locality__c oLoc2   =   TestHelpUtility.getLocality('Surathkal', oPin1); 
        lInsertLocality.add(oLoc2);
        insert lInsertLocality;
        
        Account oAccount =  TestHelpUtility.getNewAccount('Test Account', oPin1);
        insert oAccount;
        
        list<Contact> lInsertContact = new list<Contact>();
        Contact oCon1           =   TestHelpUtility.getContact(oAccount, oPin1);
        oCon1.AOSI_Locality__c  =   oLoc1.Id;
        lInsertContact.add(oCon1);
        Contact oCon2           =   TestHelpUtility.getContact(oAccount, oPin1);
        lInsertContact.add(oCon2);
        insert lInsertContact;
        
        Contact qoCon1 = [SELECT Id,Name,MailingCity,MailingState,MailingPostalCode,MailingStreet FROM Contact WHERE Id =: oCon1.Id LIMIT 1];
        system.assertEquals(qoCon1.MailingCity, 'Mangalore', 'MailingCity matches');
        system.assertEquals(qoCon1.MailingState, 'Karnataka', 'MailingState matches');
        system.assertEquals(qoCon1.MailingPostalCode, '574111', 'MailingPostalCode matches');
        //system.assertEquals(qoCon1.MailingStreet , 'Test Mailing Street Hampankatta', 'MailingStreet matches');
        
        oCon2.AOSI_Pin_Code__c    =   oPin2.Id;
        update oCon2;
        
    } //End of unitTestMethod
  
} //End of AOSI_ContractTriggerHandlerTest