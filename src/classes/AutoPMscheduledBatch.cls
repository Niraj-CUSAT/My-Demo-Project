/****************************************************************************************************  
    Created by    :   Vishwanath Attikeri, KVP Business Solutions
    Created On    :    26 AUG 2013
    Modified by   :    
    Modified on   :    
    Description   :   Schedula class for creating PM cases 
**************************************************************************************************/
global class AutoPMscheduledBatch implements Schedulable{
   global void execute(SchedulableContext sc) {
      BatchCreateAutoPMCases b = new BatchCreateAutoPMCases(); 
      database.executebatch(b);
   }
}