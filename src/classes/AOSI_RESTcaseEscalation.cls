/*******************************************************************************************************

*Created By         : Keyur Modi
*Created Date       : September 22,2015
*Description        : An Apex REST service to that supports the following 
                      operations, related to case object for customer call tracking:
1.Post/Escalation   : Case Escalation to  

********************************************************************************************************/

@RestResource(urlMapping='/caseEscalation/*')
global with sharing class AOSI_RESTcaseEscalation {

/*******************************************************************************************************
     * Method Name : caseEscalation()
     * Return Type : void
     * Description : Defines Escalation functionality 
                     1) Escalation reason stored in Escalation(Escalation__C) with Escalation Reason
                     
********************************************************************************************************/
    @HttpPost   
    global static void caseEscalation() {
        
        RestRequest req            = RestContext.request;
        RestResponse res           = RestContext.response;
        String strCaseNumber       = req.params.get('caseNumber');
        String strPhoneNumber      = req.params.get('phoneNumber');
        String strEscalationReason = req.params.get('escalationReason');
        string strQuery            = '';
        string strError            = '';
        LIst<Case> lstCase         = new List<Case>();
        errorMessage__c errorMesssage = errorMessage__c.getValues('error');
        system.debug('==value of errorMesssage =='+errorMesssage );
        
        IF(strCaseNumber.length() == 8 && strPhoneNumber.length() == 10) {
            strQuery='SELECT id,contactId FROM Case WHERE CaseNumber='+'\''+strCaseNumber+'\''+' AND Contact_Phone__c='+'\''+strPhoneNumber +'\'' + ' LIMIT 1';
            try{
                lstCase = Database.Query(strQuery);
                IF(!lstCase.isEmpty()){
                    Escalation__c objEscalation        = new Escalation__c();
                    for(case eachCase :lstCase){
                        objEscalation.Related_Case__c      = eachCase.id;
                        objEscalation.Escalation_Reason__c = strEscalationReason;
                    }
                    try{
                    insert objEscalation;
                    }catch(exception ex){}       
                }
                Else{
                    strError= errorMesssage.DataNotFound__c ;
                }
            }catch(exception ex){}
            
        strError=errorMesssage.caseEscalationInfo__c;
        
        }        
        else{
            strError=errorMesssage.IncorrectData__c;
        }
        IF(strError != null){     
            RestContext.response.addHeader('Content-Type', 'application/json');
            String strJSON = JSON.serialize(strError);
            RestContext.response.responseBody = Blob.valueOf(strJSON);  
        }
    }

}