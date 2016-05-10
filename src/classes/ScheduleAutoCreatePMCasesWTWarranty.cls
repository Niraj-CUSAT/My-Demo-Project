/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    09/09/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a Schedule class for Creating Auto PM Cases for WT products Warranty
**************************************************************************************************/

global class ScheduleAutoCreatePMCasesWTWarranty implements Schedulable{
    global void execute(SchedulableContext SC) {
      AutoCreatePMCasesWTWarranty autoCreationContract = new AutoCreatePMCasesWTWarranty();
      Database.executeBatch(autoCreationContract);  
        
    }
}