@isTest
private class ISP_DemoRequestTrigHandletTest {
    static testMethod void unitTestMethod(){

        ISP_Demo_Request__c d = new ISP_Demo_Request__c();
        d.Dealer_Name__c = 'sudama';
        d.Demo_Give_Y_N__c = 'Yes';
        d.Demo_Status__c = 'Open';
        d.Customer_Prefered_Time__c = System.today();
        
        Insert d;
        
        ISP_Target__c t1  = new ISP_Target__c();
        t1.Assigned_To__c = userInfo.getUserId();
        t1.name = 'new1';
        t1.No_of_Demo_Requests__c = 5;
        t1.To_date__c = System.today();
        t1.From_date__c = System.today();
             
        insert t1; 
        
        update d;
        
        delete d;  
 
  
    }
}