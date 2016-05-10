/*****************************************************************************************************************************************************
 * Class Name   : AOSI_caseTrackingControllerTest
 * Created By   : Rajesh Kumar
 * Created Date : 23-DECEMBER-2015
****************************************************************************************************************************************************/
@isTest
public class AOSI_caseTrackingControllerTest {
    
    static testmethod void test1()
    {
        

        CCTSettings__c settings=new CCTSettings__c();
        settings.Name='Default';
        settings.Customer_Call_Tracking_URL__c='http://www.test.com';
        settings.Display_Name__c='Rajesh';
        settings.Email_Template_Id__c='test';
        settings.Feedback_URL__c='http://www.test.com';
        settings.Sender_Email__c='test@test.com';
        insert settings;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Manufactured_Serial_Numbers__c serialnumber= new Manufactured_Serial_Numbers__c();
        serialnumber.Name='B0800104041234';
		insert serialnumber;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        insert oCaseContrctReq;

        oCaseContrctReq=[select Contact.MobilePhone,AOSI_Preferred_Color__c,Assignment_End_Time__c,Contact.FirstName,Contact.LastName,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet,Contact.OtherPhone,AOSI_Appointment_Date__c,AOSI_Cancelled_On_HOLD_Reason__c,Assignment_Start_Time__c,Asset.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Contact.Email,AOSIProduct__r.Name,AOSIProduct__c,Id,ContactId,AOSI_Total_Charges__c,AOSI_Discount__c,AOSI_New_Final_Amount__c,AOSI_Transaction_Number__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,CaseNumber, Service_Engineer__r.Name,Status,Service_Engineer_Phone__c,Reason,CreatedDate,ClosedDate,Contact_Name__c,Contact_Address__c,LOC_Contact_Email__c,Contact_Other_Phone__c,Contact_Phone__c from Case where  Id=:oCaseContrctReq.Id ] ;
		
        Escalation__c objEscalation = new Escalation__c();
        objEscalation.Related_Case__c=oCaseContrctReq.Id;
        objEscalation.Escalation_Reason__c='Test';
        objEscalation.Origin__c='Website';
        insert objEscalation;
        
        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.casenumber = oCaseContrctReq.CaseNumber;
        controller.contactnumber = oContact.Phone;
        controller.servicecharges=null;
        controller.customer_case=oCaseContrctReq;
        controller.displayPopup =false;
        controller.displayfeedbackform=false;
        controller.escalation_mail_content='Test';
        controller.displaymainpageerror=false; 
        controller.displaysuccessfeedbackmessage=false; 
        controller.mainpageerror='Test';
        controller.expired=false;
        ApexPages.currentPage().getParameters().put('casenumber', oCaseContrctReq.CaseNumber);
        ApexPages.currentPage().getParameters().put('contactnumber', oContact.Phone);
        controller.getCaseHistory();
        controller.showfeedbackform();
        controller.cancelescalation();
        controller.escalationHandler();
        
        controller.hidefeedbackform();
        controller.logOut();
        controller.showfeedbackform();
        controller.showPopup();

        
    }
    
    static testmethod void wrongmobilenumber()
    {
        

        CCTSettings__c settings=new CCTSettings__c();
        settings.Name='Default';
        settings.Customer_Call_Tracking_URL__c='http://www.test.com';
        settings.Display_Name__c='Rajesh';
        settings.Email_Template_Id__c='test';
        settings.Feedback_URL__c='http://www.test.com';
        settings.Sender_Email__c='test@test.com';
        insert settings;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Manufactured_Serial_Numbers__c serialnumber= new Manufactured_Serial_Numbers__c();
        serialnumber.Name='B0800104041234';
		insert serialnumber;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        insert oCaseContrctReq;

        oCaseContrctReq=[select Contact.MobilePhone,AOSI_Preferred_Color__c,Assignment_End_Time__c,Contact.FirstName,Contact.LastName,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet,Contact.OtherPhone,AOSI_Appointment_Date__c,AOSI_Cancelled_On_HOLD_Reason__c,Assignment_Start_Time__c,Asset.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Contact.Email,AOSIProduct__r.Name,AOSIProduct__c,Id,ContactId,AOSI_Total_Charges__c,AOSI_Discount__c,AOSI_New_Final_Amount__c,AOSI_Transaction_Number__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,CaseNumber, Service_Engineer__r.Name,Status,Service_Engineer_Phone__c,Reason,CreatedDate,ClosedDate,Contact_Name__c,Contact_Address__c,LOC_Contact_Email__c,Contact_Other_Phone__c,Contact_Phone__c from Case where  Id=:oCaseContrctReq.Id ] ;

        
        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.casenumber = oCaseContrctReq.CaseNumber;
        controller.contactnumber = '8900003333';
        controller.servicecharges=null;
        controller.customer_case=oCaseContrctReq;
        controller.displayPopup =false;
        controller.displayfeedbackform=false;
        controller.escalation_mail_content='Test';
        controller.displaymainpageerror=false; 
        controller.displaysuccessfeedbackmessage=false; 
        controller.mainpageerror='Test';
        controller.expired=false;
        ApexPages.currentPage().getParameters().put('casenumber', oCaseContrctReq.CaseNumber);
        ApexPages.currentPage().getParameters().put('contactnumber', '8900003333');
        controller.getCaseHistory();
        

        
    }
    static testmethod void wrongcasenumber()
    {
        
        
        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.casenumber = '44444444';
        controller.contactnumber = '8900003333';
        controller.servicecharges=null;
        controller.customer_case=null;
        controller.displayPopup =false;
        controller.displayfeedbackform=false;
        controller.escalation_mail_content='Test';
        controller.displaymainpageerror=false; 
        controller.displaysuccessfeedbackmessage=false; 
        controller.mainpageerror='Test';
        controller.expired=false;
        ApexPages.currentPage().getParameters().put('casenumber', '44444444');
        ApexPages.currentPage().getParameters().put('contactnumber', '8900003333');
        controller.getCaseHistory();
        

        
    }
    
    /*
        static testmethod void closedCase()
    {
        

        CCTSettings__c settings=new CCTSettings__c();
        settings.Name='Default';
        settings.Customer_Call_Tracking_URL__c='http://www.test.com';
        settings.Display_Name__c='Rajesh';
        settings.Email_Template_Id__c='test';
        settings.Feedback_URL__c='http://www.test.com';
        settings.Sender_Email__c='test@test.com';
        insert settings;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Manufactured_Serial_Numbers__c serialnumber= new Manufactured_Serial_Numbers__c();
        serialnumber.Name='B0800104041234';
		insert serialnumber;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.Status='Open';
        insert oCaseContrctReq;
        
        Service_Engineer__c serviceengineer=TestHelpUtility.getResource();
		
        oCaseContrctReq.Service_Engineer__c=serviceengineer.Id;
        
        update oCaseContrctReq;
        
        oCaseContrctReq.AOSI_Case_Close_Time__c=system.now();
        oCaseContrctReq.Status='Closed';
    	update oCaseContrctReq;
        
        oCaseContrctReq=[select Contact.MobilePhone,AOSI_Preferred_Color__c,Assignment_End_Time__c,Contact.FirstName,Contact.LastName,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet,Contact.OtherPhone,AOSI_Appointment_Date__c,AOSI_Cancelled_On_HOLD_Reason__c,Assignment_Start_Time__c,Asset.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Contact.Email,AOSIProduct__r.Name,AOSIProduct__c,Id,ContactId,AOSI_Total_Charges__c,AOSI_Discount__c,AOSI_New_Final_Amount__c,AOSI_Transaction_Number__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,CaseNumber, Service_Engineer__r.Name,Status,Service_Engineer_Phone__c,Reason,CreatedDate,ClosedDate,Contact_Name__c,Contact_Address__c,LOC_Contact_Email__c,Contact_Other_Phone__c,Contact_Phone__c from Case where  Id=:oCaseContrctReq.Id ] ;
        Escalation__c objEscalation = new Escalation__c();
        objEscalation.Related_Case__c=oCaseContrctReq.Id;
        objEscalation.Escalation_Reason__c='Test';
        objEscalation.Origin__c='Website';
        insert objEscalation;
        
        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.casenumber = oCaseContrctReq.CaseNumber;
        controller.contactnumber = oContact.Phone;
        controller.servicecharges=null;
        controller.customer_case=oCaseContrctReq;
        controller.displayPopup =false;
        controller.displayfeedbackform=false;
        controller.escalation_mail_content='Test';
        controller.displaymainpageerror=false; 
        controller.displaysuccessfeedbackmessage=false; 
        controller.mainpageerror='Test';
        controller.expired=false;
        ApexPages.currentPage().getParameters().put('casenumber', oCaseContrctReq.CaseNumber);
        ApexPages.currentPage().getParameters().put('contactnumber', oContact.Phone);
        controller.getCaseHistory();
        controller.showfeedbackform();
        controller.cancelescalation();
        controller.escalationHandler();
        
        controller.hidefeedbackform();
        controller.logOut();
        controller.showfeedbackform();
        controller.showPopup();

        
    }
    */
     static testmethod void partiallyClosed()
    {
        

        CCTSettings__c settings=new CCTSettings__c();
        settings.Name='Default';
        settings.Customer_Call_Tracking_URL__c='http://www.test.com';
        settings.Display_Name__c='Rajesh';
        settings.Email_Template_Id__c='test';
        settings.Feedback_URL__c='http://www.test.com';
        settings.Sender_Email__c='test@test.com';
        insert settings;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Manufactured_Serial_Numbers__c serialnumber= new Manufactured_Serial_Numbers__c();
        serialnumber.Name='B0800104041234';
		insert serialnumber;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.ClosedDate=System.today();
        oCaseContrctReq.AOSI_Case_Close_Time__c=System.now();
        oCaseContrctReq.Status='Partially Closed';
        insert oCaseContrctReq;
        
        Service_Charges__c charges=new Service_Charges__c();
        charges.Case__c=oCaseContrctReq.Id;
        insert charges;

        oCaseContrctReq=[select Contact.MobilePhone,AOSI_Preferred_Color__c,Assignment_End_Time__c,Contact.FirstName,Contact.LastName,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet,Contact.OtherPhone,AOSI_Appointment_Date__c,AOSI_Cancelled_On_HOLD_Reason__c,Assignment_Start_Time__c,Asset.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Contact.Email,AOSIProduct__r.Name,AOSIProduct__c,Id,ContactId,AOSI_Total_Charges__c,AOSI_Discount__c,AOSI_New_Final_Amount__c,AOSI_Transaction_Number__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,CaseNumber, Service_Engineer__r.Name,Status,Service_Engineer_Phone__c,Reason,CreatedDate,ClosedDate,Contact_Name__c,Contact_Address__c,LOC_Contact_Email__c,Contact_Other_Phone__c,Contact_Phone__c from Case where  Id=:oCaseContrctReq.Id ] ;
        
        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.casenumber = oCaseContrctReq.CaseNumber;
        controller.contactnumber = oContact.Phone;
        controller.servicecharges=null;
        controller.customer_case=oCaseContrctReq;
        controller.displayPopup =false;
        controller.displayfeedbackform=false;
        controller.escalation_mail_content='Test';
        controller.displaymainpageerror=false; 
        controller.displaysuccessfeedbackmessage=false; 
        controller.mainpageerror='Test';
        controller.expired=false;
        ApexPages.currentPage().getParameters().put('casenumber', oCaseContrctReq.CaseNumber);
        ApexPages.currentPage().getParameters().put('contactnumber', oContact.Phone);
        controller.getCaseHistory();
        controller.showfeedbackform();
        controller.cancelescalation();
        controller.escalationHandler();
        
        controller.hidefeedbackform();
        controller.logOut();
        controller.showfeedbackform();
        controller.showPopup();

        
    }
    
         static testmethod void blankEscalationReason()
    {
        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.escalation_mail_content='';
        controller.escalationHandler();
    }
    
    static testmethod void multipleEscalations()
    {
        

        CCTSettings__c settings=new CCTSettings__c();
        settings.Name='Default';
        settings.Customer_Call_Tracking_URL__c='http://www.test.com';
        settings.Display_Name__c='Rajesh';
        settings.Email_Template_Id__c='test';
        settings.Feedback_URL__c='http://www.test.com';
        settings.Sender_Email__c='test@test.com';
        insert settings;
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        insert oContact;
        
        Manufactured_Serial_Numbers__c serialnumber= new Manufactured_Serial_Numbers__c();
        serialnumber.Name='B0800104041234';
		insert serialnumber;
        
        Product2 oProd              =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c          =   DefineConstant.PROD_VERTICAL_WT;
        oProd.AOSI_Comprehensive_Warranty__c  =  2;
        oProd.Product_Warranty_AOS_India__c    =  7;
        oProd.AOSI_Element_Warranty__c      =  1;
        insert oProd;
        
        Asset oAsset              =   TestHelpUtility.getAsset(oContact, oProd);
        oAsset.AOSI_Membrane_Warranty__c   =   '1 Year';
        insert oAsset;
        
        
        Case oCaseContrctReq                    =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseContrctReq.Reason                  =   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.AOSI_Customer_Concern__c=   DefineConstant.CASE_REASON_CONTRACT_REQUEST;
        oCaseContrctReq.ClosedDate=System.today();
        oCaseContrctReq.AOSI_Case_Close_Time__c=System.now();
        oCaseContrctReq.Status='Open';
        insert oCaseContrctReq;
        
        Service_Charges__c charges=new Service_Charges__c();
        charges.Case__c=oCaseContrctReq.Id;
        insert charges;

        oCaseContrctReq=[select Contact.MobilePhone,AOSI_Preferred_Color__c,Assignment_End_Time__c,Contact.FirstName,Contact.LastName,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet,Contact.OtherPhone,AOSI_Appointment_Date__c,AOSI_Cancelled_On_HOLD_Reason__c,Assignment_Start_Time__c,Asset.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Contact.Email,AOSIProduct__r.Name,AOSIProduct__c,Id,ContactId,AOSI_Total_Charges__c,AOSI_Discount__c,AOSI_New_Final_Amount__c,AOSI_Transaction_Number__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,CaseNumber, Service_Engineer__r.Name,Status,Service_Engineer_Phone__c,Reason,CreatedDate,ClosedDate,Contact_Name__c,Contact_Address__c,LOC_Contact_Email__c,Contact_Other_Phone__c,Contact_Phone__c from Case where  Id=:oCaseContrctReq.Id ] ;


        PageReference pageRef = Page.AOSI_caseTracking;
        Test.setCurrentPage(pageRef);
        AOSI_caseTrackingController controller=new AOSI_caseTrackingController();
        controller.casenumber = oCaseContrctReq.CaseNumber;
        controller.contactnumber = oContact.Phone;
        controller.servicecharges=null;
        controller.customer_case=oCaseContrctReq;
        controller.displayPopup =false;
        controller.displayfeedbackform=false;
        controller.escalation_mail_content='Test';
        controller.displaymainpageerror=false; 
        controller.displaysuccessfeedbackmessage=false; 
        controller.mainpageerror='Test';
        controller.expired=false;
        ApexPages.currentPage().getParameters().put('casenumber', oCaseContrctReq.CaseNumber);
        ApexPages.currentPage().getParameters().put('contactnumber', oContact.Phone);
        controller.getCaseHistory();
        controller.showfeedbackform();
        controller.cancelescalation();
        controller.escalationHandler(); 
        controller.hidefeedbackform();
        controller.logOut();
        controller.showfeedbackform();
        controller.showPopup();

        
    }
}