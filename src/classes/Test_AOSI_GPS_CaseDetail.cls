/******************************************************************************************
@Class Name:	Test_AOSI_GPS_CaseDetail
@Description:	
@Created Date:	
******************************************************************************************/

@IsTest
private class Test_AOSI_GPS_CaseDetail{

	/************************************************
	@ Method Name:	AOSI_GPS_CaseDetailMethod
	@ Description:	Test method for AOSI_GPS_CaseDetailController class to get list of unassigned open cases.
	************************************************/
    static testMethod void AOSI_GPS_CaseDetailMethod(){
        /*
        //AOSI_GPS_CaseDetailController objCaseDetail = new AOSI_GPS_CaseDetailController();
        //objCaseDetail.getListOfOpenCases();
        
        //Pin Master new record
        Pin_Master__c objPinMaster = new Pin_Master__c(Name='560034', AOSI_Region__c='South',
                                                       AOSI_State__c='Karnataka', AOSI_Type__c='Local',
                                                       AOSI_City__c='Bangalore');
        insert objPinMaster;
        
        Pin_Master__c objPinMasertInserted = [Select Id, Name From Pin_Master__c Where Id =: objPinMaster.Id];
        System.assertEquals(objPinMasertInserted.Name, '560034');
        
        //Account new record
        Account objAccount = new Account(Name='Test GPS Acc',   AOSI_Region__c='South',
                                         AOSI_State__c='KARNATAKA', AOSI_Categories__c='Distributor',
                                         AOSI_Email__c='testGPS@gmail.com', Phone='9011223344',
                                         Customer_Code__c='10001', AOSI_Pin_Code__c=objPinMaster.Id,
                                         AOSI_Related_Sales_Manager__c='Rajesh Kumar',
                                         AOSI_Related_Service_Manager__c='005e00000038TOu');
        Insert objAccount;
        
        //Contact new record
        Contact objContact = new Contact(LastName='TestGPS', AccountId=objAccount.Id, Mobile__c = '8893836688');
        insert objContact;
        
        //Finaly create Case
        Case ca = new Case(Subject='Test Controller Acct Case', ContactId=objContact.id, Status='New',Origin='Phone');
        insert ca;
		*/

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
        oServEngg.PIN_Code__c			=	'600114';
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
            
            AOSI_GPS_CaseDetailController objCaseDetail = new AOSI_GPS_CaseDetailController();
            objCaseDetail.getListOfOpenCases();
        } catch ( Exception ex ) { System.debug('*** Exception in test class Test_AOSI_GPS_CaseDetail(AOSI_GPS_CaseDetailMethod) *** ' + ex); }
        
        test.stopTest();
    }
    
    /************************************************
	@ Method Name:	AOSI_GPS_CaseDetailWithResourceAndMap
	@ Description:	Test method for AOSI_GPS_CaseDetailWithResourceAndMap class to get the related Resources for selected case from CaseDetailPage.
	************************************************/
    static testMethod void AOSI_GPS_CaseDetailWithResourceAndMap(){
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

        ASP_Rate_Master__c oAspRateMaster   =   TestHelpUtility.getASPRateMaster('Test Rate Master', DefineConstant.PROD_VERTICAL_WT);
        insert oAspRateMaster;

        ASP__c oASP =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
        oASP.AOSI_Approval_Status__c= 'Approved';
        
        insert oASP;
        
        list<Service_Engineer__c> lstResources		=	new List<Service_Engineer__c>();
        Service_Engineer__c oServEngg1   			=   TestHelpUtility.getResource();
        oServEngg1.Name								=	'Test Resource 1000';
        oServEngg1.PIN_Code__c						=	'600114';
        oServEngg1.AOSI_ASP__c =oASP.Id;
        oServEngg1.Type__c = 'ASP Technician';
        lstResources.add(oServEngg1);
        
        Service_Engineer__c oServEngg2   			=   TestHelpUtility.getResource();
        oServEngg2.Name								=	'Test Resource 2000';
        oServEngg2.PIN_Code__c						=	'600114';
        oServEngg2.AOSI_ASP__c						=	oASP.Id;
        oServEngg2.Type__c							=	'ASP Technician';
        oServEngg2.AOSI_City__c						=	'Chennai';
        lstResources.add(oServEngg2);

        Service_Engineer__c oServEngg3   			=   TestHelpUtility.getResource();
        oServEngg3.Name								=	'Test Resource 3000';
        oServEngg3.PIN_Code__c						=	'600114';
        oServEngg3.AOSI_ASP__c						=	oASP.Id;
        oServEngg2.AOSI_City__c						=	'Chennai';
        oServEngg3.Type__c							=	'ASP Technician';
        lstResources.add(oServEngg3);
        
        insert lstResources;
        system.debug('lstResources'+lstResources);
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Service Case',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth); 
        oContactSouth.MailingCity		=	'Chennai';   
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
		//insert oCase;
        
        Case oCase1                          =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                        =   DefineConstant.CASE_REASON_SERVICE;
        oCase1.AOSI_Customer_Concern__c      =   'Bad Smell';
        oCase1.AOSI_Appointment_Date__c = System.today();
        insert oCase1;
        oCase1.Service_Engineer__c = lstResources[0].Id;
        update oCase1;
		/*
		// System bydefault creating attendence for each new resource. so no need here.
        List<Attendence__c> lstAttendence	=	new List<Attendence__c>();
        Attendence__c objResAtt1			=	new Attendence__c();
        objResAtt1.AOSI_Service_Engineer__c	=	lstResources[0].Id;
        objResAtt1.AOSI_Date__c				=	system.today()+7;
        objResAtt1.AOSI_Present__c			=	true;
        lstAttendence.add(objResAtt1);
		
        system.debug('lstAttendence'+lstAttendence);
        
		insert lstAttendence;
        */

        try {
            insert oCase;
            system.debug('********************oCase****************** '+oCase.id);
            
            //Formating date and time as same as getting from page to put into apex:param appDate. 
            String strAppointmentDate = (system.today().Month()) + '/' + (system.today().Day()) + '/' + (system.today().Year()) + ' ' + '11:45' + ' ' + 'PM';
            
            
            PageReference pageRef = Page.AOSI_GPS_CaseDetailWithResourceAndMap;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('caseId', oCase.Id);
            ApexPages.currentPage().getParameters().put('appDate', strAppointmentDate);
            ApexPages.currentPage().getParameters().put('description', 'Test Desc');
            ApexPages.currentPage().getParameters().put('resId', lstResources[1].Id);
             
            AOSI_GPS_CaseDetailWithResourceAndMap objCaseMap	=	new AOSI_GPS_CaseDetailWithResourceAndMap();
			objCaseMap.getResourceCaseDetails();
            objCaseMap.getResourceDetails();
            
            //If resource and contact city matching
            objCaseMap.objSelectedCase.Service_Engineer__c	=	lstResources[1].Id;
            objCaseMap.saveCaseWithResource();
            
            objCaseMap.saveCaseByPopDetails();
            
            /*
            //If resource not selected 
            objCaseMap.objSelectedCase.Service_Engineer__c	=	null;
            objCaseMap.saveCaseWithResource();
            /*
            //If resource and contact city not matching
            objCaseMap.objSelectedCase.Service_Engineer__c	=	lstResources[2].Id;
            objCaseMap.saveCaseWithResource();
			*/  
            
        } catch ( Exception ex ) { System.debug('*** Exception in test class Test_AOSI_GPS_CaseDetail(AOSI_GPS_CaseDetailWithResourceAndMap) *** ' + ex); }
        
        test.stopTest();
    }
    
    /************************************************
	@ Method Name:	AOSI_GPS_CaseDetailWithResourceAndMapErr
	@ Description:	Test method for AOSI_GPS_CaseDetailWithResourceAndMap class to get cover the else/exception part for selected case from CaseDetailPage.
	************************************************/
    static testMethod void AOSI_GPS_CaseDetailWithResourceAndMapErr(){
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

        ASP_Rate_Master__c oAspRateMaster   =   TestHelpUtility.getASPRateMaster('Test Rate Master', DefineConstant.PROD_VERTICAL_WT);
        insert oAspRateMaster;

        ASP__c oASP =   TestHelpUtility.getASP(uASPAosi, oAspRateMaster);
        oASP.AOSI_Approval_Status__c= 'Approved';
        
        insert oASP;
        
        list<Service_Engineer__c> lstResources		=	new List<Service_Engineer__c>();
        Service_Engineer__c oServEngg1   			=   TestHelpUtility.getResource();
        oServEngg1.Name								=	'Test Resource 1000';
        oServEngg1.PIN_Code__c						=	'600114';
        oServEngg1.AOSI_ASP__c 						=	oASP.Id;
        oServEngg1.Type__c							= 	'ASP Technician';
        lstResources.add(oServEngg1);
        
        Service_Engineer__c oServEngg2   			=   TestHelpUtility.getResource();
        oServEngg2.Name								=	'Test Resource 2000';
        oServEngg2.PIN_Code__c						=	'600114';
        oServEngg2.AOSI_ASP__c						=	oASP.Id;
        oServEngg2.Type__c							=	'ASP Technician';
        oServEngg2.AOSI_City__c						=	'Chennai';
        lstResources.add(oServEngg2);

        Service_Engineer__c oServEngg3   			=   TestHelpUtility.getResource();
        oServEngg3.Name								=	'Test Resource 3000';
        oServEngg3.PIN_Code__c						=	'600114';
        oServEngg3.AOSI_ASP__c						=	oASP.Id;
        oServEngg2.AOSI_City__c						=	'Bangalore';
        oServEngg3.Type__c							=	'ASP Technician';
        lstResources.add(oServEngg3);
        
        insert lstResources;
        system.debug('lstResources'+lstResources);
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
		//insert oCase;
        
        Case oCase1                          =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                        =   DefineConstant.CASE_REASON_SERVICE;
        oCase1.AOSI_Customer_Concern__c      =   'Bad Smell';
        oCase1.AOSI_Appointment_Date__c = System.today();
        insert oCase1;
        oCase1.Service_Engineer__c = lstResources[0].Id;
        update oCase1;
		
        try {
            insert oCase;
            system.debug('********************oCase****************** '+oCase.id);
            
            String strAppointmentDate = (system.today().Month()) + '/' + (system.today().Day() -1) + '/' + (system.today().Year()) + ' ' + '11:45' + ' ' + 'PM';
            
            
            PageReference pageRef = Page.AOSI_GPS_CaseDetailWithResourceAndMap;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('caseId', oCase.Id);
            ApexPages.currentPage().getParameters().put('flag', 'true');
            
            ApexPages.currentPage().getParameters().put('appDate', strAppointmentDate);
            ApexPages.currentPage().getParameters().put('description', 'Test Desc');
            ApexPages.currentPage().getParameters().put('resId', lstResources[1].Id);
            
            AOSI_GPS_CaseDetailWithResourceAndMap objCaseMap	=	new AOSI_GPS_CaseDetailWithResourceAndMap();
			objCaseMap.getResourceCaseDetails();
            objCaseMap.getResourceDetails();
            objCaseMap.strSelectedResource	=	lstResources[2].Id;
            
            objCaseMap.saveCaseByPopDetails();
            
            //If resource not selected 
            objCaseMap.objSelectedCase.Service_Engineer__c	=	null;
            objCaseMap.saveCaseWithResource();
            
            //If resource and contact city not matching
            AOSI_GPS_CaseDetailWithResourceAndMap objCaseMap2	=	new AOSI_GPS_CaseDetailWithResourceAndMap();
            objCaseMap2.objSelectedCase.Service_Engineer__c		=	lstResources[2].Id;
            objCaseMap2.saveCaseWithResource();
			 
        } catch ( Exception ex ) { System.debug('*** Exception in test class Test_AOSI_GPS_CaseDetail(AOSI_GPS_CaseDetailWithResourceAndMapErr) *** ' + ex); }
        
        test.stopTest();
    }
}