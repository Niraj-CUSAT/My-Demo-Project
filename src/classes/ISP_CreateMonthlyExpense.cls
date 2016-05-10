Global class ISP_CreateMonthlyExpense implements Schedulable{

  public void createExpense(){
     list<Task> taskList = new list<Task>();
     Map<id,ISP_Expense_Report__c> expenseReportMap = new Map<id,ISP_Expense_Report__c>();
      for(user u : [select id from user where profileId in (select id from profile where name = 'Demo Promoter')]){
          ISP_Expense_Report__c report = new  ISP_Expense_Report__c ();
          report.Month__c = currentMonth(system.Today().Month());
          report.ownerId  = u.id;
          expenseReportMap.put(u.id,report);
          
      }
      
      if(!expenseReportMap.isEmpty()){
          insert expenseReportMap.values(); 
      }
      
      integer noOfDays   =  date.daysInMonth(system.today().Year(),system.today().Month());
      date lastDayInMonth=  date.newInstance(system.today().Year(),system.today().Month(),noOfDays);
      
       //Create task for monthly expense report
       for(user u : [select id from user where profileId in (select id from profile where name = 'Demo Promoter')]){
           if(!expenseReportMap.isEmpty() && expenseReportMap.containsKey(u.id)){
                
                Task task1         = new Task();
                task1.Subject      = 'Expense for ' +expenseReportMap.get(u.id).Month__c ;
                task1.Status       = 'Not Started';
                task1.Priority     = 'Normal';
                task1.IsReminderSet= True;
                task1.activityDate = lastDayInMonth;
                task1.OwnerId      = u.id;
                task1.WhatId       = expenseReportMap.get(u.id).id;
                taskList.add(task1);
               }
       }
       
       if(!tasklist.isEmpty()){
          insert tasklist;
          system.debug(tasklist);
      }
 }//End
 
  
  
  //Creating insert Demo Promoter Targets
  public void createDemoPromMonthlyTarget(){
  
      integer noOfDays   =  date.daysInMonth(system.today().Year(),system.today().Month());
      date lastDayInMonth=  date.newInstance(system.today().Year(),system.today().Month(),noOfDays);
      
      list<ISP_Target__c> targetList =  new list<ISP_Target__c>();
       //Create task for monthly expense report
       for(user u : [select id from user where profileId in (select id from profile where name = 'Demo Promoter')]){
           ISP_Target__c target = new ISP_Target__c(Assigned_To__c = u.id,From_date__c = system.today(),To_date__c = lastDayInMonth);
           targetList.add(target);
       }
       
       //Insert target objects
        if(!targetList.isEmpty()){
          insert targetList;
          system.debug(targetList);
      }
  
  }  
  
  
  public String currentMonth(integer monthNo){
   return monthNo == 1  ? 'January' :
          monthNo == 2  ? 'February' :
          monthNo == 3  ? 'March' :
          monthNo == 4  ? 'April' :
          monthNo == 5  ? 'May' :
          monthNo == 6  ? 'June' :
          monthNo == 7  ? 'July' :
          monthNo == 8  ? 'August' :
          monthNo == 9  ? 'September' :
          monthNo == 10 ? 'October' :
          monthNo == 11 ? 'November' :
          monthNo == 12 ? 'December' : null;

  }

  public void execute(SchedulableContext sc){
      ISP_CreateMonthlyExpense obj =  new ISP_CreateMonthlyExpense();
      obj.createExpense(); 
      obj.createDemoPromMonthlyTarget();
  }
}