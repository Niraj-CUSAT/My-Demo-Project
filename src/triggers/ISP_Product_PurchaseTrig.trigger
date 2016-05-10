trigger ISP_Product_PurchaseTrig on ISP_Product_Purchase__c (before insert,before update,after insert, after update,after delete,  after undelete ) {

   if(Trigger.isBefore){
       list<ISP_Target__c> targetList = new list<ISP_Target__c>();
       Map<id,string>  promoterIdsMap = new Map<id,string>();
       set<id> customerIds = new set<id>();
       
       for(ISP_Product_Purchase__c pp : trigger.new){
           customerIds.add(pp.customer__c);
       }
       
       //Getting Promoters from customer
       for(contact con : [select id, ownerId from contact where id in:customerIds]){
           //promoterIds.add(con.ownerId);
           promoterIdsMap.put(con.id,con.ownerId);
       }
       
       //Getting target records from Target objects
       targetList = [select id,Product__c,Assigned_To__c,To_date__c,From_date__c from ISP_Target__c where Assigned_To__c in :promoterIdsMap.values()];
       
       //Linking the purchase with corresponding target
       for(ISP_Target__c target : targetList){
          
          for(ISP_Product_Purchase__c pp : trigger.new){
              if(!promoterIdsMap.isEmpty() && promoterIdsMap.containsKey(pp.Customer__c)){
              
                   if(target.Assigned_To__c == promoterIdsMap.get(pp.Customer__c) 
                      && pp.ISP_Product__c  == target.product__c 
                      && pp.Date_of_Purchase__c <= target.To_date__c
                      && pp.Date_of_Purchase__c >= target.From_date__c){
                      
                              pp.Target__c = target.id; 
                   
                   }//end of if
              }//end of if
          }//end of for
       }//end of for
       
   }//End of isBefore
   
   
   //Rollup Summary of Total Items sold on target Object
   if(Trigger.isAfter){
   
          set<id> targetIds = new set<id>();
          if(trigger.isInsert || trigger.isUpdate){
            for(ISP_Product_Purchase__c pp : trigger.new){
              targetIds .add(pp.target__c);
            }
          }
         
          //When deleting 
          if(trigger.isDelete){
            for(ISP_Product_Purchase__c pp : trigger.old){
              targetIds.add(pp.target__c);
            }
          }
          
          //Map will contain target id along with sum value
          map<id, Double> targetMap = new map<id, Double>();
         
          //Produce a sum of Payments__c and add them to the map
          //use group by to have a single Opportunity Id with a single sum value
          for(AggregateResult q : [select target__c ,sum(Number_of_units_sold__c)
                                  from ISP_Product_Purchase__c where target__c IN :targetIds group by target__c]){
              targetMap.put((Id)q.get('target__c'),(Double)q.get('expr0'));
          }
         
          List<ISP_Target__c> updateTargetlist = new List<ISP_Target__c>();
          for(ISP_Target__c tar : [Select Id,target_Actulas__c from ISP_Target__c where Id IN :targetIds]){
            
            Double soldSum        = targetMap.get(tar.Id);
            tar.Target_Actulas__c = soldSum;
            updateTargetlist.add(tar);
          }
         
          //Update the targets
          if(!updateTargetlist.isEmpty()){
              update updateTargetlist;
          }
          
          if(trigger.isdelete){
              //Calling Handler class method to update demo promoter target record with number of purchases.
              ISP_DemoRequestTrigHandlerCls.updateDemoPromTargetWithPurchases(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, new set<id>(), Trigger.OldMap.keyset());
          }else{
             ISP_DemoRequestTrigHandlerCls.updateDemoPromTargetWithPurchases(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.NewMap.keyset(), new set<id>());
          }
    }//End of IsAfter
    
}