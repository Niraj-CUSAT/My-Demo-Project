trigger TBN_AlertConfiguration on Alert_Relationship__c (before delete, before insert, before update) 
{
	TBN_AlertConfigurationHandler handler = new TBN_AlertConfigurationHandler();
	
	if(trigger.isBefore && trigger.isInsert)
	{
		handler.onBeforeInsert(trigger.new);
	}
	else if(trigger.isBefore && trigger.isUpdate)
	{
		handler.onBeforeUpdate(trigger.new, trigger.oldMap);
	}
	else if(trigger.isBefore && trigger.isDelete)
	{
		handler.onBeforeDelete(trigger.oldMap);
	}
}