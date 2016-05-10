/*
    Name:   AttachmentTriggerhandler 
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  14/04/2015
    Modified By:  
    Last Modified Date: 
    Description:This Class is used after insert after delete,when attachment is attached,AOSI_Invoice_Attached__c checkbox is true.else it is false
    Methods Used: 
*/
public with sharing class AttachmentTriggerhandler {
     Map<Id,Id> attachmentMap = new Map<Id,Id>();
     List<PRR__c> updatePRR = new List<PRR__c>();
     List<Task> updateTask = new List<Task>();
     public AttachmentTriggerhandler(){
     	
     }
     
     public void onAfterInsert(List<Attachment> attachmentDetails){
     	 for(Attachment att:attachmentDetails){
               attachmentMap.put(att.Id,att.ParentId);
         }
         for(PRR__c prrDetails:[Select Id,AOSI_Invoice_Attached__c from PRR__c where Id in:attachmentMap.values()]){//Start of for loop
            prrDetails.AOSI_Invoice_Attached__c=true;
            updatePRR.add(prrDetails);
         }//End of for loop
   
        if(updatePRR.size()>0){//Updating List
           update updatePRR;
        }
     }
     public void onAfterDelete(List<Attachment> attachmentOld){ 
     	for(Attachment att:attachmentOld){
               attachmentMap.put(att.Id,att.ParentId);
        }
        List<Attachment> attSize=[Select Id from Attachment where ParentId in:attachmentMap.values()];
        if(attSize.size()==null || attSize.size()==0){//Start of if
           for(PRR__c prrDetails:[Select Id,AOSI_Invoice_Attached__c from PRR__c where Id in:attachmentMap.values()]){//Start of for loop
               prrDetails.AOSI_Invoice_Attached__c=false;
               updatePRR.add(prrDetails);
           }//End of for loop
           for(Task tskDetails:[Select Id,AOSI_Visit_Report_Attached__c,Status from Task where Id in:attachmentMap.values()]){//Start of for loop
               tskDetails.AOSI_Visit_Report_Attached__c=false;
               updateTask.add(tskDetails);
           }//End of for loop
        }//End of if
        if(updatePRR.size()>0){//Start of if
          update updatePRR;
        }//End of if
        if(updateTask.size()>0){//Start of if
          update updateTask;
        }//End of if
     }
}