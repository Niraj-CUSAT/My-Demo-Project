public class PRRPdfcontroller {
    public List<Case> previousCaseRecord {get;set;}
    public PRR__c prrrecord{get;set;}
    public PRRPdfcontroller(ApexPages.StandardController controller) {
    previousCaseRecord =new List<Case>();
        prrrecord = [Select id,AOSI_Case__c,AOSI_Contact__c,AOSI_Asset__c from PRR__c where id =: ApexPages.currentPage().getParameters().get('id')];
        previousCaseRecord = [select id ,Assetid,CaseNumber,CreatedDate,AOSI_Customer_Concern__c,AOSI_Cause__c,AOSI_Action__c from Case where id !=: prrrecord.AOSI_Case__c and Assetid=:prrrecord.AOSI_Asset__c];   
    }
}