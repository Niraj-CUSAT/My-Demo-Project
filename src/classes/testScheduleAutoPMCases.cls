@isTest
Private class testScheduleAutoPMCases{
Static testmethod void test()
{

          
    String jobId = System.schedule('ScheduledApex','0 0 0 3 9 ? 2022' ,new ScheduleAutoPMCases());
    
   
    
}
}