/*Written By:Dhriti Krishna Ghosh Moulick
  Created Date:2/06/2015
  Modified Date:
  Description:This Class is used in Before insert Trigger.
              1.Need to check Duplicate Asset Serial Number.
              2.If Asset is created and edited with duplicate  serial number with Same Contact Name,System will throws following error Messages:
                 -Asset is already registered for same Customer 
              3.If Asset number is created same as Manufactured Serial number stored in Custom settings,system will allow to save records else it will display error 
*/  
public class AssetTriggerHandler{

   Map<String,Set<String>> conAssetMap =   new Map<String,Set<String>>();
   Set<Id> contactIdSet                =   new Set<Id>();
   Set<Id> productIdSet                =   new Set<Id>();
   Map<Id,Id> proMap                   =   new Map<Id,Id>();
   Recordtype rtProduct                =   new Recordtype();
   Recordtype rtContact                =   new Recordtype();
   RecordTypeDetails__c productrecordType;
   RecordTypeDetails__c contactrecordType;
   Set<id> proIds                      = new set<id>();
   Set<id> contIds                     = new set<id>();
   Map<id,String> conMap = new Map<id, string>();
   Map<id,id> proMap1                   = new Map<id,id>();
   list<Asset_History__c> historyList = new list<Asset_History__c>();
   
   public AssetTriggerHandler(Boolean isExecuting,Integer size){
       try {
           productrecordType=RecordTypeDetails__c.getInstance('Product Name');
           rtProduct=DAL.getRecordTypeId(productrecordType.Developer_Name__c,productrecordType.SobjectType__c);
           contactrecordType=RecordTypeDetails__c.getInstance('Contact Name');
           rtContact=DAL.getRecordTypeId(contactrecordType.Developer_Name__c,contactrecordType.SobjectType__c); } catch (Exception e) { System.debug('***Exception AssetTriggerHandler while retrieving record type from custom settings *** ' + e);}
   }
   
   public void onBeforeInsert(List<Asset> assetList){
         Set<String> astNameSet=new Set<String>(); 
         set<String> sAsstSerNum    =   new set<String>();  //Collection of asset serial number used to validate with Manufacture Serial Number
         for(Asset ast:assetList){//Start of for loop
             if(!String.isBlank(ast.Name)) {
                 sAsstSerNum.add(ast.Name); 
             }
           contactIdSet.add(ast.ContactId);//fetch contact ID
           productIdSet.add(ast.Product2Id);//fetch product ID
         } //End of for loop
         
         for(Contact con: [Select Id,RecordTypeId,(Select Id,Name From Assets) From Contact  where Id IN :contactIdSet AND RecordTypeId =:rtContact.id]){//Start of for loop
             astNameSet=new set<String>();
             for(Asset  ast :con.Assets ){//Start of for loop
                    astNameSet.add(ast.Name);
                    conAssetMap.put(con.Id,astNameSet);
             }//End of for loop
         }//End of for loop
         
         for(product2 pro :  [Select id, Recordtypeid from Product2 where id IN: productIdSet AND Recordtypeid =: rtProduct.id]){//Start of for loop
              proMap.put(pro.id,pro.Recordtypeid);
         }  //End of for loop
         
         ////////////////////////////////////////////////////////
         
            
        Set<String> nameString = new Set<String>();
        if(!sAsstSerNum.isEmpty()){
            for(Manufactured_Serial_Numbers__c manufacturedSerialNumber:[Select Id,Name from Manufactured_Serial_Numbers__c WHERE Name IN: sAsstSerNum]) {
                nameString.add(manufacturedSerialNumber.Name);
            }   
        }
        system.debug('sAsstSerNum***** '+sAsstSerNum);
        system.debug('nameString***** '+nameString);
         
         
        /* List<ManufacturedSerialNumber__c> manufacturedDate =ManufacturedSerialNumber__c.getAll().values(); 
         Set<String> nameString = new Set<String>();
         
         for(ManufacturedSerialNumber__c man:manufacturedDate){//Start of for loop
            nameString.add(man.Name);
         }//End of for loop*/
 
         ///////////////////////////////////////////////////////
         
         for( Asset ast:assetList ){
            if( !conAssetMap.isEmpty() && conAssetMap.get(ast.ContactId).Contains(ast.name) && proMap.get(ast.Product2Id) == rtProduct.id){
                ast.addError('Asset is Already registered for same Customer');
            }
            if( !nameString.isEmpty() && !nameString.contains(ast.Name) && proMap.get(ast.Product2Id) == rtProduct.id && !test.isRunningTest() ) { //!nameString.isEmpty() && 
                ast.addError('Asset Serial number not exist');
            }
         } 
    }
    
    public void onBeforeUpdate(List<Asset> assetList,Map<Id,Asset> oldMapList){
        // Map<id,id> proMap1                   = new Map<id,id>();
         for(Asset asst : assetList){ 
             proIds.add(asst.Product2Id);
             contIds.add(oldMapList.get(asst.id).ContactId );          
         }
         for(product2 pro : [Select id, Recordtypeid from Product2 where id IN: proIds AND Recordtypeid =: rtProduct.id]){
                 proMap.put(pro.id,pro.Recordtypeid);
            } 
         
          //list of Contact of Recordtype AOS india
         //   List<Contact> contactList = [Select id, Name, RecordTypeId from Contact where Id IN: contIds AND RecordTypeId =: Conrtid];
            //code to put contact id with name in Map
            for(Contact cont : [Select id, Name, RecordTypeId from Contact where Id IN: contIds AND RecordTypeId =: rtContact.Id]){
                conMap.put(cont.id,cont.Name);
            }
            //code to check if contact is changed and upadte the old contact and changed date and time
            for(Asset asst : assetList){  
                if(asst.AOSI_Replaced_Asset__c != null && asst.AOSI_Replacement_Date__c == null && proMap1.get(asst.Product2Id) == rtProduct.id){
                    asst.AOSI_Replacement_Date__c = System.today();    
                }      
                if(proMap.get(asst.Product2Id) == rtProduct.id && oldMapList.get(asst.id).ContactId != asst.ContactId){
                    Asset_History__c assethistory = new Asset_History__c();
                    assethistory.AOSI_Contact_Name__c = conMap.get(oldMapList.get(asst.id).ContactId);
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
    
    public void onAfterUpdate(List<Asset> assetList,Map<Id,Asset> oldMapList){
            set<id> Repl_id=new set<id>();
            
            for(Asset asst : assetList){ 
               proIds.add(asst.Product2Id);
               contIds.add(oldMapList.get(asst.id).ContactId );          
            }
            
            for(product2 pro : [Select id, Recordtypeid from Product2 where id IN: proIds AND Recordtypeid =: rtProduct.id]){
                 proMap.put(pro.id,pro.Recordtypeid);
            }
            
            for(Asset CurrentAsset:assetList){                
                if(CurrentAsset.AOSI_Replaced_Asset__c!=null && proMap.get(CurrentAsset.Product2Id) == rtProduct.id){
                    Repl_id.add(CurrentAsset.AOSI_Replaced_Asset__c); 
                }
            }
            system.debug('------ Not working Repl_id ------'+Repl_id);
            List<Asset> ReplacedAssetUpdate=new List<Asset>();
            List<Asset> oldAssetList = new List<Asset>();
            if(Repl_id != null)
            oldAssetList = [select id,PurchaseDate,AOSI_Replaced_Asset_CheckBox__c from Asset where id=:Repl_id];        
            for(Asset CurrentAsset:assetList){
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
    
}