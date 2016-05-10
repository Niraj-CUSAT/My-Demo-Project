public class AOSI_GPS_MessageHandler {
    
    public static List<String> getMessage(String message_code)
    {
        List<String> messagedetails=new List<String>();
        MessageTable__c obj=MessageTable__c.getValues(message_code);
        messagedetails.add(obj.Message__c);
        messagedetails.add(obj.Level__c);
        return messagedetails;
    }
    

}