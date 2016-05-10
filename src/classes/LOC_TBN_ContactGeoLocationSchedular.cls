/**
* @ClassName    : TBN_SchedulerAccountGeoBatch
* @JIRATicket   : 
* @CreatedOn    : 9/Jan/2013
* @ModifiedBy   : 
* @Description  : This is the scheduler that runs daily to call batch TBN_BatchForContactToUpdateGeoFields
					 which updates the geolocation fields of Contact.  
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
global class LOC_TBN_ContactGeoLocationSchedular implements Schedulable
{
	 //Call batch apex class to insert/update asset records 
    global void execute(SchedulableContext ctx) 
    {
        datetime currentDateTime = datetime.now();
		Integer currentHour = currentDateTime.hour();
		
		If(currentHour == (Integer.ValueOf(currentHour/4)) * 4)   
		{
	        //scheduling batch
	        LOC_TBN_BatchForContactToUpdateGeoFields batchObj = new LOC_TBN_BatchForContactToUpdateGeoFields();
	        ID batchprocessid = Database.executeBatch(batchObj,8);    
		}
    } 
    @isTest()
    static void Test_TBN_ContactGeoLocationSchedular()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account 1';
        insert objAccount;
        
        LOC_TBN_ContactGeoLocationSchedular objSchedulableClassAssetImport = new LOC_TBN_ContactGeoLocationSchedular();
        String sch = '0 0 * * * ?';
        System.schedule('Test_TBN_ContactGeoLocationSchedular', sch, new LOC_TBN_ContactGeoLocationSchedular());
    } 
}