public with sharing class TBN_UpdateAlertConfiguration  
{
	//	Global Variables
	public String strSelectedSObject	{get; set;}
	public String strSelectedView		{get; set;}
	public List<SelectOption> lstViews	{get; set;}
	public List<Contact> lstContacts	{get; set;}
	public List<Account> lstAccounts	{get; set;}
	public List<Case> lstCases			{get; set;}
	public List<Product2> lstProducts	{get; set;}
	public List<Asset> lstAssets		{get; set;}
	
	public List<FieldSetMember> AccountFields	{get; set;}
	public List<SObject> lstSampleViewRecords	{get; set;}
	
	public Alert_Relationship__c objAlertRelationship{get; set;}
		
	private Id recordId; 
	private Boolean onLoad = true;
	
	//	Constructor
	public TBN_UpdateAlertConfiguration(Apexpages.StandardController con)
	{
		initializations();
		fetchViewRecords();
	}
	
	/**
	  Method Name	: initializations
	  Description	: Makes the required initializations before page load
	**/ 
	private void initializations()
	{
		AccountFields = new List<FieldSetMember>();
		lstContacts = new List<Contact>();
		lstAccounts = new List<Account>();
		lstCases = new List<Case>();
		lstProducts = new List<Product2>();
		lstAssets = new List<Asset>();
		objAlertRelationship = new Alert_Relationship__c();
		lstViews = new List<SelectOption>();
		lstViews.add(new SelectOption('None', '--None--'));
		
		recordId = ApexPages.currentPage().getParameters().get('recordid'); 
		objAlertRelationship = [select Id, Name, Related_SObject__c, ViewId__c, Active__c, Alert__c from Alert_Relationship__c where Id =: recordId limit 1]; 
		
		//	Sets the initial values of strSelectedSObject and strSelectedView to the page
		if(objAlertRelationship.Related_SObject__c != null)
		{
			strSelectedSObject = objAlertRelationship.Related_SObject__c; 
			
			if(objAlertRelationship.ViewId__c != null)
				strSelectedView = objAlertRelationship.ViewId__c;
			
			ApexPages.Standardsetcontroller objSSC = new ApexPages.Standardsetcontroller(database.getQueryLocator('select Id from '+objAlertRelationship.Related_SObject__c+' limit 1'));
			lstViews.addAll(objSSC.getListViewOptions());
			
			//	Check whether the view still exists or got deleted, If deleted set the "strSelectedView" value to null
			Set<String> setViewIds = new Set<String>();
			for(SelectOption objSelectOption : lstViews)
			{
				setViewIds.add(objSelectOption.getValue());
			}
			if(!setViewIds.contains(objAlertRelationship.ViewId__c))
				strSelectedView = null;
		}
	} 
	
	/**
	  Method Name	: getViews
	  Description	: Fetches the respective view of an Sobject based on the Sobject selected in the page 
	**/ 
	public void getViews()
	{
		lstViews = new List<SelectOption>();
		lstViews.add(new SelectOption('None', '--None--'));
		ApexPages.Standardsetcontroller objSSC = new ApexPages.Standardsetcontroller(database.getQueryLocator('select Id from '+strSelectedSObject+' limit 1'));
		lstViews.addAll(objSSC.getListViewOptions());
	}
	
	/**
	  Method Name	: SaveRecord
	  Description	: Updates record to the database 
	**/ 
	public pageReference SaveRecord()
	{
		update objAlertRelationship; 
		return new pageReference('/'+objAlertRelationship.Id);
	}
	
	/**
	  Method Name	: fetchViewRecords
	  Description	: Retrieves five records of the selected view to show in the page 
	**/ 
	public void fetchViewRecords()
	{
		lstContacts = new List<Contact>();
		lstAccounts = new List<Account>();
		lstCases = new List<Case>();
		lstProducts = new List<Product2>();
		lstAssets = new List<Asset>();
		
		String strQuery = 'Select Id';
		Set<Id> setRecordIds = new Set<Id>();
		if(!onLoad)
			strSelectedView = ApexPages.currentPage().getParameters().get('strSelectedView');
		
		if(strSelectedView != 'None')
		{
			objAlertRelationship.ViewId__c = strSelectedView;
			
			try
			{
				ApexPages.Standardsetcontroller objSSC = new ApexPages.Standardsetcontroller(database.getQueryLocator('select Id from '+strSelectedSObject+' limit 1'));
				objSSC.setFilterId(strSelectedView);
			
				if(strSelectedSObject == 'Account')
				{
					lstSampleViewRecords = (List<Account>)(objSSC.getRecords());
					AccountFields = Schema.SObjectType.Account.fieldSets.AccountFieldSet.getFields();
					
					for(SObject objAccount : lstSampleViewRecords)
					{
						setRecordIds.add(objAccount.Id);
					}
					for(FieldSetMember fsFields : Schema.SObjectType.Account.fieldSets.AccountFieldSet.getFields())
					{
						strQuery += ', ' + fsFields.getFieldPath();
					} 
					
					strQuery += ' From Account where Id IN : setRecordIds limit 5';
					
					lstAccounts = new List<Account>((List<Account>)Database.query(strQuery));
					
				} 
				else if(strSelectedSObject == 'Contact')
				{
					lstSampleViewRecords = (List<Contact>)(objSSC.getRecords());
					AccountFields = Schema.SObjectType.Contact.fieldSets.ContactFieldSet.getFields();
					
					for(SObject objContact : lstSampleViewRecords)
					{
						setRecordIds.add(objContact.Id);
					}
					for(FieldSetMember fsFields : Schema.SObjectType.Contact.fieldSets.ContactFieldSet.getFields())
					{
						strQuery += ', ' + fsFields.getFieldPath();
					} 
					
					strQuery += ' From Contact where Id IN : setRecordIds limit 5';
					
					lstContacts = new List<Contact>((List<Contact>)Database.query(strQuery));
				}
				else if(strSelectedSObject == 'Case')
				{
					lstSampleViewRecords = (List<Case>)(objSSC.getRecords());
					AccountFields = Schema.SObjectType.Case.fieldSets.CaseFieldSet.getFields();
					
					for(SObject objCase : lstSampleViewRecords)
					{
						setRecordIds.add(objCase.Id);
					}
					for(FieldSetMember fsFields : Schema.SObjectType.Case.fieldSets.CaseFieldSet.getFields())
					{
						strQuery += ', ' + fsFields.getFieldPath();
					} 
					
					strQuery += ' From Case where Id IN : setRecordIds limit 5';
					
					lstCases = new List<Case>((List<Case>)Database.query(strQuery));
				}
				else if(strSelectedSObject == 'Product2')
				{
					lstSampleViewRecords = (List<Product2>)(objSSC.getRecords());
					AccountFields = Schema.SObjectType.Product2.fieldSets.ProductFieldSet.getFields();
					
					for(SObject objProduct : lstSampleViewRecords)
					{
						setRecordIds.add(objProduct.Id);
					}
					for(FieldSetMember fsFields : Schema.SObjectType.Product2.fieldSets.ProductFieldSet.getFields())
					{
						strQuery += ', ' + fsFields.getFieldPath();
					} 
					
					strQuery += ' From Product2 where Id IN : setRecordIds limit 5';
					
					lstProducts = new List<Product2>((List<Product2>)Database.query(strQuery));
				}
				else if(strSelectedSObject == 'Asset')
				{
					lstSampleViewRecords = (List<Asset>)(objSSC.getRecords());
					AccountFields = Schema.SObjectType.Asset.fieldSets.AssetFieldSet.getFields();
					
					for(SObject objAsset : lstSampleViewRecords)
					{
						setRecordIds.add(objAsset.Id);
					}
					for(FieldSetMember fsFields : Schema.SObjectType.Asset.fieldSets.AssetFieldSet.getFields())
					{
						strQuery += ', ' + fsFields.getFieldPath();
					} 
					
					strQuery += ' From Asset where Id IN : setRecordIds limit 5';
					
					lstAssets = new List<Asset>((List<Asset>)Database.query(strQuery));
				}
			}
			catch(Exception e)
			{
				return;
			}
		}
		else
		{
			objAlertRelationship.ViewId__c = null;
		}
		onLoad = false;
	}
	public pageReference cancel()
	{
		return new PageReference('/'+recordId);
	}
	/**
	  Method Name	: testTBN_UpdateAlertConfiguration
	  Description	: Test Method.
	**/ 
	public static testMethod void testTBN_UpdateAlertConfiguration()
	{
		Alert__c objAlert = new Alert__c(Name = 'Test Alert', Alert_Message__c = 'Test Message');
		insert objAlert;
		Alert_Relationship__c objAR = new Alert_Relationship__c(Alert__c = objAlert.Id, Related_SObject__c = 'Account');
		insert objAR; 
		
		ApexPages.currentPage().getParameters().put('recordid',objAR.Id);
		
		ApexPages.StandardController objCon = new ApexPages.StandardController(objAR);
		TBN_UpdateAlertConfiguration objClass = new TBN_UpdateAlertConfiguration(objCon);
		objClass.initializations();
		objClass.strSelectedSObject = 'Account';
		objClass.getViews();
		ApexPages.currentPage().getParameters().put('strSelectedView','');
		objClass.fetchViewRecords();
		objClass.SaveRecord();
		
		objClass.strSelectedSObject = 'Contact';
		objClass.getViews();
		ApexPages.currentPage().getParameters().put('strSelectedView','');
		objClass.fetchViewRecords();
		
		objClass.strSelectedSObject = 'Asset';
		objClass.getViews();
		ApexPages.currentPage().getParameters().put('strSelectedView','');
		objClass.fetchViewRecords();
		
		objClass.strSelectedSObject = 'Case';
		objClass.getViews();
		ApexPages.currentPage().getParameters().put('strSelectedView','');
		objClass.fetchViewRecords();
		
		objClass.strSelectedSObject = 'Case_Action__c';
		objClass.getViews();
		ApexPages.currentPage().getParameters().put('strSelectedView','');
		objClass.fetchViewRecords();
		
		objClass.strSelectedSObject = 'Product2';
		objClass.getViews();
		ApexPages.currentPage().getParameters().put('strSelectedView','');
		objClass.fetchViewRecords();
		objClass.cancel();
	}
}