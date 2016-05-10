@isTest
public class ContactUpadteRegion_Test{
    public static Testmethod void updatePin(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Pin_Master__c pin = new Pin_Master__c();
        pin.AOSI_Region__c = 'South';
        pin.AOSI_State__c = 'Hyderabad';
        pin.AOSI_City__c = 'Andra Pradesh';       
        pin.Name = '560089';
        insert pin;
        
        Locality__c loc = new Locality__c();
        loc.Name = 'test';
        loc.AOSI_Pin_Master__c = pin.id;
        insert loc;
        
        Contact ct = new Contact();
        ct.Lastname = 'Test';
        ct.accountid = acc.id;
        ct.phone = '8861925544';
        ct.AOSI_Locality__c = loc.id;
        ct.AOSI_Pin_Code__c= pin.id;
        ct.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
        test.starttest();
        insert ct;
        test.stoptest();
    }
}