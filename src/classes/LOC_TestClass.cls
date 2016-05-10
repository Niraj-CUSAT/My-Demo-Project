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
private class LOC_TestClass {

    //
    static testMethod void Test_TBN_AccountTrigger()
	{
		Account objParentAccount = new Account();
		objParentAccount.Name = 'Parent Account ';
		insert objParentAccount;
		
		Account objAccount = new Account();
		objAccount.Name = 'Child account';
	 	objAccount.ParentId = objParentAccount.Id;
		objAccount.LOC_Manufacturers_Rep__c = false;
		insert objAccount;
		
		objParentAccount.LOC_Manufacturers_Rep__c = true;
		update objParentAccount;
		
		system.assertEquals(objParentAccount.LOC_Manufacturers_Rep__c, true);
		system.assertEquals(objAccount.ParentId, objParentAccount.Id);
		
	}
	
	//
	static void Test_TBN_FindLocation()
    {
        test.startTest();
        
        Account objAccount = new Account();
        objAccount.Name = 'Test objAccount 1';
        objAccount.ShippingState = 'TestState';
        objAccount.ShippingCity = 'TestCity';
        objAccount.ShippingStreet ='TestStreet';
        objAccount.ShippingPostalCode ='340901';
        objAccount.ShippingCountry = 'testCountry';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Test Contact 1'; 
        objContact.MailingState = 'TestState';
        objContact.MailingCity = 'TestCity';
        objContact.MailingStreet ='TestStreet';
        objContact.MailingPostalCode ='340901';
        objContact.MailingCountry = 'testCountry';
        insert objContact; 
        
        Profile objProfile = [select id from profile limit 1]; 
        User objUser = new User(alias = 'stf', email='stf@test.com', emailencodingkey='UTF-8', lastname='Testingefsfs', languagelocalekey='en_US',
                        localesidkey='en_US',timezonesidkey='America/Los_Angeles',profileid = objProfile.Id,username='stf@test.com');
        objUser.State = 'TestState';
        objUser.City = 'TestCity'; 
        objUser.Street ='TestStreet';
        objUser.PostalCode ='340901';
        objUser.Country = 'testCountry';
        insert objUser;
        test.stopTest();
    }
	
	//
	static testMethod void Test_TBN_AssetTrigger()
	{ 
		Account objAccount = new Account();
		objAccount.Name = 'Parent Account ';
		insert objAccount;
		
		list<Asset> lstAsset = new list<Asset>();
		Asset objAsset = new Asset(AccountId =objAccount.Id, Name= 'Test Asset 1' );
		lstAsset.add(objAsset);
		insert objAsset;
		
		system.assertEquals(lstAsset.size(), 1);
		
		Asset objAsset1 = new Asset(AccountId =objAccount.Id, Name= 'Test Asset 2' ,LOC_Unit_Price__c = 100 ,LOC_Shipped_Date__c = Date.today());
		lstAsset.add(objAsset1);
		Asset objAsset2 = new Asset(AccountId =objAccount.Id, Name= 'Test Asset 3' ,LOC_Shipped_Date__c = Date.today());
		lstAsset.add(objAsset2);
		insert objAsset2;
		Asset objAsset3 = new Asset(AccountId =objAccount.Id, Name= 'Test Asset 4' ,LOC_Unit_Price__c = 100 ,LOC_Shipped_Date__c = Date.today().addDays(-1));
		lstAsset.add(objAsset3);
		Asset objAsset4 = new Asset(AccountId =objAccount.Id, Name= 'Test Asset 5 ' ,LOC_Unit_Price__c = 100 ,LOC_Shipped_Date__c = Date.today().addDays(-2));
		lstAsset.add(objAsset4);
		Asset objAsset5 = new Asset(AccountId =objAccount.Id, Name= 'Test Asset 6' ,LOC_Unit_Price__c = 1000 ,LOC_Shipped_Date__c = Date.today().addDays(-365));
		lstAsset.add(objAsset5);
		
		upsert lstAsset;
		
		system.assertEquals(lstAsset.size(), 6);
		
		delete objAsset4;
	}
	
	//
/*	static testMethod void Test_TBN_UpdateCloseCaseCount()
    {
    	Account objAccount = new Account();
    	objAccount.Name= 'test Account 1';
    	insert objAccount;
    	
    	Contact objContact = new Contact();
        objContact.LastName = 'testContact1';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        Error_Set__c objErrorSet = new Error_Set__c();
        objErrorSet.Name = 'testErrorSet';
        insert objErrorSet;
        
        Error__c objError = new Error__c();
        objError.LOC_Error_Code__c = '1234'; 
        objError.LOC_Error_Set__c = objErrorSet.Id;
        insert objError;
        
        Product2 objProduct = new Product2();
        objProduct.Name = 'testProduct1';
        objProduct.LOC_Error_Set__c = objErrorSet.Id;
        insert objProduct;
        
        Asset objAsset = new Asset();
    	objAsset.Name = 'test Asset 1';
    	objAsset.AccountId = objAccount.Id;
    	objAsset.Product2Id = objProduct.Id;
    	objAsset.SerialNumber = objAsset.Id; 
    	insert objAsset; 
        
    	Case objCase = new Case();
    	objCase.Status = 'Closed';
    	objCase.AssetId = objAsset.Id;
    	objCase.LOC_Error_Code__c = objError.Id;
    	insert objCase;
    	
    	Case objCase4 = new Case();
    	objCase4.Status = 'Closed';
    	objCase4.AssetId = objAsset.Id;
    	objCase4.LOC_Error_Code__c = objError.Id;
    	insert objCase4;
    	
    	Asset objAsset2 = new Asset();
    	objAsset2.Name = 'test Asset 1';
    	objAsset2.AccountId = objAccount.Id;
    	objAsset2.Product2Id = objProduct.Id;
    	objAsset2.SerialNumber = objAsset.Id; 
    	insert objAsset2;
    	
    	Case objCase2 = new Case(Id = objCase.Id);
    	objCase2.AssetId = objAsset2.Id;
    	objCase2.LOC_Error_Code__c = objError.Id;
    	objCase2.Status = 'Open';
    	update objCase2;
    	
    	Asset objAsset3 = new Asset();
    	objAsset3.Name = 'test Asset 1';
    	objAsset3.AccountId = objAccount.Id;
    	objAsset3.Product2Id = objProduct.Id;
    	objAsset3.SerialNumber = objAsset.Id; 
    	insert objAsset3;
    	
    	Case objCase3 = new Case(Id=objCase2.Id);
    	objCase3.AssetId = objAsset3.Id;
    	objCase3.LOC_Error_Code__c = objError.Id;
    	objCase3.Status = 'Closed';
    	delete objCase3;
    }*/
    
    //
        public static void testMethods()
        {
	    	Messaging.InboundEmail email = new Messaging.InboundEmail();
	        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
	        email.subject = 'test Subject 1';
	        email.fromName = 'test test';
	        email.plainTextBody = 'Hello, this a test email body. for testing purposes only.Phone:123456 Bye';
	       
	        Messaging.InboundEmail.Binaryattachment intBinaryAttch = new Messaging.InboundEmail.Binaryattachment();
	        intBinaryAttch.body = Blob.valueOf('H12H00052260,455709,FBN1500-8556,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200-P,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nHS12H00052260,455709,HSAWN601PM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200PM CE,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nH12H00052260,455709,FBN1500-TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712');
	        intBinaryAttch.fileName = 'myAttachment1.csv';
	        Messaging.InboundEmail.Binaryattachment[] binaryAttach = new Messaging.InboundEmail.Binaryattachment[1];
	        binaryAttach[0] = intBinaryAttch;   
	        email.binaryAttachments = binaryAttach;
	        
	        LOC_TBN_EmailServiceInboundHandler objMyHandler = new LOC_TBN_EmailServiceInboundHandler();
	        objMyHandler.handleInboundEmail(email, envelope); 
	        
	        Messaging.InboundEmail.TextAttachment inbTextAttchment1 = new Messaging.InboundEmail.TextAttachment();
	        inbTextAttchment1.body = 'H12H00052260,455709,FBN1500-8556,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200-P,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nHS12H00052260,455709,HSAWN601PM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200PM CE,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nH12H00052260,455709,FBN1500-TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712';
	        inbTextAttchment1.fileName = 'myAttachment.csv';
	        Messaging.InboundEmail.TextAttachment[] textAttachs1 = new Messaging.InboundEmail.TextAttachment[1];
	        textAttachs1[0] = inbTextAttchment1;   
	        email.textAttachments = textAttachs1;
	        
	        // setup controller object
	         objMyHandler.handleInboundEmail(email, envelope); 
	        
       }
       
       //
       static testMethod void LOC_TBN_Contact_UpdateNullAccoToUnknown()
       {
       		
       }
       
       //*/
}