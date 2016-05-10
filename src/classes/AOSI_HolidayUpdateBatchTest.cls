@isTest
private class AOSI_HolidayUpdateBatchTest{

    static testmethod void test() {
        // The query used by the batch job.
        String query = 'SELECT Id,AOSI_Name__c,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Region__c,AOSI_Type__c FROM AOSI_Holiday_Calendar__c WHERE AOSI_Type__c ='+'\''+'Planned'+'\'' +' AND AOSI_Start_Date__c = THIS_YEAR'; //,AOSI_State__c,AOSI_Location__c

       // Create some test Holiday calender items to be deleted
       //   by the batch job.
       List<AOSI_Holiday_Calendar__c> lstHoliday = new List<AOSI_Holiday_Calendar__c>();
       AOSI_Holiday_Calendar__c eachHoliday = new AOSI_Holiday_Calendar__c();
       eachHoliday.AOSI_Name__c= 'test Holiday';
       eachHoliday.AOSI_Start_Date__c= System.Today();
       eachHoliday.AOSI_End_Date__c= System.Today().addDays(1);
       eachHoliday.AOSI_Region__c= 'North';
       lstHoliday.add(eachHoliday);
       insert eachHoliday; 

       Test.startTest();
        AOSI_HolidayUpdateBatch batchHoliday = new AOSI_HolidayUpdateBatch();
        ID batchprocessid = Database.executeBatch(batchHoliday);
        batchHoliday.start(null);
        batchHoliday.execute(null,lstHoliday);
        batchHoliday.finish(null);      
       Test.stopTest();

    }
     static testmethod void test1() {
     Test.startTest();
     AOSI_HolidayUpdateBatchSchedule scheduleEachBatch = new AOSI_HolidayUpdateBatchSchedule();
     scheduleEachBatch.execute(null);
      Test.stopTest();
     }
}