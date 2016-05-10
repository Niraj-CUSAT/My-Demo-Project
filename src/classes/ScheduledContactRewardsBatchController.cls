/*
*    Name        : AccountContactsRewardBatchController 
*    Author      : Sumit Jain
*    Date        : 11/29/2013
*    Description : Scheduler class.
*/
global class ScheduledContactRewardsBatchController implements Schedulable {
   global void execute(SchedulableContext sc) {
      ContactRewardsBatchController b = new ContactRewardsBatchController(); 
      database.executebatch(b,50);
   }
}