trigger PopulateContactInfo on AssetContactJunction__c (before insert, before update) {
	
	Set<Id> contactId = new Set<Id>();
	 
	for(AssetContactJunction__c aj : Trigger.new){
		
		contactId.add(aj.Contact__c);	
	}
	
	Map<Id,Contact> conMap = new Map<Id,Contact>([select id,name,phone from Contact where Id IN: contactId]);
	
	for(AssetContactJunction__c aj : Trigger.new){
		if(conMap.get(aj.Contact__c) != null && conMap.get(aj.Contact__c).Phone != null){
			aj.ContactPhone__c = conMap.get(aj.Contact__c).Phone.replaceAll('\\(','').replaceAll('\\)','').replaceAll('-','').replaceAll(' ','');
			
		}
		aj.ContactName__c = conMap.get(aj.Contact__c).Name;
	}
}