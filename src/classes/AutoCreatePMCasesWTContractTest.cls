/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    31/08/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Test class for Creating Auto PM Contract Cases for WT products
**************************************************************************************************/
@isTest
private class AutoCreatePMCasesWTContractTest {

    static testMethod void positiveTest() {
       
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       
      /* RecordTypeDetails__c contactrecordType = new RecordTypeDetails__c();//Inserting ContactRecord Type Custom settings
       contactrecordType.Name='Contact Name';
       contactrecordType.Developer_Name__c='AOS_India';
       contactrecordType.SobjectType__c='Contact';
       insert contactrecordType;
       
       Recordtype rtContact = DAL.getRecordTypeId(contactrecordType.Developer_Name__c,contactrecordType.SobjectType__c);//Calling DAL Class
       
       RecordTypeDetails__c productrecordType= new RecordTypeDetails__c();//Inserting Product Record Type Custom settings
       productrecordType.Name='Product Name';
       productrecordType.Developer_Name__c='AOSIndia';
       productrecordType.SobjectType__c='Product2';
       insert productrecordType;
       
       Recordtype rtProduct=DAL.getRecordTypeId(productrecordType.Developer_Name__c,productrecordType.SobjectType__c);//Calling DAL Class */
       
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
          
     //   Pin_Master__c oPinMaster = TestHelpUtility.getPinMaster('574104', 'South', 'Udupi', 'Karnataka');
      //  insert oPinMaster;
        
        Pin_Master__c oPinMaster	=	new Pin_Master__c();
    	oPinMaster.Name				=	'574104';
    	oPinMaster.AOSI_Region__c	=	'South';
    	oPinMaster.AOSI_City__c		=	'BANGALORE';
    	oPinMaster.AOSI_Type__c		=	'Upcountry';
    	oPinMaster.AOSI_State__c	=	'Karnataka';
    	oPinMaster.AOSI_Country__c	=	'India';
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
        insert oProd;
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  oContact.id;
        ast.Product2id = oProd.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
        
       /* RecordTypeDetails__c caserecordType= new RecordTypeDetails__c();//Inserting Product Record Type Custom settings
        caserecordType.Name='Case Name';
        caserecordType.Developer_Name__c='AOSIndia';
        caserecordType.SobjectType__c='Case';
        insert caserecordType;
       
        Recordtype rtCase=DAL.getRecordTypeId(caserecordType.Developer_Name__c,caserecordType.SobjectType__c);//Calling DAL Class
        
        RecordTypeDetails__c caserecordType1= new RecordTypeDetails__c();//Inserting Product Record Type Custom settings
        caserecordType1.Name='Case AOSI';
        caserecordType1.Developer_Name__c='AOSI';
        caserecordType1.SobjectType__c='Case';
        insert caserecordType1;
       
        Recordtype rtCase1=DAL.getRecordTypeId(caserecordType1.Developer_Name__c,caserecordType1.SobjectType__c);//Calling DAL Class */
        
        
       	smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Case caseInstallation = TestHelpUtility.getCase(oContact, ast, oProd);
        //caseInstallation.RecordTypeId				= 	rtCase.Id;
        caseInstallation.Reason 					=  	DefineConstant.CASE_REASON_FREE_INSTALLATION;
        caseInstallation.AOSI_City__c				=   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c 	= 	DefineConstant.CASE_REASON_FREE_INSTALLATION;
        insert caseInstallation;
        
        AMC_Master__c amcMaster = new AMC_Master__c();
        amcMaster.Name='Test AMC';
        amcMaster.AOSI_AMC_Amount__c=500;
        amcMaster.AOSI_Contract_Type__c='WT-AMC';
        amcMaster.Number_Of_PM_Visits__c='2';
        amcMaster.AOSI_Status__c='Active';
        amcMaster.MRP__c=400;
        amcMaster.AOSI_Contract_Period_In_Years__c='1';
        insert amcMaster;
        
        AOSI_Contract__c aosiContract = new AOSI_Contract__c();
        aosiContract.Name='Test Contract';
        aosiContract.AOSI_Asset__c=ast.Id;
        aosiContract.AOSI_AMC__c=amcMaster.Id;
        aosiContract.AOSI_Case__c=caseInstallation.Id;
        aosiContract.AOSI_Start_Date__c=System.today()-180;
        aosiContract.AOSI_Contract_Status__c='Active';
        aosiContract.AOSI_Base_Amount__c=200;
        aosiContract.AOSI_Mode_Of_Payment__c='Cash';
        aosiContract.AOSI_Amount_Received__c =true;
        aosiContract.AOSI_Discount__c=0;
        aosiContract.AOSI_Reference_Number__c='123';
        aosiContract.AOSI_Tax__c=12.5;
        aosiContract.AOSI_Payment_Collected_By__c='Test';
        aosiContract.AOSI_Invoice_Number__c='123';
        aosiContract.AOSI_Amount_Received_Date__c=System.today();
        aosiContract.AOSI_Invoice_Date__c=System.today();
        insert aosiContract;
        
        AutoCreatePMCasesWTContract auto = new AutoCreatePMCasesWTContract();
        database.executeBatch(auto);
    }
    
     static testMethod void negativeTest() {
   
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
     
        Pin_Master__c oPinMaster	=	new Pin_Master__c();
    	oPinMaster.Name				=	'574104';
    	oPinMaster.AOSI_Region__c	=	'South';
    	oPinMaster.AOSI_City__c		=	'BANGALORE';
    	oPinMaster.AOSI_Type__c		=	'Upcountry';
    	oPinMaster.AOSI_State__c	=	'Karnataka';
    	oPinMaster.AOSI_Country__c	=	'India';
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
        insert oProd;
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  oContact.id;
        ast.Product2id = oProd.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
      
        
        
       	smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Case caseInstallation = TestHelpUtility.getCase(oContact, ast, oProd);
        //caseInstallation.RecordTypeId				= 	rtCase.Id;
        caseInstallation.Reason 					=  	DefineConstant.CASE_REASON_FREE_INSTALLATION;
        caseInstallation.AOSI_City__c				=   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c 	= 	DefineConstant.CASE_REASON_FREE_INSTALLATION;
        insert caseInstallation;
        
        AMC_Master__c amcMaster = new AMC_Master__c();
        amcMaster.Name='Test AMC';
        amcMaster.AOSI_AMC_Amount__c=500;
        amcMaster.AOSI_Contract_Type__c='WT-AMC';
        amcMaster.Number_Of_PM_Visits__c='2';
        amcMaster.AOSI_Status__c='Active';
        amcMaster.MRP__c=400;
        amcMaster.AOSI_Contract_Period_In_Years__c='1';
        insert amcMaster;
        
        AOSI_Contract__c aosiContract = new AOSI_Contract__c();
        aosiContract.Name='Test Contract';
        aosiContract.AOSI_Asset__c=ast.Id;
        aosiContract.AOSI_AMC__c=amcMaster.Id;
        aosiContract.AOSI_Case__c=caseInstallation.Id;
        aosiContract.AOSI_Start_Date__c=System.today()-358; 
        aosiContract.AOSI_Contract_Status__c='Active';
        aosiContract.AOSI_Base_Amount__c=200;
        aosiContract.AOSI_Mode_Of_Payment__c='Cash';
        aosiContract.AOSI_Amount_Received__c =true;
        aosiContract.AOSI_Discount__c=0;
        aosiContract.AOSI_Reference_Number__c='123';
        aosiContract.AOSI_Tax__c=12.5;
        aosiContract.AOSI_Payment_Collected_By__c='Test';
        aosiContract.AOSI_Invoice_Number__c='123';
        aosiContract.AOSI_Amount_Received_Date__c=System.today();
        aosiContract.AOSI_Invoice_Date__c=System.today();
        insert aosiContract;
        
        AutoCreatePMCasesWTContract auto = new AutoCreatePMCasesWTContract();
        database.executeBatch(auto);
    }
    
     static testMethod void negative1Test() {
   
      list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
      
       
       Account oAcc = TestHelpUtility.getAccount();
       insert oAcc;
      
        
        Pin_Master__c oPinMaster	=	new Pin_Master__c();
    	oPinMaster.Name				=	'574104';
    	oPinMaster.AOSI_Region__c	=	'South';
    	oPinMaster.AOSI_City__c		=	'BANGALORE';
    	oPinMaster.AOSI_Type__c		=	'Upcountry';
    	oPinMaster.AOSI_State__c	=	'Karnataka';
    	oPinMaster.AOSI_Country__c	=	'India';
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
        insert oProd;
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  oContact.id;
        ast.Product2id = oProd.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
      
        
       	smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Case caseInstallation = TestHelpUtility.getCase(oContact, ast, oProd);
        //caseInstallation.RecordTypeId				= 	rtCase.Id;
        caseInstallation.Reason 					=  	DefineConstant.CASE_REASON_FREE_INSTALLATION;
        caseInstallation.AOSI_City__c				=   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c 	= 	DefineConstant.CASE_REASON_FREE_INSTALLATION;
        insert caseInstallation;
        
        AMC_Master__c amcMaster = new AMC_Master__c();
        amcMaster.Name='Test AMC';
        amcMaster.AOSI_AMC_Amount__c=500;
        amcMaster.AOSI_Contract_Type__c='WT-ACMC';
        amcMaster.Number_Of_PM_Visits__c='3';
        amcMaster.AOSI_Status__c='Active';
        amcMaster.MRP__c=400;
        amcMaster.AOSI_Contract_Period_In_Years__c='1';
        insert amcMaster;
        
        AOSI_Contract__c aosiContract = new AOSI_Contract__c();
        aosiContract.Name='Test Contract';
        aosiContract.AOSI_Asset__c=ast.Id;
        aosiContract.AOSI_AMC__c=amcMaster.Id;
        aosiContract.AOSI_Case__c=caseInstallation.Id;
        aosiContract.AOSI_Start_Date__c=System.today()-358; 
        aosiContract.AOSI_Contract_Status__c='Active';
        aosiContract.AOSI_Base_Amount__c=200;
        aosiContract.AOSI_Mode_Of_Payment__c='Cash';
        aosiContract.AOSI_Amount_Received__c =true;
        aosiContract.AOSI_Discount__c=0;
        aosiContract.AOSI_Reference_Number__c='123';
        aosiContract.AOSI_Tax__c=12.5;
        aosiContract.AOSI_Payment_Collected_By__c='Test';
        aosiContract.AOSI_Invoice_Number__c='123';
        aosiContract.AOSI_Amount_Received_Date__c=System.today();
        aosiContract.AOSI_Invoice_Date__c=System.today();
        insert aosiContract;
        
        AutoCreatePMCasesWTContract auto = new AutoCreatePMCasesWTContract();
        database.executeBatch(auto);
    }
}