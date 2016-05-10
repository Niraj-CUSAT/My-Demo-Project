trigger LOC_TBN_SystemGuideUpdate on Case (before insert, before update) 
{
    private static final String LOCHINVAR_RECORDTYPE = 'Technical Services - Lochinvar';
    private Boolean isExecute = false;
    private List<RecordType> lstRecordType;
    lstRecordType = [Select Id, SobjectType From RecordType where Name =:LOCHINVAR_RECORDTYPE limit 1];
    
     Set<Id> setErrorCode = new Set<Id>();
	 Set<Id> setAssetIds = new Set<Id>();
	 Set<Id> setProduct =  new Set<Id>();
 
    if(trigger.isUpdate)
    {//Compare to old value if isupdate, if different then update reset flag
           System.debug('------------isUpdate----------');
                            
            for (Case t:Trigger.new)
            {
                if(t.RecordTypeId == lstRecordType[0].Id)
                {
                    Case oldCase = Trigger.oldMap.get(t.ID);
                    if (t.LOC_Error_Code__c != oldCase.LOC_Error_Code__c) {//compare error codes
                        t.LOC_System_Guide_Populated__c=FALSE;}
                    //if (t.AssetID != oldCase.AssetID) {//compare assets
                        t.LOC_Product_Parameters_Populated__c=FALSE;
                        //t.LOC_Product_Parameters__c = '';//}
                       system.debug('---------- clear ob update --------'+t.LOC_Product_Parameters__c);
                }
            }
    }	

	 for (Case t:Trigger.new)   
	 {
		if(t.RecordTypeId == lstRecordType[0].Id)
	    {
			if(t.LOC_Error_Code__c != NULL && t.Type=='Error Code')
			{
				 if(!t.LOC_System_Guide_Populated__c)
	             {
					setErrorCode.add(t.LOC_Error_Code__c);
				 }
			}	  
		}
		
		if(t.AssetId != NULL && !t.LOC_Product_Parameters_Populated__c) 
		{       
			setAssetIds.add(t.AssetID);	
		}	
	 }
//below If loop added by bhanu for checking query will not run for aosi recordtype
	if(!setErrorCode.isempty() && !setAssetIds.isempty()){
	Map<Id, Error__c> mapErrorSystemGuide = new Map<Id, Error__c>([select id, LOC_system_guide__c from Error__c where id IN: setErrorCode]);
	
	Map<Id, Asset> mapAssetProductId = new Map<Id, Asset>([select id,Product2ID from Asset where id IN: setAssetIds]);
	
	for(Id ProductId : mapAssetProductId.keyset())
	{	
		setProduct.add(mapAssetProductId.get(ProductId).Product2ID);
	}
	
	Map<Id, Product2> mapProductIdDetails = new Map<Id, Product2>([select id, Vent_Size_Inches__c, LOC_Gas_Connection_Size__c, LOC_LP_Gas_Flue_CO2_Range__c, LOC_LP_Gas_Flue_CO2_Range_Valve_2__c, LOC_LP_Gas_Flue_O2_Range__c, LOC_LP_Gas_Flue_O2_Range_Valve_2__c, lMax_Flue_Temperature_Before_Modulation__c, LOC_Maximum_Air_Intake_Length__c, LOC_Maximum_CO_Levels__c, LOC_Max_Delta_T_Before_Modulation__c, LOC_Max_Delta_T_Before_Shutdown__c, LOC_Max_FlueTemperature_Before_Shutdown__c, LOC_Maximum_Supply_LP_Gas__c, LOC_Maximum_Supply_Natural_Gas__c, LOC_Maximum_TDS__c, LOC_Maximum_Vent_Length__c, lMax_Outlet_Temperature_Befor_Modulation__c, L_Max_Outlet_Temperature_Before_Shutdown__c, LOC_Minimum_Air_Intake_Length__c, LOC_Minimum_Gas_Pipe_Size_10__c, LOC_Minimum_Supply_LP_Gas__c, LOC_Minimum_Supply_Natural_Gas__c, LOC_Minimum_Vent_Length__c, LOC_Natural_Gas_Flue_CO2_Range__c, LOC_Natural_Gas_Flue_CO2_Range_Valve_2__c   , LOC_Natural_Gas_Flue_O2_Range__c, LOC_Natural_Gas_Flue_O2_Range_Valve_2__c, LOC_Water_Connection_Size_Inlet__c, LOC_Water_Connection_Size_Outlet__c, LOC_Water_Hardness__c from Product2 where id IN: setProduct]);
	
	system.debug('---------- Working --------');
	
	for (Case t:Trigger.new)
	{
		if(t.RecordTypeId == lstRecordType[0].Id)
	    {
			if(t.LOC_Error_Code__c != NULL && t.Type=='Error Code')
			{
				if(mapErrorSystemGuide.containskey(t.LOC_Error_Code__c))
				{
					t.LOC_System_Guide__c = mapErrorSystemGuide.get(t.LOC_Error_Code__c).LOC_system_guide__c;			
					t.LOC_System_Guide_Populated__c=TRUE;
				}
			}		
		}
		
		if(t.AssetId != NULL && !t.LOC_Product_Parameters_Populated__c)
		{
			if(mapAssetProductId.containskey(t.AssetID))
			{
				Asset objAsset = mapAssetProductId.get(t.AssetID);
				if(objAsset.Product2ID == null)
				{
					t.LOC_Product_Parameters__c = '';
					t.LOC_System_Guide__c= '';				
				}
				else
				{			
					Product2 objProduct2 = mapProductIdDetails.get(objAsset.Product2ID);	
					if(objProduct2.Vent_Size_Inches__c != NULL)t.LOC_Product_Parameters__c = 'Air/Vent Pipe Size: ' + objProduct2.Vent_Size_Inches__c + '\n';  
	                            
					if(objProduct2.LOC_Gas_Connection_Size__c != NULL)t.LOC_Product_Parameters__c =  + 'Gas Connection Size: ' + objProduct2.LOC_Gas_Connection_Size__c + '\n';
					
					if(objProduct2.LOC_Water_Connection_Size_Inlet__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Water Connection Size - Inlet: ' + objProduct2.LOC_Water_Connection_Size_Inlet__c + '\n';
					
					if(objProduct2.LOC_Water_Connection_Size_Outlet__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Water Connection Size - Outlet: ' + objProduct2.LOC_Water_Connection_Size_Outlet__c + '\n';
					
					if(objProduct2.LOC_Minimum_Gas_Pipe_Size_10__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Minimum Gas Pipe Size (@10ft): ' + objProduct2.LOC_Minimum_Gas_Pipe_Size_10__c + '\n';  
					
					if(objProduct2.LOC_Maximum_Air_Intake_Length__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum Air Intake Length: ' + objProduct2.LOC_Maximum_Air_Intake_Length__c + '\n';    
					
					if(objProduct2.LOC_Minimum_Air_Intake_Length__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Minimum Air Intake Length: ' + objProduct2.LOC_Minimum_Air_Intake_Length__c + '\n';    
				
					if(objProduct2.LOC_Maximum_Vent_Length__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum Vent Length: ' + objProduct2.LOC_Maximum_Vent_Length__c + '\n';  
				
					if(objProduct2.LOC_Minimum_Vent_Length__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Minimum Vent Length: ' + objProduct2.LOC_Minimum_Vent_Length__c + '\n';  
					
					if(objProduct2.LOC_LP_Gas_Flue_CO2_Range__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'LP Gas Flue CO2 Range: ' + objProduct2.LOC_LP_Gas_Flue_CO2_Range__c + '\n';
					
					if(objProduct2.LOC_LP_Gas_Flue_CO2_Range_Valve_2__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'LP Gas Flue CO2 Range Valve 2: ' + objProduct2.LOC_LP_Gas_Flue_CO2_Range_Valve_2__c + '\n';
					
					if(objProduct2.LOC_LP_Gas_Flue_O2_Range__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'LP Gas Flue O2 Range: ' + objProduct2.LOC_LP_Gas_Flue_O2_Range__c + '\n';
					
					if(objProduct2.LOC_LP_Gas_Flue_O2_Range_Valve_2__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'LP Gas Flue O2 Range Valve 2: ' + objProduct2.LOC_LP_Gas_Flue_O2_Range_Valve_2__c + '\n';
					
					if(objProduct2.LOC_Natural_Gas_Flue_CO2_Range__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Natural Gas Flue CO2 Range: ' + objProduct2.LOC_Natural_Gas_Flue_CO2_Range__c + '\n';
					
					if(objProduct2.LOC_Natural_Gas_Flue_CO2_Range_Valve_2__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Natural Gas Flue CO2 Range Valve 2: ' + objProduct2.LOC_Natural_Gas_Flue_CO2_Range_Valve_2__c + '\n';
					
					if(objProduct2.LOC_Natural_Gas_Flue_O2_Range__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Natural Gas Flue O2 Range: ' + objProduct2.LOC_Natural_Gas_Flue_O2_Range__c + '\n';
					
					if(objProduct2.LOC_Natural_Gas_Flue_O2_Range_Valve_2__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Natural Gas Flue O2 Range Valve 2: ' + objProduct2.LOC_Natural_Gas_Flue_O2_Range_Valve_2__c + '\n';
					
					if(objProduct2.lMax_Flue_Temperature_Before_Modulation__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Max Flue Temperature Before Modulation: ' + objProduct2.lMax_Flue_Temperature_Before_Modulation__c + '\n'; 
					
					if(objProduct2.LOC_Max_FlueTemperature_Before_Shutdown__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Max Flue Temperature Before Shutdown: ' + objProduct2.LOC_Max_FlueTemperature_Before_Shutdown__c + '\n'; 
					
					if(objProduct2.lMax_Outlet_Temperature_Befor_Modulation__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Max Outlet Temperature Before Modulation: ' + objProduct2.lMax_Outlet_Temperature_Befor_Modulation__c + '\n';   
					
					if(objProduct2.L_Max_Outlet_Temperature_Before_Shutdown__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Max Outlet Temperature Before Shutdownh: ' + objProduct2.L_Max_Outlet_Temperature_Before_Shutdown__c + '\n';    
					
					if(objProduct2.LOC_Max_Delta_T_Before_Modulation__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum Delta T Before Modulation: ' + objProduct2.LOC_Max_Delta_T_Before_Modulation__c + '\n';
					
					if(objProduct2.LOC_Max_Delta_T_Before_Shutdown__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum Delta T Before Shutdown: ' + objProduct2.LOC_Max_Delta_T_Before_Shutdown__c + '\n';
					
					if(objProduct2.LOC_Maximum_CO_Levels__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum CO Levels: ' + objProduct2.LOC_Maximum_CO_Levels__c + '\n';
					
					if(objProduct2.LOC_Maximum_Supply_LP_Gas__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum Supply LP Gas: ' + objProduct2.LOC_Maximum_Supply_LP_Gas__c + '\n';
					
					if(objProduct2.LOC_Maximum_Supply_Natural_Gas__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum Supply Natural Gas: ' + objProduct2.LOC_Maximum_Supply_Natural_Gas__c + '\n';
					
					if(objProduct2.LOC_Minimum_Supply_LP_Gas__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Minimum Supply LP Gas: ' + objProduct2.LOC_Minimum_Supply_LP_Gas__c + '\n';
					
					if(objProduct2.LOC_Minimum_Supply_Natural_Gas__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Minimum Supply Natural Gas: ' + objProduct2.LOC_Minimum_Supply_Natural_Gas__c + '\n';
					
					if(objProduct2.LOC_Maximum_TDS__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Maximum TDS: ' + objProduct2.LOC_Maximum_TDS__c + '\n';
					
					if(objProduct2.LOC_Water_Hardness__c != NULL)t.LOC_Product_Parameters__c = t.LOC_Product_Parameters__c + 'Water Hardness: ' + objProduct2.LOC_Water_Hardness__c + '\n';
					
					t.LOC_Product_Parameters_Populated__c = TRUE;				
				}
				
			}
		}	
		
	}
	}
    //The below functionality is created for on Insert and on update Case should update with below fields.
    //Case.Serial_Number_Asset_Account__c = Case.Asset.AccountID, Case.Serial_Number_Territory__c = Case.Asset.Territory_1__c
    //JIRA task - VIRSYGEN-19
    if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            updateCaseSerialNumberAssetAccount(Trigger.new);
        }
        else if(Trigger.isUpdate)
        {
            updateCaseSerialNumberAssetAccount(Trigger.new);
        }   
    }
    
    private void updateCaseSerialNumberAssetAccount(List<Case> lstCaseNew)
    {
        Set<Id> setAssetId = new Set<Id>();
        Map<Id, Asset> mapAssetIdToAsset = new Map<Id, Asset>();
        
        for(Case objCase :  lstCaseNew)
        {
            if(objCase.RecordTypeId == lstRecordType[0].Id)
            setAssetId.add(objCase.AssetId);
        }
        //Putting Asset.AccountId, and Territory_1__c values into a Map to update Case.
        for(Asset objAsset : [Select Id, LOC_Territory_1__c, AccountId From Asset where Id IN : setAssetId])
        {
            mapAssetIdToAsset.put(objAsset.Id, objAsset);
        }
        
        for(Case objCase : lstCaseNew)
        {
            if(mapAssetIdToAsset.containsKey(objCase.AssetId))
            {
                if(mapAssetIdToAsset.get(objCase.AssetId).AccountId != null)
                    objCase.LOC_Serial_Number_Asset_Account__c = mapAssetIdToAsset.get(objCase.AssetId).AccountId;
                if(mapAssetIdToAsset.get(objCase.AssetId).LOC_Territory_1__c != null)
                    objCase.LOC_Serial_Number_Territory__c = mapAssetIdToAsset.get(objCase.AssetId).LOC_Territory_1__c;
            }
        }
        
    }
}