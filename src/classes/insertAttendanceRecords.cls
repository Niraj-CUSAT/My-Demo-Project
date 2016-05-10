/***************************************************************************************************************
Created By :- Pawani GVK
Created date :- 17/02/2014
Description :- Class to insert new attendance records for the service engineers for current month
****************************************************************************************************************/
global class insertAttendanceRecords implements Schedulable
{
    //list<Service_Engineer__c> lstEngineers = new list<Service_Engineer__c>();
    list<Attendence__c> lstAttendance = new list<Attendence__c>();
    list<Attendence__c> lstDeleteAttendance = new list<Attendence__c>();
    Date firstDayOfMonth = System.today().toStartOfMonth();
    Integer numberOfDays =  (firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1)).DAY(); //varibale to store the no. of days in current month
    Integer i = 0;
    
    //This method will be called via a scheduler class
    //This is used to insert attendance records for all the service engineers for all the days of the current month
    global void execute(SchedulableContext ctx) 
    {
        //lstEngineers = [SELECT id, name FROM Service_Engineer__c];
        for(Service_Engineer__c se : [SELECT id, name FROM Service_Engineer__c WHERE AOSI_Active__c =: TRUE])
        {
            //The following code is used to insert multiple records for different dates for the same service engineer
            for(integer i = 0;i <= numberOfDays - (System.Today()).DAY() ; i++)
            {
                Attendence__c att = new Attendence__c();
                att.AOSI_Service_Engineer__c = se.id;
                att.AOSI_Date__c = system.today() + i;
                lstAttendance.add(att);
            }
        }
         try{                                
                    Database.insert(lstAttendance,false);
                   
                }
            catch(Exception E){
                system.debug('-------E--------'+E);
            }
       
    }
    
    //This method is called via a trigger which gets triggered when a service engineer is created
    //The attendance record is created only for the new service engineer from the date the new record is created, for the current month
    global void insertNewRecords(set<id> setEnggId) 
    {
        //lstEngineers = [SELECT id, name FROM Service_Engineer__c WHERE CreatedDate = Today];
        for(Service_Engineer__c se : [SELECT id, name FROM Service_Engineer__c WHERE Id IN: setEnggId AND AOSI_Active__c =: TRUE])
        {
            //The following code is used to insert multiple records for different dates for the same service engineer
            for(integer i = 0;i <= numberOfDays - (-(System.Today()).DAY()-7) ; i++)
            {
                Attendence__c att = new Attendence__c();
                att.AOSI_Service_Engineer__c = se.id;
                att.AOSI_Date__c = system.today() + i;
                lstAttendance.add(att);
            }
        }
        insert lstAttendance;
    }
    
    //This method is called via a scheduler class, which will be run of the first of every month
    //Following code will delete the attendance records which were created 60 days earlier than the current date
    global void deleteRecords()
    {
        delete [SELECT Id FROM Attendence__c WHERE CreatedDate < LAST_N_DAYS:60];
    }
    
}