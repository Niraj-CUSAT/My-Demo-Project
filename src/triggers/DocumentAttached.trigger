trigger DocumentAttached  on Task (before update) {

      for(Task t : [SELECT Id,status,CheckAttachment__c, (SELECT Id FROM Attachments LIMIT 1)FROM Task WHERE Id IN : trigger.new]){
         if(t.Attachments.size() == 0 && t.Status =='Completed' && t.CheckAttachment__c == true) { 
           t.addError('Upload atleast one attachment to complete this task');
        }
        //trigger.newMap(t.Id).Questionnaire_attached__c = !t.Attachments.isEmpty();
    }

}