trigger Asset_After on Asset (after insert, after update) {

    Map<Id,Asset> processAssetsMap = new Map<Id,Asset>();
    AssetHelper helperObj = new AssetHelper();
    
    if(Trigger.isInsert && helperObj.getProcessedAssetInsert() == false){
        helperObj.setProcessedAssetInsert(true);
        for(Asset a: Trigger.new){
            if(a.Replacement__c != null){
                helperObj.setReplacementUnitProcessing(true);
                processAssetsMap.put(a.Id,a);
            }
        }
    }else if(Trigger.isUpdate && helperObj.getProcessedAssetUpdate() == false){
        helperObj.setProcessedAssetUpdate(true);
        for(Asset a: Trigger.new){
            if(a.Replacement__c != null && Trigger.oldMap.get(a.Id).Replacement__c != a.Replacement__c){
                helperObj.setReplacementUnitProcessing(true);
                processAssetsMap.put(a.Id,a);
            }
        }
    }
    
    if(processAssetsMap.keySet().size() >0){
        helperObj.updateReplacementUnit(processAssetsMap);
    }
    
    Map<String,Id> assetSNMap = new Map<String,Id>();
    
    for(Asset a : Trigger.new){
        assetSNMap.put(a.SerialNumber,a.Id);
    }
    
    AssetHelper.processAJRecordsFromBeforeTrigger(assetSNMap); 
}