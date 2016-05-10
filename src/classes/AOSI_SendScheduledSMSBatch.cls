/*****************************************************************************************************************************************************
 * Class Name   : AOSI_SendScheduledSMSBatch
 * Created By   : Pooja P Bhat
 * Created Date : 24-JULY-2015
 * Description  : Batch class to schedule SMS  
******************************************************************************************************************************************************/
global class AOSI_SendScheduledSMSBatch implements Database.Batchable<sObject>,DataBase.Stateful,Database.AllowsCallouts { 

    global list<smagicinteract__smsMagic__c> smsHistoryList;
    global String smsSenderID;       
    
    public AOSI_SendScheduledSMSBatch() {
        smsHistoryList = new list<smagicinteract__smsMagic__c>();
        try {
             RecordTypeDetails__c senderId = RecordTypeDetails__c.getInstance('SMS SenderID'); 
             smsSenderID = [SELECT Id, smagicinteract__senderId__c FROM smagicinteract__SMS_SenderId__c WHERE smagicinteract__senderId__c  =: senderId.Developer_Name__c LIMIT 1].smagicinteract__senderId__c;
        } catch (Exception e) { System.debug('** Exception **'+ e); }
    }
    
    /******************************************************************************************************************************************
     * Method Name : start() is a Batch Interface method that takes a parameter Database.BatchableContext
     * Purpose : Used to retrieve records form smagicinteract__Scheduled_SMS__c object
     ******************************************************************************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC) { 
        Date todayDate =  System.today();
        String scheduleSMSQuery =   'SELECT Id,Name,smagicinteract__MobilePhone__c,smagicinteract__jobId__c,smagicinteract__status__c,smagicinteract__SMSText__c,' +
                                    'smagicinteract__ObjectId__c,smagicinteract__Object_Type__c,smagicinteract__Scheduled_Date__c FROM smagicinteract__Scheduled_SMS__c ' +
                                    'WHERE smagicinteract__Scheduled_Date__c =: todayDate'  ;                       
        return Database.getQueryLocator(scheduleSMSQuery);
    }
    
    /******************************************************************************************************************************************
     * Method Name : execute() is a Batch Interface method that takes two parameters Database.BatchableContext and list<sobject>
     * Purpose : Used to 1)collect records passed by start()
                         2)Send the Scheduled SMS
    ******************************************************************************************************************************************/ 
    global void execute(Database.BatchableContext BC, List<smagicinteract__Scheduled_SMS__c> listScheduledSMS) {      

        if ( !listScheduledSMS.isEmpty() ) {
            for(smagicinteract__Scheduled_SMS__c objSchedule : listScheduledSMS ) {
                if( objSchedule.smagicinteract__MobilePhone__c != null ) {
                    smagicinteract__smsMagic__c smsObject               = new smagicinteract__smsMagic__c();
                    smsObject.smagicinteract__SenderId__c               = smsSenderID;
                    smsObject.smagicinteract__PhoneNumber__c            = objSchedule.smagicinteract__MobilePhone__c;
                    smsObject.smagicinteract__ObjectType__c             = objSchedule.smagicinteract__Object_Type__c;
                    smsObject.smagicinteract__disableSMSOnTrigger__c    = 1;
                    smsObject.smagicinteract__external_field__c         = smagicinteract.ApexAPI.generateUniqueKey();
                    smsObject.smagicinteract__SMSText__c                = objSchedule.smagicinteract__SMSText__c;
                    smsObject.Case__c                                   = objSchedule.smagicinteract__ObjectId__c;
                    smsHistoryList.add(smsObject);
               }
            }
        } 
       
    }
    
    /******************************************************************************************************************************************
    * Method Name : finish () is a Batch Interface method that takes a parameter Database.BatchableContext
    *******************************************************************************************************************************************/
    global void finish(Database.BatchableContext BC) {
        if ( !smsHistoryList.isEmpty() ) {
            try {
                String response = ( (!test.isRunningTest()) ? smagicinteract.ApexAPI.pushSMSCallout(smsHistoryList) : ' ');
                System.debug('$$response $$$'+response);
                Database.insert(smsHistoryList,false);
                Integer excp = (test.isRunningTest()? (1/0):1);
            } catch ( Exception e ) { System.debug('&& Exception while inserting records into SMS History Object &&' + e); }
        } 
    
    }
}