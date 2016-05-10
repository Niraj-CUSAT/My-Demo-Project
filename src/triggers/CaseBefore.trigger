trigger CaseBefore on Case (before insert,before update) {

	for(Case c : Trigger.new){
		
		// Need to do it for only AWH America record Type
		
		if(c.RecordTypeId != '012400000000pcs')
			continue;
		
		c.Subject = (c.Product_Family__c!= null?c.Product_Family__c:'') + ' - ' + (c.Symptom_Code__c!= null?c.Symptom_Code__c:'');
		
			
		if(c.Subject == ' - '){
			c.Subject = '';
		}else if(c.Subject.startsWith(' - ')){
			c.Subject = c.Subject.subString(3,c.Subject.length());
		}else if(c.Subject.endsWith(' - ')){
			c.Subject = c.Subject.subString(0,c.Subject.length()-3);
		}		
	}

}