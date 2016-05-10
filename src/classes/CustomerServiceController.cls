/*#########################################################################
# File..................: CustomerServiceController
# API Version...........: 20
# Created by............: Vikram Middha
# Created Date..........: 02-Aug-2011
# Last Modified by......: Vikram Middha
# Last Modified Date....: 
# Description...........: This is the controller class for VF page CustomerService.
                        
# Copyright (c) 2000-2010. Astadia, Inc. All Rights Reserved.
#
# Created by the Astadia, Inc. Modification must retain the above copyright notice.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any commercial purpose, without fee, and without a written
# agreement from Astadia, Inc., is hereby forbidden. Any modification to source
# code, must include this paragraph and copyright.
#
# Permission is not granted to anyone to use this software for commercial uses.
#
# Contact address: 2839 Paces Ferry Road, Suite 350, Atlanta, GA 30339
# Company URL : http://www.astadia.com
###########################################################################*/
public class CustomerServiceController {
  
  /*Variable declarations*/
  public String searchAssetSerialNumber {get;set;}
  public String searchOwnerLastName {get;set;}
  public String searchContactPhone {get;set;}
  public String searchCaseNumber {get;set;}
  public String searchInstallStreet {get;set;}
  public String searchInstallCity {get;set;}
  public String searchInstallState {get;set;}
  public List<Asset> assets {get;set;}
  public List<Asset> pageAssets {get;set;}
  public Integer TotalAssets {get;set;}
  public Asset selectedAsset {get;set;}
  public Integer pageNumber {get;set;}
  public Integer pageSize {get;set;}
  public Integer totalPageNumber {get;set;}
  public Boolean assetDetailedEnabled {get;set;}
  public List<AssetContactJunction__c> contList {get;set;}
  public List<Case> selectedCaseList {get;set;}  
  public List<CaseComment> selectedCaseCommentList {get;set;}
  public List<Case_Action__c> selectedCaseActionList {get;set;} 
  public String selectedAssetNumber {get;set;}
  public String selectedContactId {get;set;}
  
  public List<AssetContactJunction__c> contactOwner ;
  public Map<String,CustomerService__c> custSettMap = new Map<String,CustomerService__c>(); 
  
  
  
  /*Constructor */  
  public CustomerServiceController(){
    
    init();
    Id existingId;
    
    /*Users creates a new case from this VF page. Upon saving the case, same VF page will be called with the selected Asset.*/
    if(ApexPages.currentPage().getParameters().get('source') != null && ApexPages.currentPage().getParameters().get('source') == 'case'){
      /*Id of the newly created Case*/
      if(ApexPages.currentPage().getParameters().get('newid')!=null){
        existingId = [select AssetId from case where id = :ApexPages.currentPage().getParameters().get('newid')].AssetId;
      }
    }
    /*If this VF page is called from some event, populate the selected Asset and other related scetions*/
    else if(ApexPages.currentPage().getParameters().get('assetId') != null){
      existingId = ApexPages.currentPage().getParameters().get('assetId');
      
    }
    /*Users creates a new asset from this VF page. Upon saving the asset, same VF page will be called with the selected Asset.*/
    else if(ApexPages.currentPage().getParameters().get('newid') != null && ApexPages.currentPage().getParameters().get('source') == 'asset'){ 
      existingId = ApexPages.currentPage().getParameters().get('newid');
    }
    
    /*If existingId is not null, query the record and populate all the sections of this page.*/
    if(existingId != null){
      selectedAsset = [select Id,InstallDate,Name,ProductName__c,Account.Name,Account.Id,Date_Code__c ,Model_Number__c ,Account__c,Version__c,Product2.ProductCode,
              Manufacture_Date__c,Status,Void_Reason__c,Invoice_Date__c,Invoice_Number__c,POP_Received__c,
              Product2.Family,Tank_Warranty_Expiration__c,Parts_Warranty_Expiration__c,Labor_Warranty_Expiration__c,
              Install_City__c,Install_Country__c,Install_Postal_Code__c,Install_State__c,Product_Name__c,Product_Family_New__c,Replacement_Unit_Name__c 
              ,Install_Street__c,Installation_Type__c,Registration_Method__c,Professionally_Installed__c,PurchaseDate 
              ,Physical_Location__c,Replacement__c,Product2.Id  from Asset where Id =:existingId];
    
    }
        
  }
  
  /*Method for initializing all the variables.*/
  private void init(){
    
    selectedCaseList = new List<Case>();
    selectedCaseCommentList = new List<CaseComment>();
    selectedCaseActionList = new List<Case_Action__c>();
    contactOwner = new List<AssetContactJunction__c>();
    contList = new List<AssetContactJunction__c>();
    custSettMap = CustomerService__c.getAll();
    assets = new List<Asset>();
    pageAssets = new List<Asset>();
    TotalAssets = -1;
    pageNumber = 0;
    pageSize = 10;
    totalPageNumber = 0;
    assetDetailedEnabled = false;
    
  }
  
  /*action method of the VF page. If new contact is created from the VF page, upon saving, this VF page will be called back and need to create the entry for Junction object.*/
  public PageReference execute(){
    if(selectedAsset != null && ApexPages.currentPage().getParameters().get('source') != null && ApexPages.currentPage().getParameters().get('source') == 'contact'){
      try{
        AssetContactJunction__c ajObj = new AssetContactJunction__c();
        ajObj.Contact__c = ApexPages.currentPage().getParameters().get('newid');
        ajObj.Asset__c = selectedAsset.Id;
        insert ajObj;
      }
      catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception occured while Adding/Creating Contact for this asset. Cause :' +  e.getMessage() + e.getStackTraceString()));  
      }
    }
    /*If this is not the first time VF page is called (selectedAsset is not null), load all the asset related data.*/
    if(selectedAsset != null){
      loadCaseRelatedObjects();
    }
    return null;
  }
  
  /*Decides if Previous button for paginations should be enabled or not.*/
  public Boolean getPreviousButtonEnabled()
  {
    return !(pageNumber > 1);
  }
  
  /*Decides if Next button for paginations should be enabled or not.*/
  public Boolean getNextButtonDisabled()
  {
    if (assets == null) return true;
    else
      return ((pageNumber * pageSize) >= assets.size());
  }
  
  /*helper method for pagination of the asset records.*/
  private void BindData(Integer newPageIndex)
  {
    try
    {
      pageAssets = new List<Asset>();
      Transient Integer counter = 0;
      Transient Integer min = 0;
      Transient Integer max = 0;
      if (newPageIndex > pageNumber)
      {
        min = pageNumber * pageSize;
        max = newPageIndex * pageSize;
      }
      else
      {
        max = newPageIndex * pageSize;
        min = max - pageSize;
      }
      for(Asset a : assets)
      {
        counter++;
        if (counter > min && counter <= max)
          pageAssets.add(a);
      }
      pageNumber = newPageIndex;
      if (pageAssets == null || pageAssets.size() <= 0)
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
    }
    catch(Exception ex)
    {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
    }
  }
  
    /*Method called on Search button hit. It prepares the query based on the search parameteres and searches asset records.*/
  public PageReference SearchAssets(){
    String buildQuery = '';
    String mainQuery = '';
    
    if(searchCaseNumber.length() == 0 && searchOwnerLastName.trim().length() == 0 &&  searchContactPhone.trim().length() == 0 && 
      searchAssetSerialNumber.trim().length() == 0 && searchInstallStreet.trim().length() == 0 && searchInstallCity.trim().length() == 0 && searchInstallState.trim().length() == 0){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please enter at least 1 search criteria . '));  
      return null;
          
    }
    selectedAsset = null;
    TotalAssets = 0;
    pageAssets = null;
    try{
      Set<Id> assetIdSet = new Set<Id>();
      String sosl = '';
      String initExp = '';
      String endExp = '';
      
      /*Build query if Case number has some value*/
      Set<Id> assetIdSet1 = new Set<Id>();
      if(searchCaseNumber != null && searchCaseNumber.trim().length() > 0){
          sosl = 'Find {'+searchCaseNumber.trim() + '} in Name fields returning Case(Id,AssetId)';
          List<List<sObject>> soList = search.query(sosl);
          List<Case> caseList = (List<Case>)soList.get(0);
          if(caseList.size() >0){
            for(Case c : caseList){
              assetIdSet1.add(c.AssetId);
            }
          }
          
      }
      /*Build query if Contact last name has some value*/
      sosl = '';  
      Set<Id> assetIdSet2 = new Set<Id>();    
      if(searchOwnerLastName.trim().length() > 0 && searchContactPhone.trim().length() >0){
        sosl = 'Find {'+searchOwnerLastName.trim()+' and '+searchContactPhone.trim() + '} in All fields returning AssetContactJunction__c(Id,Asset__c)';
        
      }else if(searchOwnerLastName.trim().length() == 0 && searchContactPhone.trim().length() >0){
        sosl = 'Find {'+searchContactPhone.trim() + '} in All fields returning AssetContactJunction__c(Id,Asset__c)';
          
      }else if(searchOwnerLastName.trim().length() >0 && searchContactPhone.trim().length() == 0){
        sosl = 'Find {'+searchOwnerLastName.trim()+ '} in All fields returning AssetContactJunction__c(Id,Asset__c)';
          
      }
      if(sosl.length() >0){
        List<List<sObject>> soList = search.query(sosl);
        List<AssetContactJunction__c> ajList = (List<AssetContactJunction__c>)soList.get(0);
        if(ajList.size() >0){
          for(AssetContactJunction__c aj : ajList){
            assetIdSet2.add(aj.Asset__c);
          }
        }
      }
      
      Set<Id> assetIdSet3 = new Set<Id>();
      if(searchAssetSerialNumber != null && searchAssetSerialNumber.trim().length() > 0){
        sosl = 'Find {'+searchAssetSerialNumber.trim()+ '} in Name fields returning Asset(Id)';
        List<List<sObject>> soList = search.query(sosl);
        
        List<Asset> aList = (List<Asset>)soList.get(0);
        
        if(aList.size()>0){
          for(Asset a : aList){
            assetIdSet3.add(a.Id);
          }
        }
      }
            
      String exprQuery = '';
      String whereQuery = '';
      
      Set<Id> assetIdSet4 = new Set<Id>();
      
      if(searchInstallStreet != null && searchInstallStreet.trim().length() > 0){
        exprQuery = searchInstallStreet + '* and ';
        //whereQuery = 'Install_Street__c=\''+searchInstallStreet + '\' and ';
      }
      if(searchInstallCity != null && searchInstallCity.trim().length() > 0){
        exprQuery += searchInstallCity + ' and ';
        whereQuery += 'Install_City__c=\''+searchInstallCity + '\' and ';
      }
      if(searchInstallState != null && searchInstallState.trim().length() > 0){
        exprQuery += searchInstallState;
        whereQuery += 'Install_State__c=\''+searchInstallState+'\'';
      }
      
      if(exprQuery.length() >0){
        if(exprQuery.endsWith(' and ')){
          exprQuery = exprQuery.substring(0,exprQuery.length() - 5);
          
        }
        if(whereQuery.length() >0 && whereQuery.endsWith(' and '))  {
          whereQuery = whereQuery.substring(0,whereQuery.length() - 5);
        }
        if(whereQuery.length() >0){
          sosl = 'Find {'+exprQuery+'} in All Fields returning Asset(Id where ' + whereQuery + ')';
        }
        else
          sosl = 'Find {'+exprQuery+'} in All Fields returning Asset(Id)';
        
        List<List<sObject>> soList = search.query(sosl);
        List<Asset> aList = (List<Asset>)soList.get(0);
        if(aList.size()>0){
          for(Asset a : aList){
            assetIdSet4.add(a.Id);
          }
        }
      }
      
      
    
      Set<Id> assetIdSetTemp = new Set<Id>();
      Set<Id> assetIdSetFinal = new Set<Id>();
      
      assetIdSetTemp.addAll(assetIdSet1);
      assetIdSetTemp.addAll(assetIdSet2);
      assetIdSetTemp.addAll(assetIdSet3);
      assetIdSetTemp.addAll(assetIdSet4);
            
      if(assetIdSetTemp.size()>0){
        for(Id id: assetIdSetTemp){
          Boolean val1 = true;
          Boolean val2 = true;
          Boolean val3 = true;
          Boolean val4 = true;
          
          if(searchCaseNumber.trim().length() > 0 && !assetIdSet1.contains(id)){
            val1 = false;
          }
          if((searchOwnerLastName.trim().length() >0 || searchContactPhone.trim().length() >0) && !assetIdSet2.contains(id)){
            val2 = false;
          }
          if(searchAssetSerialNumber.trim().length()>0 && !assetIdSet3.contains(id)){
            val3 = false;
          }
          if((searchInstallStreet.trim().length() > 0 || searchInstallCity.trim().length() >0 || searchInstallState.trim().length() >0) && !assetIdSet4.contains(id) ) {
            val4 = false;
          }
          if(val1 == true && val2 == true && val3 == true && val4 == true){
            assetIdSetFinal.add(id);
          }
          
        }
      }
      
    
      if(assetIdSetFinal.size() > 0){
        assets = [select Id,InstallDate,(Select Contact_Mailing_Address_del__c,Contact__r.Name, Contact__r.Phone 
              From AssetContactJunction__r where Contact__r.Contact_Type__c = 'Asset Owner' limit 1),Name,
              ProductName__c,Account.Name,Account.Id,Date_Code__c ,Model_Number__c ,Account__c,Version__c,Replacement_Unit_Name__c ,
              Product2.ProductCode,Product_Name__c,Product_Family_New__c,Manufacture_Date__c,Status,Void_Reason__c,Invoice_Date__c,Invoice_Number__c,
              POP_Received__c,Product2.Family,Tank_Warranty_Expiration__c,Parts_Warranty_Expiration__c,PurchaseDate ,
              Install_City__c,Install_Country__c,Install_Postal_Code__c,Install_State__c,Install_Street__c,
              Installation_Type__c,Registration_Method__c,Professionally_Installed__c,Physical_Location__c,
              Labor_Warranty_Expiration__c,Replacement__c,Product2.Id  from Asset where ID IN :assetIdSetFinal];
              
        /*Prepare the pagination data*/
        TotalAssets = assets.size(); 
        BindData(1);
        if (assets !=null)
        {
          totalPageNumber = assets.size() / pageSize;
          Integer mod = assets.size() - (totalPageNumber * pageSize);
          if (mod > 0)
            totalPageNumber++;
        }      
      }
       
    }
    catch(Exception e){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception occured while searching the Asset. Cause :' +  e.getMessage() + e.getStackTraceString()));
    }
    return null;
  }
  
  /*Returns the total number of asset records fetched. User for pagination*/  
  public Integer getTotalAssets(){
    return TotalAssets;
  }
  
  /*Prepares the pagination data on Next button click.*/
  public PageReference nextBtnClick() {
    BindData(pageNumber + 1);
    return null;
  }
  
  /*Prepares the pagination data on Next button click.*/
  public PageReference previousBtnClick() {
    BindData(pageNumber - 1);
    return null;
  }
  
  public String getCreateCaseLink(){
    String retURL = '';
    if(selectedAsset == null )
      return null;
    else if(custSettMap.size() > 0 && selectedAsset != null)
    {
      retURL += '&' + custSettMap.get('createCaseProductFamily').value__c +'=' + selectedAsset.Product_Family_New__c;
      return retURL;
    }
    else
      return null;
    
    
  }
  /*Method called when user selects any asset record. It loads all the selected Asset related data. */
  public PageReference SelectAsset(){
    
    for(Asset asset: assets)
      {
        if(asset.Name==selectedAssetNumber)
        {
          selectedAsset = asset;
          assetDetailedEnabled = true;
          
        }
      }
      if(selectedAsset != null){
        loadCaseRelatedObjects();
      }
                  
    return null;
  }
  
  /*Load all the asset related data*/
  private void loadCaseRelatedObjects(){
    try{
      selectedCaseList = [Select c.Subject, c.Status, c.Solution_Code__c, c.CreatedDate, c.CreatedBy.Name, 
              c.CreatedById, c.Contact.Name, c.ContactId, c.CaseNumber From Case c where AssetId =: selectedAsset.Id order by CreatedDate desc];
              
      selectedCaseCommentList = [Select c.Parent.CaseNumber, c.ParentId, c.CreatedDate,c.CreatedBy.Name, c.CommentBody From CaseComment c 
                    where  Parent.Asset.Id =:selectedAsset.Id order by CreatedDate desc]  ;
                    
      selectedCaseActionList = [Select Case__r.Asset.Product2.Name,Case__r.Asset.Product2.ProductCode,c.CreatedDate, c.CreatedBy.Name, 
                  c.CreatedById, c.Case__r.Case_Type__c, c.Case__r.CaseNumber, c.Case__c ,Name,RecordType.Name
                  From Case_Action__c c where case__r.Asset.Id =:selectedAsset.Id order by CreatedDate desc];
                    
      contList = [Select a.Contact__r.Id,a.Contact__r.Email,Contact__r.Contact_Type__c,Contact__r.MobilePhone, a.Contact__r.Name, a.Contact__r.Phone 
                From AssetContactJunction__c a where Asset__r.Id = :selectedAsset.Id order by CreatedDate desc];        
                    
      contactOwner = [Select a.Contact__r.Id,a.Contact__r.Email,Contact__r.FirstName,Contact__r.LastName,  a.Contact__r.Phone 
                From AssetContactJunction__c a where Asset__r.Id = :selectedAsset.Id and Contact__r.Contact_Type__c = 'Asset Owner'];
    }
    catch(Exception e){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception occured while loading the Asset related data. Cause :' +  e.getMessage() + e.getStackTraceString()));
    }                            
  }
  
  /*Returns Contact owner information. */
  public AssetContactJunction__c getContactOwner(){
    if(contactOwner.size() >0)
      return contactOwner.get(0);
    else
      return null;    
  }  
  
  /*Wrapper class for asset*/
  public class AssetWrap{
    Asset asset {get;set;}
  }
  
  /*Returns the asset list after search critiera is executed.*/
  public List<AssetWrap> getAssets(){
    Set<Id> accountIds = new Set<Id>();
    Map<Id,Account> accountIdMap ;
    List<AssetWrap> wrapList = new List<AssetWrap>();
    
    if(assets.size() > 0){
      for(Asset asst : assets){
        accountIds.add(asst.AccountId);    
      }
      accountIdMap = new Map<Id,Account>([select Id,Name from Account where Id IN:accountIds]);
    }
    
    if(assets.size() > 0){
      for(Asset asst : assets){
        AssetWrap wrapObj = new AssetWrap();
        wrapObj.asset = asst;
        wrapList.add(wrapObj);
      }
    }  
     return wrapList;
  }
  
  /*Action method for Edit button on Asset*/
  public PageReference editAsset(){
    if(selectedAsset == null)
      return null;
    PageReference pg = new PageReference('/'+selectedAsset.Id+'/e?retURL=%2F/apex%2FCustomerService%3FassetId%3D' + selectedAsset.Id);
    return pg;
  }
  
  /*Action method for New button on Asset*/
  public PageReference newAsset(){
    PageReference pg;
    if(selectedAsset != null)
      pg = new PageReference('/02i/e?saveURL=%2Fapex%2FCustomerService?source=asset&retURL=%2Fapex%2Fcustomerservice%3FassetId%3D'+selectedAsset.Id);
    else
      pg = new PageReference('/02i/e?saveURL=%2Fapex%2FCustomerService?source=asset&retURL=%2Fapex%2Fcustomerservice');
    return pg;
  }  
  
  /*Action method for Add Contact on Asset*/
  public PageReference addContact(){
    String url ;
    system.debug('------custSettMap----1-'+custSettMap);
    system.debug('------selectedAsset---1--'+selectedAsset);
    if(selectedAsset == null)
      return null;
    else if(custSettMap.size() >0 && selectedAsset != null)
    {
      url = '/' + custSettMap.get('AssetContactJunctionURL').value__c +'/e?'+custSettMap.get('JunctionContactId').value__c + '=' + selectedAsset.Name + '&' + custSettMap.get('JunctionContactLkid').value__c +'=' + selectedAsset.Id;
      url += '&saveURL=/apex/customerService?assetId='+selectedAsset.Id + '&retURL=/apex/customerService?assetId='+selectedAsset.Id;
      PageReference pg = new PageReference(url);
      return pg;
    }
    else
     return null;
  }
  
  public PageReference editOwner(){
    String url = '';
    if(getContactOwner() == null)
      url = '/apex/EditRegistration?assetId='+selectedAsset.Id;
    else 
      url = '/apex/EditRegistration?assetId='+selectedAsset.Id+'&ownerId='+getContactOwner().Contact__r.Id;  
    PageReference pg = new PageReference(url);
    return pg;
  }
  public PageReference callServiceProviderPage(){
    PageReference pref= new PageReference('/apex/GoogleMapDrivingDistance?src=console');
    return pref;
    
  }
  
   @IsTest(SeeAllData=false)
   public static void CustomerServiceController(){
     
     Account acc = new Account();
     acc.Name = 'Test Account';
     
     insert acc;
     
     Asset asst = new Asset();
     asst.Name = '123456789';
     asst.AccountId = acc.Id;
     asst.Manufacture_Date__c = System.today();
     insert asst;
     
     Contact con = new Contact();
     con.FirstName = 'FirstName';
     con.LastName = 'LastName';
     con.Phone = '999999978';
     con.Contact_Type__c = 'Asset Owner';
     insert con;
     
     Case caseObj = new Case();
     caseObj.Origin = 'Phone';
     caseObj.Status = 'Open';
     caseObj.OwnerId = UserInfo.getUserId();
     caseObj.AccountId = acc.Id;
     insert caseObj;
     
     
     AssetContactJunction__c acj = new AssetContactJunction__c();
     acj.Asset__c = asst.Id;
     acj.Contact__c = con.Id;
     insert acj;
     
     ApexPages.currentPage().getParameters().put('assetId',asst.Id);
     CustomerServiceController obj = new CustomerServiceController();
     obj.searchAssetSerialNumber = '123456789';
     obj.searchOwnerLastName = con.LastName;
     obj.searchCaseNumber = '1234';
     obj.searchContactPhone = '9999999999';
     obj.searchInstallCity = 'City';
     obj.searchInstallState = 'State';
     obj.searchInstallStreet = 'Street';
     
          
     obj.execute();
     obj.SearchAssets();
     obj.selectedAsset = asst;
     List<Asset> allAsset = new List<Asset>();
     allAsset.add(asst);
     obj.assets = allAsset;
     obj.SelectAsset();
     obj.addContact();
     obj.editAsset();
     obj.editOwner();
     obj.getAssets();
     obj.getContactOwner();
     obj.getNextButtonDisabled();
     obj.getPreviousButtonEnabled();
     obj.getTotalAssets();
     obj.newAsset();
     obj.nextBtnClick();
     obj.previousBtnClick();
     obj.getCreateCaseLink();
     obj.callServiceProviderPage();
          
     ApexPages.currentPage().getParameters().put('source','contact');
     obj.execute();
     
     ApexPages.currentPage().getParameters().put('source','case');
     ApexPages.currentPage().getParameters().put('newid',caseObj.Id);
     obj = new CustomerServiceController();
     obj.searchCaseNumber = '1234';
     obj.searchOwnerLastName = con.LastName;
     obj.SearchAssets();
   }
}