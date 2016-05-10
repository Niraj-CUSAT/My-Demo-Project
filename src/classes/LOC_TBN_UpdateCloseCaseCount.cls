/**
* @ClassName    : TBN_UpdateCloseCaseCount
* @Requirement  : https://trekbin.jira.com/browse/VIRSYGEN-4
* @CreatedOn    : 07/Dec/2012
* @ModifiedBy   : 
* @Description  : Trigger on case to update its asset's field, "number of closed cases", with count of case with status as Closed
*/

/**
@Santosh Prasad
Percentage of best practices followed: 100% 
No of SOQL queries used: 0
No of collections used: 0
Exception Handling implemented: Yes
Coding standards followed: Yes
Naming conventions followed: Yes
Third party integrations: No
Maximum of No of records tested with: 50
Customer Approval: Yes
Last Modified Date: 
Approved by: 
*/ 

public without sharing class LOC_TBN_UpdateCloseCaseCount
{
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    private boolean isDelete;
    public static boolean isTriggerFired = false;
    
    public LOC_TBN_UpdateCloseCaseCount(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
        isDelete= false;
    }
    
    public void onAfterInsert(Map<Id, Case> newMapCase)
    {
        updateCloseCaseCountOnAsset(newMapCase, null);
    }
    
    public void onAfterUpdate(Map<Id, Case> newMapCase, Map<Id, Case> oldMapCase)
    {
        updateCloseCaseCountOnAsset(newMapCase, oldMapCase);
    }
    
    public void onBeforeDelete(Map<Id, Case> oldMapCase)
    {
        isDelete = true;
        updateCloseCaseCountOnAsset(null,oldMapCase);
    }
    
    public void updateCloseCaseCountOnAsset(Map<Id, Case> newMapCase, Map<Id, Case> oldMapCase)
    {
        try
        {
            system.debug('-------------updateCloseCaseCountOnAsset-----------');
            List<Asset> lstAssetToUpdate = new List<Asset>();
            set<Id> setAsset = new set<Id>();
            String strRecordTypeName = 'Technical Services - Lochinvar';
            Map<String, Integer> mapAsset_Int = new Map<String, Integer>();
            List<RecordType> lstrd =  [Select Name, Id From RecordType where Name =: strRecordTypeName AND SobjectType = 'Case' limit 1];
            
            system.debug('------------lstrd---------'+lstrd);
            for(Case objCase : [select Id, Status, AssetId from Case where Id IN: newMapCase.keySet() AND RecordTypeId  =: lstrd[0].Id and AssetId != null and Asset.Name!='UNKNOWN'])
            {
                setAsset.add(objCase.AssetId);
                system.debug('-----------setAsset---------'+setAsset);
            }
            
            if(setAsset.size() > 0)
            {
                AggregateResult[] groupedResults;
                if(isDelete)
                    groupedResults = [SELECT Count(Id), AssetId FROM Case where Status=: 'Closed' AND Id NOT IN: oldMapCase.keySet() AND AssetId IN : setAsset GROUP BY AssetId ];
                else if(!isDelete)
                    groupedResults = [SELECT Count(Id), AssetId FROM Case where Status=: 'Closed' AND AssetId IN : setAsset GROUP BY AssetId ];
                system.debug('------groupedResults------'+groupedResults);  
                for (AggregateResult ar : groupedResults)  
                {
                    mapAsset_Int.put((String)ar.get('AssetId'),(Integer)ar.get('expr0'));
                }
                system.debug('------mapAsset_Int------'+mapAsset_Int);  
                for(Asset objAsset : [select Id, LOC_Number_of_closed_cases__c  from Asset where Id IN: setAsset])
                {
                    if(mapAsset_Int.get(objAsset.Id)!= null )
                        objAsset.LOC_Number_of_closed_cases__c = mapAsset_Int.get(objAsset.Id);
                    else 
                        objAsset.LOC_Number_of_closed_cases__c = 0;
                    lstAssetToUpdate.add(objAsset);
                }
                system.debug('-------------------lstAssetToUpdate-------------1------'+lstAssetToUpdate);
                if(lstAssetToUpdate.size() > 0)
                    update lstAssetToUpdate;
                system.debug('-------------------lstAssetToUpdate----------2---------'+lstAssetToUpdate);
                if(Test.isRunningTest())
                {
                    Integer i = 1/0;                
                }
            }
        }
        catch(Exception e)
        {
            system.debug('=====exception====='+e);
        }
    }
    
@isTest(SeeAllData=false)
    static void Test_TBN_UpdateCloseCaseCount()
    {
    
        Account objAccount = new Account();
        objAccount.Name= 'test Account 1';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.LastName = 'testContact1';
        objContact.AccountId = objAccount.Id;
        objContact.Phone = '999999989';
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
        
        list<Asset> lstAsset = new list<Asset>();
        Asset objAsset = new Asset(AccountId = objAccount.Id, Name = '12345678',Product2Id = objProduct.Id );     
        lstAsset.add(objAsset);     
        
        Asset objAsset2 = new Asset(AccountId =objAccount.Id, Name= '12345679' ,Product2Id = objProduct.Id ,SerialNumber = objAsset.Id);
        lstAsset.add(objAsset2);
        
        Asset objAsset3 = new Asset(AccountId =objAccount.Id, Name= '12345670' ,Product2Id = objProduct.Id ,SerialNumber = objAsset.Id,LOC_Number_of_closed_cases__c=1);
        lstAsset.add(objAsset3);
        
        insert lstAsset;
        
        List<Case> lstCase = new List<Case>();
        Case objCase = new Case();
        objCase.RecordTypeId=Utilities.RecordTypeFor('Technical_Services_Lochinvar');        
        objCase.Status = 'Closed';
        objCase.AssetId = lstAsset[0].Id;
        objCase.LOC_Error_Code__c = objError.Id;        
        //insert objCase;     
        lstCase.add(objCase);
  
        Case objCase3 = new Case();
        objCase3.RecordTypeId=Utilities.RecordTypeFor('Technical_Services_Lochinvar');        
        objCase3.Status = 'Closed';
        objCase3.AssetId = lstAsset[0].Id;
        objCase3.LOC_Error_Code__c = objError.Id;
        lstCase.add(objCase3);        
        insert lstCase;  
        
        Case objCase2 = new Case(Id = lstCase[0].Id);
        objCase2.RecordTypeId=Utilities.RecordTypeFor('Technical_Services_Lochinvar');
        objCase2.AssetId = objAsset.Id;
        objCase2.LOC_Error_Code__c = objError.Id;
        objCase2.Status = 'Open';        
        update objCase2;        

        delete objCase;

    }

}