/*******************************************************************************
Created by    :    Rajesh Kumar, KVP Business Solutions Pvt. Ltd.
Created On    :    21/8/2015
Description   :    This class creates an exam for the candidate.
********************************************************************************/
global class CreateExam
{
  
  //Method to generate a random number  
  private static Integer getRandomInt (Integer lower, Integer upper)
  {
    return Math.round(Math.random() * (upper - lower)) + lower;
  }
  
  //web service to create an exam
    webservice  static String createExamForCandidate(String candidateid)
    {
    List<spExams__User_Exam__c> examcheck=[select Id from spExams__User_Exam__c where Candidate__c =:candidateid];
    
    //Create exam only if there are less than 2 exams    
    if(examcheck.size()<2)
    {
    Candidate__c candidateobj=[SELECT alternatenumber__c,ASP__c,candidatecode__c,candidateemail__c,CreatedById,CreatedDate,currentaddrcity__c,currentaddrregion__c,currentaddrstate__c,currentaddrstreet__c,dateofbirth__c,experience__c,fathersname__c,fieldexecutivescomment__c,firstname__c,Id,interviewerdesignation__c,interviewerscomment__c,Interviewer_Email_Address__c,Interviewer__c,IsDeleted,Is_Interviewer_notified__c,LastModifiedById,LastModifiedDate,lastname__c,LastReferencedDate,LastViewedDate,Name,OwnerId,permaddrcity__c,permaddrregion__c,permaddrstate__c,permaddrstreet__c,status__c,supervisorname__c,SystemModstamp,trainerscomment__c,Type__c FROM Candidate__c where Id =:candidateid limit 1];       
    spExamsSettings__c settings=[SELECT Configuration__r.spExams__Site__c,Configuration__c,Description__c,Exam_Admin__c,Exam_Duration__c,Exam_expiry__c,Exam_Title__c,Id,Name,Passing_Score__c,Show_Results_Upon_Submission__c FROM spExamsSettings__c limit 1];    
    
    // Inserting Exam    
    spExams__Exam__c obj=new spExams__Exam__c();
    obj.spExams__Admin__c=settings.Exam_Admin__c;
    obj.spExams__Configuration__c=settings.Configuration__c;
    obj.spExams__Description__c=settings.Description__c;
    obj.spExams__Exam_Duration__c=settings.Exam_Duration__c;    
    obj.spExams__Title__c=settings.Exam_Title__c;    
    obj.spExams__Passing_Score__c=settings.Passing_Score__c;
    obj.spExams__Show_Results_Upon_Submission__c=settings.Show_Results_Upon_Submission__c;   
    obj.spExams__Status__c='Draft';   
    Date d=System.today();
    d=d.addDays(settings.Exam_expiry__c.intValue());
    obj.spExams__Expiration_Date__c=d;      
    insert obj; 

    //Preparing the questions    
    List<spExams__Topic__c> topics=[Select s.Name, s.Id, s.Question_Limit__c From spExams__Topic__c s];   
    List<spExams__Exam_Question__c> qq=new List<spExams__Exam_Question__c>();
    
    for(spExams__Topic__c topic:topics)
    {
    //Fetching all the questions from topic 
    List<spExams__Question__c> selectedquestion=[Select Id From spExams__Question__c where spExams__Topic__c=:topic.Id];   
    
    if(selectedquestion.size()>0)
    {    
    Set<spExams__Exam_Question__c> questionlist=new Set<spExams__Exam_Question__c>();
    while(questionlist.size()!=topic.Question_Limit__c)
    {
    spExams__Exam_Question__c question=new spExams__Exam_Question__c ();
    question.spExams__Exam__c=obj.Id;
    //Shuffing and adding the questions    
    Integer index=getRandomInt(0, topics.size()-1);
    spExams__Question__c ques= selectedquestion.get(index);
    question.spExams__Question__c= ques.Id;
    questionlist.add(question);   
    }
    qq.addAll(questionlist);   
    }    
        
    }
       
    // Inserting Question
    insert qq;
    
    //Updating number of questions in exam  
    obj.spExams__Domain_Question__c=qq.size();  
    obj.spExams__Exam_Question__c=qq.size();
    update obj;
    
    //Inserting user exam    
    spExams__User_Exam__c userexam=new spExams__User_Exam__c();
    userexam.spExams__First_Name__c=candidateobj.firstname__c;
    userexam.spExams__Last_Name__c=candidateobj.lastname__c;
    userexam.spExams__Email__c=candidateobj.candidateemail__c;
    userexam.spExams__Exam__c=obj.Id;
    userexam.spExams__Remaining_Time__c=obj.spExams__Exam_Duration__c;
    userexam.spExams__User_Id__c=candidateobj.Id; 
    userexam.Candidate__c=candidateobj.Id;   
    userexam.spExams__Status__c='Pending';
    insert userexam;    
    
    //Updating userexam : Adding url and changing the status to sent.    
    userexam.spExams__Exam_URL__c=settings.Configuration__r.spExams__Site__c+'/spexams__spExamsUserVerification?uId='+userexam.Id;
    userexam.spExams__Status__c='Sent';  
    update userexam;
    
    if(examcheck.size()==1)
    {
        candidateobj.status__c ='Retake Online test';
        candidateobj.Retook_Exam_del__c=true;
        update candidateobj; 
    }
    return 'ok';
    }
    else
    {
    return 'error';
    }
    }
    
}