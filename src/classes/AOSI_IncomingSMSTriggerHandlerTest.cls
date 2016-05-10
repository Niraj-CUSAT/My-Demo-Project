/*****************************************************************************************************************************************************
 * Class Name   : AOSI_IncomingSMSTriggerHandlerTest
 * Created By   : Pooja P Bhat
 * Created Date : 29-SEPTEMBER-2015
 * Description  : Test Class for AOSI_IncomingSMSTrigger and AOSI_IncomingSMSTriggerHandler
 * Methods      : static testMethod void unitTestMethod()
******************************************************************************************************************************************************/
@isTest()
private class AOSI_IncomingSMSTriggerHandlerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Service_Engineer__c oResource   =   TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd  =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c    =    DefineConstant.PROD_VERTICAL_WH;
        insert oProd;
        
        Asset oAsset    =   TestHelpUtility.getAsset(oContact, oProd);
        insert oAsset;
        
        AMC_Master__c oAMC    =    TestHelpUtility.getAMC('Test', 900, 'WH-AMC');
        insert oAMC;
        
        Product_AMC_Junction__c oPAMC = TestHelpUtility.getProductAMCJunction(oAMC, oProd);
        insert oPAMC;
        
        list<Case> lInsertCase  =   new list<Case>();
        Case oCaseInstall                       =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseInstall.Reason                     =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_City__c               =   'Bangalore';
        lInsertCase.add(oCaseInstall);
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(oCaseContrctReq);

        if ( !lInsertCase.isEmpty()) {
            insert lInsertCase;
        }
        
        oCaseInstall.Service_Engineer__c    =  oResource.Id;  
        update oCaseInstall;
        
        case csFreeinstall = [SELECT Id,CaseNumber,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION LIMIT 1];
        case csConReq = [SELECT Id,CaseNumber,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_CONTRACT_REQUEST LIMIT 1];
        
        list<smagicinteract__Incoming_SMS__c> lInsertInSMS    =    new list<smagicinteract__Incoming_SMS__c>();
        smagicinteract__Incoming_SMS__c iSMSStart   = TestHelpUtility.getIncomingSMS('test1', 'START ' + csFreeinstall.CaseNumber, '919282159481', oResource.Mobile_Number__c );
        smagicinteract__Incoming_SMS__c iSMSStop    = TestHelpUtility.getIncomingSMS('test2', 'STOP ' + csFreeinstall.CaseNumber, '919282159481', oResource.Mobile_Number__c );
        smagicinteract__Incoming_SMS__c iSMSYes     = TestHelpUtility.getIncomingSMS('test3', 'YES ' + csFreeinstall.CaseNumber, '919282159481', csFreeinstall.Contact_Phone__c );
        
        smagicinteract__Incoming_SMS__c iSMSAmc     = TestHelpUtility.getIncomingSMS('test4', 'AMC 1234567 ' + csConReq.CaseNumber, '919282159481', csConReq.Contact_Phone__c );
        smagicinteract__Incoming_SMS__c iSMSNo      = TestHelpUtility.getIncomingSMS('test5', 'NO ' + csConReq.CaseNumber, '919282159481', csConReq.Contact_Phone__c );
        smagicinteract__Incoming_SMS__c iSMSexcp    = TestHelpUtility.getIncomingSMS('test6', 'NO ' + '12345678', '919282159481', csConReq.Contact_Phone__c );
        
        lInsertInSMS.add(iSMSStart);
        lInsertInSMS.add(iSMSStop);
        lInsertInSMS.add(iSMSYes);
        lInsertInSMS.add(iSMSAmc);
        lInsertInSMS.add(iSMSNo);
        lInsertInSMS.add(iSMSexcp);
        
        insert lInsertInSMS;
        
        
        test.stopTest();
        
    }
     static testMethod void otpMessagesUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Service_Engineer__c oResource   =   TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd  =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c    =    DefineConstant.PROD_VERTICAL_WH;
        insert oProd;
        
        Asset oAsset    =   TestHelpUtility.getAsset(oContact, oProd);
        insert oAsset;
        
        AMC_Master__c oAMC    =    TestHelpUtility.getAMC('Test', 900, 'WH-AMC');
        insert oAMC;
        
        Product_AMC_Junction__c oPAMC = TestHelpUtility.getProductAMCJunction(oAMC, oProd);
        insert oPAMC;
        
        list<Case> lInsertCase  =   new list<Case>();
        Case oCaseInstall                       =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseInstall.Reason                     =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_City__c               =   'Bangalore';
        lInsertCase.add(oCaseInstall);
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(oCaseContrctReq);

        if ( !lInsertCase.isEmpty()) {
            insert lInsertCase;
        }
        
        oCaseInstall.Service_Engineer__c    =  oResource.Id;  
        update oCaseInstall;
        
        case csFreeinstall = [SELECT Id,CaseNumber,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION LIMIT 1];
        case csConReq = [SELECT AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__c,Reason,AccountId,AOSI_AMC_Pin__c,CaseNumber,Contact.Phone, Contact.MobilePhone,Contact_Name__c,Contact_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_CONTRACT_REQUEST LIMIT 1];
        
        list<smagicinteract__Incoming_SMS__c> lInsertInSMS    =    new list<smagicinteract__Incoming_SMS__c>();
        system.debug('csConReq'+csConReq);
        smagicinteract__Incoming_SMS__c OTPSMS1    = TestHelpUtility.getIncomingSMS('test7','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '91'+csConReq.Contact_Phone__c );
        //smagicinteract__Incoming_SMS__c OTPSMS2    = TestHelpUtility.getIncomingSMS('test8','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '918904623622' );
        //smagicinteract__Incoming_SMS__c OTPSMS3    = TestHelpUtility.getIncomingSMS('test9','OTP '+csConReq.CaseNumber+ ' FLT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        //smagicinteract__Incoming_SMS__c OTPSMS4    = TestHelpUtility.getIncomingSMS('test10','OTP '+csConReq.CaseNumber+ ' FLTT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        system.debug('OTPSMS1'+OTPSMS1);
        lInsertInSMS.add(OTPSMS1);
        //lInsertInSMS.add(OTPSMS2);
        //lInsertInSMS.add(OTPSMS3);
        //lInsertInSMS.add(OTPSMS4);
        
        insert lInsertInSMS;
        
        
        test.stopTest();
        
    }
         static testMethod void otpMessagesUnitTest2() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Service_Engineer__c oResource   =   TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd  =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c    =    DefineConstant.PROD_VERTICAL_WH;
        insert oProd;
        
        Asset oAsset    =   TestHelpUtility.getAsset(oContact, oProd);
        insert oAsset;
        
        AMC_Master__c oAMC    =    TestHelpUtility.getAMC('Test', 900, 'WH-AMC');
        insert oAMC;
        
        Product_AMC_Junction__c oPAMC = TestHelpUtility.getProductAMCJunction(oAMC, oProd);
        insert oPAMC;
        
        list<Case> lInsertCase  =   new list<Case>();
        Case oCaseInstall                       =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseInstall.Reason                     =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_City__c               =   'Bangalore';
        lInsertCase.add(oCaseInstall);
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(oCaseContrctReq);

        if ( !lInsertCase.isEmpty()) {
            insert lInsertCase;
        }
        
        oCaseInstall.Service_Engineer__c    =  oResource.Id;  
        update oCaseInstall;
        
        case csFreeinstall = [SELECT Id,CaseNumber,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION LIMIT 1];
        case csConReq = [SELECT AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__c,Reason,AccountId,AOSI_AMC_Pin__c,CaseNumber,Contact.Phone, Contact.MobilePhone,Contact_Name__c,Contact_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_CONTRACT_REQUEST LIMIT 1];
        
        list<smagicinteract__Incoming_SMS__c> lInsertInSMS    =    new list<smagicinteract__Incoming_SMS__c>();
        system.debug('csConReq'+csConReq);
        //smagicinteract__Incoming_SMS__c OTPSMS1    = TestHelpUtility.getIncomingSMS('test7','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '91'+csConReq.Contact_Phone__c );
        smagicinteract__Incoming_SMS__c OTPSMS2    = TestHelpUtility.getIncomingSMS('test8','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '918904623622' );
        //smagicinteract__Incoming_SMS__c OTPSMS3    = TestHelpUtility.getIncomingSMS('test9','OTP '+csConReq.CaseNumber+ ' FLT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        //smagicinteract__Incoming_SMS__c OTPSMS4    = TestHelpUtility.getIncomingSMS('test10','OTP '+csConReq.CaseNumber+ ' FLTT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        //system.debug('OTPSMS1'+OTPSMS1);
        //lInsertInSMS.add(OTPSMS1);
        lInsertInSMS.add(OTPSMS2);
        //lInsertInSMS.add(OTPSMS3);
        //lInsertInSMS.add(OTPSMS4);
        
        insert lInsertInSMS;
        
        
        test.stopTest();
        
    }
    
             static testMethod void otpMessagesUnitTest5() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Service_Engineer__c oResource   =   TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd  =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c    =    DefineConstant.PROD_VERTICAL_WH;
        insert oProd;
        
        Asset oAsset    =   TestHelpUtility.getAsset(oContact, oProd);
        insert oAsset;
        
        AMC_Master__c oAMC    =    TestHelpUtility.getAMC('Test', 900, 'WH-AMC');
        insert oAMC;
        
        Product_AMC_Junction__c oPAMC = TestHelpUtility.getProductAMCJunction(oAMC, oProd);
        insert oPAMC;
        
        list<Case> lInsertCase  =   new list<Case>();
        Case oCaseInstall                       =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseInstall.Reason                     =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_City__c               =   'Bangalore';
        lInsertCase.add(oCaseInstall);
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(oCaseContrctReq);

        if ( !lInsertCase.isEmpty()) {
            insert lInsertCase;
        }
        
        oCaseInstall.Service_Engineer__c    =  oResource.Id;  
        update oCaseInstall;
        
        case csFreeinstall = [SELECT Id,CaseNumber,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION LIMIT 1];
        case csConReq = [SELECT AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__c,Reason,AccountId,AOSI_AMC_Pin__c,CaseNumber,Contact.Phone, Contact.MobilePhone,Contact_Name__c,Contact_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_CONTRACT_REQUEST LIMIT 1];
        
        list<smagicinteract__Incoming_SMS__c> lInsertInSMS    =    new list<smagicinteract__Incoming_SMS__c>();
        system.debug('csConReq'+csConReq);
        //smagicinteract__Incoming_SMS__c OTPSMS1    = TestHelpUtility.getIncomingSMS('test7','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '91'+csConReq.Contact_Phone__c );
        //smagicinteract__Incoming_SMS__c OTPSMS2    = TestHelpUtility.getIncomingSMS('test8','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '918904623622' );
        smagicinteract__Incoming_SMS__c OTPSMS3    = TestHelpUtility.getIncomingSMS('test9','OTP '+csConReq.CaseNumber+ ' FLT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        //smagicinteract__Incoming_SMS__c OTPSMS4    = TestHelpUtility.getIncomingSMS('test10','OTP '+csConReq.CaseNumber+ ' FLTT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        //system.debug('OTPSMS1'+OTPSMS1);
        //lInsertInSMS.add(OTPSMS1);
        //lInsertInSMS.add(OTPSMS2);
        lInsertInSMS.add(OTPSMS3);
        //lInsertInSMS.add(OTPSMS4);
        
        insert lInsertInSMS;
        
        
        test.stopTest();
        
    }
             static testMethod void otpMessagesUnitTest4() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Service_Engineer__c oResource   =   TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd  =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c    =    DefineConstant.PROD_VERTICAL_WH;
        insert oProd;
        
        Asset oAsset    =   TestHelpUtility.getAsset(oContact, oProd);
        insert oAsset;
        
        AMC_Master__c oAMC    =    TestHelpUtility.getAMC('Test', 900, 'WH-AMC');
        insert oAMC;
        
        Product_AMC_Junction__c oPAMC = TestHelpUtility.getProductAMCJunction(oAMC, oProd);
        insert oPAMC;
        
        list<Case> lInsertCase  =   new list<Case>();
        Case oCaseInstall                       =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseInstall.Reason                     =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_City__c               =   'Bangalore';
        lInsertCase.add(oCaseInstall);
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(oCaseContrctReq);

        if ( !lInsertCase.isEmpty()) {
            insert lInsertCase;
        }
        
        oCaseInstall.Service_Engineer__c    =  oResource.Id;  
        update oCaseInstall;
        
        case csFreeinstall = [SELECT Id,CaseNumber,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION LIMIT 1];
        case csConReq = [SELECT AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__c,Reason,AccountId,AOSI_AMC_Pin__c,CaseNumber,Contact.Phone, Contact.MobilePhone,Contact_Name__c,Contact_Phone__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_CONTRACT_REQUEST LIMIT 1];
        
        list<smagicinteract__Incoming_SMS__c> lInsertInSMS    =    new list<smagicinteract__Incoming_SMS__c>();
        system.debug('csConReq'+csConReq);
        //smagicinteract__Incoming_SMS__c OTPSMS1    = TestHelpUtility.getIncomingSMS('test7','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '91'+csConReq.Contact_Phone__c );
        //smagicinteract__Incoming_SMS__c OTPSMS2    = TestHelpUtility.getIncomingSMS('test8','OTP '+csConReq.CaseNumber+ ' AMC', '919282159481', '918904623622' );
        //smagicinteract__Incoming_SMS__c OTPSMS3    = TestHelpUtility.getIncomingSMS('test9','OTP '+csConReq.CaseNumber+ ' FLT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        smagicinteract__Incoming_SMS__c OTPSMS4    = TestHelpUtility.getIncomingSMS('test10','OTP '+csConReq.CaseNumber+ ' FLTT', '919282159481', '91'+csConReq.Contact_Phone__c  );
        //system.debug('OTPSMS1'+OTPSMS1);
        //lInsertInSMS.add(OTPSMS1);
        //lInsertInSMS.add(OTPSMS2);
        //lInsertInSMS.add(OTPSMS3);
        lInsertInSMS.add(OTPSMS4);
        
        insert lInsertInSMS;
        
        
        test.stopTest();
        
    }
}