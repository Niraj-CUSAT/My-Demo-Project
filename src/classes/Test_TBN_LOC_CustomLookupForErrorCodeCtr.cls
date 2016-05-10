/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_TBN_LOC_CustomLookupForErrorCodeCtr {

    static testMethod void myUnitTest() {
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