/*
##############################################################
# Project Name..........: AOSmith
# File..................: ContractorRewardsAfter
# Version...............: 1
# Created by............: Rahul Nasa
# Created Date..........: 05-December-2011
# Last Modified by......:    
# Last Modified Date....:   
# Description...........: This trigger performs the addition of RollUpSummary fields:
							1.    AOSTransaction
							2.    AOSCount
							3.    American Transaction
							4.    American Count
							5.    State Transaction
							6.    State Count
							7.    Takagi Transaction
							8.    Takagi Count
							9.    Other Transaction
							10.   Other Count
							11.   Sum Total Transaction
							12    Count Total Transaction
			                And also perform the max of:
			                1.    Recent Transaction Date.	
			                    for the After Update , After Delete , After Undelete of ContractorRewards.				  
########################################################################### 
*/ 
trigger ContractorRewardsAfter on Contractor_Rewards__c (after delete, after insert, after undelete, after update) 
{	
	//if(!Test.isRunningTest())
	//{
		Map<String,CreatedById__c> customMessages; 
		customMessages=CreatedById__c.getAll();
		List<Contractor_Rewards__c> lstContractorRewards=new List<Contractor_Rewards__c>();
		if(trigger.isUpdate || trigger.isInsert ||trigger.isUnDelete)
		{
			for(Contractor_Rewards__c cr: trigger.new)
			{					
	   		 	//if(cr.ContactRecordTypeId__c==rtByName.getRecordTypeId())
	   		 	//{
	   		 	if(cr.ContactCreatedById__c==customMessages.get('UserId').value__c)
	   		 	{
	   		 		lstContractorRewards.add(cr);               		 
	   		 	}
			}
			if(lstContractorRewards.size()>0)
	        	AOS_UtilityUpdateAccountwithRollUp.AOS_ContractorRewards(lstContractorRewards);
		}	
		if(trigger.isDelete)
		{
			for(Contractor_Rewards__c cr: trigger.old)
			{					
	   		 	if(cr.ContactCreatedById__c==customMessages.get('UserId').value__c)
	   		 	{
	   		 		lstContractorRewards.add(cr);               		 
	   		 	}
	   		}
			if(lstContractorRewards.size()>0)
				AOS_UtilityUpdateAccountwithRollUp.AOS_ContractorRewards(lstContractorRewards);
	   		  
		}
	//}
}