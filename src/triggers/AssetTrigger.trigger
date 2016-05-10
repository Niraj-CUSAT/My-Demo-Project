/*Written By:Dhriti Krishna Ghosh Moulick
  Created Date:2/06/2015
  Modified Date:
  Description:This trigger is used in Before insert,before update Trigger.
              1.Need to check Duplicate Asset Serial Number.
              2.If Asset is created and edited with duplicate  serial number with Same Contact Name,System will throws following error Messages:
                 -Asset is already registered for same Customer 
*/  
trigger AssetTrigger on Asset (before insert,before update,after update) {
    
    AssetTriggerHandler assetHandler = new AssetTriggerHandler(Trigger.isExecuting,Trigger.size);
    if(Trigger.isInsert){
       if(Trigger.isBefore){
          assetHandler.onBeforeInsert(Trigger.new);
       }
    }
    
    if(Trigger.isUpdate){
       if(Trigger.isBefore){
          assetHandler.onBeforeupdate(Trigger.new,Trigger.oldMap);
       }
       if(Trigger.isAfter){
          assetHandler.onAfterupdate(Trigger.new,Trigger.oldMap);
       }
    }
}