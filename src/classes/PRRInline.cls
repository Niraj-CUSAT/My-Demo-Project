/*
    Name:   PRRInline
    Created By:  Dhriti Krishna Ghosh Moulick
    Created Date:  14/04/2015
    Modified By:  
    Last Modified Date: 
    Description:Fetch Invoice Attached field from PRR
    Methods Used:
*/
public Class PRRInline{
    private final PRR__c prrId;
    public Boolean displayMessage{get;set;}
    public PRRInline(ApexPages.StandardController stdController){
           prrId= (PRR__c)stdController.getRecord();
           PRR__c  prrDetails=[Select Id,AOSI_Invoice_Attached__c,Tank_Failure__c from PRR__c where Id =:prrId.Id];
           if(prrDetails.AOSI_Invoice_Attached__c==false){
               displayMessage=true;
           }
           else{
               displayMessage=false;
           }
           

           
    }
}