/*****************************************************************************************************************************************************
 * Class Name   : AOSI_HolidayUpdateBatchSchedule
 * Created By   : Keyur Modi
 * Created Date : 15/10/2015
 * Description  : This Schedular class is to schedule Batch class(AOSI_HolidayUpdateBatch). 
 * Methods      : global void execute(SchedulableContext sc)
******************************************************************************************************************************************************/
global class AOSI_HolidayUpdateBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        //  Instantiate batch class
        AOSI_HolidayUpdateBatch holidayBatch= new AOSI_HolidayUpdateBatch();
        ID BatchId = database.executebatch(holidayBatch,200);
        
    }
}