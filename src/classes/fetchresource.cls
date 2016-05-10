public class fetchresource {
    public Case vfCase;
    public List<Service_Engineer__c> lstResource{get;set;}
    
    public fetchresource(ApexPages.StandardController stdController) {
            this.vfCase = (Case)stdController.getRecord();
            lstResource = new List<Service_Engineer__c>();
            System.debug('case info----------->'+vfCase.contact.Pincode__c);
          //  lstResource = [SELECT Name,OwnerId,PIN_Code__c,Type__c FROM Service_Engineer__c WHERE PIN_Code__c =:vfCase.contact.Pincode__c];  
            System.debug('---------->'+lstResource);
            
            
            list<Attendence__c> att = new list<Attendence__c>();
          att= [select id,AOSI_Service_Engineer__c from Attendence__c where AOSI_Present__c=true];
        set<id> id1 = new set<id>();
           for(Attendence__c att1 : att){
                id1.add(att1.AOSI_Service_Engineer__c);
                System.debug('---------->'+id1);
    }
     lstResource = [SELECT Name,OwnerId,PIN_Code__c,Type__c FROM Service_Engineer__c WHERE PIN_Code__c =:vfCase.contact.Pincode__c and id IN: id1];
     
}
}