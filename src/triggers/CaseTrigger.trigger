trigger CaseTrigger on Case (after insert, after update, before insert, before update) {
    
    CaseTriggerHandler objCaseHandler = new CaseTriggerHandler(trigger.new, trigger.newMap, trigger.oldMap);
        
        if ( trigger.isInsert && trigger.isBefore ) {
            system.debug('^^ before insert'+ trigger.new);
            objCaseHandler.beforeInsertHandler();
        }
        
        if ( trigger.isInsert && trigger.isAfter ) { 
            system.debug('^^ after insert'+ trigger.new); 
            objCaseHandler.afterInsertHandler();
        } 
        
        if ( trigger.isUpdate && trigger.isBefore ) {
            system.debug('^^ before update'+ trigger.new);
            objCaseHandler.beforeUpdateHandler();
        }
   
        if ( trigger.isUpdate && trigger.isAfter ) {  
            system.debug('^^ after update'+ trigger.new);    
             objCaseHandler.afterUpdateHandler(); 
        } 

}