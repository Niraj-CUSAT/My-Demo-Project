/*************************************************************************************************
        Created by    :    Bhanu Vallabhu, KVP Business Solutions
        Created On    :    5 Mar 2013
        Modified by   :    Shweta Kumari
        Modified on   :    7/1/2014
        Description   :    Test class for testCaseafterbeforeInsert Trigger
**************************************************************************************************/

@isTest
Private class testCaseafterbeforeInsertTriggers{
Static testmethod void TestTriggers()
{
    Account acc = new Account();
    acc.Name = 'Test Account';
    Insert acc;
    
    Pin_Master__c pin = new Pin_Master__c();
    pin.AOSI_Region__c = 'South';
    pin.AOSI_State__c = 'Hyderabad';
    pin.AOSI_City__c = 'Andra Pradesh';       
    pin.Name = '560087';
    insert pin;
    Pin_Master__c pin1 = new Pin_Master__c();
    pin1.AOSI_Region__c = 'North';
    pin1.AOSI_State__c = 'Delhi';
    pin1.AOSI_City__c = 'Delhi';       
    pin1.Name = '560088';
    insert pin1;
    Pin_Master__c pin2 = new Pin_Master__c();
    pin2.AOSI_Region__c = 'East';
    pin2.AOSI_State__c = 'ASSAM';
    pin2.AOSI_City__c = 'ASSAM';       
    pin2.Name = '560089';
    insert pin2;
    Pin_Master__c pin4 = new Pin_Master__c();
    pin4.AOSI_Region__c = 'West';
    pin4.AOSI_State__c = 'GOA';
    pin4.AOSI_City__c = 'GOA';       
    pin4.Name = '560085';
    insert pin4;
    ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
    list<Contact> contactList  = new list<Contact>();
    Contact ct = new Contact();
    ct.Lastname = 'Test';
    ct.recordtypeid = Conrtid;
    ct.accountid = acc.id;
    ct.phone = '8861925544';
    ct.AOSI_Pin_Code__c= pin.id;
    contactList.add(ct);
    
    Contact ct2 = new Contact();
    ct2.Lastname = 'Test2';
    ct2.recordtypeid = Conrtid;
    ct2.accountid = acc.id;
    ct2.phone = '9949643991';
    ct2.AOSI_Pin_Code__c= pin1.id;
     //ct2.MailingPostalCode='560089';
    contactList.add(ct2);
    
    Contact ct3 = new Contact();
    ct3.Lastname = 'Test2';
    ct3.recordtypeid = Conrtid;
    ct3.accountid = acc.id;
    ct3.phone = '9949643991';
    ct3.AOSI_Pin_Code__c= pin2.id;
    //ct3.MailingPostalCode='560089';
    contactList.add(ct3);
    
    Contact ct4 = new Contact();
    ct4.Lastname = 'Test2';
    ct4.recordtypeid = Conrtid;
    ct4.accountid = acc.id;
    ct4.phone = '9949643991';
    ct4.AOSI_Pin_Code__c= pin4.id;
    // ct4.MailingPostalCode='560089';
    contactList.add(ct4);
    insert contactList;
   Product2 pr = new Product2();
   pr.name = 'AOSI123456';
   pr.IsActive = True;
   pr.AOSIColorPanel_Free__c='Yes';
   pr.AOSI_Product_Code_for_Serial_Number__c='1224';
   pr.AOSI_Free_Installtion__c='Yes';
   pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
   insert pr;
   
    
    list<Asset> AssetList = new List<Asset>();
    Asset ast = new Asset();
    ast.Name = '12241212130001';
    ast.contactid = ct.id;
    ast.Product2id = pr.id;
    ast.PurchaseDate = system.today();
    AssetList.add(ast);
    
    Asset ast2 = new Asset();
    ast2.Name = '12241212130002';
    ast2.contactid = ct2.id;
    ast2.Product2id = pr.id;
    AssetList.add(ast2);
    
    Asset ast3 = new Asset();
    ast3.Name = '12241212130003';
    ast3.contactid = ct4.id;
    ast3.Product2id = pr.id;
    AssetList.add(ast3);
    
    
    insert AssetList;
    list<Service_Engineer__c> SeList  = new List<Service_Engineer__c>();
    Service_Engineer__c se = new Service_Engineer__c();
    se.Name = 'Test SE';
    se.Mobile_Number__c = '9234567890';
    SeList.add(se);
    
    Service_Engineer__c se1 = new Service_Engineer__c();
    se1.Name = 'Test SE';
    se1.Mobile_Number__c = '9239567891';
    SeList.add(se1);
    
    Service_Engineer__c se2 = new Service_Engineer__c();
    se2.Name = 'Test SE2';
    se2.Mobile_Number__c = '9234967892';
    SeList.add(se2);
    insert se2;
    
   // Attendence__c at = new Attendence__c();
   // at.AOSI_Present__c = false;
    //at.AOSI_Date__c = system.today().adddays(10);
  //  at.AOSI_Service_Engineer__c = se.id;
  //  insert at;
   /* Profile pAosi = [select id from Profile where Name =: 'ASP AOSI' limit 1];
    User AOSUser = [select id from User where ProfileId =: PAosi.id limit 1];
    ASP__c Asp = new ASP__c();
    Asp.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
    Asp.AOSI_Company_Name__c = 'Test__Com';
    Asp.AOSI_Approval_Status__c= 'Pending';  
    Asp.AOSI_ASP_User__c = AOSUser.id;
    Asp.AOSI_Mobile_No__c = '8080808080';
    Asp.AOSI_Contract_Effective_From_Date__c = system.Today();
    Asp.AOSI_Contract_Effective_To_Date__c = system.Today().adddays(5);  
    Asp.AOSI_WATER_HEATER_I_W__c =1; 
    insert Asp;
    
    Asp.AOSI_Approval_Status__c= 'Approved';
    Update Asp;
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'ASP_Pin' and SobjectType =:'PIN_Allocation__c' limit 1];          
    PIN_Allocation__c  aspPin = new PIN_Allocation__c();
    aspPin.AOSI_ASP__c = Asp.id;
    aspPin.AOSI_Pin_Master__c = pin.id;
    aspPin.RecordTypeid = rt.id; 
    insert aspPin;*/
    ID rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
    
    List<Case> NewCase = new List<Case>();
    Case c = new Case();
    c.recordtypeid = Rtid;
    c.reason =  'Color Panel (Free)';
    c.AOSI_Preferred_Color__c= 'Blue';
    c.contactid = ct2.id;
    c.Assetid = ast.id;
    c.Service_Engineer__c = se.id;
    c.AOSIProduct__c= pr.id;
    NewCase.add(c);
    
         
    Case c2 = new Case();
    c2.recordtypeid = Rtid;
    c2.AOSIProduct__c= pr.id;
    c2.reason = 'Free Installation';
    c2.contactid = ct.id;
    c2.Assetid = ast.id;
    c2.AOSIProduct__c= pr.id;
    c2.Service_Engineer__c = se1.id;
    c2.AOSI_City__c = 'HYDERABAD';
    c2.AOSI_Purchase_Value__c = 1000;
    c2.AOSI_Appointment_Date__c = system.now().addHours(13);
    NewCase.add(c2);
    
    Case c3 = new Case();
    c3.recordtypeid = Rtid;
    c3.AOSIProduct__c= pr.id;
    c3.reason = 'System Testing';
    c3.contactid = ct4.id;
    c3.Assetid = ast3.id;
    c3.AOSIProduct__c= pr.id;
    c3.Service_Engineer__c = se1.id;
    c3.AOSI_City__c = 'HYDERABAD';
    c3.AOSI_Purchase_Value__c = 1000;
    NewCase.add(c3);
    
    Case c4 = new Case();
    c4.recordtypeid = Rtid;
    c4.AOSIProduct__c= pr.id;
    c4.reason = 'Service';
    c4.contactid = ct4.id;
    c4.Assetid = ast3.id;
    c4.AOSIProduct__c= pr.id;
    c4.Service_Engineer__c = se1.id;
    c4.AOSI_City__c = 'HYDERABAD';
    c4.AOSI_Purchase_Value__c = 1000;
    NewCase.add(c4);
    
    try{
    insert NewCase;
     }
    Catch(Exception e){
        system.debug('-------------e1-----------'+e);
    }
    NewCase.clear();
    c.Service_Engineer__c = se1.id;
     c.Assetid = ast2.id;
    NewCase.add(c); 
    c2.AOSI_Appointment_Date__c = system.now();
    NewCase.add(c2);
    NewCase.add(c3);
    try{
    insert NewCase;
     }
    Catch(Exception e){
        system.debug('-------------e2-----------'+e);
    }             
    }
}