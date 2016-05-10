/***** The Controller for the Page "TBN_PicklistDesc"*****/
/***
@Developer Name : V Kumar
Percentage of best practices followed : 100%
No of SOQL queries used : 0
No of collections used : 0
Exception Handling implemented : Yes
Coding standards followed : Yes
Naming conventions followed : Yes
Third party integrations :
Maximum of No of records tested with : 
Customer Approval : 
Last Modified Date: 26-12-12
Approved by:
 
@Major Change 1
JIRA Link:Virsygen-7
Short desc:
Impacted methods/areas:
Result:
Changed By:
Approved By:
**********/
public class LOC_TBN_PickListDescController 
{
    public Sobject sobj {get;set;}
    public String pickListFieldName {get;set;}        
    
    public LOC_TBN_PickListDescController() 
    {
        Map<String, String> reqParams = ApexPages.currentPage().getParameters();
        String recordTypeId = reqParams.get('recordTypeId');
        String sobjectTypeName = reqParams.get('sobjectType'); 
        this.pickListFieldName = reqParams.get('picklistFieldName'); 
        Schema.SobjectType sobjectType = null;
        
        if (sobjectTypeName != null && sobjectTypeName.trim().length() > 0) 
        {
            sobjectType = Schema.getGlobalDescribe().get(sobjectTypeName);
            // create blank sobject record
            sobj = sobjectType.newSobject();
            
            // if no recordTypeId passed explicitly by user, try loading one from the RecordType table
            if (isBlank(recordTypeId) ) 
            {
                // queryexception is fine, we don't want to return anything good for bad recordtype
                RecordType recType = [Select Id from RecordType Where SobjectType =:sobjectTypeName limit 1];
                                            
                recordTypeid = recType.id;                                            
            }
            sobj.put('RecordTypeId', recordTypeid);                                            

        } 
       
            
    }  
    
    static boolean isBlank(String val) 
    { 
        return val == null || val.trim().length() == 0;
    }
     @isTest() 
	static void Test_TBN_PickListDescController()
	{
		list<RecordType> lstRecType = [select Id from RecordType where  SobjectType='Account' limit 1];
		if(lstRecType.size() >0)
			ApexPages.currentPage().getParameters().put('recordTypeId',lstRecType[0].Id);
		else
			ApexPages.currentPage().getParameters().put('recordTypeId','');
		ApexPages.currentPage().getParameters().put('sobjectType','Account');
		ApexPages.currentPage().getParameters().put('picklistFieldName','Type');
		LOC_TBN_PickListDescController objDesc = new LOC_TBN_PickListDescController(); 
		ApexPages.currentPage().getParameters().put('recordTypeId','');
		ApexPages.currentPage().getParameters().put('sobjectType','Account');
		ApexPages.currentPage().getParameters().put('picklistFieldName','Type');
		LOC_TBN_PickListDescController objDesc1 = new LOC_TBN_PickListDescController(); 
	}
}