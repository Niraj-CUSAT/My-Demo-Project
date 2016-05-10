/* Written By:- Shweta Kumari
   Written On:- 6/02/2014
   Description:- 1) To validate AMC and to make sure that one Asset have only one Active Contract 
                 2) To validate AMC related to product which is related to selected Asset
                 3) code to update Contract start date, contract end date and contract status in asset
                 4) code to deactivate other AMC Pin record when a contract is created for one pin of particular pin number
   */

trigger validateContractBeforeInsertUpdate on AOSI_Contract__c (before insert , before update, after insert, after update,after delete) {
    set<id> assetId = new set<id>();
    set<id> contactId = new set<id>();
    set<string> contractKey = new set<string>();
    set<id> productId = new set<id>();    
    map<id , id> AMCMap = new map<id , id>();
    map<id , id> contractMap = new map<id , id>();
    map<id , id> caseMap = new map<id , id>();
    map<id , id> contactMap = new map<id , id>();
    map<id , id> assetProMap = new map<id , id>();
    list<Asset> newAssetList = new list<Asset>();   
    list<asset> assetList = new list<Asset>();
    List<AOSI_Contract__c> contractList = new List<AOSI_Contract__c>();
    list<product2> productList = new list<product2>();
    List<case> caselist = new list<case>();
    List<Product_AMC_Junction__c> proAssetList = new List<Product_AMC_Junction__c>();
    Set<id> AMCIds = new Set<id>();
    
    Map<Id,Id> currentContractAssetID = new Map<Id,Id>();
    Map<Id,AOSI_Contract__c> aosiContractDetails = new Map<Id,AOSI_Contract__c>();
    List<AOSI_Contract__c> currentAosiContractDetails = new List<AOSI_Contract__c>();
    
    if(trigger.isinsert || trigger.isupdate){
            //code to get asset id
            for(AOSI_Contract__c con : trigger.new){
                assetId.add(con.AOSI_Asset__c); 
                AMCIds.add(con.AOSI_AMC__c);                 
            }
            //list of Asset which are selected in Contract
            assetList = [select id, Product2Id,AOSI_Contract_Start_Date__c,AOSI_Contract_End_Date__c,AOSI_Contract_Status__c from asset where id In: assetId];
            //code to get Productid
            for(asset ast : assetList){
                productId.add(ast.Product2Id );
                assetProMap.put(ast.id, ast.Product2Id);
            }
            //list of Contract related to asset
            contractList = [Select id,AOSI_Start_Date__c,AOSI_Asset__c,AOSI_Contract_Status__c,AOSI_AMC__r.AOSI_Contract_Type__c,AOSI_AMC__r.Number_Of_PM_Visits__c,PHCP_PM_Date1__c,PHCP_PM_Date2__c,PHCP_PM_Date3__c from AOSI_Contract__c where AOSI_Asset__c In: assetId AND AOSI_Contract_Status__c =: 'Active'];
            //code to store contract id for related Assetid
            if(contractList.Size() > 0){
                for(AOSI_Contract__c con : contractList){
                    contractMap.put(con.AOSI_Asset__c,con.id);               
                }            
            }
            //list of product for selected Asset
           // productList = [Select id, AOSI_AMC__c from Product2 where Id IN: productId];
            proAssetList = [select id, AMC_Master__c,Product__c from Product_AMC_Junction__c where Product__c IN : productId And AMC_Master__c IN : AMCIds];
            //code to store AMC related to assetid
            /*for(Product2 pr : productList ){
                for(asset ast : assetList){
                    if(ast.Product2Id == pr.id){
                        AMCMap.put(ast.id,pr.AOSI_AMC__c);    
                    }
                }
            }*/
            for(Product_AMC_Junction__c pm : proAssetList){
                AMCMap.put(pm.AMC_Master__c,pm.Product__c);    
            }
            //list of case related to asset
            caselist =[select id,AssetId from Case where AssetId In:assetId AND Reason =: 'Contract Request' AND Status !=: 'Closed'];   
            //code to store case id for particular asset
            for(case cs: caselist){        
                caseMap.put(cs.id,cs.AssetId);    
            } 
        }
    List<AOSI_Contract__c> aosiContractPMDate = new List<AOSI_Contract__c>();
    
    if(trigger.isbefore && trigger.isUpdate && !trigger.isInsert){        
                
            System.debug('%%%%%%%%%%%%%%%%%%%%%');  
            System.debug('%%%%%%%%%%%%%%%%%%%%% AMCMap' + AMCMap); 
            System.debug('%%%%%%%%%%%%%%%%%%%%% assetProMap' + assetProMap);   
             List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(AOSI_Contract__c con : trigger.new){ 
                        
                //code to validate AMC
                if((AMCMap.get(con.AOSI_AMC__c)!= assetProMap.get(con.AOSI_Asset__c)|| proAssetList.size() <= 0 ) && con.AOSI_AMC__c != null ){
                    System.debug('%%%%%%%%%%%%%%%%%%%%%'+con.PHCP_PM_Date1__c); 
                   
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {'pooja.bhat@kvpcorp.com'};
                    mail.setToAddresses(toAddresses);
                    mail.setSenderDisplayName('AO Smith');
                    //String[] toCC = new String[] {'honey.narang@kvpcorp.com','dhriti.moulick@kvpcorp.com'};                 
                    //mail.setCcAddresses(toCC);
                    mail.setSubject('TIME DEPENDENT WORKFLOW ACTION ERROR');
                    String body = 'Record Details '  + con  ;
                    mail.setPlainTextBody(body);
                    system.debug('****body*****'+body);
                    mails.add(mail);
                    system.debug('****mail*****'+mails);
                   
                    con.adderror('Please select AMC related to product which is related to selected Asset');        
                }
                
                if(con.AOSI_Amount_Received__c == true && con.AOSI_Start_Date__c != null && (trigger.oldMap.get(con.id).AOSI_Amount_Received__c != con.AOSI_Amount_Received__c || trigger.oldMap.get(con.id).AOSI_Start_Date__c != con.AOSI_Start_Date__c)){
                    con.AOSI_Contract_Status__c = 'Active';
                }
               
            } 
             try {
                    Messaging.sendEmail(mails);
             } catch ( Exception e) { System.debug('Exception while sending email from validateContractBeforeInsertUpdate ' + e);}
             
            for(AOSI_Contract__c con : contractList){
                  System.debug('%%%%%%%%%%%%%%%%%%%%%'+con.PHCP_PM_Date1__c);      
                 System.debug('%%%%%%%%%%%%%%%%%%%%%'+con.AOSI_AMC__r.AOSI_Contract_Type__c);   
                 System.debug('%%%%%%%%%%%%%%%%%%%%%'+con.AOSI_AMC__r.Number_Of_PM_Visits__c);   
                 System.debug('%%%%%%%%%%%%%%%%%%%%%'+con.AOSI_Contract_Status__c);    
                 /*Code added by:Dhriti Krishna Ghosh Moulick************************/
                if(con.AOSI_Contract_Status__c == 'Active' && con.AOSI_AMC__r.AOSI_Contract_Type__c=='WT-AMC' && con.AOSI_AMC__r.Number_Of_PM_Visits__c=='2' && (con.PHCP_PM_Date1__c==null || con.PHCP_PM_Date2__c==null)){
                    con.PHCP_PM_Date1__c=con.AOSI_Start_Date__c.addDays(180);
                    con.PHCP_PM_Date2__c=con.AOSI_Start_Date__c.addDays(358);
                }else if(con.AOSI_Contract_Status__c == 'Active' && con.AOSI_AMC__r.AOSI_Contract_Type__c=='WT-ACMC' && con.AOSI_AMC__r.Number_Of_PM_Visits__c=='3' && (con.PHCP_PM_Date1__c==null || con.PHCP_PM_Date2__c==null || con.PHCP_PM_Date3__c==null)){
                    con.PHCP_PM_Date1__c=con.AOSI_Start_Date__c.addDays(120);
                    con.PHCP_PM_Date2__c=con.AOSI_Start_Date__c.addDays(240);
                    con.PHCP_PM_Date3__c=con.AOSI_Start_Date__c.addDays(358);
                }else if(con.AOSI_Contract_Status__c == 'Active' && con.AOSI_AMC__r.AOSI_Contract_Type__c=='WT-Filter Plan' && con.AOSI_AMC__r.Number_Of_PM_Visits__c=='1' && con.PHCP_PM_Date1__c==null){
                    
                    Date startDate=con.AOSI_Start_Date__c;
                    System.debug('^^^^^^^^^^startDate^^^^^^^^^^^'+startDate);
                    con.PHCP_PM_Date1__c=startDate.addDays(358);
                    con.AOSI_Amount_Received_Date__c=System.today();
                    System.debug('^^^^^^^^^^firstPM^^^^^^^^^^^'+con.PHCP_PM_Date1__c);
                }
                //aosiContractPMDate.add(con);
                /**********************************************/
            }
            
           
       // update aosiContractPMDate;
        for(AOSI_Contract__c con : trigger.new){
            //code to make contract unique for particular asset
            if(contractMap.get(con.AOSI_Asset__c)!= null && contractMap.get(con.AOSI_Asset__c)!= con.id && con.AOSI_Contract_Status__c == 'Active'){
                //con.adderror('Selected Asset already have active Contract');
            }
            //code to validate case        
           // if(caseMap.get(con.AOSI_Case__c) != con.AOSI_Asset__c && con.AOSI_Case__c != null){
            //  con.adderror('Please select Case with Case Reason "Contract Request" related to asset');
            //}
        }
    }    
    //code to update asset based on contract
    if(trigger.isAfter){
        date todaysDate = System.today();
        system.debug('***todays date'+todaysDate);
        if(trigger.isInsert || trigger.isUpdate){           
            //code to update Contract start date, contract end date and contract status in asset
            
            for(AOSI_Contract__c con: Trigger.new){
                currentContractAssetID.put(con.Id,con.AOSI_Asset__c);
            }
              System.debug('^^^^^^^^^^^^currentContractAssetID^^^^^^^^^^'+currentContractAssetID);
            if(Trigger.isInsert){
                for(Asset aos:[Select Id,(Select Id,CreatedDate,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Contract_Status__c,AOSI_Asset__c 
                    from Contracts__r where  CreatedDate < :todaysDate ORDER BY CreatedDate DESC LIMIT 1)
                    from Asset WHERE Id in:currentContractAssetID.values()]){
                        System.debug('^^^^^^^^^^^^aos^^^^^^^^^^'+aos);
                        //System.debug('^^^^^^^^^^^^aos.contracts__r^^^^^^^^^^'+aos.contracts__r[0]);
                      System.debug('^^^^^^^^^^^^aos.contracts__r^^^^^^^^^^'+aos.contracts__r.size());
                      if(aos.contracts__r.size()>0){
                      aosiContractDetails.put(aos.Id ,aos.contracts__r[0]);  
                      } 
                       System.debug('^^^^^^^^^^^^aosiContractDetails^^^^^^^^^^'+aosiContractDetails);   
                }
            
            List<AggregateResult> aosiContracts =[Select Max(AOSI_End_Date__c),Id 
                                          from AOSI_Contract__c where Id in:currentContractAssetID.keySet() group by Id];
            System.debug('^^^^^^^^^^^^aosiContracts^^^^^^^^^^'+aosiContracts);
            
              System.debug('&&&&&&&&&&&&&aosiContractDetails&&&&&&&&&&'+aosiContractDetails);
             if(aosiContractDetails.size()>0){
                 System.debug('&&&&&&&&&&&&&aosiContractDetails.size()&&&&&&&&&&'+aosiContractDetails.size());
                  for(AOSI_Contract__c aosicontract:Trigger.new){
          
                        System.debug(aosicontract.Id);
                        Date convertCreatedDate = date.newinstance(aosicontract.CreatedDate.year(), aosicontract.CreatedDate.month(), aosicontract.CreatedDate.day());
                        Date dateAsset = (aosiContractDetails.get(aosicontract.AOSI_Asset__c).AOSI_End_Date__c - 30);
                        System.debug('&&&&&&&&&&&&&dateAsset &&&&&&&&&&'+dateAsset );
                        System.debug('&&&&&&&&&&&&&dateAsset &&&&&&&&&&'+(aosiContractDetails.get(aosicontract.AOSI_Asset__c)).AOSI_Contract_Status__c);
                        if(convertCreatedDate  <(aosiContractDetails.get(aosicontract.AOSI_Asset__c).AOSI_End_Date__c - 30) ){
                          aosicontract.addError('New Contract Created Date always be within less than 30 days of End date of previous contract');
                        }
                        if((aosicontract.AOSI_Start_Date__c<(aosiContractDetails.get(aosicontract.AOSI_Asset__c)).AOSI_End_Date__c) && (aosiContractDetails.get(aosicontract.AOSI_Asset__c)).AOSI_Contract_Status__c!='Active'){
                          aosicontract.addError('New Contract Start Date always be greater than End date of previous contract');
                        }
                        if((aosicontract.AOSI_Start_Date__c<(aosiContractDetails.get(aosicontract.AOSI_Asset__c)).AOSI_End_Date__c) && (aosiContractDetails.get(aosicontract.AOSI_Asset__c)).AOSI_Contract_Status__c=='Active'){
                          aosicontract.addError('Selected Asset already have active Contract');
                        }
                  }
              }
            }
            
            for(AOSI_Contract__c con : trigger.new) {                            
                    for(asset ast : assetList){                    
                        if(ast.id == con.AOSI_Asset__c &&(ast.AOSI_Contract_End_Date__c <= con.AOSI_End_Date__c || ast.AOSI_Contract_End_Date__c == null)&& (con.AOSI_Contract_Status__c=='Active'||con.AOSI_Contract_Status__c=='Inactive'||con.AOSI_Contract_Status__c=='Terminated')){                                                       
                                ast.AOSI_Contract_Start_Date__c = con.AOSI_Start_Date__c; 
                                ast.AOSI_Contract_End_Date__c = con.AOSI_End_Date__c;
                                ast.AOSI_Contract_Charges__c = con.AOSI_Total_Amount__c; 
                                ast.AOSI_Contract_Number__c = con.AOSI_Contract_Number__c; 
                                if(con.AOSI_Contract_Status__c=='Active'){                          
                                    ast.AOSI_Contract_Status__c = 'In Contract';
                                }
                                else{
                                    ast.AOSI_Contract_Status__c = 'Out of Contract';
                                }                            
                            newAssetList.add(ast);
                        } 
                    }                                      
            }            
            try{
                database.update(newAssetList, false); 
            } 
            catch(exception e){
                system.debug('-------e--------'+e);
            }             
        } 
        // code to deactivate other AMC Pin record when a contract is created for one pin of particular pin number  
        if(trigger.isInsert){
            for(AOSI_Contract__c con : trigger.new){                
                List<String> parts = con.Name.split(' ');               
                string key =parts[parts.size()-1]; 
                contractKey.add(key); 
                assetId.add(con.AOSI_Asset__c);                                               
            } 
            //list of Asset which are selected in Contract
            list<asset> assetList1 = [select id, Product2Id,AOSI_Contract_Start_Date__c,AOSI_Contract_End_Date__c,AOSI_Contract_Status__c,ContactId from asset where id In: assetId];           
            //code to get Productid
            for(asset ast : assetList1){                
                contactMap.put(ast.id,ast.ContactId);
            }
            //query to get the pin record for particular contact and product  
            List<AMC_Pin__c> amcPinList = [Select id,AOSI_Active__c,AOSI_Type__c,AOSI_AMC_Pin_Number__c,Case__c,Asset__c,AOSI_Contact__c,AOSI_Key_Number__c from AMC_Pin__c where AOSI_Key_Number__c IN: contractKey];
            //code to deactivate the other pin record related to particular contact and product
            for(AOSI_Contract__c con : trigger.new){
                    List<String> parts = con.Name.split(' ');               
                    string type =parts[0];
                    string key =parts[parts.size()-1];
                    for(AMC_Pin__c pin: amcPinList){                   
                        if(pin.AOSI_Key_Number__c == key && pin.AOSI_Type__c != type){
                            pin.AOSI_Active__c = false;
                            pin.AOSI_Contact__c = contactMap.get(con.AOSI_Asset__c);
                            pin.Asset__c = con.AOSI_Asset__c;
                            pin.Case__c = con.AOSI_Case__c;
                        }
                        if(pin.AOSI_Key_Number__c == key && pin.AOSI_Type__c == type){
                            pin.AOSI_Contact__c = contactMap.get(con.AOSI_Asset__c);
                            pin.Asset__c = con.AOSI_Asset__c;
                            pin.Case__c = con.AOSI_Case__c;
                        }    
                    }                          
            }
            try{
                database.update(amcPinList, false); 
            } 
            catch(exception e){
                system.debug('-------e--------'+e);
            }  
        }
        if(trigger.isdelete){
            //code to get asset id
            for(AOSI_Contract__c con : trigger.old){
                assetId.add(con.AOSI_Asset__c);                  
            }
            //list of Asset which are selected in Contract
            list<asset> assetList2 = [select id, Product2Id,AOSI_Contract_Start_Date__c,AOSI_Contract_End_Date__c,AOSI_Contract_Status__c from asset where id In: assetId];
            //code to update Contract start date, contract end date and contract status in asset
            for(AOSI_Contract__c con : trigger.old) {                          
                for(asset ast : assetList2){
                     if(ast.id == con.AOSI_Asset__c &&(ast.AOSI_Contract_End_Date__c == con.AOSI_End_Date__c)&& (con.AOSI_Contract_Status__c=='Active'||con.AOSI_Contract_Status__c=='Inactive'||con.AOSI_Contract_Status__c=='Terminated')){                                                       
                            ast.AOSI_Contract_Start_Date__c = null; 
                            ast.AOSI_Contract_End_Date__c = null;  
                            ast.AOSI_Contract_Status__c = null;                              
                            newAssetList.add(ast);
                        } 
                }                   
            }            
            try{
                database.update(newAssetList, false); 
            } 
            catch(exception e){
                system.debug('-------e--------'+e);
            }                 
        }  
    }
}