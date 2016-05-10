/*
Modified by: bhanu Vallabhu, modified on: 16 Sep 14
Description: Bulkified the existing code.
*/

trigger UpdateCasefromSMS on smagicinteract__Incoming_SMS__c ( before insert,before update) {

 //This trigger is used to capture the Keyword as well as the case number from the incoming SMS and then update the case 
 //with  Assignement start time, Assignement end  time,Customer satisfaction status fields based on Keywords YES,NO, START,
 //STOP, it check for the incoming number to prevent people other than service engineer or the contact in the case object to update the case.
 map<String,String> operationmap = new map<String,String>();
 set<String> casenumbersset = new set<String>();
 map<String,case> casemap = new map<String,case>();
 map<String,String> servenggmobilenumbermap = new map<String,String>();
 map<String,String> contactmobilenumbermap = new map<String,String>();
 public Boolean updatecase = false;
 for(smagicinteract__Incoming_SMS__c insms : Trigger.new){
        try{
        if( insms.smagicinteract__SMS_Text__c.containsIgnoreCase('Start') )
        {
            operationmap.put(insms.smagicinteract__SMS_Text__c.substring(5).trim(),'START');
            casenumbersset.add(insms.smagicinteract__SMS_Text__c.substring(5).trim());
            servenggmobilenumbermap.put(insms.smagicinteract__SMS_Text__c.substring(5).trim(),insms.smagicinteract__Mobile_Number__c);
        }
        else if( insms.smagicinteract__SMS_Text__c.containsIgnoreCase('Stop') )
        {
            operationmap.put(insms.smagicinteract__SMS_Text__c.substring(4).trim(),'STOP');
            casenumbersset.add(insms.smagicinteract__SMS_Text__c.substring(4).trim());
            servenggmobilenumbermap.put(insms.smagicinteract__SMS_Text__c.substring(5).trim(),insms.smagicinteract__Mobile_Number__c);
        }
        else if( insms.smagicinteract__SMS_Text__c.containsIgnoreCase('Yes') )
        {
            operationmap.put(insms.smagicinteract__SMS_Text__c.substring(3).trim(),'YES');
            casenumbersset.add(insms.smagicinteract__SMS_Text__c.substring(3).trim());
            contactmobilenumbermap.put(insms.smagicinteract__SMS_Text__c.substring(5).trim(),insms.smagicinteract__Mobile_Number__c);
        }
        else if( insms.smagicinteract__SMS_Text__c.containsIgnoreCase('NO') )
        {
            operationmap.put(insms.smagicinteract__SMS_Text__c.substring(2).trim(),'NO');
            casenumbersset.add(insms.smagicinteract__SMS_Text__c.substring(2).trim());
            contactmobilenumbermap.put(insms.smagicinteract__SMS_Text__c.substring(5).trim(),insms.smagicinteract__Mobile_Number__c);
        }
        }catch(Exception e){
            System.debug('exception occured '+e);
        }
 }
 
 system.debug('*******************operationmap'+operationmap);
  system.debug('*******************casenumbersset'+casenumbersset);
   system.debug('*******************servenggmobilenumbermap'+servenggmobilenumbermap);
 try{
     for(case cs : [Select id, CaseNumber,Assignment_Start_Time__c ,Assignment_End_Time_Minute_Value__c,Service_Engineer_Phone__c,Contact_Phone__c , Assignment_End_Time__c , Customer_Satisfaction_Status__c from Case where CaseNumber IN : casenumbersset]){
        casemap.put(cs.CaseNumber,cs);
     }
     system.debug('******************* query casemap'+casemap);
     if(!casemap.isEmpty()){
        for(case cs : casemap.values()){
            if(operationmap.containskey(cs.CaseNumber)){
                //system.debug('operation----->'+cs.Service_Engineer_Phone__c);
                try{
                system.debug('******************* operationmap.get(cs.CaseNumber)'+operationmap.get(cs.CaseNumber));
                system.debug('******************* operationmap.get(cs.CaseNumber)'+servenggmobilenumbermap.get(cs.CaseNumber).contains(cs.Service_Engineer_Phone__c));
                system.debug('******************* contact number'+contactmobilenumbermap.get(cs.CaseNumber).contains(cs.Contact_Phone__c));
                }catch( exception e ) {system.debug('$$$$$$$$$$$$ ' + e);}
                if( operationmap.get(cs.CaseNumber).equalsIgnorecase('START')&& cs.Service_Engineer_Phone__c != Null && servenggmobilenumbermap.containsKey(cs.CaseNumber) && servenggmobilenumbermap.get(cs.CaseNumber).contains(cs.Service_Engineer_Phone__c)){                 
                    cs.Assignment_Start_Time__c  = System.now();updatecase = true;
                }
                else if(operationmap.get(cs.CaseNumber).equalsIgnorecase('STOP') && cs.Service_Engineer_Phone__c != Null && servenggmobilenumbermap.containsKey(cs.CaseNumber) && servenggmobilenumbermap.get(cs.CaseNumber).contains(cs.Service_Engineer_Phone__c)){
                    cs.Assignment_End_Time__c    = System.now();updatecase = true;
                    cs.Assignment_End_Time_Minute_Value__c= String.valueOf(System.now().hour())+':'+String.valueOf(System.now().minute());
                }
                else if(operationmap.get(cs.CaseNumber).equalsIgnorecase('YES') && contactmobilenumbermap.containsKey(cs.CaseNumber) && cs.Contact_Phone__c != Null && contactmobilenumbermap.get(cs.CaseNumber).contains(cs.Contact_Phone__c)){
                    cs.Customer_Satisfaction_Status__c =  'Satisfied' ;updatecase = true;
                }
                else if(operationmap.get(cs.CaseNumber).equalsIgnorecase('NO') && contactmobilenumbermap.containsKey(cs.CaseNumber) && cs.Contact_Phone__c != Null && contactmobilenumbermap.get(cs.CaseNumber).contains(cs.Contact_Phone__c)){ 
                    cs.Customer_Satisfaction_Status__c =  'Not Satisfied' ;updatecase = true;
                }
            }
        }
        
        system.debug('***************** casemap '+casemap);
            if(updatecase){
                //Database.update(casemap.values(),false);
                update casemap.values();
            }
            
        }}Catch(Exception e){
            System.debug('exception occured '+e);
        }
    
 
 /* try
  {
    
    String SMSText= trigger.new[0].smagicinteract__SMS_Text__c;
    
    String CaseNumber  = '';
    
    String OPERATION = '';
    
    If( SMSText.containsIgnoreCase('Start') )
    {
      CaseNumber =  SMSText.substring(5).trim();
      OPERATION = 'START';
    }
    else if( SMSText.containsIgnoreCase('Stop') )
    {
        CaseNumber =  SMSText.substring(4).trim();
        OPERATION = 'STOP';
    }
    else if( SMSText.containsIgnoreCase('Yes') )
    {
     CaseNumber =  SMSText.substring(3).trim();
     OPERATION = 'YES';
    }
    else if( SMSText.containsIgnoreCase('No') )
    {
       CaseNumber =  SMSText.substring(2).trim();
       OPERATION = 'NO';
    } 
    Case Current_Case =  [Select id, Assignment_Start_Time__c ,Assignment_End_Time_Minute_Value__c,Service_Engineer_Phone__c,Contact_Phone__c , Assignment_End_Time__c , Customer_Satisfaction_Status__c from Case where CaseNumber =: CaseNumber ];
     if( trigger.new[0].smagicinteract__Mobile_Number__c.contains(Current_Case.Service_Engineer_Phone__c))
    {
            if( OPERATION == 'START' )
            {
              Current_Case.Assignment_Start_Time__c  = System.now();
            }
            else
            if( OPERATION == 'STOP' )
            {
                Current_Case.Assignment_End_Time__c    = System.now();
              Current_Case.Assignment_End_Time_Minute_Value__c= String.valueOf(System.now().hour())+':'+String.valueOf(System.now().minute());
             }
            update Current_Case;
 
   }
   if( trigger.new[0].smagicinteract__Mobile_Number__c.contains( (Current_Case.Contact_Phone__c).replace('(','' ).replace(')','').replace('-','').replaceAll(' ','') ) )
    {
        if( OPERATION == 'YES' ){
                Current_Case.Customer_Satisfaction_Status__c =  'Satisfied' ;
            }
        else if( OPERATION == 'NO' ){ 
               Current_Case.Customer_Satisfaction_Status__c =  'Not Satisfied' ;
            }
            update Current_Case;
   }
  }catch(Exception e){   
  }*/
}