/*****************************************************************************************************************************************************
 * Class Name   : AOSI_StaticQueryHelper 
 * Created By   : Pooja P Bhat
 * Created Date : 11-SEPTEMBER-2015
 * Description  : Helper class to reduce number of SOQL query.  
******************************************************************************************************************************************************/
public class AOSI_StaticQueryHelper {
    
    public static RecordType caseAOSIRecType;
    public static RecordType caseAOSIndiaRecType;
    public static map<String,String> mCaseSMSTemplateText       =   getCaseObjSMSTemplate();
    public static smagicinteract__SMS_SenderId__c smsSenderID   =   getSMSSenderId();
 
    static {
        set<String> sdevName        =   new set<String>();
        set<String> sobjectType     =   new set<String>();
        for(RecordTypeDetails__c csRecType : RecordTypeDetails__c.getall().values()) {
            sdevName.add(csRecType.Developer_Name__c);
            sobjectType.add(csRecType.SobjectType__c);    
        }
        
        if( !sdevName.isEmpty() && !sobjectType.isEmpty() ) {
            for(RecordType recType : [SELECT Id,Name,DeveloperName,SobjectType FROM RecordType WHERE DeveloperName IN:sdevName AND SobjectType IN: sobjectType] ) {
                if( recType.DeveloperName.equalsIgnoreCase('AOSI') && recType.sobjectType.equalsIgnoreCase('Case')) {
                    caseAOSIRecType     =   recType;
                }else if( recType.DeveloperName.equalsIgnoreCase('AOSIndia') && recType.sobjectType.equalsIgnoreCase('Case')) {
                    caseAOSIndiaRecType =   recType;   
                }
            }    
        }
              
      }
      
      public static smagicinteract__SMS_SenderId__c getSMSSenderId() {
          RecordTypeDetails__c senderId = RecordTypeDetails__c.getInstance('SMS SenderID'); 
          return([SELECT Id, smagicinteract__senderId__c FROM smagicinteract__SMS_SenderId__c WHERE smagicinteract__senderId__c =: senderId.Developer_Name__c LIMIT 1]);
      }
      
      public static map<String,String> getCaseObjSMSTemplate() {
            list<smagicinteract__SMS_Template__c> listSMSTemplates  =   [SELECT ID, Name, smagicinteract__Name__c, smagicinteract__Text__c, smagicinteract__ObjectName__c FROM smagicinteract__SMS_Template__c];
            map<String,String> mapSMSTemplateText                   =   new map<String,String>(); //Contains SMS template name and template text
            if( !listSMSTemplates.isEmpty() ) {
                for(smagicinteract__SMS_Template__c smsTemplate : listSMSTemplates) {
                    mapSMSTemplateText.put(smsTemplate.smagicinteract__Name__c,smsTemplate.smagicinteract__Text__c);
                }
            }
            return(mapSMSTemplateText);
      }

}