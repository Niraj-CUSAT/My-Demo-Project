/*
*    Name        : ContactRewardsBatchController 
*    Author      : Sumit Jain
*    Date        : 11/24/2013
*    Description : Batch class that controls the calculation of Contrator Rewards for Contacts based on Brand and Reporting Group
*                  of Contrator Rewards.
*/
global class ContactRewardsBatchController implements Database.Batchable<sObject>{
    
    // Query to get all Contractors record.
    String query = ' Select c.Id, c.Takagi_Bonus__c, c.Takagi_Aggregate_ranking_points__c, c.State_Tankless_ranking_points__c, c.State_Standard_Tank_ranking_points__c, '
                   +' c.State_Solar_ranking_points__c, c.State_High_Eff_Gas_Ranking_Points__c, c.State_Heat_Pump_ranking_points__c, c.State_Commercial_ranking_points__c, '
                   +' c.State_Bonus__c, c.State_Aggregate_ranking_points__c, c.American_Tankless_ranking_points__c, c.American_Standard_Tank_ranking_points__c, c.American_Solar_ranking_points__c, '
                   +' c.American_High_Eff_Gas_Ranking_Points__c, c.American_Heat_Pump_ranking_points__c, c.American_Commercial_ranking_points__c, c.American_Bonus__c, '
                   +' c.American_Aggregate_ranking_points__c, c.AOS_Tankless_ranking_points__c, c.AOS_Standard_Tank_ranking_points__c, c.AOS_Solar_ranking_points__c, '
                   +' c.AOS_High_Efficiency_Gas_ranking_points__c, c.AOS_Heat_Pump_ranking_points__c, c.AOS_Commercial_ranking_points__c, c.AOS_Bonus__c, '
                   +' c.American_Aggregate_Rank_Point_90_days__c, c.American_Commercial_Rank_Point_90_days__c, c.American_Heat_Pump_Rank_Point_90_days__c, '
                   +' c.American_High_Eff_Gas_Rank_Point_90_days__c, c.American_Solar_Rank_Point_90_days__c, c.American_Std_Tank_Rank_Point_90_days__c, '
                   +' c.American_Tankless_Rank_Point_90_days__c, c.AOS_Aggregate_Rank_Point_90_days__c, c.AOS_Commercial_Rank_Point_90_days__c, c.AOS_Heat_Pump_Rank_Point_90_days__c, '
                   +' c.AOS_High_Eff_Gas_Rank_Point_90_days__c, c.AOS_Solar_Rank_Point_90_days__c, c.AOS_Std_Tank_Rank_Point_90_days__c, c.AOS_Tankless_Rank_Point_90_days__c, '
                   +' c.State_Aggregate_Rank_Point_90_days__c, c.State_Commercial_Rank_Point_90_days__c, c.State_Heat_Pump_Rank_Point_90_days__c, c.State_High_Eff_Gas_Rank_Point_90_days__c, '
                   +' c.State_Solar_Rank_Point_90_days__c, c.State_Std_Tank_Rank_Point_90_days__c, c.State_Tankless_Rank_Point_90_days__c, c.Takagi_Bonus_90_Days__c, c.Takagi_Aggregate_Rank_Point_90_days__c, '
                   +' c.AOS_Bonus_90_days__c, c.State_Bonus_90_days__c, c.American_Bonus_90_days__c, '
                   +' c.AOS_Aggregate_ranking_points__c From Contact c WHERE RecordType.Name=\'Contractor\''; // AND Id=\'003M000000QtlAr\'';
     
                
    // Start Meth
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Contact> contacts){
        
        // Set TriggerUtility.isRewardsBatchProcess = true to prevent Contact triggers from there execution.
        TriggerUtility.isRewardsBatchProcessing = true;
         
        // Logic to be Executed batch wise 
        Map<String, Contact> contactsMap = new Map<String, Contact>();
        
        for(Contact conRec : contacts){
            initalizeAllFields(conRec);
            contactsMap.put(conRec.Id, conRec);
        }  
        
        Set<String> brandNameSet = new Set<String>{'AOS', 'State', 'American', 'Takagi'};
        Set<String> reportingGroupSet = new Set<String>{'standard gas & electric', 'heat pump', 'high efficiency gas', 'tankless', 'solar', 'commercial',  'bonus'};
        
        // Aggregate Query to collect Sum of all Combinations of Brand Name and Reporting Groups.           
        List<AggregateResult> arrAllDaysCRsResult = [SELECT Sum(Relative_Date_Calculated__c) totalRewards, Brand_Name__c, Reporting_Group__c, Contractor__c FROM Contractor_Rewards__c 
                                            WHERE Brand_Name_Calculated__c in:brandNameSet AND Contractor__c in:contactsMap.keyset() // AND Reporting_Group__c in:reportingGroupSet
                                            group by Brand_Name__c, Reporting_Group__c, Contractor__c ];  
        
        for(AggregateResult arrResult: arrAllDaysCRsResult){
            
            // Populate State fields
            if((arrResult.get('Brand_Name__c')+'').toUpperCase().contains('STATE') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null 
                                                                                   && reportingGroupSet.contains((arrResult.get('Reporting_Group__c')+'').toLowerCase())){
                populateContactStateFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
            
            // Populate American fields.
            if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('AMERICAN') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null
                                                                                      && reportingGroupSet.contains((arrResult.get('Reporting_Group__c')+'').toLowerCase())){
                populateContactAmericanFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
            
            // Populate A. O. Smith fields.
            if((((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('SMITH') || ((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('AOS')) 
                            && contactsMap.get((arrResult.get('Contractor__c')+'')) != null && reportingGroupSet.contains((arrResult.get('Reporting_Group__c')+'').toLowerCase())){
                populateContactAOSmithFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
            
            /*// Takagi + Bonus
            if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('TAKAGI') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null
                                                                        && ((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
                conRecord.Takagi_Bonus__c = (Decimal)arrResult.get('totalRewards');
            }
            
            // Takagi + Aggregate
            if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('TAKAGI') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null){
                contactsMap.get((arrResult.get('Contractor__c')+'')).Takagi_Aggregate_ranking_points__c = (Decimal)arrResult.get('totalRewards');
            }*/
            
            // Populate Takagi fields.
            if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('TAKAGI') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null ){
                populateContactTakagiFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
        }
        
        // Aggregate Last 90 days records.
        List<AggregateResult> arr90DaysCRsResult = [SELECT count(Id) totalRewards, Brand_Name__c, Reporting_Group__c, Contractor__c FROM Contractor_Rewards__c 
                                                    WHERE Brand_Name_Calculated__c in:brandNameSet AND Contractor__c in:contactsMap.keyset() AND Relative_Date_Calculated__c > 0.04 // AND Reporting_Group__c in:reportingGroupSet
                                                    group by Brand_Name__c, Reporting_Group__c, Contractor__c ];  
        
        for(AggregateResult arrResult: arr90DaysCRsResult){
            // Populate State fields
            if((arrResult.get('Brand_Name__c')+'').toUpperCase().contains('STATE') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null 
                                                                                   && reportingGroupSet.contains((arrResult.get('Reporting_Group__c')+'').toLowerCase())){
                populateContactStateLast90DaysFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
            
            // Populate American fields.
            if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('AMERICAN') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null
                                                                                      && reportingGroupSet.contains((arrResult.get('Reporting_Group__c')+'').toLowerCase())){
                populateContactAmericanLast90DaysFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
            
            // Populate A. O. Smith fields.
            if((((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('SMITH') || ((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('AOS')) 
                            && contactsMap.get((arrResult.get('Contractor__c')+'')) != null && reportingGroupSet.contains((arrResult.get('Reporting_Group__c')+'').toLowerCase())){
                populateContactAOSSmithLast90DaysFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
            
            /*if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('TAKAGI') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null){
                contactsMap.get((arrResult.get('Contractor__c')+'')).Takagi_Aggregate_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
            }*/
            
            // Populate Takagi fields.
            if(((arrResult.get('Brand_Name__c')+'').toUpperCase()).contains('TAKAGI') && contactsMap.get((arrResult.get('Contractor__c')+'')) != null ){
                populateContactTakagiLast90DaysFields(contactsMap.get((arrResult.get('Contractor__c')+'')), arrResult);
            }
        }
        
        
        // Update Contractors Record.
        if(contactsMap.values().size() > 0){
            update contactsMap.values(); 
        }
        
    }
    // Logic to be Executed at finish
    global void finish(Database.BatchableContext BC){
        // Start Account's batch class execution. 
        AccountContactsRewardBatchController acBatchObj = new AccountContactsRewardBatchController();
        Database.executeBatch(acBatchObj, 50);
        
        TriggerUtility.isRewardsBatchProcessing = false;
        
    }
    
    private void populateContactStateFields(Contact conRecord, AggregateResult arrResult){
        
        // STATE - Standard Gas & Electric
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric')){
            conRecord.State_Standard_Tank_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Heat Pump
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('heat pump') ){
            conRecord.State_Heat_Pump_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - High Efficiency Gas
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('high efficiency gas') ){
            conRecord.State_High_Eff_Gas_Ranking_Points__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Tankless
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('tankless') ){
            conRecord.State_Tankless_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE + Solar
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('solar') ){
            conRecord.State_Solar_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE + Commercial
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('commercial') ){
            conRecord.State_Commercial_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE + Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.State_Bonus__c = (Decimal)arrResult.get('totalRewards');
        }
        // State - Aggregate ranking points (Sum of all State ranking point fields)
        conRecord.State_Aggregate_ranking_points__c = (conRecord.State_Standard_Tank_ranking_points__c + conRecord.State_Heat_Pump_ranking_points__c + conRecord.State_High_Eff_Gas_Ranking_Points__c 
                                                       + conRecord.State_Tankless_ranking_points__c + conRecord.State_Solar_ranking_points__c + conRecord.State_Commercial_ranking_points__c 
                                                       + conRecord.State_Bonus__c);
    }
    
    // Populate Contact Takagi fields here.
    private void populateContactTakagiFields(Contact conRecord, AggregateResult arrResult){
        // Takagi - Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.Takagi_Bonus__c = (Decimal)arrResult.get('totalRewards');
        }
        
        // Takagi - Aggregate
        conRecord.Takagi_Aggregate_ranking_points__c += (Decimal)arrResult.get('totalRewards');
    }
    
    private void populateContactAmericanFields(Contact conRecord, AggregateResult arrResult){
        
        // American - Standard Gas & Electric
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric') ){ 
            conRecord.American_Standard_Tank_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Heat Pump
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('heat pump') ){
            conRecord.American_Heat_Pump_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - High Efficiency Gas
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('high efficiency gas') ){
            conRecord.American_High_Eff_Gas_Ranking_Points__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Tankless
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('tankless') ){
            conRecord.American_Tankless_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // American + Solar
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('solar') ){
            conRecord.American_Solar_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // American + Commercial
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('commercial') ){
            conRecord.American_Commercial_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // American + Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.American_Bonus__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Aggregate ranking points (Sum of all American ranking point fields)
        conRecord.American_Aggregate_ranking_points__c = (conRecord.American_Standard_Tank_ranking_points__c + conRecord.American_Heat_Pump_ranking_points__c + conRecord.American_High_Eff_Gas_Ranking_Points__c 
                                                       + conRecord.American_Tankless_ranking_points__c + conRecord.American_Solar_ranking_points__c + conRecord.American_Commercial_ranking_points__c 
                                                       + conRecord.American_Bonus__c);
    }
    
    private void populateContactAOSmithFields(Contact conRecord, AggregateResult arrResult){
        System.debug('Reporting Group ::::: '+arrResult.get('Reporting_Group__c')+' Result :: '+((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric'));
        // AOS - Standard Gas & Electric
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric') ){
            conRecord.AOS_Standard_Tank_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Heat Pump
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('heat pump') ){
            conRecord.AOS_Heat_Pump_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - High Efficiency Gas
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('high efficiency gas') ){
            conRecord.AOS_High_Efficiency_Gas_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Tankless
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('tankless') ){
            conRecord.AOS_Tankless_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS + Solar
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('solar') ){
            conRecord.AOS_Solar_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS + Commercial
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('commercial') ){
            conRecord.AOS_Commercial_ranking_points__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS + Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.AOS_Bonus__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Aggregate ranking points (Sum of all AOS ranking point fields)
        conRecord.AOS_Aggregate_ranking_points__c = (conRecord.AOS_Standard_Tank_ranking_points__c + conRecord.AOS_Heat_Pump_ranking_points__c + conRecord.AOS_High_Efficiency_Gas_ranking_points__c 
                                                       + conRecord.AOS_Tankless_ranking_points__c + conRecord.AOS_Solar_ranking_points__c + conRecord.AOS_Commercial_ranking_points__c 
                                                       + conRecord.AOS_Bonus__c);
    }
    
    private void initalizeAllFields(Contact conRecord){
        // AOS Fields
        conRecord.AOS_Standard_Tank_ranking_points__c = conRecord.AOS_Heat_Pump_ranking_points__c = conRecord.AOS_High_Efficiency_Gas_ranking_points__c 
                    = conRecord.AOS_Tankless_ranking_points__c = conRecord.AOS_Solar_ranking_points__c = conRecord.AOS_Commercial_ranking_points__c 
                    = conRecord.AOS_Bonus__c = conRecord.AOS_Aggregate_ranking_points__c = 0;
                                                      
        // American Fields
        conRecord.American_Standard_Tank_ranking_points__c = conRecord.American_Heat_Pump_ranking_points__c = conRecord.American_High_Eff_Gas_Ranking_Points__c 
                    = conRecord.American_Tankless_ranking_points__c = conRecord.American_Solar_ranking_points__c = conRecord.American_Commercial_ranking_points__c 
                    = conRecord.American_Bonus__c = conRecord.American_Aggregate_ranking_points__c = 0;
        
        // State Fields
        conRecord.State_Standard_Tank_ranking_points__c = conRecord.State_Heat_Pump_ranking_points__c = conRecord.State_High_Eff_Gas_Ranking_Points__c 
                    = conRecord.State_Tankless_ranking_points__c = conRecord.State_Solar_ranking_points__c = conRecord.State_Commercial_ranking_points__c 
                    = conRecord.State_Bonus__c = conRecord.State_Aggregate_ranking_points__c = 0;
        
        // Takagi Fields
        conRecord.Takagi_Aggregate_ranking_points__c = conRecord.Takagi_Bonus__c = 0;    
        
        // Last 90 days fields
        conRecord.American_Aggregate_Rank_Point_90_days__c = conRecord.American_Commercial_Rank_Point_90_days__c = conRecord.American_Heat_Pump_Rank_Point_90_days__c = 
                   conRecord.American_High_Eff_Gas_Rank_Point_90_days__c = conRecord.American_Solar_Rank_Point_90_days__c = conRecord.American_Std_Tank_Rank_Point_90_days__c = 
                   conRecord.American_Tankless_Rank_Point_90_days__c = conRecord.AOS_Aggregate_Rank_Point_90_days__c = conRecord.AOS_Commercial_Rank_Point_90_days__c = conRecord.AOS_Heat_Pump_Rank_Point_90_days__c = 
                   conRecord.AOS_High_Eff_Gas_Rank_Point_90_days__c = conRecord.AOS_Solar_Rank_Point_90_days__c = conRecord.AOS_Std_Tank_Rank_Point_90_days__c = conRecord.AOS_Tankless_Rank_Point_90_days__c = 
                   conRecord.State_Aggregate_Rank_Point_90_days__c = conRecord.State_Commercial_Rank_Point_90_days__c = conRecord.State_Heat_Pump_Rank_Point_90_days__c = conRecord.State_High_Eff_Gas_Rank_Point_90_days__c = 
                   conRecord.State_Solar_Rank_Point_90_days__c = conRecord.State_Std_Tank_Rank_Point_90_days__c = conRecord.State_Tankless_Rank_Point_90_days__c = conRecord.Takagi_Aggregate_Rank_Point_90_days__c = 
                   conRecord.AOS_Bonus_90_Days__c = conRecord.American_Bonus_90_Days__c = conRecord.State_Bonus_90_Days__c = conRecord.Takagi_Bonus_90_Days__c = 0;
                   
    }   
     
    // Takagi fields - Last 90 Days.    
     private void populateContactTakagiLast90DaysFields(Contact conRecord, AggregateResult arrResult){
        // Takagi + Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.Takagi_Bonus_90_Days__c = (Decimal)arrResult.get('totalRewards');
        }
        
        conRecord.Takagi_Aggregate_Rank_Point_90_days__c += (Decimal)arrResult.get('totalRewards');
        
     }
     
     // State fields - Last 90 Days.    
     private void populateContactStateLast90DaysFields(Contact conRecord, AggregateResult arrResult){
        
        // STATE - Standard Gas & Electric
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric')){
            conRecord.State_Std_Tank_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Heat Pump
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('heat pump') ){
            conRecord.State_Heat_Pump_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - High Efficiency Gas
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('high efficiency gas') ){
            conRecord.State_High_Eff_Gas_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Tankless
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('tankless') ){
            conRecord.State_Tankless_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Solar
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('solar') ){
            conRecord.State_Solar_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Commercial
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('commercial') ){
            conRecord.State_Commercial_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.State_Bonus_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // STATE - Aggregate ranking points (Sum of all State ranking point fields)
        conRecord.State_Aggregate_Rank_Point_90_days__c = (conRecord.State_Std_Tank_Rank_Point_90_days__c + conRecord.State_Heat_Pump_Rank_Point_90_days__c + conRecord.State_High_Eff_Gas_Rank_Point_90_days__c 
                                                       + conRecord.State_Tankless_Rank_Point_90_days__c + conRecord.State_Solar_Rank_Point_90_days__c + conRecord.State_Commercial_Rank_Point_90_days__c
                                                       + conRecord.State_Bonus_90_days__c );
                                                       
    }
    
    // AOS fields - Last 90 Days.    
     private void populateContactAOSSmithLast90DaysFields(Contact conRecord, AggregateResult arrResult){
        
        // AOS - Standard Gas & Electric
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric')){
            conRecord.AOS_Std_Tank_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Heat Pump
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('heat pump') ){
            conRecord.AOS_Heat_Pump_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - High Efficiency Gas
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('high efficiency gas') ){
            conRecord.AOS_High_Eff_Gas_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Tankless
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('tankless') ){
            conRecord.AOS_Tankless_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Solar
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('solar') ){
            conRecord.AOS_Solar_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Commercial
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('commercial') ){
            conRecord.AOS_Commercial_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.AOS_Bonus_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // AOS - Aggregate ranking points (Sum of all AOS ranking point fields)
        conRecord.AOS_Aggregate_Rank_Point_90_days__c = (conRecord.AOS_Std_Tank_Rank_Point_90_days__c + conRecord.AOS_Heat_Pump_Rank_Point_90_days__c + conRecord.AOS_High_Eff_Gas_Rank_Point_90_days__c 
                                                       + conRecord.AOS_Tankless_Rank_Point_90_days__c + conRecord.AOS_Solar_Rank_Point_90_days__c + conRecord.AOS_Commercial_Rank_Point_90_days__c
                                                       + conRecord.AOS_Bonus_90_days__c );
                                                       
    }
    
    // American fields - Last 90 Days.    
     private void populateContactAmericanLast90DaysFields(Contact conRecord, AggregateResult arrResult){
        
        // American - Standard Gas & Electric
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('standard gas & electric')){
            conRecord.American_Std_Tank_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Heat Pump
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('heat pump') ){
            conRecord.American_Heat_Pump_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        
        // American - High Efficiency Gas
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('high efficiency gas') ){
            conRecord.American_High_Eff_Gas_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Tankless
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('tankless') ){
            conRecord.American_Tankless_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Solar
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('solar') ){
            conRecord.American_Solar_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Commercial
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('commercial') ){
            conRecord.American_Commercial_Rank_Point_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Bonus
        if(((arrResult.get('Reporting_Group__c')+'').toLowerCase()).equals('bonus') ){
            conRecord.American_Bonus_90_days__c = (Decimal)arrResult.get('totalRewards');
        }
        // American - Aggregate ranking points (Sum of all American ranking point fields)
        conRecord.American_Aggregate_Rank_Point_90_days__c = (conRecord.American_Std_Tank_Rank_Point_90_days__c + conRecord.American_Heat_Pump_Rank_Point_90_days__c + conRecord.American_High_Eff_Gas_Rank_Point_90_days__c 
                                                       + conRecord.American_Tankless_Rank_Point_90_days__c + conRecord.American_Solar_Rank_Point_90_days__c + conRecord.American_Commercial_Rank_Point_90_days__c 
                                                       + conRecord.American_Bonus_90_days__c);
                                                       
    }
}