trigger UpdateContractInfo on Asset (before Update,After Update) {
    system.debug('------  UpdateContractInfo ------');
    //id of AOS India recordtype for Product
    Recordtype rt = [Select id,name from RecordType where DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1];
    system.debug('------  Recordtype rt ------'+rt);
    //select the id of AOS india record type for contact
    ID Conrtid = [Select id,name from RecordType where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
    system.debug('------ Conrtid ------'+Conrtid);
    set<id> proIds = new set<id>();
    set<id> contIds = new set<id>();
    Map<id , id> proMap = new Map<id,id>();
    Map<id,String> conMap = new Map<id, string>();
    list<Asset_History__c> historyList = new list<Asset_History__c>();
    //code to get productid and contact id
    for(Asset asst : Trigger.new){ 
         proIds.add(asst.Product2Id);
        contIds.add(Trigger.oldMap.get(asst.id).ContactId );          
    }
    // list of product for particular Asset of AOS india recordtype 
        List<product2> proList = [Select id, Recordtypeid from Product2 where id IN: proIds AND Recordtypeid =: rt.id];
        system.debug('------ Not working ------'+proList);
        //code to put productid and recordtype in Map
        for(product2 pro : proList){
            proMap.put(pro.id,pro.Recordtypeid);
        }
        system.debug('------ Not working proMap ------'+proMap);
        if(trigger.isAfter){
            set<id> Repl_id=new set<id>();
             for(Asset CurrentAsset:Trigger.new){                
                if(CurrentAsset.AOSI_Replaced_Asset__c!=null && proMap.get(CurrentAsset.Product2Id) == rt.id){
                    Repl_id.add(CurrentAsset.AOSI_Replaced_Asset__c); 
                }
            }
            system.debug('------ Not working Repl_id ------'+Repl_id);
            List<Asset> ReplacedAssetUpdate=new List<Asset>();
            List<Asset> oldAssetList = new List<Asset>();
            if(Repl_id != null)
            oldAssetList = [select id,PurchaseDate,AOSI_Replaced_Asset_CheckBox__c from Asset where id=:Repl_id];        
            for(Asset CurrentAsset:Trigger.new){
                if(oldAssetList.Size() > 0){
                    for(Asset Rep_Asset :oldAssetList){
                        if(CurrentAsset.AOSI_Replaced_Asset__c==Rep_Asset.id ){
                            Rep_Asset.AOSI_Old_Asset_Purchase_Date__c=CurrentAsset.PurchaseDate;
                            Rep_Asset.AOSI_Replaced_Asset_CheckBox__c = TRUE;
                            Rep_Asset.AOSI_Replacement_Date__c = System.today(); 
                            ReplacedAssetUpdate.add(Rep_Asset); 
                            //CurrentAsset.AOSI_Replacement_Date__c = System.today();
                        }
                    }
                }
            }
            if(!ReplacedAssetUpdate.isempty())
                update ReplacedAssetUpdate;
        }
    system.debug('------ Not working ReplacedAssetUpdate ------');
    //code to upadet old contact name and Date/time
    if(trigger.isbefore)
    {
            //list of Contact of Recordtype AOS india
            List<Contact> contactList = [Select id, Name, RecordTypeId from Contact where Id IN: contIds AND RecordTypeId =: Conrtid];
            //code to put contact id with name in Map
            for(Contact cont : contactList){
                conMap.put(cont.id,cont.Name);
            }
            //code to check if contact is changed and upadte the old contact and changed date and time
            for(Asset asst : Trigger.new){  
                if(asst.AOSI_Replaced_Asset__c != null && asst.AOSI_Replacement_Date__c == null && proMap.get(asst.Product2Id) == rt.id){
                    asst.AOSI_Replacement_Date__c = System.today();    
                }      
                if(proMap.get(asst.Product2Id) == rt.id && Trigger.oldMap.get(asst.id).ContactId != asst.ContactId){
                    Asset_History__c assethistory = new Asset_History__c();
                    assethistory.AOSI_Contact_Name__c = conMap.get(Trigger.oldMap.get(asst.id).ContactId);
                    assethistory.AOSI_Change_Date_Time__c = System.Now();
                    assethistory.AOSI_Asset__c = asst.id;
                    historyList.add(assethistory);                 
                }    
            } 
            try{
                database.insert(historyList,true);
            } 
            catch(exception e){
                system.debug('-------e------'+e);
            }  
        
    }
    
}