@isTest
public class insertAttendanceRecordsTest
{
    public static testMethod void insertAttendanceRecordsTestMethod()
    {
        Service_Engineer__c se = new Service_Engineer__c();
        se.Name = 'Test';
        se.Mobile_Number__c = '9222222244';
        se.AOSI_Active__c = TRUE;
        insert se;
        
        Attendence__c att = new Attendence__c();
        att.AOSI_Service_Engineer__c = se.id;
        att.AOSI_Date__c = System.Today().adddays(89);
        insert att;
        
        insertAttendanceRecords iar = new insertAttendanceRecords();
        iar.execute(null);
        iar.deleteRecords();
        //iar.insertNewRecords(null);
        
        scheduleAttendanceRecords sar = new scheduleAttendanceRecords();
        sar.execute(null);
    }
}