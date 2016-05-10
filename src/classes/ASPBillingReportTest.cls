/****Field Name: ASPBillingReportTest
    Created By:Dhriti Krishna Ghosh Moulick
    Modified By:
    Description:This Test class is used to display ASP Billing Report.
                1.Need to display records of all individual case reasons related to a particular ASP.
                2.Need to retreive ASP Rate Master(one for each ASP).
                3.Need to retreive Service line(can be multiple for a particular rate master) which is child of ASP Rate Master.
                4.Need to retreive rate based on case reason of individual service line
                5.Need to retreive Cases closed last month for this particular ASP.
                6.Categorize case based on resolution time and displayed it on VF page.
*****/
@isTest
private class ASPBillingReportTest {

    static testMethod void myUnitTestFILocal() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Local';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'Free Installation';
       serviceLine.X6_hrs__c = 200;
       serviceLine.X24hrs_City__c = 200;
       serviceLine.X48_hrs_City__c = 200;
       serviceLine.X6hrs_to_24hrs_City__c = 300;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       list<Case> newCaseLst                                 =   new list<Case>();
       Case caseFreeInstallSouth1                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth1.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth1.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth1.AOSI_City__c                    =   'Chennai';
       caseFreeInstallSouth1.Quantity__c                     =   '5';
       newCaseLst.add(caseFreeInstallSouth1);
       Case caseFreeInstallSouth2                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth2.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth2.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth2.AOSI_City__c                    =   'Chennai';
       newCaseLst.add(caseFreeInstallSouth2);
       Case caseFreeInstallSouth3                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth3.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth3.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth3.AOSI_City__c                    =   'Chennai';
       newCaseLst.add(caseFreeInstallSouth3);
       Case caseFreeInstallSouth4                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth4.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth4.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth4.AOSI_City__c                    =   'Chennai';
       newCaseLst.add(caseFreeInstallSouth4);
       insert newCaseLst;
       
       caseFreeInstallSouth1.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth1.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth1.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth1.AOSI_Resolution_Clock_Time__c  =   5.0;
       caseFreeInstallSouth1.AOSI_Hardness__c = '200';
       caseFreeInstallSouth1.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth1.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth1.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth1.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth1.AOSI_pH__c = '200';
       caseFreeInstallSouth1.Status = 'Closed';
       caseFreeInstallSouth1.AOSI_Purchase_Value__c = 333;
       
       caseFreeInstallSouth2.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth2.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth2.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth2.AOSI_Resolution_Clock_Time__c  =   12.0;
       caseFreeInstallSouth2.AOSI_Hardness__c = '200';
       caseFreeInstallSouth2.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth2.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth2.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth2.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth2.AOSI_pH__c = '200';
       caseFreeInstallSouth2.Status = 'Closed';
       caseFreeInstallSouth2.AOSI_Purchase_Value__c = 333;
       
       caseFreeInstallSouth3.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth3.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth3.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth3.AOSI_Resolution_Clock_Time__c  =   36.0;
       caseFreeInstallSouth3.AOSI_Hardness__c = '200';
       caseFreeInstallSouth3.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth3.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth3.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth3.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth3.AOSI_pH__c = '200';
       caseFreeInstallSouth3.Status = 'Closed';
       caseFreeInstallSouth3.AOSI_Purchase_Value__c = 333;
       
       caseFreeInstallSouth4.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth4.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth4.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth4.AOSI_Resolution_Clock_Time__c  =   50.0;
       caseFreeInstallSouth4.AOSI_Hardness__c = '200';
       caseFreeInstallSouth4.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth4.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth4.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth4.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth4.AOSI_pH__c = '200';
       caseFreeInstallSouth4.Status = 'Closed';
       caseFreeInstallSouth4.AOSI_Purchase_Value__c = 333;
       update newCaseLst;  
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
       billingReport.beginning();
       billingReport.previous();
       billingReport.next();
       billingReport.getprev();
       billingReport.end();
       billingReport.getnxt();
       
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
     static testMethod void myUnitTestFIUpcountry() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType1 = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType1);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Upcountry';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'Free Installation';
        serviceLine.X6_hrs__c = 200;
        serviceLine.X6hrs_Upcountry__c = 200;
       serviceLine.X24hrs_Upcountry__c = 200;
       serviceLine.X48_hrs_Upcountry__c = 200;
       serviceLine.X6hrs_to_24hrs_Upcountry__c = 200;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       list<Case> newCaseLst                                 =   new list<Case>();
       Case caseFreeInstallSouth1                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth1.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth1.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth1.AOSI_City__c                    =   'Chennai';
       caseFreeInstallSouth1.Quantity__c                     =   '5';
       newCaseLst.add(caseFreeInstallSouth1);
       Case caseFreeInstallSouth2                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth2.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth2.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth2.AOSI_City__c                    =   'Chennai';
       newCaseLst.add(caseFreeInstallSouth2);
       Case caseFreeInstallSouth3                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth3.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth3.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth3.AOSI_City__c                    =   'Chennai';
       newCaseLst.add(caseFreeInstallSouth3);
       Case caseFreeInstallSouth4                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth4.Reason                          =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth4.AOSI_Customer_Concern__c        =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
       caseFreeInstallSouth4.AOSI_City__c                    =   'Chennai';
       newCaseLst.add(caseFreeInstallSouth4);
       insert newCaseLst;
       
       caseFreeInstallSouth1.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth1.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth1.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth1.AOSI_Resolution_Clock_Time__c  =   5.0;
       caseFreeInstallSouth1.AOSI_Hardness__c = '200';
       caseFreeInstallSouth1.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth1.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth1.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth1.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth1.AOSI_pH__c = '200';
       caseFreeInstallSouth1.Status = 'Closed';
       caseFreeInstallSouth1.AOSI_Purchase_Value__c = 333;
       
       caseFreeInstallSouth2.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth2.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth2.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth2.AOSI_Resolution_Clock_Time__c  =   12.0;
       caseFreeInstallSouth2.AOSI_Hardness__c = '200';
       caseFreeInstallSouth2.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth2.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth2.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth2.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth2.AOSI_pH__c = '200';
       caseFreeInstallSouth2.Status = 'Closed';
       caseFreeInstallSouth2.AOSI_Purchase_Value__c = 333;
       
       caseFreeInstallSouth3.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth3.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth3.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth3.AOSI_Resolution_Clock_Time__c  =   36.0;
       caseFreeInstallSouth3.AOSI_Hardness__c = '200';
       caseFreeInstallSouth3.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth3.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth3.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth3.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth3.AOSI_pH__c = '200';
       caseFreeInstallSouth3.Status = 'Closed';
       caseFreeInstallSouth3.AOSI_Purchase_Value__c = 333;
       
       caseFreeInstallSouth4.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth4.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth4.Assignment_End_Time__c        =   System.now().addhours(7);
       caseFreeInstallSouth4.AOSI_Resolution_Clock_Time__c  =   50.0;
       caseFreeInstallSouth4.AOSI_Hardness__c = '200';
       caseFreeInstallSouth4.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth4.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth4.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth4.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth4.AOSI_pH__c = '200';
       caseFreeInstallSouth4.Status = 'Closed';
       caseFreeInstallSouth4.AOSI_Purchase_Value__c = 333;
       update newCaseLst;  
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
       billingReport.next();
       billingReport.previous();
       
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
    
    static testMethod void myUnitTestServiceLocal() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Local';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'Service';
       serviceLine.X6_hrs__c = 200;
       serviceLine.X24hrs_City__c = 200;
       serviceLine.X48_hrs_City__c = 200;
       serviceLine.X6hrs_to_24hrs_City__c = 300;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1]; 
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Customer_Concern__c customConcern =TestHelpUtility.getCustomerConcern('Accessory Missing','Accessory Missing');
        insert customConcern;
        
        Product_Customer_Concern__c productCustomerConcern = TestHelpUtility.getProductCustomerConcern(customConcern,oProdWT);
        insert productCustomerConcern;
        
        /*String objectTypes = 'Case'; 
        List<smagicinteract__SMS_Template__c> smsTemplate1  =  TestHelpUtility.getSMSTemplate(objectTypes);  
        insert smsTemplate1;*/
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       test.startTest();
       list<Case> caseList                              =   new list<Case>();
       Case caseServiceSouth1                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
        caseServiceSouth1.Reason                         =   DefineConstant.CASE_REASON_SERVICE;
        caseServiceSouth1.AOSI_Customer_Concern__c       =   'Accessory Missing';
        caseServiceSouth1.AOSI_City__c                   =   'Chennai';
        caseServiceSouth1.Quantity__c                    =   '5';
        caseServiceSouth1.AssetId                        =   oAssetSouth.Id;
        caseList.add(caseServiceSouth1);
        insert caseList;
        
        list<Service_Charges__c> serChargeLst   =   new list<Service_Charges__c>();
        Service_Charges__c serviceCharges1 = new Service_Charges__c();
        serviceCharges1.Case__c = caseServiceSouth1.Id;
        serviceCharges1.Type__c = 'Visit Charges';
        serviceCharges1.Quantity__c = 1;
        serviceCharges1.Chargable__c = 'No';
        serChargeLst.add(serviceCharges1);
        
        insert serChargeLst;
        
        
        Case_Customer_Concern__c caseCustomerConcern = new Case_Customer_Concern__c();
        caseCustomerConcern.Action__c = 'Product Refund';
        caseCustomerConcern.Cause__c = 'Drain Pipes';
        caseCustomerConcern.Customer_Concern__c = 'Accessory Missing';
        caseCustomerConcern.Case__c = caseServiceSouth1.Id;
        insert caseCustomerConcern;
        
        caseServiceSouth1.Status='Closed';
        caseServiceSouth1.Assignment_Start_Time__c  =   System.now();
        caseServiceSouth1.Assignment_End_Time__c     =   System.now().addhours(1);
        //caseServiceSouth.AOSI_Case_Close_Time__c = System.now();
        caseServiceSouth1.AOSI_Water_Source__c = 'Muncipal';
        caseServiceSouth1.AOSI_Hardness__c = '123';
        caseServiceSouth1.AOSI_pH__c = '111';
        caseServiceSouth1.AOSI_TDS_Input__c = '111';
        caseServiceSouth1.AOSI_TDS_Output__c = '123';
        caseServiceSouth1.AOSI_Water_Storage__c = 'Under ground tank';
        caseServiceSouth1.Service_Engineer__c = oResource.Id;
        update caseServiceSouth1;
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
        
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
    
     static testMethod void myUnitTestServiceUpcountry() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Upcountry';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'Service';
       serviceLine.X6hrs_Upcountry__c = 200;
       serviceLine.X24hrs_Upcountry__c = 200;
       serviceLine.X48_hrs_Upcountry__c = 200;
       serviceLine.X6hrs_to_24hrs_Upcountry__c = 200;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1]; 
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Customer_Concern__c customConcern =TestHelpUtility.getCustomerConcern('Accessory Missing','Accessory Missing');
        insert customConcern;
        
        Product_Customer_Concern__c productCustomerConcern = TestHelpUtility.getProductCustomerConcern(customConcern,oProdWT);
        insert productCustomerConcern;
        
        /*String objectTypes = 'Case'; 
        List<smagicinteract__SMS_Template__c> smsTemplate1  =  TestHelpUtility.getSMSTemplate(objectTypes);  
        insert smsTemplate1;*/
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       Case caseServiceSouth                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
        caseServiceSouth.Reason                         =   DefineConstant.CASE_REASON_SERVICE;
        caseServiceSouth.AOSI_Customer_Concern__c       =   'Accessory Missing';
        caseServiceSouth.AOSI_City__c                   =   'Chennai';
        caseServiceSouth.Quantity__c                    =   '5';
        caseServiceSouth.AssetId                        =   oAssetSouth.Id;
        insert caseServiceSouth;
        
        
        Service_Charges__c serviceCharges = new Service_Charges__c();
        serviceCharges.Case__c = caseServiceSouth.Id;
        serviceCharges.Type__c = 'Visit Charges';
        serviceCharges.Quantity__c = 1;
        serviceCharges.Chargable__c = 'No';
        insert serviceCharges;
        
        
        Case_Customer_Concern__c caseCustomerConcern = new Case_Customer_Concern__c();
        caseCustomerConcern.Action__c = 'Product Refund';
        caseCustomerConcern.Cause__c = 'Drain Pipes';
        caseCustomerConcern.Customer_Concern__c = 'Accessory Missing';
        caseCustomerConcern.Case__c = caseServiceSouth.Id;
        insert caseCustomerConcern;
        
        caseServiceSouth.Status='Closed';
        caseServiceSouth.Assignment_Start_Time__c  =   System.now();
        caseServiceSouth.Assignment_End_Time__c    =   System.now().addDays(1);
        //caseServiceSouth.AOSI_Case_Close_Time__c = System.now();
        caseServiceSouth.AOSI_Water_Source__c = 'Muncipal';
        caseServiceSouth.AOSI_Hardness__c = '123';
        caseServiceSouth.AOSI_pH__c = '111';
        caseServiceSouth.AOSI_TDS_Input__c = '111';
        caseServiceSouth.AOSI_TDS_Output__c = '123';
        caseServiceSouth.AOSI_Water_Storage__c = 'Under ground tank';
        caseServiceSouth.Service_Engineer__c = oResource.Id;
        update caseServiceSouth;
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
        
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
    
     static testMethod void myUnitTestDealerStockLocal() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Local';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Customer_Concern__c customConcern =TestHelpUtility.getCustomerConcern('Accessory Missing','Accessory Missing');
       insert customConcern;
        
       Product_Customer_Concern__c productCustomerConcern = TestHelpUtility.getProductCustomerConcern(customConcern,oProdWT);
       insert productCustomerConcern;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'Dealer Stock';
       serviceLine.X6_hrs__c = 200;
       serviceLine.X24hrs_City__c = 200;
       serviceLine.X48_hrs_City__c = 200;
       serviceLine.X6hrs_to_24hrs_City__c = 300;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       Case caseFreeInstallSouth                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth.Reason                          =   DefineConstant.CASE_REASON_DEALER_STOCK;
       caseFreeInstallSouth.AOSI_Customer_Concern__c        =   'Accessory Missing';
       //caseFreeInstallSouth.AOSI_City__c                    =   'Chennai';
       //caseFreeInstallSouth.Quantity__c                     =   '5';
       insert caseFreeInstallSouth;
       
       Case_Customer_Concern__c caseCustomerConcern = new Case_Customer_Concern__c();
       caseCustomerConcern.Action__c = 'Product Refund';
       caseCustomerConcern.Cause__c = 'Drain Pipes';
       caseCustomerConcern.Customer_Concern__c = 'Accessory Missing';
       caseCustomerConcern.Case__c = caseFreeInstallSouth.Id;
       insert caseCustomerConcern;
       
       caseFreeInstallSouth.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth.Assignment_End_Time__c    =   System.now().addhours(35);
       //caseFreeInstallSouth.AOSI_Case_Close_Time__c =System.now();
       caseFreeInstallSouth.AOSI_Hardness__c = '200';
       caseFreeInstallSouth.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth.AOSI_pH__c = '200';
       caseFreeInstallSouth.Status = 'Closed';
       caseFreeInstallSouth.AOSI_Purchase_Value__c = 333;
       //caseFreeInstallSouth.ClosedDate = System.now().addMonths(-1);
       update caseFreeInstallSouth;  
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
        
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
    
     static testMethod void myUnitTestDealerStockUpCountry() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Upcountry';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Customer_Concern__c customConcern =TestHelpUtility.getCustomerConcern('Accessory Missing','Accessory Missing');
       insert customConcern;
        
       Product_Customer_Concern__c productCustomerConcern = TestHelpUtility.getProductCustomerConcern(customConcern,oProdWT);
       insert productCustomerConcern;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'Dealer Stock';
       serviceLine.X6hrs_Upcountry__c = 200;
       serviceLine.X24hrs_Upcountry__c = 200;
       serviceLine.X48_hrs_Upcountry__c = 200;
       serviceLine.X6hrs_to_24hrs_Upcountry__c = 200;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       Case caseFreeInstallSouth                            =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       caseFreeInstallSouth.Reason                          =   DefineConstant.CASE_REASON_DEALER_STOCK;
       caseFreeInstallSouth.AOSI_Customer_Concern__c        =   'Accessory Missing';
       //caseFreeInstallSouth.AOSI_City__c                    =   'Chennai';
       //caseFreeInstallSouth.Quantity__c                     =   '5';
       insert caseFreeInstallSouth;
       
       Case_Customer_Concern__c caseCustomerConcern = new Case_Customer_Concern__c();
       caseCustomerConcern.Action__c = 'Product Refund';
       caseCustomerConcern.Cause__c = 'Drain Pipes';
       caseCustomerConcern.Customer_Concern__c = 'Accessory Missing';
       caseCustomerConcern.Case__c = caseFreeInstallSouth.Id;
       insert caseCustomerConcern;
       
       caseFreeInstallSouth.Service_Engineer__c =   oResource.Id;
       caseFreeInstallSouth.Assignment_Start_Time__c  =   System.now();
       caseFreeInstallSouth.Assignment_End_Time__c    =   System.now().addhours(16);
       //caseFreeInstallSouth.AOSI_Case_Close_Time__c =System.now();
       caseFreeInstallSouth.AOSI_Hardness__c = '200';
       caseFreeInstallSouth.AOSI_Water_Storage__c = 'Under ground tank';
       caseFreeInstallSouth.AOSI_TDS_Output__c = '222';
       caseFreeInstallSouth.AOSI_Water_Source__c = 'Municipal';
       caseFreeInstallSouth.AOSI_TDS_Input__c = '333';
       caseFreeInstallSouth.AOSI_pH__c = '200';
       caseFreeInstallSouth.Status = 'Closed';
       caseFreeInstallSouth.AOSI_Purchase_Value__c = 333;
       //caseFreeInstallSouth.ClosedDate = System.now().addMonths(-1);
       update caseFreeInstallSouth;  
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
        
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
    
     static testMethod void myUnitTestPMServiceLocal() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Local';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'PM Service';
       serviceLine.X6_hrs__c = 200;
       serviceLine.X24hrs_City__c = 200;
       serviceLine.X48_hrs_City__c = 200;
       serviceLine.X6hrs_to_24hrs_City__c = 300;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       test.startTest();
       
       list<Case> newCaseList                   =   new list<Case>();
       Case PMServSouth1                        =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       PMServSouth1.Reason                      =   DefineConstant.CASE_REASON_PM_SERVICE;
       PMServSouth1.AOSI_Customer_Concern__c    =   'PM Service 1';
       newCaseList.add(PMServSouth1);
       insert newCaseList;
       
       list<Case_Customer_Concern__c> cccList           =   new list<Case_Customer_Concern__c>();
       Case_Customer_Concern__c caseCustomerConcern1    =   new Case_Customer_Concern__c();
       caseCustomerConcern1.Action__c                   =   'Product Refund';
       caseCustomerConcern1.Cause__c                    =   'Drain Pipes';
       caseCustomerConcern1.Customer_Concern__c         =   'Accessory Missing';
       caseCustomerConcern1.Case__c                     =   PMServSouth1.Id;
       cccList.add(caseCustomerConcern1);
       insert cccList;
       
       PMServSouth1.Service_Engineer__c         =   oResource.Id;
       PMServSouth1.Assignment_Start_Time__c    =   System.now();
       PMServSouth1.Assignment_End_Time__c      =   System.now().addhours(22);
       PMServSouth1.AOSI_Resolution_Clock_Time__c = 4.2;
       PMServSouth1.AOSI_Hardness__c            =   '200';
       PMServSouth1.AOSI_Water_Storage__c       =   'Under ground tank';
       PMServSouth1.AOSI_TDS_Output__c          =   '222';
       PMServSouth1.AOSI_Water_Source__c        =   'Municipal';
       PMServSouth1.AOSI_TDS_Input__c           =   '333';
       PMServSouth1.AOSI_pH__c                  =   '200';
       PMServSouth1.Status                      =   'Closed';
       PMServSouth1.AOSI_Purchase_Value__c      =   333;
       update newCaseList;  
       
       test.stopTest(); 
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
       billingReport.getCases();
        
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
    
     static testMethod void myUnitTestPMServiceUpcountry() {
        
       list<RecordTypeDetails__c> recordTypes       =   TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       smagicinteract__SMS_SenderId__c senderId     =   TestHelpUtility.getSMSSenderID();
       insert senderId;
        
       String objectType = 'Case';
       List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
       insert smsTemplate;
        
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
       
       City_Master__c cityMasterSouth           =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
       insert cityMasterSouth;
       
       Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       oPinMasterSouth.AOSI_Type__c = 'Upcountry';
       insert oPinMasterSouth;
       
       Contact oContactSouth    = TestHelpUtility.getContact(oAcc, oPinMasterSouth);
       insert oContactSouth;
       
       Product2 oProdWT             =   TestHelpUtility.getProduct();
       oProdWT.AOSI_Vertical__c     =   DefineConstant.PROD_VERTICAL_WT;
       oProdWT.AOSI_Family__c       =   'Water Purifier';
       insert oProdWT;
       
       Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
       oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
       insert oAssetSouth; 
       
       ASP_Rate_Master__c oAspRateMaster    =   TestHelpUtility.getASPRateMaster('Test Rate Master', 'Water Treatment');
       oAspRateMaster.Active__c = true;
       insert oAspRateMaster;
       
       Service_Line__c serviceLine = new Service_Line__c();
       serviceLine.ASP_Rate_Master__c = oAspRateMaster.Id;
       serviceLine.Type__c = 'PM Service';
       serviceLine.X6hrs_Upcountry__c = 200;
       serviceLine.X24hrs_Upcountry__c = 200;
       serviceLine.X48_hrs_Upcountry__c = 200;
       serviceLine.X6hrs_to_24hrs_Upcountry__c = 200;
       insert serviceLine;
       
       Profile pASPAosi =   [SELECT Id,Name FROM Profile WHERE Name = 'ASP AOSI' LIMIT 1];
       system.debug('*******************TEST installationCaseTest pASPAosi '+pASPAosi);
        
       User uASPAosi    =   [SELECT Id,Name,ProfileId FROM User WHERE ProfileId =: pASPAosi.Id AND IsActive = true LIMIT 1];
       system.debug('*******************TEST installationCaseTest uASPAosi '+uASPAosi);
       
       ASP__c oASP1 =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
       oASP1.AOSI_Approval_Status__c = 'Approved';
       oASP1.AOSI_Contract_Effective_From_Date__c  = System.today() -1;
       oASP1.AOSI_Contract_Effective_To_Date__c  = System.today() +1;
       oASP1.Terminate__c = false;
       insert oASP1;
       
       ASP_Rate_Master_Junction__c rateMasterJunction = new ASP_Rate_Master_Junction__c();
       rateMasterJunction.ASP__c = oASP1.ID;
       rateMasterJunction.ASP_Rate_Master__c = oAspRateMaster.ID;
       insert rateMasterJunction;
       
       Service_Engineer__c oResource    =   TestHelpUtility.getResource();
       oResource.AOSI_ASP__c = oASP1.ID;
       insert oResource;
       
       test.startTest();
       
       list<Case> newCaseList                   =   new list<Case>();
       Case PMServSouth1                        =   TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
       PMServSouth1.Reason                      =   DefineConstant.CASE_REASON_PM_SERVICE;
       PMServSouth1.AOSI_Customer_Concern__c    =   'PM Service 1';
       newCaseList.add(PMServSouth1);
       insert newCaseList;
       
       list<Case_Customer_Concern__c> cccList           =   new list<Case_Customer_Concern__c>();
       Case_Customer_Concern__c caseCustomerConcern1    =   new Case_Customer_Concern__c();
       caseCustomerConcern1.Action__c                   =   'Product Refund';
       caseCustomerConcern1.Cause__c                    =   'Drain Pipes';
       caseCustomerConcern1.Customer_Concern__c         =   'Accessory Missing';
       caseCustomerConcern1.Case__c                     =   PMServSouth1.Id;
       cccList.add(caseCustomerConcern1);
       insert cccList;
       
       PMServSouth1.Service_Engineer__c         =   oResource.Id;
       PMServSouth1.Assignment_Start_Time__c    =   System.now();
       PMServSouth1.Assignment_End_Time__c      =   System.now().addhours(22);
       PMServSouth1.AOSI_Resolution_Clock_Time__c = 4.2;
       PMServSouth1.AOSI_Hardness__c            =   '200';
       PMServSouth1.AOSI_Water_Storage__c       =   'Under ground tank';
       PMServSouth1.AOSI_TDS_Output__c          =   '222';
       PMServSouth1.AOSI_Water_Source__c        =   'Municipal';
       PMServSouth1.AOSI_TDS_Input__c           =   '333';
       PMServSouth1.AOSI_pH__c                  =   '200';
       PMServSouth1.Status                      =   'Closed';
       PMServSouth1.AOSI_Purchase_Value__c      =   333;
       update newCaseList;  
       
       test.stopTest(); 
       
       PageReference pageRef1 = Page.ASPBillingReport;
       pageRef1.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef1);
       ASPBillingReport billingReport = new ASPBillingReport();
       
        
       PageReference pageRef = Page.ASPBillingReport;
       pageRef.getParameters().put('id', String.valueOf(oASP1.Id));
       Test.setCurrentPage(pageRef);
       billingReport.exportExcel();
    }
}