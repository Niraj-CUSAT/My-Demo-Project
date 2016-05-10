/* Written By:- Shweta Kumari
   Written On:- 10/02/2014
   Description:- Create Contract based on AMC pin entered in case , Make Sales Query Case Reasons moved to On hold Status upto 5 times.After that system will throws an Error */

trigger updateAMCInContractafterUpdate on Case (before update) { 
    if( RecursionMonitor.recursionCheck.contains('updateAMCInContractafterUpdate')){
     return;
     }        
     else{
     RecursionMonitor.recursionCheck.add('updateAMCInContractafterUpdate');
     }        
    set<string> pinSet = new set<string>();
    set<id> caseId = new set<id>();
    set<id> contactIds = new set<id>();  
    set<id> productids = new set<id>(); 
    Map<String,id> AMCPinMap = new Map<String,id>();
    map<id,product2> productlist = new map<Id,product2>();
    list<AOSI_Contract__c> newContractList = new list<AOSI_Contract__c>();
    map<String,id> AMCmasterMap = new Map<String,id>();
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype 
    if(trigger.isupdate){
        //code to store AMC pin and case id in set
        for(Case cs : trigger.new){   
        
             if(cs.RecordTypeId == rt.id){//Code to Make Sales Query Case Reasons moved to On hold Status upto 5 times.After that system will throws an Error
            
                if((Trigger.oldMap.get(cs.Id).Status!=Trigger.newMap.get(cs.Id).Status) && Trigger.newMap.get(cs.Id).Status=='On Hold' && Trigger.newMap.get(cs.Id).Reason=='Sales Query' ){
                    System.debug('&&&&&&&&&&&&&&&cs.AOSI_Count_Sales_Query_On_Hold__c&&&&&&&&&&&&&'+cs.AOSI_Count_Sales_Query_On_Hold__c);
                    if(String.valueOf(cs.AOSI_Count_Sales_Query_On_Hold__c)=='' || String.valueOf(cs.AOSI_Count_Sales_Query_On_Hold__c)==null){
                    cs.AOSI_Count_Sales_Query_On_Hold__c=1;
                    }
                    else{
                    cs.AOSI_Count_Sales_Query_On_Hold__c=cs.AOSI_Count_Sales_Query_On_Hold__c + 1;
                    }
                }
                if(cs.AOSI_Count_Sales_Query_On_Hold__c > 5){
                    cs.AddError('Case cannot be moved further to On hold status as limit exceeds and can be either closed/cancelled');
                }
            }
             
            if(Trigger.oldMap.get(cs.id).AOSI_AMC_Pin__c != cs.AOSI_AMC_Pin__c && cs.AOSI_AMC_Pin__c!=null && cs.RecordTypeId == rt.id){
                pinSet.add(cs.AOSI_AMC_Pin__c); 
                contactIds.add(cs.contactId);
                productids.add(cs.AOSIProduct__c);
            }
            caseId.add(cs.id);      
        }   
        //list of AMC Pin reletd to AMC Pin Case
      /*  list<AMC_Pin__c> AmcPinList = [Select id, AOSI_AMC_Pin_Number__c from AMC_Pin__c where AOSI_AMC_Pin_Number__c  IN: pinSet AND AOSI_Active__c = true];       
        //code to put AMC id with particular AMC Pin Id In Map
        for(AMC_Pin__c amc : AmcPinList){    
            AMCPinMap.put(amc.AOSI_AMC_Pin_Number__c,amc.AOSI_AMC__c);
        } */  
        
        System.debug('conids+++++'+contactIds);
        map<id,contact> contactmap = new map<id,contact>([select id, email, phone from Contact where id IN : contactIds]);  
        productlist = new map<id,product2>([select id,name,AOSI_Vertical__c from product2 where Id IN : productids]);
        for(Product_AMC_Junction__c AMCjuntion :[select id,name,AMC_Master__c,AMC_Master__r.AOSI_AMC_Amount__c,AMC_Master__r.Name,AMC_Master__r.AOSI_Contract_Type__c,Product__c from Product_AMC_Junction__c  where Product__c IN : productids AND AMC_Master__r.AOSI_Status__c=: 'active']){
            AMCmasterMap.put(AMCjuntion.AMC_Master__r.AOSI_Contract_Type__c, AMCjuntion.AMC_Master__c);
        }
        //code create new Contract
        for(Case cs : Trigger.new){    
            if(Trigger.oldMap.get(cs.id).AOSI_AMC_Pin__c != cs.AOSI_AMC_Pin__c && cs.AOSI_AMC_Pin__c!=null && cs.RecordTypeId == rt.id){            
                AOSI_Contract__c contract = new AOSI_Contract__c();
                contract.Name = cs.AOSI_AMC_Pin__c;
                contract.AOSI_Asset__c = cs.Assetid;
                contract.AOSI_Case__c = cs.id;
                contract.AOSI_Contact_Email_Id__c =contactmap.get(cs.contactid).email ;
                contract.AOSI_Contact_Phone_Number__c =contactmap.get(cs.contactid).Phone;
                contract.AOSI_Start_Date__c = System.today();               
                if(productlist.containskey(cs.AOSIProduct__c)){
                    if(productlist.get(cs.AOSIProduct__c).AOSI_Vertical__c.equalsIgnorecase('Water Heater') ){
                            if(cs.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase('AMC') && AMCmasterMap.containskey('WH-AMC')){
                                contract.AOSI_AMC__c = AMCmasterMap.get('WH-AMC');
                            }  
                    }
                    else if(productlist.get(cs.AOSIProduct__c).AOSI_Vertical__c.equalsIgnorecase('Water Treatment')){
                        if(cs.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase('AMC') && AMCmasterMap.containskey('WT-AMC')){
                                contract.AOSI_AMC__c = AMCmasterMap.get('WT-AMC');
                        }
                        if(cs.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase('ACMC') && AMCmasterMap.containskey('WT-ACMC')){
                                contract.AOSI_AMC__c = AMCmasterMap.get('WT-ACMC');
                        }
                        if(cs.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase('FLT') && AMCmasterMap.containskey('WT-Filter Plan')){
                                contract.AOSI_AMC__c = AMCmasterMap.get('WT-Filter Plan');
                        }
                    }
                
                }
                newContractList.add(contract);                     
            }            
        }
        List<String> stringError = new List<String>();
        try{
            insert newContractList;
            //Database.insert(newContractList,false);
        }
        catch(Exception e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDmlMessage(i));
                stringError.add(e.getDmlMessage(i)); 
            }
            system.debug('------e---------'+e);
        }
        System.debug('%%%%%%%%%newContractList%%%%%%%%%'+newContractList);
    }    
}