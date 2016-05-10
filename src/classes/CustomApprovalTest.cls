@IsTest
public class CustomApprovalTest {

    public static testmethod void unitTest1()
    {
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
            insert lInsertProd;
            
            list<Asset> lInsertAsset  =  new list<Asset>();
            Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
            oAsset1.Name                        =   'B0800104041234';
            lInsertAsset.add(oAsset1);        
            insert lInsertAsset;
            
            Service_Engineer__c oServEngg1    =   TestHelpUtility.getResource();  
            oServEngg1.Name                   =   'Test Resource1';
            oServEngg1.Mobile_Number__c       =   '9773587451';
            insert oServEngg1;
            
            Case oCase1                             =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase1.Reason                           =   DefineConstant.CASE_REASON_SALES_QUERY;
            oCase1.AOSI_Customer_Concern__c         =   'Interested in Buying';
            oCase1.AOSI_Sales_Query_Reference__c    =   'Canopy';
            oCase1.AOSI_Category_of_Sales_Query__c  =   'Interested';
            oCase1.AOSI_Vertical__c                 =   DefineConstant.PROD_VERTICAL_WH;
            insert oCase1;
            
            PRR__c oPRR                                     =   new PRR__c();
            oPRR.AOSI_Case__c                               =   oCase1.id;
            oPRR.AOSI_Asset__c                              =   oAsset1.id;
            oPRR.AOSI_Type__c                               =   'Customer';
            oPRR.AOSI_Justification__c                      =   'testsss';
            oPRR.AOSI_Approval_Status__c                    =   'Submit For Approval';
            oPRR.Tank_Failure__c=true;
            insert oPRR;
            CustomApproval.SubmitPRRForApproval(oPRR.Id);
            
        
    }
    
    public static testmethod void unitTest2()
    {
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
            insert lInsertProd;
            
            list<Asset> lInsertAsset  =  new list<Asset>();
            Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
            oAsset1.Name                        =   'B0800104041234';
            lInsertAsset.add(oAsset1);        
            insert lInsertAsset;
            
            Service_Engineer__c oServEngg1    =   TestHelpUtility.getResource();  
            oServEngg1.Name                   =   'Test Resource1';
            oServEngg1.Mobile_Number__c       =   '9773587451';
            insert oServEngg1;
            
            Case oCase1                             =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase1.Reason                           =   DefineConstant.CASE_REASON_SALES_QUERY;
            oCase1.AOSI_Customer_Concern__c         =   'Interested in Buying';
            oCase1.AOSI_Sales_Query_Reference__c    =   'Canopy';
            oCase1.AOSI_Category_of_Sales_Query__c  =   'Interested';
            oCase1.AOSI_Vertical__c                 =   DefineConstant.PROD_VERTICAL_WH;
            insert oCase1;
            
            PRR__c oPRR                                     =   new PRR__c();
            oPRR.AOSI_Case__c                               =   oCase1.id;
            oPRR.AOSI_Asset__c                              =   oAsset1.id;
            oPRR.AOSI_Type__c                               =   'Customer';
            oPRR.AOSI_Justification__c                      =   'testsss';
            oPRR.AOSI_Approval_Status__c                    =   'Submit For Approval';
            oPRR.AOSI_Manufacture_Fault_Non_Repairable__c   =   true;
            insert oPRR;
            CustomApproval.SubmitPRRForApproval(oPRR.Id);
            
        
    }
    
}