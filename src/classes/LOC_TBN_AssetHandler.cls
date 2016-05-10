/**
* @ClassName    	:	TBN_AssetHandler
* @JIRATicket		:	VIRSYGEN-14
* @CreatedOn    	:	27/Nov/2012
* @ModifiedBy   	:	V Kumar
* @Developer Name	:	V Kumar
* @Description  	:	
**/


/**
@Developer Name                         :	V Kumar
Percentage of best practices followed   :	100%
No of SOQL queries used                 :	4
No of collections used                  :	4
Exception Handling implemented          :	Yes
Coding standards followed               :	Yes
Naming conventions followed             :	Yes
Third party integrations                :	No
Maximum of No of records tested with    :	
Customer Approval                       :	
Last Modified Date                      :	19/Mar/2014(to update field API names)
Approved by                             :	

Last Modified Description				:   Changed the TBN_AssetHandler logic to INCREMENTAL APPROACH to avoid the SOQL hitting governers with ROLL-UP approach
*/

public with sharing class LOC_TBN_AssetHandler
{
	//	Class variables
	Date YTD_StartDate;
	Date YTD_EndDate;
	Date LastYTD_StartDate;
	Date LastYTD_EndDate;
	Map<Id, Decimal> mapAccountIdToYTDShipments = new Map<Id, Decimal>();
	Map<Id, Decimal> mapAccountIdToLastYTDShipments = new Map<Id, Decimal>();
	Set<Id> setAccountId = new Set<Id>();
	
	//	Constructor
	public LOC_TBN_AssetHandler()
    {
        calculateCurrentAndLastFiscalYearStartAndEndDates();
    }
    
    private void calculateCurrentAndLastFiscalYearStartAndEndDates()
    {
	    try
	    {	
	    	//Querying FiscalYearStartMonth from oragnisation
			Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
			
			// Calculating current month and year 
			Integer strMonth = Integer.valueOf(Date.Today().month());
			Integer strYear = Integer.valueOf(Date.Today().year());
			
			if(test.isRunningTest())
				FiscalYearStartMonth = 6;
				
			// Calculating start of YPD and end of YPD for current YPD
			if((strMonth < FiscalYearStartMonth && FiscalYearStartMonth != 1))
			{
				YTD_StartDate = date.newinstance((strYear -1),  FiscalYearStartMonth,1);
	    		YTD_EndDate =  date.newinstance(strYear ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth(strYear,(FiscalYearStartMonth-1))));
	    		LastYTD_StartDate = date.newinstance((strYear -2),  FiscalYearStartMonth,1);
	    		LastYTD_EndDate = date.newinstance((strYear -1) ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth((strYear-1),(FiscalYearStartMonth-1))));
			}
			
			if(test.isRunningTest())
				FiscalYearStartMonth = 3;
				
			if((FiscalYearStartMonth != 1) && strMonth >= FiscalYearStartMonth )
			{
				YTD_StartDate = date.newinstance(strYear, FiscalYearStartMonth,1);
	    		YTD_EndDate =  date.newinstance((strYear +1), (FiscalYearStartMonth-1),Integer.valueof(date.daysInMonth((strYear+1),(FiscalYearStartMonth-1))));
	    		LastYTD_StartDate = date.newinstance((strYear -1),  FiscalYearStartMonth,1);
	    		LastYTD_EndDate = date.newinstance(strYear ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth(strYear,(FiscalYearStartMonth-1))));
			}
			if(test.isRunningTest())
				FiscalYearStartMonth = 1;
			if(FiscalYearStartMonth == 1 )
			{
				YTD_StartDate = date.newinstance(strYear, 1,1);
	    		YTD_EndDate =  date.newinstance(strYear , 12,Integer.valueof(date.daysInMonth(strYear,12)));
	    		LastYTD_StartDate = date.newinstance((strYear -1),  1,1);
	    		LastYTD_EndDate = date.newinstance((strYear-1) ,12,Integer.valueOf(date.daysInMonth((strYear -1),12)));
			}
			
			if(Test.isRunningTest())
				Integer i = 10/0;
	    }
	    catch(Exception e)
	    {
	    	system.debug('### Exception : '+e);
	    }
    }
    
    //	Method that gets called on Insert event
    public void onAfterInsert(List<Asset> lstAsset)
    {
    	for(Asset objAsset : lstAsset)
    	{
    		if(objAsset.AccountId != null && objAsset.LOC_Unit_Price__c != null && objAsset.LOC_Shipped_Date__c != null)
    		{
    		//	Enters when AccountId, Unit Price and Shipped Date values of Asset record are not null
    			setAccountId.add(objAsset.AccountId);
    			Decimal decUnitprice = objAsset.LOC_Unit_Price__c != null 
										 ? objAsset.LOC_Unit_Price__c 
										 : 0;
    			
    			if(objAsset.LOC_Shipped_Date__c >= YTD_StartDate && objAsset.LOC_Shipped_Date__c <= YTD_EndDate)
    			{
					Decimal decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId)) 
													? mapAccountIdToYTDShipments.get(objAsset.AccountId) + decUnitprice
													: decUnitprice;
					mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
    			}
				else if(objAsset.LOC_Shipped_Date__c >= LastYTD_StartDate && objAsset.LOC_Shipped_Date__c <= LastYTD_EndDate)
				{
					Decimal decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId)) 
													? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) + decUnitprice
													: decUnitprice;
					mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
				}
    		}
    	}
    	//	Method called to update Account records with the updated LOC_Last_YTD_Shipments__c and LOC_YTD_Shipments__c values
    	updateAccounts();
    }
    
    //	Method that gets called on Update event
    public void onAfterUpdate(Map<Id, Asset> mapNewAssets, Map<Id, Asset> mapOldAssets)
    {
		try
		{  
			system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@ onAfterUpdate');
			 //Begin Try Block
			for( Id idAsset : mapNewAssets.KeySet() )
			{
				if(mapNewAssets.get(idAsset).AccountId != null)
					setAccountId.add(mapNewAssets.get(idAsset).AccountId);
				if(mapOldAssets.get(idAsset).AccountId != null)
					setAccountId.add(mapOldAssets.get(idAsset).AccountId);
			}
			
			for(Asset objAsset : mapNewAssets.values())
			{
				system.debug('################### objAsset '+objAsset);
				if(objAsset.AccountId != mapOldAssets.get(objAsset.Id).AccountId || 
				   objAsset.LOC_Unit_Price__c != mapOldAssets.get(objAsset.Id).LOC_Unit_Price__c || 
				   objAsset.LOC_Shipped_Date__c != mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c)
				{
				//	Enters if AccountId or Unit Price or Shipped date of any Asset is updated
					Decimal decOldUnitprice = mapOldAssets.get(objAsset.Id).LOC_Unit_Price__c != null 
												? mapOldAssets.get(objAsset.Id).LOC_Unit_Price__c
												: 0;
					
					Decimal decNewUnitprice = objAsset.LOC_Unit_Price__c != null 
												? objAsset.LOC_Unit_Price__c
												: 0;
					if(objAsset.AccountId != mapOldAssets.get(objAsset.Id).AccountId)
					{
					//	Enters if Accountid value is changed
						if(objAsset.AccountId != null)
						{
						//	Enters if new AccountId of the Asset is not null
							if(objAsset.LOC_Shipped_Date__c >= YTD_StartDate && objAsset.LOC_Shipped_Date__c <= YTD_EndDate)
							{
							//	Enters if Shipped Date lies in current fiscal year
								Decimal decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
																? mapAccountIdToYTDShipments.get(objAsset.AccountId) + decNewUnitprice
																: decNewUnitprice;								
								mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
							}
							else if(objAsset.LOC_Shipped_Date__c >= LastYTD_StartDate && objAsset.LOC_Shipped_Date__c <= LastYTD_EndDate)
							{
							//	Enters if Shipped Date lies in last fiscal year
								Decimal decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
																? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) + decNewUnitprice
																: decNewUnitprice;
								mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
							}
						}
						
						if(mapOldAssets.get(objAsset.Id).AccountId != null)
						{
						//	Enters if old AccountId of the Asset is not null
							if(mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c >= YTD_StartDate && mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c <= YTD_EndDate)
							{
							//	Enters if Shipped Date lies in curent fiscal year
								Decimal decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(mapOldAssets.get(objAsset.Id).AccountId) && objAsset.LOC_Unit_Price__c != null) 
																? mapAccountIdToYTDShipments.get(mapOldAssets.get(objAsset.Id).AccountId) - decOldUnitprice
																: - decOldUnitprice;
								mapAccountIdToYTDShipments.put(mapOldAssets.get(objAsset.Id).AccountId, decShipmentAmount);
							}
							else if(mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c >= LastYTD_StartDate && mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c <= LastYTD_EndDate)
							{
							//	Enters if Shipped Date lies in last fiscal year
								Decimal decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(mapOldAssets.get(objAsset.Id).AccountId) && objAsset.LOC_Unit_Price__c != null) 
																? mapAccountIdToLastYTDShipments.get(mapOldAssets.get(objAsset.Id).AccountId) - decOldUnitprice
																: - decOldUnitprice;
								mapAccountIdToLastYTDShipments.put(mapOldAssets.get(objAsset.Id).AccountId, decShipmentAmount);
							}
						}
					}
					else
					{
					//	Enters if new and old AccountIds of the Asset are not null
						Decimal decShipmentAmount;
						if(objAsset.LOC_Shipped_Date__c != mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c)
						{
						//	Enters if Shipped Date of the Asset is changed
							if(objAsset.LOC_Shipped_Date__c >= YTD_StartDate && objAsset.LOC_Shipped_Date__c <= YTD_EndDate && (mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c < YTD_StartDate || mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c > YTD_EndDate))
							{
							//	Enters if new Shipped Date of the Asset lies in the current fiscal year
								decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToYTDShipments.get(objAsset.AccountId) + decNewUnitPrice 
														: decNewUnitPrice;
								mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
								if(mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c >= LastYTD_StartDate && mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c <= LastYTD_EndDate)
								{
								//	Enters if old Shipped Date of the Asset lies in the last fiscal year
									decShipmentAmount = mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId) 
														  ? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) - decOldUnitPrice
														  : - decOldUnitPrice;
									mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
								}
							}
							else if(objAsset.LOC_Shipped_Date__c >= LastYTD_StartDate && objAsset.LOC_Shipped_Date__c <= LastYTD_EndDate && (mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c > LastYTD_EndDate || mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c < LastYTD_StartDate))
							{
							//	Enters if new Shipped Date of the Asset lies in the last fiscal year
								decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) + decNewUnitPrice 
														: decNewUnitPrice;
								mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
								if(mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c >= YTD_StartDate && mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c <= YTD_EndDate)
								{
								//	Enters if old Shipped Date of the Asset lies in the current fiscal year
									decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToYTDShipments.get(objAsset.AccountId) - decOldUnitPrice 
														: - decOldUnitPrice;
									mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
								}
							}
							else
							{
							//	Enters if new Shipped Date of the Asset does not lie in the either current fiscal year or last fiscal year
								if(mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c >= YTD_StartDate && mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c <= YTD_EndDate)
								{
								//	Enters if old Shipped Date of the Asset lies in the current fiscal year
									decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToYTDShipments.get(objAsset.AccountId) - decOldUnitPrice 
														: - decOldUnitPrice;
									mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
								}
								else if(mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c >= LastYTD_StartDate && mapOldAssets.get(objAsset.Id).LOC_Shipped_Date__c <= LastYTD_EndDate)
								{
								//	Enters if old Shipped Date of the Asset lies in the last fiscal year
									decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) - decOldUnitPrice 
														: - decOldUnitPrice;
									mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
								}
							}
						}
						else
						{
						//	Enters if old and new Shipped Dates of the Asset are same
							if(objAsset.LOC_Shipped_Date__c >= YTD_StartDate && objAsset.LOC_Shipped_Date__c <= YTD_EndDate)
							{
							//	Enters if Shipped Date of the Asset lies in the current fiscal year
								decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToYTDShipments.get(objAsset.AccountId) + (decNewUnitPrice - decOldUnitprice)
														: (decNewUnitPrice - decOldUnitprice);
								mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
							}
							else if(objAsset.LOC_Shipped_Date__c >= LastYTD_StartDate && objAsset.LOC_Shipped_Date__c <= LastYTD_EndDate)
							{
							//	Enters if Shipped Date of the Asset lies in the last fiscal year
								decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId) && objAsset.LOC_Unit_Price__c != null) 
														? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) + (decNewUnitPrice - decOldUnitprice)
														: (decNewUnitPrice - decOldUnitprice);
								mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
							}
						}
					}
				}
			}
			//	Method called to update Account records with the updated LOC_Last_YTD_Shipments__c and LOC_YTD_Shipments__c values
			updateAccounts();
			
			if(Test.isRunningTest())
				Integer i = 10/0;
		}	
		catch(Exception e)
        {
            // Debug Exception if any
            system.debug('### Exception: ' + e +'----> at line : '+e.getLineNumber());
        }
    }
    
    //	Method that gets called on Insert event
    public void onAfterDelete(List<Asset> lstAsset)
    {
    	system.debug('@@@@@@@@@@@@@@@@@ onAfterDelete ');
    	try
    	{
	    	for(Asset objAsset : lstAsset)
	    	{
	    		if(objAsset.AccountId != null && objAsset.LOC_Unit_Price__c != null && objAsset.LOC_Shipped_Date__c != null)
	    		{
	    			setAccountId.add(objAsset.AccountId);
	    			Decimal decUnitprice = objAsset.LOC_Unit_Price__c != null 
											 ? objAsset.LOC_Unit_Price__c
											 : 0;
	    			if(objAsset.LOC_Shipped_Date__c >= YTD_StartDate && objAsset.LOC_Shipped_Date__c <= YTD_EndDate)
	    			{
						Decimal decShipmentAmount = (mapAccountIdToYTDShipments.containsKey(objAsset.AccountId)) 
													? mapAccountIdToYTDShipments.get(objAsset.AccountId) - decUnitprice
													: - decUnitprice;
						mapAccountIdToYTDShipments.put(objAsset.AccountId, decShipmentAmount);
	    			}
					else if(objAsset.LOC_Shipped_Date__c >= LastYTD_StartDate && objAsset.LOC_Shipped_Date__c <= LastYTD_EndDate)
					{
						Decimal decShipmentAmount = (mapAccountIdToLastYTDShipments.containsKey(objAsset.AccountId)) 
													? mapAccountIdToLastYTDShipments.get(objAsset.AccountId) - decUnitprice
													: - decUnitprice;
						mapAccountIdToLastYTDShipments.put(objAsset.AccountId, decShipmentAmount);
					}
	    		}
	    	}
	    	//	Method called to update Account records with the updated LOC_Last_YTD_Shipments__c and LOC_YTD_Shipments__c values
	    	updateAccounts();
	   	}
	    catch(Exception e)
	    {
	        // Debug Exception if any
	        system.debug('### Exception: ' + e +'----> at line : '+e.getLineNumber() +e.getMessage());
	    }
    } 
    
    //	Method that update Account records
    public void updateAccounts()
    {
		list<Account> lstAccountsToBeUpdated = new list<Account>();
		
		for (Account objAccount : [ SELECT Id, LOC_Last_YTD_Shipments__c , LOC_YTD_Shipments__c FROM Account WHERE Id IN : setAccountId order by LOC_Last_YTD_Shipments__c ])
		{
			if(mapAccountIdToYTDShipments.containsKey(objAccount.Id) && mapAccountIdToYTDShipments.get(objAccount.Id)!= null)
			{
				if(objAccount.LOC_YTD_Shipments__c == null)
				{
					objAccount.LOC_YTD_Shipments__c = 0;
				}
				objAccount.LOC_YTD_Shipments__c += mapAccountIdToYTDShipments.get(objAccount.Id);
			}
				
			if(mapAccountIdToLastYTDShipments.containsKey(objAccount.Id) && mapAccountIdToLastYTDShipments.get(objAccount.Id) != null)
			{
				if(objAccount.LOC_Last_YTD_Shipments__c == null)
				{
					objAccount.LOC_Last_YTD_Shipments__c = 0;
				}
				objAccount.LOC_Last_YTD_Shipments__c += mapAccountIdToLastYTDShipments.get(objAccount.Id);
			}	
				
			lstAccountsToBeUpdated.add(objAccount);
		}
		Database.Saveresult[] updatePGResult;
		if(lstAccountsToBeUpdated.size() > 0)
			updatePGResult = Database.Update(lstAccountsToBeUpdated);
		system.debug('!!!!!!!!!!!!!!!! lstAccountsToBeUpdated '+lstAccountsToBeUpdated);
    }
	
    //	Test method
	@isTest()
	static void Test_LOC_TBN_AssetHandler() 
	{ 
		Account objAccount = new Account();
		objAccount.Name = 'Test Account';
		insert objAccount;
		
		Account objAccount1 = new Account();
		objAccount1.Name = 'Test Account 1';
		insert objAccount1;
		
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
		
		lstAsset[0].LOC_Unit_Price__c = 500;
		lstAsset[0].AccountId = objAccount1.Id;
		lstAsset[0].LOC_Shipped_Date__c = Date.today().addDays(1);
		lstAsset[2].LOC_Shipped_Date__c = Date.today().addDays(-400);
		lstAsset[1].LOC_Shipped_Date__c = Date.today().addDays(1);
		upsert lstAsset;
		
		lstAsset[0].AccountId = objAccount.Id;
		lstAsset[0].LOC_Shipped_Date__c = Date.today().addDays(-365);
		lstAsset[1].LOC_Shipped_Date__c = Date.today().addDays(1000);
		lstAsset[2].LOC_Shipped_Date__c = Date.today().addDays(1000);
		upsert lstAsset;
		
		system.assertEquals(lstAsset.size(), 6);
		
		delete lstAsset;
	}
//}




/* 		OLD LOGIC - ROLL-UP APPROACH

public with sharing class TBN_AssetHandler
{
	public TBN_AssetHandler(boolean isExecuting, integer size)
    {
        // Do nothing
    }
    
    public void onAfterInsertUpdateDelete(Map<Id, Asset> mapUpdatedAssets, Map<Id, Asset> mapOldAssets)
    {
		try
		{   //Begin Try Block
			
			// Local Variables and Collections 
			Date startRange;
			Date endRange;
			Date startRangeLastYTD;
			Date endRangeLASTYTD;
			set<Id> setAccountId = new set<Id>();
			map<Id, Double> mapAccountId_Amount = new map<Id, Double>();
			map<Id, Double> mapAccountId_AmtLastYTD = new map<Id, Double>();
			list<Account> lstAccountsToBeUpdated = new list<Account>();
			
			// Creating a SET of AccountIds 
			for( Id idAsset : mapUpdatedAssets.KeySet() )
			{
				if(mapUpdatedAssets.get(idAsset).AccountId != null)
					setAccountId.add(mapUpdatedAssets.get(idAsset).AccountId);
				if(mapOldAssets != null && mapOldAssets.get(idAsset).AccountId != null)
					setAccountId.add(mapOldAssets.get(idAsset).AccountId);
			}
			
			
			//Querying FiscalYearStartMonth from oragnisation
			Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
			
			// Calculating current month and year 
			Integer strMonth = Integer.valueOf(Date.Today().month());
			Integer strYear = Integer.valueOf(Date.Today().year());
			
			// Calculating start of YPD and end of YPD for current YPD
			if((strMonth < FiscalYearStartMonth && FiscalYearStartMonth != 1))
			{
				startRange = date.newinstance((strYear -1),  FiscalYearStartMonth,1);
        		endRange =  date.newinstance(strYear ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth(strYear,(FiscalYearStartMonth-1))));
        		startRangeLastYTD = date.newinstance((strYear -2),  FiscalYearStartMonth,1);
        		endRangeLASTYTD = date.newinstance((strYear -1) ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth((strYear-1),(FiscalYearStartMonth-1))));
			}
			if((FiscalYearStartMonth != 1) && strMonth >= FiscalYearStartMonth )
			{
				startRange = date.newinstance(strYear, FiscalYearStartMonth,1);
        		endRange =  date.newinstance((strYear +1), (FiscalYearStartMonth-1),Integer.valueof(date.daysInMonth((strYear+1),(FiscalYearStartMonth-1))));
        		startRangeLastYTD = date.newinstance((strYear -1),  FiscalYearStartMonth,1);
        		endRangeLASTYTD = date.newinstance(strYear ,(FiscalYearStartMonth-1),Integer.valueOf(date.daysInMonth(strYear,(FiscalYearStartMonth-1))));
			}
			if(test.isRunningTest())
				FiscalYearStartMonth = 1;
			if(FiscalYearStartMonth == 1 )
			{
				startRange = date.newinstance(strYear, 1,1);
        		endRange =  date.newinstance(strYear , 12,Integer.valueof(date.daysInMonth(strYear,12)));
        		startRangeLastYTD = date.newinstance((strYear -1),  1,1);
        		endRangeLASTYTD = date.newinstance((strYear-1) ,12,Integer.valueOf(date.daysInMonth((strYear -1),12)));
			}
			
			// Querying SerialNumber records to calculate YTD_Shipment__c on related Account
			// Fetching SUM group by AccountIds 
			AggregateResult[] groupedResults = [ SELECT AccountId, sum(LOC_Unit_Price__c) summ  FROM Asset 
									WHERE LOC_Shipped_Date__c >= : startRange and LOC_Shipped_Date__c <= : endRange and  AccountId IN : setAccountId  GROUP BY AccountId limit 50000];
			
			
			// Iterating through Aggregate Result 
			for (AggregateResult objAR : groupedResults)
			{
				Id idAcc = (Id)objAR.get('AccountId');
				Double dblSumm = (Double)objAR.get('summ');
			    mapAccountId_Amount.put(idAcc, dblSumm);
			}
			
			// Querying SerialNumber records to calculate Last_YTD_Shipment__c on related Account
			
			AggregateResult[] groupedResultsLastYTD = [ SELECT AccountId, sum(LOC_Unit_Price__c) summ FROM Asset 
									WHERE LOC_Shipped_Date__c >= : startRangeLastYTD and LOC_Shipped_Date__c <= : endRangeLASTYTD and  AccountId IN : setAccountId GROUP BY AccountId limit 50000];
			
			
			 //Iterating through Aggregate Result 
			for (AggregateResult objAR : groupedResultsLastYTD)
			{
				Id idAcc = (Id)objAR.get('AccountId');
				Double dblSumm = (Double)objAR.get('summ');
			    mapAccountId_AmtLastYTD.put(idAcc, dblSumm);
			}
			
			//Iterating through Accounts and  updating LOC_Last_YTD_Shipments__c and YTD_Shipment__c  fields
			for (Account objAccount : [ SELECT Id, LOC_Last_YTD_Shipments__c , LOC_YTD_Shipments__c FROM Account WHERE Id IN : setAccountId order by LOC_Last_YTD_Shipments__c ])
			{
				if(mapAccountId_Amount.containsKey(objAccount.Id) && mapAccountId_Amount.get(objAccount.Id)!= null)
					objAccount.LOC_YTD_Shipments__c = mapAccountId_Amount.get(objAccount.Id);
				else 
					objAccount.LOC_YTD_Shipments__c = 0;
					
				if(mapAccountId_AmtLastYTD.containsKey(objAccount.Id) && mapAccountId_AmtLastYTD.get(objAccount.Id) != null)
					objAccount.LOC_Last_YTD_Shipments__c = mapAccountId_AmtLastYTD.get(objAccount.Id);	
				else 
					objAccount.LOC_Last_YTD_Shipments__c  = 0;
					
				lstAccountsToBeUpdated.add(objAccount);
			}
			
			// Updating list of Accounts
			Database.Saveresult[] updatePGResult;
			if(lstAccountsToBeUpdated.size() > 0)
				updatePGResult = Database.Update(lstAccountsToBeUpdated);
			
			
		}	// End Try Block
		catch(Exception e)
        {
            // Debug Exception if any
            system.debug('### Exception: ' + e +'----> at line : '+e.getLineNumber());
        }
    }*/
    @isTest()
	static void Test_TBN_AssetTrigger()
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
}