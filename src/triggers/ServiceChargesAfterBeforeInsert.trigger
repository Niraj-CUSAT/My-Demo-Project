/****
Class Name: ServiceChargesAfterBeforeInsert
    Created By:Dhriti Krishna Ghosh Moulick
    Modified By:
    Description:This trigger is used manipulate part charges and accessory charges for AOS India CASE.
****/

/*trigger ServiceChargesAfterBeforeInsert on Service_Charges__c (after insert, after Update) {
  
      
  If(trigger.new[0].type__c == 'Part Replacement' ||trigger.new[0].type__c == 'Accessories' )
    {
        Id Prodid;
        List<case> CList = [Select id, AOSIProduct__c from Case where id=: Trigger.new[0].Case__c ];
        if(!Clist.isempty())
        {
        Prodid = [Select id,Name from product2 where id=:CList[0].AOSIProduct__c].id;       
        List<Spare_Product_Junction__c> SPJList = [Select id,Product__c,Spares__c from Spare_Product_Junction__c where Spares__c =: Trigger.new[0].Spares__c AND product__c =: Prodid];  
        if(SPJList.isempty())
        Trigger.new[0].Adderror('the Selected Spare does not relate to the serviced product');
        
      }
    }

}*/
trigger ServiceChargesAfterBeforeInsert on Service_Charges__c (after insert, after Update) {//Start of trigger 
  List<Service_Charges__c> serviceChargesUpdate = new List<Service_Charges__c>();
  Map<String,String> serviceCharges = new Map<String,String>();
  Set<Id> productListId = new Set<Id>();
  List<Id> Prodid = new List<Id>();
  Set<Id> spareId = new Set<Id>();
    if(checkRecursive.runOnce()){//Call recurive class to stop recursion
        System.debug('&&&&&&&&&&&&&&');
        if(Trigger.isInsert || Trigger.isUpdate){//start of if loop,Trigger will run for insert and update
            if(Trigger.isAfter){//start of if condition
                for(Service_Charges__c serviceCharge:Trigger.new){//start of for loop
                     serviceCharges.put(serviceCharge.Id,serviceCharge.Case__c);
                     spareId.add(serviceCharge.Spares__c);
                }//end of for loop
            }//end of if condition
        }//End of if loop
        List<Case> CList = [Select id, AOSIProduct__c from Case where id in:serviceCharges.values()];//retreiving from Case object
        for(Case csList:CList){//start of for loop
            productListId.add(csList.AOSIProduct__c);
        }//end of for loop
        if(!Clist.isempty()){//Checking for list size
            for(Product2 prdct:[Select id,Name from product2 where id in:productListId]){//Start of for loop
                Prodid.add(prdct.Id);
            }//end of for loop      
            List<Spare_Product_Junction__c> SPJList = [Select id,Product__c,Spares__c from Spare_Product_Junction__c where Spares__c in:spareId AND product__c =:Prodid];  
            for(Service_Charges__c serviceCharge:Trigger.new){//Start of for loop
                if(SPJList.isempty() && serviceCharge.Spares__c!=null)
                serviceCharge.Adderror('The Selected Spare does not relate to the serviced product');
            }//End of for loop
        }//End of if condition
        for(Service_Charges__c services:[Select Id,Spares__r.MRP__c,Case__c,Case__r.Status,Spares__r.Old_MRP_Price__c,Type__c,Part_Charges1__c,Chargable__c,Free_Parts__c from Service_Charges__c where Id in:serviceCharges.keyset()]){//Start of for loop
            if(services.Chargable__c =='Yes' && services.Type__c=='Part Replacement' && services.Case__r.Status=='Closed'){
               services.Part_Charges1__c=services.Spares__r.MRP__c;
            }//end of if condition
            else if(services.Free_Parts__c =='True'){//start of if condition
               services.Part_Charges1__c=0;
            }//end of if condition
            else if( services.Chargable__c =='Yes' && services.Type__c=='Part Replacement' && services.Case__r.Status!='Closed'){
               services.Part_Charges1__c=services.Spares__r.MRP__c;
            }
            else if(services.Type__c=='Accessories'){
               services.Accessory_Charges1__c=services.Spares__r.MRP__c;
            }else{
               services.Accessory_Charges1__c=0;
            }
           serviceChargesUpdate.add(services);
        }//End of for loop
        if(serviceChargesUpdate.size()>0){//start of if condition
          update serviceChargesUpdate;
        }//end of if condition
    }//End of recursive call to Class
}//End of trigger