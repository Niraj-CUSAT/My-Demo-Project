/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
public class Testupdateexamstatus {
static testMethod void myUnitTest() {
	
    //Inserting Topic
    spExams__Topic__c topic=new spExams__Topic__c();
    topic.Name ='Technical Knowledge';
    topic.Question_Limit__c=1;
    insert topic;
    
    //Inserting Topic
    spExams__Topic__c topic_att=new spExams__Topic__c();
    topic_att.Name ='Attitude';
    topic_att.Question_Limit__c=1;
    insert topic_att;
    
    //Inserting Question
    spExams__Question__c question=new spExams__Question__c();
    question.spExams__Topic__c=topic.Id;
    question.spExams__Content__c='Test';
    question.spExams__Type__c='Single Choice';
    insert question;
    
    //Inserting Answer
    spExams__Answer__c answer=new spExams__Answer__c();
    answer.spExams__Content__c='Test';
    answer.spExams__IsCorrect__c=true;
    answer.spExams__Question__c=question.Id;
    insert answer;
    
    // Attitude
    //Inserting Question
    spExams__Question__c question_att=new spExams__Question__c();
    question_att.spExams__Topic__c=topic_att.Id;
    question_att.spExams__Content__c='Test';
    question_att.spExams__Type__c='Single Choice';
    insert question_att;
    
    //Inserting Answer
    spExams__Answer__c answer_att=new spExams__Answer__c();
    answer_att.spExams__Content__c='Test';
    answer_att.spExams__IsCorrect__c=true;
    answer_att.spExams__Question__c=question_att.Id;
    insert answer_att;
    
    
    
    // Configuration Setting
    spExams__Configuration__c configuration=new spExams__Configuration__c();
    configuration.spExams__Background_Color__c='Blue';
    insert configuration;
    
    //Creating new exam
    spExams__Exam__c exam =new spExams__Exam__c();
    exam.spExams__Configuration__c=configuration.Id;
    User admin=[select Id from User limit 1];
    exam.spExams__Admin__c=admin.id;
    exam.spExams__Domain_Question__c=1;
    exam.spExams__Exam_Duration__c=1;
    exam.spExams__Exam_Question__c=1;
    exam.spExams__Expiration_Date__c=System.today();
    exam.spExams__Passing_Score__c=1;
    insert exam;
    
    //Creating new candidate
     City_Master__c cm=new City_Master__c();
    cm.AOSI_City__c='Bangalore';
    cm.District__c='Bangalore';
    cm.AOSI_Region__c='South';
    cm.AOSI_State__c='Karnataka';
    
    Candidate__c candidate=new Candidate__c();
    candidate.alternatenumber__c = '8904623622';
    candidate.candidatecode__c='ASP0787';
    candidate.candidateemail__c='rajesh.kumar@kvpcorp.com';
    candidate.currentaddrcity__c='Bangalore';
    candidate.currentaddrregion__c='South';
    candidate.currentaddrstate__c='Karnataka';
    candidate.currentaddrstreet__c='71';
    candidate.currentaddrzipcode__c='560091';
	candidate.status__c ='Interviewer remarks';
    candidate.dateofbirth__c=System.today();
    candidate.experience__c='Experienced - Other Industry';
    candidate.fathersname__c='Demo';
    candidate.firstname__c='First Name';
    candidate.lastname__c='Last NAme';
    candidate.mobilenumber__c='8904623622';
    candidate.Type__c='Co-ordinator';
    candidate.City_Master__c=cm.Id;
    insert candidate;
	update candidate;    
    
    //Creating new user exam
    spExams__User_Exam__c userexam=new spExams__User_Exam__c();
    userexam.spExams__Status__c='Submitted';
    userexam.spExams__Exam__c=exam.Id;
    userexam.Candidate__c=candidate.Id;
    insert userexam;
    
    //Inserting userexam question
    spExams__User_Exam_Question__c userexamquestion=new spExams__User_Exam_Question__c();
    userexamquestion.spExams__Is_Correct__c='Y';
    userexamquestion.spExams__Question__c=question.Id;
    userexamquestion.spExams__Review_Later__c=false;
    userexamquestion.spExams__User_Exam__c=userexam.Id;
    insert userexamquestion;
    
    //Inserting userexam answer
    spExams__User_Exam_Answer__c userexamanswer=new spExams__User_Exam_Answer__c();
    userexamanswer.spExams__Answer__c=answer.Id;
    userexamanswer.spExams__Free_Text_Content__c='test';
    userexamanswer.spExams__Is_Correct__c='Y';
    userexamanswer.spExams__User_Exam_Question__c=userexamquestion.Id;
    insert userexamanswer;

    update userexam;
}
}