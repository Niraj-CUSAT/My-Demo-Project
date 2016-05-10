/*
	ClassName : LOC_TSExtension
	Description : To override New and Edit button for recordType "Technical Services - Lochinvar"
	
	Maintence history :
	Created and Modified by - vkumar  
	Modified Date : 7/Mar/2014

*/

public with sharing class LOC_TSExtension 
{
	// Global variable declaration
	private static final String LOCHINVAR_RECORDTYPE = 'Technical Services - Lochinvar';
	public String recordTypeId {get;set;}
	public Case objCase {get;set;}
	public List<String> lstFieldAPINames {get;set;}
	public Boolean isLochinvarCase { get;set; }
	private Apexpages.Standardcontroller sc;
	
	//public Case objCase {get;set;}
    public String strErrorCodeId {get;set;}
    public String strErrorCodeName {get;set;}
    public boolean isErrorCodeExists {get;set;}
    public String isopenPopUp {get;set;}
    public String strSerialLength {get;set;}
    private List<RecordType> lstRecordType;
    public String caseId ;
    
	// Constructor
	public LOC_TSExtension(Apexpages.Standardcontroller sc)
	{
		caseId = sc.getId();
		recordTypeId = '';
		this.sc = sc;
		objCase = new Case();
		initializer();
	}	
	
	// Method initializes the case object and global variables
	private void initializer()
	{
		try
		{
			lstRecordType = [Select Id, SobjectType From RecordType where Name =:LOCHINVAR_RECORDTYPE limit 1];
			isLochinvarCase = false;
			objCase.OwnerId = UserInfo.getUserId();
			// Updated code [VSYSAOS - 36] When a user has access to only 1 recordType(Default), to fetch the default recordType
			if(caseId == null)
			{
				if(Apexpages.currentPage().getUrl().contains('RecordType') && Apexpages.currentPage().getParameters().get('RecordType') != null)
				{
					recordTypeId = Apexpages.currentPage().getParameters().get('RecordType');
					system.debug('$$$$$$$$$$$$$$$$$$$ recordType choosen'+ recordTypeId);
				}
				else if(!Apexpages.currentPage().getUrl().contains('RecordType'))
				{
					system.debug('#################### has default RD');
					// Fetch the default recordType for Case objects assigned to this profile
					for (Schema.RecordTypeInfo caseRDrInfo : Case.SObjectType.getDescribe().getRecordTypeInfos()) 
					{
		  				system.debug('################### caseRDrInfo'+ caseRDrInfo);
		  				if(caseRDrInfo.isDefaultRecordTypeMapping()) 
		  				{
		    				System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%  caseRDrInfo default'+ caseRDrInfo);
		    				System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%  caseRDrInfo default rd id'+ caseRDrInfo.getRecordTypeId());
		    				recordTypeId = caseRDrInfo.getRecordTypeId();
		  				}
	  				}
				}
				objCase.recordTypeId = recordTypeId;
				system.debug('^^^^^^^^^^^^^^^^^^^^^^^^ objCase.recordTypeId'+ objCase.recordTypeId);
				if(lstRecordType[0].Id != null && objCase.recordTypeId == lstRecordType[0].Id)
				{
					system.debug('############ matches with Loch');
					isLochinvarCase = true;
					InitialiseOnLoc(caseId);
				}	
				else if(lstRecordType[0].Id != null && objCase.recordTypeId != lstRecordType[0].Id)
				{
					system.debug('############ not Loch');
					isLochinvarCase = false;
				}
				system.debug('@@@@@@@ objCase.recordTypeId insert-------'+ objCase.recordTypeId);
			}
			
			// Assigning the recordTypeId on Case edit if RecordType of Case is Lochinvar
			if(caseId != null)
			{
				List<Case> lstCaseInserted = new List<Case>();
				lstCaseInserted = [Select Id From Case where Id =:caseId limit 1];
		        if(lstRecordType[0].Id != null && lstCaseInserted[0].recordTypeId == lstRecordType[0].Id)
		        {
		        	recordTypeId = lstCaseInserted[0].recordTypeId;
		        	isLochinvarCase = true;
		        	system.debug('############ Loch update yes'+ isLochinvarCase +'  '+lstRecordType[0].Id + '  '+recordTypeId);
		        	InitialiseOnLoc(caseId);
		        }
		       // Assigning the recordTypeId on edit Case if RecordType of Opportunity was not Lochinvar
		        else if(lstRecordType[0].Id != null && lstCaseInserted[0].recordTypeId != lstRecordType[0].Id)
		        {
		        	system.debug('############ Loch update no');
		        	recordTypeId = lstCaseInserted[0].recordTypeId;
		        	isLochinvarCase = false;
		        	system.debug('############ Loch update no'+ isLochinvarCase +'  '+lstRecordType[0].Id + '  '+recordTypeId);
		        	gatherFieldAPINames();
		        }
			}
			system.debug('@@@@@@@ objCase.recordTypeId update-------'+objCase.recordTypeId);
		}
		catch(Exception objExption)
		{
			system.debug('####################### Exception in Constructor'+objExption.getLineNumber()+' '+objExption.getMessage());
		}
	}
	
	// Retrive Field API's which is used on page to display standard Case page
	public void gatherFieldAPINames() 
	{
		
		try 
		{
			List<Case> lstCase = new List<Case>();
			lstFieldAPINames = new List<String>();
			String fieldsAPIName = Apexpages.currentPage().getParameters().get('fieldAPINames');
			if(fieldsAPIName != '')
			{
				system.debug('------------fieldsAPIName1--------'+fieldsAPIName);
				String strFieldAPI = fieldsAPIName.remove('#null');
				system.debug('------------strFieldAPI--------'+strFieldAPI);
				lstFieldAPINames.addAll(strFieldAPI.split('#'));
				system.debug('-----------lstFieldAPINames---------'+lstFieldAPINames);
			
				if(!lstFieldAPINames.isEmpty())
					lstCase = DataBase.query('Select ' + String.join(lstFieldAPINames, ', ') + ' From Case where Id =:caseId');
				if(!lstCase.isEmpty())
				  objCase = lstCase[0];
			}
			system.debug('---------objCase-------'+objCase);
			
		}
		catch(Exception e) 
		{
			system.debug('## Exception : '+e);
		}
	}
	
	// Initiaize global variables and Case object to bind values on edit  Case
	 public void InitialiseOnLoc(String caseId)
    {
        try
        {
            List<Case> lstCaseInserted = new List<Case>();
            strErrorCodeId = '';
            strErrorCodeName = '';
            
            //pre populate the owner id when its a new record
            if(caseId == null)  
            {
                objCase.OwnerId = UserInfo.getUserId();
            }
            else
            {
                String strQuery = 'Select ';
                
                //getting all the fields dynamically through field sets.
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.ContactDetails.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.ContactDetails1.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.ContactDetails2.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.ContactDetails3.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.Details.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.Details2.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                /*for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.Details3.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }*/
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.System.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.AssetDetails.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.AssetDetails2.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                
                /*for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.Additional_Information_Section.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }*/
                
                for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.System_Close_Date_section.getFields())
                {
                    strQuery += f.getFieldPath() + ', ';
                }
                strQuery += 'Contact.IsDeleted,Case.LOC_System_Guide__c, Case.LOC_Product_Parameters__c, Case.AssetId,Case.Type , Case.Description, Case.LOC_Error_Code__r.LOC_System_Guide__c, Contact.Id,LOC_Error_Code__r.Name From Case Where Id=:caseId';
                
                objCase = database.query(strQuery);
                system.debug('-----objCase--------------'+objCase);
                strErrorCodeId = objCase.LOC_Error_Code__c;
                strErrorCodeName = objCase.LOC_Error_Code__r.Name;
                if(objCase.AssetId == null)
                {
                    strErrorCodeName = '';
                    strErrorCodeId = '';
                }
            } 
        }
        catch(Exception e)
        {
            system.debug('---------Exception----------'+e);
        }
    }
    
    // Fetch the value passed from page to controller
    public void reloadMethod()
    {
    	if(strErrorCodeId != null && strErrorCodeId != '')
    		objCase.LOC_Error_Code__c = strErrorCodeId;
        insertCaseOnChange();
    }
	
	// Method called to generate the erroe code on change of Asset
	public void insertCaseOnChange()
    {
        try
        {
            if(strSerialLength == '0')
            {
                objCase.AssetId = null;
            }
            
            strErrorCodeName = '';
            strErrorCodeId = '';
            checkErrorCode();
            
            if(strErrorCodeName == '' || (strErrorCodeName != '' && objCase.AssetId != null) || (strErrorCodeName != '' && objCase.AssetId == null))
            {
               if(objCase.ContactId != null) // Added to avoid duplicate case creation without contactId onChange.
        	   {
			    	upsert objCase; 
			   }
            }
            if(objCase != null && objCase.Id != null)
            {
                InitialiseOnLoc(objCase.Id);
            }
            InitialiseOnLoc(objCase.Id);
            
        }
        catch(Exception e)
        {
            system.debug('-----------Exception------------'+e.getLineNumber()+'-----'+e.getMessage());
        }
    }
	
	// Method called to save the case record
	public pagereference saveCase()
    {
       try
        {
             /*We were facing null condition at first time on save cause we will not have id for new case record but from the next save the id will be provided so save will update
            the case record without any error*/
            system.debug('---------isLochinvarCase-------'+isLochinvarCase+' '+recordTypeId);
            if(isLochinvarCase)
            {
		        if(strErrorCodeName == '' || strErrorCodeName == Null)
		        {
		            objCase.LOC_Error_Code__c = Null;
		            objCase.Type = 'No Error Code';
		        }
		        else if(strErrorCodeName != '' && strErrorCodeName != Null && strErrorCodeId != '' && strErrorCodeId != Null)
		            objCase.LOC_Error_Code__c = strErrorCodeId;
		        
		        if(objCase.ContactId == null)
		        {
		        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Contact Name'));
		        	return null;
		        }
            }
            system.debug('---------save--------'+ objCase);
          /*  if(objCase.Id == null)
            {
                if(!isLochinvarCase)
                {
                	objCase.recordTypeId = recordTypeId;
                }
                system.debug('------objCase.recordTypeId-insert-----'+objCase.recordTypeId);
                insert objCase;
            }
            else if(objCase.Id != null)
            {
                if(!isLochinvarCase)
                {
                	objCase.recordTypeId = recordTypeId;
                }
                upsert objCase;
            }	
            
            PageReference pr= new PageReference('/'+objCase.id);
            pr.setRedirect(true);
            return pr;*/
            objCase.recordTypeId = recordTypeId;
            system.debug('################## objCase'+objCase);
            upsert objCase;
            PageReference pr= new PageReference('/'+objCase.id);
            pr.setRedirect(true);
            return pr;
        }
        catch(DMLException e)
        {	
        	ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0)) ;
			ApexPages.addMessage(msg);
			system.debug('=========msg=========='+msg);
			return null;
        }
    }
    
  	// Method called to save and close case record	
	public pagereference saveAndClose()
	{  
		try
		{
			objCase.Status = 'Closed';
			objCase.Close_Reason__c = 'Other';
			objCase.recordTypeId = recordTypeId;
			upsert objCase;
		    system.debug('---------objCase-----------'+objCase);
			PageReference pr= new PageReference('/'+objCase.id);
	        pr.setRedirect(true);
	        return pr;
		}
		catch(Exception e)
		{
			ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0)) ;
			ApexPages.addMessage(msg);
			system.debug('=========msg=========='+msg);
			return null;
		}
	}	
	
	// Method called to save and close the lochinvar Case record
	public pagereference saveAndCloseLoc()
	{
		try
		{
		        system.debug('--------saveAndCloseLoc--------');
		        objCase.Status = 'Closed';
				objCase.Close_Reason__c = 'Other';
				objCase.recordTypeId = lstRecordType[0].Id;
		        if(strErrorCodeName == '' || strErrorCodeName == Null)
		        {
		            objCase.LOC_Error_Code__c = Null;
		            objCase.Type = 'No Error Code';
		        }
		        else if(strErrorCodeName != '' && strErrorCodeName != Null && strErrorCodeId != '' && strErrorCodeId != Null)
		            objCase.LOC_Error_Code__c = strErrorCodeId;
		        
		        if(objCase.ContactId == null)
		        {
		        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a Contact Name'));
		        	return null;
		        }
		     
		    upsert objCase;
		    system.debug('---------objCase-----------'+objCase);
			PageReference pr= new PageReference('/'+objCase.id);
	        pr.setRedirect(true);
	        return pr;
		}
		catch(Exception e)
		{
			ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0)) ;
			ApexPages.addMessage(msg);
			system.debug('=========msg=========='+msg);
			return null;
		}
	}
 
   // Assigning value to Case.Type on interim save
   public void checkErrorCode()
    {
        try
        {
            isErrorCodeExists = isErrorSetExists();
            if(!isErrorCodeExists)
            {
                objCase.Type = 'No Error Code';
            }
            else
            {
                objCase.Type = 'Error Code';
            }
            
            if(Test.isRunningTest())
                Integer i = 5/0;    
                
        }
        catch(Exception e)
        {
            system.debug('-------Exception-------------'+e);
        }
    }
    // Checks if the error code exists or not for a product
     public boolean isErrorSetExists()
    {
        try
        {
            system.debug('--------------isErrorSetExists--------------');
            String strSearchName = '%'+strErrorCodeName+'%';
            Asset objAsset;
            if(objCase.AssetId != Null)
                objAsset = [Select Id,Product2Id From Asset where id=:objCase.AssetId];
                
            Product2 objProduct;
            if(objAsset != Null && objAsset.Product2Id != Null)
                objProduct = [Select LOC_Error_Set__r.Id, LOC_Error_Set__c,Id From Product2 where Id =: objAsset.Product2Id];
            
            if(objProduct != Null)
            {
                List<Error__c> lstErrorCode = new List<Error__c>();
                /*Fetch Error Codes from Error Set and add in a list to display in Page*/
                lstErrorCode = [Select Name, Id, LOC_Error_Set__c,LOC_Error_Details__c,LOC_Error_Code__c 
                                From Error__c 
                                where LOC_Error_Set__c =: objProduct.LOC_Error_Set__r.Id];
                system.debug('------------lstErrorCode------------'+lstErrorCode);
                if(lstErrorCode.size() > 0)
                    return true;
            }
        }
        catch(Exception e)
        {
            system.debug('-------Exception-------------'+e);
            return false;
        }
        return false;
    }
    @isTest
    static void testLOC_TSExtension()
    {
       Case objCase = new Case();
		String caseId=null;
		ApexPages.currentPage().getParameters().put('RecordType','RecordType');
		ApexPAges.StandardController sc = new ApexPages.StandardController(objCase);
		LOC_TSExtension objLOC_TSExtension = new LOC_TSExtension(sc); 
		objLOC_TSExtension.gatherFieldAPINames();
		objLOC_TSExtension.InitialiseOnLoc(caseId);
		objLOC_TSExtension.insertCaseOnChange();
		//objLOC_TSExtension.saveCase();
		//objLOC_TSExtension.saveAndClose();
		objLOC_TSExtension.saveAndCloseLoc();
		objLOC_TSExtension.checkErrorCode(); 
		objLOC_TSExtension.isErrorSetExists();    
    }
}