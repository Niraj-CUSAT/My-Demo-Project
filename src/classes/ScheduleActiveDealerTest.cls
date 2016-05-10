/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    09/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Test class for  scheduling ScheduleAutoCreationofTaskActiveDealer
**************************************************************************************************/
@isTest
private class ScheduleActiveDealerTest {

    static testMethod void myUnitTest() {
       RecordTypeDetails__c accountRT= new RecordTypeDetails__c();//Inserting Product Record Type Custom settings
       accountRT.Name='Account Name';
       accountRT.Developer_Name__c='AOS_India';
       accountRT.SobjectType__c='Account';
       insert accountRT;
       
       Recordtype rtAccount=DAL.getRecordTypeId(accountRT.Developer_Name__c,accountRT.SobjectType__c);//Calling DAL Class
       
        ScheduleAutoCreationofTaskActiveDealer m = new ScheduleAutoCreationofTaskActiveDealer();
        test.startTest();
        String sch = '20 30 8 10 2 ?';
        String jobID = system.schedule('Merge Job', sch, m);
        test.stopTest();
    }
}