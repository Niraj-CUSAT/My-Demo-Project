/**
 
 Created By : Bhupesh Kumar
 Date : 24.4.2015
 Description : Test class for the apex class "TBN_AlertsForCaseDetail".
 
 */
@isTest
private class TestTBN_AlertsForCaseDetail {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
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
        ast.Name = '12341212130001';
        ast.contactid =  ct2.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        insert ast;
        
        List<RecordType> recordType = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r Where SobjectType = 'Case' AND DeveloperName != 'AOSIndia'];
        
        Case c1 = new Case();
        c1.RecordTypeId = recordType[0].Id;
        insert c1;
        
        Alert__c objAlert = new Alert__c();
        objAlert.Name = 'Test Alert';
        objAlert.Alert_Message__c = 'Test Message';
        insert objAlert;
        
        Alert_Relationship__c objAR = new Alert_Relationship__c();
        objAR.Alert__c = objAlert.Id;
        objAR.Related_SObject__c = 'Case';
        insert objAR; 
        
        ConfiguredViewIds__c viewObject = new ConfiguredViewIds__c();
        viewObject.Name = c1.Id;
        viewObject.ViewId__c = c1.Id;
        insert viewObject;
        
        Apexpages.currentPage().getParameters().put('recordId',c1.Id);
        Apexpages.currentPage().getParameters().put('objectType','Case');
        
        TBN_AlertsForCaseDetail TBNObject = new TBN_AlertsForCaseDetail();
        
        TBNObject.getAlertMessages('Case', c1.Id);
        
    }
}