@isTest
private class SetRecordtype_Test {
    static testmethod void testParts() { 
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
            
            Account oAcc                    =   TestHelpUtility.getNewAccount('Test FieldTrial',oPinMasterSouth);
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
            
            Case oCase1                     =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase1.Reason                   =   DefineConstant.CASE_REASON_FIELD_TRIAL;
            oCase1.AOSI_Customer_Concern__c =   'Demo Call';
            insert oCase1;
            
            ApexPages.StandardController sc = new ApexPages.standardController(oCase1);
            SetRecordtype newPart = new SetRecordtype(sc);
            list<Part_Code__c> lstPratCodeTemp = newPart.partCodeList;
            lstPratCodeTemp = newPart.newPartCodeList;
            lstPratCodeTemp = newPart.insertPartCodeList;
            newPart.addMore();
            newPart.savePartCode();
            newPart.ShowPartDetail();
            newPart.CustomeSave();
            newPart.deleteRow();
            newPart.deleteRow();
            newPart.savePartCode();
            newPart.ShowPartDetail();
            newPart.CustomeSave();
        test.stopTest();
    }
}