/*****************************************************************************************************************************************************
 * Class Name   : AOSI_HolidayUpdateBatch
 * Created By   : Keyur Modi
 * Created Date : 14/10/2015
 * Description  : This Batch class to clone all planed holiday to new year. 
 * Methods      : Global Database.QueryLocator Start(Database.BatchableContext bc)
                  Global void Execute(Database.BatchableContext bc,list<AOSI_Holiday_Calendar__c> lstHolidays)
                  Global void Finish(Database.BatchableContext bc)
                  
******************************************************************************************************************************************************/
Global class AOSI_HolidayUpdateBatch implements Database.Batchable<Sobject> {

    Global Database.QueryLocator Start(Database.BatchableContext bc){
     return Database.getQueryLocator('SELECT Id,AOSI_Name__c,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Region__c,AOSI_Type__c FROM AOSI_Holiday_Calendar__c WHERE AOSI_Type__c ='+'\''+'Planned'+'\'' +' AND AOSI_Start_Date__c = THIS_YEAR'); //AOSI_State__c,AOSI_Location__c,
    }
    Global void Execute(Database.BatchableContext bc,list<AOSI_Holiday_Calendar__c> lstHolidays){
        List<AOSI_Holiday_Calendar__c> lstNewHolidays = new List<AOSI_Holiday_Calendar__c>();
        IF(!lstHolidays.isEmpty()){
        system.debug('==lstHolidays=='+lstHolidays);
            lstNewHolidays=lstHolidays.deepClone();
            for(AOSI_Holiday_Calendar__c eachHoliday:lstNewHolidays){
                if(eachHoliday.AOSI_Start_Date__c!=null)
                eachHoliday.AOSI_Start_Date__c=eachHoliday.AOSI_Start_Date__c.addYears(1);
                if(eachHoliday.AOSI_End_Date__c!=null)
                eachHoliday.AOSI_End_Date__c=eachHoliday.AOSI_End_Date__c.addYears(1);
            }
        }
        System.debug('==lstNewHolidays=='+lstNewHolidays);
        IF(lstNewHolidays.size()>0){
            try{
                insert lstNewHolidays;
            }Catch(exception ex){
            System.debug('==ex=='+ex);
            }
        }
    }
    Global void Finish(Database.BatchableContext bc){
        List<User> lstUser = [SELECT Email FROM User WHERE Profile.Name = 'AOS India Manager'];
        System.DEbug('==lstUser=='+lstUser);
        List<String> lstEmail = new List<String>();
        for(User eachUser: lstUser){
            if(eachUser.Email!=null){
               lstEmail.add(eachUser.Email);
            }
        }
        SYstem.debug('==lstEmail=='+lstEmail);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(lstEmail);
        mail.setSubject('Holiday calender update for '+(System.Today().Year()+1)+' year');
        mail.setPlainTextBody('This mail is to inform you that please update the Holiday Calender for '+(System.Today().Year()+1)+' year');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}