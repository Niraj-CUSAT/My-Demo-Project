/*
##############################################################
# Project Name..........: AOSmith
# File..................: AOS_UtilityUpdateAccountwithRollUp
# Version...............: 1
# Created by............: Rahul Nasa
# Created Date..........: 05-December-2011
# Last Modified by......:    
# Last Modified Date....:   
# Description...........: This is the Utility class called from Contact After and ContractorRewards After triggers.
                        
########################################################################### 
*/ 

public  class AOS_UtilityUpdateAccountwithRollUp {
  //Utility Method for ContactAfter Trigger.
  public static void AOS_Contact(List<Contact> contacts,Map<Id,Contact> mapcontact)
  {
    Set<Id> accIdSet=new Set<Id>();
    if(mapcontact!=null)
    {
        for(Contact objContact: contacts)
        {  
          if(objContact.AccountId != null)  
            accIdSet.add(objContact.AccountId);
          else if(objContact.AccountId == null)
          {  
            accIdSet.add(mapcontact.get(objContact.id).AccountId);
          }
        }
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Id in:accIdSet AND Account.RecordType.Name='CSP']);
        if(accMap.size() > 0)
            AOS_UtilityMethod(accMap.keyset()); 
            
        //AOS_UtilityMethod(accIdSet); 
    }
    else if(mapcontact==null)
    {
        for(Contact objContact: contacts)
        {  
          if(objContact.AccountId != null)  
            accIdSet.add(objContact.AccountId);
        }
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Id in:accIdSet AND Account.RecordType.Name='CSP']);
        if(accMap.size() > 0)
            AOS_UtilityMethod(accMap.keyset()); 
        //AOS_UtilityMethod(accIdSet);
    }
  }
  //Utility Method for ContractorRewardsAfter Trigger 
  public static void AOS_ContractorRewards(List<Contractor_Rewards__c> contractorRewards)
  {
    Set<Id> accIdSet=new Set<Id>();
    for(Contractor_Rewards__c objContractorRewards: contractorRewards){ 
        system.debug('Test......'); 
      if(objContractorRewards.AccountId__c != null)  
        accIdSet.add(objContractorRewards.AccountId__c);
    }
    if(accIdSet!=null && accIdSet.size()>0){
        AOS_UtilityMethod(accIdSet);
    }
  }
  //Utility Method
  public static void AOS_UtilityMethod(Set<Id> accIdSet)
  {
    List<Account> lstUpdatedAccount=new List<Account>();
    AggregateResult []  groupedTotalTransactions = [SELECT  AccountId,SUM(Count_Total_Transactions__c) CountTotalTransactions,
                                  SUM(Sum_Total_Transactions__c) SumTotalTransactions,
                                  SUM(Sum_AOSmith_Transactions__c) AOSTransaction,
                                  SUM(Count_AOSmith_Transactions__c) AOSCount,
                                  SUM(Sum_American_Transactions__c) AmericanTransaction,
                                  SUM(Count_American_Transactions__c) AmericanCount,
                                  SUM(Sum_State_Transactions__c) StateTransaction,
                                  SUM(Count_State_Transactions__c)StateCount,
                                  SUM(Sum_Takagi_Transactions__c) TakagiTransaction,
                                  SUM(Count_Takagi_Transactions__c) TakagiCount,
                                  SUM(Sum_Other_Transactions__c) OtherTransaction,
                                  SUM(Count_Other_Transactions__c)OtherCount,
                                  MAX(Recent_CR_Transaction_Date__c)  RecentCRTransactionDate 
                                  FROM Contact where AccountId in:accIdSet and AccountId!=null
                                  AND RecordType.Name = 'Contractor' AND Account.RecordType.Name='CSP' 
                                  GROUP BY AccountId];  // Added RecordType filters - By Govind Thathera - 6/13/2014
      if(groupedTotalTransactions!=null && groupedTotalTransactions.size()>0)
      { 
      for (AggregateResult groupedAggregateResult : groupedTotalTransactions)  
          {
            Account objAcc=new Account(Id =(Id)groupedAggregateResult.get('AccountId'));
        objAcc.Count_Total_Transaction__c =(Double) groupedAggregateResult.get('CountTotalTransactions');                
          objAcc.Sum_Total_Transaction__c =(Double)groupedAggregateResult.get('SumTotalTransactions');
          objAcc.Recent_CR_Transaction_Date__c =(Date)groupedAggregateResult.get('RecentCRTransactionDate');
          objAcc.AOS_Transaction__c =(Double) groupedAggregateResult.get('AOSTransaction');                
          objAcc.AOS_Count__c =(Double)groupedAggregateResult.get('AOSCount');
          objAcc.American_Transaction__c =(Double)groupedAggregateResult.get('AmericanTransaction');
          objAcc.American_Count__c =(Double) groupedAggregateResult.get('AmericanCount');                
          objAcc.State_Transaction__c =(Double)groupedAggregateResult.get('StateTransaction');
          objAcc.State_Count__c =(Double)groupedAggregateResult.get('StateCount');
          objAcc.Takagi_Transaction__c =(Double)groupedAggregateResult.get('TakagiTransaction');
          objAcc.Takagi_Count__c =(Double)groupedAggregateResult.get('TakagiCount');
          objAcc.Other_Transaction__c =(Double)groupedAggregateResult.get('OtherTransaction');
          objAcc.Other_Count__c =(Double)groupedAggregateResult.get('OtherCount');          
          lstUpdatedAccount.add(objAcc);  
      }   
      }
      //For the case of last related record.  
      
      else
      {   
        for(Id objId:accIdSet)
        {
        Account objAcc=new Account(Id = objId);        
          objAcc.Count_Total_Transaction__c = 0.0;                
          objAcc.Sum_Total_Transaction__c = 0.0;
          objAcc.Recent_CR_Transaction_Date__c = null;
          objAcc.AOS_Transaction__c = 0.0;                
          objAcc.AOS_Count__c = 0.0;          
          objAcc.American_Transaction__c = 0.0;
          objAcc.American_Count__c = 0.0;                
          objAcc.State_Transaction__c = 0.0;
          objAcc.State_Count__c = 0.0;
          objAcc.Takagi_Transaction__c = 0.0;
          objAcc.Takagi_Count__c = 0.0;
          objAcc.Other_Transaction__c = 0.0;
          objAcc.Other_Count__c = 0.0; 
          lstUpdatedAccount.add(objAcc);
      }
      }
        
    if(lstUpdatedAccount!=null && lstUpdatedAccount.size() >0)
    { 
      Database.update(lstUpdatedAccount,false);
    }
  }
   
}