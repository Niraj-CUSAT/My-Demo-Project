/*****************************************************************************************************************************************************
 * Class Name   : AOSI_CaseTrigger 
 * Created By   : Pooja P Bhat
 * Created Date : 21-SEPTEMBER-2015
 * Description  : Case trigger for AOS India record type
****************************************************************************************************************************************************/
trigger AOSI_AOSIContractTrigger on AOSI_Contract__c (before update, after insert, after update, after delete) {
    
    AOSI_AOSIContractTriggerHandler oContractHandler    =   new AOSI_AOSIContractTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap);
    
    if( trigger.isBefore ) {       
        if ( trigger.isUpdate ) {
            if(!AOSI_UtilRecursionHandler.isContractBeforeUpdateRecursive) {
                AOSI_UtilRecursionHandler.isContractBeforeUpdateRecursive = ((!test.isRunningTest())?true:false);
                oContractHandler.beforeUpdateHandler();
            }  
        }
    }
    
    if ( trigger.isAfter ) {
        if( trigger.isInsert ) {
            oContractHandler.afterInsertHandler();
        }
        if ( trigger.isUpdate ) {
            if(!AOSI_UtilRecursionHandler.isContractAfterUpdateRecursive) {
                AOSI_UtilRecursionHandler.isContractAfterUpdateRecursive = ((!test.isRunningTest())?true:false);
                oContractHandler.afterUpdateHandler();
            } 
        }
        if ( trigger.isDelete ) {
            oContractHandler.afterDeleteHandler();
        }
    }
}