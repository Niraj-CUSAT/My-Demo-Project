/*
    Name:   PRRInlineTest
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  14/04/2015
    Modified By:  
    Last Modified Date: 
    Description:Test class for fetching Invoice Attached field from PRR
    Methods Used: positiveTest
*/
@istest
Public class PRRInlineTest{
   public Static testmethod void positiveTest(){
   	
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
	
       Account accDetails = TestHelpUtility.getAccount();//Inserting Account
       insert accDetails;
       
       Pin_Master__c pinDetails =  TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');//	Inserting Pin Master
       insert pinDetails;
       
    
        Contact ctDetails = TestHelpUtility.getContact(accDetails, pinDetails);
        insert ctDetails;
       
     
       Product2 prDetails = TestHelpUtility.getProduct();
       prDetails.name = 'AOSI123456';
       prDetails.IsActive = True;
       prDetails.AOSIColorPanel_Free__c='Yes';
       prDetails.AOSI_Product_Code_for_Serial_Number__c='1234';
       prDetails.AOSI_Free_Installtion__c='Yes';
       insert prDetails;
       
       Manufactured_Serial_Numbers__c manufac = new Manufactured_Serial_Numbers__c();//Inserting Manufactury Serial Number in Custom Settings
       manufac.Name='12341212130002';
       insert manufac;
        
       Asset ast = new Asset();
       ast.Name = '12341212130002';
       ast.contactid =  ctDetails.id;
       ast.Product2id = prDetails.id;
       ast.AOSI_Active__c=true;
       ast.PurchaseDate = system.today();
       insert ast ;
             
     
       Service_Engineer__c se = TestHelpUtility.getResource();
       insert se;
       
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        Case c = new Case();
        c.reason =  'Field Trial';        
        c.contactid = ctDetails.id;                
        c.AOSIProduct__c= prDetails.id;                
        c.AOSI_Region_picklist__c ='South';
        c.AOSI_State_Picklist__c ='Karnataka';
        c.AOSI_City_Picklist__c ='Bangalore';  
        test.starttest();
        insert c;
 
                     
        PRR__c PRR=new PRR__c();
        PRR.AOSI_Case__c=c.id;
        PRR.AOSI_Asset__c=ast.id;
        PRR.AOSI_Type__c='Customer';
        PRR.AOSI_Justification__c='testsss';
        PRR.AOSI_Approval_Status__c='Approved';
        PRR.AOSI_Manufacture_Fault_Non_Repairable__c =true;
        PRR.AOSI_Invoice_Attached__c=false;
        insert PRR;
             
        ApexPages.StandardController controller = new ApexPages.StandardController(PRR);
        apexpages.currentpage().getparameters().put('Id',PRR.id);  
        PRRInline PRRCont=new PRRInline(controller );
        test.stopTest();
       }
    public Static testmethod void negativeTest(){
        list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
	
       Account accDetails = TestHelpUtility.getAccount();//Inserting Account
       insert accDetails;
       
       Pin_Master__c pinDetails =  TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');//	Inserting Pin Master
       insert pinDetails;
       
    
        Contact ctDetails = TestHelpUtility.getContact(accDetails, pinDetails);
        insert ctDetails;
       
     
       Product2 prDetails = TestHelpUtility.getProduct();
       prDetails.name = 'AOSI123456';
       prDetails.IsActive = True;
       prDetails.AOSIColorPanel_Free__c='Yes';
       prDetails.AOSI_Product_Code_for_Serial_Number__c='1234';
       prDetails.AOSI_Free_Installtion__c='Yes';
       insert prDetails;
       
       Manufactured_Serial_Numbers__c manufac = new Manufactured_Serial_Numbers__c();//Inserting Manufactury Serial Number in Custom Settings
       manufac.Name='12341212130002';
       insert manufac;
        
       Asset ast = new Asset();
       ast.Name = '12341212130002';
       ast.contactid =  ctDetails.id;
       ast.Product2id = prDetails.id;
       ast.AOSI_Active__c=true;
       ast.PurchaseDate = system.today();
       insert ast ;
             
     
       Service_Engineer__c se = TestHelpUtility.getResource();
       insert se;
       
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        
        Case c = new Case();
        c.reason =  'Field Trial';        
        c.contactid = ctDetails.id;                
        c.AOSIProduct__c= prDetails.id;                
        c.AOSI_Region_picklist__c ='South';
        c.AOSI_State_Picklist__c ='Karnataka';
        c.AOSI_City_Picklist__c ='Bangalore';  
        insert c;
     
        PRR__c PRR=new PRR__c();
        PRR.AOSI_Case__c=c.id;
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
        
        test.starttest();     
        ApexPages.StandardController controller = new ApexPages.StandardController(PRR);
        apexpages.currentpage().getparameters().put('Id',PRR.id);  
        PRRInline PRRCont=new PRRInline(controller );
        test.stopTest();
       }
}