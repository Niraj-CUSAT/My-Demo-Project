/********************************************************************************
Created by: Bhanu Vallabhu, KVP Business Solutions;Created On: 13 Feb 2013
Modified by: Pawani GVK, KVP Business Solutions;Modified on: 19 Feb 2014
*********************************************************************************/
trigger CaseAfterBeforeUpdate on Case (before update, after update)
{
     if(RecursionMonitor.updated == false){
        return;
     }
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype 
    set<id> Contactids = new set<id>();
    set<id> ServiceIds = new set<id>();
    set<id> assetids = new set<id>();
    set<id> caseids = new set<id>();
    set<id> sevCaseids = new set<id>();
    set<id> replacedAssetIds = new set<id>();
    list<user> rccusers = new list<user>();
    map<id,date> caseDateMap= new Map<id,date>();
    public boolean statuschanged = false;
    public boolean serviceenggchanged = false;
    public boolean caseclosed = false;
    public boolean panelcasepartialyclosed = false;
    set<id> panelcaseids = new set<id>();
    //list<User> userlist = [Select u.UserRole.DeveloperName, u.UserRoleId, u.IsActive, u.Id From User u where u.UserRole.DeveloperName like 'Regional_Call_Coordinator%'];
    
    Set<Id> caseId = new Set<Id>();
    List<Asset> fieldUpdateAsset = new List<Asset>();
    List<Product2> fieldUpdateAProduct = new List<Product2>();
    //List<String> updateMembraneWarranty = new List<String>();
    Map<Id,String> updateMembraneWarranty = new Map<Id,String>();
    Map<Id,String> updateMembraneWarranty1 = new Map<Id,String>();
    
    for(Case c: Trigger.new)
    {

            if(c.RecordTypeId == rt.id){
            
              
            Contactids.add(c.contactid);
            ServiceIds.add(c.Service_Engineer__c);
            if(c.Assetid!=null){
                assetids.add(c.Assetid);
            }
            caseids.add(c.id);
            if(c.AOSI_Purchase_Date__c != null && c.AOSI_Asset_Purchase_Date__c == null){
               caseDateMap.put(c.id,c.AOSI_Purchase_Date__c);
            } 
            if(c.AOSI_Replaced_Asset__c != null){
                replacedAssetIds.add(c.AOSI_Replaced_Asset__c);
            }  
            if(c.Service_Engineer__c != Trigger.oldMap.get(c.id).Service_Engineer__c){
                serviceenggchanged = true;
            }
            if(c.Reason != Trigger.oldMap.get(c.id).Reason || c.Status != Trigger.oldMap.get(c.Id).Status || c.AssetId != Trigger.oldMap.get(c.Id).AssetId){
                statuschanged = true;
            }
            if(c.status == 'Closed'){
                caseclosed = true;
            }
            //aif((c.Reason.equalsIgnorecase('Color Panel (Free)') || c.Reason.equalsIgnorecase('Color Panel (Chargeable)')) && (c.status.equalsIgnorecase('Partially Closed') && c.status != Trigger.oldMap.get(c.Id).status) ){
            if((c.Reason.equalsIgnorecase('Color Panel (Free)') || c.Reason.equalsIgnorecase('Color Panel (Chargeable)')) && (c.Assignment_End_Time__c != Trigger.oldMap.get(c.Id).Assignment_End_Time__c || c.AOSI_Case_Close_Time__c != Trigger.oldMap.get(c.Id).AOSI_Case_Close_Time__c) ){
                panelcasepartialyclosed = true;
                panelcaseids.add(c.Id);
            }
        }                 
    }
   
    if(Trigger.isbefore)
    {                   
        //This block of code is to prevent updating case type to Color Panel Registration or Free Installation if the contact already has same case type registered
        //This block of code is only for AOS India Recordtype
        if(statuschanged){ 
        List<Case> PreviousCase = [Select id,contactid,CaseNumber,Reason,Assetid,AOSIProduct__c,status from Case where Status =:'Closed' and RecordTypeId =: rt.id and (Reason =:'Color Panel (Free)' OR Reason =:'Free Installation')and contactid IN : Contactids and Parentid =: null];
        List<Case> OpenCases = [Select id,contactid,CaseNumber,Reason,Assetid,AOSIProduct__c,status from Case where Status =:'Open' and RecordTypeId =: rt.id and contactid IN : Contactids and Parentid =: null];
        set<id> cid = new set<id>();
        for(Case c : trigger.new)
        {
             for(Case c1 : PreviousCase)
            {
               if(c.RecordTypeId == rt.id && c.contactid == c1.contactid && c.Reason == c1.Reason  && c.id != c1.id && c.Assetid == c1.Assetid && c.AOSIProduct__c == c1.AOSIProduct__c && c.status != 'Cancelled' && c.parentId==null)
               c.adderror('A case has already been registered for this contact regarding'+' '+c.Reason+'-With Case No '+c1.CaseNumber+' '+',Only one case can be registered with this reason for this Asset');
            }
            //Below If condition prevents creation of a new case of same reason and contact if there is already a open case for the same
            for(Case c1 : OpenCases)
            {
                              
                if(c.RecordTypeId == rt.id && c.contactid == c1.contactid && c.Reason == c1.Reason && c.id != c1.id && c.Assetid == c1.Assetid && c.AOSIProduct__c == c1.AOSIProduct__c && c.parentId==null)
                    c.adderror('A case has already been registered for this contact regarding'+' '+c.Reason+'-With Case No '+c1.CaseNumber+' '+'.To escalate the case click on Call escalated checkbox');
            }
        }}
        //end of code block for type restriction for same contact for AOS India Recordtype  
        
        //Below block of code is to prevent a service engineer being allocated more than 10 open cases at a time 
        if(serviceenggchanged){                 
        List<Service_Engineer__c > sevList = [select id,(select id,Service_Engineer__c,Reason from Cases__r where Reason !='Color Panel (Free)' AND Reason !='Color Panel (Chargeable)' AND Reason !='Sales Query' and Status =:'Open' and RecordTypeId =: rt.id) from Service_Engineer__c where id IN:ServiceIds];
        Map<id,Set<id>> SevCaseMap = new  Map<id,Set<id>>();
        for(Service_Engineer__c sev : sevList){
            for(case cs: sev.Cases__r){
                sevCaseids.add(cs.id);    
            }
            SevCaseMap.put(sev.id,sevCaseids); 
            //sevCaseids.clear();    
        }
        for(Service_Engineer__c sev : sevList){                                    
                     for(integer i=0; i<trigger.new.Size() ; i++){                             
                         if( sev.Cases__r.size()>=10 &&(!SevCaseMap.get(sev.id).contains(trigger.new[i].id))&& trigger.new[i].Service_Engineer__c != Null  && trigger.new[i].Reason !='Color Panel (Free)' && trigger.new[i].Reason !='Color Panel (Chargeable)' && trigger.new[i].Reason !='Sales Query' && trigger.old[i].Service_Engineer__c!= trigger.new[i].Service_Engineer__c && trigger.new[i].RecordTypeId == rt.id)
                         {
                           trigger.new[i].Service_Engineer__c.adderror('The Service Engineer is already having 10 open cases allocated to him, cannot allocate more cases to this service engineer');
                         }  
                     }
                  
        }
        //Code to prevent case assignment to the Service users who are not present on the day of Case creation
        List<Attendence__c> presentSEList = [select id, AOSI_Present__c,AOSI_Date__c,AOSI_Service_Engineer__c from Attendence__c where AOSI_Present__c = false and AOSI_Date__c =: system.today()];                             
        for(Case c : trigger.new){
            //Modified by : bhanu, Added below If loop so that service engineer validation is checked only if newly assigned or changed - 14 Jul 14
            if(c.Service_Engineer__c!=null && Trigger.oldmap.containskey(c.Service_Engineer__c) && !c.Service_Engineer__c.equals(Trigger.oldmap.get(c.id).Service_Engineer__c)){
                    for(Attendence__c at : presentSEList){                  
                        if(c.Service_Engineer__c == at.AOSI_Service_Engineer__c && c.RecordTypeId == rt.id){
                            c.adderror('Case cannot be assigned to service engineer who is absent for the day.');    
                        }
                    }
            }
        }}
        // code to update replaced product
        Map<id,Asset> assetMap = new Map<id,Asset>([Select id, Product2.Name from Asset where id IN: replacedAssetIds]);
        for(Case cs: Trigger.new){
            if(cs.RecordTypeId==rt.id && cs.AOSI_Replaced_Asset__c != null && assetMap.containsKey(cs.AOSI_Replaced_Asset__c) ){
                cs.AOSI_Replaced_Product__c = assetMap.get(cs.AOSI_Replaced_Asset__c).Product2.Name;
                
            }
        }
     }    
    if(Trigger.isafter)
    {
        //code to update responded time on child cases
        list<Case> childcases = new list<Case>();
        set<Id> parentids  = new set<Id>();
        set<Id> servenggid  = new set<Id>();
        for(Case ca : trigger.new){  
            //code added by bhanu
                if(ca.Assignment_Start_Time__c != Trigger.oldmap.get(ca.Id).Assignment_Start_Time__c && (ca.Reason =='Free Installation' || ca.Reason =='Chargeable Installation') && ca.ParentId==Null){
                parentids.add(ca.Id);
                servenggid.add(ca.Service_Engineer__c);
            }
               if(!servenggid.isempty() && !parentids.isempty()){
            boolean updatechild = false;
            childcases = [Select Id,Assignment_Start_Time__c,ParentId,Service_Engineer__c from case where parentid IN: parentids AND Service_Engineer__c IN: servenggid];
            //system.debug('childcases--->'+childcases.size());
            if(!childcases.isempty()){
                for(case childcase : childcases){
                    if(trigger.newmap.containskey(childcase.parentId) && childcase.Service_Engineer__c.equals(trigger.newmap.get(childcase.parentId).Service_Engineer__c) && childcase.Assignment_Start_Time__c==Null){
                        childcase.Assignment_Start_Time__c = Trigger.newMap.get(childcase.parentId).Assignment_Start_Time__c;
                        updatechild = true; 
                    }
                }
                if(updatechild){
                    RecursionMonitor.updated = false;
                    Database.update(childcases,false);
                }
            }
        }
        //end ocode to update responded time on child cases 
        if(caseclosed){
        System.debug('After Update'+Assetids.size());
        //Below block of code will update warranty registration date of related Asset For  warranty registration cases for AOS India Recordtype
        list<Asset> ast = [select id,Name,AOSI_Warranty_registration_Date__c,AOSI_Purchase_Value__c,PurchaseDate from Asset where id IN: assetids];   
        list<asset> newAsset = new List<asset>();
        list<asset> Purchasevalueupdate = new List<asset>();
        
          if((ca.Reason =='Warranty Registration' || ca.Reason =='Free Installation' || ca.Reason =='Chargeable Installation') && ca.RecordTypeId==rt.id && ca.status=='Closed')
            {                
                for(Asset at : ast){            
                    if(ca.Assetid!=Null && ca.Assetid == at.id){            
                        if(at.PurchaseDate!=Null)
                        if((at.PurchaseDate).daysBetween(date.newinstance(ca.CreatedDate.year(), ca.CreatedDate.month(), ca.CreatedDate.day()))<= 60){
                            at.AOSI_Warranty_registration_Date__c = system.today();
                            newAsset.add(at);                        
                        }
                    } 
                }        
            }
            // this block is update the purchase value from case to asset
            if(ca.Reason =='Free Installation' && ca.status=='Closed' && ca.RecordTypeId == rt.id && ca.AOSI_Purchase_Value__c!=null){
                for(Asset at : ast){ 
                      if(at.AOSI_Purchase_Value__c==null || at.AOSI_Purchase_Value__c==0){
                        at.AOSI_Purchase_Value__c=ca.AOSI_Purchase_Value__c;       
                    }                    
                }
            }
            if((ca.Reason =='Free Installation' || ca.Reason =='Chargeable Installation') && ca.status=='Closed' && ca.RecordTypeId == rt.id && ca.AOSI_Purchase_Date__c != null){
                for(Asset at : ast){
                    System.debug('Case Date++'+ ca.AOSI_Asset_Purchase_Date__c);
                    if(!caseDateMap.IsEmpty()){
                        at.PurchaseDate = caseDateMap.get(ca.id);
                        Purchasevalueupdate.add(at); 
                    }
                }   
            }
        if(!newAsset.isempty())
        update newAsset;
        if(!Purchasevalueupdate.isempty())
        update Purchasevalueupdate;
        
        }
        //end of code for updating warranty registration of realted asset.}
        //code to change owner to RCC login for panle case partially closed
        if(panelcasepartialyclosed){
            Casereassignmenthelper.changeowner(panelcaseids);
        }
        
    }}  
}