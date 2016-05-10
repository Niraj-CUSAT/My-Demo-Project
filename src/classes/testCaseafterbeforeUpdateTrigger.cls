/*************************************************************************************************
        Created by    :    Bhanu Vallabhu, KVP Business Solutions
        Created On    :    5 Mar 2013
        Modified by   :    
        Modified on   :
        Description   :    Test class for testCaseafterbeforeupdate Trigger
**************************************************************************************************/

@isTest
Private class testCaseafterbeforeUpdateTrigger{
Static testmethod void TestTrigger()
{
    
    Account acc = new Account();
    acc.Name = 'Test Account';
    Insert acc;
    Pin_Master__c pin = new Pin_Master__c();
        pin.AOSI_Region__c = 'South';
        pin.AOSI_State__c = 'Andra Pradesh';
        pin.AOSI_City__c = 'Hyderabad';              
        pin.Name = '560089';
        pin.AOSI_Type__c = 'City';
        insert pin;
    ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
    
    list<contact> conlist = new list<Contact>();
    Contact ct = new Contact();
    ct.Lastname = 'Test';
    ct.recordtypeid = Conrtid;
    ct.accountid = acc.id;
    ct.phone = '8861925544';
    ct.AOSI_Pin_Code__c= pin.id;ct.AOSI_Pin_Code__c= pin.id;
    //insert ct;
    conlist.add(ct);
    Contact ct2 = new Contact();
    ct2.Lastname = 'Test2';
    ct2.recordtypeid = Conrtid;
    ct2.accountid = acc.id;
    ct2.phone = '9949643991';
    ct2.AOSI_Pin_Code__c= pin.id;
    //insert ct2;
    conlist.add(ct2);
     Insert conlist;
     
     Product2 pr = new Product2();
     pr.name = 'AOSI123456';
     pr.IsActive = True;
     pr.AOSIColorPanel_Free__c='Yes';
     pr.AOSI_Product_Code_for_Serial_Number__c='1234';
     pr.AOSI_Free_Installtion__c='Yes';
     pr.AOSI_PM_Service__c = 'Yes';
     pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
     insert pr;
    
    list<Asset> astlist = new list<Asset>();
    Asset ast = new Asset();
    ast.Name = '12341212130001';
    ast.contactid = ct.id;
    ast.Product2id = pr.id;
    ast.PurchaseDate = system.today();
    ast.AOSI_Active__c = true;
    //insert ast;
    astlist.add(ast);
    Asset ast1 = new Asset();
    ast1.Name = '12341212130002';
    ast1.contactid = ct2.id;
    ast1.Product2id = pr.id;
    ast1.PurchaseDate = system.today();
    ast1.AOSI_Active__c = true;
    //insert ast1;
    astlist.add(ast1);
    insert astlist;
    
    list<Service_Engineer__c> selist = new list<Service_Engineer__c>();
    Service_Engineer__c se = new Service_Engineer__c();
    se.Name = 'Test SE';
    se.Mobile_Number__c = '8080808080';
    //insert se;
    selist.add(se);
    
    Service_Engineer__c se1 = new Service_Engineer__c();
    se1.Name = 'Test SE1';
    se1.Mobile_Number__c = '8080808081';
    //insert se1;
    selist.add(se1);
    Service_Engineer__c se2 = new Service_Engineer__c();
    se2.Name = 'Test SE2';
    se2.Mobile_Number__c = '8080808082';
    //insert se2;
    selist.add(se2);
    insert selist;
   /* Attendence__c at = new Attendence__c();
    at.AOSI_Present__c = false;
    at.AOSI_Date__c = system.today();
    at.AOSI_Service_Engineer__c = se.id;
    insert at;*/
    
    ID Rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
    list<case> caseList = new list<case>();
    Case c = new Case();
    c.recordtypeid = Rtid;
    c.reason =  'Field Trial';
    c.AOSI_Preferred_Color__c= 'Blue';
    c.contactid = ct.id;
    c.Assetid = ast.id;
    c.Service_Engineer__c = se1.id;
    c.AOSIProduct__c= pr.id;
    caseList.add(c);
                  
    Case c2 = new Case();
    c2.recordtypeid = Rtid;
    c2.AOSIProduct__c= pr.id;
    c2.reason = 'Warranty Registration';
    c2.contactid = ct.id;
    c2.Assetid = ast.id;
    c2.AOSIProduct__c= pr.id;
    c2.Service_Engineer__c = se1.id;
    c2.AOSI_City__c = 'HYDERABAD';    
    caseList.add(c2);
    test.startTest();
    try{
    insert caseList;
     }
    Catch(Exception e){
        system.debug('-------------e3-----------'+e);
    }
    system.debug('------c2.id-----'+c2.id);
    c.Service_Engineer__c = se.id;    
    c2.AOSI_Case_Close_Time__c = system.today()+1;
    //c2.Service_Engineer__c = se2.id;  
    c2.AOSI_Appointment_Date__c = system.now().addHours(13); 
    c2.status= 'Closed';
    RecursionMonitor.updated = true ;
    try{
    //    Update caseList;
    }
    Catch(Exception e){
        system.debug('-------------e4-----------'+e);
    }  
    test.stopTest();      
          
}
}