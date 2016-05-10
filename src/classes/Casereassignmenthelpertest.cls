/**
created by: Bhanu Vallabhu, KVP Business Solution. created on : 9 sep 14
description: test class for Casereassignmenthelper
 */
@isTest
private class Casereassignmenthelpertest {

    static testMethod void myUnitTest() {
        
        /*Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;*/
        Id caseAOSIRecTy    =   [SELECT Id,Name FROM RecordType WHERE  DeveloperName =:'AOSI' and SobjectType =:'Case' LIMIT 1].Id;
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> oTCS    =   TestHelpUtility.getTimeCalCustSttng();
        insert oTCS;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        list<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        Account acc	=	 TestHelpUtility.getAccount();
        insert acc;
        
        Pin_Master__c pin = new Pin_Master__c();
        pin.AOSI_Region__c = 'South';
        pin.AOSI_State__c = 'Andra Pradesh';
        pin.AOSI_City__c = 'Hyderabad';               
        pin.Name = '560089';
        pin.AOSI_Type__c = 'City';
        insert pin;
        
        ID recordTypeId = [Select id,name,DeveloperName,SobjectType from RecordType where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
        
        Contact ct2 = new Contact();
        ct2.Lastname = 'Test2';
        ct2.RecordTypeId = recordTypeId;
        ct2.accountid = acc.id;
        ct2.phone = '9949643991';
        ct2.AOSI_Pin_Code__c= pin.id;
        ct2.MailingStreet = 'Test Mailing Street';
        insert ct2;
        
        Product2 pr = new Product2();
        pr.name = 'AOSI123456';
        pr.IsActive = True;
        pr.AOSIColorPanel_Free__c='Yes';
        pr.AOSI_Product_Code_for_Serial_Number__c='1234';
        pr.AOSI_Free_Installtion__c='Yes';
        pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
        insert pr;
        
        Asset ast = new Asset();
        ast.Name = '12341308130123';
        ast.contactid = ct2.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c = true;
        ast.PurchaseDate = system.today();
        insert ast;
        
        List<RecordType> recordType = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r Where SobjectType = 'Case' AND DeveloperName = 'AOSIndia'];
        
        Case caseObject = new Case();
        caseObject.ContactId = ct2.Id;
        caseObject.Reason = 'Color Panel (Free)';
        caseObject.AOSI_Region__c = 'North';
        caseObject.RecordTypeId = recordType[0].Id;
        caseObject.Assetid = ast.id;        
        caseObject.AOSIProduct__c= pr.id;
        caseObject.AOSI_Preferred_Color__c = 'Blue';
        caseObject.Courier_Number__c            =   'COU123456';
        insert caseObject;
        
        set<Id> panelids = new set<Id>();
        panelids.add(caseObject.Id);
        
    	Casereassignmenthelper CaseReassignmentObject = new Casereassignmenthelper();
    	Casereassignmenthelper.changeowner(panelids);
    	
    }
}