/****************************************************************************************************  
    Created by    :    Shweta Kumari, KVP Business Solutions
    Created On    :    19/2/2014   
    Description   :    This class creats PM cases On contract 
**************************************************************************************************/

global class CreateContractPMCases implements Schedulable {
    global void execute(SchedulableContext ctx) {    
    	             system.debug('*********system.today()********'+system.today()); 
        List<AOSI_Contract__c> contractList = [Select id,AOSI_AMC__r.AOSI_Contract_Period_In_Years__c,AOSI_AMC__r.AOSI_Number_Of_PM_s_Visit__c,AOSI_Asset__c,AOSI_Asset__r.Contactid,AOSI_Asset__r.product2Id,AOSI_Contract_Status__c,AOSI_End_Date__c,AOSI_PM_Visit__c,AOSI_PM_Visit_Date__c,AOSI_Start_Date__c,AOSI_No_Of_PM_Visit__c  from AOSI_Contract__c Where AOSI_Contract_Status__c=:'Active' AND AOSI_PM_Visit_Date__c =: system.today()];
        Id CaseRecordtypeId  = [Select id from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;                
        List<Case> newCaseList = New List<Case>();
        List<AOSI_Contract__c> updatedContract = New List<AOSI_Contract__c>();        
        //code to create case and update Contract
        for(AOSI_Contract__c cont : contractList){
        		system.debug('*********Inside for********');            
                Date nexDate = Date.newInstance(cont.AOSI_PM_Visit_Date__c.year() , cont.AOSI_PM_Visit_Date__c.month() , cont.AOSI_PM_Visit_Date__c.day() ).addMonths(Integer.valueof((12 *Integer.valueof(cont.AOSI_AMC__r.AOSI_Contract_Period_In_Years__c))/cont.AOSI_AMC__r.AOSI_Number_Of_PM_s_Visit__c  ));
                Case c = new Case();
                c.reason = 'PM Service';
                c.Origin = 'Auto';
                c.contactid = cont.AOSI_Asset__r.Contactid;
                c.AOSIProduct__c = cont.AOSI_Asset__r.product2Id;
                c.recordtypeid = CaseRecordtypeId;
                c.assetid = cont.AOSI_Asset__c;
                c.AOSI_Warranty_Status_I__c = 'WR';
                c.Status = 'Unregistered / Unallocated';
                c.AOSI_PM_Service_Customer_Concern__c = 'PM Service'+ ' ' + Integer.valueof(cont.AOSI_No_Of_PM_Visit__c+1);
                newCaseList.add(c);                
                cont.AOSI_No_Of_PM_Visit__c  = cont.AOSI_No_Of_PM_Visit__c+1;
                //update PM Visit date with next date of PM visit
                if(nexDate < cont.AOSI_End_Date__c){
                    cont.AOSI_PM_Visit_Date__c = nexDate; 
                }
                else{
                    cont.AOSI_PM_Visit_Date__c = nexDate.adddays(-16);    
                }
                updatedContract.add(cont);    
            
        } 
        system.debug('*********newCaseListr********'+newCaseList);
        //code to insert Case
        if(!newCaseList.isempty()){
            try{                    
                    Database.insert(newCaseList,false);
                    Database.update(updatedContract,false);
                }
            catch(Exception E){
                system.debug('-------E--------'+E);
            }
        }   
    }
}