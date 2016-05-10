/*************************************************************************************************
        Created by    :    shweta kumari, KVP Business Solutions
        Created On    :    7 Jan 2014
        Modified by   :    
        Modified on   :        
*************************************************************************************************/

@isTest
Private class testCaseupdateTimebeforeUpdate {
Static testmethod void TestTime()
{
    //public boolean selected = true;   
    
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
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; 
    ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
    
    Contact ct = new Contact();
    ct.Lastname = 'Test';
    ct.recordtypeid = Conrtid;
    ct.accountid = acc.id;
    ct.phone = '8861925544';
    ct.AOSI_Pin_Code__c= pin.id;
    insert ct;
     
     Product2 pr = new Product2();
     pr.name = 'AOSI123456';
     pr.IsActive = True;
     pr.AOSIColorPanel_Free__c='Yes';
     pr.AOSI_Product_Code_for_Serial_Number__c='1234';
     pr.AOSI_Free_Installtion__c='Yes';
     pr.AOSI_PM_Service__c = 'Yes';
     pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
     insert pr;
    
    Asset ast = new Asset();
    ast.Name = '12341212130001';
    ast.contactid = ct.id;
    ast.Product2id = pr.id;
    ast.PurchaseDate = system.today();
    ast.AOSI_Active__c=true;
    insert ast;
   
    List<Case> caseList = new List<Case>();
    Case c = new Case();
    c.recordtypeid = rt.id;    
    c.contactid = ct.id;
    c.Assetid = ast.id;
    c.AOSIProduct__c= pr.id;
    c.Status = 'Open';
    c.Reason = 'Existing problem';
    c.Assignment_Start_Time__c = system.Now().adddays(2);
    c.AOSI_Appointment_Date__c = system.Now();
    c.AOSI_Case_Close_Time__c = system.now().adddays(4);   
    caseList.add(c);
    
    Case c1 = new Case();
    c1.recordtypeid = rt.id;
    c1.reason =  'System Testing';    
    c1.contactid = ct.id;
    c1.Assetid = ast.id;
    c1.AOSIProduct__c= pr.id;
    c1.Status = 'Open';    
    c1.Assignment_Start_Time__c = system.Now().adddays(2);
    c1.AOSI_Appointment_Date__c = system.Now();
    c1.Assignment_End_Time__c = system.Now().adddays(4);
    caseList.add(c1);
    
    Case c2 = new Case();
    c2.recordtypeid = rt.id;
    c2.reason =  'Field Trial';   
    c2.contactid = ct.id;
    c2.Assetid = ast.id;
    c2.AOSIProduct__c= pr.id;
    c2.Status = 'Open';    
    c2.Assignment_Start_Time__c = system.Now().adddays(2);    
    c2.Assignment_End_Time__c = system.Now().adddays(4);
    caseList.add(c2);
    
    Case c3 = new Case();
    c3.recordtypeid = rt.id;
    c3.reason =  'Contract Request';   
    c3.contactid = ct.id;
    c3.Assetid = ast.id;
    c3.AOSIProduct__c= pr.id;
    c3.Status = 'Open';        
    c3.Assignment_End_Time__c = system.Now().adddays(4);
    caseList.add(c3);
    
    Case c4 = new Case();
    c4.recordtypeid = rt.id;
    c4.reason =  'Sales Query';   
    c4.contactid = ct.id;
    c4.Assetid = ast.id;
    c4.AOSIProduct__c= pr.id;
    c4.Status = 'Open';       
    c4.AOSI_Case_Close_Time__c = system.Now().adddays(4);
    caseList.add(c4);
    
    Case c5 = new Case();
    c5.recordtypeid = rt.id;
    c5.reason =  'Warranty Registration';
    c5.contactid = ct.id;
    c5.Assetid = ast.id;
    c5.AOSIProduct__c= pr.id;
    c5.Status = 'Open';   
    c5.Assignment_Start_Time__c = system.Now();
    c5.AOSI_Appointment_Date__c = system.Now();     
    c5.AOSI_Case_Close_Time__c = system.Now();
    caseList.add(c5);
    test.startTest();
    try{
        insert caseList;
    }
    catch(Exception e){
        system.debug('-------------e------------'+e);
    }
    test.stopTest();
    }
    }