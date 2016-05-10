/*****************************************************************************************************************************************************
 * Class Name   : AOSI_SendScheduledSMSScheduler 
 * Created By   : Pooja P Bhat
 * Created Date : 29-JULY-2015
 * Description  : Scheduler class for AOSI_SendScheduledSMSBatch
******************************************************************************************************************************************************/
global class AOSI_SendScheduledSMSScheduler implements Schedulable {

    /***********************************************************************************************************************************
    * Method Name : execute() is a Shedulable Interface method that takes a parameter SchedulableContext
    * Description : Create object of SendScheduleSMSBatch and execute it.
    ************************************************************************************************************************************/
    global void execute(SchedulableContext SC) {              
        /*Creating object of AddAllInvestorAvailableFundBatch and executing it*/
        AOSI_SendScheduledSMSBatch scheduleSMS = new AOSI_SendScheduledSMSBatch();        
        database.executeBatch(scheduleSMS);
    }
}