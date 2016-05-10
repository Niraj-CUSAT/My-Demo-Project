/**********************************************************************************************
Created By :- GVK Pawani
Created Date :- 17/02/2014    
Description  :- Used to insert attendance records for the new service engineers for the current month from the date of new service engineer creation.
***********************************************************************************************/
trigger insertNewAttendanceRecords on Service_Engineer__c (after insert,before insert, before update) 
{
    if(trigger.isafter && trigger.isinsert){
    set<id> setNewEnggId = new set<id>();
    for(Service_Engineer__c se : trigger.new)
        setNewEnggId.add(se.id);
    insertAttendanceRecords sm = new insertAttendanceRecords();
    sm.insertNewRecords(setNewEnggId);
    }
    set<String> citymaster=new set<String>();
    if(Trigger.isbefore){
        for(Service_Engineer__c se : trigger.new){
            citymaster.add(se.City_Master__c);
        }
        if(!citymaster.isempty()){
            for(City_Master__c CM:[select id,name,AOSI_Region__c,AOSI_State__c from City_Master__c where id=:citymaster]){
                for(Service_Engineer__c se : trigger.new){
                    if(CM.id==se.City_Master__c){
                        se.Region__c=CM.AOSI_Region__c;
                        se.State__c=CM.AOSI_State__c;
                        se.AOSI_City__c=CM.Name;
                    }
                }
            }
        }
    }
}