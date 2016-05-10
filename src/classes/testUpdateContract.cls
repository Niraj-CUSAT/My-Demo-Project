@isTest
private class testUpdateContract {
    static testmethod void testSMS() {
        test.startTest();
            Id caseAOSIRecTy    =   [SELECT Id,Name FROM RecordType WHERE  DeveloperName =:'AOSI' and SobjectType =:'Case' LIMIT 1].Id;
        
            list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
            insert recordTypes;
            
            list<AOSI_Time_Calculation_Settings__c> oTCS    =   TestHelpUtility.getTimeCalCustSttng();
            insert oTCS;
            
            smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
            insert senderId;
            
            list<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
            insert smsTemplate;
        

            City_Master__c cityMasterSouth  =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');          
            insert cityMasterSouth;
        
            Pin_Master__c oPinMasterSouth   =   TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
            insert oPinMasterSouth; 
 
        
            Account oAcc    =   TestHelpUtility.getNewAccount('Test Contract Request',oPinMasterSouth);
            insert oAcc;
        
            Contact oContactSouth   = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
            insert oContactSouth;
        
       
            AMC_Master__c amcWH  = TestHelpUtility.getAMC('Test AMC WH', 5000, DefineConstant.AMC_WH_AMC);
            insert amcWH;
        
        
            Product2 oProdWH1                                   =   TestHelpUtility.getProduct();
            oProdWH1.Name                                       =   'WH-TEST-PROD1';
            oProdWH1.AOSI_Vertical__c                           =   DefineConstant.PROD_VERTICAL_WH;
            oProdWH1.AOSI_Family__c                             =   'Storage';
            oProdWH1.AOSI_Product_Code_for_Serial_Number__c     =   'B080';
            insert oProdWH1;
        

            Product_AMC_Junction__c pamc1   =   TestHelpUtility.getProductAMCJunction(amcWH, oProdWH1);     
            insert pamc1;

            Asset oAssetSouth1              =   TestHelpUtility.getAsset(oContactSouth, oProdWH1);
            oAssetSouth1.Name               =   'B0800104041234';
            insert oAssetSouth1;
        
        
            Case c1                         =   TestHelpUtility.getCase(oContactSouth, oAssetSouth1, oProdWH1);
            c1.RecordTypeId                 =   caseAOSIRecTy;
            c1.Reason                       =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
            c1.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;     
            insert c1;
        
            Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
            insert oServEngg;
        
            c1.AOSI_AMC_Pin__c      =   'AMC 1234567';       
            c1.Service_Engineer__c  =   oServEngg.Id;
            update c1;
            
            Case caserecord = [select id,CaseNumber,Contact_Phone__c from case where id = : c1.Id LIMIT 1];
            string caseNo = caserecord.CaseNumber;
            smagicinteract__Incoming_SMS__c sms = new smagicinteract__Incoming_SMS__c();
            sms.smagicinteract__SMS_Text__c = 'ACMC 1234567'+' ' +caseNo;
            sms.smagicinteract__Mobile_Number__c=caserecord.Contact_Phone__c;
            sms.smagicinteract__external_field__c='123456';
            insert sms;  
        test.stopTest();
    }
}