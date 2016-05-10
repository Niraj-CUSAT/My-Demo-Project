/*******************************************************************************
Created by    :    Rajesh Kumar, KVP Business Solutions Pvt. Ltd.
Created On    :    21/8/2015
Description   :    This class generates Employee code for ASP Candidates and creates an exam for the candidate.
********************************************************************************/
public class CreateExamV2 {
  
  //Method to generate employee code for ASP Candidates 
  public static void getEmployeeCode(List<Candidate__c> candidatelist)
  {
      String c_code;
      boolean isinitial=false;
      List<Candidate__c> candidates=null;
      try
      {
         //Reading the last employee code from the database
       candidates=[select candidatecode__c from Candidate__c where  candidatecode__c like 'ASP%'order by candidatecode__c desc limit 1];    
      }
      catch(Exception e)
      {
          
      }
      
      //Assigning the initial candidate code to the ASP Employee if there is no ASP code present
      if(candidates==null||candidates.size()<=0)
      {
          c_code='ASP001';
          isinitial=true;
            
      }
      else
      {
          c_code=candidates.get(0).candidatecode__c;
      }
      
      for(Candidate__c c:candidatelist)
      {
       if(!isinitial)   
       {
       String code=c_code;
       //Extracting the number from the code    
       String enumber=code.substring(3, code.length());
       //Incrementing the number    
       Integer incrementer=Integer.valueOf(enumber)+1;
       if(incrementer<10)
       {
       c_code= 'ASP00'+incrementer;   
       }
       else if(incrementer>9&&incrementer<100)
       {
          c_code= 'ASP0'+ incrementer;
       }
       else
       {
          c_code= 'ASP'+ incrementer; 
       }
         
       }
        //Assigning the candidate code to the candidate.  
        c.candidatecode__c=c_code;
        isinitial=false;  
      }
          
  }
    //Method to generate a random number  
    public static Integer getRandomInt (Integer lower, Integer upper)
    {
        return Math.round(Math.random() * (upper - lower)) + lower;
    }

    public static void createExamForCandidate(Map<String,Integer> candi_dates)
    {   
        //Loading the candidate's information
        List<Candidate__c> candidates=[SELECT alternatenumber__c,ASP__c,candidatecode__c,candidateemail__c,City_Master__c,CreatedById,CreatedDate,currentaddrcity__c,currentaddrregion__c,currentaddrstate__c,currentaddrstreet__c,dateofbirth__c,experience__c,fathersname__c,fieldexecutivescomment__c,firstname__c,Id,interviewerdesignation__c,interviewerscomment__c,Interviewer_Email_Address__c,Interviewer__c,IsDeleted,Is_Interviewer_notified__c,LastModifiedById,LastModifiedDate,lastname__c,LastReferencedDate,LastViewedDate,Name,OwnerId,permaddrcity__c,permaddrregion__c,permaddrstate__c,permaddrstreet__c,Product_Category__c,Retook_Exam_del__c,status__c,supervisorname__c,SystemModstamp,traineremail__c,trainerscomment__c,Type__c FROM Candidate__c where Id IN:candi_dates.keySet()];
        //List of user exams
        List<spExams__User_Exam__c> userexamlist=new List<spExams__User_Exam__c>();
        //Loading the settings  
        spExamsSettings__c settings=[SELECT Configuration__r.spExams__Site__c,Configuration__c,Description__c,Exam_Admin__c,Exam_Duration__c,Exam_expiry__c,Exam_Title__c,Id,Name,Passing_Score__c,Show_Results_Upon_Submission__c FROM spExamsSettings__c limit 1];
        //Topics
        List<spExams__Topic__c> topics=[Select s.Name, s.Id, s.Question_Limit__c From spExams__Topic__c s];
        system.debug('topics'+topics);
        //Exam list for creating exams
        List<spExams__Exam__c> examlist=new List<spExams__Exam__c>();
        // List of all the exam questions  
        List<spExams__Question__c> allquestions=[Select spExams__Topic__c,Id From spExams__Question__c where spExams__Topic__c IN :topics];
        // Map of topic -> List of questions
        Map<spExams__Topic__c,List<spExams__Question__c>> questionmap=new Map<spExams__Topic__c,List<spExams__Question__c>>();
        
        //Mapping the list of question to their topic 
        for(integer i=0;i<topics.size();i++)
        {
            List<spExams__Question__c> question=new List<spExams__Question__c>();
            for(integer j=0;j<allquestions.size();j++)
            {
                
                if(allquestions.get(j).spExams__Topic__c.equals(topics.get(i).Id))
                {
                    question.add(allquestions.get(j));
                    
                }
                questionmap.put(topics.get(i),question);
                
            }
            
        }       
        
        // Creating list of exams
        for(integer i=0;i<candidates.size();i++)
        {
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
            examlist.add(obj);
        }
        //inserting list of exans    
        insert examlist;

        // Creating the final list of questions 
        List<spExams__Exam_Question__c> finalquestionset=new List<spExams__Exam_Question__c>();
        for(integer i=0;i<candidates.size();i++)
        {
            //Creating the user exam object    
            spExams__User_Exam__c userexam=new spExams__User_Exam__c();
            userexam.spExams__First_Name__c=candidates.get(i).firstname__c;
            userexam.spExams__Last_Name__c=candidates.get(i).lastname__c;
            userexam.spExams__Email__c=candidates.get(i).candidateemail__c;
            userexam.spExams__Exam__c=examlist.get(i).Id;
            userexam.spExams__Remaining_Time__c=examlist.get(i).spExams__Exam_Duration__c;
            userexam.spExams__User_Id__c=candidates.get(i).Id; 
            userexam.Candidate__c=candidates.get(i).Id;   
            userexam.spExams__Status__c='Pending';

         //Picking random question from eact topic by considering the question limit of the topic    
         for(spExams__Topic__c topic:questionmap.KeySet())
         {
            if(topic.Question_Limit__c > 0)
            {
            Set<spExams__Exam_Question__c> questionlist=new Set<spExams__Exam_Question__c>();
            while(questionlist.size()!=topic.Question_Limit__c)
            {
                spExams__Exam_Question__c question=new spExams__Exam_Question__c ();
                 question.spExams__Exam__c=examlist.get(i).Id; 
                //Shuffing and adding the questions    
                //Integer index=getRandomInt(0, topics.size()-1);
                Integer index=getRandomInt(0, Integer.valueof(topic.Question_Limit__c)-1);
                System.debug('topic'+topic+' index'+index);
                spExams__Question__c ques= questionmap.get(topic).get(index);
                question.spExams__Question__c= ques.Id;
                questionlist.add(question);   
                
            }
            finalquestionset.addAll(questionlist);
         }
        }     
            //adding the userexam to the userexam list for insertion
            userexamlist.add(userexam);
            
        }
        // Updating the exam with the number of questions which will be asked in the exam        
        for(spExams__Exam__c exam:examlist)
        {
            exam.spExams__Domain_Question__c=finalquestionset.size();
            exam.spExams__Exam_Question__c=finalquestionset.size();
        }

        update examlist;
        //inserting userexam and final question list
        insert userexamlist;
        insert finalquestionset;
        
        // Sending the exam link to the candidate
        List<spExams__User_Exam__c> updatelist=new List<spExams__User_Exam__c>();
        for(spExams__User_Exam__c userexam:userexamlist)
        {
            userexam.spExams__Exam_URL__c=settings.Configuration__r.spExams__Site__c+'/spexams__spExamsUserVerification?uId='+userexam.Id;
            userexam.spExams__Status__c='Sent';  
            updatelist.add(userexam);
        }
        update updatelist; 

    }
}