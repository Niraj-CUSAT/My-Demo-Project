/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    09/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Schedule class for  Auto creation of tasks for active delaers with catergory
**************************************************************************************************/
global class ScheduleAutoCreationofTaskActiveDealer implements Schedulable {
   global void execute(SchedulableContext SC) {
      AutoCreationofTaskActiveDealer M = new AutoCreationofTaskActiveDealer(); 
   }
}