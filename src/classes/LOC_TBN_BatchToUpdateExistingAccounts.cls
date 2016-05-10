public with sharing class LOC_TBN_BatchToUpdateExistingAccounts implements Database.Batchable<sObject> 
{
	/*
     * Name       : LOC_TBN_BatchToUpdateExistingAccounts 
     * Description: Updates the LOC_Last_YTD_Shipments__c and LOC_YTD_Shipments__c values of Existing Account records
     *
     * Maintenance History:
     * 25-Apr-2013   - VK - 1.0 - Created  
     * 11-Mar-2014   - VK - 1.1 - Modified(Updated field API names)
	*/
	
	//	Class variables
	Date YTD_StartDate;
	Date YTD_EndDate;
	Date LastYTD_StartDate;
	Date LastYTD_EndDate;
	Map<Id, Decimal> mapAccountIdToYTDShipments = new Map<Id, Decimal>();
	Map<Id, Decimal> mapAccountIdToLastYTDShipments = new Map<Id, Decimal>();
	List<Account> lstAccountsToUpdate = new List<Account>();
	Set<Id> setAccountId = new Set<Id>();
	
	//	Constructor
	public LOC_TBN_BatchToUpdateExistingAccounts()
	{
		//	Does nothing
	}
	
	//	Start method
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {
		return Database.getQueryLocator('Select Id, AccountId, LOC_Unit_Price__c, LOC_Shipped_Date__c From Asset Where AccountId != null AND LOC_Unit_Price__c != null AND LOC_Shipped_Date__c != null');
    } 
	
	//	Execute method
    public void execute(Database.BatchableContext BC, List<Asset> lstAssets)
    {
    	
    	System.debug('######################## execute' + lstAssets);
    	//Querying FiscalYearStartMonth from oragnisation
		Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
		
		// Calculating current month and year 
		Integer strMonth = Integer.valueOf(Date.Today().month());
		Integer strYear = Integer.valueOf(Date.Today().year());
		
		// Calculating start and end dates of current and last fiscal years 
		if((strMonth < FiscalYearStartMonth && FiscalYearStartMonth != 1))
		{
			YTD_StartDate = date.newinstance((strYear -1),  FiscalYearStartMonth,1);
    		YTD_EndDate =  date.newinstance(strYear ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth(strYear,(FiscalYearStartMonth-1))));
    		LastYTD_StartDate = date.newinstance((strYear -2),  FiscalYearStartMonth,1);
    		LastYTD_EndDate = date.newinstance((strYear -1) ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth((strYear-1),(FiscalYearStartMonth-1))));
		}
		
		if((FiscalYearStartMonth != 1) && strMonth >= FiscalYearStartMonth )
		{
			YTD_StartDate = date.newinstance(strYear, FiscalYearStartMonth,1);
    		YTD_EndDate =  date.newinstance((strYear +1), (FiscalYearStartMonth-1),Integer.valueof(date.daysInMonth((strYear+1),(FiscalYearStartMonth-1))));
    		LastYTD_StartDate = date.newinstance((strYear -1),  FiscalYearStartMonth,1);
    		LastYTD_EndDate = date.newinstance(strYear ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth(strYear,(FiscalYearStartMonth-1))));
		}
		if(FiscalYearStartMonth == 1 )
		{
			YTD_StartDate = date.newinstance(strYear, 1,1);
    		YTD_EndDate =  date.newinstance(strYear , 12,Integer.valueof(date.daysInMonth(strYear,12)));
    		LastYTD_StartDate = date.newinstance((strYear -1),  1,1);
    		LastYTD_EndDate = date.newinstance((strYear-1) ,12,Integer.valueOf(date.daysInMonth((strYear -1),12)));
		}
    	
    	
    	//	Forms a map with key Account Id of the Asset and value as sum of unit prices of Assets of the Account 
    	for(Asset objAsset : lstAssets)
    	{
     		system.debug('################# objAsset.LOC_Shipped_Date__c '+objAsset.LOC_Shipped_Date__c);
     		if(objAsset.LOC_Shipped_Date__c >= YTD_StartDate && objAsset.LOC_Shipped_Date__c <= YTD_EndDate && objAsset.AccountId != null)
			{
				Decimal decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId)) 
												? mapAccountIdToYTDShipments.get(objAsset.AccountId) + objAsset.LOC_Unit_Price__c
												: objAsset.LOC_Unit_Price__c;
				mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
			}
			else if(objAsset.LOC_Shipped_Date__c >= LastYTD_StartDate && objAsset.LOC_Shipped_Date__c <= LastYTD_EndDate && objAsset.AccountId != null)
			{
				Decimal decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId)) 
												? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) + objAsset.LOC_Unit_Price__c
												: objAsset.LOC_Unit_Price__c;
				mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
			}
		}
    	for(Account objAccount : [SELECT Id, LOC_Last_YTD_Shipments__c , LOC_YTD_Shipments__c FROM Account WHERE Id IN : mapAccountIdToYTDShipments.keyset() OR Id IN : mapAccountIdToLastYTDShipments.keyset()])
    	{
    		objAccount.LOC_YTD_Shipments__c = objAccount.LOC_YTD_Shipments__c == null ? 0 :objAccount.LOC_YTD_Shipments__c;
    		objAccount.LOC_Last_YTD_Shipments__c = objAccount.LOC_Last_YTD_Shipments__c == null ? 0 : objAccount.LOC_Last_YTD_Shipments__c;
    		objAccount.LOC_YTD_Shipments__c += mapAccountIdToYTDShipments.containsKey(objAccount.Id) ? mapAccountIdToYTDShipments.get(objAccount.Id) : 0;
    		objAccount.LOC_Last_YTD_Shipments__c += mapAccountIdToLastYTDShipments.containsKey(objAccount.Id) ? mapAccountIdToLastYTDShipments.get(objAccount.Id) : 0;
    		lstAccountsToUpdate.add(objAccount);
    	}
    	system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ lstAccountsToUpdate'+ lstAccountsToUpdate);
    	update lstAccountsToUpdate;
    }
    
    //	Finish method 
    public void finish(Database.BatchableContext BC)
    {
   		//	Does nothing
    } 
    
    @isTest()
	static void Test_TBN_BatchToUpdateExistingAccounts()
	{
		Account objAccount = new Account();
        objAccount.Name = 'Test objAccount 1';       
        insert objAccount;        
        system.debug('######################## objAccount.Id ############## ::'+objAccount.Id);
		Date dt = date.today();
        Asset objAsset = new Asset();
        objAsset.Name = 'TestTest';
        objAsset.AccountId = objAccount.Id;
        objAsset.LOC_Shipped_Date__c =dt;
        objAsset.LOC_Unit_Price__c =Decimal.valueOf('100');
        insert objAsset;
        

        LOC_TBN_BatchToUpdateExistingAccounts objBatch = new LOC_TBN_BatchToUpdateExistingAccounts();        
        ID batchprocessid = Database.executeBatch(objBatch);
		
	}
}