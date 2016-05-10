/****Field Name: PRRApprovalHistoryTest
    Created By:Dhriti Krishna Ghosh Moulick
    Modified By:
    Description:This Test class is used to display PRR Approval History records 
*****/
@isTest
private class PRRApprovalHistoryTest {
public Static testmethod void unitTest1(){
	
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
             
      /* Service_Engineer__c se = new Service_Engineer__c();//Inserting Service Engineer 
       se.Name = 'Test SE';
       se.Mobile_Number__c = '8080808080';
       insert se;*/
       
       Service_Engineer__c se = TestHelpUtility.getResource();
       insert se;
       
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
       
       Case csrRecord = new Case();//Inserting Case
       csrRecord.status='New';
       csrRecord.AOSI_Cancelled_On_HOLD_Reason__c='Replacement Processing';
       csrRecord.AOSI_Appointment_Date__c=system.today().adddays(1);
      // csrRecord.recordtypeid = Rtid;
       csrRecord.reason =  'Sales query';   
       csrRecord.AOSI_Category_of_Sales_Query__c='Interested';    
       csrRecord.contactid = ctDetails.id;
       csrRecord.Assetid = ast.id;      
       csrRecord.AOSIProduct__c= prDetails.id;
       csrRecord.Service_Engineer__c = se.id;
       csrRecord.AOSI_Sales_Query_Reference__c ='Newspaper';
    	csrRecord.AOSI_Vertical__c	=	'Water Heater';
       insert csrRecord;
        
       PRR__c PRR=new PRR__c();//Inserting PRR
       PRR.AOSI_Case__c=csrRecord.id;
       PRR.AOSI_Asset__c=ast.id;
       PRR.AOSI_Type__c='Customer';
       PRR.AOSI_Justification__c='testsss';
       PRR.AOSI_Approval_Status__c='Approved';
       PRR.AOSI_Manufacture_Fault_Non_Repairable__c =true;
       insert PRR;
        
       PRRApprovalHistory prrApproval = new PRRApprovalHistory();
       prrApproval.refresh();
       prrApproval.first();
       prrApproval.last();
       prrApproval.previous();
       prrApproval.next();
       prrApproval.Download();
       prrApproval.DownloadAll();
  }
}