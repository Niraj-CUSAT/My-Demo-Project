/*****************************************************************************************************************************************************
 * Class Name   : AOSI_ContactTrigger
 * Created By   : Pooja P Bhat
 * Created Date : 6-OCT-2015
 * Description  : Contact trigger for AOS India record type
******************************************************************************************************************************************************/
trigger AOSI_ContactTrigger on Contact (before insert, before Update) {
    
    AOSI_ContactTriggerHandler  conHandler  =   new AOSI_ContactTriggerHandler(trigger.new, trigger.newMap, trigger.oldMap);
    
    if( trigger.isBefore ) {
        if ( trigger.isInsert ) {
            conHandler.beforeInsertHandler();
        }
        if ( trigger.isUpdate ) {
            if ( !AOSI_UtilRecursionHandler.isContactBeforeUpdateRecursive) {
                AOSI_UtilRecursionHandler.isContactBeforeUpdateRecursive = true;    
                conHandler.beforeUpdateHandler();
            }
        }
    }  
} //End of AOSI_ContractTrigger