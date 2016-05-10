/**
* @ClassName    : TBN_AlertsForCaseDetail 
* @Description  : This class will fetch the alert messages that can be useful to the Call Center agent, after the creation of a Case record. 
*/
public with sharing class TBN_AlertsForCaseDetail 
{
    /* Start : Class Variables */
    public String caseId                    {get; set;}
    public String strAccountViewName        {get; set;}
    public Set<String> setAlertMessages     {get; set;}
     
    String strObjectType = '';
    List<String> lstViewIds = new List<String>();
    Set<Id> setViewIdsToBeSkipped = new Set<Id>();
    Case objCase = new Case();
    Case objCaseForViewComparison = new Case();
    Account objAccount =  new Account();
    Contact objContact =  new Contact();
    Asset objAsset =  new Asset();
    Product2 objProduct = new Product2();
    Case_Action__c  objCaseAction =  new Case_Action__c ();
    
    /* End : Class Variables */
    
    /**
      Method Name   : Constructor
      Description   : Does initialize the class variables and performs the actions needed on page load
    **/
    public TBN_AlertsForCaseDetail()
    {
        setAlertMessages = new Set<String>();
        caseId = Apexpages.currentPage().getParameters().get('recordId');
        strObjectType = Apexpages.currentPage().getParameters().get('objectType');
        if(caseId != null)
            objCase = [Select Id, AccountId, ContactId, AssetId, Asset.Product2Id, Product_Family__c From Case Where Id =: caseId limit 1]; 
        //  Method call to get the view Ids to be skipped, which have huge data falling under them
        getViewsToBeSkipped();
        
        if(objCase.AccountId != null && strObjectType == 'Account')     //Account
        {
            objAccount = [Select Id From Account Where Id =: objCase.AccountId LIMIT 1];
            getAlertMessages('Account', objCase.AccountId);
        }
        
        else if(objCase.ContactId != null && strObjectType == 'Contact')    //Contact
        {
            objContact = [SELECT Id FROM Contact where Id =: objCase.ContactId LIMIT 1];
            getAlertMessages('Contact', objCase.ContactId);
        }
        
        else if(objCase.AssetId != null && strObjectType == 'Asset')        //Asset
        {
            objAsset =  [SELECT Id FROM Asset where Id =: objCase.AssetId LIMIT 1];
            getAlertMessages('Asset', objCase.AssetId);
        }
        
        else if(objCase.Asset.Product2Id != null && strObjectType == 'Product') //Product
        {
            objProduct = [SELECT Id FROM Product2 where Id =: objCase.Asset.Product2Id LIMIT 1];
            getAlertMessages('product2', objProduct.Id);
        }
        else if(strObjectType == 'CaseAction')
        {
            try
            {
                //CaseAction
                objCaseAction =     [SELECT Id FROM Case_Action__c where Case__c =: objCase.Id LIMIT 1];
                getAlertMessages('Case_Action__c', objCaseAction.Id);
            }
            catch(Exception e)
            {
                system.debug('####Exception####');  
            }
        }
        
        else if(objCase.Id != null && strObjectType == 'Case')  //Case
        {
            objCaseForViewComparison = [Select Id From Case Where Id =: CaseId limit 1]; 
            getAlertMessages('Case', objCaseForViewComparison.Id);
        }
    }
    
    /**
      Method Name   : getViewsToBeSkipped
      Description   : Gets the viewIds from the custom setting that are not needed to be tested
    **/
    private void getViewsToBeSkipped()
    {
        for(ConfiguredViewIds__c objCS :ConfiguredViewIds__c.getAll().values())
        {
            setViewIdsToBeSkipped.add(objCS.ViewId__c);
        }
    } 
    
    /**
      Method Name   : getAlertMessages
      Parameters    : Recieves Sobject Name and Id of the Record to be processed
      Description   : Checks the view(s) of the record recieved through param and fetches the respective alert messages
    **/
    public void getAlertMessages(String strObject, String RecordId)
    {
        //  Instance of StandardsetController
        ApexPages.StandardSetController objSSC = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT Id FROM '+strObject+' LIMIT 1'));
        
        //  Avoids an Sobject checking with it's views when no corresponding alerts are configured
        String strQuery = 'Select Id From Alert_Relationship__c Where Related_Sobject__c =: strObject';
        if(Database.Query(strQuery).isEmpty())
            return;
        
        // Iterates through the all views of an Sobject
        for(Selectoption viewOption :  objSSC.getListViewOptions())
        {
            //  Checks whether the view lies in the "setViewIdsToBeSkipped" set or not
            if(setViewIdsToBeSkipped.contains(viewOption.getValue())) 
            {
                objSSC.setPageSize(2000);
                objSSC.setPageNumber(1);
                objSSC.setFilterId(viewOption.getValue());
                
                if(RecordId.startsWith('001'))      //Checking the Views of Account record that falls in 
                {
                    Set<Account> setAccount = new Set<Account>();
                    setAccount.addAll((List<Account>)objSSC.getRecords());
                    if(setAccount.contains(objAccount))
                    {
                        lstViewIds.add(viewOption.getValue());
                    }
                    else
                    {
                        objSSC.setPageNumber(2);
                        objSSC.setFilterId(viewOption.getValue());
                        setAccount = new Set<Account>();
                        setAccount.addAll((List<Account>)objSSC.getRecords());
                        if(setAccount.contains(objAccount))
                        {
                            lstViewIds.add(viewOption.getValue());
                        }
                        else
                        {
                            objSSC.setPageNumber(3);
                            objSSC.setFilterId(viewOption.getValue());
                            setAccount = new Set<Account>();
                            setAccount.addAll((List<Account>)objSSC.getRecords());
                            if(setAccount.contains(objAccount))
                            {
                                lstViewIds.add(viewOption.getValue());
                            }
                        }
                    }
                }
                
                else if(RecordId.startsWith('003')) //Checking the Views of Contact record that falls in
                {
                    Set<Contact> setContact = new Set<Contact>();
                    setContact.addAll((List<Contact>)objSSC.getRecords());
                    
                    if(setContact.contains(objContact))
                    {
                        lstViewIds.add(viewOption.getValue());
                    }
                    else
                    {
                        objSSC.setPageNumber(2);
                        objSSC.setFilterId(viewOption.getValue());
                        setContact = new Set<Contact>();
                        setContact.addAll((List<Contact>)objSSC.getRecords());
                        
                        if(setContact.contains(objContact))
                        {
                            lstViewIds.add(viewOption.getValue());
                        }
                        else
                        {
                            objSSC.setPageNumber(3);
                            objSSC.setFilterId(viewOption.getValue());
                            setContact = new Set<Contact>();
                            setContact.addAll((List<Contact>)objSSC.getRecords());
                            
                            if(setContact.contains(objContact))
                            {
                                lstViewIds.add(viewOption.getValue());
                            }
                        }
                    }
                }
                
                else if(RecordId.startsWith('02i')) //Checking the Views of Asset record that falls in
                {
                    Set<Asset> setAsset = new Set<Asset>();
                    setAsset.addAll((List<Asset>)objSSC.getRecords());
                    
                    if(setAsset.contains(objAsset))
                    {
                        lstViewIds.add(viewOption.getValue());
                    }
                    else
                    {
                        objSSC.setPageNumber(2);
                        objSSC.setFilterId(viewOption.getValue());
                        setAsset = new Set<Asset>();
                        setAsset.addAll((List<Asset>)objSSC.getRecords());
                        
                        if(setAsset.contains(objAsset))
                        {
                            lstViewIds.add(viewOption.getValue());
                        }
                        else
                        {
                            objSSC.setPageNumber(3);
                            objSSC.setFilterId(viewOption.getValue());
                            setAsset = new Set<Asset>();
                            setAsset.addAll((List<Asset>)objSSC.getRecords());
                            
                            if(setAsset.contains(objAsset))
                            {
                                lstViewIds.add(viewOption.getValue());
                            }
                        }
                    }
                }  
                
                else if(RecordId.startsWith('500'))     //Checking the Views of Case record that falls in
                {
                    Set<Case> setCase = new Set<Case>();
                    setCase.addAll((List<Case>)objSSC.getRecords());
                    
                    if(setCase.contains(objCaseForViewComparison))
                    {
                        lstViewIds.add(viewOption.getValue());
                    }
                    else
                    {
                        objSSC.setPageNumber(2);
                        objSSC.setFilterId(viewOption.getValue());
                        setCase = new Set<Case>();
                        setCase.addAll((List<Case>)objSSC.getRecords());
                        if(setCase.contains(objCaseForViewComparison))
                        {
                            lstViewIds.add(viewOption.getValue());
                        }
                        else
                        {
                            objSSC.setPageNumber(3);
                            objSSC.setFilterId(viewOption.getValue());
                            setCase = new Set<Case>();
                            setCase.addAll((List<Case>)objSSC.getRecords());
                            
                            if(setCase.contains(objCaseForViewComparison))
                            {
                                lstViewIds.add(viewOption.getValue());
                            }
                        }
                    }
                }
                
                else if(RecordId.startsWith('01t')) //Checking the Views of Product record that falls in
                {
                    Set<Product2> setProduct = new Set<Product2>();
                    setProduct.addAll((List<Product2>)objSSC.getRecords());
                    
                    if(setProduct.contains(objProduct))
                    {
                        lstViewIds.add(viewOption.getValue());
                    }
                    else
                    {
                        objSSC.setPageNumber(2);
                        objSSC.setFilterId(viewOption.getValue());
                        setProduct = new Set<Product2>();
                        setProduct.addAll((List<Product2>)objSSC.getRecords());
                        if(setProduct.contains(objProduct))
                        {
                            lstViewIds.add(viewOption.getValue());
                        }
                        else
                        {
                            objSSC.setPageNumber(3);
                            objSSC.setFilterId(viewOption.getValue());
                            setProduct = new Set<Product2>();
                            setProduct.addAll((List<Product2>)objSSC.getRecords());
                            if(setProduct.contains(objProduct))
                            {
                                lstViewIds.add(viewOption.getValue());
                            }
                        }
                    }
                }
                
                else if(RecordId.startsWith('a07'))//Checking the Views of Case Action record that falls in
                {
                    Set<Case_Action__c> setCaseAction = new Set<Case_Action__c>();
                    setCaseAction.addAll((List<Case_Action__c>)objSSC.getRecords());
                    
                    if(setCaseAction.contains(objCaseAction))
                    {
                        lstViewIds.add(viewOption.getValue());
                    }
                    else
                    {
                        objSSC.setPageNumber(2);
                        objSSC.setFilterId(viewOption.getValue());
                        setCaseAction = new Set<Case_Action__c>();
                        setCaseAction.addAll((List<Case_Action__c>)objSSC.getRecords());
                    
                        if(setCaseAction.contains(objCaseAction))
                        {
                            lstViewIds.add(viewOption.getValue());
                        }
                        else
                        {
                            objSSC.setPageNumber(3);
                            objSSC.setFilterId(viewOption.getValue());
                            setCaseAction = new Set<Case_Action__c>();
                            setCaseAction.addAll((List<Case_Action__c>)objSSC.getRecords());
                        
                            if(setCaseAction.contains(objCaseAction))
                            {
                                lstViewIds.add(viewOption.getValue());
                            }
                        }
                    }
                } 
            }
        }
        //  Query on the Alert_Relationship__c object to get the respective alerts
        for(Alert_Relationship__c objAlertRelationship : [SELECT Id, Related_SObject__c, ViewId__c, Alert__c, Alert__r.Alert_Message__c, Active__c FROM Alert_Relationship__c WHERE ViewId__c IN : lstViewIds and Active__c = true])
        {
            setAlertMessages.add(objAlertRelationship.Alert__r.Alert_Message__c);
        }
    }
    
    /**
      Method Name   : testTBN_AlertsForCaseDetail
      Description   : Test Method
    **/
    @isTest(SeeAllData=false)
    private static void testTBN_AlertsForCaseDetail()
    {    	
        Account objAccount = new Account(Name = 'Test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'Test Contact',Phone='999999989');
        insert objContact;
        Product2 objProduct = new Product2(Name = '12356789');
        insert objProduct;
        Asset objAsset = new Asset(Name = '1362979791884', product2Id = objProduct.Id, AccountId = objAccount.Id);
        insert objAsset;
        Case objCase = new Case(AccountId = objAccount.Id, ContactId = objContact.Id, AssetId = objAsset.Id);
        insert objCase;
        Case_Action__c objCaseAction = new Case_Action__c(Case__c = objCase.Id);
        insert objCaseAction;
        Alert__c objAlert = new Alert__c(Name = 'Test Alert', Alert_Message__c = 'Test Message');
        insert objAlert;
        Alert_Relationship__c objAR = new Alert_Relationship__c(Alert__c = objAlert.Id, Related_SObject__c = 'Account');
        insert objAR; 
        
        Apexpages.currentPage().getParameters().put('recordId', objCase.Id);
        Apexpages.currentPage().getParameters().put('objectType', 'Account');
        TBN_AlertsForCaseDetail objClass = new TBN_AlertsForCaseDetail();

		objAR.Related_SObject__c = 'Contact';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'Contact');
        objClass = new TBN_AlertsForCaseDetail();
        
        objAR.Related_SObject__c = 'Asset';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'Asset');
        objClass = new TBN_AlertsForCaseDetail();
        
       /* objAR.Related_SObject__c = 'Product2';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'Product');
        objClass = new TBN_AlertsForCaseDetail();
        
        objAR.Related_SObject__c = 'Case_Action__c';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'CaseAction');
        objClass = new TBN_AlertsForCaseDetail();
        
        /*objAR.Related_SObject__c = '';
        update objAR;*/
        /*Apexpages.currentPage().getParameters().put('objectType', 'Case');
        
        try{
            objClass = new TBN_AlertsForCaseDetail();
        }catch(Exception e){}*/
    }

		@isTest(SeeAllData=false)
    private static void testTBN_AlertsForCaseDetail2()
    {    	
        Account objAccount = new Account(Name = 'Test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'Test Contact',Phone='999999989');
        insert objContact;
        Product2 objProduct = new Product2(Name = '12356789');
        insert objProduct;
        Asset objAsset = new Asset(Name = '1362979791884', product2Id = objProduct.Id, AccountId = objAccount.Id);
        insert objAsset;
        Case objCase = new Case(AccountId = objAccount.Id, ContactId = objContact.Id, AssetId = objAsset.Id);
        insert objCase;
        Case_Action__c objCaseAction = new Case_Action__c(Case__c = objCase.Id);
        insert objCaseAction;
        Alert__c objAlert = new Alert__c(Name = 'Test Alert', Alert_Message__c = 'Test Message');
        insert objAlert;
        Alert_Relationship__c objAR = new Alert_Relationship__c(Alert__c = objAlert.Id, Related_SObject__c = 'Account');
        insert objAR; 
        
        Apexpages.currentPage().getParameters().put('recordId', objCase.Id);
        Apexpages.currentPage().getParameters().put('objectType', 'Account');
        /*TBN_AlertsForCaseDetail objClass = new TBN_AlertsForCaseDetail();

        /*objAR.Related_SObject__c = 'Contact';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'Contact');
        objClass = new TBN_AlertsForCaseDetail();
        
        objAR.Related_SObject__c = 'Asset';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'Asset');
        objClass = new TBN_AlertsForCaseDetail();*/
        
        objAR.Related_SObject__c = 'Product2';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'Product');
        TBN_AlertsForCaseDetail objClass = new TBN_AlertsForCaseDetail();
        
        objAR.Related_SObject__c = 'Case_Action__c';
        update objAR;
        Apexpages.currentPage().getParameters().put('objectType', 'CaseAction');
        TBN_AlertsForCaseDetail objClass1 = new TBN_AlertsForCaseDetail();
    }
}