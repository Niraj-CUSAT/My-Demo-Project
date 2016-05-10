/**********************************************************************************************
Created By :- GVK Pawani;Created Date :- 17/02/2014    
Description  :- Scheduler class to be run on the 1st of every month.
                Used to insert attendance records for service engineers for the current month.
Modified By :  Bhanu Vallabhu; Modified On: 3 jun 14;
description: changes insertion class to batch class to avoid governerlimits.               
***********************************************************************************************/
global class scheduleAttendanceRecords implements Schedulable{
    global void execute(SchedulableContext sc) 
    {
      /*insertAttendanceRecords sm = new insertAttendanceRecords();
      sm.execute(null);
      sm.deleteRecords();*/
      InsertAttendanceBatch b = new InsertAttendanceBatch(); 
      database.executebatch(b,100);
    }
}