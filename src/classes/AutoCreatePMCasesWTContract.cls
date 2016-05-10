/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    31/08/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a batch class for Creating Auto PM Contract Cases for WT products
**************************************************************************************************/
global class AutoCreatePMCasesWTContract implements Database.Batchable<Sobject> {
	public String query;
	public Date todaysDate;
	public Recordtype rtCase;
    public RecordTypeDetails__c caserecordType;
    public String AOSIAutomaticPMService;
    
    public AutoCreatePMCasesWTContract(){
    	
    }
    
    global Database.QueryLocator start(Database.batchableContext bc){
    	todaysDate=System.today();
    	String activeContract ='Active';
    	query='Select id,AOSI_AMC__r.AOSI_Contract_Period_In_Years__c,AOSI_AMC__r.AOSI_Number_Of_PM_s_Visit__c,AOSI_Asset__c,AOSI_Asset__r.Contactid,AOSI_Asset__r.product2Id,AOSI_Contract_Status__c,AOSI_End_Date__c,AOSI_PM_Visit__c,AOSI_PM_Visit_Date__c,AOSI_Start_Date__c,AOSI_No_Of_PM_Visit__c,AOSI_PHCP_PM_Date1__c,AOSI_PHCP_PM_Date2__c,AOSI_PHCP_PM_Date3__c  from AOSI_Contract__c Where AOSI_Contract_Status__c=:activeContract AND (AOSI_PHCP_PM_Date1__c =:todaysDate OR AOSI_PHCP_PM_Date2__c=:todaysDate OR AOSI_PHCP_PM_Date3__c=:todaysDate)';
        return Database.getQueryLocator(query);     
    }
    
    global void execute(Database.BatchableContext BC,List<Sobject> scope){
    	List<Case> autoPMCaseList = New List<Case>();         
	   	caserecordType=RecordTypeDetails__c.getInstance('Case Name'); 
		rtCase=DAL.getRecordTypeId(caserecordType.Developer_Name__c,caserecordType.SobjectType__c);
		System.debug('&&&&&&&&&&&&'+rtCase);
		
		for(AOSI_Contract__c cont : (List<AOSI_Contract__c>)scope){
			System.debug('&&&&&&&&&&&&&'+cont);
	        Case autoPMCase = new Case();
	        autoPMCase.Status = 'Unregistered / Unallocated';
	        autoPMCase.reason = 'PM Service';
	        autoPMCase.contactid = cont.AOSI_Asset__r.ContactId;
	        autoPMCase.AOSIProduct__c = cont.AOSI_Asset__r.Product2Id;
	        autoPMCase.recordtypeid = rtCase.id;
	        autoPMCase.assetid = cont.AOSI_Asset__c; 
	        if(cont.AOSI_PHCP_PM_Date1__c==System.today()){
	        	autoPMCase.AOSI_Customer_Concern__c='PM Service 1';
	        }
	        if(cont.AOSI_PHCP_PM_Date2__c==System.today()){
	        	autoPMCase.AOSI_Customer_Concern__c='PM Service 2';
	        }
	        if(cont.AOSI_PHCP_PM_Date3__c==System.today()){
	        	autoPMCase.AOSI_Customer_Concern__c='PM Service 3';
	        }
	        autoPMCaseList.add(autoPMCase);     
		}  
		System.debug('&&&&&&&&autoPMCaseList&&&&&'+autoPMCaseList);   
		if(!autoPMCaseList.isempty()){
            try{                    
                    //Database.insert(autoPMCaseList,false);
                    insert autoPMCaseList;
            }catch(Exception E){
                system.debug('-------E--------'+E);
            }
        }   
        System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^'+autoPMCaseList);
    }
   
    global void finish(Database.BatchableContext BC){
   	  System.debug('-----------Batch executed successfully-----------');    
    }
    
}