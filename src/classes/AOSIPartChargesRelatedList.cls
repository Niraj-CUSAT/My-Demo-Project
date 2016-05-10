/****Field Name: AOSIPartChargesRelatedList
    Created By:Dhriti Krishna Ghosh Moulick
    Modified By:
    Description:This class is used to display service charges of closed cases
*****/
public with sharing class AOSIPartChargesRelatedList {
	
	public Asset      assetRecord                     {get;set;}
	public String     assetId                         {get;set;}
	public List<Case> closedCaseList                  {get;set;}
	public List<Service_Charges__c> serviceChargeList {get;set;}
	public List<wrapperList> wrapperListService       {get;set;}
	public String strJsonData                         {get;set;}
	public RecordType caseAOSIndiaRecType             {get;set;}
	
	public AOSIPartChargesRelatedList(ApexPages.StandardController stdController){
		   
		   caseAOSIndiaRecType = AOSI_StaticQueryHelper.caseAOSIndiaRecType;
		   wrapperListService = new List<wrapperList>();
		   assetRecord =(Asset)stdController.getRecord();
		   assetId =assetRecord.Id; 
		   
		   System.debug('&&&&&&&&&&&assetId&&&&&&'+assetId+'**********************'+caseAOSIndiaRecType.Id);
		   closedCaseList=[Select Id,RecordTypeID,AssetId,caseNumber,Status,(Select Case__r.CaseNumber,Id,Name,Type__c,Chargable__c,Spares__r.Name,Spares__c,Part_Charges1__c,Accessory_Charges1__c,Part_Charges__c,MRP_Charges__c,Final_Charges__c from Service_Charges__r) from Case where Status='Closed' AND  assetId=:assetId AND RecordTypeId=:caseAOSIndiaRecType.ID];
		   
		   System.debug('^^^^^^^^^^^^^^^^^^^^^^^'+closedCaseList);
		   serviceChargeList = new List<Service_Charges__c>();
		   for(Case cse:closedCaseList){
               if(cse.Service_Charges__r!=null)
               {
              	//serviceChargeList = new List<Service_Charges__c>();
		   	  	for(Service_Charges__c srvice:cse.Service_Charges__r){
		   	  	serviceChargeList.add(srvice);
		   	  }     
               }
		   	  
		   }
        	system.debug('***************serviceChargeList'+serviceChargeList);
		   for(Service_Charges__c service:serviceChargeList ){
		   	     wrapperList wrapperservice = new wrapperList();
		   	     wrapperservice.caseId = service.Case__c;
		   	     wrapperservice.serviceChargesId=service.Id;
		   	     wrapperservice.name = service.Name;
		   	     wrapperservice.caseNumber = service.Case__r.CaseNumber;
		   	     wrapperservice.type = service.Type__c;
		   	     wrapperservice.chargable = service.Chargable__c;
		   	     if(service.Spares__c!=null){
		   	     wrapperservice.spares = service.Spares__r.Name;
		   	     wrapperservice.spareId = service.Spares__c;
		   	     }else{
		   	     wrapperservice.spares = '';
		   	     wrapperservice.spareId = '';
		   	     }
		   	     wrapperservice.partCharges =  service.Part_Charges1__c;
		   	     wrapperservice.accesoryCharges = service.Accessory_Charges1__c;
		   	     wrapperservice.mrpCharges = service.MRP_Charges__c;
		   	     wrapperservice.finalCharges = service.Final_Charges__c;
		   	     wrapperListService.add(wrapperservice);
		   }
		   strJsonData = JSON.serialize(wrapperListService); //Serialize the wrapper list to a string
        system.debug('strJsonData'+strJsonData);
	}

    public Class WrapperList{
    	
    	public String spareId              {get;set;}
    	public String serviceChargesId     {get;set;}
    	public String caseId               {get;set;}
    	public String caseNumber           {get;set;}
    	public String name                 {get;set;}
    	public String type                 {get;set;}
    	public String chargable            {get;set;}
    	public String spares               {get;set;}
    	public Decimal partCharges         {get;set;}
    	public Decimal accesoryCharges     {get;set;}
    	public Decimal mrpCharges          {get;set;}
    	public Decimal finalCharges        {get;set;}
    }
}