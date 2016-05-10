/*
    Name:   AttachmentTrigger 
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  14/04/2015
    Modified By:  
    Last Modified Date: 
    Description:This Trigger is used after insert after delete,when attachment is attached,AOSI_Invoice_Attached__c checkbox is true.else it is false
    Methods Used: 
*/
trigger AttachmentTrigger on Attachment (after insert,after delete) {
  /* Map<Id,Id> attachmentMap = new Map<Id,Id>();
   List<PRR__c> updatePRR = new List<PRR__c>();
   List<Task> updateTask = new List<Task>();
   
   if(Trigger.isInsert){//Start of if
      if(Trigger.isAfter){//Start of if
           for(Attachment att:Trigger.new){
               attachmentMap.put(att.Id,att.ParentId);
           }
      }//End of if 
   }//End of if
   for(PRR__c prrDetails:[Select Id,AOSI_Invoice_Attached__c from PRR__c where Id in:attachmentMap.values()]){//Start of for loop
       prrDetails.AOSI_Invoice_Attached__c=true;
       updatePRR.add(prrDetails);
   }//End of for loop
   
   if(updatePRR.size()>0){//Updating List
      update updatePRR;
   }
   
   if(Trigger.isDelete){//Start of if
      if(Trigger.isAfter){
         for(Attachment att:Trigger.old){
               attachmentMap.put(att.Id,att.ParentId);
           }
      }//End of if
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
   }//End of if*/
   
   AttachmentTriggerHandler attachmentTrigger = new AttachmentTriggerHandler(); 
   if(Trigger.isInsert){
       if(Trigger.isAfter){
          attachmentTrigger.onAfterInsert(Trigger.new);
      /****Check attchment id for store image object Start*******/     
           
            
           set <id> Ids = new set<id>(); 
          
           list <ISP_Store_Image__c> storeimglist = new list<ISP_Store_Image__c>();
           for(Attachment att : trigger.New){
               if(att.ParentId.getSobjectType() == ISP_Store_Image__c.SobjectType){
                   ISP_Store_Image__c img = new ISP_Store_Image__c(id = att.parentId,Attchment_ID__c = att.id);
                   storeimglist.add(img);
                   system.debug('-------id = --------'+Ids);
               }
    	   }
          
           if(storeimglist.size()>0){
               update storeimglist;
            }
           
           
           
      /****Check attchment id for store image object End*******/            
           
       }
    }
    
    if(Trigger.isDelete){ 
       
       if(Trigger.isAfter){
          attachmentTrigger.onAfterDelete(Trigger.old);
       }
    }
}