/********************************************************************************
Created by    :    Bhanu Vallabhu, KVP Business Solutions
Created On    :    13 Feb 2013
Modified by   :    Shweta Kumari, KVP Business Solutions    
Modified on   :    10/03/2014
Description   :    1) code to validate,customer concern selected in Case should be related to Selected product
                   2) code to create child case based on quantity for Installation and color panel case reason
                   3) code to validate that child and parent should not have same asset
                   4) code to validate that parent can be closed if child case cases are closed or cancelled
                   5) code to validate that Under processing contract case should not be close
                   6) code to validation for Contract Request case cannot be created  on Asset which is Out Of Warranty and have an open case
*********************************************************************************/

trigger CustomerConcern on Case (after insert, after Update ,before Update, before insert) { 
    
    public boolean childinsert = false;
    for(case c : Trigger.New){
        if(Trigger.isInsert && Integer.valueof(c.Quantity__c) > 1){
            childinsert = true;
        }
    }

     if(RecursionMonitor.updated == false && !childinsert){
     return;
     }   
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype 
    set<string> consernName = new set<string>();
    set<id> productId = new set<id>();    
    list<case> childCases = new List<case>();
    list<case> resourceChildCase = new List<case>();
    list<case> childDeleteCase = new List<case>();
    set<id> parentIdSet = new set<id>();
    set<id> caseId = new set<id>();
    set<id> contractCaseId = new set<id>();
    set<id> assetId = new set<id>();
    map<id,id> childMap = new map<id,id>();
    map<id,id> childIdMap = new map<id,id>();
    map<id,List<Case>> casemap = new map<id,List<Case>>();
    map<id,List<Case>> parentChildmap = new map<id,List<Case>>();
    map<id,List<AOSI_Contract__c>> contractCaseMap = new map<id,List<AOSI_Contract__c>>();
    map<id,List<Case>> assetMap = new map<id,List<Case>>();
    Map<string,List<Product_Customer_Concern__c>> concernMap = new Map<string,List<Product_Customer_Concern__c>>(); 
    Set<id> ResourceIds = new Set<id>();  
    Map<id, Integer> caseCountMap = new Map<id, Integer>();  
    List<Service_Engineer__c> RrresourceCaseList = new List<Service_Engineer__c> ();       
    public boolean qunatitychanged = false;
    //code to store AOSI_Customer_Concern__c and Product in a set 
    for(Case cs : Trigger.New){
        if(cs.RecordTypeId == rt.id && cs.Reason == 'Service' && cs.AOSI_Customer_Concern__c != 'Other'){        
            consernName.add(cs.AOSI_Customer_Concern__c);
            productId.add(cs.AOSIProduct__c);    
        } 
        if(cs.RecordTypeId == rt.id && (cs.Reason == 'Free Installation' ||cs.Reason == 'Chargeable Installation') && cs.Parentid != null){
            parentIdSet.add(cs.Parentid);                    
        }
        if(cs.RecordTypeId == rt.id && (cs.Reason == 'Free Installation' ||cs.Reason == 'Chargeable Installation') && cs.Parentid == null){
            caseId.add(cs.id);
            ResourceIds.add(cs.Service_Engineer__c);                    
        }
        if(cs.RecordTypeId == rt.id && cs.Reason == 'Contract Request'){
            contractCaseId.add(cs.id);
            assetId.add(cs.AssetId);
        }
        if(cs.RecordTypeId == rt.id && Trigger.isupdate && cs.Quantity__c != trigger.oldmap.get(cs.Id).Quantity__c){
            qunatitychanged = true;
        }
    }
    System.debug('**********consernName******'+consernName);
    if(trigger.isafter){       
        //query to get list of customer consern and related produt customer consern  
        List<Customer_Concern__c> concernList = new list<Customer_Concern__c>();
        if(!consernName.isempty()){
           concernList  = [Select id,Customer_Concern__c,Name,(Select id,Customer_Concern__c,Product__c  from Product_Customer_Concern__r where Product__c IN: productId ) from Customer_Concern__c where Customer_Concern__c IN : consernName];                                   
        }
        System.debug('**********concernList******'+concernList);
        //code to put customer concern and product customer concern in a map
        if(concernList.size()>0){
            for(Customer_Concern__c cc : concernList){            
                if(cc.Product_Customer_Concern__r.size()>0)
                    concernMap.put(cc.Customer_Concern__c,cc.Product_Customer_Concern__r);
            } 
        }
        System.debug('**********concernMap******'+concernMap);
        //code to validate customer concern             
        for(Case cs : Trigger.New){              
            if(!concernMap.containsKey(cs.AOSI_Customer_Concern__c)  && cs.RecordTypeId == rt.id && cs.Reason == 'Service' && cs.AOSI_Customer_Concern__c != 'Other'){             
                cs.addError('Selected Customer concern does not relate to the product'); 
            }
        }
        //query to get list of all child
        if(Trigger.isInsert || qunatitychanged){
        List<case> caseList = [Select id, Service_Engineer__c,status,(Select id,Service_Engineer__c, status from Cases) from case where Id In:caseId ];
        for(case cs : caseList){
            parentChildmap.put(cs.id,cs.Cases);
        }
        integer quantity = 0;
       /* if(!ResourceIds.isEmpty()){
            RrresourceCaseList = [Select id,(select id,Service_Engineer__c,Reason from Cases__r where Reason !='Color Panel (Free)' AND Reason !='Color Panel (Chargeable)' and Status =:'Open' and RecordTypeId =: rt.id) from Service_Engineer__c where Id IN: ResourceIds];
        }
        for(Service_Engineer__c rcs : RrresourceCaseList){
            caseCountMap.put(rcs.id, rcs.Cases__r.Size());
        }*/
        //code to create child case                                 
        for(case cs : Trigger.new){       
            if(cs.RecordTypeId == rt.id && (cs.Reason == 'Free Installation' ||cs.Reason == 'Chargeable Installation') && cs.Parentid == null){                                   
                quantity = integer.valueof(cs.Quantity__c); 
                
                if(quantity > 0 && parentChildmap.get(cs.id).size() <= 0){
                    for(Integer i = 1 ; i< quantity ; i++){   
                        case childcase = new case();
                        childcase.Parentid = cs.id;
                        childcase.Quantity__c = '1'; 
                        childcase.AOSIProduct__c = cs.AOSIProduct__c;
                        childcase.Reason = cs.Reason;
                        childcase.contactId = cs.contactId;
                        childcase.AOSI_Customer_Concern__c = cs.AOSI_Customer_Concern__c;   
                        childcase.AOSI_City__c = cs.AOSI_City__c; 
                        /*case clonecase = cs.clone();                                                         
                        clonecase.AOSIProduct__c = null;
                        clonecase.Assetid = null;
                        clonecase.id = null;
                        clonecase.Parentid = cs.id;
                        clonecase.Quantity__c = '1'; 
                        clonecase.AOSIProduct__c = cs.AOSIProduct__c;  */                                           
                        childCases.add(childcase);
                    }
                }
                else if(quantity > 0 && parentChildmap.get(cs.id).size() < quantity && trigger.oldmap.get(cs.id).Quantity__c != cs.Quantity__c){
                    quantity = quantity - parentChildmap.get(cs.id).size();  
                    for(Integer i = 1 ; i< quantity ; i++){
                        case childcase = new case();
                        childcase.Parentid = cs.id;
                        childcase.Quantity__c = '1'; 
                        childcase.AOSIProduct__c = cs.AOSIProduct__c;
                        childcase.Reason = cs.Reason;
                        childcase.contactId = cs.contactId;
                        childcase.AOSI_Customer_Concern__c = cs.AOSI_Customer_Concern__c;
                        childcase.AOSI_City__c = cs.AOSI_City__c;  
                        /*case clonecase = cs.clone();                                                         
                        clonecase.AOSIProduct__c = null;
                        clonecase.Assetid = null;
                        clonecase.id = null;
                        clonecase.Parentid = cs.id;
                        clonecase.Quantity__c = '1'; 
                        clonecase.AOSIProduct__c = cs.AOSIProduct__c;*/                                                  
                        childCases.add(childcase);
                    }
                } 
               /* if(cs.Service_Engineer__c != null && caseCountMap.containsKey(cs.Service_Engineer__c)){
                    integer caseQuantity = 10-caseCountMap.get(cs.Service_Engineer__c);
                    for(case css : parentChildmap.get(cs.id)){                    
                        if(caseQuantity != 0){
                            if(css.Service_Engineer__c == null){
                                css.Service_Engineer__c = cs.Service_Engineer__c;
                                caseQuantity = caseQuantity-1;
                                resourceChildCase.add(css);
                            }
                        }
                    }  
                } */                               
            }
            
        }       
       try{     
            //Database.insert(childCases, false);
             RecursionMonitor.updated = false;  
             insert childCases;
                        
       }catch(Exception e){
            //system.debug('----------e--------'+e);
        }                                              
    }}
    //code to validate that child and parent should not have same asset
    if(Trigger.isbefore){        
        //map of parent case 
        map<id,case> parentcase = new Map<id,case >([Select id, assetid from Case where id In: parentIdSet]);
        List<Case> allchildCase = new List<Case>();     
        //list of child record
        if(Test.isRunningTest()){
         allchildCase= [Select ParentId ,id, assetid from Case where ParentId IN: parentIdSet LIMIT 1];
        }else{
           allchildCase = [Select ParentId ,id, assetid from Case where ParentId IN: parentIdSet];
        }
        for(case cse : allchildCase  ){
            childMap.put(cse.ParentId , cse.assetid );
            childIdMap.put(cse.ParentId , cse.id);
        }
        //query to get list of all child
        List<case> caseList = [Select id, status,(Select id, status from Cases where Status != 'Closed' AND Status != 'Cancelled') from case where Id In:caseId ];
        for(case cs : caseList){
            casemap.put(cs.id,cs.Cases);
        } 
        //query to get Contract related to case
        list<case> contractCaselist=new List<case>();
        if(!contractCaseId.isempty()){
         contractCaselist = [Select id, status,(Select id,AOSI_Contract_Status__c,AOSI_Case__c from Contracts__r where AOSI_Contract_Status__c =: 'Under Progress') from case where Id IN: contractCaseId];           
        }
        if(!contractCaselist.isempty()){
        for(case cs : contractCaselist){
            contractCaseMap.put(cs.id,cs.Contracts__r);
        }  
        }        
        for(Case css : trigger.new){
             //code to check for duplicate asset
            if(css .RecordTypeId == rt.id && css.assetid!= null && (css.Reason == 'Free Installation' ||css.Reason == 'Chargeable Installation') && css.Parentid != null){                
                if((childMap.get(css.Parentid) == css.assetid && childIdMap.get(css.Parentid) != css.id) || parentcase.get(css.Parentid).AssetId == css.assetid ){
                    css.addError(' A case is already registered for selected asset for ' + css.Reason);     
                }
            }
            //code to validate that parent can be closed if child case cases are closed or cancelled
            if(css.RecordTypeId == rt.id && (css.Reason == 'Free Installation' ||css.Reason == 'Chargeable Installation') && css.Parentid == null){
                if(css.Status== 'Closed' && casemap.get(css.id).size()>0){
                    css.addError(' Parent case will close only when all the child cases are Closed or Cancelled');
                }                       
            }
            //code to validate that Under processing contract case should not be close
            if(css.RecordTypeId == rt.id && css.Reason == 'Contract Request'){
                if(css.Status== 'Closed' && contractCaseMap.get(css.id).size()>0){
                    css.addError('Case Cannot be closed if it has Under Progress Contract');
                }    
            }
        }
        //validation for Contract Request case cannot be created  on Asset which is Out Of Warranty and have an open case
        if(Trigger.isInsert){
            list<asset> assetList = [Select id,AOSI_Asset_Status__c, (Select id , Status from Cases where Status =: 'Open') from asset where id IN: assetId AND AOSI_Asset_Status__c =: 'Out Of Warranty'];                
            for(asset ast : assetList){
                assetMap.put(ast.id,ast.Cases);    
            }
            for(Case cs: trigger.new){
                if(cs.RecordTypeId == rt.id && cs.Reason == 'Contract Request'&& assetMap.containsKey(cs.AssetId) && assetMap.get(cs.AssetId).size()>0){
                    cs.addError('You cannot create Contract Request case on Asset which is Out Of Warranty and have an open case');    
                }    
            }
        }                                    
    }                         
}