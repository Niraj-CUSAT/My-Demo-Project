/*
*    Name        : AccountContactsRewardBatchController 
*    Author      : Sumit Jain
*    Date        : 11/26/2013
*    Description : Batch class that Rollups AOS, American and State fields from Contact records to their parent Account record at appropriate AOS, American and State field.
*/
global class AccountContactsRewardBatchController implements Database.Batchable<sObject>{
    
    // Query to get all CSP Account record().
    String query = 'Select a.Takagi_Bonus__c, a.Takagi_Aggregate_ranking_points__c, a.State_Tankless_ranking_points__c, a.State_Standard_Tank_ranking_points__c, a.State_Solar_ranking_points__c,' 
                +' a.State_High_Eff_Gas_Ranking_Points__c, a.State_Heat_Pump_ranking_points__c, a.State_Commercial_ranking_points__c, a.State_Aggregate_ranking_points__c,' 
                +' a.Ratings_Weight__c, a.Ranking_Points_from_Ratings_Reviews__c, a.Id, a.Avg_Star_Rating__c, a.American_Tankless_ranking_points__c, '
                +' a.American_Standard_Tank_ranking_points__c, a.American_Solar_ranking_points__c, a.American_High_Eff_Gas_Ranking_Points__c, '
                +' a.American_Heat_Pump_ranking_points__c, a.American_Commercial_ranking_points__c, a.American_Aggregate_ranking_points__c, a.AOS_Tankless_ranking_points__c, '
                +' a.AOS_Standard_Tank_ranking_points__c, a.AOS_Solar_ranking_points__c, a.AOS_High_Efficiency_Gas_ranking_points__c, a.AOS_Heat_Pump_ranking_points__c, '
                +' a.AOS_Commercial_ranking_points__c, a.AOS_Aggregate_ranking_points__c, '
                +' a.American_Bonus__c, a.AOS_Bonus__c, a.State_Bonus__c, a.State_Bonus_90_days__c, a.AOS_Bonus_90_days__c, a.American_Bonus_90_days__c,'
                +' a.American_Aggregate_Rank_Point_90_days__c, a.American_Commercial_Rank_Point_90_days__c, a.American_Heat_Pump_Rank_Point_90_days__c, '
                +' a.American_High_Eff_Gas_Rank_Point_90_days__c, a.American_Solar_Rank_Point_90_days__c, a.American_Std_Tank_Rank_Point_90_days__c, '
                +' a.American_Tankless_Rank_Point_90_days__c, a.AOS_Aggregate_Rank_Point_90_days__c, a.AOS_Commercial_Rank_Point_90_days__c, a.AOS_Heat_Pump_Rank_Point_90_days__c, '
                +' a.AOS_High_Eff_Gas_Rank_Point_90_days__c, a.AOS_Solar_Rank_Point_90_days__c, a.AOS_Std_Tank_Rank_Point_90_days__c, a.AOS_Tankless_Rank_Point_90_days__c, '
                +' a.State_Aggregate_Rank_Point_90_days__c, a.State_Commercial_Rank_Point_90_days__c, a.State_Heat_Pump_Rank_Point_90_days__c, a.State_High_Eff_Gas_Rank_Point_90_days__c, '
                +' a.State_Solar_Rank_Point_90_days__c, a.State_Std_Tank_Rank_Point_90_days__c, a.State_Tankless_Rank_Point_90_days__c, a.Takagi_Aggregate_Rank_Point_90_days__c, '
                +' a.AOS_Approved__c, a.Takagi_Bonus_90_days__c FROM Account a WHERE RecordType.Name=\'CSP\''; // AND Id=\'001M000000X7EZO\''; //- Just for Testing
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
     
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Account> accounts){
        
        // Set TriggerUtility.isRewardsBatchProcess = true to prevent Account triggers from there execution.
        //TriggerUtility.isRewardsBatchProcessing = true;
        
        // Logic to be Executed batch wise 
        Map<String, Account> accountsMap = new Map<String, Account>();
                    
        for(Account accRec : accounts){
            initializeAllFields(accRec);
            accountsMap.put(accRec.Id, accRec);
        }  
        
        List<AggregateResult> arrResults = [Select Sum(Takagi_Bonus__c) takagiBonus, Sum(Takagi_Aggregate_ranking_points__c)takagiArg, Sum(State_Tankless_ranking_points__c) stateTankless, Sum(State_Standard_Tank_ranking_points__c) stateStdTank, Sum(State_Solar_ranking_points__c) stateSolar,
                                        Sum(State_High_Eff_Gas_ranking_points__c) stateHighEff, Sum(State_Heat_Pump_ranking_points__c) stateHeatPump, Sum(State_Commercial_ranking_points__c) stateCommercial, Sum(State_Aggregate_ranking_points__c) stateArg, 
                                        Sum(American_Tankless_ranking_points__c) americanTankless, Sum(American_Standard_Tank_ranking_points__c) americanStdTank, Sum(American_Solar_ranking_points__c) americanSolar, Sum(American_Heat_Pump_ranking_points__c) americanHeatPump, 
                                        Sum(American_Commercial_ranking_points__c) americanCommercial, Sum(American_Aggregate_ranking_points__c) americanArg, Sum(AOS_Tankless_ranking_points__c) aosTankless, Sum(AOS_Standard_Tank_ranking_points__c) aosStdTank, 
                                        Sum(AOS_Solar_ranking_points__c) aosSolar, Sum(AOS_High_Efficiency_Gas_ranking_points__c) aosHighEff, Sum(AOS_Heat_Pump_ranking_points__c) aosHeatPump, Sum(AOS_Commercial_ranking_points__c) aosCommercial, 
                                        Sum(AOS_Bonus__c) aosBonus, Sum(American_Bonus__c) americanBonus, Sum(State_Bonus__c) stateBonus,
                                        Sum(AOS_Aggregate_ranking_points__c) aosArg, Sum(American_Aggregate_Rank_Point_90_days__c) americanArg90, Sum(American_Commercial_Rank_Point_90_days__c) americanCommercial90, Sum(American_Heat_Pump_Rank_Point_90_days__c) americanHeatPump90, 
                                        Sum(American_High_Eff_Gas_Rank_Point_90_days__c) americanHighEff90, Sum(American_Solar_Rank_Point_90_days__c) americanSolar90, Sum(American_Std_Tank_Rank_Point_90_days__c) americanStdTank90, Sum(American_Tankless_Rank_Point_90_days__c) americanTankless90, 
                                        Sum(AOS_Aggregate_Rank_Point_90_days__c) aosArg90, Sum(AOS_Commercial_Rank_Point_90_days__c) aosCommercial90, Sum(AOS_Heat_Pump_Rank_Point_90_days__c) aosHeatPump90, Sum(AOS_High_Eff_Gas_Rank_Point_90_days__c) aosHighEff90, Sum(AOS_Solar_Rank_Point_90_days__c) aosSolar90, 
                                        Sum(AOS_Std_Tank_Rank_Point_90_days__c) aosStdTank90, Sum(AOS_Tankless_Rank_Point_90_days__c) aosTankless90, Sum(State_Aggregate_Rank_Point_90_days__c) stateArg90, Sum(State_Commercial_Rank_Point_90_days__c) stateCommercial90, Sum(State_Heat_Pump_Rank_Point_90_days__c) stateHeatPump90, 
                                        Sum(State_High_Eff_Gas_Rank_Point_90_days__c) stateHighEff90,Sum(State_Solar_Rank_Point_90_days__c) stateSolar90, Sum(State_Std_Tank_Rank_Point_90_days__c) stateStdTank90, Sum(State_Tankless_Rank_Point_90_days__c) stateTankless90, Sum(Takagi_Aggregate_Rank_Point_90_days__c) takagiArg90, 
                                        Sum(American_High_Eff_Gas_Ranking_Points__c)americanHighEff, 
                                        Sum(AOS_Bonus_90_days__c) aosBonus90, Sum(American_Bonus_90_days__c) americanBonus90, Sum(State_Bonus_90_days__c) stateBonus90,
                                        AccountId, Sum(Takagi_Bonus_90_days__c) takagiBonus90
                                        From Contact c WHERE RecordType.Name='Contractor' AND AccountId in:accountsMap.keyset() group by AccountId];
                                        
        for(AggregateResult arrResult: arrResults){
            if(accountsMap.get(arrResult.get('AccountId')+'') != null){
                aggregateAccountFields(accountsMap.get(arrResult.get('AccountId')+''), arrResult);
            }
        }   
        
        if(accountsMap.values().size() > 0){ 
            update accountsMap.values();
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
        //TriggerUtility.isRewardsBatchProcessing = false;
    }
    
    private void aggregateAccountFields(Account accRecord, AggregateResult arrResult){
        // AOS Fields
        accRecord.AOS_Tankless_ranking_points__c = (Decimal)arrResult.get('aosTankless'); // != null  ? conRecord.AOS_Tankless_ranking_points__c : 0 );
        accRecord.AOS_Standard_Tank_ranking_points__c = (Decimal)arrResult.get('aosStdTank'); // null  ? conRecord.AOS_Standard_Tank_ranking_points__c : 0 );
        accRecord.AOS_Solar_ranking_points__c = (Decimal)arrResult.get('aosSolar'); // null  ? conRecord.AOS_Solar_ranking_points__c : 0 );
        accRecord.AOS_High_Efficiency_Gas_ranking_points__c = (Decimal)arrResult.get('aosHighEff'); // null  ? conRecord.AOS_High_Efficiency_Gas_ranking_points__c : 0 );
        accRecord.AOS_Heat_Pump_ranking_points__c = (Decimal)arrResult.get('aosHeatPump'); // null  ? conRecord.AOS_Heat_Pump_ranking_points__c : 0 );
        accRecord.AOS_Commercial_ranking_points__c = (Decimal)arrResult.get('aosCommercial'); // null  ? conRecord.AOS_Commercial_ranking_points__c : 0 );
        accRecord.AOS_Bonus__c = (Decimal)arrResult.get('aosBonus'); // null  ? conRecord.AOS_Commercial_ranking_points__c : 0 );
        accRecord.AOS_Aggregate_ranking_points__c = ((Decimal)arrResult.get('aosArg') + accRecord.Ranking_Points_from_Ratings_Reviews__c); // null  ? conRecord.AOS_Aggregate_ranking_points__c : 0 ) 
        
        // American Fields
        accRecord.American_Tankless_ranking_points__c = (Decimal)arrResult.get('americanTankless'); // null  ? conRecord.American_Tankless_ranking_points__c : 0 );
        accRecord.American_Standard_Tank_ranking_points__c = (Decimal)arrResult.get('americanStdTank'); // null  ? conRecord.American_Standard_Tank_ranking_points__c : 0 );
        accRecord.American_Solar_ranking_points__c = (Decimal)arrResult.get('americanSolar'); // null  ? conRecord.American_Solar_ranking_points__c : 0 );
        accRecord.American_High_Eff_Gas_Ranking_Points__c = (Decimal)arrResult.get('AmericanHighEff'); // null  ? conRecord.AmericanHighEfficiencyGasRankingPoints__c : 0 );
        accRecord.American_Heat_Pump_ranking_points__c  = (Decimal)arrResult.get('americanHeatPump'); // null  ? conRecord.American_Heat_Pump_ranking_points__c : 0 );
        accRecord.American_Commercial_ranking_points__c = (Decimal)arrResult.get('americanCommercial'); // null  ? conRecord.American_Commercial_ranking_points__c : 0 );
        accRecord.American_Bonus__c = (Decimal)arrResult.get('americanBonus'); // null  ? conRecord.American_Commercial_ranking_points__c : 0 );
        accRecord.American_Aggregate_ranking_points__c = ((Decimal)arrResult.get('americanArg') + accRecord.Ranking_Points_from_Ratings_Reviews__c); // null  ? conRecord.American_Aggregate_ranking_points__c : 0 ) + accRecord.Ranking_Points_from_Ratings_Reviews__c);  
        
        // State Fields
        accRecord.State_Tankless_ranking_points__c = (Decimal)arrResult.get('stateTankless'); // null  ? conRecord.State_Tankless_ranking_points__c : 0 );
        accRecord.State_Standard_Tank_ranking_points__c = (Decimal)arrResult.get('stateStdTank'); // null  ? conRecord.State_Standard_Tank_ranking_points__c : 0 );
        accRecord.State_Solar_ranking_points__c = (Decimal)arrResult.get('stateSolar'); // null  ? conRecord.State_Solar_ranking_points__c : 0 );
        accRecord.State_High_Eff_Gas_Ranking_Points__c = (Decimal)arrResult.get('stateHighEff'); // null  ? conRecord.State_High_Efficiency_Gas_ranking_poin__c : 0 );
        accRecord.State_Heat_Pump_ranking_points__c = (Decimal)arrResult.get('stateHeatPump'); // null  ? conRecord.State_Heat_Pump_ranking_points__c : 0 );
        accRecord.State_Commercial_ranking_points__c = (Decimal)arrResult.get('stateCommercial'); // null  ? conRecord.State_Commercial_ranking_points__c : 0 );
        accRecord.State_Bonus__c = (Decimal)arrResult.get('stateBonus'); // null  ? conRecord.State_Commercial_ranking_points__c : 0 );
        accRecord.State_Aggregate_ranking_points__c = ((Decimal)arrResult.get('stateArg') + accRecord.Ranking_Points_from_Ratings_Reviews__c); // null  ? conRecord.State_Aggregate_ranking_points__c : 0 ) + accRecord.Ranking_Points_from_Ratings_Reviews__c);  
        
        // Takagi Field
        accRecord.Takagi_Bonus__c = (Decimal)arrResult.get('takagiBonus'); // null  ? conRecord.State_Commercial_ranking_points__c : 0 );
        accRecord.Takagi_Aggregate_ranking_points__c = ((Decimal)arrResult.get('takagiArg') + accRecord.Ranking_Points_from_Ratings_Reviews__c); // null  ? conRecord.Takagi_Aggregate_ranking_points__c : 0 ) + accRecord.Ranking_Points_from_Ratings_Reviews__c);  
        
        
        // Last 90 Days fields
        // American Last 90 days fields
        accRecord.American_Aggregate_Rank_Point_90_days__c = (Decimal)arrResult.get('americanArg90');
        accRecord.American_Commercial_Rank_Point_90_days__c = (Decimal)arrResult.get('americanCommercial90');
        accRecord.American_Heat_Pump_Rank_Point_90_days__c = (Decimal)arrResult.get('americanHighEff90');
        accRecord.American_High_Eff_Gas_Rank_Point_90_days__c = (Decimal)arrResult.get('americanSolar90');
        accRecord.American_Solar_Rank_Point_90_days__c = (Decimal)arrResult.get('americanSolar90');
        accRecord.American_Std_Tank_Rank_Point_90_days__c = (Decimal)arrResult.get('americanStdTank90');
        accRecord.American_Bonus_90_days__c = (Decimal)arrResult.get('americanBonus90');
        accRecord.American_Tankless_Rank_Point_90_days__c = (Decimal)arrResult.get('americanTankless90');
        
        // AOS Last 90 days fields
        accRecord.AOS_Aggregate_Rank_Point_90_days__c = (Decimal)arrResult.get('aosArg90');
        accRecord.AOS_Commercial_Rank_Point_90_days__c = (Decimal)arrResult.get('aosCommercial90');
        accRecord.AOS_Heat_Pump_Rank_Point_90_days__c = (Decimal)arrResult.get('aosHeatPump90');
        accRecord.AOS_High_Eff_Gas_Rank_Point_90_days__c = (Decimal)arrResult.get('aosHighEff90'); 
        accRecord.AOS_Solar_Rank_Point_90_days__c = (Decimal)arrResult.get('aosSolar90');
        accRecord.AOS_Std_Tank_Rank_Point_90_days__c = (Decimal)arrResult.get('aosStdTank90');
        accRecord.AOS_Bonus_90_days__c = (Decimal)arrResult.get('aosBonus90');
        accRecord.AOS_Tankless_Rank_Point_90_days__c = (Decimal)arrResult.get('aosTankless90');
        
        // State Last 90 days fields
        accRecord.State_Aggregate_Rank_Point_90_days__c = (Decimal)arrResult.get('stateArg90');
        accRecord.State_Commercial_Rank_Point_90_days__c = (Decimal)arrResult.get('stateCommercial90');
        accRecord.State_Heat_Pump_Rank_Point_90_days__c = (Decimal)arrResult.get('stateHeatPump90');
        accRecord.State_High_Eff_Gas_Rank_Point_90_days__c = (Decimal)arrResult.get('stateHighEff90');
        accRecord.State_Solar_Rank_Point_90_days__c = (Decimal)arrResult.get('stateSolar90');
        accRecord.State_Std_Tank_Rank_Point_90_days__c = (Decimal)arrResult.get('stateStdTank90');
        accRecord.State_Bonus_90_days__c = (Decimal)arrResult.get('stateBonus90');
        accRecord.State_Tankless_Rank_Point_90_days__c = (Decimal)arrResult.get('stateTankless90');
        
        // Takagi Last 90 days field
        accRecord.Takagi_Bonus_90_days__c = (Decimal)arrResult.get('takagiBonus90');
        accRecord.Takagi_Aggregate_Rank_Point_90_days__c = (Decimal)arrResult.get('TakagiArg90');
         
        /*if(accRecord.State_Aggregate_Rank_Point_90_days__c == 0 &&  accRecord.AOS_Aggregate_Rank_Point_90_days__c == 0 
                                        && accRecord.American_Aggregate_Rank_Point_90_days__c == 0 && accRecord.Takagi_Aggregate_Rank_Point_90_days__c==0){
            accRecord.AOS_Approved__c = false;                                    
        }
        else{
        	accRecord.AOS_Approved__c = true;
        }*/
    }
    
    private void initializeAllFields(Account accRecord){
        // AOS Fields
        accRecord.AOS_Tankless_ranking_points__c = accRecord.AOS_Standard_Tank_ranking_points__c = accRecord.AOS_Solar_ranking_points__c = accRecord.AOS_Bonus__c
                                                 = accRecord.AOS_High_Efficiency_Gas_ranking_points__c = accRecord.AOS_Heat_Pump_ranking_points__c 
                                                 = accRecord.AOS_Commercial_ranking_points__c = accRecord.AOS_Aggregate_ranking_points__c = 0;

        // American Fields
        accRecord.American_Tankless_ranking_points__c = accRecord.American_Standard_Tank_ranking_points__c = accRecord.American_Solar_ranking_points__c = accRecord.American_Bonus__c
                                                      = accRecord.American_High_Eff_Gas_Ranking_Points__c = accRecord.American_Heat_Pump_ranking_points__c 
                                                      = accRecord.American_Commercial_ranking_points__c = accRecord.American_Aggregate_ranking_points__c = 0;       
        
        // State Fields
         accRecord.State_Tankless_ranking_points__c = accRecord.State_Standard_Tank_ranking_points__c = accRecord.State_Solar_ranking_points__c = accRecord.State_Bonus__c
                                                    = accRecord.State_High_Eff_Gas_Ranking_Points__c = accRecord.State_Heat_Pump_ranking_points__c 
                                                    = accRecord.State_Commercial_ranking_points__c = accRecord.State_Aggregate_ranking_points__c = 0;
        // Takagi Field
        accRecord.Takagi_Aggregate_ranking_points__c = accRecord.AOS_Bonus__c = 0;
        
        // Last 90 Days fields
        accRecord.American_Aggregate_Rank_Point_90_days__c = accRecord.American_Commercial_Rank_Point_90_days__c = accRecord.American_Heat_Pump_Rank_Point_90_days__c = 
                accRecord.American_High_Eff_Gas_Rank_Point_90_days__c = accRecord.American_Solar_Rank_Point_90_days__c = accRecord.American_Std_Tank_Rank_Point_90_days__c = 
                accRecord.American_Tankless_Rank_Point_90_days__c = accRecord.AOS_Aggregate_Rank_Point_90_days__c = accRecord.AOS_Commercial_Rank_Point_90_days__c = accRecord.AOS_Heat_Pump_Rank_Point_90_days__c = 
                accRecord.AOS_High_Eff_Gas_Rank_Point_90_days__c = accRecord.AOS_Solar_Rank_Point_90_days__c = accRecord.AOS_Std_Tank_Rank_Point_90_days__c = accRecord.AOS_Tankless_Rank_Point_90_days__c = 
                accRecord.State_Aggregate_Rank_Point_90_days__c = accRecord.State_Commercial_Rank_Point_90_days__c = accRecord.State_Heat_Pump_Rank_Point_90_days__c = accRecord.State_High_Eff_Gas_Rank_Point_90_days__c = 
                accRecord.State_Solar_Rank_Point_90_days__c = accRecord.State_Std_Tank_Rank_Point_90_days__c = accRecord.State_Tankless_Rank_Point_90_days__c = accRecord.Takagi_Aggregate_Rank_Point_90_days__c =
                accRecord.State_Bonus_90_days__c = accRecord.American_Bonus_90_days__c = accRecord.AOS_Bonus_90_days__c = accRecord.Takagi_Bonus_90_days__c = 0;
    }
}