public with sharing class TBN_AlertConfigurationHandler 
{
	/*
     * Name       : TBN_AlertConfigurationHandler 
     * Description: Manages the custom setting records as that they store only the view ids which are associated to Alert Configurations
     *
     * Maintenance History:
     * 04/09/2013   - VK - 1.0 - Created  
	*/
	
	//	Constructor
	public TBN_AlertConfigurationHandler()
	{
		//	Does Nothing
	}
	
	//	Method called on before insert event
	public void onBeforeInsert(List<Alert_Relationship__c> lstAlertConfigurations)
	{
		//	Method variables
		Set<Id> setViewIds = new Set<Id>();
		Set<Id> setViewIdsFromCS = new Set<Id>(); 
		List<ConfiguredViewIds__c> lstConfiguredViews = new List<ConfiguredViewIds__c>(); 
		ConfiguredViewIds__c objViewConfiguration = new ConfiguredViewIds__c();
		
		//	Iterate through the custom setting values and take their view ids into a set
		for(ConfiguredViewIds__c objCS : ConfiguredViewIds__c.getAll().values())
		{
			setViewIdsFromCS.add(objCS.ViewId__c);
		}
		//	Check if the view id of the new Alert Configurations is already present in the custom setting
		//	If not present, then insert it into the custom setting
		for(Alert_Relationship__c objAlertConfiguration : lstAlertConfigurations)
		{
			if(!setViewIds.contains(objAlertConfiguration.ViewId__c) && objAlertConfiguration.ViewId__c != null)
			{
				setViewIds.add(objAlertConfiguration.ViewId__c);
				if(!setViewIdsFromCS.contains(objAlertConfiguration.ViewId__c))
				{
					objViewConfiguration = new ConfiguredViewIds__c(Name = objAlertConfiguration.ViewId__c, ViewId__c = objAlertConfiguration.ViewId__c);
					lstConfiguredViews.add(objViewConfiguration);
				}
			}	
		}
		//	Inserts the records into the custom setting, if the list is not empty
		if(!lstConfiguredViews.isEmpty())
			insert lstConfiguredViews;
	}
	
	//	Method called on before update event
	public void onBeforeUpdate(List<Alert_Relationship__c> lstUpdatedAlertConfigurations, Map<Id, Alert_Relationship__c> mapOldAlertConfigurations)
	{
		//	Method variables
		Set<Id> setNewViewIds = new Set<Id>();
		Set<Id> setOldViewIds = new Set<Id>();
		Set<Id> setCustomSettingViewIds = new Set<Id>();
		Set<Id> setConfiguredViewIds = new Set<Id>();
		List<ConfiguredViewIds__c> lstUnconfiguredViews = new List<ConfiguredViewIds__c>();
		List<ConfiguredViewIds__c> lstConfiguredViews = new List<ConfiguredViewIds__c>();
		ConfiguredViewIds__c objCustomSetting = new ConfiguredViewIds__c();
		
		//	Takes the view ids stored in custom setting to a set
		for(ConfiguredViewIds__c objCS : ConfiguredViewIds__c.getAll().values())
		{
			setCustomSettingViewIds.add(objCS.ViewId__c);
		}
		//	Iterate through the updated Alert Configurations
		for(Alert_Relationship__c objAlertConfiguration : lstUpdatedAlertConfigurations)
		{
			if(objAlertConfiguration.ViewId__c != mapOldAlertConfigurations.get(objAlertConfiguration.Id).ViewId__c && 
			   !setOldViewIds.contains(objAlertConfiguration.ViewId__c) &&
			   objAlertConfiguration.ViewId__c != null)
			{
				setNewViewIds.add(objAlertConfiguration.ViewId__c);
				setOldViewIds.add(mapOldAlertConfigurations.get(objAlertConfiguration.Id).ViewId__c);
				//	Checks whether the updated view id is present in the custom setting
				if(!setCustomSettingViewIds.contains(objAlertConfiguration.ViewId__c))
				{
					//	Creates a new record of custom setting and adds it to a list for insertion
					objCustomSetting = new ConfiguredViewIds__c(Name = objAlertConfiguration.ViewId__c, ViewId__c = objAlertConfiguration.ViewId__c);
					lstConfiguredViews.add(objCustomSetting);
				}
			}
			else if(objAlertConfiguration.ViewId__c == null && mapOldAlertConfigurations.get(objAlertConfiguration.Id).ViewId__c != null)
			{
				setOldViewIds.add(mapOldAlertConfigurations.get(objAlertConfiguration.Id).ViewId__c);
			}
		}
		
		//	Iterates through the Alert Configurations exist with the old view ids of updated Alert Configurations and takes the view ids into a set
		for(Alert_Relationship__c objAlertConfiguration : [Select Id, ViewId__c From Alert_Relationship__c Where ViewId__c IN : setOldViewIds AND Id NOT IN : mapOldAlertConfigurations.keyset()])
		{
			setConfiguredViewIds.add(objAlertConfiguration.ViewId__c);
		}
		//	Removes the confured view ids from the set setOldViewIds 
		setOldViewIds.removeAll(setConfiguredViewIds);
		system.debug('---------setOldViewIds-----------------'+setOldViewIds);
		//	Adds custom setting records of unconfigured views to a list for deletion
		if(!setOldViewIds.isEmpty())
		{
			for(Id viewId : setOldViewIds)
			{
				if(ConfiguredViewIds__c.getInstance(viewId) != null)
					lstUnconfiguredViews.add(ConfiguredViewIds__c.getInstance(viewId));
			}
		}
		
		//	Deletes records from custom setting	
		if(!lstUnconfiguredViews.isEmpty())
			delete lstUnconfiguredViews; 
		//	Inserts records into custom setting
		if(!lstConfiguredViews.isEmpty())
			insert lstConfiguredViews;	
		system.debug('--------------lstUnconfiguredViews-------------------'+lstUnconfiguredViews);
		system.debug('--------------lstConfiguredViews-------------------'+lstConfiguredViews);
	}
	
	//	method called on before delete event
	public void onBeforeDelete(Map<Id, Alert_Relationship__c> mapAlertConfigurations)
	{
		//	Method variables
		Set<Id> setConfiguredViewIdsAmongDeleted = new Set<Id>();
		Set<Id> setViewIdsOfDeletedAlertConfigurations = new Set<Id>();
		List<ConfiguredViewIds__c> lstCSViewsToBeDeleted = new List<ConfiguredViewIds__c>();
		
		//	Takes the view ids of deleted Alert Configurations into a set
		for(Alert_Relationship__c objAlertConfiguration : mapAlertConfigurations.values())
		{
			setViewIdsOfDeletedAlertConfigurations.add(objAlertConfiguration.ViewId__c); 
		}
		//	Queries and Iterates through the Alert Configurations related to the view ids of deleted Alert Configurations
		for(Alert_Relationship__c objAlertConfiguration : [Select Id, ViewId__c From Alert_Relationship__c Where ViewId__c IN : setViewIdsOfDeletedAlertConfigurations AND Id NOT IN : mapAlertConfigurations.keyset()])
		{
			setConfiguredViewIdsAmongDeleted.add(objAlertConfiguration.ViewId__c); 
		}
		//	Removes the view ids of existing Alert Configurations from the set setViewIdsOfDeletedAlertConfigurations 
		setViewIdsOfDeletedAlertConfigurations.removeAll(setConfiguredViewIdsAmongDeleted);
		
		//	Adds custom setting records of unconfigured views to a list for deletion
		for(Id viewId : setViewIdsOfDeletedAlertConfigurations)
		{
			if(ConfiguredViewIds__c.getInstance(viewId) != null)
				lstCSViewsToBeDeleted.add(ConfiguredViewIds__c.getInstance(viewId));
		}
		//	Deletes records from custom setting
		if(!lstCSViewsToBeDeleted.isEmpty())
			delete lstCSViewsToBeDeleted; 
		
	}
	
	//	Test method
	public static testMethod void testTBN_AlertConfigurationHandler()
	{
		Alert__c objAlert = new Alert__c(Alert_Message__c = 'Test Alert');
		insert objAlert;
		Alert_Relationship__c objAR1 = new Alert_Relationship__c(Alert__c = objAlert.Id, Related_SObject__c = 'Case', ViewId__c = '00B30000002ntXt');
		insert objAR1;
		Alert_Relationship__c objAR = new Alert_Relationship__c(Alert__c = objAlert.Id, Related_SObject__c = 'Case', ViewId__c = '00B30000002ntXt');
		insert objAR;
		objAR.Related_SObject__c = 'Account';
		objAR.ViewId__c = '00B30000002ntY0';
		update objAR;
		delete objAR;
	}
}