public Class ExpenseTriggerHandlerCls{
    
    
    //Method to create Phone, internet LineItems 
    public static void createDefaultLineItems(list<ISP_Expense_Report__c> newList) {
    
        list<ISP_Expense_Line_Item__c> expLineItemList = new list<ISP_Expense_Line_Item__c>();
        
        for(ISP_Expense_Report__c exp :newList){
            
            //Phone Expense line Item
            ISP_Expense_Line_Item__c phoneExp = new ISP_Expense_Line_Item__c(
            Expense_Report__c                 = exp.id,
            Expenditure_Type__c               = 'Phone',
            exp_Amount__c                     =  500,
            Date__c                           = System.Today());
            expLineItemList.add(phoneExp);
            
            //Internet Expense line Item
            ISP_Expense_Line_Item__c internetExp = new ISP_Expense_Line_Item__c(
            Expense_Report__c                 = exp.id,
            Expenditure_Type__c               = 'Internet',
            exp_Amount__c                     =  400,
            Date__c                           = System.Today());
            expLineItemList.add(internetExp);
        }
        
        if(!expLineItemList.isEmpty()){
            insert expLineItemList;
        }
    }
    
    
    //Method to validate the only one Expense record creation for each month
    
    public static void validateExpenseReportCreation(list<ISP_Expense_Report__c> newList) {
        
        set<id> currentOwnerIds= new set<id>();
        Map<id,ISP_Expense_Report__c> currentMonthExpMap = new Map<id,ISP_Expense_Report__c>();
        
        //Getting new record ownerId to filter the current month records
        for(ISP_Expense_Report__c exp :newList){
            currentOwnerIds.add(exp.ownerId);
        }
        
        //Querying the current user Expense report records for current month
        for(ISP_Expense_Report__c exp : [select id, name,ownerId from ISP_Expense_Report__c where Date__c = THIS_MONTH AND ownerId in: currentOwnerIds]){
            currentMonthExpMap.put(exp.ownerId,exp);
        }
        
        //Add error to new records which are already created for current month
        for(ISP_Expense_Report__c exp : newList){
            if(!currentMonthExpMap.isEmpty() && currentMonthExpMap.containsKey(exp.ownerId)){
      
                exp.addError('This Month Expense alreay created, Expense is ' + ' <a href= \'/'+currentMonthExpMap.get(exp.ownerId).id+'\'>' + currentMonthExpMap.get(exp.ownerId).name + '</a>', false);

        }
    }
}
}