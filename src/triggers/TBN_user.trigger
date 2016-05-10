/**
* @TriggerName      :  TBN_User
* @JIRATicket    :  VIRSYGEN-7
* @CreatedOn      :  9/Jan/2013
* @ModifiedBy     :  V Kumar
* @Developer Name  :  V Kumar
* @Description    :  This trigger updates the geolocation field of an User record based on address 
**/
trigger TBN_user on User (after insert, after update,before insert, before update) 
{
  private static boolean hasTriggerExecuted = false;
  
   LOC_TBN_CalCulateLatLangHandler handler = new  LOC_TBN_CalCulateLatLangHandler();
  
  if(Trigger.isAfter && ( Trigger.isInsert || Trigger.isUpdate) && !hasTriggerExecuted)
  {
    hasTriggerExecuted = true;
    handler.setUsersIdsToUpdate(Trigger.newMap,Trigger.oldMap);
    
  }
  else if(Trigger.isBefore && ( Trigger.isInsert || Trigger.isUpdate))
  {
    handler.onBeforeUpdateInsert(Trigger.new);
  }
  
}