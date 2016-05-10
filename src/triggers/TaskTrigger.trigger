/*
    Name:   TaskTrigger 
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  7/9/2015
    Modified By:  
    Last Modified Date: 
    Description:This Trigger is used after insert after delete,when attachment is attached,AOSI_Visit_Report_Attached__c checkbox is true.else it is false
    Methods Used: 
*/
trigger TaskTrigger on Task (after update) {
   /*List<Task> tskDetails = new List<Task>();
   List<Task> updateTsk = new List<Task>();
   if(checkRecursive.runOnce()){//Start of if 
   	  if(Trigger.isUpdate){
   	  	  for(Task tskDetail:Trigger.new){//Start of for 
   	  	  	 tskDetails.add(tskDetail);//Adding task details to a list
		  }//End of for
   	  }
	  if(tskDetails.size()>0){//if list size is greater than zero, start if
		   for(Task atch:[Select Id,AOSI_Visit_Report_Attached__c,status,(Select ID from Attachments) from Task where Id in:tskDetails]){//Inner query from task to attachments,Start of for loop
		   	   if(atch.Attachments.size()>0){//If inner query attachment result is greater than zero,start if 
		   	   	  atch.AOSI_Visit_Report_Attached__c =true;
		   	   	  updateTsk.add(atch);
		   	   }//End if 
		   	   if(atch.Attachments.size()==0){//If inner query attachment result is equals to zero,start if
		   	   	  if(atch.AOSI_Visit_Report_Attached__c==false && atch.status=='completed'){
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
  }//End of if */
  TaskTriggerhandler taskTrigger = new TaskTriggerhandler();
  
  if(checkRecursive.runOnce()){//Start of if 
	  if(Trigger.isUpdate){
	       if(Trigger.isAfter){ 
	          taskTrigger.onAfterUpdate(Trigger.new);
	       }
	  }
  }//End of if 
}