/*******************************************************************************************************

*Created By         : Keyur Modi
*Created Date       : September 22,2015
*Description        : An Apex REST service to that supports the following 
                      operations, related to case object for customer call tracking:
1.GET/surveyLink    : surveyLink with two parameter case Number and Phone Number 

********************************************************************************************************/

@RestResource(urlMapping='/surveyLink/*')
global with sharing class AOSI_RESTsurveyLink {

/*******************************************************************************************************
     * Method Name : surveyLink()
     * Return Type : Void
     * Description : Defines survey link functionality 
                     1)Based on the case number and phone number, returns the survey link for the particular case
                     
********************************************************************************************************/
    @HttpGet   
    global static Void surveyLink() {
        
        RestRequest req       = RestContext.request;
        RestResponse res      = RestContext.response;
        String strCaseNumber  = req.params.get('caseNumber');
        String strPhoneNumber = req.params.get('phoneNumber');
        String strSurveyLink  = '';
        String strTemp        = '';
        string strQuery       = '';
        string strError       = '';
        List<Case> lstCase    = new List<Case>();
        errorMessage__c errorMesssage = errorMessage__c.getValues('error');
        system.debug('==value of errorMesssage =='+errorMesssage );
        
        IF(strCaseNumber.length() == 8 && strPhoneNumber.length() == 10) {
            strQuery='SELECT id,contactId FROM Case WHERE CaseNumber='+'\''+strCaseNumber+'\''+' AND Contact_Phone__c='+'\''+strPhoneNumber +'\'' + ' LIMIT 1';
            try{
                lstCase = Database.Query(strQuery);
                IF(lstCase.isEmpty()){
                    strError=errorMesssage.DataNotFound__c;
                }
            }catch(exception ex){
            }
            for(case eachCase : lstCase) {
                IF(eachCase.id!=null && eachCase.contactId!=null){
                    surveyLink__c custmObj = surveyLink__c.getValues('URL');
                    strTemp=custmObj.Link__c;
                    system.debug('strTemp=='+strTemp);
                    strSurveyLink = strTemp+eachCase.contactId+'&case_id='+eachCase.id+'&wf=yes' ;
                }
                else{
                    strError=errorMesssage.DataNotFound__c;
                }
            }
        }        
        else{
        strError=errorMesssage.IncorrectData__c;
        }
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        IF(strError !=null){
            system.debug('==strError='+strError);
            String strJSON = JSON.serialize(strError);
            RestContext.response.responseBody = Blob.valueOf(strJSON);
        }
        IF(strSurveyLink!=''){
            system.debug('==strSurveyLink='+strSurveyLink);
            String strJSON = JSON.serialize(strSurveyLink);
            RestContext.response.responseBody = Blob.valueOf(strJSON);
        }   
    
    }

}