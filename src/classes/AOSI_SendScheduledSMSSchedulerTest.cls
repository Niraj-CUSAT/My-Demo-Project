/*****************************************************************************************************************************************************
 * Class Name   : AOSI_SendScheduledSMSSchedulerTest 
 * Created By   : Pooja P Bhat
 * Created Date : 5-OCT-2015
 * Description  : Test Class for AOSI_SendScheduledSMSBatch and AOSI_SendScheduledSMSScheduler
 * Methods      : static testMethod void unitTestMethod()
******************************************************************************************************************************************************/
@isTest
private class AOSI_SendScheduledSMSSchedulerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        smagicinteract__Scheduled_SMS__c sms1 = new smagicinteract__Scheduled_SMS__c();
        smagicinteract__Scheduled_SMS__c sms2 = new smagicinteract__Scheduled_SMS__c();
        smagicinteract__Scheduled_SMS__c sms3 = new smagicinteract__Scheduled_SMS__c();
        smagicinteract__Scheduled_SMS__c sms4 = new smagicinteract__Scheduled_SMS__c();
        smagicinteract__Scheduled_SMS__c sms5 = new smagicinteract__Scheduled_SMS__c();   
            
        sms1.smagicinteract__MobilePhone__c    =   '9834717777';
        sms1.smagicinteract__jobId__c          =   '1';
        sms1.smagicinteract__status__c         =   DefineConstant.SMS_STATUS_SCHEDULE;
        sms1.smagicinteract__SMSText__c        =   'Test Template1';
        sms1.smagicinteract__Scheduled_Date__c =   system.today();
        insert sms1; 
        sms2.smagicinteract__MobilePhone__c    =   '9834717777';
        sms2.smagicinteract__jobId__c          =   '1';
        sms2.smagicinteract__status__c         =   DefineConstant.SMS_STATUS_SCHEDULE;
        sms2.smagicinteract__SMSText__c        =   'Test Template2';
        sms2.smagicinteract__Scheduled_Date__c =   system.today();
        insert sms2; 
        sms3.smagicinteract__MobilePhone__c    =   '9834717777';
        sms3.smagicinteract__jobId__c          =   '1';
        sms3.smagicinteract__status__c         =   DefineConstant.SMS_STATUS_SCHEDULE;
        sms3.smagicinteract__SMSText__c        =   'Test Template3';
        sms3.smagicinteract__Scheduled_Date__c =   system.today();
        insert sms3; 
        sms4.smagicinteract__MobilePhone__c    =   '9834717777';
        sms4.smagicinteract__jobId__c          =   '1';
        sms4.smagicinteract__status__c         =   DefineConstant.SMS_STATUS_SCHEDULE;
        sms4.smagicinteract__SMSText__c        =   'Test Template4';
        sms4.smagicinteract__Scheduled_Date__c =   system.today();
        insert sms4; 
        sms5.smagicinteract__MobilePhone__c    =   '9834717777';
        sms5.smagicinteract__jobId__c          =   '1';
        sms5.smagicinteract__status__c         =   DefineConstant.SMS_STATUS_SCHEDULE;
        sms5.smagicinteract__SMSText__c        =   'Test Template5';
        sms5.smagicinteract__Scheduled_Date__c =   system.today();
        insert sms5;        
        
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Sample_Heading', CRON_EXP, new AOSI_SendScheduledSMSScheduler() ); 
        
        test.stopTest();
    }
}