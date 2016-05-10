global class ISP_ScheduleUpdatetaskClass implements Schedulable
{
  

  global void execute(SchedulableContext sc)
  {
    ISP_Createscheduledtask  obj = new ISP_Createscheduledtask();
    obj.updateTasks();
    
  }
}