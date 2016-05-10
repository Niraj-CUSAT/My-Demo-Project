@RestResource(urlMapping='/getpicklistvalues/*')
global class AOSI_GPS_PicklistValues {
    
    @HttpGet
    global static String getpicklistvalues()
    {
        list<GPS_Picklist_Value__c> picklistvals=[select Object_Name__c,Values__c,Field_Name__c,Dependent_Values__c,Dependent_Field__c from GPS_Picklist_Value__c where Active__c=true ];
		return JSON.serializePretty(picklistvals);
    }

}