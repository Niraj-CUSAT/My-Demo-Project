public with sharing class LOC_TBN_UpdateUserGeolocationInline 
{

	public string strRecId {get;set;}
	public User objUser;
	public string strAddress{get;set;}
    
	public LOC_TBN_UpdateUserGeolocationInline(ApexPages.StandardController ctlr)
	{
		strRecId = ApexPages.currentPage().getParameters().get('id');
		objUser = new User();
		strAddress ='';
		objUser = [Select Street, State,PostalCode,Country, City 
			 			From User  
			 			WHERE id =: strRecId and LOC_Latitude__c = null and LOC_Longitude__c = null];
		if(objUser != null)
		{
			if (objUser.Street != null && objUser.Street != '')
                strAddress += objUser.Street +', ';
            if (objUser.City != null && objUser.City != '')
                strAddress += objUser.City +', ';
            if (objUser.State != null && objUser.State != '')
                strAddress += objUser.State +' ';
            if (objUser.PostalCode != null && objUser.PostalCode != '')
                strAddress += objUser.PostalCode +', ';
            if (objUser.Country != null && objUser.Country != '')
                strAddress += objUser.Country;
		}
	}
	
	@isTest()
	static void Test_LOC_TBN_UpdateUserGeolocationInline()
	{
		test.startTest();
		Profile objProfile = [select id from profile limit 1]; 
        User objUser = new User(alias = 'stf', email='stf@test.com', emailencodingkey='UTF-8', lastname='Testingefsfs', languagelocalekey='en_US',
                        localesidkey='en_US',timezonesidkey='America/Los_Angeles',profileid = objProfile.Id,username='stf@test.com');
        
        objUser.State = 'TestState';
        objUser.City = 'TestCity';
        objUser.Street ='TestStreet';
        objUser.PostalCode ='340901';
        objUser.Country = 'testCountry';
        insert objUser;
		
		ApexPages.currentPage().getParameters().put('id',objUser.Id);
        Apexpages.Standardcontroller ctrl1 = new Apexpages.Standardcontroller(objUser);
		LOC_TBN_UpdateUserGeolocationInline objMap = new LOC_TBN_UpdateUserGeolocationInline(ctrl1); 
		
		test.stopTest();
	}
}