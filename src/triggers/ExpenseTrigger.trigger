trigger ExpenseTrigger on ISP_Expense_Report__c (before insert,after Insert) {

     
     //Validate the Expense record creation
     if(Trigger.isBefore && Trigger.isInsert){
         ExpenseTriggerHandlerCls.validateExpenseReportCreation(trigger.new);
     }
     
     
     //Create the default phone, Internet expense lineItems for each expense report
     if(Trigger.isafter && Trigger.isInsert){
         ExpenseTriggerHandlerCls.createDefaultLineItems(trigger.new);
     }

}