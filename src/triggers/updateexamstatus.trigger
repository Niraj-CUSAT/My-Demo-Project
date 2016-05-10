/*******************************************************************************
Created by    :    Rajesh Kumar, KVP Business Solutions Pvt. Ltd.
Created On    :    21/8/2015
Description   :    This class is used change the status of the candidate if they pass or fail the exam.
********************************************************************************/

trigger updateexamstatus on spExams__User_Exam__c (after update) {

//Set of candidates who passed the exam
Set<Id> exam_passed=new Set<Id>();
//Set of candidate who failed the exam
Set<Id> exam_failed=new Set<Id>();

for(spExams__User_Exam__c exam:Trigger.new)
{
    //Adding the list of candidate to the list for changing the status
   if(exam.spExams__Status__c=='Submitted' && exam.spExams__Passed__c=='PASS')
   {
   exam_passed.add(exam.Candidate__c);
   }else if(exam.spExams__Status__c=='Submitted' && exam.spExams__Passed__c=='FAILED')
   {
   exam_failed.add(exam.Candidate__c);
   }
   
}
// List to candidate for updation
List<Candidate__c> updatelist=new List<Candidate__c> ();
//List of passed candidates
List<Candidate__c> passed_candidate = [select Id,status__c from Candidate__c where Id in :exam_passed];
if(passed_candidate.size()>0)
{
for(Candidate__c c:passed_candidate)
{
c.status__c='Online test passed';
updatelist.add(c);
}
}

//List of failed candidates
List<Candidate__c> failed_candidate = [select Id,status__c from Candidate__c where Id in :exam_failed];
if(failed_candidate.size()>0)
{
for(Candidate__c c:failed_candidate)
{
c.status__c='Online test failed';
updatelist.add(c);
}
}

if(updatelist.size()>0)
{
try
{
update updatelist;
}
catch(DMLException e)
{

}
}

}