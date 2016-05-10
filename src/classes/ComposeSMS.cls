/*************************************************************************************************************************
 * Class Name   : ComposeSMS
 * Created By   : Pooja P Bhat
 * Created Date : 27-JUNE-2015
 * Modified By  : Rajesh Kumar
 * Description  : The ComposeSMS Class is used to render SMS templates and compose outgoing SMS to particular phone number
 * Methods      : public static String toRenderTemplate(String templateText, String objectType, String recordId)
                  public static String toRenderSMSTemplate(String objectType, Case objCase, String templateText)
                  public static String toRenderSMSTemplate(String objectType, Case objCase, String templateText)
                  public static String toSendSMS(String senderID, String objectType, String phoneNum, String textMsg)
**************************************************************************************************************************/
public class ComposeSMS {

    /********************************************************************************************
     * Method Name : toRenderTemplate()
     * Return Type : Sting  
     * Description : SMS template refers to one particular object and template contains many fields 
              of objects. Inorder to replace those fields and get the plain text this method
              can be used.
    *********************************************************************************************/
    public static String toRenderTemplate(String templateText, String objectType, String recordId) {
        smagicinteract.TemplateEngine tempEngine   = new smagicinteract.TemplateEngine(templateText); 
        List<String> fields   = new List<String>();       
        List<String> args     = new List<String>{};
        String plainTempText  = '';
        String extraFieldText = '';
        String query          = ''; 
    
        fields = tempEngine.getFieldsFromSMSTextOfObjectType(objectType);

        for(String x: fields){
            if(x.equalsIgnoreCase('Name')) continue;
            if(!extraFieldText.contains(x)) extraFieldText = extraFieldText + ', '+x;
        }

        extraFieldText = String.escapeSingleQuotes(extraFieldText);
        
        if (extraFieldText != null ) { args.add(extraFieldText); } else { args.add('');  }

        args.add(objectType);

        query ='SELECT Id {0} FROM {1} WHERE Id =: recordId LIMIT 1';   
        query = String.format(query, args);
        sObject sObj = Database.query(query);
        tempEngine.getFieldMap(sObj);   
        plainTempText = tempEngine.getReplacedTextForObject( sObj , 0);
        return plainTempText;
    } //End of toRenderTemplate()
    
    /******************************************************************************************************************
    Method Name : toRenderSMSTemplate(String objectType, Case objCase, String templateText)
    Return Type : String  
    Description : This method is used to render Case Object related SMS Templates.
    ******************************************************************************************************************/
    public static String toRenderSMSTemplate(String objectType, Case objCase, String templateText) {
        smagicinteract.TemplateEngine tempEngine    =   new smagicinteract.TemplateEngine(templateText);
        list<String> caseFields                     =   tempEngine.getFieldsFromSMSTextOfObjectType(objectType);
        tempEngine.getFieldMap(objCase);
        String plainTempText = tempEngine.getReplacedTextForObject( objCase, 0);
        return plainTempText;
    } //End of toRenderSMSTemplate()
    
    /*****************************************************************************************************************
     //Added by Rajesh Kumar
	 * Method Name : toRenderSMSTemplate(String objectType, AOSI_Contract__c objContract, String templateText) 
     * Return Type : String  
     * Description : This method is used to render AOSI Contract Object SMS Templates.
    ******************************************************************************************************************/    //To render SMS Templates of contract
    public static String toRenderSMSTemplate(String objectType, AOSI_Contract__c objContract, String templateText) { 
        smagicinteract.TemplateEngine tempEngine	=   new smagicinteract.TemplateEngine(templateText);
        list<String> contractFields                	=   tempEngine.getFieldsFromSMSTextOfObjectType(objectType);
        tempEngine.getFieldMap(objContract);
        String plainTempText = tempEngine.getReplacedTextForObject( objContract, 0);
        return plainTempText;
    } //End of toRenderSMSTemplate()
    
     public static String toRenderSMSTemplate(String objectType, Service_Engineer__c serviceengineer, String templateText) { 
        smagicinteract.TemplateEngine tempEngine	=   new smagicinteract.TemplateEngine(templateText);
        list<String> resourceFields                	=   tempEngine.getFieldsFromSMSTextOfObjectType(objectType);
        system.debug('resourceFields'+resourceFields); 
        tempEngine.getFieldMap(serviceengineer);
        String plainTempText = tempEngine.getReplacedTextForObject( serviceengineer, 0);
        return plainTempText;
    } //End of toRenderSMSTemplate()
    
    /******************************************************************************************************************
     * Method Name : toSendSMS()
     * Return Type : smagicinteract__smsMagic__c (SMS History Object)
     * Description : This is used to compose outgoing SMS to specified Phone Number
     *****************************************************************************************************************/
    public static smagicinteract__smsMagic__c toSendSMS(String senderID, String objectType, String phoneNum, String textMsg ) {
        smagicinteract__smsMagic__c smsObject            = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c            = senderID;
        smsObject.smagicinteract__ObjectType__c          = objectType;
        smsObject.smagicinteract__PhoneNumber__c         = phoneNum; 
        smsObject.smagicinteract__SMSText__c             = textMsg;
        smsObject.smagicinteract__external_field__c      = (test.isRunningTest()?null:smagicinteract.ApexAPI.generateUniqueKey());              
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0;
        return smsObject;
    } //End of toSendSMS()

} //End of ComposeSMS