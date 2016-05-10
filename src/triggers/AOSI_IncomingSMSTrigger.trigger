/*****************************************************************************************************************************************************
 * Class Name   : AOSI_IncomingSMSTrigger
 * Created By   : Pooja P Bhat
 * Created Date : 29-SEPTEMBER-2015
 * Description  : Contact trigger for AOS India record type
******************************************************************************************************************************************************/
trigger AOSI_IncomingSMSTrigger on smagicinteract__Incoming_SMS__c (after insert, after update) {
    
    AOSI_IncomingSMSTriggerHandler  oInSMS  =   new AOSI_IncomingSMSTriggerHandler(trigger.new, trigger.newMap, trigger.oldMap);
    
    if( trigger.isAfter) {
        if( trigger.isInsert ) {
            oInSMS.afterInsertHandler();
        }
        if( trigger.isUpdate ) {
            if(!AOSI_UtilRecursionHandler.isIncomingSMSAfterUpdateRecursive) {
                AOSI_UtilRecursionHandler.isIncomingSMSAfterUpdateRecursive = true;
                oInSMS.afterUpdateHandler();
            }
        }
        
    }
}