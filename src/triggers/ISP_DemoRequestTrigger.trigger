trigger ISP_DemoRequestTrigger on ISP_Demo_Request__c (before insert,before update, after insert, after update, after delete, after undelete ) {
    
  if(Trigger.isbefore){
      ISP_DemoRequestTrigHandlerCls.updateRecWithTarget(trigger.new);
  }
  
   if(Trigger.isAfter){
       ISP_DemoRequestTrigHandlerCls.updateTargetRecords(Trigger.isInsert, Trigger.isUpdate,Trigger.isDelete, Trigger.new, Trigger.old);
   }
  
  /*  List<Id> LocationIds = new List<Id>();
    List<String> locationList = new List<String>();
    Map<String, List<User>> locationToUsersMap = new Map<String, List<User>>();
    List<ISP_Store_Location__c> storeLocationList = new List<ISP_Store_Location__c>();
    
    List<ISP_Product_Demo__c> prodDemoToUpdate = new List<ISP_Product_Demo__c>();
    Map<Id, String> storeLocationMap = new Map<Id, String>();
    
    
    for(ISP_Product_Demo__c ProdDemo :Trigger.New){
        LocationIds.add(ProdDemo.Preferred_Location__c);        
    }
    
    for(ISP_Store_Location__c storeLocation : [SELECT Id, Name FROM ISP_Store_Location__c WHERE Id IN :LocationIds]){
        //locationList.add(storeLocation.Name);
        storeLocationMap.put(storeLocation.Id, storeLocation.Name);
    }
    
    List<User> usr = [Select Id, Name, Location__c, Region__c FROM User 
                        WHERE isActive = true AND Location__c IN :storeLocationMap.values()];
    for(User u :usr){
        if(locationToUsersMap.containsKey(u.Location__c))
            locationToUsersMap.get(u.Location__c).add(u); 
        else{
            locationToUsersMap.put(u.Location__c, new List<User>{u});
        }       
    }
    System.debug('--locationToUsersMap--'+locationToUsersMap);
    
    for(ISP_Product_Demo__c prodDemo :Trigger.New){
      
      if(prodDemo.Preferred_Location__c != null){
        
            ISP_Product_Demo__c newProdDemo = new ISP_Product_Demo__c(Id = prodDemo.Id);
            System.debug('--newProdDemo--'+newProdDemo.Demo_Number__c);
            integer modValue = math.mod(Integer.valueOf(prodDemo.Demo_Number__c),locationToUsersMap.get(storeLocationMap.get(prodDemo.Preferred_Location__c)).size());
            newProdDemo.ownerId = locationToUsersMap.get(storeLocationMap.get(prodDemo.Preferred_Location__c))[modValue].Id;        
            prodDemoToUpdate.add(newProdDemo);
        
      }
      
    }
    
    if(prodDemoToUpdate.size() > 0){
        update prodDemoToUpdate;
    }  */
}