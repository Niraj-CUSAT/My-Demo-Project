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
private class TestGoogleMapDrivingDistanceController {

    static testMethod void myGoogleMapControllerTest() {
    	
    	 RecordType cspRecordType=[select id from RecordType where DeveloperName='QSP'];
    	 RecordType disRecordType=[select id from RecordType where DeveloperName='Distributor'];
    	 Profile p = [SELECT Id FROM profile WHERE name='Integration' limit 1];
         // mock user for the same
         User mockUser = new User(alias = 'newUser', email='newuser@tgerm.com',
                 emailencodingkey='UTF-8', lastname='Testing',
                 languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,
                 timezonesidkey='America/Los_Angeles', username='newuser@tgerm.com' + System.now().getTime());
          insert mockUser;
    	
    	 //Select IsAllowAllProfiles, o.DisplayName, o.Address From OrgWideEmailAddress o
    	
    	 system.runas(mockUser) {
    	 	
    	 Account testAccountServiceProvider= new Account(name='#1 Plumbing Company');
    	 testAccountServiceProvider.RecordTypeId=cspRecordType.id;
    	 testAccountServiceProvider.Brands_Serviced__c='American;Polaris';
    	 testAccountServiceProvider.Services__c='Commercial;Electric;Natural Gas;Residential';
    	 testAccountServiceProvider.QSP_Co_Grade_Level__c='5';
    	 testAccountServiceProvider.ShippingCity='Fall River';
    	 testAccountServiceProvider.ShippingCountry='USA';
    	 testAccountServiceProvider.ShippingPostalCode='53932';
    	 testAccountServiceProvider.ShippingState='WI';
    	 testAccountServiceProvider.ShippingStreet='680 Steel Rd';
    	 testAccountServiceProvider.Account_Status__c = 'Active';
    	 testAccountServiceProvider.Exclude_from_lookup__c= false; 
    	 testAccountServiceProvider.Geocode_Latitude__c=30.066888 ;
    	 testAccountServiceProvider.Geocode_Longitude__c=79.0214585;
    	 
	     List<Account> lstAccount = new List<Account>();
	     lstAccount.add(testAccountServiceProvider);
	     insert lstAccount;
	     
	     Account distriAccount = new Account(name='AKWEN LTD');
         distriAccount.RecordTypeId=disRecordType.id;
    	 distriAccount.Market__c='AO Smith National Ac';
    	 distriAccount.Industry = 'Wholesale';
    	 distriAccount.ShippingCity='UNIONTOWN';
    	 distriAccount.ShippingCountry='USA';
    	 distriAccount.ShippingPostalCode='44685-6227';
    	 distriAccount.ShippingState='OH';
    	 distriAccount.ShippingStreet='3743 BOETTLER OAKS DR';
    	 distriAccount.Account_Status__c = 'Active';
    	 distriAccount.Exclude_from_lookup__c= false; 
    	 distriAccount.Industry = 'Wholesale';
    	 distriAccount.Geocode_Latitude__c=30.066888 ;
    	 distriAccount.Geocode_Longitude__c=79.0214585;
    	 
    	 List<Account> lstAccount1 = new List<Account>();
	     lstAccount1.add(distriAccount);
	     insert lstAccount1;
	     
	     Contact ct = new Contact(AccountId=distriAccount.Id,lastname='testing',firstname='apex');
	     ct.MailingCity='UNIONTOWN';
	     ct.MailingCountry='USA';
	     ct.MailingPostalCode='44685-6227';
	     ct.MailingState='OH';
	     ct.MailingStreet='3743 BOETTLER OAKS DR';
	     
	     insert ct;
	     
	     Case caseObj = new Case();
	     caseObj.Origin='Phone';
	     caseObj.Status='Open';
	     caseObj.ContactId=ct.id;
	    // caseObj.CaseNumber = '150899';
	     insert caseObj;
	     
	     Case_Action__c caseActionObj = new Case_Action__c();
	     caseActionObj.Case__c=caseObj.Id;
	     insert caseActionObj;
	     
        PageReference pageRef = Page.GoogleMapDrivingDistance;
        Test.setCurrentPageReference(pageRef);
        
        GoogleMapDrivingDistanceController googleController = new GoogleMapDrivingDistanceController();
        SPLookupFilters__c filtersObj = new SPLookupFilters__c();
		
		pageRef.getParameters().put('street','3743 BOETTLER OAKS DR');
		pageRef.getParameters().put('state','OH');
		pageRef.getParameters().put('city','UNIONTOWN');
		pageRef.getParameters().put('zipCode','44685-6227');
		pageRef.getParameters().put('address','UNIONTOWN, USA');
		pageRef.getParameters().put('country','USA');
		pageRef.getParameters().put('src','Account');
		pageRef.getParameters().put('distance','78mi');
		pageRef.getParameters().put('distanceValue','500');
		pageRef.getParameters().put('duration','1 hour 24 mins');
		pageRef.getParameters().put('accutObj','testAccountServiceProvider');
		pageRef.getParameters().put('src','Case');
		pageRef.getParameters().put('conId',ct.Id);
		pageRef.getParameters().put('msg','TestCompany');
	 	pageRef.getParameters().put('accId',testAccountServiceProvider.Id);
	 	pageRef.getParameters().put('caseActionId',caseActionObj.id);
        pageRef.getParameters().put('caseActionId',caseActionObj.id);
	 	pageRef.getParameters().put('email','rsinghbist@astadia.com');
	 	
	 	googleController.showGoogleMap();
        googleController.selectProviderType = 'ServiceProvider';
        googleController.country = 'USA';
        googleController.filtersObj.Brands_Serviced__c = 'American;Polaris';
        googleController.filtersObj.Services__c = 'Commercial;Electric;Natural Gas;Residential';
        googleController.filtersObj.QSP_Co_Grade_Level__c = '5';
        googleController.result = '9';
        googleController.sourceOfCall = 'Account';
        googleController.backToParent();
        googleController.SearchService();
        googleController.providerType();
        googleController.accDistanceList[0].selectAccount = true;
        googleController.printPreview();
        googleController.selectProviderType = 'ServiceProvider';
        googleController.email ='test@gmail.com';
        googleController.msg= 'Service Provider</b><br/><br/>'+'<b>ServiceProvider near your Address</b><br/><br/>'+'<b>A.</b>'+'phone :1999077888'+'<br/><br/>';
        googleController.accDistanceList[0].selectAccount = true;
        pageRef.getParameters().put('caseId',caseObj.id);
        googleController.isLaunchedFromCaseAction = true;
        googleController.sendEmail();
        googleController.selectProviderType = 'ServiceProvider';
        googleController.updateCase();
        
        googleController.selectProviderType = 'Distributor';
        filtersObj.Market__c = 'AO Smith National Ac';
        googleController.country = 'USA';
        googleController.sourceOfCall = 'Contact';
        googleController.backToParent();
        googleController.selectProviderType = 'Distributor';
        googleController.SearchDistributor();
        googleController.providerType();
        googleController.accDistanceList[0].selectAccount = true;
        googleController.printPreview();
        googleController.selectProviderType = 'ServiceProvider';
        googleController.email ='test@gmail.com';
        googleController.msg= 'Service Provider</b><br/><br/>'+'<b>ServiceProvider near your Address</b><br/><br/>'+'<b>A.</b>'+'phone :1999077888'+'<br/><br/>';
        googleController.accDistanceList[0].selectAccount = true;
        pageRef.getParameters().put('caseId',caseObj.id);
        googleController.isLaunchedFromCaseAction = true;
        googleController.sendEmail();
        googleController.selectProviderType = 'ServiceProvider';
        GoogleMapDrivingDistanceController.LinearSortList(googleController.accDistanceList, '2');
    	}
    }

}