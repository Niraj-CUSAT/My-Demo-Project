/********************************************************************************
Created by    :    Bhanu Vallabhu, KVP Business Solutions
Created On    :    13 Feb 2013
Modified by   :    Shweta Kumari, KVP Business Solutions    
Modified on   :    28th Feb 2014

*********************************************************************************/

trigger CaseAfterBeforeInsert on Case (before Insert, after Insert){   
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype 
    set<id> assetids = new set<id>();
    set<id> caseids = new set<id>();
    set<id> ServiceIds = new set<id>();
    set<id> Contactids = new set<id>();
    Boolean flag = false;
    Boolean aspcheck=false;
    for(Case c: Trigger.new){
        if(c.recordtypeid == rt.id){            
            assetids.add(c.Assetid);
            ServiceIds.add(c.Service_Engineer__c);
            Contactids.add(c.contactid);
            caseids.add(c.id);
        }
    } 
    list<Asset> ast = [select id,Name,product2id,AOSI_Warranty_registration_Date__c,PurchaseDate from Asset where id IN: assetids];
    if(Trigger.isbefore){
        //list<Asset> ast = [Select id,product2id from Asset where id IN:assetids]; 
        for(Case c: Trigger.new){
            for(Asset a : ast){
                if(c.RecordTypeId == rt.id && c.Assetid !=Null && c.Assetid == a.id){                    
                    c.AOSIProduct__c = a.product2id;
                    
                }
                    if(Trigger.isInsert){
                        c.Assignment_Start_Time__c = null;
                        c.Assignment_End_Time__c = null;
                        c.AOSI_Response_Clock_Time__c = null;
                        c.AOSI_Resolution_Clock_Time__c = null;
                        c.AOSI_Job_Clock_Time__c = null;
                        c.AOSI_Response_Time_New__c = null;
                        c.AOSI_Resolution_Time_New__c  = null;
                        c.AOSI_Job_Time_New__c = null;
                        c.Service_Engineer__c = null;
                        c.AOSI_Cancelled_On_HOLD_Reason__c = null;
                        c.AOSI_Appointment_Date__c = null;
                        c.AOSI_Case_Close_Time__c = null;
                        c.AOSI_Cancelled_On_HOLD_Reason__c = null;
                    }
            }
        }
        //This block of code is to prevent creation of new case of type Color Panel Registration if the contact already has same case type registered
        //This block of code is only for AOS India Recordtype                        
        List<Case> PreviousCase = [Select id,contactid,CaseNumber,Reason,Assetid,AOSIProduct__c,status  from Case where Status =:'Closed' and RecordTypeId =: rt.id and (Reason =:'Color Panel (Free)' OR Reason =:'Free Installation') and contactid IN : Contactids and Parentid =: null];        
        List<Case> OpenCases = [Select id,contactid,CaseNumber,Reason,Assetid,AOSIProduct__c,status from Case where Status =:'Open' and RecordTypeId =: rt.id and contactid IN : Contactids and Parentid =: null];                  
        set<id> cid = new set<id>();
        for(Case c : trigger.new){
            for(Case c1 : PreviousCase){
                if(c.RecordTypeId == rt.id && c.contactid == c1.contactid && c.Reason == c1.Reason  && c.id != c1.id && c.Assetid == c1.Assetid &&  c.AOSIProduct__c == c1.AOSIProduct__c && c.status != 'Cancelled' && c.parentId==null)
                    c.adderror('A case has already been registered for this contact regarding'+' '+c.Reason+'-With Case No '+c1.CaseNumber+' '+',Only one case can be registered with this reason for this Asset');            
            }
            for(Case c1 : OpenCases){
                if(c.RecordTypeId == rt.id && c.contactid == c1.contactid && c.Reason == c1.Reason && c.id != c1.id &&  c.Assetid == c1.Assetid && c.AOSIProduct__c == c1.AOSIProduct__c && c.parentId==null && c.parentId==null)
                    c.adderror('A case has already been registered for this contact regarding'+' '+c.Reason+'-With Case No '+c1.CaseNumber+' '+'.To escalate the case click on Call escalated checkbox');                        
            }
        }
        //end of code block for type restriction for same contact for AOS India Recordtype  
        //Below block of code is to prevent a service engineer being allocated more than 10 open cases at a time                   
        list<Service_Engineer__c> servList = [select id,(select id,Service_Engineer__c,Reason from Cases__r where Reason !='Color Panel (Free)' AND Reason !='Color Panel (Chargeable)' AND Reason !='Sales Query' and Status =:'Open' and RecordTypeId =: rt.id) from Service_Engineer__c where id IN:ServiceIds];    
        for(Service_Engineer__c sev : servList  ){                
            for(case ca: trigger.new){           
                if( sev.Cases__r.size()>=10 && ca.Service_Engineer__c != Null  && ca.Reason !='Color Panel (Free)' && ca.Reason !='Color Panel (Chargeable)' && ca.Reason !='Sales Query' && ca.RecordTypeId == rt.id){                    
                    ca.Service_Engineer__c.adderror('The Service Engineer is already having 10 open cases allocated to him, cannot allocate more cases to this service engineer');
                }  
            }                
        }
        //end of code block for restricting 10 cases per service engineer
        //Code to prevent case assignment to the Service users who are not present on the day of Case creation
        List<Attendence__c> presentSEList = [select id, AOSI_Present__c,AOSI_Date__c,AOSI_Service_Engineer__c from Attendence__c where AOSI_Present__c = false and AOSI_Date__c =: system.today()];                
        for(Case c : trigger.new){
            for(Attendence__c at : presentSEList){
                if(c.Service_Engineer__c == at.AOSI_Service_Engineer__c && c.RecordTypeId == rt.id){
                    c.adderror('Case cannot be assign to service engineer who is absent for the day.');    
                }
            }
        }
        }
        if(Trigger.isafter){
        system.debug('--------inside after----------');
        List<Case> caseList = [select id,contactid,ownerid,RecordTypeId,reason from case where id IN: caseids];
       // Recordtype rtASP = [Select id,name from recordtype where DeveloperName =:'ASP_Pin' and SobjectType =:'PIN_Allocation__c' limit 1]; //recordtype ASP Pin for validating Pin Allocation recordtype         
        List<Case> newCaseList = new List<Case>();  
        List<PIN_Allocation__c > ASPPinList = new List<PIN_Allocation__c >();
        Set<id> aspId = new Set<id>();
        Map<id,contact> ConList = new Map<id,contact>([select id,MailingPostalCode,AOSI_Region__c from contact where id IN: Contactids]);
        User RCCListNorth;
        User RCCListEast;
        User RCCListSouth;
        User RCCListWest;
        try{
            RCCListNorth =  [select id from user where UserRoleId in (Select id from UserRole where DeveloperName =: 'Regional_Call_Coordinator_North')and isactive =: true limit 1];
        }
        catch(Exception e){}
        try{
            RCCListEast =  [select id from user where UserRoleId in (Select id from UserRole where DeveloperName =: 'Regional_Call_Coordinator_East')and isactive =: true limit 1];
        }
        catch(Exception e){}   
        try{  
            RCCListSouth  =  [select id from user where UserRoleId in (Select id from UserRole where DeveloperName =: 'Regional_Call_Coordinator_South')and isactive =: true limit 1];
        }
        catch(Exception e){}
        try{
            RCCListWest =  [select id from user where UserRoleId in (Select id from UserRole where DeveloperName =: 'Regional_Call_Coordinator_West')and isactive =: true limit 1];
        }
        catch(Exception e){}
        
        list<String> lstCaseCity1 = new list<String>();
        set<String> mallingideSet = new set<String>();
        map<id, string> Region = new map<id, string>() ;
        for(Contact con : ConList.values()){
            mallingideSet.add(con.MailingPostalCode);            
        } 
        
        List<ASP__c> asplist=new List<ASP__c>();
        User adminId = [Select id from User where Name =: 'Digamber Bahuguna' limit 1];      
  
       // else{
            if(!ConList.Isempty()){
                ASPPinList = [select ASP__c,PIN__c,ASP_User_Profile__c,ASP__r.IsActive from PIN_Allocation__c where PIN__c IN: mallingideSet ];
                set<id> aspuserid=new set<id>();
                for(PIN_Allocation__c asppin:ASPPinList){
                    if(asppin.ASP_User_Profile__c=='ASP AOSI'){
                        aspuserid.add(asppin.ASP__c);
                    }
                }
                if(!aspuserid.isempty()){
                    asplist=[select id,AOSI_ASP_User__c,AOSI_Service_detail__c from ASP__c where AOSI_ASP_User__c=:aspuserid];
                }
                for(Case c : caseList ){            
                    if(c.RecordTypeId == rt.id){
                        if(c.Reason !='Sales Query'){
                            for(PIN_Allocation__c pin : ASPPinList){
                                if(ConList.get(c.contactid).MailingPostalCode == pin.PIN__c && ConList.containsKey(c.contactid) && pin.ASP_User_Profile__c=='ASP AOSI'){
                                    if(!asplist.isempty()){
                                        for(ASP__c asp:asplist){
                                            if(pin.ASP__c==asp.AOSI_ASP_User__c && asp.AOSI_Service_detail__c.contains(c.reason) && pin.ASP__r.IsActive){
                                                c.Ownerid = pin.ASP__c;
                                                flag = true;  
                                                aspcheck=true;
                                            }
                                        }
                                    }
                                }
                                if(aspcheck==false && ConList.get(c.contactid).MailingPostalCode == pin.PIN__c && ConList.containsKey(c.contactid) && pin.ASP_User_Profile__c!='ASP AOSI' && pin.ASP__r.IsActive){
                                    if(pin.ASP__c!=null){
                                        c.Ownerid = pin.ASP__c;
                                        flag = true; 
                                    }
                                }
                            }
                        }                            
                            
                            if(flag == false){                                                                                              
                                If(ConList.get(c.contactid).AOSI_Region__c == 'North'){                        
                                    if(RCCListNorth != null){
                                        system.debug('=====RCCListNorth');
                                        c.Ownerid = RCCListNorth.id;                                      
                                    }                         
                                }
                                else If(ConList.get(c.contactid).AOSI_Region__c == 'East'){                        
                                    if(RCCListEast != null){
                                        system.debug('=====RCCListEast');
                                        c.Ownerid = RCCListEast.id;                                        
                                    }                         
                                }
                                else If(ConList.get(c.contactid).AOSI_Region__c == 'South'){                        
                                    if(RCCListSouth != null){
                                        system.debug('=====RCCListsouth');
                                        c.Ownerid = RCCListSouth.id;                                        
                                    }                        
                                }
                                else If(ConList.get(c.contactid).AOSI_Region__c == 'West'){                        
                                    if(RCCListWest != null){
                                        system.debug('=====RCCListwest');
                                        c.Ownerid = RCCListWest.id;                                       
                                    }
                                }                    
                            }                                              
                    }
                } 
            }           
        //}
        system.debug('----caseList-----'+caseList);
        update caseList;
        RecursionMonitor.updated = false;    
        //validation for Appointment date should be in between working hours (8 AM - 8 PM)
          
        list<asset> newAsset = new List<asset>();
        for(Case ca : trigger.new){       
            if((ca.Reason =='Warranty Registration' || ca.Reason =='Free Installation' || ca.Reason =='Chargeable Installation') && ca.RecordTypeId==rt.id && ca.status=='Closed'){                
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
        }
        update newAsset;  
    }
}