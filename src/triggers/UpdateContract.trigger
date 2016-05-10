/********************************************************************************
Created by    :    Vishwanath Attikere, KVP Business Solutions
Created On    :    22nd Feb 2014
Modified by   :    Shweta Kumari, KVP Business Solutions    
Modified on   :    24th Feb 2014
Description   :    Trigger to Update ASP pin with key from Incoming SMS
*********************************************************************************/

trigger UpdateContract on smagicinteract__Incoming_SMS__c ( before insert,before update) {
    String AMCtype = '';
    List<String> parts = new List<string>(); 
    String caseNo;
    String key;
    String mobileNo;
    list<Case> caseList = new List<Case>();
    set<id> contactIds = new set<id>();
    Map<String , string> keymap = new Map<String , string>();
    //code to get key and case number from incoming SMS     
    for(smagicinteract__Incoming_SMS__c SMS:Trigger.new){ 
        system.debug('-------SMS.smagicinteract__SMS_Text__c----'+ SMS.smagicinteract__SMS_Text__c);           
       // if(!SMS.smagicinteract__SMS_Text__c.containsIgnoreCase('Start') && !SMS.smagicinteract__SMS_Text__c.containsIgnoreCase('Stop') && !SMS.smagicinteract__SMS_Text__c.containsIgnoreCase('Yes') && !SMS.smagicinteract__SMS_Text__c.containsIgnoreCase('No') && !SMS.smagicinteract__SMS_Text__c.containsIgnoreCase('No') && !SMS.smagicinteract__SMS_Text__c.containsIgnoreCase('COMPLETE')){
         if(SMS.smagicinteract__SMS_Text__c.startswithIgnoreCase('AMC') || SMS.smagicinteract__SMS_Text__c.startswithIgnoreCase('ACMC') || SMS.smagicinteract__SMS_Text__c.startswithIgnoreCase('FLT')){
            AMCtype=SMS.smagicinteract__SMS_Text__c;  
            system.debug('-------AMCtype----'+ AMCtype);
            mobileNo = SMS.smagicinteract__Mobile_Number__c.substring(2);                      
            if(AMCtype.length()>0){  
                parts = AMCtype.split(' ');
                system.debug('-------parts ----'+ parts );               
                caseNo =parts[parts.size()-1];
                key = parts[0]+ ' ' +parts[1];
                keymap.put(caseNo , key);                                
            }
        }
    }
    //code to update AMC PIn with key for paticular Casenumber 
    if(!keymap.isEmpty()){
        caseList = [Select id,CaseNumber,AOSI_AMC_Pin__c,ContactId,Reason ,AOSI_Contract_Pin_Registration_Time__c from case where CaseNumber IN: keymap.keySet()];          
        for(case cs : caseList){
            contactIds.add(cs.contactId);
        }
        map<id, contact> contactMap = new map<id, contact>([Select id,Phone,OtherPhone from contact where id IN: contactIds]);
        for(Case cs: caseList){
        system.debug('---------mobileNo----------'+ mobileNo);
        system.debug('-------contactMap.get(cs.contactId).phone-------'+ contactMap.get(cs.contactId).phone);
            if(keymap.containsKey(cs.CaseNumber)&& cs.AOSI_AMC_Pin__c == null && cs.Reason == 'Contract Request' && (mobileNo == contactMap.get(cs.contactId).phone || mobileNo == contactMap.get(cs.contactId).OtherPhone)){
                cs.AOSI_AMC_Pin__c = keymap.get(cs.CaseNumber); 
                cs.AOSI_Contract_Pin_Registration_Time__c = System.Now();
            }  
        }   
        //code to update List
        try{
            database.update(caseList, false);
        }
        Catch(Exception e){
            System.debug('--------e-------------'+ e);
        }
    }
}