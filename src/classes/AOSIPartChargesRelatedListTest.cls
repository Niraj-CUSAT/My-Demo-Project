/****Field Name: AOSIPartChargesRelatedListTest
    Created By:Dhriti Krishna Ghosh Moulick
    Modified By:
    Description:This test class is used to display service charges of closed cases
*****/
@isTest
private class AOSIPartChargesRelatedListTest {

    static testMethod void myUnitTest() {
    	
    	list<RecordTypeDetails__c> recordTypes		=	TestHelpUtility.getRecTyCustomSettings();
       	insert recordTypes;
    	
    	smagicinteract__SMS_SenderId__c senderId 	=	TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        Account oAcc = TestHelpUtility.getAccount();
        insert oAcc;
        
        City_Master__c cityMasterSouth 			= 	TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
        insert cityMasterSouth;
        
        Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
        insert oPinMasterSouth; 
        
        Contact oContactSouth 	= TestHelpUtility.getContact(oAcc, oPinMasterSouth);
        insert  oContactSouth;
        
        Product2 oProdWT 			= 	TestHelpUtility.getProduct();
        oProdWT.AOSI_Vertical__c 	=	DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c 		= 	'Storage';
        insert oProdWT;
        
        Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        insert oAssetSouth;
        
        
        Customer_Concern__c customConcern =TestHelpUtility.getCustomerConcern('Accessory Missing','Accessory Missing');
        insert customConcern;
        
        Product_Customer_Concern__c productCustomerConcern = TestHelpUtility.getProductCustomerConcern(customConcern,oProdWT);
        insert productCustomerConcern;
        
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Service_Engineer__c oResource	=	TestHelpUtility.getResource();
        insert oResource;
        
        Case caseServiceSouth							=	TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
        caseServiceSouth.Reason 						=  	DefineConstant.CASE_REASON_SERVICE;
        caseServiceSouth.AOSI_Customer_Concern__c 		= 	'Accessory Missing';
        caseServiceSouth.AOSI_City__c					=   'Chennai';
        caseServiceSouth.Quantity__c					=	'5';
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
        caseServiceSouth.AOSI_Case_Close_Time__c = System.now();
        caseServiceSouth.AOSI_Water_Source__c = 'Muncipal';
        caseServiceSouth.AOSI_Hardness__c = '123';
        caseServiceSouth.AOSI_pH__c = '111';
        caseServiceSouth.AOSI_TDS_Input__c = '111';
        caseServiceSouth.AOSI_TDS_Output__c = '123';
        caseServiceSouth.AOSI_Water_Storage__c = 'Under ground tank';
        caseServiceSouth.Service_Engineer__c = oResource.Id;
        update caseServiceSouth;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oAssetSouth);
        AOSIPartChargesRelatedList partCharges = new AOSIPartChargesRelatedList(sc);
        
        PageReference pageRef = Page.AOSIpartchargesRelatedList;
        pageRef.getParameters().put('id', String.valueOf(oAssetSouth.Id));
        Test.setCurrentPage(pageRef);
    }
    
    static testMethod void myNegativeTest() {
    	
    	list<RecordTypeDetails__c> recordTypes		=	TestHelpUtility.getRecTyCustomSettings();
       	insert recordTypes;
    	
    	smagicinteract__SMS_SenderId__c senderId 	=	TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        Account oAcc = TestHelpUtility.getAccount();
        insert oAcc;
        
        City_Master__c cityMasterSouth 			= 	TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai');
        insert cityMasterSouth;
        
        Pin_Master__c oPinMasterSouth = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
        insert oPinMasterSouth; 
        
        Contact oContactSouth 	= TestHelpUtility.getContact(oAcc, oPinMasterSouth);
        insert  oContactSouth;
        
        Product2 oProdWT 			= 	TestHelpUtility.getProduct();
        oProdWT.AOSI_Vertical__c 	=	DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c 		= 	'Storage';
        insert oProdWT;
        
        Asset oAssetSouth = TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAssetSouth.AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        insert oAssetSouth;
        
        
        Customer_Concern__c customConcern =TestHelpUtility.getCustomerConcern('Accessory Missing','Accessory Missing');
        insert customConcern;
        
        Product_Customer_Concern__c productCustomerConcern = TestHelpUtility.getProductCustomerConcern(customConcern,oProdWT);
        insert productCustomerConcern;
        
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Service_Engineer__c oResource	=	TestHelpUtility.getResource();
        insert oResource;
        
        Case caseServiceSouth							=	TestHelpUtility.getCase(oContactSouth, oAssetSouth, oProdWT);
        caseServiceSouth.Reason 						=  	DefineConstant.CASE_REASON_SERVICE;
        caseServiceSouth.AOSI_Customer_Concern__c 		= 	'Accessory Missing';
        caseServiceSouth.AOSI_City__c					=   'Chennai';
        caseServiceSouth.Quantity__c					=	'5';
        caseServiceSouth.AssetId                        =   oAssetSouth.Id;
        insert caseServiceSouth;
        
        
        Spares__c spareCharges = new Spares__c();
        spareCharges.Name = 'Test Spares';
        spareCharges.Type__c = 'Accessory';
        spareCharges.Part_Type__c = 'Health Care Visit';
        spareCharges.Part_Code__c = '1234';
        spareCharges.Active__c = true;
        spareCharges.MRP__c = 12345;
        insert spareCharges;
        
        Spare_Product_Junction__c spareProductjunction = new Spare_Product_Junction__c();
        spareProductjunction.Product__c = oProdWT.Id;
        spareProductjunction.Spares__c = spareCharges.Id;
        insert spareProductjunction;
        
        Service_Charges__c serviceCharges = new Service_Charges__c();
        serviceCharges.Spares__c = spareCharges.Id;
        serviceCharges.Case__c = caseServiceSouth.Id;
        serviceCharges.Type__c = 'Part Replacement';
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
        caseServiceSouth.AOSI_Case_Close_Time__c = System.now();
        caseServiceSouth.AOSI_Water_Source__c = 'Muncipal';
        caseServiceSouth.AOSI_Hardness__c = '123';
        caseServiceSouth.AOSI_pH__c = '111';
        caseServiceSouth.AOSI_TDS_Input__c = '111';
        caseServiceSouth.AOSI_TDS_Output__c = '123';
        caseServiceSouth.AOSI_Water_Storage__c = 'Under ground tank';
        caseServiceSouth.Service_Engineer__c = oResource.Id;
        update caseServiceSouth;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(oAssetSouth);
        AOSIPartChargesRelatedList partCharges = new AOSIPartChargesRelatedList(sc);
        
        PageReference pageRef = Page.AOSIpartchargesRelatedList;
        pageRef.getParameters().put('id', String.valueOf(oAssetSouth.Id));
        Test.setCurrentPage(pageRef);
    }
}