public with sharing class LOC_TBN_UpdateAccountGeolocationInline {

	public string strRecId {get;set;}
	public Account objAccount;
	public string strAddress{get;set;} 
    
	public LOC_TBN_UpdateAccountGeolocationInline(ApexPages.StandardController ctlr)
	{
		try
		{
			strRecId = ApexPages.currentPage().getParameters().get('id');
			system.debug('@@@@@@@@@@@@@@@@@@@@@@@ strRecId'+ strRecId);
			objAccount = new Account();
			strAddress ='';
			objAccount = [ Select LOC_Longitude_x__c,LOC_Latitude_x__c,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
	            			   From Account 
	            			   WHERE id =: strRecId and  LOC_Longitude_x__c = null and LOC_Latitude_x__c = null];
	        system.debug('@@@@@@@@@@@@@@@@@@@@@@@ objAccount '+ objAccount);
	        if(objAccount != null)
	        {
	            if (objAccount.ShippingStreet != null && objAccount.ShippingStreet != '')
		                strAddress += objAccount.ShippingStreet +',';
	            if (objAccount.ShippingCity != null && objAccount.ShippingCity != '')
	                strAddress += objAccount.ShippingCity +',';
	            if (objAccount.ShippingState != null && objAccount.ShippingState != '')
	                strAddress += objAccount.ShippingState +',';
	            if (objAccount.ShippingPostalCode != null && objAccount.ShippingPostalCode != '')
	                strAddress += objAccount.ShippingPostalCode +',';
	            if (objAccount.ShippingCountry != null && objAccount.ShippingCountry != '')
	                strAddress += objAccount.ShippingCountry;
	            system.debug('##################### strAddress '+strAddress);
	        } 
		}
		catch(Exception e)
		{
			system.debug('########################## Exception '+e.getLineNumber()+'---'+e.getMessage());
		}
	}
	@isTest()
	static void Test_TBN_UpdateAccountGeolocationInline()
	{
		test.startTest();
		Account objAccount = new Account();
		objAccount.Name = 'Test Account 1';
		objAccount.ShippingState = 'test';
		objAccount.ShippingCountry = 'test';
		objAccount.ShippingStreet ='test' ;
		objAccount.ShippingCity = 'test';
		objAccount.ShippingPostalCode = '678678';
		objAccount.Type = 'Test';
		insert objAccount;
		
		
		ApexPages.currentPage().getParameters().put('id',objAccount.Id);
        Apexpages.Standardcontroller ctrl1 = new Apexpages.Standardcontroller(objAccount);
		LOC_TBN_UpdateAccountGeolocationInline objMap = new LOC_TBN_UpdateAccountGeolocationInline(ctrl1); 
		
		test.stopTest();
	}
}