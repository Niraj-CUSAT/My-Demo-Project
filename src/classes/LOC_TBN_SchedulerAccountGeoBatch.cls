/**
* @ClassName    : TBN_SchedulerAccountGeoBatch
* @JIRATicket   : 
* @CreatedOn    : 9/Jan/2013
* @ModifiedBy   : 
* @Description  : This is the scheduler that runs daily to call batch TBN_BatchForAccountGeoLocationUpdate
*/

/**
@Developer Name: V kumar
Percentage of best practices followed: 100%
No of SOQL queries used: 
No of global collections used: 0
Exception Handling implemented: Yes
Coding standards followed: Yes
Naming conventions followed: Yes
Third party integrations: No
Maximum of No of records tested with: 
Customer Approval: 
Last Modified Date: 9/Jan/2013
Approved by: 
Test Coverage : 100%
*/
global class LOC_TBN_SchedulerAccountGeoBatch implements Schedulable
{

    //Call batch apex class to insert/update Account records
    global void execute(SchedulableContext ctx) 
    {
        datetime myDateTime = datetime.now(); 
		Integer myHour = myDateTime.hour();
		If(MyHour == (Integer.ValueOf(MyHour/4)) * 4)   
		{
			//scheduling batch
        	LOC_TBN_BatchForAccountGeoLocationUpdate batchObj = new LOC_TBN_BatchForAccountGeoLocationUpdate();
        	ID batchprocessid = Database.executeBatch(batchObj,8); 
		}
         
    } 
	@isTest()
    static void Test_TBN_SchedulerAssetImport()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account 1';
        objAccount.ShippingState = 'test';
		objAccount.ShippingCountry = 'USA';
		objAccount.ShippingStreet ='test' ;
		objAccount.ShippingCity = 'test';
		objAccount.ShippingPostalCode = '37338';
		objAccount.Type = 'Test';
        insert objAccount;
        
        LOC_TBN_SchedulerAccountGeoBatch objSchedulableClassAssetImport = new LOC_TBN_SchedulerAccountGeoBatch();
        String sch = '0 0 * * * ?';
        System.schedule('Test_TBN_SchedulerAccountGeoBatch', sch, new LOC_TBN_SchedulerAccountGeoBatch());
    }
}