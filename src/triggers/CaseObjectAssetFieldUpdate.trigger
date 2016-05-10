/*
    Name:   CaseObjectAssetFieldUpdate 
    Created By:  
    Created Date:  4/15/2015
    Modified By:  Dhriti Krishna Ghosh Moulick 
    Last Modified Date: 
    Description: 1.If there is a warranty Case, and the case date is within 65 days of purchase and the case is closed 
                   Warranty Registered in time is TRUE,
                   OR
                 2.If there is an installation case (free or charged), and the case date is within 65 days of purchase and the case is closed
                   Warranty Registered in time is TRUE,
                   
                 3.If Case Reason is Free Installation and Case Status is Closed,
                   a.If Hardness is < 450 and Input TDS < 2000,
                     -Membrane warranty in Asset:-2 years
                     -Membrane warranty in Product:-Membrane Wty 2 year
                   b.If Hardness is > 450 && <=550 and Input TDS < 2000,
                     -Membrane warranty in Asset:-1 years
                     -Membrane warranty in Product:-Membrane Wty 1 year
                   c.a.If Hardness is > 550 and Input TDS < 2000,
                     -Membrane warranty in Asset:-NIL
                     -Membrane warranty in Product:-Membrane No Wty
                   
*/
trigger CaseObjectAssetFieldUpdate on Case (after insert,after update) {
    
    
    Set<Id> caseAsset= new Set<Id>();
    List<Asset> assetDetails = new List<Asset>();
    Map<Id,String> assetFieldUpdate = new Map<Id,String>();
    List<Asset> fieldUpdateAsset = new List<Asset>();
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1];//Query the Record type name as AOSIndia 
    
    if(checkRecursive.runOnce()){
    if(Trigger.isInsert || Trigger.isUpdate){//Start of if condition
        if(Trigger.isAfter){//Start of if condition
            for(Case cse:Trigger.new){//Trigger will run for after insert and after update
              caseAsset.add(cse.Id);
            }
        }//End of if condition
    }//End of if condition
    for(Case cseDetails:[Select Id,AssetId,Reason,Status,Asset.PurchaseDate,Asset.AOSI_Warranty_Registered_In_Time_new__c,CreatedDate from Case
                          where Id in:caseAsset AND RecordTypeId=:rt.Id]){//Query all necessary fields from case where record type is AOSIndia
         
        Date convertCreatedDate = date.newinstance(cseDetails.CreatedDate.year(), cseDetails.CreatedDate.month(), cseDetails.CreatedDate.day());//Converting CreatedDate from Datetime to Date
            if(cseDetails.Asset.PurchaseDate!=null){
                Integer dateDifference = cseDetails.Asset.PurchaseDate.daysBetween(convertCreatedDate);  //Find out difference between Case Creation Date and purchase Date
                if((cseDetails.Reason=='Free Installation' || cseDetails.Reason=='Chargeable Installation')&&
                     (cseDetails.Status=='Closed') && (dateDifference <65)){//Checking particular condition
                      cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c='True';
                }
                else if((cseDetails.Reason=='Warranty Registration') && (cseDetails.Status=='Closed') && (dateDifference <65)){
                        system.debug('*****before true********'+cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c);
                        cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c='True';
                        system.debug('*****after true********'+cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c);
                }
                else{
                      system.debug('*****before false********'+cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c);
                      cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c='False';
                      system.debug('*****before false********'+cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c);
                }
               assetFieldUpdate.put(cseDetails.AssetId,cseDetails.Asset.AOSI_Warranty_Registered_In_Time_new__c);//Map contains Asset Id as a key and Warranty registered In time as a value
            }
    }
   if(assetFieldUpdate.size()>0){
        for(Asset ast:[Select Id,AOSI_Warranty_Registered_In_Time_new__c from Asset where Id in:assetFieldUpdate.keySet()]){//Iterating Asset and assign Map value to Asset warranty registered in time
             ast.AOSI_Warranty_Registered_In_Time_new__c=assetFieldUpdate.get(ast.Id);
             fieldUpdateAsset.add(ast);
        }
   }
    if(fieldUpdateAsset.size()>0){//Update that particular field
        try{
             update fieldUpdateAsset;
        }catch(DMLException e){
             System.debug('&&&&&&&&&&&&&&&&&&&&&&'+e);
        }
         
    }
  } 
   
}