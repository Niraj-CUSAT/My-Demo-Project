/*
    Name:   AttachmentTriggerTest
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  14/04/2015
    Modified By:  
    Last Modified Date: 
    Description:Test Class,when attachment is attached,AOSI_Invoice_Attached__c checkbox is true.else it is false
    Methods Used: positiveTest
*/
@istest
Public class AttachmentTriggerTest{
   public Static testmethod void positiveTest(){//Positive test
     
        list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
     	system.debug('@@@@@@ record types'+recordTypes);
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Pin_Master__c pin =TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');
        insert pin;
        
        Contact ct = TestHelpUtility.getContact(acc,pin);
        insert ct;
        
        Product2 pr = new Product2();
        pr.name = 'AOSI123456';
        pr.IsActive = True;
        pr.AOSIColorPanel_Free__c='Yes';
        pr.AOSI_Product_Code_for_Serial_Number__c='1234';
        pr.AOSI_Free_Installtion__c='Yes';
        pr.AOSI_PM_Service__c = 'Yes';
      
        insert pr;
        
        Asset ast = new Asset();
        ast.Name = '12341212130001';
        ast.contactid =  ct.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        insert ast;
        
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
         Case caseInstallation = TestHelpUtility.getCase(ct, ast, pr);
        //caseInstallation.RecordTypeId        =   rtCase.Id;
        caseInstallation.Reason           =    DefineConstant.CASE_REASON_FREE_INSTALLATION;
        caseInstallation.AOSI_City__c        =   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
		system.debug('*******caseInstallation****'+caseInstallation);
        insert caseInstallation;
        system.debug('************query case****'+[SELECT Id,RecordtypeID FROM  Case Limit 1]);            
        PRR__c PRR=new PRR__c();
        PRR.AOSI_Case__c=caseInstallation.id;
        PRR.AOSI_Asset__c=ast.id;
        PRR.AOSI_Type__c='Customer';
        PRR.AOSI_Justification__c='testsss';
        PRR.AOSI_Approval_Status__c='Approved';
        PRR.AOSI_Manufacture_Fault_Non_Repairable__c =true;
        PRR.AOSI_Invoice_Attached__c=false;
        insert PRR;
        test.starttest();      
        ApexPages.StandardController controller = new ApexPages.StandardController(PRR);
        apexpages.currentpage().getparameters().put('Id',PRR.id);  
        PRRInline PRRCont=new PRRInline(controller );
        test.stopTest();
    }
       
    public Static testmethod void negativeTest(){//Negative test
        list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
     
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Pin_Master__c pin =TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');
        insert pin;
         
        Contact ct = TestHelpUtility.getContact(acc,pin);
        insert ct;
        
        Product2 pr = new Product2();
        pr.name = 'AOSI123456';
        pr.IsActive = True;
        pr.AOSIColorPanel_Free__c='Yes';
        pr.AOSI_Product_Code_for_Serial_Number__c='1234';
        pr.AOSI_Free_Installtion__c='Yes';
        pr.AOSI_PM_Service__c = 'Yes';
      
        insert pr;
        
        Asset ast = new Asset();
        ast.Name = '12341212130001';
        ast.contactid =  ct.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        insert ast;
       
       	smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Case caseInstallation = TestHelpUtility.getCase(ct, ast, pr);
        caseInstallation.Reason           =    DefineConstant.CASE_REASON_FREE_INSTALLATION;
        caseInstallation.AOSI_City__c        =   'BANGALORE';
        caseInstallation.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;

        insert caseInstallation;
                     
        PRR__c PRR=new PRR__c();
        PRR.AOSI_Case__c=caseInstallation.id;
        PRR.AOSI_Asset__c=ast.id;
        PRR.AOSI_Type__c='Customer';
        PRR.AOSI_Justification__c='testsss';
        PRR.AOSI_Approval_Status__c='Approved';
        PRR.AOSI_Manufacture_Fault_Non_Repairable__c =true;
        insert PRR;
        
        Attachment attach=new Attachment();    
        attach.Name='Invoice';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=PRR.id;
        insert attach;
        
        Delete attach;
        
        test.starttest();     
        ApexPages.StandardController controller = new ApexPages.StandardController(PRR);
        apexpages.currentpage().getparameters().put('Id',PRR.id);  
        PRRInline PRRCont=new PRRInline(controller );
        test.stopTest();
    }
}