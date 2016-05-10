@isTest//(seeAllData=True)
Public Class AOSI_casePowerOfOneHandlerTest1{
     static testMethod void myUnitTest() {
       test.startTest();
       /*DateTime myDateTime = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
       myDateTime = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(myDateTime);
       System.debug('===myDateTime==='+myDateTime);
       case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='Closed' AND  (Reason='Service' OR Reason='Free Installation')   LIMIT 1];
       test.setCreatedDate(oCase1.id, myDateTime);
       test.StopTest();*/
      }
      
   
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
            Case oCase1                     =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase1.Reason                   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_City__c             =   'Chennai';
            listCase.add(oCase1);
        insert listCase;
        
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        list<Case>  lstUpdateServEngg               =   new list<Case>();
            oCase1.AOSI_Appointment_Date__c         =   System.now().addMinutes(5);
            oCase1.Assignment_Start_Time__c         =   System.now().addMinutes(45);
            oCase1.Service_Engineer__c              =   oServEngg.Id;   
            lstUpdateServEngg.add(oCase1);
        update lstUpdateServEngg;   
        System.debug('===oCase1==='+oCase1.createdDate);
        System.debug('===oCase1==='+oCase1);
       test.stopTest();
       
       DateTime myDateTime = DateTime.newInstance(1997, 1, 31, 7, 8, 16);
       myDateTime = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(myDateTime);
       System.debug('===myDateTime==='+myDateTime);
       System.debug('===oCase1==='+oCase1.createdDate);
       test.setCreatedDate(oCase1.id, myDateTime);
       System.debug('===oCase1==='+oCase1.createdDate);
       
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
            
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Service_Engineer__c                  =   oServEngg.Id;
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
            update oCase1; } catch(Exception e) {System.debug('Exception PO1 Service Case Update*** '+e);}
        
      
       test.stopTest();  
        
        
    
    }

}