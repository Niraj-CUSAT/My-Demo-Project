/*******************************************************************************
Created by    :    Rajesh Kumar, KVP Business Solutions Pvt. Ltd.
Created On    :    21/8/2015
Description   :    This class is used to handle the renewal process of ASP
********************************************************************************/
global class AOSI_ASP_RenewalProcess {
    //web service to submit the PRR for approval
    webservice  static String renewContract(String aspid)
    {
       String message=null; 
       // Loading the prr details into the object
       ASP__c asp=[select Id,AOSI_Renewal__c,AOSI_Contract_Effective_From_Date__c,AOSI_Contract_Effective_To_Date__c,Previous_Contract_Effective_From_Date__c,Previous_Contract_Effective_To_Date__c from ASP__c where Id =:aspid limit 1];
       if(System.today() >= asp.AOSI_Contract_Effective_To_Date__c -30)
       {
       asp.AOSI_Renewal__c=true;
       asp.AOSI_Approval_Status__c='Submit for Renewal';
       asp.Previous_Contract_Effective_From_Date__c=asp.AOSI_Contract_Effective_From_Date__c;
       asp.Previous_Contract_Effective_To_Date__c=asp.AOSI_Contract_Effective_To_Date__c;
        update asp; 
       //Loading the attachements of the PRR
       if(asp != null)
       {
             try
             {  
            // Create an approval request for the PRR
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(asp.id);
            // Submit the approval request for the PRR
            Approval.ProcessResult result = Approval.process(req1);
            message='This record has been successfully submitted for the renewal.';     
            }
            Catch(Exception ex)
            {
            message='This approval request does not match the entry criteria.\nPlease make sure this record fulfils all the criteria to be submitted for approval.';
            }
           
       }  
         
       }       
       else
       {
		message='Contract can be renewed before 30 days of contract expiry date or after contract expiry';  
       }
       return message;
    
    }
}