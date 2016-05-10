/**
 Created By : Bhupesh Kumar
 Date : 22.4.2015
 */
@isTest
private class TestSendSMSfromTrigger {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<RecordType> recordType = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r Where SobjectType = 'Case' AND DeveloperName != 'AOSIndia'];
        
        Case caseObject = new Case();
        caseObject.RecordTypeId = recordType[0].Id;
        insert caseObject;
        
        SendSMSfromTrigger sendSMSObject = new SendSMSfromTrigger();
        SendSMSfromTrigger.sendMethod('SMSText', caseObject, '7799665544');
        
    }
}