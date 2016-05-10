/**
* @ClassName    : TBN_RenderAsExcelAssetImportController 
* @JIRATicket   : 
* @CreatedOn    : 03/Dec/2012
* @ModifiedBy   : 
* @Description  : This is the controller for component created for sending error log emails.
*/

/**
@Developer Name: Santosh
Percentage of best practices followed: 100%
No of SOQL queries used: 
No of global collections used: 2
Exception Handling implemented: Yes
Coding standards followed: Yes
Naming conventions followed: Yes
Third party integrations: No
Maximum of No of records tested with: 5300
Customer Approval: Yes
Last Modified Date: 07/Feb/2012
Approved by: 
Test Coverage : 89%

**/

public with sharing class LOC_TBN_RenderAsExcelAssetImportCntrl 
{
    public List<AssetImportErrorLog__c> lstAssetImportErrorLog {get;set;}
    public Map<Id, AssetImportErrorLog__c> mapMainAssetImportLog {get;set;}
    
    
    public LOC_TBN_RenderAsExcelAssetImportCntrl()
    {
        try
        { 
            mapMainAssetImportLog = new Map<Id, AssetImportErrorLog__c>();
            /*Limiting to 9900 since there is a limit of 10,000 and hence the list wont bind*/
            lstAssetImportErrorLog = [select Id, CSVLogData__c,Reason_of_failure__c from AssetImportErrorLog__c limit 9900];
            for(AssetImportErrorLog__c objAssetImportLog : lstAssetImportErrorLog) 
            {
                  mapMainAssetImportLog.put(objAssetImportLog.Id, objAssetImportLog);
            }
            
        }
        catch(Exception e)
        {
            system.debug('====Exception==='+e.getMessage()+'=====at line number======'+e.getLineNumber());
        }
    }
    
  @isTest
    static void testRenderAsExcelAssetImportController()
    {
        AssetImportErrorLog__c objAssetImportErrorLog = new AssetImportErrorLog__c();
        objAssetImportErrorLog.CSVLogData__c = 'testCSVLogData';
        insert objAssetImportErrorLog;
        LOC_TBN_RenderAsExcelAssetImportCntrl objAssetImportLog = new LOC_TBN_RenderAsExcelAssetImportCntrl();
    }
}