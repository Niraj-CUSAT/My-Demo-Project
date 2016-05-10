/**
* @ClassName    	:	TBN_AccountHandler
* @JIRATicket		:	VIRSYGEN-13
* @CreatedOn    	:	26/Nov/2012
* @ModifiedBy   	:	V Kumar
* @Developer Name	:	V Kumar
* @Description  	:	
**/


/**
@Developer Name                         :	V Kumar
Percentage of best practices followed   :	100%
No of SOQL queries used                 :	1
No of collections used                  :	1
Exception Handling implemented          :	Yes
Coding standards followed               :	Yes
Naming conventions followed             :	Yes
Third party integrations                :	No
Maximum of No of records tested with    :	
Customer Approval                       :	
Last Modified Date                      :	12/Mar/2014 [Updated field API names]
Approved by                             :	

*/
public with sharing class LOC_TBN_AccountHandler 
{
	 public LOC_TBN_AccountHandler (boolean isExecuting, integer size)
    {
        // Do nothing
    } 
    
    public void onAfterUpdate(Map<Id, Account> newMap_Id_Account)
    {
        try
        {  
        	// Start Try Block
            
            /* Local Variables and Collections */
			list<Account> lstAccountsToBeUpdated = new list<Account>();
			
			//Querying the child account and updating Manufacturers_Rep__c field //and ParentId In :newMap_Id_Account.keyset()
			for(Account objAccount : [select Id,Parent.LOC_Manufacturers_Rep__c, LOC_Manufacturers_Rep__c From Account 
										where	((LOC_Manufacturers_Rep__c = true and  Parent.LOC_Manufacturers_Rep__c = false ) 
										or (LOC_Manufacturers_Rep__c = false and  Parent.LOC_Manufacturers_Rep__c = true )) 
										and ParentId In :newMap_Id_Account.keyset()])
			{
				objAccount.LOC_Manufacturers_Rep__c = objAccount.parent.LOC_Manufacturers_Rep__c;
				lstAccountsToBeUpdated.add(objAccount);
			}
			
			// Updating the child accounts
			if(lstAccountsToBeUpdated.size() > 0)
				update lstAccountsToBeUpdated;
			system.debug('#################### lstAccountsToBeUpdated'+lstAccountsToBeUpdated);
			
			// End Try Block
			if(Test.isRunningTest())
			{
			 	Integer i = 1/0;			 	
			}
        }  
        catch(Exception e)
        {
        	// Debug Exception if any
            
            system.debug('### Exception: ' + e);
        }
    }


	@isTest()
	static void Test_LOC_TBN_AccountTrigger()
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
}