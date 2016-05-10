/* created by: Bhanu Vallabhu, KVP Business Solutions; Created On : 3jun 2014;
Description: Class to insert new attendance records for the service engineers for current month
batch class written to over come governer limits;
*/
global class InsertAttendanceBatch implements Database.Batchable<sObject> {
    
    global String query;
    list<Attendence__c> lstAttendance = new list<Attendence__c>();
    Date firstDayOfMonth = System.today().toStartOfMonth();
    Integer numberOfDays =  (firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1)).DAY(); //varibale to store the no. of days in current month
    Integer i = 0;
    
    global InsertAttendanceBatch(){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
            query='SELECT id, name FROM Service_Engineer__c WHERE AOSI_Active__c = true';
            //system.debug('query is'+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Sobject> scope){
        system.debug('Scope size is'+scope.size());
        
         set<Id> resourceid = new set<Id>();
         lstAttendance = new list<Attendence__c>();
        for(Sobject se : scope){
            resourceid.add(se.id);
            for(integer i = 0;i <= numberOfDays - (System.Today()).DAY() ; i++){
                Attendence__c att = new Attendence__c();
                att.AOSI_Service_Engineer__c = se.id;
                att.AOSI_Date__c = system.today() + i;
                lstAttendance.add(att);
            }
        }
         try{                                
                if(!lstAttendance.isempty()){
                    Database.insert(lstAttendance,false);
                }    
                if(!resourceid.isempty()){
                    Database.delete([SELECT Id FROM Attendence__c WHERE CreatedDate < LAST_N_DAYS:60 AND AOSI_Service_Engineer__c IN : resourceid], false);
                } 
         }catch(Exception E){
                system.debug('-------E--------'+E);
            }

    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    

}