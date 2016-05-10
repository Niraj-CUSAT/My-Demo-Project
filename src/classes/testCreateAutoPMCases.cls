/*************************************************************************************************
        Created by    :    Bhanu Vallabhu, KVP Business Solutions
        Created On    :    5 Mar 2013
        Modified by   :    
        Modified on   :
        Description   :    Test class for CreateAutoPMCases Class
        **************************************************************************************************/

@isTest(seeAllData = false)
Private class testCreateAutoPMCases{
Static testmethod void TestCreateCase()
{
    Account acc = new Account();
    acc.Name = 'Test Account';
    insert acc;
    
    Pin_Master__c objPin =  new Pin_Master__c();
    objPin.AOSI_Area__c = 'Test';
    objPin.AOSI_City__c = 'Test';
    objPin.AOSI_Country__c = 'Test';
    objPin.AOSI_Region__c = 'East';
    objPin.AOSI_State__c = 'Bihar';
    objPin.AOSI_Street__c = 'Test';
    objPin.AOSI_Type__c = 'Local';
    insert objPin;
    
    String conRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contact' AND Name='AOS India'].Id;
    
    List<Contact> lstContact = new List<Contact>();
    Contact ct = new Contact();
    ct.Lastname = 'Test';
    ct.RecordtypeId=conRecordTypeId;
    ct.accountid = acc.id;
    ct.phone = '8861925544';
    ct.AOSI_Region__c = 'South';
    ct.AOSI_State__c = 'Andhra Pradesh';
    ct.mailingstate = 'Andhra Pradesh';
    ct.mailingcity= 'HYDERABAD';
    ct.AOSI_Pin_Code__c = objPin.Id;
    lstContact.add(ct);
    //insert ct;
    
    
    Contact ct2 = new Contact();
    ct2.Lastname = 'Test2';
    ct2.accountid = acc.id;
    ct2.phone = '9949643991';
    ct2.AOSI_Region__c = 'South';
    ct2.AOSI_State__c = 'Andhra Pradesh';
    ct2.mailingstate = 'Andhra Pradesh';
    ct2.mailingcity= 'HYDERABAD';
    ct2.AOSI_Pin_Code__c = objPin.Id;
    lstContact.add(ct2);
    //insert ct2;
    insert lstContact;
     
     Product2 pr = new Product2();
     pr.name = 'AOSI123456';
     pr.IsActive = True;
     pr.AOSIColorPanel_Free__c='Yes';
     pr.AOSI_Product_Code_for_Serial_Number__c='00001303120319';
     pr.AOSI_Free_Installtion__c='Yes';
     pr.AOSI_PM_Service__c = 'Automatic';
     pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
     insert pr;
    
    List<Asset> lstAsset = new List<Asset>();
    Asset ast = new Asset();
    ast.Name = '00001303120319';
    ast.contactid = ct.id;
    ast.Product2id = pr.id;
    ast.PurchaseDate = System.today();
    lstAsset.add(ast);
    //insert ast;
    
     Asset ast2 = new Asset();
    ast2.Name = '00001303120319';
    ast2.contactid = ct2.id;
    ast2.Product2id = pr.id;
    ast2.PurchaseDate = System.today();
    lstAsset.add(ast2);
   // insert ast2;
    insert lstAsset;
    
    CreateAutoPMCases cc = new CreateAutoPMCases();
    cc.createcase();
   

}}