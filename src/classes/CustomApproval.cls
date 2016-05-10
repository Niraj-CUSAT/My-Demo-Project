/*******************************************************************************
Created by    :    Rajesh Kumar, KVP Business Solutions Pvt. Ltd.
Created On    :    21/8/2015
Description   :    This class is used to handle the approval process of PRR
********************************************************************************/
global class CustomApproval
{ 
    //web service to submit the PRR for approval
    webservice  static String SubmitPRRForApproval(String prrid)
    {
       String message=null; 
       // Loading the prr details into the object
       PRR__c prr=[select Id,AOSI_Serious_Issue_Product_Burnt__c,Tank_Failure__c from PRR__c where Id =:prrid limit 1]; 
       //Loading the attachements of the PRR
       List<Attachment> prrattachments=[select id,name from Attachment where parentid=:prrid];
       
       if(prr != null)
       {
           // If tank failure option is selected and no attachment is found, the display error message
           if((prr.Tank_Failure__c) && prrattachments.size()== 0 || (prr.AOSI_Serious_Issue_Product_Burnt__c) && prrattachments.size()== 0)
           {
               message = 'Attachment is mandatory.';
           }
           else
           {
             try
             {  
            // Create an approval request for the PRR
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(prr.id);
            // Submit the approval request for the PRR
            Approval.ProcessResult result = Approval.process(req1);
            }
            Catch(Exception ex)
            {
            message='This approval request does not match the entry criteria.\nPlease make sure this record fulfils all the criteria to be submitted for approval.';
            }
           }
       } 
       return message;
    
    }
  }