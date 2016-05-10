public class Promoteralbum {
    public list<ISP_Store_Album__c> storealbumlist {get;set;}
    public Promoteralbum(){
        storealbumlist = new list <ISP_Store_Album__c>();
        storealbumlist = [SELECT id,Name,Approval_Status__c,From__c,To__c,Store_Location__c from ISP_Store_Album__c WHERE CreatedDate = LAST_N_DAYS:7 ORDER BY CreatedDate DESC];
    }

}