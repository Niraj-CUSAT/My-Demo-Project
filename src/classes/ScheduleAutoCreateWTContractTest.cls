/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    09/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Test class for  Schedule class ScheduleAutoCreatePMCasesWTContract
**************************************************************************************************/
@isTest
private class ScheduleAutoCreateWTContractTest {

    static testMethod void myUnitTest() {
       RecordTypeDetails__c caseRT= new RecordTypeDetails__c();//Inserting Product Record Type Custom settings
       caseRT.Name='Case Name';
       caseRT.Developer_Name__c='AOSIndia';
       caseRT.SobjectType__c='Case';
       insert caseRT;
        
       Recordtype rtCase=DAL.getRecordTypeId(caseRT.Developer_Name__c,caseRT.SobjectType__c);//Calling DAL Class
       
       ScheduleAutoCreatePMCasesWTContract scheduleContractPM = new ScheduleAutoCreatePMCasesWTContract();
       test.startTest();
       String sch = '20 30 8 10 2 ?';
       String jobID = system.schedule('Merge Job', sch, scheduleContractPM);
       test.stopTest();
    }
}