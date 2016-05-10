/****************************************************************************************************  
    Created by    :    Hardev Parmar, KVP Business Solutions
    Created On    :    1 AUG 2013
    Modified by   :    Hardev parmar
    Modified on   :    
    Description   :    This is a batch class for Creating Auto PM Cases for Asset
**************************************************************************************************/

global class BatchCreateAutoPMCases implements Database.Batchable<sObject> {
   // public static boolean isBatchPMclassRun;
    public List<Asset> AssetList = new List<Asset>();
    public List<Case> PmCaseList = new List<Case>();
    public String query;
    public List<Recordtype> rt = new List<Recordtype>();
    public List<Recordtype> prodRecId = new List<Recordtype>();
    public Date todaysDate;
    public String AOSIAutomaticPMService;
    public String prodRecTypeId;
    Public smagicinteract__SMS_Template__c  SMS_TemplateComplaint;
    Public Map<String,String> CaseIdtoTemplateText = new  Map<String,String>();
    
    global BatchCreateAutoPMCases(){
            rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1];  
            prodRecId = [Select id,name from recordtype where DeveloperName ='AOSIndia' and SobjectType ='Product2' limit 1 ]; 
            prodRecTypeId = prodRecId[0].id;
            todaysDate =  system.today();            
            AOSIAutomaticPMService = 'Yes';
            query = 'Select a.PurchaseDate, a.Product2.RecordTypeId, a.Product2.IsActive, a.Product2Id, a.Id, a.ContactId, a.AOSI_PM_Service3_Date__c, a.AOSI_PM_Service2_Date__c, a.AOSI_PM_Service1_Date__c, a.AOSI_Automatic_PM_Service__c From Asset a where (a.AOSI_PM_Service1_Date__c =: todaysDate OR a.AOSI_PM_Service2_Date__c =: todaysDate OR a.AOSI_PM_Service3_Date__c =: todaysDate)  AND  a.AOSI_Automatic_PM_Service__c =:AOSIAutomaticPMService AND a.Product2.IsActive =True AND a.Product2.RecordTypeId =:prodRecTypeId';     
             
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);     
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Case> CaseList = New List<Case>();         
        for (Asset a: (List<Asset>)scope){
               Case c = new Case();
                c.reason = 'PM Service';
                c.contactid = a.ContactId;
                c.AOSIProduct__c = a.Product2Id;
                c.recordtypeid = rt[0].id;
                c.assetid = a.Id;
                c.AOSI_Warranty_Status_I__c = 'WR';
                CaseList.add(c);            
            }
            if(!CaseList.isempty())
            {
                try
                {
                    Insert CaseList;
                }
                Catch(DMLException e)
                {
               }
        
            }         
         
    }
       global void finish(Database.BatchableContext BC){
        System.debug('-----------Batch executed successfully-----------');    
    }       
    
}