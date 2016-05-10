/*
    Name:   TaskTriggerhandler 
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  7/9/2015
    Modified By:  
    Last Modified Date: 
    Description:This Class is used after insert after delete,when attachment is attached,AOSI_Visit_Report_Attached__c checkbox is true.else it is false
    Methods Used: 
*/
public class TaskTriggerhandler {
    
   List<Task> tskDetails = new List<Task>();
   List<Task> updateTsk = new List<Task>();
   public void onAfterUpdate(List<Task> taskDetails){
       set<Id> sAccIds               =    new set<Id>();
       set<Id> sDealerAccIds         =    new set<Id>();
       
       for(Task tskDetail:taskDetails){//Start of for 
             tskDetails.add(tskDetail);//Adding task details to a list
             if(tskDetail.WhatId != null && String.valueof(tskDetail.WhatId).startsWith('001')) {
                 sAccIds.add(tskDetail.WhatId);
             }
       }//End of for
       
       if(!sAccIds.isEmpty()) {
           for(Account acc: [SELECT Id,Name,AOSI_Categories__c FROM Account WHERE Id IN:sAccIds AND RecordType.Name = 'AOS India' AND (AOSI_Categories__c = 'Distributor' OR AOSI_Categories__c = 'Direct Dealer' OR AOSI_Categories__c = 'Modern retail')]){
               sDealerAccIds.add(acc.Id);    
           }
       }
       system.debug('sDealerAccIds***'+sDealerAccIds);
       
       set<String> sAOSIProfiles    =   new set<String>{'AOS India Agent', 'AOS India Manager', 'ASP AOSI', 'AOS India Admin', 'Call Centre Agent - AOS India', 'Call Centre Manager - AOS India', 'Regional Customer Call Coordinator AOSI', 'Regional Manager AOSI', 'Store Executive AOSI', 'Service Executive AOSI','Sales Coordinator'};
       set<Id> sAOSIProfIds         =   new set<Id>(); 
       system.debug('sAOSIProfiles*** '+sAOSIProfiles);
       
       for(Profile oProfile : [SELECT Id,Name FROM Profile WHERE Name IN: sAOSIProfiles]) {
           sAOSIProfIds.add(oProfile.Id);
       }
       
       if(tskDetails.size()>0) {//if list size is greater than zero, start if
           for(Task atch : [SELECT Id,AOSI_Visit_Report_Attached__c,Status,CreatedBy.ProfileId, LastModifiedBy.ProfileId, WhatId, (SELECT ID from Attachments) FROM Task where Id in:tskDetails]){//Inner query from task to attachments,Start of for loop
               if(atch.Attachments.size() > 0) {//If inner query attachment result is greater than zero,start if 
                  atch.AOSI_Visit_Report_Attached__c =true;
                  updateTsk.add(atch);
               }//End if 
               if(atch.Attachments.size()==0  && atch.WhatId != null && !sDealerAccIds.isEmpty() && sDealerAccIds.contains(atch.WhatId) ){//If inner query attachment result is equals to zero,start if
                  if(atch.AOSI_Visit_Report_Attached__c==false && atch.status=='Completed' && !sAOSIProfIds.isEmpty() && (sAOSIProfIds.contains(atch.CreatedBy.ProfileId) || sAOSIProfIds.contains(atch.LastModifiedBy.ProfileId)) ) {
                      trigger.newMap.get(atch.id).addError('Please add attachment to complete your task.');
                   }
                  atch.AOSI_Visit_Report_Attached__c =false;
                  updateTsk.add(atch);
               }//End of if 
           }//End of for loop
           if(updateTsk.size()>0){//Start of if 
               update updateTsk;
           }//End of if 
       }
   }
}