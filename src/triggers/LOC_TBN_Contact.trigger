// If a Contact inserted/Updated without an Account based on recordType of contact trigger assigns the default Account(VSYSAOS-33)
trigger LOC_TBN_Contact on Contact (before insert, before update) 
{
	if(LOC_TBN_Contact_UpdateNullAccoToUnknown.isTriggerFired) return;
    else
        LOC_TBN_Contact_UpdateNullAccoToUnknown.isTriggerFired = true;
	
    LOC_TBN_Contact_UpdateNullAccoToUnknown objHandler = new LOC_TBN_Contact_UpdateNullAccoToUnknown();
    public Boolean isExecuted = false;
    if(Trigger.isBefore && ( Trigger.isInsert || Trigger.isUpdate) && !isExecuted)
    {
        objHandler.onBeforeUpdateInsert(Trigger.new);
        isExecuted = true;
    } 
}