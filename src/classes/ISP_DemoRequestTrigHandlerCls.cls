public Class ISP_DemoRequestTrigHandlerCls{

   public static void updateRecWithTarget(list<ISP_Demo_Request__c> newList){
   
       list<ISP_Target__c> targetList = new list<ISP_Target__c>();
       set<id> promoterIds = new set<id>();
       
       for(ISP_Demo_Request__c pp : newList){
           promoterIds.add(pp.ownerId);
       }
       

       //Getting target records from Target objects
       targetList = [select id,Product__c,Assigned_To__c,To_date__c,From_date__c from ISP_Target__c where Assigned_To__c in :promoterIds];
       
       //Linking the purchase with corresponding target
       for(ISP_Target__c target : targetList){
          
          for(ISP_Demo_Request__c pp : newList){	
              
                   Date pDate = date.valueOf(pp.Customer_Prefered_Time__c);
                   if(target.Assigned_To__c == pp.ownerId 
                      && pDate <= target.To_date__c
                      && pDate >= target.From_date__c){
                      
                      
                              pp.Target__c = target.id; 
                              
                   
                   }//end of if
                   
          }//end of for
       }//end of for
   }
   
   
   public Static void updateTargetRecords(Boolean isInsert, Boolean isUpdate, boolean isDelete, list<ISP_Demo_Request__c> newList , list<ISP_Demo_Request__c> oldList){
          set<id> targetIds = new set<id>();
          if(isInsert || isUpdate){
            for(ISP_Demo_Request__c  pp : newList){
              targetIds.add(pp.target__c);
            }
          }
         
          //When deleting 
          if(isDelete){
            for(ISP_Demo_Request__c pp : oldList){
              targetIds.add(pp.target__c);
            }
          }
          
          //Map will contain target id along with sum value
          map<id, Double> targetMap = new map<id, Double>();
         
          //Produce a sum of Payments__c and add them to the map
          //use group by to have a single Opportunity Id with a single sum value
          for(AggregateResult q : [select target__c , count(id)
                                  from ISP_Demo_Request__c where target__c IN :targetIds group by target__c]){
              targetMap.put((Id)q.get('target__c'),(Double)q.get('expr0'));
          }
         
          List<ISP_Target__c> updateTargetlist = new List<ISP_Target__c>();
          for(ISP_Target__c tar : [Select Id,No_of_Demo_Requests__c from ISP_Target__c where Id IN :targetIds]){
            
            Double soldSum             = targetMap.get(tar.Id);
            tar.No_of_Demo_Requests__c = soldSum;
            updateTargetlist.add(tar);
          }
         
          //Update the targets
          if(!updateTargetlist.isEmpty()){
              update updateTargetlist;
          }
   }
   
 /*  
   public Static void updateDemoPromTargetWithPurchases(Boolean isInsert, Boolean isUpdate, boolean isDelete, set<id> newKeySet , set<id> oldKeySet){
          set<id> targetIds = new set<id>();
          
          if(isInsert || isUpdate){
            for(ISP_Product_Purchase__c  pp : [select id,Demo_Request__r.target__c from ISP_Product_Purchase__c where id in: newKeySet]){
              targetIds.add(pp.Demo_Request__r.target__c);
            }
          }
           system.debug('****newKeySet******'+newKeySet);
          //When deleting 
          if(isDelete){
            for(ISP_Product_Purchase__c  pp : [select id,Demo_Request__r.target__c from ISP_Product_Purchase__c where id in: oldKeySet]){
              targetIds.add(pp.Demo_Request__r.target__c);
            }
          }
          
           system.debug('****oldKeySet******'+oldKeySet);
           system.debug('****targetIds******'+targetIds);
           
          //Map will contain target id along with sum value
          map<id, Double> targetMap = new map<id, Double>();
         
          //Produce a sum of Payments__c and add them to the map
          //use group by to have a single Opportunity Id with a single sum value
          for(AggregateResult q : [select Demo_Request__r.target__c , count(id)
                                  from ISP_Product_Purchase__c where Demo_Request__r.target__c IN :targetIds group by Demo_Request__r.target__c]){
              targetMap.put((Id)q.get('target__c'),(Double)q.get('expr0'));
          }
         
           system.debug('****targetMap ******'+targetMap );
          List<ISP_Target__c> updateTargetlist = new List<ISP_Target__c>();
          for(ISP_Target__c tar : [Select Id,Converted_Puchases__c from ISP_Target__c where Id IN :targetIds]){
            
            Double soldSum             = targetMap.get(tar.Id);
            tar.Converted_Puchases__c  = soldSum;
            updateTargetlist.add(tar);
          }
         
          //Update the targets
          if(!updateTargetlist.isEmpty()){
              update updateTargetlist;
          }
   }
   
*/
 }//Class