/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    26/08/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a batch class for Creating Auto PM Cases for WT products
**************************************************************************************************/
global class AutoCreatePMCasesWTWarranty implements Database.Batchable<Sobject>{   
   public String query;
   public Date todaysDate;
   public Recordtype rtProduct; 
   public RecordTypeDetails__c productrecordType;
   public Recordtype rtCase;
   public RecordTypeDetails__c caserecordType;
   public String AOSIAutomaticPMService;
   public String productVertical; 
   public AutoCreatePMCasesWTWarranty(){
     
   }
   
   global Database.QueryLocator  start(Database.BatchableContext BC){
     productrecordType=RecordTypeDetails__c.getInstance('Product Name'); 
     rtProduct=DAL.getRecordTypeId(productrecordType.Developer_Name__c,productrecordType.SobjectType__c);
     
     Id rtProductId=rtProduct.Id;
     todaysDate =  system.today();     
     AOSIAutomaticPMService = 'Yes';
     productVertical='Water Treatment';
     query='Select a.PurchaseDate, a.Product2.RecordTypeId, a.Product2.IsActive, a.Product2Id, a.Id, a.ContactId, a.AOSI_PM_Service3_Date__c, a.AOSI_PM_Service2_Date__c, a.AOSI_PM_Service1_Date__c, a.AOSI_Automatic_PM_Service__c From Asset a where (a.AOSI_PM_Service1_Date__c =: todaysDate OR a.AOSI_PM_Service2_Date__c =: todaysDate OR a.AOSI_PM_Service3_Date__c =: todaysDate) AND  a.AOSI_Automatic_PM_Service__c =:AOSIAutomaticPMService AND a.Product2.IsActive =True AND a.Product2.AOSI_Vertical__c=:productVertical AND a.Product2.RecordTypeId =:rtProductId';
     return Database.getQueryLocator(query);     
   }
    
   global void execute(Database.BatchableContext BC,List<Sobject> scope){
          List<Case> autoPMCaseList = New List<Case>();         
          caserecordType=RecordTypeDetails__c.getInstance('Case Name'); 
          rtCase=DAL.getRecordTypeId(caserecordType.Developer_Name__c,caserecordType.SobjectType__c);
          System.debug('&&&&&&&&&&&&'+rtCase);
          for (Asset assetData: (List<Asset>)scope){
                   System.debug('&&&&&&&&&&&&&'+assetData);
                   Case autoPMCase = new Case();
                    autoPMCase.Status = 'Unregistered / Unallocated';
                    autoPMCase.reason = 'PM Service';
                    autoPMCase.contactid = assetData.ContactId;
                    autoPMCase.AOSIProduct__c = assetData.Product2Id;
                    autoPMCase.recordtypeid = rtCase.id;
                    autoPMCase.assetid = assetData.Id;
                    autoPMCase.AOSI_Warranty_Status_I__c = 'WR';
                    if(assetData.AOSI_PM_Service1_Date__c==System.today()){
                        autoPMCase.AOSI_Customer_Concern__c='PM Service 1';
                    }
                    if(assetData.AOSI_PM_Service2_Date__c==System.today()){
                        autoPMCase.AOSI_Customer_Concern__c='PM Service 2';
                    }
                    if(assetData.AOSI_PM_Service3_Date__c==System.today()){
                        autoPMCase.AOSI_Customer_Concern__c='PM Service 3';
                    }
                    autoPMCaseList.add(autoPMCase);            
          }
          if(!autoPMCaseList.isempty()){      
             try{
                   Insert autoPMCaseList;
             }
             catch(DMLException e) {
             }
         }
        System.debug('&&&&&&&&CaseList&&&&&'+autoPMCaseList);       
   }
   global void finish(Database.BatchableContext BC){
      System.debug('-----------Batch executed successfully-----------');    
   }
}