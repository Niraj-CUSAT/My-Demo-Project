trigger executejobs on Candidate__c (before update,after update,before insert) {
    
    // This list will hold the list of candidate which should be converted into a resource    
    List<Candidate__c> candidatelist=new List<Candidate__c>();
    //This list will hold the list of candidate for whom serial number should be generated.
    List<Candidate__c> candidatelistforserialnumber=new List<Candidate__c>();
    //This list will hold all the candidates for whom exam should me created.
    List<String> candidatelistforexam=new List<String>(); 
    //Map containing candidate and the count of exams
    Map<String,Integer> mapcandidatelistforexam=new Map<String,Integer>();
    //Getting the trainer's email id from the settings page
    spExamsSettings__c traineremail=[select Trainer_Email__c from spExamsSettings__c]; 
    
    for(Candidate__c c:Trigger.new)
    {   
        /* 
        if(Trigger.isBefore && Trigger.isInsert)
        {
        City_Master__c cm=[select AOSI_City__c,AOSI_Region__c,AOSI_State__c from City_Master__c where Id=:c.City_Master__c];
        c.currentaddrcity__c=cm.AOSI_City__c;
        c.currentaddrregion__c=cm.AOSI_Region__c;
        c.currentaddrstate__c=cm.AOSI_State__c;
        }
        */
 
        if(Trigger.isUpdate && Trigger.isBefore)
        { 
            //Updating the main status when a trainer accepts or reject the candidate
            if((c.status__c=='Online test passed' || c.status__c=='Online test failed') && c.status1__c !=null)
            {
                c.status__c = c.status1__c;
            }
            
            //Changing the status when the interviewer updates the candidate details
            if(c.status__c=='Profile created' && c.candidatecode__c !=null)
            {
                c.status__c='Interviewer remarks'; 
            }
            
            //Adding the candidate to list for serial number assignment    
            if(c.status__c=='Profile created' && c.Type__c!=null)
            {
                if((c.Type__c!='Factory Technician' || c.Type__c!='Sales Executive' )&& c.candidatecode__c==null)
                {  
                    c.status__c='Interviewer remarks'; 
                    candidatelistforserialnumber.add(c);
                }
            }
            
            
        }

        //Adding the candidate to the list who should be converted to an inactive resource
        if(Trigger.isUpdate && Trigger.isAfter)
        {
            //Adding the candidates to the list for whom an exam link should be sent   
            if(c.candidatecode__c !=null && c.Retook_Exam_del__c == false && c.status__c =='Interviewer remarks')
            {
                candidatelistforexam.add(c.Id);
            }
            
            //Adding the list of candidates to be converted into a resource
            if(c.status1__c == 'Accepted')
            {
                candidatelist.add(c);
            }
        }
        
        //Updating the trainer email field from spExamsSettings
        if(Trigger.isInsert && Trigger.isBefore)
        {
            c.traineremail__c = traineremail.Trainer_Email__c;
            //c.status__c = 'Profile Created';
            
        }

    }
    
    // Updating the record with the employee code   
    if(candidatelistforserialnumber.size()>0)
    { 
        CreateExamV2.getEmployeeCode(candidatelistforserialnumber);
    }
    
    // Converting the candidate to resource
    if(candidatelist.size()>0)
    {
        CandidateConverter.convertCandidateToResource(candidatelist);
    }
    
    //Creating exams for the candidate 
    if(candidatelistforexam.size()>0)
    {
        //Checking the number of exams of the candidate 
        List<AggregateResult> canlist=[SELECT Candidate__c,count(Id) FROM spExams__User_Exam__c where Candidate__c in: candidatelistforexam group by Candidate__c];
        if(canlist.isEmpty())
        {
            for(String s:candidatelistforexam)
            {
                mapcandidatelistforexam.put(s,0);
            }
        }    
        if(canlist.size()>0)
        {
            
            for(AggregateResult a:canlist)
            {
                // Restricting the exam creation for only 1 times or less
                if((Integer)a.get('expr0')<1)
                {
                    mapcandidatelistforexam.put((String)a.get('Candidate__c'),(Integer)a.get('expr0'));
                }     
            }
        }
        //Creating exams for the candidates
        if(mapcandidatelistforexam.size()>0)
        {   
            CreateExamV2.createExamForCandidate(mapcandidatelistforexam);
        }
        
    }
    
}