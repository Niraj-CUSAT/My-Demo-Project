@RestResource(urlMapping='/resourceLogin/*')
global class AOSI_resourceCheck{
    @HttpPost
    global static void loginCheck(){  
        String[] toAddresses = new string[] {'honey.narang@kvpcorp.com'};
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject( 'Hit');
        email.setToAddresses( toAddresses);
        email.setPlainTextBody( 'Hit from api user');
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});     
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf('Success');  
    }
}