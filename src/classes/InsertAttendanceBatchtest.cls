/*createdby: Bhanu vallabhu;Created on : 3 jun 14;
description : test class for insertAtteandancebatch class. 
 */
@isTest
private class InsertAttendanceBatchtest {

    static testMethod void myUnitTest() {
        City_Master__c CM=new City_Master__c();
        CM.name='Bangalore';
        insert CM;
        Service_Engineer__c se = new Service_Engineer__c();
        se.Name = 'Test';
        se.Mobile_Number__c = '9222222244';
        se.AOSI_Active__c = TRUE;
        Se.City_Master__c=CM.id;
        Se.AOSI_City__c=CM.name;
        insert se;
        
        Attendence__c att = new Attendence__c();
        att.AOSI_Service_Engineer__c = se.id;
        att.AOSI_Date__c = System.Today().adddays(89);
        insert att;
        
        scheduleAttendanceRecords sar = new scheduleAttendanceRecords();
        sar.execute(null);

    }
}