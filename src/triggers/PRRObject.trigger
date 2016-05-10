/*******************************************************************************************************
Written Bby :- Vishwanath Attikeri
Written On :- 10th Feb 2014
Description :- In Activate the Asset once PRR got approved and checking invoice attachment
modified by: bhanu Vallabhu, for Auto updating account,Contact and asset details automatically
********************************************************************************************************/
trigger PRRObject on PRR__c (Before Insert,before update) {
    set<id> parentid=new set<id>();
    set<id> caseids = new set<id>();
    for(PRR__c prr : trigger.new){
        parentid.add(prr.id);
        caseids.add(prr.AOSI_Case__c);
    }
   List<Attachment> InvoiceAtt=[select id,name from Attachment where parentid=:parentid];
   for(PRR__c prr : trigger.new){
       if(prr.AOSI_Invoice_Attached__c==TRUE && InvoiceAtt.size()==0){
           prr.AOSI_Invoice_Attached__c.addError('Attachment is mandatory');
       }
       
    }
       
     /**** below code added for auto updation of asset and contact details ***/  
    if(Trigger.isInsert && !caseids.isempty()){
        map<Id,case> casemap =new map<Id,case>([select id,AssetId,ContactId,accountid from case where id IN:caseids]);
        for(PRR__c pr : Trigger.new){
            if(casemap.containskey(pr.AOSI_Case__c)){
                pr.AOSI_Account__c = casemap.get(pr.AOSI_Case__c).Accountid;
                pr.AOSI_Asset__c = casemap.get(pr.AOSI_Case__c).AssetId;
                pr.AOSI_Contact__c = casemap.get(pr.AOSI_Case__c).Contactid;
            }
        }
     }
     /***end*****/  
    set<id> Assetid = new set<id>();
    if(Trigger.isupdate){
        for(PRR__c prr : trigger.new){
            if(prr.AOSI_Approval_Status__c=='Approved'){
                Assetid.add(prr.AOSI_Asset__c);
            }
        }
    List<Asset> UpdateAssetlist=new List<Asset>();
    if(!Assetid.isempty()){
        for(Asset currentasset:[select id,AOSI_Active__c from Asset where id=:Assetid]){
            if(currentasset.AOSI_Active__c==true){
                currentasset.AOSI_Active__c=false;
            }
            UpdateAssetlist.add(currentasset);
        }
        if(!UpdateAssetlist.isempty()){
            Update UpdateAssetlist;
        }
    }
    }
}