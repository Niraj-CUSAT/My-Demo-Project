/***************************************************************************************************************************************************************************************
 * Class Name   : AOSI_AOSIContractTriggerHandler
 * Created By   : Pooja P Bhat
 * Created Date : 21-SEPTEMBER-2015
 * Description  : Handler Class for AOSI_AOSIContractTrigger
 * Constructor  : public AOSI_AOSIContractTriggerHandler(list<AOSI_Contract__c> newList,list<AOSI_Contract__c> oldList,map<Id,AOSI_Contract__c> newMap,map<Id,AOSI_Contract__c> oldMap)
 * Methods      : public void beforeInsertHandler()
                  public void beforeUpdateHandler()
                  public void afterInsertUpdateHandler(Boolean isInsert)
                  public void afterInsertHandler() 
                  public void afterUpdateHandler()
                  public void afterDeleteHandler()
 *************************************************************************************************************************************************************************************/

public class AOSI_AOSIContractTriggerHandler {
    
    private list<AOSI_Contract__c>  newList =   new list<AOSI_Contract__c>();
    private list<AOSI_Contract__c>  oldList =   new list<AOSI_Contract__c>();
    private map<Id,AOSI_Contract__c> newMap =   new map<Id,AOSI_Contract__c>();
    private map<Id,AOSI_Contract__c> oldMap =   new map<Id,AOSI_Contract__c>();
    
    /*******************************************************************************************************************************************************
    Parameterized Constructor   :   AOSI_AOSIContractTriggerHandler
    Description                 :   Used to initialize all class variables newList, oldList, newMap, oldMap
    *******************************************************************************************************************************************************/
    public AOSI_AOSIContractTriggerHandler( list<AOSI_Contract__c> newList, list<AOSI_Contract__c> oldList, map<Id,AOSI_Contract__c> newMap, map<Id,AOSI_Contract__c> oldMap) {
        this.newList    =   newList; 
        this.oldList    =   oldList;                
        this.newMap     =   newMap;
        this.oldMap     =   oldMap;    
    }
        
    /*******************************************************************************************************************************************************
     * Method Name : beforeInsertHandler()
     * Return Type : void
     * Description : Defines AOSI Contract trigger before insert logic 
    *******************************************************************************************************************************************************/
    //public void beforeInsertHandler() {} //End of beforeInsertHandler()
    
    /*******************************************************************************************************************************************************
     * Method Name : beforeUpdateHandler()
     * Return Type : void
     * Description : Defines AOSI Contract trigger before update logic              
    *******************************************************************************************************************************************************/
    public void beforeUpdateHandler() {
    
        map<Id,Id> mConIdAssetId   =   new map<Id,Id>();
        
        if( !newMap.isEmpty() ) {
            for( AOSI_Contract__c oContract : newMap.values() ) {
                if( oContract.AOSI_Asset__c != null ) {
                    mConIdAssetId.put(oContract.Id, oContract.AOSI_Asset__c );
                }
            } //End of for(AOSI_Contract__c oContract : newMap.values())
        } //End of if(!newMap.isEmpty())
        
        map<Id,Id> mAssetIdProdId             =   new map<Id,Id>();
        map<Id,AOSI_Contract__c> mAssetIdPrevContrct    =   new map<Id,AOSI_Contract__c>();
        
        if( !mConIdAssetId.isEmpty() ) {
            for( Asset oAsset : [SELECT Id, Name, Product2Id, Product2.Name, AOSI_Asset_Status__c,
                                (SELECT Id, Name, CreatedDate, AOSI_Start_Date__c, AOSI_End_Date__c, AOSI_Contract_Status__c, AOSI_Amount_Received__c, AOSI_Asset__c 
                                FROM Contracts__r WHERE AOSI_Amount_Received__c = true AND AOSI_Invoice_Date__c != null AND AOSI_Invoice_Number__c != null AND Id NOT IN: mConIdAssetId.keyset() ORDER BY CreatedDate DESC LIMIT 1) 
                                FROM Asset WHERE Id IN : mConIdAssetId.values()]) {
                
                if( oAsset.Product2Id != null ) {
                    mAssetIdProdId.put(oAsset.Id, oAsset.Product2Id);
                }
                
                if( oAsset.Contracts__r.size() == 1 ) {
                    mAssetIdPrevContrct.put(oAsset.Id, oAsset.Contracts__r );
                }
            }
        }
        
        map<Id, map<Id, Product_AMC_Junction__c>> mapProdIdAMC = new map<Id,map<Id, Product_AMC_Junction__c>>();
        if( !mAssetIdProdId.isEmpty() ) {
            for( Product_AMC_Junction__c oPAJunction : [SELECT Id, AMC_Master__c, AMC_Master__r.Name, AMC_Master__r.AOSI_Contract_Type__c, AMC_Master__r.AOSI_Status__c, AMC_Master__r.AOSI_AMC_Amount__c, Product__c FROM Product_AMC_Junction__c WHERE Product__c IN :mAssetIdProdId.values()]) { 
                if( !mapProdIdAMC.isEmpty() && mapProdIdAMC.containsKey(oPAJunction.Product__c) && mapProdIdAMC.get(oPAJunction.Product__c) != null ) {
                    mapProdIdAMC.get(oPAJunction.Product__c).put(oPAJunction.AMC_Master__c, oPAJunction);           
                } else {                                        
                    mapProdIdAMC.put(oPAJunction.Product__c, new map<Id, Product_AMC_Junction__c>{oPAJunction.AMC_Master__c => oPAJunction});
                }
            }
        }
        
        if( !newMap.isEmpty() ) {
            for( AOSI_Contract__c oContract : newMap.values() ) {
                if( oldMap.get(oContract.Id).AOSI_Amount_Received__c == false && oContract.AOSI_Amount_Received__c == true && oContract.AOSI_Start_Date__c != null ){
                    oContract.AOSI_Contract_Status__c = DefineConstant.CONTRACT_STAT_ACTIVE; 
                }
                
                if ( oContract.AOSI_AMC__c != null && oContract.AOSI_Base_Amount__c == null) {
                    if(!mAssetIdProdId.isEmpty() && mAssetIdProdId.containsKey(oContract.AOSI_Asset__c) && mAssetIdProdId.get(oContract.AOSI_Asset__c) != null && !mapProdIdAMC.isEmpty() && mapProdIdAMC.containsKey(mAssetIdProdId.get(oContract.AOSI_Asset__c)) && mapProdIdAMC.get(mAssetIdProdId.get(oContract.AOSI_Asset__c)) != null ) {
                        oContract.AOSI_Base_Amount__c = ((mapProdIdAMC.get(mAssetIdProdId.get(oContract.AOSI_Asset__c)).containsKey(oContract.AOSI_AMC__c) && mapProdIdAMC.get(mAssetIdProdId.get(oContract.AOSI_Asset__c)).get(oContract.AOSI_AMC__c) != null) ? mapProdIdAMC.get(mAssetIdProdId.get(oContract.AOSI_Asset__c)).get(oContract.AOSI_AMC__c).AMC_Master__r.AOSI_AMC_Amount__c : null);
                    }
                }
                
                if( oContract.AOSI_Asset__c != null && oContract.AOSI_AMC__c != null && !mAssetIdProdId.isEmpty() && mAssetIdProdId.containsKey(oContract.AOSI_Asset__c) && mAssetIdProdId.get(oContract.AOSI_Asset__c) != null 
                    && !mapProdIdAMC.isEmpty() && mapProdIdAMC.containsKey(mAssetIdProdId.get(oContract.AOSI_Asset__c)) && mapProdIdAMC.get(mAssetIdProdId.get(oContract.AOSI_Asset__c)) != null
                    && !(mapProdIdAMC.get(mAssetIdProdId.get(oContract.AOSI_Asset__c)).containsKey(oContract.AOSI_AMC__c)) ) {
                        oContract.addError('Incorrect AMC. \n Please select AMC related to product, which is related to selected Asset');
                }
                
                
                if ( !mAssetIdPrevContrct.isEmpty() && mAssetIdPrevContrct.containsKey(oContract.AOSI_Asset__c) && mAssetIdPrevContrct.get(oContract.AOSI_Asset__c) != null ) {
                    if( oContract.AOSI_Contract_Status__c.equalsIgnoreCase(DefineConstant.CONTRACT_STAT_ACTIVE) && oContract.AOSI_Start_Date__c != null && ( (oContract.AOSI_Start_Date__c <= mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).AOSI_End_Date__c) || (system.today() <= mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).AOSI_End_Date__c && oContract.AOSI_Start_Date__c >= mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).AOSI_End_Date__c.addDays(2)) )){
                        system.debug('New Contract start date********');
                        //Added by Rajesh on Dec 24 2015
                        //Introduced this condition to throw an error only on if previous contract is active
                        if(mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).AOSI_Contract_Status__c =='Active')
                        {
                        oContract.addError('New Contract Start Date should be always next day of the End date of previous contract. ' +  mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).Name );
                    }   }
                    if( oContract.AOSI_Contract_Status__c.equalsIgnoreCase(DefineConstant.CONTRACT_STAT_ACTIVE) && mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).AOSI_Contract_Status__c == DefineConstant.CONTRACT_STAT_ACTIVE && oContract.AOSI_Start_Date__c != null ){
                        system.debug('Selected Asset already have active Contract********');
                        oContract.addError('Selected Asset already have active Contract ' + mAssetIdPrevContrct.get(oContract.AOSI_Asset__c).Name);
                    }
                }
                
            } //End of for(AOSI_Contract__c oContract : newMap.values())
        } //End of if(!newMap.isEmpty())
        
    } //End of beforeUpdateHandler()
    
    /*******************************************************************************************************************************************************
     * Method Name : afterInsertUpdateHandler(Boolean isInsert)
     * Return Type : void
     * Description : Defines AOSI Contract trigger after insert logic 
                     a) To update AMC Pin record(Fields - Active, related Contact,Case, Asset and Product) when new Contract is created using AMC Pin.
    *******************************************************************************************************************************************************/
    public void afterInsertUpdateHandler(Boolean isInsert) {
      
        set<String> sContractKey            =  new set<String>();
        set<Id>  sAssetIds                  =  new set<Id>();
        map<Id,Asset> mAsset                =  new map<Id,Asset>();
        map<String,AMC_Pin__c> mKeyAMCPin   =  new map<String,AMC_Pin__c>();
        list<AMC_Pin__c>  lUpdateAMCPIn     =  new list<AMC_Pin__c>();

        if( !newMap.isEmpty() || (!isInsert && !oldMap.isEmpty()) ) {
            for( AOSI_Contract__c oContract : newMap.values() ) { 
                if(!isInsert){
                    system.debug('********oldMap.get(oContract.Id).AOSI_AMC__c'+oldMap.get(oContract.Id).AOSI_AMC__c);}
                if( (isInsert && oContract.Name != null && oContract.AOSI_Asset__c != null) || (!isInsert && oContract.Name != null && oContract.AOSI_Asset__c != null && oContract.AOSI_AMC__c != null && (oldMap.get(oContract.Id).AOSI_Asset__c != oContract.AOSI_Asset__c || oldMap.get(oContract.Id).AOSI_AMC__c != oContract.AOSI_AMC__c))) {
                    list<String> parts  =   oContract.Name.split(' ');               
                    String key          =  parts[parts.size()-1]; 
                    sContractKey.add(key);
                    sAssetIds.add(oContract.AOSI_Asset__c);
                    
                }
                
            }
        }
    
        if ( !sAssetIds.isEmpty() ) {
            for ( Asset oAsset : [SELECT Id, Name, Product2Id, ContactId FROM Asset WHERE Id IN: sAssetIds]) {
                mAsset.put(oAsset.Id, oAsset);
            }
        }
      
        if ( !sContractKey.isEmpty() ) {
            for (AMC_Pin__c oAMCPin : [SELECT Id, Name, AOSI_AMC_Pin_Number__c, AOSI_Active__c, AOSI_Key_Number__c, AOSI_Type__c FROM AMC_Pin__c WHERE AOSI_Key_Number__c IN: sContractKey ]) {
                mKeyAMCPin.put(oAMCPin.AOSI_AMC_Pin_Number__c, oAMCPin);
            }
        }
      
        if ( !newMap.isEmpty() ) {
            for( AOSI_Contract__c oContract : newMap.values() ) { 
          
                /***To update AMC Pin record(Fields - Active, related Contact,Case, Asset and Product) when new Contract is created using AMC Pin***/
                if( !mKeyAMCPin.isEmpty() && mKeyAMCPin.containsKey(oContract.Name) && mKeyAMCPin.get(oContract.Name) != null && !mAsset.isEmpty() && mAsset.containsKey(oContract.AOSI_Asset__c) && mAsset.get(oContract.AOSI_Asset__c) != null) {
                    AMC_Pin__c oPin         =   new AMC_Pin__c();
                    oPin.Id                 =   mKeyAMCPin.get(oContract.Name).Id;
                    oPin.AOSI_Active__c     =   ((mKeyAMCPin.get(oContract.Name).AOSI_Type__c != oContract.Name.split(' ')[0].trim()) ? false : true );
                    oPin.AOSI_Contact__c    =   mAsset.get(oContract.AOSI_Asset__c).ContactId;
                    oPin.AOSI_Product__c    =   mAsset.get(oContract.AOSI_Asset__c).Product2Id;
                    oPin.Asset__c           =   oContract.AOSI_Asset__c;
                    oPin.Case__c            =   oContract.AOSI_Case__c;
                    oPin.AOSI_AMC__c        =   (oContract.AOSI_AMC__c != null ? oContract.AOSI_AMC__c : null);
                    lUpdateAMCPIn.add(oPin);
                } 
            }
        }

        if ( !lUpdateAMCPIn.isEmpty() ) {
            try{
                update lUpdateAMCPIn; } catch ( Exception e ) { System.debug('******Exception while updating AMC Pin from AOSI_AOSIContractTriggerHandler at *** ' + e.getLineNumber() + e.getMessage()); }
        }
        
    } //End of afterInsertUpdateHandler()
    
    
    /*******************************************************************************************************************************************************
     * Method Name : afterInsertHandler()
     * Return Type : void
     * Description : Defines AOSI Contract trigger after insert logic 
                     a) To update AMC Pin record(Fields - Active, related Contact,Case, Asset and Product) when new Contract is created using AMC Pin.
    *******************************************************************************************************************************************************/
    public void afterInsertHandler() {
        
        /*** To update AOSI Trigger(AMC_Pin__c) Object  ***/
        afterInsertUpdateHandler(true);
    }
    
    /********************************************************************************************************************************************************
     * Method Name : afterUpdateHandler()
     * Return Type : void
     * Description : Defines AOSI Contract trigger after update logic 
                     a)When contract is activated, the related Assets Contract Details(i.e Contract StartDate,EndDate,Charge,Number and Status) are updated.  
    ********************************************************************************************************************************************************/
    public void afterUpdateHandler() {
      
        set<Id>  sAssetIds      =   new set<Id>();
        map<Id,Asset> mAsset    =   new map<Id,Asset>();
      
        if ( !newMap.isEmpty() ) {
            for( AOSI_Contract__c oContract : newMap.values() ) {
                if( oContract.AOSI_Asset__c != null ) {
                    sAssetIds.add(oContract.AOSI_Asset__c);
                }
            }
        }  
        
        if( !sAssetIds.isEmpty() ) {
            for(Asset oAsset : [SELECT Id, Name, Product2Id, AOSI_Contract_Start_Date__c, AOSI_Contract_End_Date__c, AOSI_Contract_Charges__c, AOSI_Contract_Number__c, AOSI_Contract_Status__c FROM Asset WHERE Id IN: sAssetIds]) {
                mAsset.put(oAsset.Id, oAsset);
            }
        }
        
        if ( !newMap.isEmpty() ) {
            for( AOSI_Contract__c oContract : newMap.values() ) {
            /***When contract is activated, the related Assets Contract Details(i.e Contract StartDate,EndDate,Charge,Number and Status) are updated ***/
                if( oContract.AOSI_Amount_Received__c == true && oContract.AOSI_Asset__c != null && !mAsset.isEmpty() && mAsset.containsKey(oContract.AOSI_Asset__c) && mAsset.get(oContract.AOSI_Asset__c) != null
                && (mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_End_Date__c <= oContract.AOSI_End_Date__c || mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_End_Date__c == null) 
                && (oContract.AOSI_Contract_Status__c.equalsIgnoreCase(DefineConstant.CONTRACT_STAT_ACTIVE) || oContract.AOSI_Contract_Status__c.equalsIgnoreCase(DefineConstant.CONTRACT_STAT_INACTIVE) || oContract.AOSI_Contract_Status__c.equalsIgnoreCase(DefineConstant.CONTRACT_STAT_TERMINATED)) ) {
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_Start_Date__c =  oContract.AOSI_Start_Date__c; 
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_End_Date__c   =  oContract.AOSI_End_Date__c;
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_Charges__c   =  oContract.AOSI_Total_Amount__c; 
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_Number__c    =  oContract.AOSI_Contract_Number__c; 
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_Status__c   =   ((oContract.AOSI_Contract_Status__c.equalsIgnoreCase(DefineConstant.CONTRACT_STAT_ACTIVE)) ? DefineConstant.IN_CONTRCT : DefineConstant.OUT_OF_CONTRCT);                           
                }
            }
        }
        
        /*** To update AOSI Trigger(AMC_Pin__c) Object  ***/
        afterInsertUpdateHandler(false);

        if( !mAsset.isEmpty() ) {
            try {
                update mAsset.values(); } catch ( Exception e ) { System.debug('******Exception while updating asset from AOSI_AOSIContractTriggerHandler at *** ' + e.getLineNumber() + e.getMessage()); }
        }
    
    } //End of afterUpdateHandler()
    
    /*******************************************************************************************************************************************************
     * Method Name : afterDeleteHandler()
     * Return Type : void
     * Description : Defines AOSI Contract trigger after delete logic 
              a)When contract is deleted related Assets Contract StartDate,EndDate and Status should be null.
    *******************************************************************************************************************************************************/
    public void afterDeleteHandler() {
      
        set<Id>  sAssetIds      =   new set<Id>();
        map<Id,Asset> mAsset    =   new map<Id,Asset>();
        
        if( !oldList.isEmpty() ) {
            for(AOSI_Contract__c oContract : oldList){
                if( oContract.AOSI_Asset__c != null ) {
                    sAssetIds.add(oContract.AOSI_Asset__c);
                }          
            }
        }

        if( !sAssetIds.isEmpty() ) {
            mAsset = new map<Id,Asset>([SELECT Id, Product2Id, AOSI_Contract_Start_Date__c, AOSI_Contract_End_Date__c, AOSI_Contract_Status__c FROM Asset WHERE Id IN: sAssetIds]);
        }
        
        if( !oldList.isEmpty() ) {
            for(AOSI_Contract__c oContract : oldList) {                        
            /***When contract is deleted related Assets Contract StartDate,EndDate and Status should be null***/
                if( !mAsset.isEmpty() && mAsset.containsKey(oContract.AOSI_Asset__c) && mAsset.get(oContract.AOSI_Asset__c) != null ){
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_Start_Date__c =   null; 
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_End_Date__c   =   null;  
                    mAsset.get(oContract.AOSI_Asset__c).AOSI_Contract_Status__c   =   null;  
                } 
            }
        }  

        if( !mAsset.isEmpty() ) {
            try{
                update mAsset.values(); } catch(exception e) { System.debug('******Exception while updating asset from AOSI_AOSIContractTriggerHandler at *** ' + e.getLineNumber() + e.getMessage()); }
        }
    } //End of afterDeleteHandler()
    
        
    
} //End of AOSI_AOSIContractTriggerHandler