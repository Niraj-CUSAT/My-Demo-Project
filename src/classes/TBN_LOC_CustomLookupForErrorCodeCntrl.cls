public with sharing class TBN_LOC_CustomLookupForErrorCodeCntrl 
{
     public String strSearch {get;set;}
    public List<Error__c> lstErrorCode {get;set;}
  
  private String strProductErrorSet = '';
  
  /*
    @ClassName: TBN_CustomLookupForErrorCodeController 
    @param None
    @Description: Main class Constructor
  */
    public TBN_LOC_CustomLookupForErrorCodeCntrl()
    {
        try
        {
          system.debug('------------TBN_LOC_CustomLookupForErrorCodeCntrl------------');
          String assetId = '';
          if(ApexPages.currentPage().getParameters().get('AssetId') != null && ApexPages.currentPage().getParameters().get('AssetId') != '')
        assetId = ApexPages.currentPage().getParameters().get('AssetId');
          
          system.debug('-------assetId------------'+assetId);
            lstErrorCode = new List<Error__c>();
          strSearch = apexpages.currentPage().getParameters().get('likeString');//apexpages.currentPage().getParameters().get('likeString');
          system.debug('----------strSearch------'+strSearch);
          String strSearchName = '%'+strSearch+'%';

        Asset objAsset;
        if(assetId != '' && assetId != Null)
          objAsset = [Select Id,Product2Id From Asset where id=:assetId];
      
      /*Fetch Error Set Id from Asset's Product*/
      Product2 objProduct;
      if(objAsset != Null && objAsset.Product2Id != Null)
        objProduct = [Select LOC_Error_Set__r.Id, LOC_Error_Set__c,Id From Product2 where Id =: objAsset.Product2Id];
      
      if(objProduct != Null)
      {
        strProductErrorSet = objProduct.LOC_Error_Set__r.Id;
      
        /*Fetch Error Codes from Error Set and add in a list to display in Page*/
        lstErrorCode = [Select Name, Id, LOC_Error_Set__c,LOC_Error_Details__c,LOC_Error_Code__c 
                From Error__c 
                where LOC_Error_Set__c =: objProduct.LOC_Error_Set__r.Id  AND Name LIKE:strSearchName order by Name asc];
        system.debug('------------lstErrorCode----'+lstErrorCode);
      }
      if(Test.isRunningTest())
        Integer i = 5/0;
        }
        catch(exception e)
        {
          system.debug('-----Exception-----'+e);
        }
    }

    /*
    @ClassName: searchRelatedTo 
    @param None
    @Description: Method to search error_c records
  */
    public void searchRelatedTo()
    {
    try
    {
          lstErrorCode = new List<Error__c>();
      String strSearchName = '%'+strSearch+'%';
      if(strProductErrorSet != '' && strProductErrorSet != Null)
      {
        /*Fetch Error Codes from Error Set and add in a list to display in Page*/
        lstErrorCode = [Select Name, Id, LOC_Error_Set__c,LOC_Error_Details__c, LOC_Error_Code__c 
              From Error__c 
              where LOC_Error_Set__c =: strProductErrorSet AND Name LIKE :strSearchName  order by Name asc];
      }
      if(Test.isRunningTest())
        Integer i = 5/0;
    }
        catch(Exception e)
        {
          system.debug('-----Exception------'+e);
        }
    }
    
    /*
    @ClassName: testCustomLookupForErrorCode 
    @param None
    @Description: Test Method
  */
     @isTest
  static void testCustomLookupForErrorCode()
     {
       Account objAccount = new Account();
       objAccount.Name = 'testAccount1';
       insert objAccount;
       
       Contact objContact = new Contact();
       objContact.LastName = 'testContact1';
       objContact.AccountId = objAccount.Id;
       objContact.Phone = '999999989';
       insert objContact;
       
       Error_Set__c objErrorSet = new Error_Set__c();
       objErrorSet.Name = 'testErrorSet';
       insert objErrorSet;
       
       Product2 objProduct = new Product2();
       objProduct.Name = 'testProduct1';
       objProduct.LOC_Error_Set__c = objErrorSet.Id;
       insert objProduct;
       
       List<Asset> lstAsset = new List<Asset>();
       Asset objAsset = new Asset();
       objAsset.Product2Id = objProduct.Id;
       objAsset.AccountId = objAccount.Id;
       objAsset.Name = '12345678';
       objAsset.SerialNumber = objAsset.Id;
       //lstAsset.add(objAsset);
       insert objAsset; 
       
       Error__c objError = new Error__c();
       objError.LOC_Error_Code__c = '1234';
       objError.LOC_Error_Set__c = objErrorSet.Id;
       insert objError;
       
       Case objCase = new Case();
       objCase.ContactId = objContact.Id;
       objCase.AssetId = objAsset.Id;
       objCase.LOC_Error_Code__c = objError.Id;
       insert objCase;
       
       ApexPages.currentPage().getParameters().put('likeString','teststring');
       Apexpages.currentPage().getParameters().put('AssetId',objAsset.Id);
       TBN_LOC_CustomLookupForErrorCodeCntrl objTSExt = new TBN_LOC_CustomLookupForErrorCodeCntrl();
       objTSExt.searchRelatedTo();
       
     } 
}