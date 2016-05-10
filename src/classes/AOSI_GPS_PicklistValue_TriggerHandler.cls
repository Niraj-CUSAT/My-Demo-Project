/*
Created By: Dheeraj Gangulli
Created Date: 19/04/2016
Last Modified By: Dheeraj Gangulli
Last Modified Date: 19/04/2016
Description: This handler is used to send the notifications to the resources whenever the picklist values are changed.
*/

public class AOSI_GPS_PicklistValue_TriggerHandler{
    
    public static void sendNotifications(Map<Id,GPS_Picklist_Value__c> newMap, Map<Id,GPS_Picklist_Value__c> oldMap){
        List<GPS_Picklist_Value__c>  updatedPickListValuesList = new List<GPS_Picklist_Value__c>();
        List<String> resourceGCMId = new List<String>(); //List which holds the resource's GCM ID
        
        //iterating the list to find whether the picklist values are changed or not. 
        //If the picklist values are changed then adding it to the list.
        for(GPS_Picklist_Value__c p: newMap.Values()){
            if(p.Values__c != oldMap.get(p.Id).Values__c && p.Active__c == true){
                updatedPickListValuesList.add(p);
            }
        }
        System.debug('Modified PickList values are'+updatedPickListValuesList);
        
        //Selecting all the resources who has GCM Ids
        for(Service_Engineer__c se : [SELECT Id, AOSI_GCM_Registration_ID__c FROM Service_Engineer__c WHERE AOSI_GCM_Registration_ID__c != null]){
            resourceGCMId.add(se.AOSI_GCM_Registration_ID__c);
        }
        System.debug('Service Engineers GCM Ids are'+resourceGCMId);
        
        //checking the size of the list, if the size is greater than zero then only sending the notifications.
        if(resourceGCMId.Size()>0){
            for(GPS_Picklist_Value__c pickListValues : updatedPickListValuesList){
                AOSI_GPS_GCMMessengerForUpdatePickList.sendMessage('Picklist Updated',resourceGCMId);
            }
        }
        
    }
    
}