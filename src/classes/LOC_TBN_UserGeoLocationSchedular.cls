/**
* @ClassName    : TBN_UserGeoLocationSchedular
* @JIRATicket   : 
* @CreatedOn    : 9/Jan/2013
* @ModifiedBy   : 
* @Description  : This is the scheduler that runs daily to call batch TBN_BatchForUserToUpdateGeoFields
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

global class LOC_TBN_UserGeoLocationSchedular implements Schedulable
{
	 //Call batch apex class to insert/update asset records
    global void execute(SchedulableContext ctx) 
    {
        
        //scheduling batch
        LOC_TBN_BatchForUserToUpdateGeoFields batchObj = new LOC_TBN_BatchForUserToUpdateGeoFields();
        ID batchprocessid = Database.executeBatch(batchObj,4);  
		
    } 
    @isTest()
    static void Test_LOC_TBN_UserGeoLocationSchedular() 
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account 1';
        insert objAccount;
        
       LOC_TBN_UserGeoLocationSchedular objSchedulableClassAssetImport = new LOC_TBN_UserGeoLocationSchedular();
        String sch = '0 0 * * * ?';
        System.schedule('Test_TBN_UserGeoLocationSchedular', sch, new LOC_TBN_UserGeoLocationSchedular());
    }
}