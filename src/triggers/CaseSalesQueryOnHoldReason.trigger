/*trigger CaseSalesQueryOnHoldReason on Case (Before update) {
  Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype    
  if(Trigger.isUpdate){
      System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&');       
     for(Case cse:Trigger.new){
         System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&'); 
       if(cse.RecordTypeId == rt.id){ 
         System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+Trigger.oldMap.get(cse.Id).Status);
         System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+Trigger.newMap.get(cse.Id).Status);
         System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+Trigger.newMap.get(cse.Id).Reason);
        if((Trigger.oldMap.get(cse.Id).Status!=Trigger.newMap.get(cse.Id).Status) && Trigger.newMap.get(cse.Id).Status=='On Hold' && Trigger.newMap.get(cse.Id).Reason=='Sales Query' ){
           System.debug('&&&&&&&&&&&&&&&cse.AOSI_Count_Sales_Query_On_Hold__c&&&&&&&&&&&&&'+cse.AOSI_Count_Sales_Query_On_Hold__c);
           if(String.valueOf(cse.AOSI_Count_Sales_Query_On_Hold__c)=='' || String.valueOf(cse.AOSI_Count_Sales_Query_On_Hold__c)==null){
              cse.AOSI_Count_Sales_Query_On_Hold__c=1;
           }
           else{
              cse.AOSI_Count_Sales_Query_On_Hold__c=cse.AOSI_Count_Sales_Query_On_Hold__c + 1;
           }
        }
        if(cse.AOSI_Count_Sales_Query_On_Hold__c > 5){
            cse.AddError('case cannot be moved further to On hold status as limit exceeds and can be either closed/cancelled');
        }
     }
    }
  }
}
*/
trigger CaseSalesQueryOnHoldReason on Case (After insert,After update) {
  Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype    
  Set<Id> caseId = new Set<Id>();
  List<Asset> fieldUpdateAsset = new List<Asset>();
  List<Product2> fieldUpdateAProduct = new List<Product2>();
  //List<String> updateMembraneWarranty = new List<String>();
   Map<Id,String> updateMembraneWarranty = new Map<Id,String>();
   Map<Id,String> updateMembraneWarranty1 = new Map<Id,String>();
  if(checkRecursive.runOnce()){
  if(Trigger.isAfter){     
     for(Case cse:Trigger.new){
        caseId.add(cse.Id);
     }
  }
  
  for(case cse:[Select Id,AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__r.AOSI_Membrane_Wty__c,Asset.AOSI_Membrane_Warranty__c,AOSI_TDS_Input__c,AOSI_Hardness__c,AssetId,Reason,Status,Asset.PurchaseDate,Asset.AOSI_Warranty_Registered_In_Time_new__c,CreatedDate from Case
                          where Id in:caseId AND RecordTypeId=:rt.Id]){
     
     if(cse.Reason=='Free Installation' && cse.Status=='Closed'){
             Integer inputTDS=2000;
             if(Integer.valueOf(cse.AOSI_TDS_Input__c) < inputTDS){
                   Integer hardness=450; 
                   Integer hardness1=550;
                  if(Integer.valueOf(cse.AOSI_Hardness__c) < hardness){
                           cse.Asset.AOSI_Membrane_Warranty__c='2 Years';
                           updateMembraneWarranty.put(cse.AssetId,cse.Asset.AOSI_Membrane_Warranty__c);
                           System.debug('%%%%%%%%%%%%%%updateMembraneWarranty%%%%%%%%%%%'+updateMembraneWarranty);
                           System.debug('%%%%%%%%%%%%%%cse.AOSIProduct__r.AOSI_Vertical__c%%%%%%%%%%%'+cse.AOSIProduct__r.AOSI_Vertical__c);
                           if(cse.AOSIProduct__r.AOSI_Vertical__c=='Water Treatment'){
                               cse.AOSIProduct__r.AOSI_Membrane_Wty__c='Membrane Wty 2 Year';
                               updateMembraneWarranty1.put(cse.AOSIProduct__c,cse.AOSIProduct__r.AOSI_Membrane_Wty__c);
                           }
                            System.debug('%%%%%%%%%%%%%updateMembraneWarranty1%%%%%%%%%%%'+updateMembraneWarranty1);
                  }
                  
                  else if(Integer.valueOf(cse.AOSI_Hardness__c) > hardness && Integer.valueOf(cse.AOSI_Hardness__c) <=hardness1){
                            System.debug('%%%%%%%%%%%%%cse.AOSI_Hardness__c%%%%%%%%%%%'+cse.AOSI_Hardness__c);
                           cse.Asset.AOSI_Membrane_Warranty__c='1 Years';
                           updateMembraneWarranty.put(cse.AssetId,cse.Asset.AOSI_Membrane_Warranty__c);
                           System.debug('%%%%%%%%%%%%%%updateMembraneWarranty%%%%%%%%%%%'+updateMembraneWarranty);
                           System.debug('%%%%%%%%%%%%%%cse.AOSIProduct__r.AOSI_Vertical__c%%%%%%%%%%%'+cse.AOSIProduct__r.AOSI_Vertical__c);
                           if(cse.AOSIProduct__r.AOSI_Vertical__c=='Water Treatment'){
                                 cse.AOSIProduct__r.AOSI_Membrane_Wty__c='Membrane Wty 1 Year';
                                 updateMembraneWarranty1.put(cse.AOSIProduct__c,cse.AOSIProduct__r.AOSI_Membrane_Wty__c);
                                 System.debug('%%%%%%%%%%%%%updateMembraneWarranty1%%%%%%%%%%%'+updateMembraneWarranty1);
                           }
                  }
                  else if(Integer.valueOf(cse.AOSI_Hardness__c) > hardness1){
                           cse.Asset.AOSI_Membrane_Warranty__c='NIL';
                           updateMembraneWarranty.put(cse.AssetId,cse.Asset.AOSI_Membrane_Warranty__c);
                            System.debug('%%%%%%%%%%%%%%updateMembraneWarranty%%%%%%%%%%%'+updateMembraneWarranty);
                           System.debug('%%%%%%%%%%%%%%cse.AOSIProduct__r.AOSI_Vertical__c%%%%%%%%%%%'+cse.AOSIProduct__r.AOSI_Vertical__c);
                            if(cse.AOSIProduct__r.AOSI_Vertical__c=='Water Treatment'){
                                  cse.AOSIProduct__r.AOSI_Membrane_Wty__c='Membrane No Wty';
                                 updateMembraneWarranty1.put(cse.AOSIProduct__c,cse.AOSIProduct__r.AOSI_Membrane_Wty__c);
                                 System.debug('%%%%%%%%%%%%%updateMembraneWarranty1%%%%%%%%%%%'+updateMembraneWarranty1);
                           }
                  }
             }
     }
  }
  if(updateMembraneWarranty.size()>0){
        for(Asset ast:[Select Id,Product2.AOSI_Membrane_Wty__c,AOSI_Membrane_Warranty__c from Asset where Id in:updateMembraneWarranty.keySet()]){//Iterating Asset and assign Map value to Asset warranty registered in time
             ast.AOSI_Membrane_Warranty__c=updateMembraneWarranty.get(ast.Id);
             fieldUpdateAsset.add(ast);
        }
         System.debug('&&&&&&&&fieldUpdateAsset&&&&&&&&&&&&&'+fieldUpdateAsset);
   }
     if(fieldUpdateAsset.size()>0){//Update that particular field
        try{
             update fieldUpdateAsset;
        }catch(DMLException e){
             System.debug('&&&&&&&&&&&&&&&&&&&&&&'+e);
        }
         
    }
    
    if(updateMembraneWarranty1.size()>0){
        for(Product2 prdct:[Select Id,AOSI_Membrane_Wty__c from Product2 where Id in:updateMembraneWarranty1.keySet()]){//Iterating Asset and assign Map value to Asset warranty registered in time
             prdct.AOSI_Membrane_Wty__c=updateMembraneWarranty1.get(prdct.Id);
             fieldUpdateAProduct.add(prdct);
        }
         System.debug('&&&&&&&&fieldUpdateAProduct&&&&&&&&&&&&&'+fieldUpdateAProduct);
    }
    if(fieldUpdateAProduct.size()>0){//Update that particular field
        try{
             update fieldUpdateAProduct;
        }catch(DMLException e){
             System.debug('&&&&&&&&&&&&&&&&&&&&&&'+e);
        }
         
    }
    
  }
}