/*****************************************************************************************************************************************************
 * Class Name   : AOSI_ContactTriggerHandler
 * Created By   : Pooja P Bhat
 * Created Date : 6-OCT-2015
 * Description  : Handler Class for AOSI_ContractTrigger
 * Constructor  : public AOSI_ContactTriggerHandler( list<Contact> newlist, map<Id,Contact> newMap, map<Id,Contact> oldMap )
 * Methods      : public void beforeInsertHandler()
                  public void beforeUpdateHandler()
                  private void beforeInsertUpdateHandler(Boolean isInsert)
******************************************************************************************************************************************************/
public class AOSI_ContactTriggerHandler { 
    
    private list<Contact> newlist   =   new list<Contact>();
    private map<Id,Contact> newMap  =   new map<Id,Contact>();
    private map<Id,Contact> oldMap  =   new map<Id,Contact>();
    
    private RecordType aosIndiaRecType    =    new RecordType();
    
    /************************************************************************************************************************************************
    Constructor : AOSI_ContactTriggerHandler
    Description : Used to initialize all class variables
    *************************************************************************************************************************************************/
    public AOSI_ContactTriggerHandler( list<Contact> newlist, map<Id,Contact> newMap, map<Id,Contact> oldMap ) {
        this.newlist    =   newlist;
        this.newMap     =   newMap;
        this.oldMap     =   oldMap;
        
        try{
            RecordTypeDetails__c caseRecType    =   RecordTypeDetails__c.getInstance('Contact Name');
            aosIndiaRecType                     =   DAL.getRecordTypeId(caseRecType.Developer_Name__c, caseRecType.SobjectType__c); } catch (Exception e) { System.debug('***Exception AOSI_ContactTriggerHandler while retrieving record type from custom settings *** ' + e);}
    }
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : beforeInsertUpdateHandler(Boolean isInsert)
     * Return Type : void
     * Description : Defines case trigger before Insert/Update common logic 
                     *)Used to update contact mailing address based on selected locality and pin code 
     * ***********************************************************************************************************************************************************************************************/
    private void beforeInsertUpdateHandler(Boolean isInsert) {
        set<Id> sLocalityIds    =   new set<Id>();
        set<Id> sPinCodeIds     =   new set<Id>();
        
        map<Id,Locality__c> mLocality       =   new map<Id,Locality__c>(); 
        map<Id,Pin_Master__c> mPinMaster    =   new map<Id,Pin_Master__c>(); 
        
        if( !newlist.isEmpty() ) {
            for ( Contact oCon : newlist ) {
                if ( oCon.RecordTypeId != null && aosIndiaRecType.Id != null && oCon.RecordTypeId == aosIndiaRecType.ID) {
                    /***On Insert - If locality is not null, collecting selected locality Id in a set sLocalityIds : On Update - If locality is changed, collecting selected locality Id in a set sLocalityIds***/
                    if ( (isInsert && oCon.AOSI_Locality__c != null) || ( !isInsert && ((oCon.AOSI_Locality__c != null && oldMap.get(oCon.Id).AOSI_Locality__c != oCon.AOSI_Locality__c) || (oCon.AOSI_Pin_Code__c != null && oldMap.get(oCon.Id).AOSI_Pin_Code__c != oCon.AOSI_Pin_Code__c) || ((oCon.MailingCity != oldMap.get(oCon.Id).MailingCity || oCon.MailingState != oldMap.get(oCon.Id).MailingState || oCon.MailingPostalCode != oldMap.get(oCon.Id).MailingPostalCode || oCon.MailingCountry != oldMap.get(oCon.Id).MailingCountry)))) ) {
                        sLocalityIds.add(oCon.AOSI_Locality__c);
                    }
                    /***On Insert - If PinCode is not null, collecting selected Pincode Id in a set sPinCodeIds : On Update - If PinCode is changed, collecting selected PinCode Id in a set sPinCodeIds***/
                    if ( oCon.AOSI_Pin_Code__c != null) {
                        sPinCodeIds.add(oCon.AOSI_Pin_Code__c);
                    }
                }
            }
        }
        
        if( !sLocalityIds.isEmpty() ) {
            for( Locality__c oLoc : [SELECT Id,Name,AOSI_Pin_Master__c,AOSI_Pin_Master__r.Name,AOSI_Pin_Master__r.AOSI_City__c,AOSI_Pin_Master__r.AOSI_Region__c,AOSI_Pin_Master__r.AOSI_State__c,AOSI_Pin_Master__r.AOSI_Country__c FROM Locality__c WHERE Id IN : sLocalityIds] ) {
                mLocality.put(oLoc.Id, oLoc);
            }
        }
        
        if( !sPinCodeIds.isEmpty() ) {
            for( Pin_Master__c oPin : [SELECT Id,Name,AOSI_City__c,AOSI_Region__c,AOSI_State__c,AOSI_Country__c FROM Pin_Master__c WHERE Id IN : sPinCodeIds] ) {
                mPinMaster.put(oPin.Id, oPin);
            }
        }
        
        if( !newlist.isEmpty() ) {
            for ( Contact oCon : newlist ) { 
                
                system.debug('1'+oCon.AOSI_Locality__c  );
                system.debug('2'+oCon.AOSI_Pin_Code__c);
                system.debug('3'+mPinMaster);
                system.debug('4'+mPinMaster.containsKey(oCon.AOSI_Pin_Code__c));
                system.debug('5'+mPinMaster.get(oCon.AOSI_Pin_Code__c) != null);
                system.debug('6'+oCon.AOSI_Locality__c);
                system.debug('7'+oCon.AOSI_Pin_Code__c);
                
                
                if ( oCon.AOSI_Locality__c != null && !mLocality.isEmpty() && mLocality.containsKey(oCon.AOSI_Locality__c) && mLocality.get(oCon.AOSI_Locality__c) != null ) {
                    system.debug('Locality check');
                    oCon.AOSI_Pin_Code__c    =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__c;                 
                    oCon.AOSI_State__c       =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_State__c;
                    oCon.AOSI_Region__c      =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_Region__c; 
                    oCon.MailingStreet       =   ((oCon.MailingStreet != null && !oCon.MailingStreet.contains(mLocality.get(oCon.AOSI_Locality__c).Name)) ? oCon.MailingStreet+ ' ' +mLocality.get(oCon.AOSI_Locality__c).Name : mLocality.get(oCon.AOSI_Locality__c).Name) ;
                    oCon.MailingCity         =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_City__c;
                    oCon.MailingState        =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_State__c;
                    oCon.MailingPostalCode   =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__r.Name; 
                    oCon.MailingCountry      =   mLocality.get(oCon.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_Country__c;    
                }
                else if ( oCon.AOSI_Locality__c == null && oCon.AOSI_Pin_Code__c != null ){
                    system.debug('Pin check');
                    oCon.AOSI_State__c       =   mPinMaster.get(oCon.AOSI_Pin_Code__c).AOSI_State__c;
                    oCon.AOSI_Region__c      =   mPinMaster.get(oCon.AOSI_Pin_Code__c).AOSI_Region__c; 
                    oCon.MailingCity         =   mPinMaster.get(oCon.AOSI_Pin_Code__c).AOSI_City__c;
                    oCon.MailingState        =   mPinMaster.get(oCon.AOSI_Pin_Code__c).AOSI_State__c;
                    oCon.MailingPostalCode   =   mPinMaster.get(oCon.AOSI_Pin_Code__c).Name; 
                    oCon.MailingCountry      =   mPinMaster.get(oCon.AOSI_Pin_Code__c).AOSI_Country__c;    
                }
            }
                
        }
        
    }
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : beforeInsertHandler()
     * Return Type : void
     * Description : Defines case trigger before insert logic                     
     * ***********************************************************************************************************************************************************************************************/
    public void beforeInsertHandler() {
        beforeInsertUpdateHandler(true);
    } //End of beforeInsertHandler
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : beforeUpdateHandler()
     * Return Type : void
     * Description : Defines case trigger before Update logic                      
     * ***********************************************************************************************************************************************************************************************/
    public void beforeUpdateHandler() {
        beforeInsertUpdateHandler(false);
    } //End of beforeUpdateHandler
    
    
} //End of AOSI_ContactTriggerHandler