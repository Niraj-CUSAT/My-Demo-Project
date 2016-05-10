global class SendSmsToServiceEngg {
    WebService static void  sendSms(Id id){
        String currentId=id;
        Recordtype recType = [Select id  from Recordtype where sobjecttype=:'case' and DeveloperName =:'AOSIndia'];
        Case cas=[SELECT Contact_Name__c,CaseNumber,Reason,Service_Engineer_Name__c,aosi_customer_concern__c,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c,aosi_model__c,Contact_Address__c,Contact_MailingPostalCode__c FROM Case WHERE Id =:currentId AND RecordtypeId =:recType.id LIMIT 1];
        List<smagicinteract__smsMagic__c> smsObjectList = new List<smagicinteract__smsMagic__c>();
        String senderId='AOSSVC';
        String MobilePhone =cas.Service_Engineer_Phone__c; 
        String enggName=cas.service_engineer_name__c;
        String caseNum=cas.CaseNumber;
       
        String  templateText =  'Case Number :'+ caseNum + ' | Case Reason : '+ cas.Reason +' | Customer Concern : '+ cas.aosi_customer_concern__c +' has been assigned to you | Name : '+Cas.Contact_Name__c +' | Mobile :' + Cas.Contact_Phone__c + ' | Phone :'+ Cas.Contact_Other_Phone__c + ' |  Model :'+ Cas.aosi_model__c + ' | Address :' + Cas.Contact_Address__c + '| PIN :'+ Cas.Contact_MailingPostalCode__c + 'SMS START '+caseNum+ ' on start or COMPLETE '+caseNum+' on completion of this case to 09773587451. Call Customer within 30mins (8am-8pm)'; 
       
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
            smsObject.smagicinteract__SenderId__c = senderId;
            smsObject.smagicinteract__PhoneNumber__c = MobilePhone;
            smsObject.smagicinteract__Name__c = cas.Contact_Name__c; // records name
            smsObject.smagicinteract__ObjectType__c = 'Case'; // record type
            smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be  0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
            if(!Test.isrunningtest())
            smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            smsObject.smagicinteract__SMSText__c = templateText;
            try{
                insert smsObject;
            }catch(DmlException ex){
                System.debug('**********'+ex);
            }
      }
}