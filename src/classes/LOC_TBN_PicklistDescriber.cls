/***** The method on this controller is called from "TBN_MapDistributor" page"*****/
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
public class LOC_TBN_PicklistDescriber
{
	static final Pattern OPTION_PATTERN = Pattern.compile('<option.+?>(.+?)</option>'); 
	
	/**Describe a picklist field for a SobjectType, its given record type developer name and the picklist field*/
	public static List<String> describe(String sobjectType, Id recordTypeId, String pickListFieldAPIName) 
	{
		return parseOptions(
						new Map<String, String>	{
													 'sobjectType' => sobjectType,
													 'recordTypeId' => recordTypeId,
													 'pickListFieldName'=> pickListFieldAPIName
												}
		);
	}
	
	/*	Internal method to parse the OPTIONS*/
	
	static List<String> parseOptions(Map<String, String> params) 
	{
		Pagereference pr = Page.LOC_TBN_PicklistDescriber;
		// to handle development mode, if ON
		pr.getParameters().put('core.apexpages.devmode.url', '1');
		
		for (String key : params.keySet()) 
		{
			pr.getParameters().put(key, params.get(key));	
		}
		List<String> options = new List<String>();
		String xmlContent ='';
		if(Test.IsrunningTest())
		{
			xmlContent = '<form id="j_id0:j_id1" name="j_id0:j_id1" method="post" action="/apex/tbn_picklistdesc" enctype="application/x-www-form-urlencoded">'+
			'<select  id="j_id0:j_id1:j_id2" name="j_id0:j_id1:j_id2"><option value="">--None--</option><option value="Installer" selected="selected">Installer</option>'+
			'</select>'+
			'</form>';
		}
		else
		xmlContent = pr.getContent().toString();
		Matcher mchr = OPTION_PATTERN.matcher(xmlContent);
		
		while(mchr.find()) 
		{
			options.add(mchr.group(1));
		} 
		// remove the --None-- element
		if (!options.isEmpty()) 
			options.remove(0);
		return options;
	}
	@isTest()
	static void Test_LOC_TBN_PickListDescController()
	{
		list<RecordType> lstRecType = [select Id from RecordType where  SobjectType='Account' limit 1];
		if(lstRecType.size() >0)
			ApexPages.currentPage().getParameters().put('recordTypeId',lstRecType[0].Id);
		else
			ApexPages.currentPage().getParameters().put('recordTypeId','');
		ApexPages.currentPage().getParameters().put('sobjectType','Account');
		//ApexPages.currentSSPage().getParameters().put('picklistFieldName','Type');
		LOC_TBN_PickListDescriber.describe('Account',lstRecType[0].Id,'Type');
	}
}