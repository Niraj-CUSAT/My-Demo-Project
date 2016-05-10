/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    08/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Test class for Creating Auto PM Cases for WT products Asset Warranty 
**************************************************************************************************/
@isTest
private class AutoCreatePMCasesWTWarrantyTest {

    static testMethod void positiveTest() {
    	
    	
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
     
       
       Account oAcc = TestHelpUtility.getAccount();
        insert oAcc;
        
        Pin_Master__c oPinMaster = TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');
        insert oPinMaster;
        
     
        
        Contact oContact = TestHelpUtility.getContact(oAcc, oPinMaster);
        insert oContact;
        
        Service_Engineer__c oResource = TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd = TestHelpUtility.getProduct();
        oProd.AOSI_Color_Panel_Charges__c 		= 250.0;
        oProd.AOSI_Comprehensive_Warranty__c 	= 2;
        oProd.AOSI_Element_Warranty__c 			= 1;
        oProd.AOSI_Family__c 					= 'Storage';
        oProd.AOSI_Installation_Charges__c 		= 300;
        oProd.AOSI_Vertical__c 					= 'Water Treatment';
        oProd.AOSI_Visit_Charges__c 			= 250;
        oProd.Family 							= 'Heater Units - Residential';
        oProd.Filter_Warranty_AOS_India__c 		= 6;
        oProd.Product_Warranty_AOS_India__c 	= 7;
        oProd.AOSI_PM_Service__c                ='Yes';
        oProd.AOSI_PM1__c                       =true;
        oProd.AOSI_PM2__c                       =true;
        oProd.AOSI_PM3__c                       =true;
        insert oProd;
         
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  oContact.id;
        ast.Product2id = oProd.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today() -120;
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
        
        
        Test.startTest() ;
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        Test.stopTest();
        
        Case caseInstallation = TestHelpUtility.getCase(oContact, ast, oProd);
       // caseInstallation.RecordTypeId				= 	rtCase.Id;
        caseInstallation.Reason 					=  	DefineConstant.CASE_REASON_PM_SERVICE;
        caseInstallation.AOSI_City__c				=   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c 	= 	DefineConstant.CASE_REASON_PM_SERVICE;
        caseInstallation.AOSI_Customer_Concern__c         =   'PM Service 1';
        insert caseInstallation;
        
        AutoCreatePMCasesWTWarranty auto = new AutoCreatePMCasesWTWarranty();
        database.executeBatch(auto);
    }
    
     static testMethod void negativeTest() {
     	
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
    
       
       Account oAcc = TestHelpUtility.getAccount();
        insert oAcc;
        
      Pin_Master__c oPinMaster = TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');
        insert oPinMaster;
        
        Contact oContact = TestHelpUtility.getContact(oAcc, oPinMaster);
        insert oContact;
        
        Service_Engineer__c oResource = TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd = TestHelpUtility.getProduct();
        oProd.AOSI_Color_Panel_Charges__c 		= 250.0;
        oProd.AOSI_Comprehensive_Warranty__c 	= 2;
        oProd.AOSI_Element_Warranty__c 			= 1;
        oProd.AOSI_Family__c 					= 'Storage';
        oProd.AOSI_Installation_Charges__c 		= 300;
        oProd.AOSI_Vertical__c 					= 'Water Treatment';
        oProd.AOSI_Visit_Charges__c 			= 250;
        oProd.Family 							= 'Heater Units - Residential';
        oProd.Filter_Warranty_AOS_India__c 		= 6;
        oProd.Product_Warranty_AOS_India__c 	= 7;
        oProd.AOSI_PM_Service__c                ='Yes';
        oProd.AOSI_PM1__c                       =true;
        oProd.AOSI_PM2__c                       =true;
        oProd.AOSI_PM3__c                       =true;
        insert oProd;
        
        
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  oContact.id;
        ast.Product2id = oProd.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today() -240;
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
        
        Test.startTest() ;
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        Test.stopTest();
        
        Case caseInstallation = TestHelpUtility.getCase(oContact, ast, oProd);
       // caseInstallation.RecordTypeId				= 	rtCase.Id;
        caseInstallation.Reason 					=  	DefineConstant.CASE_REASON_PM_SERVICE;
        caseInstallation.AOSI_City__c				=   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c 	= 	DefineConstant.CASE_REASON_PM_SERVICE;
        caseInstallation.AOSI_Customer_Concern__c         =   'PM Service 2';
        insert caseInstallation;
        
        AutoCreatePMCasesWTWarranty auto = new AutoCreatePMCasesWTWarranty();
        database.executeBatch(auto);
    }
    
    static testMethod void negativeTest1() {
    	
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
    	
    	
 
       
       Account oAcc = TestHelpUtility.getAccount();
        insert oAcc;
        
        Pin_Master__c oPinMaster = TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');
        insert oPinMaster;
        
        Contact oContact = TestHelpUtility.getContact(oAcc, oPinMaster);
        insert oContact;
        
        Service_Engineer__c oResource = TestHelpUtility.getResource();
        insert oResource;
        
        Product2 oProd = TestHelpUtility.getProduct();
        oProd.AOSI_Color_Panel_Charges__c 		= 250.0;
        oProd.AOSI_Comprehensive_Warranty__c 	= 2;
        oProd.AOSI_Element_Warranty__c 			= 1;
        oProd.AOSI_Family__c 					= 'Storage';
        oProd.AOSI_Installation_Charges__c 		= 300;
        oProd.AOSI_Vertical__c 					= 'Water Treatment';
        oProd.AOSI_Visit_Charges__c 			= 250;
        oProd.Family 							= 'Heater Units - Residential';
        oProd.Filter_Warranty_AOS_India__c 		= 6;
        oProd.Product_Warranty_AOS_India__c 	= 7;
        oProd.AOSI_PM_Service__c                ='Yes';
        oProd.AOSI_PM1__c                       =true;
        oProd.AOSI_PM2__c                       =true;
        oProd.AOSI_PM3__c                       =true;
        insert oProd;
        
       
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  oContact.id;
        ast.Product2id = oProd.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today() -358;
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
        
  
        
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
     
        
        Case caseInstallation = TestHelpUtility.getCase(oContact, ast, oProd);
       // caseInstallation.RecordTypeId				= 	rtCase.Id;
        caseInstallation.Reason 					=  	DefineConstant.CASE_REASON_PM_SERVICE;
        caseInstallation.AOSI_City__c				=   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c 	= 	DefineConstant.CASE_REASON_PM_SERVICE;
        caseInstallation.AOSI_Customer_Concern__c         =   'PM Service 2';
        insert caseInstallation;
        
        AutoCreatePMCasesWTWarranty auto = new AutoCreatePMCasesWTWarranty();
        database.executeBatch(auto);
    }
}