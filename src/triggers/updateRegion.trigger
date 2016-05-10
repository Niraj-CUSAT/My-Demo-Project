trigger updateRegion on Case (before Insert, before update) {
     if( RecursionMonitor.recursionCheck.contains('updateRegion')){
     return;
     }
     else{
     RecursionMonitor.recursionCheck.add('updateRegion');
     }       
    set<String> citystr=new set<String>();
    set<id> contactIds = new set<id>();
    set<id> productIds = new set<id>();
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype 
    for(Case cs : trigger.new){
        if(cs.RecordTypeId == rt.id && cs.ContactId != null){
            contactIds.add(cs.ContactId);    
        }
        if(cs.RecordTypeId == rt.id && cs.Reason == 'Contract Request'){
            productIds.add(cs.AOSIProduct__c);
        }
    }    
    Map<id,contact> contactMap = new Map<id,contact>([Select id,MailingCity,MailingState,AOSI_Region__c from Contact where id IN: contactIds ]);    
    for(Case cs : trigger.new){
        if(cs.RecordTypeId == rt.id && cs.ContactId != null && contactMap.containsKey(cs.contactId)){
                citystr.add(contactMap.get(cs.contactId).MailingCity);
            }
     }
     system.debug('------------citystr-------------'+ citystr);
     List<City_Master__c> CM=[select id,name from City_Master__c where name IN:citystr];
     map<string,id> cityMap = new map<string,id>();
     for(City_Master__c city : CM){
         cityMap.put(city.Name,city.id);
     }
     if(!CM.isempty()){
         for(Case cs : trigger.new){
            if(cs.RecordTypeId == rt.id && cs.ContactId != null && contactMap.containsKey(cs.contactId)){
                cs.AOSI_City_Master__c= cityMap.get(contactMap.get(cs.contactId).MailingCity);
                cs.AOSI_City_Picklist__c = contactMap.get(cs.contactId).Mailingcity;
                cs.AOSI_State_Picklist__c = contactMap.get(cs.contactId).MailingState;
                cs.AOSI_Region_picklist__c = contactMap.get(cs.contactId).AOSI_Region__c;       
            }    
        } 
    }
    if(Trigger.isupdate){
        set<id> caseids=new set<id>();
        Map<id,String> casemap=new Map<id,String>();
        List<Case_Customer_Concern__c> CCList=new List<Case_Customer_Concern__c>();
        List<Case_Customer_Concern__c> CCListUpdate=new List<Case_Customer_Concern__c>();
            for(Case cs : trigger.new){
                Case oldcasedata = System.Trigger.oldMap.get(cs.Id);
                if(oldcasedata.AOSI_Customer_Concern__c!=cs.AOSI_Customer_Concern__c){
                    caseids.add(cs.id);
                    casemap.put(cs.id,cs.AOSI_Customer_Concern__c);
                }
            }
            if(!caseids.isempty()){
                CCList=[select id,Customer_Concern__c,Case__c from Case_Customer_Concern__c where Case__c=:casemap.keyset()];
            }
            if(!CCList.isempty()){
                for(Case_Customer_Concern__c CCC : CCList){
                    CCC.Customer_Concern__c=casemap.get(CCC.Case__c);
                    CCListUpdate.add(CCC);
                }
            }
        if(!CCListUpdate.isempty())
        Update  CCListUpdate;
    }
    if(Trigger.isInsert){
        List<Product2> prolist = [Select id, (Select id, AMC_Master__c,Product__c from Product_AMC_Junctions__r) from product2 where id IN: productIds];
        Map<id, list<Product_AMC_Junction__c>> proAmcMap = new Map<id, list<Product_AMC_Junction__c>>(); 
        for(Product2 pro : prolist){
            proAmcMap.put(pro.id, pro.Product_AMC_Junctions__r);    
        }        
        for(Case cs : Trigger.new){
            if(proAmcMap.containsKey(cs.AOSIProduct__c) && proAmcMap.get(cs.AOSIProduct__c).size() <= 0){
                cs.adderror('The Selected Product does not have AMC');     
            }    
        }   
    }
        
}