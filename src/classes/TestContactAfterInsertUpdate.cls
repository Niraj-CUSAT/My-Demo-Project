@isTest
private class TestContactAfterInsertUpdate {
	
	static testMethod void trContactInsertUpdateTest() 
	{
		Contact obj = new Contact();
		
		obj.LastName = 'TestLastName';
		obj.LeadSource = 'Web';
		obj.Serial_Number_from_Web_Site_Registration__c = '12345';
		obj.Phone = '999999989';
		insert obj;
		 
		obj.LastName = 'TestLastName2';
		update obj;
		
		delete obj;
	}

}