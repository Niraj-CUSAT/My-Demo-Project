/*****************************************************************************************************************************************************
 * Class Name   : AOSI_CaseTriggerHandlerTest 
 * Created By   : Pooja P Bhat
 * Created Date : 7-SEPT-2015
 * Description  : Test Class for AOSI_CaseTrigger and AOSI_CaseTriggerHandler
 * Methods      : static testMethod void installationCaseTest()
                  static testMethod void colorPanelTest()
                  static testMethod void serviceCaseTest()
                  static testMethod void pmServiceCaseTest()
                  static testMethod void conReqCaseTest()
                  static testMethod void wttyRegCaseTest() 
                  static testMethod void dealerStockTest()
                  static testMethod void salesQueryTest()
                  static testMethod void myUnitTest()
******************************************************************************************************************************************************/
@isTest
private class AOSI_CaseTriggerHandlerTest {
    
    static testMethod void installationCaseTestWT() {
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
        
        Profile pASPAosi    =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
        Profile pSEAosi     =   [SELECT Id,Name FROM Profile WHERE Name = 'Service Executive AOSI' LIMIT 1];  
        User    uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
        User    uSEAosi     =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pSEAosi.Id AND IsActive = true LIMIT 1];

        ASP_Rate_Master__c oAspRateMaster   =   TestHelpUtility.getASPRateMaster('Test Rate Master', DefineConstant.PROD_VERTICAL_WH);
        insert oAspRateMaster;
            
        ASP__c oASP =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
        insert oASP;

        PIN_Allocation__c pinAlloc      =   TestHelpUtility.getPinAllocation('600114', oASP, uASPAosi);
        insert pinAlloc;
        
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Installation',oPinMasterSouth);
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
            Asset oAsset2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAsset2.Name                        =   'B0820104041233';
            oAsset2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAsset2);
            Asset oAssetC1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAssetC1.Name                        =   'B0820104041233';
            oAssetC1.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAssetC1);
            Asset oAssetC2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAssetC2.Name                        =   'B0820104041233';
            oAssetC2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAssetC2);
        insert lInsertAsset;
        
        list<Case> listCase             =   new list<Case>();
            Case oCase1                     =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
            oCase1.Reason                   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_City__c             =   'Chennai';
            oCase1.Quantity__c              =   '3';
            listCase.add(oCase1);
        insert listCase;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case> listChildCases   =   [Select Id,ParentId,Quantity__c,AssetId FROM Case WHERE ParentId =: oCase1.Id];
        listChildCases[0].AssetId   =   oAsset2.Id;
        try {
            update listChildCases[0];
        } catch ( Exception e ) { System.debug('***Exception installationCaseTest() update child case ***' + e); }
        
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case>  lstUpdateServEngg           =   new list<Case>();
            oCase1.Service_Engineer__c              =   oServEngg.Id;   
            lstUpdateServEngg.add(oCase1);
            listChildCases[0].Service_Engineer__c   =   oServEngg.Id;
            listChildCases[0].AssetId               =   oAssetC1.Id;
            lstUpdateServEngg.add(listChildCases[0]);
            listChildCases[1].Service_Engineer__c   =   oServEngg.Id;   
            lstUpdateServEngg.add(listChildCases[1]);
        update lstUpdateServEngg;
    
    test.stopTest();    
    
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Assignment_End_Time__c    =   System.now().addHours(2);
        oCase1.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
        oCase1.AOSI_Purchase_Value__c    =   10000;
        oCase1.AOSI_Water_Source__c      =   'All';
        oCase1.AOSI_pH__c                =   '15';
        oCase1.AOSI_Hardness__c          =   '300';
        oCase1.AOSI_TDS_Input__c         =   '1500';
        oCase1.AOSI_TDS_Output__c        =   '2500';
        oCase1.AOSI_Water_Storage__c     =   'Under ground tank';
        try {
            update oCase1;
        } catch ( Exception e ) { System.debug('***Exception installationCaseTest() update child case ***' + e); }
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case> listCloseCase        =   new list<Case>();
            oCase1.Assignment_Start_Time__c =   System.now().addMinutes(30);
        listCloseCase.add(oCase1);
        
        listChildCases[0].AOSI_Case_Close_Time__c   =   System.now().addHours(1);
        listChildCases[0].Status                    =   DefineConstant.CASE_STATUS_CLOSED;
        listChildCases[0].AOSI_Purchase_Value__c    =   10000;
        listChildCases[0].AOSI_Water_Source__c      =   'All';
        listChildCases[0].AOSI_pH__c                =   '15';
        listChildCases[0].AOSI_Hardness__c          =   '525';
        listChildCases[0].AOSI_TDS_Input__c         =   '1500';
        listChildCases[0].AOSI_TDS_Output__c        =   '2500';
        listChildCases[0].AOSI_Water_Storage__c     =   'Under ground tank';
        listCloseCase.add(listChildCases[0]);
        
        listChildCases[1].AOSI_Case_Close_Time__c   =   System.now().addHours(1);
        listChildCases[1].AssetId                   =   oAssetC2.Id;
        listChildCases[1].Status                    =   DefineConstant.CASE_STATUS_CLOSED;
        listChildCases[1].AOSI_Purchase_Value__c    =   10000;
        listChildCases[1].AOSI_Water_Source__c      =   'All';
        listChildCases[1].AOSI_pH__c                =   '15';
        listChildCases[1].AOSI_Hardness__c          =   '700';
        listChildCases[1].AOSI_TDS_Input__c         =   '1500';
        listChildCases[1].AOSI_TDS_Output__c        =   '2500';
        listChildCases[1].AOSI_Water_Storage__c     =   'Under ground tank';
        listCloseCase.add(listChildCases[1]);
        try {
        update listCloseCase; } catch ( Exception e ) { System.debug('***Exception installationCaseTest()  ***' + e); }
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Assignment_End_Time__c               =   System.now().addHours(2);
        oCase1.Status                               =   DefineConstant.CASE_STATUS_CLOSED;
        oCase1.AOSI_Purchase_Value__c               =   10000;
        oCase1.AOSI_Water_Source__c                 =   'All';
        oCase1.AOSI_pH__c                           =   '15';
        oCase1.AOSI_Hardness__c                     =   '300';
        oCase1.AOSI_TDS_Input__c                    =   '1500';
        oCase1.AOSI_TDS_Output__c                   =   '2500';
        oCase1.AOSI_Water_Storage__c                =   'Under ground tank';
        oCase1.Case_Type__c                         =   DefineConstant.CASE_TYPE_INSTALLATION;
        oCase1.SMS_SENT_TO_CONTACT_FOR_FEEDBACK__c  = false;
        try {
        update oCase1; } catch ( Exception e ) { System.debug('***Exception installationCaseTest()  ***' + e); }
        
        Case oCase3                     =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCase3.Reason                   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCase3.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCase3.AOSI_City__c             =   'Chennai';
        try {
            insert oCase3;
        } catch (Exception e) { System.debug('*** Exception Only one installation case can be registered***'+e); }
    }   //End of installationCaseTestWT
    
    static testMethod void installationCaseTestWH() {
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
            
            Profile pASPAosi    =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
            Profile pSEAosi     =   [SELECT Id,Name FROM Profile WHERE Name = 'Service Executive AOSI' LIMIT 1];  
            User    uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
            User    uSEAosi     =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pSEAosi.Id AND IsActive = true LIMIT 1];
    
            ASP_Rate_Master__c oAspRateMaster   =   TestHelpUtility.getASPRateMaster('Test Rate Master', DefineConstant.PROD_VERTICAL_WH);
            insert oAspRateMaster;
                
            ASP__c oASP =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
            insert oASP;
    
            PIN_Allocation__c pinAlloc      =   TestHelpUtility.getPinAllocation('600114', oASP, uASPAosi);
            insert pinAlloc;
            
            Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
            insert oServEngg;
            
            Account oAcc                    =   TestHelpUtility.getNewAccount('Test Installation',oPinMasterSouth);
            insert oAcc;
            
            Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
            insert oContactSouth;
            
            list<Product2> lInsertProd                      =   new list<Product2>();
                Product2 oProdWH                                =   TestHelpUtility.getProduct();
                oProdWH.Name                                    =   'WH-TEST-PROD1';
                oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
                oProdWH.AOSI_Family__c                          =   'Storage';
                oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
                lInsertProd.add(oProdWH);       
            insert lInsertProd;
            
            list<Asset> lInsertAsset  =  new list<Asset>();
                Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
                oAsset1.Name                        =   'B0800104041234';
                lInsertAsset.add(oAsset1);   
            insert lInsertAsset;
            
            list<Case> listCase =   new list<Case>();
                Case oCase2                     =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
                oCase2.Reason                   =   DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION;
                oCase2.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION;
                listCase.add(oCase2);
            insert listCase;
            
            AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
            AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
            list<Case>  lstUpdateServEngg               =   new list<Case>();
                oCase2.AOSI_Appointment_Date__c         =   System.now().addMinutes(5);
                oCase2.Assignment_Start_Time__c         =   System.now().addMinutes(45);
                oCase2.Service_Engineer__c              =   oServEngg.Id;   
                lstUpdateServEngg.add(oCase2);
            update lstUpdateServEngg;
    
        test.stopTest();
    
            AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
            AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
            list<Case> listCloseCase        =   new list<Case>();
                oCase2.Assignment_End_Time__c   =   System.now().addHours(2);
            listCloseCase.add(oCase2);
            try {
            update listCloseCase; } catch ( Exception e ) { System.debug('***Exception installationCaseTest()  ***' + e); }
    
    }   //End of installationCaseTestWH()

    
    static testMethod void colorPanelTest() {
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
       
        Service_Engineer__c oServEngg               =   TestHelpUtility.getResource();
        oServEngg.AOSI_Service_Engineer_Email__c    =   'test@test.com';
        insert oServEngg;
        
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
        
        list<Case> lstColorPanelCase        =   new list<Case>();
        Case oCase1                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                       =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Preferred_Color__c      =   'Ivory';
        oCase1.Courier_Number__c            =   'COU123456';
        lstColorPanelCase.add(oCase1);
        Case oCase2                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase2.Reason                       =   DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE;
        oCase2.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE;
        oCase2.AOSI_Preferred_Color__c      =   'Red Brick';
        lstColorPanelCase.add(oCase2);
        insert lstColorPanelCase;
        
        list<Case> qCase = [SELECT Id,CaseNumber,AOSI_Warranty_Status_I__c,Reason,AOSI_Customer_Concern__c,AOSI_Preferred_Color__c,Contact_Name__c,Contact_Phone__c,Contact_Other_Phone__c,AOSI_Model__c,Contact_Address__c,Contact_MailingPostalCode__c FROM CASE];

        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case> lstUpdateServEngg        =   new list<Case>();
        oCase1.RecordTypeId                 =   caseAOSIRecTy;
        oCase1.Service_Engineer__c          =   oServEngg.Id;
        lstUpdateServEngg.add(oCase1);
        oCase2.Service_Engineer__c          =   oServEngg.Id;
        lstUpdateServEngg.add(oCase2);
        update lstUpdateServEngg;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case> listCloseCase        =   new list<Case>();
        
        oCase1.AOSI_Case_Close_Time__c   =   System.now().addHours(1);
        oCase1.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
        oCase1.AOSI_Water_Source__c      =   'All';
        oCase1.AOSI_pH__c                =   '15';
        oCase1.AOSI_Hardness__c          =   '525';
        oCase1.AOSI_TDS_Input__c         =   '1500';
        oCase1.AOSI_TDS_Output__c        =   '2500';
        oCase1.AOSI_Water_Storage__c     =   'Under ground tank';
        listCloseCase.add(oCase1);
        
        oCase2.AOSI_Case_Close_Time__c   =   System.now().addHours(1);
        oCase2.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
        oCase2.AOSI_Water_Source__c      =   'All';
        oCase2.AOSI_pH__c                =   '15';
        oCase2.AOSI_Hardness__c          =   '700';
        oCase2.AOSI_TDS_Input__c         =   '1500';
        oCase2.AOSI_TDS_Output__c        =   '2500';
        oCase2.AOSI_Water_Storage__c     =   'Under ground tank';
        oCase2.Courier_Number__c         =   'COU133225';
        listCloseCase.add(oCase2);
        update listCloseCase;
       test.stopTest();
    }
    
    static testMethod void serviceCaseTest() {
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
       
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Service Case',oPinMasterSouth);
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
        
        list<Asset> lInsertAsset            =   new list<Asset>();   
        Asset oAsset                        =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset.Name                         =   'B0820104041233';
        oAsset.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset);
        insert oAsset;
        
        Case oCase                          =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase.Reason                        =   DefineConstant.CASE_REASON_SERVICE;
        oCase.AOSI_Customer_Concern__c      =   'Bad Smell';
        try {
            insert oCase;
        } catch ( Exception e ) { System.debug('*** Exception Selected customer concern doesnot relate to product *** '+e); }
        
        list<Customer_Concern__c> listCC    =   new list<Customer_Concern__c>();
        Customer_Concern__c accessoryMissCC =   TestHelpUtility.getCustomerConcern('Accessory Missing', 'Accessory Missing');
        listCC.add(accessoryMissCC);
        Customer_Concern__c crticalIssue =   TestHelpUtility.getCustomerConcern('Critical Issue/Smell', 'Critical Issue/Smell');
        listCC.add(crticalIssue);
        insert listCC;
        
        list<Product_Customer_Concern__c> lstPCC    =   new list<Product_Customer_Concern__c>();
        Product_Customer_Concern__c oPCC1           =   TestHelpUtility.getProductCustomerConcern(accessoryMissCC, oProdWT);
        lstPCC.add(oPCC1);
        Product_Customer_Concern__c oPCC2           =   TestHelpUtility.getProductCustomerConcern(crticalIssue, oProdWT);
        lstPCC.add(oPCC2);
        insert lstPCC;
        
        Case oCase1                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                       =   DefineConstant.CASE_REASON_SERVICE;
        oCase1.AOSI_Customer_Concern__c     =   'Critical Issue/Smell';
        insert oCase1;
        
        Case_Customer_Concern__c oCCC = new Case_Customer_Concern__c();
        oCCC.Customer_Concern__c    =   'Critical Issue/Smell';
        oCCC.Cause__c               =   'Missing';
        oCCC.Action__c              =   'Provided';
        oCCC.Case__c                =   oCase1.Id;
        insert oCCC;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Service_Engineer__c          =   oServEngg.Id;
        oCase1.Assignment_Start_Time__c     =   System.now().addHours(45);
        oCase1.AOSI_Customer_Concern__c     =   'Accessory Missing';
        try{
            update oCase1; } catch(Exception e) {System.debug('Exception*** '+e);}
        
        Spares__c oSpare                =   new Spares__c();
        oSpare.Name                     =   'Test SPARE';
        oSpare.Type__c                  =   'Accessory';
        oSpare.Related_Products__c      =   oProdWT.Name;
        oSpare.Part_Code__c             =   'TEST123';
        oSpare.Active__c                =   true;
        oSpare.MRP__c                   =   1500;
        oSpare.Family__c                =   'Water Purifier';
        oSpare.Part_Type__c             =   'Filter';
        insert oSpare;

        Spare_Product_Junction__c oSPJ  =   new Spare_Product_Junction__c();
        oSPJ.Spares__c                  =   oSpare.Id;
        oSPJ.Product__c                 =   oProdWT.Id;
        insert oSPJ;

        Service_Charges__c oServCharge  =   new Service_Charges__c();
        oServCharge.Case__c             =   oCase1.Id;
        oServCharge.Type__c             =   'Accessory';
        oServCharge.Quantity__c         =   1;
        oServCharge.Chargable__c        =   'Yes';
        insert oServCharge;
      
       test.stopTest();  
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Assignment_End_Time__c               =   System.now().addHours(2);
        oCase1.Status                               =   DefineConstant.CASE_STATUS_CLOSED;
        oCase1.AOSI_Water_Source__c                 =   'All';
        oCase1.AOSI_pH__c                           =   '15';
        oCase1.AOSI_Hardness__c                     =   '300';
        oCase1.AOSI_TDS_Input__c                    =   '1500';
        oCase1.AOSI_TDS_Output__c                   =   '2500';
        oCase1.AOSI_Water_Storage__c                =   'Under ground tank';
        oCase1.Case_Type__c                         =   DefineConstant.CASE_TYPE_COMPLAINT_REG;
        oCase1.SMS_SENT_TO_CONTACT_FOR_FEEDBACK__c  =   false;
        try{
            update oCase1; } catch(Exception e) {System.debug('Exception*** '+e);}
        
        Case oCase2                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase2.Reason                       =   DefineConstant.CASE_REASON_SERVICE;
        oCase2.AOSI_Customer_Concern__c     =   'Critical Issue/Smell';
        oCase2.CC_SSV__c                    =   true;
        oCase2.Description                  =   'Service case solved over phone';
        try{
            insert oCase2; } catch(Exception e) {System.debug('Exception*** '+e);}
     }
    
    static testMethod void pmServiceCaseTest() {
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
       
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test PM Service Case',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        list<Product2> lInsertProd                              =   new list<Product2>();   
        Product2 oProdWT                                        =   TestHelpUtility.getProduct();
        oProdWT.Name                                            =   'WT-TEST-PROD1';
        oProdWT.AOSI_Vertical__c                                =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c                                  =   'Water Purifier';
        oProdWT.AOSI_Product_Code_for_Serial_Number__c          =   'B082';
        lInsertProd.add(oProdWT);
        Product2 oProdWTReplace                                 =   TestHelpUtility.getProduct();
        oProdWTReplace.Name                                     =   'WT-TEST-PROD1';
        oProdWTReplace.AOSI_Vertical__c                         =   DefineConstant.PROD_VERTICAL_WT;
        oProdWTReplace.AOSI_Family__c                           =   'Water Purifier';
        oProdWTReplace.AOSI_Product_Code_for_Serial_Number__c   =   'B085';
        lInsertProd.add(oProdWTReplace);
        insert lInsertProd;
        
        list<Asset> lInsertAsset                =   new list<Asset>();   
        Asset oAsset                            =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset.Name                             =   'B0820104041233';
        oAsset.AOSI_Membrane_Warranty__c        =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset);
        Asset oAssetReplace                     =   TestHelpUtility.getAsset(oContactSouth, oProdWTReplace);
        oAssetReplace.Name                      =   'B0850104041233';
        oAssetReplace.AOSI_Membrane_Warranty__c =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetReplace);
        insert lInsertAsset;
        
        Case oCase                          =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase.Reason                        =   DefineConstant.CASE_REASON_PM_SERVICE;
        oCase.AOSI_Customer_Concern__c      =   'PM Service 1';
        insert oCase;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase.AOSI_Replaced_Asset__c        =   oAssetReplace.Id;
        update oCase;
        
        Case oCase1                          =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                        =   DefineConstant.CASE_REASON_PM_SERVICE;
        oCase1.AOSI_Customer_Concern__c      =   'PM Service 1';
        try {
            insert oCase1;
        } catch (Exception e) { System.debug('Exception already open case exist for the same reason'+e); }
    }
            
    static testMethod void conReqCaseTest() {
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
        
        list<City_Master__c> lInsertCityMaster  =  new list<City_Master__c>(); 
        City_Master__c cityMasterSouth  =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');          lInsertCityMaster.add(cityMasterSouth);
        City_Master__c cityMasterNorth  =   TestHelpUtility.getCityMaster('Allahabad', 'North', 'Uttar Pradesh', 'Allahabad');  lInsertCityMaster.add(cityMasterNorth);
        City_Master__c cityMasterEast   =   TestHelpUtility.getCityMaster('Kolkata', 'East', 'West Bengal', 'Kolkata');         lInsertCityMaster.add(cityMasterEast);
        City_Master__c cityMasterWest   =   TestHelpUtility.getCityMaster('Amreli', 'West', 'Gujarat', 'Amreli');               lInsertCityMaster.add(cityMasterWest);
        insert lInsertCityMaster;

        
        list<Pin_Master__c> lInsertPinMaster    =   new list<Pin_Master__c>();
        Pin_Master__c oPinMasterSouth   =   TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');        lInsertPinMaster.add(oPinMasterSouth);  
        Pin_Master__c oPinMasterNorth   =   TestHelpUtility.getPinMaster('212303', 'North', 'Allahabad', 'Uttar Pradesh');  lInsertPinMaster.add(oPinMasterNorth);
        Pin_Master__c oPinMasterEast    =   TestHelpUtility.getPinMaster('700108', 'East', 'Kolkata', 'West Bengal');       lInsertPinMaster.add(oPinMasterEast);
        Pin_Master__c oPinMasterWest    =   TestHelpUtility.getPinMaster('365430', 'West', 'Amreli', 'Gujarat');            lInsertPinMaster.add(oPinMasterWest);
        insert lInsertPinMaster; 
 
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Contract Request',oPinMasterSouth);
        insert oAcc;
        
        list<Contact> lInsertContact  =  new list<Contact>();
        Contact oContactSouth   = TestHelpUtility.getContact(oAcc, oPinMasterSouth);    lInsertContact.add(oContactSouth);
        Contact oContactNorth   = TestHelpUtility.getContact(oAcc, oPinMasterNorth);    lInsertContact.add(oContactNorth);
        Contact oContactEast   = TestHelpUtility.getContact(oAcc, oPinMasterEast);      lInsertContact.add(oContactEast);
        Contact oContactWest   = TestHelpUtility.getContact(oAcc, oPinMasterWest);      lInsertContact.add(oContactWest);
        insert lInsertContact;
        
        list<AMC_Master__c> lInsrtAMC   =   new list<AMC_Master__c>();
        AMC_Master__c amcWH  = TestHelpUtility.getAMC('Test AMC WH', 5000, DefineConstant.AMC_WH_AMC);      lInsrtAMC.add(amcWH);
        AMC_Master__c amcWT  = TestHelpUtility.getAMC('Test AMC WT', 3000, DefineConstant.AMC_WT_AMC);      lInsrtAMC.add(amcWT);
        AMC_Master__c acmcWT = TestHelpUtility.getAMC('Test ACMC WT', 2000, DefineConstant.AMC_WT_ACMC);    lInsrtAMC.add(acmcWT);
        AMC_Master__c fltWT  = TestHelpUtility.getAMC('Test FLT WT', 1000, DefineConstant.AMC_WT_FP);       lInsrtAMC.add(fltWT);
        insert lInsrtAMC;
        
        list<Product2> lInsertProd                          =   new list<Product2>();
        Product2 oProdWH1                                   =   TestHelpUtility.getProduct();
        oProdWH1.Name                                       =   'WH-TEST-PROD1';
        oProdWH1.AOSI_Vertical__c                           =   DefineConstant.PROD_VERTICAL_WH;
        oProdWH1.AOSI_Family__c                             =   'Storage';
        oProdWH1.AOSI_Product_Code_for_Serial_Number__c     =   'B080';
        lInsertProd.add(oProdWH1);
        Product2 oProdWH2                                   =   TestHelpUtility.getProduct();
        oProdWH2.Name                                       =   'WH-TEST-PROD2';
        oProdWH2.AOSI_Vertical__c                           =   DefineConstant.PROD_VERTICAL_WH;
        oProdWH2.AOSI_Family__c                             =   'Storage';
        oProdWH2.AOSI_Product_Code_for_Serial_Number__c     =   'B081';
        lInsertProd.add(oProdWH2);
        Product2 oProdWT1                                   =   TestHelpUtility.getProduct();
        oProdWT1.Name                                       =   'WT-TEST-PROD1';
        oProdWT1.AOSI_Vertical__c                           =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT1.AOSI_Family__c                             =   'Water Purifier';
        oProdWT1.AOSI_Product_Code_for_Serial_Number__c     =   'B082';
        lInsertProd.add(oProdWT1);
        insert lInsertProd;
        
        list<Product_AMC_Junction__c> lInsrtPAMC = new list<Product_AMC_Junction__c>();
        Product_AMC_Junction__c pamc1   =   TestHelpUtility.getProductAMCJunction(amcWH, oProdWH1);     lInsrtPAMC.add(pamc1);
        Product_AMC_Junction__c pamc2   =   TestHelpUtility.getProductAMCJunction(amcWT, oProdWT1);     lInsrtPAMC.add(pamc2);
        Product_AMC_Junction__c pamc3   =   TestHelpUtility.getProductAMCJunction(acmcWT, oProdWT1);    lInsrtPAMC.add(pamc3);
        Product_AMC_Junction__c pamc4   =   TestHelpUtility.getProductAMCJunction(fltWT, oProdWT1);     lInsrtPAMC.add(pamc4);
        insert lInsrtPAMC;
        
        list<Asset> lInsertAsset  =  new list<Asset>();
        Asset oAssetSouth1                      =   TestHelpUtility.getAsset(oContactSouth, oProdWH1);
        oAssetSouth1.Name                       =   'B0800104041234';
        lInsertAsset.add(oAssetSouth1);
        Asset oAssetSouth2                      =   TestHelpUtility.getAsset(oContactSouth, oProdWH2);
        oAssetSouth2.Name                       =   'B0810104041234';
        lInsertAsset.add(oAssetSouth2);
        Asset oAssetNorth                       =   TestHelpUtility.getAsset(oContactNorth, oProdWT1);
        oAssetNorth.Name                        =   'B0820104041231';
        oAssetNorth.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetNorth);       
        Asset oAssetWest                        =   TestHelpUtility.getAsset(oContactWest, oProdWT1);
        oAssetWest.Name                         =   'B0820104041232';
        oAssetWest.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetWest);
        Asset oAssetEast                        =   TestHelpUtility.getAsset(oContactEast, oProdWT1);
        oAssetEast.Name                         =   'B0820104041233';
        oAssetEast.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetEast);
        insert lInsertAsset;
        
        list<Case> lInsertCase  =   new list<Case>();
        Case c1         =   TestHelpUtility.getCase(oContactSouth, oAssetSouth1, oProdWH1);
        c1.RecordTypeId =   caseAOSIRecTy;
        c1.Reason       =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        c1.AOSI_Customer_Concern__c  =  DefineConstant.CASE_REASON_CONTRACT_REQUEST;     
        lInsertCase.add(c1);
        Case c2         =   TestHelpUtility.getCase(oContactNorth, oAssetNorth, oProdWT1);
        c2.Reason       =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        c2.AOSI_Customer_Concern__c  =  DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(c2);
        Case c3         =   TestHelpUtility.getCase(oContactWest, oAssetWest, oProdWT1);
        c3.Reason       =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        c3.AOSI_Customer_Concern__c  =  DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(c3);
        Case c4         =   TestHelpUtility.getCase(oContactEast, oAssetEast, oProdWT1);
        c4.Reason       =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        c4.AOSI_Customer_Concern__c  =  DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        lInsertCase.add(c4);
        insert lInsertCase;
        
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        list<Case> lUpdateCase  =   new list<Case>();
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive = false;
        c1.AOSI_AMC_Pin__c  =   'AMC 12345';    lUpdateCase.add(c1);        
        c2.AOSI_AMC_Pin__c  =   'AMC 32145';    lUpdateCase.add(c2);
        c3.AOSI_AMC_Pin__c  =   'ACMC 12345';   lUpdateCase.add(c3);
        c4.AOSI_AMC_Pin__c  =   'FLT 12345';    lUpdateCase.add(c4);
        update lUpdateCase;
        
        Case c5                     =   TestHelpUtility.getCase(oContactSouth, oAssetSouth2, oProdWH2);
        c5.Reason                   =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        c5.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        try {
            insert c5;
        } catch ( Exception e ) { System.debug('*** ConReqCaseTest() insert case ' + e); }
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        c2.Status                   =   DefineConstant.CASE_STATUS_CLOSED;
        c2.AOSI_Case_Close_Time__c  =   System.now();
        try {
            update c2;
        } catch ( Exception e ) { System.debug('*** ConReqCaseTest() update case ' + e);}
      test.stopTest();
    }
    
    static testMethod void wttyRegCaseTest() {
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
        
        Profile pSEAosi     =   [SELECT Id,Name FROM Profile WHERE Name = 'Service Executive AOSI' LIMIT 1];
        User    uSEAosi     =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pSEAosi.Id AND IsActive = true LIMIT 1];
        
        PIN_Allocation__c oPinAlloc     =   TestHelpUtility.getPinAllocation('600114', new ASP__c(), uSEAosi);
        insert oPinAlloc;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Warranty Registration',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           = TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        Product2 oProdWH                =   TestHelpUtility.getProduct();
        oProdWH.AOSI_Vertical__c        =   DefineConstant.PROD_VERTICAL_WH;
        insert oProdWH;
        
        Asset oAssetSouth               =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
        oAssetSouth.Name                =   'B0800104041234';
        insert oAssetSouth;
        
        Case oCase                      =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWH);
        oCase.Reason                    =   DefineConstant.CASE_REASON_WARRANTY_REG;
        oCase.AOSI_Customer_Concern__c  =   DefineConstant.CASE_REASON_WARRANTY_REG;
        insert oCase;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive = false;
        oCase.AOSI_Call_Escalated__c    =   true;
        try {
            update oCase;
        } catch ( Exception e ) { System.debug('*** Exception wttry reg case ***' + e); }
      test.stopTest();
      
        Case oCaseQueried   =   [SELECT Id,CaseNumber,Contact_Phone__c,Service_Engineer_Phone__c,CreatedDate,LastModifiedDate FROM CASE WHERE Id =: oCase.Id LIMIT 1 ];
        AOSI_CaseTriggerHandler caseTrigger =   new AOSI_CaseTriggerHandler();
        caseTrigger.toScheduleSMS (oCaseQueried, 'Test Schedule SMS', true, true);
    }
    
    static testMethod void dealerStockTest() {
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
        
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test DealerStock',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           = TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        Product2 oProdWH                =   TestHelpUtility.getProduct();
        oProdWH.AOSI_Vertical__c        =   DefineConstant.PROD_VERTICAL_WH;
        insert oProdWH;
        
        Asset oAssetSouth               =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
        oAssetSouth.Name                =   'B0800104041234';
        insert oAssetSouth;
        
        Case oCase1                      =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWH);
        oCase1.Reason                    =   DefineConstant.CASE_REASON_DEALER_STOCK;
        oCase1.AOSI_Customer_Concern__c  =   DefineConstant.CASE_REASON_DEALER_STOCK;
        insert oCase1;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Status                           =   DefineConstant.CASE_STATUS_ON_HOLD;
        oCase1.AOSI_Cancelled_On_HOLD_Reason__c =   DefineConstant.REFUND_PROCESSING;
        oCase1.AOSI_Appointment_Date__c         =   system.today().addDays(1);
        oCase1.Service_Engineer__c              =   oServEngg.Id;
        update oCase1;
       
      test.stopTest();
       
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.AOSI_Cancelled_On_HOLD_Reason__c =   DefineConstant.REPLACEMENT_PROCESSING;
        oCase1.AOSI_SYS_SMS_to_Cust__c          =   true;
        update oCase1;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Status                           = DefineConstant.CASE_STATUS_CANCELLED;
        oCase1.AOSI_Cancelled_On_HOLD_Reason__c = 'Cancelled by Customer';
        update oCase1;
        
        Case oCase2                      =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWH);
        oCase2.Reason                    =   DefineConstant.CASE_REASON_DEALER_STOCK;
        oCase2.AOSI_Customer_Concern__c  =   DefineConstant.CASE_REASON_DEALER_STOCK;
        try {
            insert oCase2;
        } catch ( Exception e ) { System.debug('*** Exception insert Dealer Stock'+e); }
      
    }
    
     static testMethod void salesQueryTest() {
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
                     
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test SalesQuery',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           = TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        list<Product2> lInsertProd                      =   new list<Product2>();
        Product2 oProdWH                                =   TestHelpUtility.getProduct();
        oProdWH.Name                                    =   'WH-TEST-PROD1';
        oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
        oProdWH.AOSI_Family__c                          =   'Storage';
        oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
        lInsertProd.add(oProdWH);       
        Product2 oProdWT                                =   TestHelpUtility.getProduct();
        oProdWT.Name                                    =   'WT-TEST-PROD1';
        oProdWT.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c                          =   'Water Purifier';
        oProdWT.AOSI_Product_Code_for_Serial_Number__c  =   'B082';
        lInsertProd.add(oProdWT);
        insert lInsertProd;
        
        list<Asset> lInsertAsset  =  new list<Asset>();
        Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
        oAsset1.Name                        =   'B0800104041234';
        lInsertAsset.add(oAsset1);        
        Asset oAsset2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset2.Name                        =   'B0820104041233';
        oAsset2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset2);
        Asset oAsset3                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset3.Name                        =   'B0820104041233';
        oAsset3.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset3);
        Asset oAssetC2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAssetC2.Name                        =   'B0820104041233';
        oAssetC2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetC2);
        insert lInsertAsset;
        
        Service_Engineer__c oServEngg1    =   TestHelpUtility.getResource();  
        oServEngg1.Name                   =   'Test Resource1';
        oServEngg1.Mobile_Number__c       =   '9773587451';
        insert oServEngg1;
        Service_Engineer__c oServEngg2    =   TestHelpUtility.getResource();  
        oServEngg2.Name                   =   'Test Resource2';
        oServEngg2.Mobile_Number__c       =   '9773587452';
        insert oServEngg2;
        
        Case oCase1                             =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCase1.Reason                           =   DefineConstant.CASE_REASON_SALES_QUERY;
        oCase1.AOSI_Customer_Concern__c         =   'Interested in Buying';
        oCase1.AOSI_Sales_Query_Reference__c    =   'Canopy';
        oCase1.AOSI_Category_of_Sales_Query__c  =   'Interested';
        oCase1.AOSI_Vertical__c                 =   DefineConstant.PROD_VERTICAL_WH;
        insert oCase1;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Status                           =   DefineConstant.CASE_STATUS_ON_HOLD;
        oCase1.AOSI_Cancelled_On_HOLD_Reason__c =   'Customer Requested Reappointment';
        oCase1.AOSI_Appointment_Date__c         =   system.now().addMinutes(10);
        update oCase1; 
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.AOSI_Cancelled_On_HOLD_Reason__c =   DefineConstant.PART_PENDNG_TECHNICIAN;
        oCase1.AOSI_Appointment_Date__c         =   system.now().addDays(1);
        oCase1.Service_Engineer__c              =   oServEngg1.Id;
        update oCase1; 
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.AOSI_Appointment_Date__c         =   system.now().addDays(2);
        oCase1.AOSI_Resend_SMS__c               =   true;
        oCase1.Service_Engineer__c              =   oServEngg2.Id;
        update oCase1; 
        
       test.stopTest();
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        oCase1.AOSI_Appointment_Date__c         =   system.now().addDays(3);
        update oCase1; 
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        oCase1.AOSI_Appointment_Date__c         =   system.now().addDays(4);
        update oCase1; 
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        oCase1.AOSI_Appointment_Date__c         =   system.now().addDays(5);
        try {
            update oCase1; 
        } catch ( Exception e ) { System.debug('*** Exception while updating SalesQuery OnHold 6th time ' + e); }
       
        Case oCase2                             =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCase2.Reason                           =   DefineConstant.CASE_REASON_SALES_QUERY;
        oCase2.AOSI_Customer_Concern__c         =   'Interested in Buying';
        oCase2.AOSI_Sales_Query_Reference__c    =   'Canopy';
        oCase2.AOSI_Category_of_Sales_Query__c  =   'Interested';
        oCase2.AOSI_Vertical__c                 =   DefineConstant.PROD_VERTICAL_WT;
        insert oCase2;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase2.Status                           = DefineConstant.CASE_STATUS_CANCELLED;
        oCase2.AOSI_Cancelled_On_HOLD_Reason__c = 'Cancelled by Customer';
        update oCase2;
        
        Case oCase3                             =   TestHelpUtility.getCase(oContactSouth, oAsset3, oProdWT);
        oCase3.Reason                           =   DefineConstant.CASE_REASON_SALES_QUERY;
        oCase3.AOSI_Customer_Concern__c         =   'Interested in Buying';
        oCase3.AOSI_Sales_Query_Reference__c    =   'Canopy';
        oCase3.AOSI_Category_of_Sales_Query__c  =   'Interested';
        oCase3.AOSI_Vertical__c                 =   DefineConstant.PROD_VERTICAL_WT;
        insert oCase3;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase3.Status                   =   DefineConstant.CASE_STATUS_CLOSED;
        oCase3.AOSI_Case_Close_Time__c  =   System.now();
        oCase3.Service_Engineer__c      =   oServEngg1.Id;
        update oCase3;
    }
    
    static testMethod void myUnitTest() {
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

        Service_Engineer__c oServEngg1    =   TestHelpUtility.getResource();  
        oServEngg1.Name                   =   'Test Resource1';
        oServEngg1.Mobile_Number__c       =   '9773587451';
        insert oServEngg1;
        Service_Engineer__c oServEngg2    =   TestHelpUtility.getResource();  
        oServEngg2.Name                   =   'Test Resource2';
        oServEngg2.Mobile_Number__c       =   '9773587452';
        insert oServEngg2;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Cases',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        list<Product2> lInsertProd                      =   new list<Product2>();
        Product2 oProdWH                                =   TestHelpUtility.getProduct();
        oProdWH.Name                                    =   'WH-TEST-PROD1';
        oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
        oProdWH.AOSI_Family__c                          =   'Storage';
        oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
        lInsertProd.add(oProdWH);       
        Product2 oProdWT                                =   TestHelpUtility.getProduct();
        oProdWT.Name                                    =   'WT-TEST-PROD1';
        oProdWT.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c                          =   'Water Purifier';
        oProdWT.AOSI_Product_Code_for_Serial_Number__c  =   'B082';
        lInsertProd.add(oProdWT);
        insert lInsertProd;
        
        list<Asset> lInsertAsset  =  new list<Asset>();
        Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
        oAsset1.Name                        =   'B0800104041234';
        lInsertAsset.add(oAsset1);        
        Asset oAsset2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset2.Name                        =   'B0820104041233';
        oAsset2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset2);
        Asset oAssetC1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAssetC1.Name                        =   'B0820104041233';
        oAssetC1.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetC1);
        Asset oAssetC2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAssetC2.Name                        =   'B0820104041233';
        oAssetC2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAssetC2);
        insert lInsertAsset;
        
        list<Customer_Concern__c> listCC    =   new list<Customer_Concern__c>();
        Customer_Concern__c accessoryMissCC =   TestHelpUtility.getCustomerConcern('Accessory Missing', 'Accessory Missing');
        listCC.add(accessoryMissCC);
        Customer_Concern__c crticalIssue =   TestHelpUtility.getCustomerConcern('Critical Issue/Smell', 'Critical Issue/Smell');
        listCC.add(crticalIssue);
        insert listCC;
        
        list<Product_Customer_Concern__c> lstPCC    =   new list<Product_Customer_Concern__c>();
        Product_Customer_Concern__c oPCC1           =   TestHelpUtility.getProductCustomerConcern(accessoryMissCC, oProdWH);
        lstPCC.add(oPCC1);
        Product_Customer_Concern__c oPCC2           =   TestHelpUtility.getProductCustomerConcern(crticalIssue, oProdWT);
        lstPCC.add(oPCC2);
        insert lstPCC;
        
        list<Case> listCase                         =   new list<Case>();
        Case oCaseWH1                               =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCaseWH1.Reason                             =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseWH1.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseWH1.AOSI_City__c                       =   'Chennai';
        listCase.add(oCaseWH1);
        Case oCaseWH2                               =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCaseWH2.Reason                             =   DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION;
        oCaseWH2.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION;
        listCase.add(oCaseWH2);
        Case oCaseWH3                               =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCaseWH3.Reason                             =   DefineConstant.CASE_REASON_DEALER_STOCK;
        oCaseWH3.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_DEALER_STOCK;
        listCase.add(oCaseWH3);
        Case oCaseWH4                               =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCaseWH4.Reason                             =   DefineConstant.CASE_REASON_SERVICE;
        oCaseWH4.AOSI_Customer_Concern__c           =   'Accessory Missing';        
        listCase.add(oCaseWH4);
        Case oCaseWH5                               =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCaseWH5.Reason                             =   DefineConstant.CASE_REASON_EXCHANGE_PICKUP;
        oCaseWH5.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_EXCHANGE_PICKUP;
        listCase.add(oCaseWH5);
        Case oCaseWH6                               =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCaseWH6.Reason                             =   DefineConstant.CASE_REASON_SYSTEM_TESTING;
        oCaseWH6.AOSI_Customer_Concern__c           =   'Accessory Missing';
        listCase.add(oCaseWH6);
        
        Case oCaseWT1                               =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCaseWT1.Reason                             =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseWT1.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseWT1.AOSI_City__c                       =   'Chennai';
        listCase.add(oCaseWT1);
        Case oCaseWT2                               =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCaseWT2.Reason                             =   DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION;
        oCaseWT2.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION;
        listCase.add(oCaseWT2);
        Case oCaseWT3                               =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCaseWT3.Reason                             =   DefineConstant.CASE_REASON_DEALER_STOCK;
        oCaseWT3.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_DEALER_STOCK;
        listCase.add(oCaseWT3);
        Case oCaseWT4                               =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCaseWT4.Reason                             =   DefineConstant.CASE_REASON_SERVICE;
        oCaseWT4.AOSI_Customer_Concern__c           =   'Critical Issue/Smell'; 
        listCase.add(oCaseWT4);
        Case oCaseWT5                               =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCaseWT5.Reason                             =   DefineConstant.CASE_REASON_EXCHANGE_PICKUP;
        oCaseWT5.AOSI_Customer_Concern__c           =   DefineConstant.CASE_REASON_EXCHANGE_PICKUP;
        listCase.add(oCaseWT5);
        Case oCaseWT6                               =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
        oCaseWT6.Reason                             =   DefineConstant.CASE_REASON_SYSTEM_TESTING;
        oCaseWT6.AOSI_Customer_Concern__c           =   'Accessory Missing';
        listCase.add(oCaseWT6);
        
        insert listCase;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case> updateServEngg       =   new list<Case>();
        oCaseWT1.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWT1);
        oCaseWT2.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWT2);
        oCaseWT3.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWT3);
        oCaseWT4.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWT4);
        oCaseWT5.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWT5);
        oCaseWT6.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWT6);
        
        oCaseWH1.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWH1);
        oCaseWH2.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWH2);
        oCaseWH3.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWH3);
        oCaseWH4.Service_Engineer__c    =   oServEngg1.Id;  updateServEngg.add(oCaseWH4);
        update updateServEngg;
        
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCaseWH5.Service_Engineer__c    =   oServEngg1.Id;  
        try {
            update oCaseWH5;
        } catch (Exception e) {System.debug('**Exception ServEngg cannot be allocated to more than 10 open cases***'+e);}
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        
        Attendence__c attendQuery    =    [SELECT Id,AOSI_Present__c,AOSI_Date__c,AOSI_Service_Engineer__c FROM Attendence__c WHERE AOSI_Service_Engineer__c=: oServEngg2.Id LIMIT 1];
        attendQuery.AOSI_Present__c             =   false;
        attendQuery.AOSI_Date__c                =   System.today();
        attendQuery.AOSI_Service_Engineer__c    =   oServEngg2.Id;
        update attendQuery;
        
        oCaseWH6.Service_Engineer__c    =   oServEngg2.Id;  
        try{
            update oCaseWH6;
        } catch (Exception e) {System.debug('**Exception ServEngg cannot be assigned to case on absent day***'+e);}
       test.stopTest();
    }
    static testMethod void caseCommentTestMethod() {
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
        
        Profile pASPAosi    =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
        Profile pSEAosi     =   [SELECT Id,Name FROM Profile WHERE Name = 'Service Executive AOSI' LIMIT 1];  
        User    uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
        User    uSEAosi     =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pSEAosi.Id AND IsActive = true LIMIT 1];

        ASP_Rate_Master__c oAspRateMaster   =   TestHelpUtility.getASPRateMaster('Test Rate Master', DefineConstant.PROD_VERTICAL_WH);
        insert oAspRateMaster;
            
        ASP__c oASP =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
        insert oASP;

        PIN_Allocation__c pinAlloc      =   TestHelpUtility.getPinAllocation('600114', oASP, uASPAosi);
        insert pinAlloc;
        
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Installation',oPinMasterSouth);
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
            Asset oAsset2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAsset2.Name                        =   'B0820104041233';
            oAsset2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAsset2);
            Asset oAssetC1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAssetC1.Name                        =   'B0820104041233';
            oAssetC1.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAssetC1);
            Asset oAssetC2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAssetC2.Name                        =   'B0820104041233';
            oAssetC2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAssetC2);
        insert lInsertAsset;
        
        list<Case> listCase             =   new list<Case>();
            Case oCase1                     =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWT);
            oCase1.Reason                   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_City__c             =   'Chennai';
            oCase1.Quantity__c              =   '3';
            oCase1.Status                   =   'On Hold';
            oCase1.AOSI_Cancelled_On_HOLD_Reason__c = 'Reappointment - Branch';
            oCase1.AOSI_Appointment_Date__c =   date.today();
            oCase1.Service_Engineer__c      =    oServEngg.id;
            listCase.add(oCase1);
        insert listCase;
        
        List<CaseComment> caseCommentList = new List<CaseComment>();
        CaseComment caseComment = new CaseComment(ParentId = oCase1.Id,
                                          IsPublished = true,CommentBody = 'Appointment Date :'+String.valueof(oCase1.AOSI_Appointment_Date__c));

        caseCommentList.add(caseComment);
        insert caseCommentList;
        system.debug('###caseCommentList###'+caseCommentList);
        
        System.assertEquals(true, caseComment.isPublished);
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case> listChildCases   =   [Select Id,ParentId,Quantity__c,AssetId FROM Case WHERE ParentId =: oCase1.Id];
        listChildCases[0].AssetId   =   oAsset2.Id;
        try {
            update listChildCases[0];
        } catch ( Exception e ) { System.debug('***Exception installationCaseTest() update child case ***' + e); }
    test.stopTest();
    }//End of caseCommentTestMethod
      
}