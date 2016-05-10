/*****************************************************************************************************************************************************
 * Class Name   : AOSI_AOSIContractTriggerHandlerTest 
 * Created By   : Pooja P Bhat
 * Created Date : 22-SEPT-2015
 * Description  : Test Class for AOSI_AOSIContractTrigger and AOSI_AOSIContractTriggerHandler
 * Methods      : static testMethod void myUnitTest() 
                  static testMethod void myUnitTest1()
******************************************************************************************************************************************************/
@isTest
private class AOSI_AOSIContractTriggerHandlerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        list<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        Asset q1Asset  =  [SELECT Id,Name,PurchaseDate,AOSI_Asset_Status__c,OPW_End_Date_AOSI__c,Warranty_Final_End_Date_AOSI__c,AOSI_Warranty_End_Date__c FROM Asset limit 1];

        list<AMC_Master__c> lAmcMaster  =  new list<AMC_Master__c>();
        AMC_Master__c oAMC1    =    TestHelpUtility.getAMC('Test1', 900, 'WT-AMC');
        lAmcMaster.add(oAMC1);
        AMC_Master__c oAMC2    =    TestHelpUtility.getAMC('Test2', 1900, 'WT-ACMC');
        lAmcMaster.add(oAMC2);
        AMC_Master__c oAMC3    =    TestHelpUtility.getAMC('Test3', 2900, 'WT-FLT');
        lAmcMaster.add(oAMC3);
        insert lAmcMaster;

        
        list<Product_AMC_Junction__c> lInsertPAMC  =  new list<Product_AMC_Junction__c>();
        Product_AMC_Junction__c oPAMC1 = TestHelpUtility.getProductAMCJunction(oAMC1, oProd);
        lInsertPAMC.add(oPAMC1);
        Product_AMC_Junction__c oPAMC2 = TestHelpUtility.getProductAMCJunction(oAMC2, oProd);
        lInsertPAMC.add(oPAMC2);
        insert lInsertPAMC;
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        insert oCaseContrctReq;
        
        list<AMC_Pin__c> lInsertPin    =  new list<AMC_Pin__c>();
        AMC_Pin__c oPin1        =   new AMC_Pin__c();
        oPin1.AOSI_AMC_Pin_Number__c  =   'AMC 12345678';
        oPin1.AOSI_Type__c        =  'AMC';
        lInsertPin.add(oPin1);
        AMC_Pin__c oPin2        =   new AMC_Pin__c();
        oPin2.AOSI_AMC_Pin_Number__c  =   'ACMC 12345678';
        oPin2.AOSI_Type__c        =  'ACMC';
        lInsertPin.add(oPin2);
        AMC_Pin__c oPin3        =   new AMC_Pin__c();
        oPin3.AOSI_AMC_Pin_Number__c  =   'FLT 12345678';
        oPin3.AOSI_Type__c        =  'FLT';
        lInsertPin.add(oPin3);
  
        insert lInsertPin;

        
        AOSI_Contract__c contract1  =  TestHelpUtility.getAOSIContract('AMC 12345678', oAsset, oCaseContrctReq);
        contract1.AOSI_AMC__c    =  oAMC1.Id;       
        insert contract1;
       
        contract1.AOSI_Start_Date__c    =  q1Asset.AOSI_Warranty_End_Date__c.addDays(1);
        contract1.AOSI_Amount_Received__c   = true;
        contract1.AOSI_Mode_Of_Payment__c  =  'Cash';
        contract1.AOSI_Invoice_Number__c  =  'INV12345';        
        contract1.AOSI_Invoice_Date__c    =  system.today();       
        update contract1;
        
        AOSI_Contract__c qaContract1  =  [SELECT Id,AOSI_Contract_Status__c,AOSI_Amount_Received__c,AOSI_Mode_Of_Payment__c,AOSI_Invoice_Number__c,AOSI_Invoice_Date__c FROM AOSI_Contract__c WHERE Name='AMC 12345678' LIMIT 1];

        system.assertEquals(qaContract1.AOSI_Amount_Received__c, true, 'Amount Received is true');
        system.assertEquals(qaContract1.AOSI_Contract_Status__c, 'Active', 'Contract Status is Active');
        
        AOSI_Contract__c contract2  =  TestHelpUtility.getAOSIContract('AMC 123456789', oAsset, oCaseContrctReq);
        contract2.AOSI_AMC__c    =  oAMC1.Id;       
        try{
            insert contract2;
        } catch ( Exception e ) { System.debug('***** Exception on insert of new contract ' + e);}
        
        contract2.AOSI_Start_Date__c    =  q1Asset.AOSI_Warranty_End_Date__c.addDays(1);
        contract2.AOSI_Amount_Received__c   = true;
        contract2.AOSI_Mode_Of_Payment__c  =  'Cash';
        contract2.AOSI_Invoice_Number__c  =  'INV123456';        
        contract2.AOSI_Invoice_Date__c    =  system.today();
        try{
             update contract2;
        } catch ( Exception e ) { System.debug('***** error - assest has active contract, new contract start date should be greater than old contract end date ' + e);}
               
       
        
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        test.startTest();
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
         
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        list<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        Asset q1Asset  =  [SELECT Id,Name,PurchaseDate,AOSI_Asset_Status__c,OPW_End_Date_AOSI__c,Warranty_Final_End_Date_AOSI__c,AOSI_Warranty_End_Date__c FROM Asset limit 1];

        list<AMC_Master__c> lAmcMaster  =  new list<AMC_Master__c>();
        AMC_Master__c oAMC1    =    TestHelpUtility.getAMC('Test1', 900, 'WT-AMC');
        lAmcMaster.add(oAMC1);
        AMC_Master__c oAMC2    =    TestHelpUtility.getAMC('Test2', 1900, 'WT-ACMC');
        lAmcMaster.add(oAMC2);
        AMC_Master__c oAMC3    =    TestHelpUtility.getAMC('Test3', 2900, 'WT-FLT');
        lAmcMaster.add(oAMC3);
        insert lAmcMaster;
 
        
        list<Product_AMC_Junction__c> lInsertPAMC  =  new list<Product_AMC_Junction__c>();
        Product_AMC_Junction__c oPAMC1 = TestHelpUtility.getProductAMCJunction(oAMC1, oProd);
        lInsertPAMC.add(oPAMC1);
        Product_AMC_Junction__c oPAMC2 = TestHelpUtility.getProductAMCJunction(oAMC2, oProd);
        lInsertPAMC.add(oPAMC2);
        insert lInsertPAMC;
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        insert oCaseContrctReq;
        
        list<AMC_Pin__c> lInsertPin    =  new list<AMC_Pin__c>();
        AMC_Pin__c oPin1        =   new AMC_Pin__c();
        oPin1.AOSI_AMC_Pin_Number__c  =   'AMC 12345678';
        oPin1.AOSI_Type__c        =  'AMC';
        lInsertPin.add(oPin1);
        AMC_Pin__c oPin2        =   new AMC_Pin__c();
        oPin2.AOSI_AMC_Pin_Number__c  =   'ACMC 12345678';
        oPin2.AOSI_Type__c        =  'ACMC';
        lInsertPin.add(oPin2);
        AMC_Pin__c oPin3        =   new AMC_Pin__c();
        oPin3.AOSI_AMC_Pin_Number__c  =   'FLT 12345678';
        oPin3.AOSI_Type__c        =  'FLT';
        lInsertPin.add(oPin3);
  
        insert lInsertPin;

        
        AOSI_Contract__c contract1  =  TestHelpUtility.getAOSIContract('AMC 12345678', oAsset, oCaseContrctReq);
        contract1.AOSI_AMC__c    =  oAMC1.Id;       
        try{
            insert contract1;
        } catch ( Exception e ) { System.debug('*** on contract insert - exception ***' + e);}

        AOSI_Contract__c qContract1  =  [SELECT Id,AOSI_Start_Date__c,AOSI_Amount_Received__c,AOSI_Mode_Of_Payment__c,AOSI_Invoice_Number__c,AOSI_Invoice_Date__c FROM AOSI_Contract__c WHERE Name='AMC 12345678' LIMIT 1];

        
        contract1.AOSI_AMC__c           =  oAMC3.Id;
        try{
            update contract1;
        } catch ( Exception e ) { System.debug('*** error Incorrect AMC Selected ***' + e);}

        try{
            delete contract1;
        } catch ( Exception e ) { System.debug('*** contract delete exception ***' + e);}
        test.stopTest();
        
    }
}