/*
Created By: Dheeraj Gangulli
Created Date: 21/04/2016
Last Modified By: Dheeraj Gangulli
Last Modified Date: 21/04/2016
Description: This trigger is used to set the values of region, state, pincode etc,....
             Values are set based on the selected locality or pincode. This trigger is used only for AOS_India record type.
             (Optimized ContactUpadteRegion Trigger)
*/
trigger AOSI_updateAddressInfo on Contact (before insert, before update) {

    Set<Id> pincCodeIdSet = new Set<Id>(); //to hold the pincode Ids
    Set<Id> localityIdSet = new Set<Id>(); //to hold the locality Ids
    Map<Id, Pin_Master__c> pincodeMap;  // to store the pin master details
    Map<Id, Locality__c> localityMap;  // to store the locality details
    Id conRecTypeId; //which stores the recordtype Id
    
    try{
        Schema.DescribeSObjectResult d = Schema.SObjectType.Contact;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        conRecTypeId =  rtMapByName.get('AOS India').getRecordTypeId();
    }Catch(Exception e){}
    
    //adding locality and pincode ids to the sets.
    for(Contact con: trigger.New){
        pinccodeIdSet.add(con.AOSI_Pin_Code__c);
        localityIdSet.add(con.AOSI_Locality__c);
    }
    
    pincodeMap =  new Map<Id, Pin_Master__c>( [SELECT Id, AOSI_City__c, AOSI_Region__c, AOSI_State__c, AOSI_Area__c, AOSI_Country__c, AOSI_Street__c, Name 
                    FROM Pin_Master__c 
                    WHERE Id IN: pinccodeIdSet]);
    
    localityMap = new Map<Id, Locality__c>( [SELECT Id, Name, AOSI_Pin_Master__c, AOSI_Pin_Master__r.Name, AOSI_Pin_Master__r.AOSI_City__c, AOSI_Pin_Master__r.AOSI_State__c, AOSI_Pin_Master__r.AOSI_Region__c, AOSI_Pin_Master__r.AOSI_Country__c 
                    FROM Locality__c 
                    WHERE Id IN: localityIdSet]);
                    
    for(Contact con : trigger.New){
        if(con.RecordTypeId == conRecTypeId){
            if(con.AOSI_Locality__c != null){
                if(!localityMap.isEmpty() && localityMap.containsKey(con.AOSI_Locality__c) && localityMap.get(con.AOSI_Locality__c) != null){
                    if(con.MailingStreet != null && !con.MailingStreet.contains(localityMap.get(con.AOSI_Locality__c).Name) ){                
                        con.MailingStreet = con.MailingStreet + ' ' +localityMap.get(con.AOSI_Locality__c).Name ;
                    } 
                    else if(con.MailingStreet == null){
                         con.MailingStreet = localityMap.get(con.AOSI_Locality__c).Name ;
                    }                          
                    con.MailingCity = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_City__c;
                    con.MailingState = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_State__c;
                    con.AOSI_State__c = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_State__c;
                    con.AOSI_Region__c = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_Region__c; 
                    con.MailingPostalCode = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__r.Name; 
                    con.MailingCountry = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__r.AOSI_Country__c; 
                    con.AOSI_Pin_Code__c = localityMap.get(con.AOSI_Locality__c).AOSI_Pin_Master__c;
                }
            } else{
                if(!pincodeMap.isEmpty() && pincodeMap.containsKey(con.AOSI_Pin_Code__c) && pincodeMap.get(con.AOSI_Pin_Code__c) != null){
                    con.MailingCity = pincodeMap.get(con.AOSI_Pin_Code__c).AOSI_City__c;
                    con.MailingState = pincodeMap.get(con.AOSI_Pin_Code__c).AOSI_State__c;
                    con.AOSI_State__c = pincodeMap.get(con.AOSI_Pin_Code__c).AOSI_State__c;
                    con.AOSI_Region__c = pincodeMap.get(con.AOSI_Pin_Code__c).AOSI_Region__c; 
                    con.MailingPostalCode = pincodeMap.get(con.AOSI_Pin_Code__c).Name; 
                    con.MailingCountry = pincodeMap.get(con.AOSI_Pin_Code__c).AOSI_Country__c;
                }
            }
        } //end of if condition (record type checking)
    } //end of trigger.New loop

}