/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    09/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Schedule class for  creating Auto  PM Contract Cases for WT products
**************************************************************************************************/
global class ScheduleAutoCreatePMCasesWTContract implements Schedulable  {
    global void execute(SchedulableContext SC) {
      AutoCreatePMCasesWTContract autoCreationContract = new AutoCreatePMCasesWTContract(); 
      Database.executeBatch(autoCreationContract);  
    }
}