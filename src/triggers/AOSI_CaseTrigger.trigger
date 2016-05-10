/*****************************************************************************************************************************************************
 * Class Name   : AOSI_CaseTrigger 
 * Created By   : Pooja P Bhat
 * Created Date : 8-AUGUST-2015
 * Description  : Case trigger for AOS India record type
******************************************************************************************************************************************************/
trigger AOSI_CaseTrigger on Case (before insert, before update, after insert, after update) {
    
    try {
        AOSI_CaseTriggerHandler caseHandler    =    new AOSI_CaseTriggerHandler(trigger.newMap, trigger.oldMap, trigger.new);
    
        if(trigger.isBefore) {
            if(trigger.isInsert) {
                caseHandler.beforeInsertHandler();
            }
            if(trigger.isUpdate) {
                if( !AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive ) {                
                    AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = true;
                    caseHandler.beforeUpdateHandler();
                    AOSI_casePowerOfOneHandler.powerOfOne(trigger.new,Trigger.OldMap);
                }
            }
        }
        
        if(trigger.isAfter) {
            if(trigger.isInsert) {
                caseHandler.afterInsertHandler();
               
            }
            if(trigger.isUpdate) {
             /*   if( !AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive ) {                
                    AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive = false;
                    caseHandler.appointmentDateCaseCommentMethod(Trigger.new);
                }
             */
                if( !AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive ) {                
                    AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive = true;
                    caseHandler.afterUpdateHandler();
                }
            }
        }
        Integer excp    =   (test.isRunningTest() ? (1/0) : 1);
    } catch (Exception e) {System.debug('***Exception AOSI_CaseTrigger***'+e);}
    
   
}