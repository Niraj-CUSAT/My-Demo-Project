/****************************************************************************************************  
    Created by    :    Dhriti Krishna Ghosh Moulick
    Created On    :    31/08/2015
    Modified by   :    
    Modified on   :    
    Description   :    This is a batch class for Creating Auto creation of tasks for active delaers with catergory
**************************************************************************************************/
global class AutoCreationofTaskActiveDealer implements Database.Batchable<Sobject> {
    public String query;
    public String category1;
    public String category2;
    public String category3;
    public Boolean activeDealer;
    public RecordTypeDetails__c accountrecordType;
    public Recordtype rtAccount;
    public String developerName;
    public String toAddress;
    
    public AutoCreationofTaskActiveDealer(){
         activeDealer = True;
         category1    = 'Distributor';
         category2    = 'Direct Dealer';
         category3    = 'Modern retail'; 
         accountrecordType=RecordTypeDetails__c.getInstance('Account Name'); 
         rtAccount= DAL.getRecordTypeId(accountrecordType.Developer_Name__c,accountrecordType.SobjectType__c);
         developerName=rtAccount.developerName;
         query='SELECT Name,ShippingCity,ShippingCountry,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,RecordType.developerName,Id,AOSI_Active__c,AOSI_Categories__c,AOSI_Related_Service_Manager__c,AOSI_Related_Service_Manager__r.Email,AOSI_Related_Sales_Manager__c,AOSI_Service_Manager_Email__c,AOSI_Service_Manager_Phone__c,AOSI_Sales_manager_Email__c,AOSI_Sales_manager_Phone__c FROM Account WHERE (AOSI_Categories__c=:category1 OR AOSI_Categories__c=:category2 OR AOSI_Categories__c=:category3) AND AOSI_Active__c=:activeDealer AND RecordType.developerName=:developerName';
    }
    global Database.QueryLocator start(Database.batchableContext bc){
         return database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Sobject> scope){
    
         List<Task> autoCreateTasks = new List<Task>();
         for(Account cont : (List<Account>)scope){
         
         /*********** .addDays(13) to be removed while deployment... added for testing purpose*****************************************************************/
             if(cont.AOSI_Related_Service_Manager__r.Id!=null && cont.AOSI_Sales_manager_Email__c!=null && System.today()==System.today().toStartOfMonth() || Test.isRunningTest()){
                  Task createTask = new Task();
                  createTask.WhatId=cont.Id; 
                  createTask.Subject='Dealer Visit';
                  createTask.priority='Normal';
                  createTask.OwnerId=cont.AOSI_Related_Service_Manager__r.Id;
                  createTask.status = 'Not Started';    
                  createTask.ActivityDate=System.today().toStartOfMonth()+14;
                  createTask.AOSI_Sales_Manager_Email__c=cont.AOSI_Sales_manager_Email__c; 
                  createTask.AOSI_Account_Shipping_Address__c=((cont.ShippingStreet!=null)?cont.ShippingStreet:'')+' '+((cont.ShippingCity!=null)?cont.ShippingCity:'')+' '+((cont.ShippingState!=null)?cont.ShippingState:'')+' '+((cont.ShippingCountry!=null)?cont.ShippingCountry:'');
                  createTask.AOSI_Sales_Manager_Name__c=cont.AOSI_Related_Sales_Manager__c;
                  autoCreateTasks.add(createTask);  
             }
         }
        if(!autoCreateTasks.isEmpty()){
            try{
                insert autoCreateTasks;}catch(Exception e){ System.debug('$$$$$$$$$$$$$$$$'+e);}
        } 
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> emailListSalesManager = new List<Messaging.SingleEmailMessage>();
        
        for(task tsk:[Select AOSI_Account_Shipping_Address__c,CreatedDate,WhatId,What.Name,Subject,priority,OwnerId,Owner.Name,Owner.Email,ActivityDate,Status,AOSI_Sales_Manager_Email__c,AOSI_Sales_Manager_Name__c from Task where Id in:autoCreateTasks]){
            DateTime currentDateTime = datetime.now();
            String currentMonth= currentDateTime.format('MMMMM');
            String currentYear= currentDateTime.format('YYYY');
            System.debug(currentMonth);
            System.debug(currentYear);
            Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
            String toAddresses = tsk.Owner.Email+';';
            mail.setSubject('Created new Activity');
            mail.setPlainTextBody('Dear'+' '+tsk.Owner.Name+',\n\n'+ 'The dealer visit is scheduled for this month '+currentMonth+','+currentYear+'. Kindly make a visit soon. The details are as follows :'+'\n\n'+
             'Account Name :'+tsk.What.Name+'\n'+
             'Location : '+'       '+tsk.AOSI_Account_Shipping_Address__c+'\n'+
             'Status : '+'          '+tsk.Status+'\n'+
             'Due Date : '+'     '+tsk.ActivityDate.format()+'\n'+
             'Subject : '+'        '+tsk.Subject+'\n\n'+
             'After your visit, please attach the dealer visit report.'+'\n\n'+
             'Best Regards,\n\n'+
             'AO Smith Service');
            mail.setSaveAsActivity(false);
            mail.setToAddresses(toAddresses.split(';').size()  > 0 ? toAddresses.split(';') : new String[]{toAddresses.trim()});
            emailList.add(mail);
            
            Messaging.SingleEmailMessage mailSalesManager= new Messaging.SingleEmailMessage();
            String toAddresses1 = tsk.AOSI_Sales_Manager_Email__c+';';
            mailSalesManager.setSubject('Created new Activity');
            mailSalesManager.setPlainTextBody('Dear'+' '+tsk.AOSI_Sales_Manager_Name__c+',\n\n'+ 'The dealer visit is scheduled for this month '+currentMonth+','+currentYear+'. Kindly make a visit soon. The details are as follows :'+'\n\n'+
             'Account Name : '+tsk.What.Name+'\n'+
             'Location : '+'         '+tsk.AOSI_Account_Shipping_Address__c+'\n'+
             'Status : '+'            '+tsk.Status+'\n'+
             'Due Date : '+'       '+tsk.ActivityDate.format()+'\n'+
             'Subject : '+'          '+tsk.Subject+'\n\n'+
             'Best Regards,\n\n'+
             'AO Smith Service');
            mailSalesManager.setSaveAsActivity(false);
            mailSalesManager.setToAddresses(toAddresses1.split(';').size()  > 0 ? toAddresses1.split(';') : new String[]{toAddresses1.trim()});
            emailListSalesManager.add(mailSalesManager);
         }
         
        try {
             Messaging.sendEmail(emailList);
             Messaging.sendEmail(emailListSalesManager); } catch ( Exception e) { System.debug('*******AutoCreationofTaskActiveDealer  Exception while sending email  '+ e); }
    }
    global void finish(Database.BatchableContext BC){
         System.debug('-----------Batch executed successfully-----------');    
    }
}