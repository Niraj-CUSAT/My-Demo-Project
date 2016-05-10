/**
* @TriggerName    	:	TBN_Account
* @JIRATicket		:	VIRSYGEN-13 & VIRSYGEN-7
* @CreatedOn    	:	26/Nov/2012
* @ModifiedBy   	:	V Kumar
* @Developer Name	:	V Kumar
* @Description  	:	This trigger updates the geolocation field of an User record based on address 
**/

trigger LOC_TBN_Account on Account (after insert, after update, before insert, before update) 
{
	private static boolean hasTriggerExecuted = false;
	LOC_TBN_AccountHandler handler =  new LOC_TBN_AccountHandler(Trigger.isExecuting, Trigger.size);
	LOC_TBN_CalCulateLatLangHandler  calCulateLatLangHandler =  new LOC_TBN_CalCulateLatLangHandler ();// && !hasTriggerExecuted
	
	if(Trigger.isAfter && Trigger.isUpdate)
	{
		// call on after Update/Insert of an Account record
		handler.onAfterUpdate(trigger.newMap);
	}
	if(Trigger.isAfter && ( Trigger.isInsert || Trigger.isUpdate) && !hasTriggerExecuted)
	{
		// call on after Update/Insert of an Account record
		hasTriggerExecuted = true;
		calCulateLatLangHandler.setAccountIdsToUpdate(Trigger.newMap,Trigger.oldMap); 
	}
	else if(Trigger.isBefore && ( Trigger.isInsert || Trigger.isUpdate))
	{
		// call on before Update/Insert of an Account record
		calCulateLatLangHandler.onBeforeInsertAndUpdate(trigger.new); 
	}
}