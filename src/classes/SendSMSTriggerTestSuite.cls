@isTest
private class  SendSMSTriggerTestSuite {

    //This test class is used for testing SendSMSonCase and UpdateCasefromSMS
    static testMethod void runtest() {
    
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
             
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Color Panel',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
      
        list<Product2> lInsertProd                      =   new list<Product2>();   
        Product2 oProdWT                                =   TestHelpUtility.getProduct();
        oProdWT.Name                                    =   'WT-TEST-PROD1';
        oProdWT.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c                          =   'Water Purifier';
        oProdWT.AOSI_Product_Code_for_Serial_Number__c  =   'B082';
        lInsertProd.add(oProdWT);
        insert lInsertProd;
        
        list<Asset> lInsertAsset  =  new list<Asset>();   
        Asset oAsset                        =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset.Name                         =   'B0820104041233';
        oAsset.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset);
        insert oAsset;
        
        Service_Engineer__c Service_Engineer1 = new Service_Engineer__c( Mobile_Number__c = '9988776654',Region__c = 'South',State__c='Karnatak' ,AOSI_City__c='Bangalore');
        insert Service_Engineer1 ;
        Service_Engineer__c Service_Engineer2 = new Service_Engineer__c( Mobile_Number__c = '8888888888',Region__c = 'South',State__c='Karnatak' ,AOSI_City__c='Bangalore');
        insert Service_Engineer2 ;
        
        Case oCase1                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                       =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Preferred_Color__c      =   'Blue';
        oCase1.Courier_Number__c            =   'COU123456';
        oCase1.Case_Type__c                 =   'Installation';
        insert oCase1;

        oCase1.Service_Engineer__c          =   Service_Engineer1.Id;
        update oCase1;
      
    
        /////////////////// Test for UpdateCasefromSMS Trigger /////////
        smagicinteract__Incoming_SMS__c inSMS1 = new smagicinteract__Incoming_SMS__c( smagicinteract__SMS_Text__c = 'AMC 12345678 '+oCase1.CaseNumber,smagicinteract__Mobile_Number__c='1234567',smagicinteract__external_field__c='12345');
         //insert inSMS1 ;
         smagicinteract__Incoming_SMS__c inSMS2 = new smagicinteract__Incoming_SMS__c( smagicinteract__SMS_Text__c = 'Start '+oCase1.CaseNumber,smagicinteract__Mobile_Number__c='12345678',smagicinteract__external_field__c='123456');
         
         //insert inSMS ;
        List<smagicinteract__Incoming_SMS__c > smslist = new List<smagicinteract__Incoming_SMS__c >();
        smslist.add(inSMS1);
        smslist.add(inSMS2);
         smagicinteract__Incoming_SMS__c inSMS3 = new smagicinteract__Incoming_SMS__c( smagicinteract__SMS_Text__c = 'COMPLETE'+oCase1.CaseNumber,smagicinteract__Mobile_Number__c='123456789',smagicinteract__external_field__c='1234564');
         smslist.add(inSMS3);
         //insert inSMS ;
         smagicinteract__Incoming_SMS__c inSMS4 = new smagicinteract__Incoming_SMS__c( smagicinteract__SMS_Text__c = 'YES'+oCase1.CaseNumber,smagicinteract__Mobile_Number__c='12345675',smagicinteract__external_field__c='1234575');
         smslist.add(inSMS4);
         //insert inSMS ;
         smagicinteract__Incoming_SMS__c inSMS5 = new smagicinteract__Incoming_SMS__c( smagicinteract__SMS_Text__c = 'NO'+oCase1.CaseNumber,smagicinteract__Mobile_Number__c='12345676',smagicinteract__external_field__c='1234586');
        smslist.add(inSMS5);
        
        Insert smslist;
        //insert inSMS ;
    test.stopTest();   
 }
}