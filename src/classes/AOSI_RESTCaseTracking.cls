/*******************************************************************************************************

*Created By         : Keyur Modi
*Created Date       : September 21,2015
*Description        : An Apex REST service to that supports the following 
                      operations, related to case object for customer call tracking:
1.GET/caseTracking  : Case detail based on two parameters, case number and phone number 

********************************************************************************************************/

@RestResource(urlMapping='/caseTracking/*')
global with sharing class AOSI_RESTCaseTracking {

/*******************************************************************************************************
     * Method Name : caseTracking()
     * Return Type : void
     * Description : Defines case tracking functionality 
                     1)Based on the parameters (caseNumber & phoneNumber)return case detail in JSON formate 
                     2)If case is closed then response will be  "case is closed" 
                     3)If case number or phone number is not matching to the salesforce data then response will be "Data not found" 
********************************************************************************************************/
    @HttpGet   
    global static void caseTracking() {
        
        RestRequest req       = RestContext.request;
        RestResponse res      = RestContext.response;
        String strCaseNumber  = req.params.get('caseNumber');
        String strPhoneNumber = req.params.get('phoneNumber');

        Case_Fields__c CaseFiledsCommon = Case_Fields__c.getValues('common');
        system.debug('==value of CaseFieldsCommon=='+CaseFiledsCommon);
        Case_Fields__c CaseFiledsClosed = Case_Fields__c.getValues('Closed');
        system.debug('==value of CaseFiledsClosed=='+CaseFiledsClosed);
        Case_Fields__c CaseFiledsOnHold = Case_Fields__c.getValues('OnHold');
        system.debug('==value of CaseFiledsOnHold=='+CaseFiledsOnHold);
        Case_Fields__c serviceFiledsPclosed = Case_Fields__c.getValues('Partially Closed');
        system.debug('==value of serviceFiledsPclosed=='+serviceFiledsPclosed);
        errorMessage__c errorMesssage = errorMessage__c.getValues('error');
        system.debug('==value of errorMesssage =='+errorMesssage );
        
        List<Case> lstCase                 = new List<Case>();
        List<Sobject> lstCaseDetail        = new List<Sobject>();
        string strFieldsTofetch            = '';
        string strQuery                    = '';
        string strError                    = '';
        
        IF(strCaseNumber.length() == 8 && strPhoneNumber.length() == 10) {        
        
            strFieldsTofetch = CaseFiledsCommon.fieldsToQuery__C;   
            strQuery='SELECT ID,'+strFieldsTofetch+' FROM Case WHERE CaseNumber='+'\''+strCaseNumber+'\''+' AND Contact_Phone__c='+'\''+strPhoneNumber +'\'' + ' LIMIT 1';
            System.debug('==strQuery=='+strQuery);
            try{
                lstCase=Database.query(strQuery);
                system.debug('==lstCase=='+lstCase);
                    IF(lstCase.isEmpty()){
                    strError= errorMesssage.DataNotFound__c;
                    }else{
                        for(case eachCase: lstCase){                    
                            IF(eachCase.status == 'Closed'){
                                Date myDate = date.newinstance(eachCase.ClosedDate.year(), eachCase.ClosedDate.month(), eachCase.ClosedDate.day());
                                integer intNumOfDays=myDate.daysBetween(SYStem.Today());
                                system.debug('=='+intNumOfDays);
                                IF(intNumOfDays <= 90){
                                    strFieldsTofetch = '';
                                    strFieldsTofetch = CaseFiledsClosed.fieldsToQuery__C;                     
                                    strQuery     = '';
                                    strQuery='SELECT ID,'+strFieldsTofetch+' FROM Case WHERE CaseNumber='+'\''+strCaseNumber+'\''+' AND Contact_Phone__c='+'\''+strPhoneNumber +'\'' + ' LIMIT 1';
                                }
                                else{
                                    strError= errorMesssage.DataNotFound__c;
                                }
                            }
                            IF(eachCase.status == 'OnHold'){
                                strFieldsTofetch = '';
                                strFieldsTofetch = CaseFiledsOnHold.fieldsToQuery__C;                     
                                strQuery     = '';
                                strQuery='SELECT ID,'+strFieldsTofetch+' FROM Case WHERE CaseNumber='+'\''+strCaseNumber+'\''+' AND Contact_Phone__c='+'\''+strPhoneNumber +'\'' + ' LIMIT 1';
                            }
                            IF(eachCase.status == 'Partially Closed'){
                                strFieldsTofetch = '';
                                strFieldsTofetch = serviceFiledsPclosed.fieldsToQuery__C;                     
                                strQuery     = '';
                                strQuery='SELECT ID,'+strFieldsTofetch+' FROM Service_Charges__c  WHERE Case__r.CaseNumber='+'\''+strCaseNumber+'\''+' AND Case__r.Contact_Phone__c='+'\''+strPhoneNumber +'\'' + ' LIMIT 1';
                            }
                        }
                    }
            }catch(exception e){
            system.debug('==exception=='+e);
            }
        }
        else{
        strError=errorMesssage.IncorrectData__c;
        }
        try{
            lstCaseDetail = Database.Query(strQuery);
            system.debug('==lstCaseDetail=='+lstCaseDetail);
            IF(lstCaseDetail.isEmpty()){
                strError= errorMesssage.DataNotFound__c;
            }
        }catch(exception ex){
        }
        
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        
        IF(strError !=null){
            String strJSON = JSON.serialize(strError);
            RestContext.response.responseBody = Blob.valueOf(strJSON);
        }
        IF(!lstCaseDetail.isEmpty()){
            String strJSON = JSON.serialize(lstCaseDetail);
            SYStem.debug('==strJSON main=='+strJSON);
            RestContext.response.responseBody = Blob.valueOf(strJSON);
        }
    }

}