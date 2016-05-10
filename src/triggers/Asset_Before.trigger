trigger Asset_Before on Asset (before insert, before update) {
    
    List<Asset> processAssetList = new List<Asset>();
    Set<Id> assetIdSet = new Set<Id>();
    Set<String> assetEmailSet = new Set<String>();
    AssetHelper helperObj = new AssetHelper();
    
    for(Asset a: Trigger.new){
        
       if(Trigger.isInsert && (a.Email__c != null || a.Registered_Owner__c != null)){ 
            processAssetList.add(a);
        }else if(Trigger.isUpdate && helperObj.getReplacementUnitProcessing() == false){
            processAssetList.add(a);
        }
        if(a.Email__c != null && a.Email__c != '' && (Trigger.isUpdate && (a.Email__c != Trigger.oldMap.get(a.Id).Email__c || a.Registered_Owner__c != Trigger.oldMap.get(a.Id).Registered_Owner__c
                                                        || a.Telephone__c != Trigger.oldMap.get(a.Id).Telephone__c || a.Install_Street__c != Trigger.oldMap.get(a.Id).Install_Street__c
                                                        || a.Install_State__c != Trigger.oldMap.get(a.Id).Install_State__c || a.Install_Postal_Code__c != Trigger.oldMap.get(a.Id).Install_Postal_Code__c
                                                        || a.Install_Country__c != Trigger.oldMap.get(a.Id).Install_Country__c || a.Install_City__c != Trigger.oldMap.get(a.Id).Install_City__c)))
            assetEmailSet.add(a.Email__c);
        if(a.Id != null)    
            assetIdSet.add(a.Id);
    }
    
    if(processAssetList.size() >0){
        AssetHelper.ownerRegistration(processAssetList,assetIdSet,assetEmailSet); 
    }
    QAS_NA.RecordStatusSetter.InvokeRecordStatusSetterConstrained(trigger.new,trigger.old,trigger.IsInsert,2);
}