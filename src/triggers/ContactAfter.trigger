trigger ContactAfter on Contact (after update,after delete, after undelete,after insert) {
	
	// Stop trigger Execution if it is running from ContactRewardsBatchController batch class otherwise execute trigger logic.
	// Added by GOVIND THATHERA - 5/19/2014 
	if(!TriggerUtility.isRewardsBatchProcessing){
		ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;//added by bhanu, KVP Business Soltion    
		 
	    if(Trigger.isUpdate)
	    {
	        
	        
	        Set<Id> contIdSet = new Set<Id>();
	        
	        for(Contact c : Trigger.new){
	        if(c.recordtypeid != Conrtid ) //added by bhanu, KVP Business Soltion
	            if(c.FirstName != Trigger.oldMap.get(c.Id).FirstName || c.LastName != Trigger.oldMap.get(c.Id).LastName || c.Phone != Trigger.oldMap.get(c.Id).Phone)
	            {
	                contIdSet.add(c.Id);
	            }
	        }
	        List<AssetContactJunction__c> assetList = [select asset__c,contact__c,contactphone__c,contactname__c
	                                 from AssetContactJunction__c where contact__c IN : contIdSet];
	                                 
	        if(!assetList.isempty()) //added by bhanu, KVP Business Soltion                        
	        update assetList;
	         
	    }
	
	
	   //Roll Up Functionality ---- Done By Rahul Nasa
	    //For Delete or Update or Undelete or Insert Operation 
	    if(Trigger.isDelete || Trigger.isUpdate || Trigger.isUnDelete ) 
	    {
	      Map<String,CreatedById__c> customMessages; 
	    customMessages=CreatedById__c.getAll();
	    List<Contact> lstContact=new List<Contact>();
	    //system.debug('UserId..'+ customMessages.get('UserId').value__c);    
	        //For Update,Undelete
	            if(Trigger.isUpdate || trigger.isUnDelete)      
	            {
	              for(Contact c : trigger.new)
	              {   
	                  //if(c.RecordTypeId==rtByName.getRecordTypeId())
	                  //{
	                  if(c.recordtypeid != Conrtid ) //added by bhanu, KVP Business Soltion
	                  if((c.CreatedById==customMessages.get('UserId').value__c)  
	                  && c.EXTERNAL_ID_PARTICIPANT__c !=  null ) //added by Nishma on 21Aug2012
	                  {
	                    lstContact.add(c);                    
	                  }
	              }
	              if(lstContact.size()>0)
	                AOS_UtilityUpdateAccountwithRollUp.AOS_Contact(lstContact,trigger.oldMap); 
	            }
	            
	            
	            //For Delete    
	            if(Trigger.isDelete)
	            {
	              for(Contact c : trigger.old)
	              {
	                  if(c.recordtypeid != Conrtid ) //added by bhanu, KVP Business Soltion
	                  if ((c.CreatedById==customMessages.get('UserId').value__c)
	                  && c.EXTERNAL_ID_PARTICIPANT__c !=  null ) //added by Nishma on 21Aug2012
	                  {
	                    lstContact.add(c);                    
	                  }   
	              } 
	              if(lstContact.size()>0)
	                AOS_UtilityUpdateAccountwithRollUp.AOS_Contact(lstContact,null); 
	                                                                        
	                
	            }
	    }  
	      
	   /** By Reetika on 28th Aug 2012
	    * At After Insert of Contact ,which is created via 'WEB' , 
	    * Asset Regristration information should be updated from Contact. 
	    * And AssetContactJunction record related to the new contact and the associated asset record.
	    **/
	 
	    if(Trigger.isInsert && Trigger.isAfter)
	    {
	      Set<Id> contIdSet = new Set<Id>();
	      Set<String> assetSet = new Set<String>();
	        Map<Id,String> linkAsset = new Map<Id,String>();
	        Map<String,Id> linkContact = new Map<String,Id>();
	        for(Contact c : Trigger.new){
	            if(c.recordtypeid != Conrtid ) //added by bhanu, KVP Business Soltion
	            if(c.Serial_Number_from_Web_Site_Registration__c != null && c.LeadSource=='Web')
	            {
	                contIdSet.add(c.Id);
	                assetSet.add(c.Serial_Number_from_Web_Site_Registration__c);
	                linkAsset.put(c.Id ,c.Serial_Number_from_Web_Site_Registration__c );
	                linkContact.put(c.Serial_Number_from_Web_Site_Registration__c ,c.id) ;
	            }
	        }  
	        if(!contIdSet.isempty())   //added by bhanu, KVP Business Soltion    
	        ContactHelper.contactAfterUpdate(contIdSet ,assetSet,linkAsset,linkContact ) ;
	    } 
	}
}