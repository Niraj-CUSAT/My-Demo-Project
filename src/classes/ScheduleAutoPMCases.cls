/*************************************************************************************************
    Created by    :    Bhanu Vallabhu, KVP Business Solutions
    Created On    :    23 APR 2013
    Modified by   :    
    Modified on   :
    Description   :    This is a schedule class to be scheduled daily at 8:00 AM for Creating Auto PM Cases
**************************************************************************************************/

global class ScheduleAutoPMCases implements Schedulable {


  global void execute(SchedulableContext ctx) {
       
      CreateAutoPMCases c = new CreateAutoPMCases();
      c.createcase();
   }
}