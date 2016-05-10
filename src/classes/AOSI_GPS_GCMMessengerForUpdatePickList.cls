global class AOSI_GPS_GCMMessengerForUpdatePickList {
    @Future(callout=true)
    global static void sendMessage(String title,List<String> gcmIds)
    {
        
        Main main=new Main();
        Notification notification=new Notification();
        notification.title=title;
        main.notification = notification;
        main.registration_ids=gcmIds;
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
        System.debug('GCM Ids are'+gcmIds);
        System.debug('Title is'+title);
    }
    
    class Notification
    {
        String title;
    }
    
    class Main
    {   
        Notification notification;
        List<String> registration_ids;
        
    }
    

}