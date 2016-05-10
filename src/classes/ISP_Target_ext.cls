public with sharing class ISP_Target_ext {


    public List<ISP_Target__c> lTarget{get;set;}
    public ISP_Target__c Tname{get;set;}
    public ISP_Target__c target{get;set;}
    public ISP_Target_ext(ApexPages.StandardController controller) {
       lTarget = new List<ISP_Target__c>();
       target = new ISP_Target__c ();
       Tname = new ISP_Target__c ();
       target = (ISP_Target__c )controller.getRecord();
      
       lTarget = [select id,name,Assigned_To__r.name,Target_Actulas__c,Product1__c,Target_Units__c,From_date__c,To_date__c  from ISP_Target__c where Assigned_To__c =: userInfo.getUserId()];
       Tname = [select Assigned_To__r.name from ISP_Target__c  where Assigned_To__c =: userInfo.getUserId() limit 1];
    }

}