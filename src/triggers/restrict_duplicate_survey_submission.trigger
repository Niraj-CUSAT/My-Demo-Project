/*

Trigger Name : restrict_duplicate_survey_submission
Description  : To resirict the submission of duplicate survey
Created By   : Rajesh Kumar

*/


trigger restrict_duplicate_survey_submission on TIMBASURVEYS__Survey_Summary__c (before insert) {
List<TIMBASURVEYS__Survey_Summary__c> listofcase=new List<TIMBASURVEYS__Survey_Summary__c>();
List<Id> Idlistofcase=new List<Id>();
for(TIMBASURVEYS__Survey_Summary__c survey:Trigger.New)
{

    listofcase.add(survey); 
    Idlistofcase.add(survey.TIMBASURVEYS__RelatedCase__c);   

}

system.debug('listofcase'+listofcase);
if(listofcase.size() > 0)
{
List<TIMBASURVEYS__Survey_Summary__c> listofexistingsurvey=[Select TIMBASURVEYS__RelatedCase__c from TIMBASURVEYS__Survey_Summary__c where TIMBASURVEYS__RelatedCase__c IN : Idlistofcase ];
Set<Id> setofexistingsurvey=new Set<Id>();
for(TIMBASURVEYS__Survey_Summary__c existingsurvey:listofexistingsurvey)
{
setofexistingsurvey.add(existingsurvey.TIMBASURVEYS__RelatedCase__c);
}

for(TIMBASURVEYS__Survey_Summary__c obj:listofcase)
{
    if(setofexistingsurvey.contains(obj.TIMBASURVEYS__RelatedCase__c))
    {
    obj.addError('Survey already exist');
    }
}


}

}