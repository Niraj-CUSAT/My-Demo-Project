global class AOSI_GPS_GCMMessenger {
    @Future(callout=true)
    global static void sendMessage(String title,String to,String notificationtype)
    {
        
        Main main=new Main();
        Notification notification=new Notification();
        notification.title=title;
        notification.notificationtype=notificationtype;
        main.notification=notification;
        main.to=to; 
        GCM_Service__c service=GCM_Service__c.getValues('Default');
        HttpRequest request=new HttpRequest();
        Http ht_tp=new Http();
        request.setEndpoint(service.EndPoint__c);
        request.setBody(json.serialize(main));
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'key='+service.Key__c);
        HttpResponse response=ht_tp.send(request);
        system.debug('Notification'+json.serialize(main));
    }
    
    class Notification
    {
        String title;
        String notificationtype;
    }
    
    class Main
    {
        String to;
        Notification notification;
        
    }
    

}