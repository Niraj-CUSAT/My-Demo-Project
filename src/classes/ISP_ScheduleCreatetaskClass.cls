global class ISP_ScheduleCreatetaskClass implements Schedulable
{
  global static void scheduleMe(String mode)
  {
    ISP_ScheduleCreatetaskClass msc = new ISP_ScheduleCreatetaskClass();
    String sch = '20 30 8 10 2 ?'; 
    String jobID = system.schedule('Scheduled Job', sch, msc);
  }

  global void execute(SchedulableContext sc)
  {
    ISP_Createscheduledtask  obj = new ISP_Createscheduledtask();
    obj.Createtasks();
    
  }
}