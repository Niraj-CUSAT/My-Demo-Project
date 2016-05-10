/* Written By:- Shweta Kumari
   Written On:- 13/02/2014
   Description:- to update mailing street , mailing city, mailing sate and region on selection of pin code */

trigger ContactUpadteRegion on Contact (before insert, before Update) {
    set<id> pinIds = new set<id>();
    set<id> locIds = new set<id>();
    //select the id of AOS india record type for contact
    ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
    //code to store selected pin code 
    for(Contact con : trigger.new){    
        if(con.recordtypeid == Conrtid){
            pinIds.add(con.AOSI_Pin_Code__c); 
            locIds.add(con.AOSI_Locality__c);   
        }
    }
    
    //list of pin Master of selected pin code
    list<Pin_Master__c> pinMasterList = [Select id,AOSI_City__c,AOSI_Region__c,AOSI_State__c,AOSI_Area__c,AOSI_Country__c,AOSI_Street__c,Name from Pin_Master__c where id IN: pinIds];        
    system.debug('------pinMasterList-------'+pinMasterList);
    //list of locality 
    list<Locality__c> localityList = [Select id, Name,AOSI_Pin_Master__c,AOSI_Pin_Master__r.Name,AOSI_Pin_Master__r.AOSI_City__c,AOSI_Pin_Master__r.AOSI_State__c,AOSI_Pin_Master__r.AOSI_Region__c,AOSI_Pin_Master__r.AOSI_Country__c from Locality__c where id IN:locIds];
    //code to update mailing street , mailing city, mailing sate and region by selected pin allocation data  
    for(Contact con : trigger.new){
        if(con.AOSI_Locality__c != null){
            for(Locality__c loc : localityList){
                if(loc.id == con.AOSI_Locality__c && con.recordtypeid == Conrtid){
                    con.AOSI_Pin_Code__c = loc.AOSI_Pin_Master__c;                      
                    if(con.MailingStreet != null && !con.MailingStreet.contains(loc.Name) ){                
                        con.MailingStreet = con.MailingStreet + ' ' +loc.Name ;
                    } 
                    else if(con.MailingStreet == null){
                         con.MailingStreet = loc.Name ;
                    }                          
                    con.MailingCity = loc.AOSI_Pin_Master__r.AOSI_City__c;
                    con.MailingState = loc.AOSI_Pin_Master__r.AOSI_State__c;
                    con.AOSI_State__c = loc.AOSI_Pin_Master__r.AOSI_State__c;
                    con.AOSI_Region__c = loc.AOSI_Pin_Master__r.AOSI_Region__c; 
                    con.MailingPostalCode = loc.AOSI_Pin_Master__r.Name; 
                    con.MailingCountry = loc.AOSI_Pin_Master__r.AOSI_Country__c;    
                }
            }    
        }
        for(Pin_Master__c pin : pinMasterList){                   
            if(con.AOSI_Pin_Code__c == pin.id && con.recordtypeid == Conrtid){
                con.MailingCity = pin.AOSI_City__c;
                con.MailingState = pin.AOSI_State__c;
                con.AOSI_State__c = pin.AOSI_State__c;
                con.AOSI_Region__c = pin.AOSI_Region__c; 
                con.MailingPostalCode = pin.Name; 
                con.MailingCountry = pin.AOSI_Country__c;
                //con.AOSI_City_Picklist__c = pin.AOSI_City__c;          
            }
        }    
    }
}