/*
    Name:   CaseObjectAssetFieldUpdateTest
    Created By:  
    Created Date:  
    Modified By:  Dhriti Krishna Ghosh Moulick 
    Last Modified Date: 13/04/2015
    Description:Test class to achieve the following functionality
                1.If there is a warranty Case, and the case date is within 65 days of purchase and the case is closed 
                   Warranty Registered in time is TRUE,
                   OR
                 2.If there is an installation case (free or charged), and the case date is within 65 days of purchase and the case is closed
                   Warranty Registered in time is TRUE,
*/
@isTest(seeAllData=true)
Private class CaseObjectAssetFieldUpdateTest{
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
    pr.AOSI_Product_Code_for_Serial_Number__c='1224';
    pr.AOSI_Free_Installtion__c='Yes';
    pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
    insert pr;
    
    Asset ast = new Asset();
    ast.Name = '12241212130001';
    ast.contactid = ct.id;
    ast.Product2id = pr.id;
    ast.PurchaseDate = system.today();
  
    insert ast;
      
    
    Service_Engineer__c serviceEngineer = new Service_Engineer__c();
     serviceEngineer.Name='BHupeshTest';
     serviceEngineer.Mobile_Number__c='1234567898';
     serviceEngineer.Type__c='Installer(DMS)';
     insert serviceEngineer;
   
    ID rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
    
    Case c2 = new Case();
    c2.recordtypeid = rtid;
    c2.AOSIProduct__c= pr.id;
    c2.reason = 'Free Installation';
    //c2.Status='Closed';
    c2.contactid = ct.id;
    c2.Assetid = ast.id;
    c2.AOSIProduct__c= pr.id;
    c2.Service_Engineer__c = serviceEngineer.id;
    c2.AOSI_City__c = 'Andra Pradesh';
    c2.AOSI_Purchase_Value__c = 1000;
    c2.AOSI_Appointment_Date__c = system.now().addHours(13);
    
    insert c2;
    
    system.debug('===insert=='+c2);
    
    c2.Status='Closed';
    c2.Service_Engineer__c=serviceEngineer.Id;
    c2.AOSI_Case_Close_Time__c=System.today()+1;
    c2.AOSI_Water_Source__c='Muncipal';
     c2.AOSI_Hardness__c='350';
     c2.AOSI_TDS_Input__c='1800';
     c2.AOSI_TDS_Output__c='1200';
     c2.AOSI_Water_Storage__c='Under ground tank';
     c2.AOSI_pH__c='123';
     
    update c2;
    
    system.debug('===update=='+c2);
    
   
    }
}