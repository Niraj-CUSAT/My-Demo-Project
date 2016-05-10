/********************************************************************************
Created by    :    Shweta Kumari, KVP Business Solutions
Created On    :    16th Jan 2014
Description   :    Trigger to Update Agreement date of Approved ASP 
*********************************************************************************/
trigger ASPAutoNoBeforeUpdate on ASP__c (Before Update,Before Insert) {
    
    set<String> citymaster=new set<String>();
    if(Trigger.isinsert || Trigger.isupdate){
        for(ASP__c ap : Trigger.New){
            ap.AOSI_SYS_service_Detail__c=ap.AOSI_Service_detail__c;
            citymaster.add(ap.AOSI_City_Master__c);
        }    
    }
    if(Trigger.isinsert){
        for(ASP__c ap : Trigger.New){
            ap.AOSI_Agreement_Auto_No__c = 0;           
            ap.AOSI_Agreement_Number__c = '';
        }    
    }
    if(Trigger.isUpdate){   
        Set<id> userID = new Set<id>();
        ASP__c maxAspAgreementNo = new ASP__c();
        integer maxNo = 0;     
        //code to get the rcord with highest number of Agreement date
        try{
            maxAspAgreementNo = [Select id,AOSI_Agreement_Number__c from ASP__c Where AOSI_Agreement_Number__c != null AND AOSI_Approval_Status__c =: 'Approved' AND AOSI_Agreement_Auto_No__c != null order by AOSI_Agreement_Auto_No__c desc limit 1];    
        }
        Catch(Exception e){}    
        //code to remove ASP- from Agreement no and convert it into Integer
        if(maxAspAgreementNo.AOSI_Agreement_Number__c != null ){
            maxNo = Integer.valueof(maxAspAgreementNo.AOSI_Agreement_Number__c.substring(8));           
        }
        // initialize the newNo with the +1 of max Agreement no
        integer newNo = maxNo+1; 

        //code to update agreement no     
        for(ASP__c ap : Trigger.New){
            // check if ASP is Approved and Agreement Number is null
            if(ap.AOSI_Active__c == true && trigger.oldmap.get(ap.id).AOSI_ASP_User__c != trigger.newmap.get(ap.id).AOSI_ASP_User__c && ap.AOSI_ASP_User__c != null){
              userID.add(ap.AOSI_ASP_User__c);
             }              
            if(ap.AOSI_Approval_Status__c == 'Approved' && ap.AOSI_Agreement_Number__c == null){ 
                //code to update Agreement no in the formate of ASP- and increment the newNo
                if(newNo < 10){                
                    ap.AOSI_Agreement_Auto_No__c = newNo;           
                    ap.AOSI_Agreement_Number__c = 'AOS/SVC/000'+string.valueof(newNo);
                } 
                else if(newNo < 100){               
                    ap.AOSI_Agreement_Auto_No__c = newNo;            
                    ap.AOSI_Agreement_Number__c = 'AOS/SVC/00'+string.valueof(newNo);
                }
                else if(newNo < 1000){             
                    ap.AOSI_Agreement_Auto_No__c = newNo;            
                    ap.AOSI_Agreement_Number__c = 'AOS/SVC/0'+string.valueof(newNo);
                }
                else{           
                    ap.AOSI_Agreement_Auto_No__c = newNo;  
                    ap.AOSI_Agreement_Number__c = 'AOS/SVC/'+string.valueof(newNo);
                }                  
            }        
        } 
        if(!userID.IsEmpty()){
                set<id> assigUId = new Set<id>();
                list<user> assignedAspList = [Select id,name from user where id IN:userID];
                for(user u :assignedAspList)   
                  assigUId.add(u.id);
                List<ASP__c> aspList = [Select id,AOSI_ASP_User__c,AOSI_Active__c from ASP__c where id IN:assigUId AND AOSI_Active__c =:true ];
                for(ASP__c ap : Trigger.New )
                if(!aspList.Isempty())
                ap.adderror('You Cannot assign this ASP for this user');
         }          
    }
     if(!citymaster.isempty()){
        for(City_Master__c CM:[select id,name,AOSI_Region__c,AOSI_State__c from City_Master__c where id=:citymaster]){
            for(ASP__c ap : Trigger.New){
                if(CM.id==ap.AOSI_City_Master__c){
                    ap.AOSI_Region__c=CM.AOSI_Region__c;
                    ap.AOSI_State__c=CM.AOSI_State__c;
                    ap.AOSI_City__c=CM.Name;
                }
            }
        }
    }
    
}