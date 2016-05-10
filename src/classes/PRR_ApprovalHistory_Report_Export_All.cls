public with sharing class PRR_ApprovalHistory_Report_Export_All {
	 public List<PRR__c> prrApprovalHistory    {get;set;}
     public PRR_ApprovalHistory_Report_Export_All(){
     	   prrApprovalHistory = [Select Name,AOSI_PRR_Number__c,AOSI_Case__r.CaseNumber,Delivered_Date__c,GIN_Date__c,AOSI_Case__r.CreatedDate,                                        
                                (SELECT SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, OriginalActor.LastName,
                                 IsPending,IsDeleted, Id, CreatedDate,CreatedById,ElapsedTimeInDays,Comments, Actor.LastName FROM ProcessSteps  
                                 order by SystemModstamp desc )  FROM PRR__c ];
     }
}