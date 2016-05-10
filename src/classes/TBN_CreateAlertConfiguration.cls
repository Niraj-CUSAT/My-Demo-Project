public with sharing class TBN_CreateAlertConfiguration  
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
	
	public Alert_Relationship__c objAlertRelationship = new Alert_Relationship__c();
	
	//	Constructor
	public TBN_CreateAlertConfiguration(Apexpages.StandardController con)
	{
		objAlertRelationship = (Alert_Relationship__c)con.getRecord();
		initiazeDataMembers();
	}
	
	/**
	  Method Name	: initiazeDataMembers
	  Description	: Initializes the data members 
	**/
	private void initiazeDataMembers()
	{
		AccountFields = new List<FieldSetMember>();
		lstContacts = new List<Contact>();
		lstAccounts = new List<Account>();
		lstCases = new List<Case>();
		lstProducts = new List<Product2>();
		lstAssets = new List<Asset>();
		lstSampleViewRecords = new List<Account>();
		lstViews = new List<SelectOption>();
		
		lstViews.add(new SelectOption('None', '--None--'));
	} 
	
	/**
	  Method Name	: pageActionMethod
	  Description	: Redirects to the respective page based on the new Record or edit Record case. 
	**/
	public pageReference pageActionMethod()
	{
		if(ApexPages.currentPage().getParameters().containsKey('id'))
		{
			return new pageReference('/apex/TBN_UpdateAlertConfiguration?recordid=' + ApexPages.currentPage().getParameters().get('id'));
		}
		else
		{ 
			return null;
		}
	}
	
	/**
	  Method Name	: getViews
	  Description	: Fetches the views of perticular Sobject 
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
	  Description	: Creates a new record using the data entered in the page
	**/
	public pageReference SaveRecord()
	{
		insert objAlertRelationship; 
		return new pageReference('/'+objAlertRelationship.Id);
	}
	
	/**
	  Method Name	: fetchViewRecords
	  Description	: Fetches five records from the respective view, that selected in the page
	**/ 
	public void fetchViewRecords()
	{
		lstContacts = new List<Contact>();
		lstAccounts = new List<Account>();
		lstCases = new List<Case>();
		lstProducts = new List<Product2>();
		lstAssets = new List<Asset>();
		
		Set<Id> setRecordIds = new Set<Id>();
		
		strSelectedView = ApexPages.currentPage().getParameters().get('strSelectedView');
		
		//	Checks whether any view is selected or not
		if(strSelectedView != 'None')
		{
			objAlertRelationship.ViewId__c = strSelectedView;
			
			//	Adds the selected view as the filter over the respective SObject and gets the records falling under that view
			ApexPages.Standardsetcontroller objSSC = new ApexPages.Standardsetcontroller(database.getQueryLocator('select Id from '+strSelectedSObject+' limit 1'));
			objSSC.setFilterId(strSelectedView);
			objSSC.setPageSize(5);
			objSSC.setPageNumber(1);
			
			String strQuery = 'Select Id';
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
	}
	/**
	  Method Name	: testTBN_CaseInLine
	  Description	: Test Method.
	**/ 
	public static testMethod void testTBN_CreateAlertConfiguration()
	{
		Alert__c objAlert = new Alert__c(Name = 'Test Alert', Alert_Message__c = 'Test Message');
		insert objAlert;
		Alert_Relationship__c objAR = new Alert_Relationship__c(Alert__c = objAlert.Id, Related_SObject__c = 'Account');
		//insert objAR; 
		
		ApexPages.StandardController objCon = new ApexPages.StandardController(objAR);
		TBN_CreateAlertConfiguration objClass = new TBN_CreateAlertConfiguration(objCon);
		objClass.initiazeDataMembers();
		objClass.pageActionMethod();
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
		
		ApexPages.currentPage().getParameters().put('id',objAR.Id);
		objClass.pageActionMethod();
	}
}