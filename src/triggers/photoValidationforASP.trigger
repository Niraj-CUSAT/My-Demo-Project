/********************************************************************************
Created by    :    Shweta Kumari, KVP Business Solutions
Created On    :    26th feb 2014
Description   :    Trigger to validate if photo is attached for particular ASP before sending it for approval   
*********************************************************************************/

trigger photoValidationforASP on Attachment (before insert,before Update,after delete) {
    set<id> aspIds = new set<id>();
    set<id> allAspIds = new set<id>(); 
    map<id,Attachment> attachMap = new map<id,Attachment>();
    list<ASP__c> aspList = new list<ASP__c>();
    if(trigger.Isinsert || trigger.isupdate){
        //check Attachment is Image and add the attachment parenid in a set
        for(Attachment att : trigger.new){
            if(att.Name.contains('.jpg')||att.Name.contains('.gif')||att.Name.contains('.bmp')||att.Name.contains('.png')||att.Name.contains('.jpeg')){
                aspIds.add(att.ParentId);    
            }             
        }
        //quary to get all ASP related to Attachment
        aspList = [Select id,AOSI_Attachment__c,AOSI_Approval_Status__c from ASP__c where AOSI_Approval_Status__c = 'Submit For Approval' AND Id IN: aspIds AND AOSI_Attachment__c = false];
        //code to update attachment checkbox in ASP
        if(aspList.size()> 0){
            for(ASP__c asp : aspList){
                asp.AOSI_Attachment__c = true;
            }
            try{
                database.update(aspList);
            }
            catch(exception e){
                system.debug('-------e--------'+ e);
            }
        }
    }
    if(trigger.isDelete){
        //check Attachment is Image and add the attachment parenid in a set
        for(Attachment att : trigger.old){
            if(att.Name.contains('.jpg')||att.Name.contains('.gif')||att.Name.contains('.bmp')||att.Name.contains('.png')||att.Name.contains('.jpeg')){
                aspIds.add(att.ParentId);    
            }             
        } 
        //quary to get all ASP related to Attachment
        aspList = [Select id,AOSI_Attachment__c,AOSI_Approval_Status__c from ASP__c where AOSI_Approval_Status__c = 'Submit For Approval' AND Id IN: aspIds AND AOSI_Attachment__c = true]; 
        //code to update attachment checkbox in ASP
        if(aspList.size()> 0){
            for(ASP__c asp : aspList){
                allAspIds.add(asp.id);   
            }            
        }
        //list of all attachemt related to ASP
        list<Attachment> attachList = [Select id , name,ParentId from Attachment where  (name LIKE '%.jpg' or Name like '%.gif' or Name like '%.bmp'or Name like '%.png'or Name like '%.jpeg') AND parentid IN: allAspIds];       
        for(Attachment attach : attachList) {
            attachMap.put(attach.Parentid,attach);    
        }
        //check if particular ASP have attachment with (.jpg,.png,.gif,.bmp,.jpeg) file
        for(ASP__c asp : aspList){        
            if(!attachMap.containsKey(asp.id)){
                asp.AOSI_Attachment__c = false;
            }
            try{
                database.update(aspList);
            }
            catch(exception e){
                system.debug('-------e--------'+ e);
            } 
        } 
    }
}