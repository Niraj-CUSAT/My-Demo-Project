trigger LOC_TBN_UpdateCloseCaseCount on Case (after insert, after update, before delete) 
{
    if(LOC_TBN_UpdateCloseCaseCount.isTriggerFired) return;
    else
        LOC_TBN_UpdateCloseCaseCount.isTriggerFired = true;

  String locRecordTypeId;
  List<RecordType> rtypes = [Select Name, Id from RecordType 
                                where sObjectType='Case' limit 15];
    For (RecordType rt:rtypes){
    
    System.debug (logginglevel.DEBUG, 'Step 2:  *'+rt.Name+'*');
    if(rt.name=='Technical Services - Lochinvar')
    {
    
     locRecordTypeId=rt.Id;
     
     System.debug (logginglevel.DEBUG,'test step 3: ' + locRecordTypeId);
     
     }
    } 
    
    Map<Id, Case> mapNewLOCCases = new Map<Id, Case>();
    if(Trigger.isInsert || Trigger.isUpdate)
    For (Case cse:Trigger.new) {
        if(cse.RecordTypeId == locRecordTypeId && cse.Recordtype.developername != 'AOSI' && cse.Recordtype.developername !=
        'AOSIndia')
            mapNewLOCCases.put(cse.Id, cse);
    } 
    else
        for(Case cse:Trigger.old) {
        if(cse.RecordTypeId == locRecordTypeId && cse.Recordtype.developername != 'AOSI' && cse.Recordtype.developername !=
        'AOSIndia')
            mapNewLOCCases.put(cse.Id, cse);
    } 
                    
    LOC_TBN_UpdateCloseCaseCount objHandler = new LOC_TBN_UpdateCloseCaseCount(Trigger.isExecuting, Trigger.size);
    
    if(!mapNewLOCCases.keyset().isEmpty())
    {
        if(trigger.isAfter && trigger.isInsert && TBN_RecursionHelper.isAfterInsert)
        {
            objHandler.onAfterInsert(trigger.newMap);
        }
    
        if(trigger.isAfter && trigger.isUpdate && TBN_RecursionHelper.isAfterUpdate)
        {
            objHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        }
        
        if(trigger.isBefore && trigger.isDelete)  
        {
            objHandler.onBeforeDelete(trigger.oldMap); 
        }
    }  
  }