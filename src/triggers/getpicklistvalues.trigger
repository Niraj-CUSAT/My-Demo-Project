trigger getpicklistvalues on GPS_Picklist_Value__c (before insert,before update) {

for(GPS_Picklist_Value__c p: Trigger.new)
{

        String returnval='';
        String object_name=p.Object_Name__c;
        String field_name=p.Field_Name__c;
        
        
        
        Schema.sObjectType sobject_type = null;
        if(object_name=='Case')
        {
        sobject_type = Case.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Asset')
        {
        sobject_type = Asset.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='PRR')
        {
        sobject_type = PRR__c.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Contact')
        {
        sobject_type = Contact.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Contract')
        {
        sobject_type = AOSI_Contract__c.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Product')
        {
        sobject_type = Product2.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Account')
        {
        sobject_type = Account.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Spares')
        {
        sobject_type = Spares__c.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Service Charges')
        {
        sobject_type = Service_Charges__c.getSObjectType(); //grab the sobject that was passed    
        }else if(object_name=='Customer Concern')
        {
        sobject_type = Case_Customer_Concern__c.getSObjectType(); //grab the sobject that was passed    
        }
        
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            returnval=returnval+ a.getValue()+',';  //add the value and label to our final list
        }
        if(returnval.endsWith(','))
        {
        p.Values__c=returnval.substring(0,returnval.length()-1);    
        }
        if(p.Dependent_Field__c !=null)
        {
        p.Dependent_Values__c=JSON.Serialize(DependentPickListValueController.GetDependentOptions(sobject_type.getDescribe().getName(),field_name,p.Dependent_Field__c));
        }
        
        if(trigger.isUpdate && trigger.isBefore){
            AOSI_GPS_PicklistValue_TriggerHandler.sendNotifications(trigger.newMap, trigger.OldMap);
        }     
}

}