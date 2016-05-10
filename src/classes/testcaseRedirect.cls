/*************************************************************************************************
        Created by    :    Bhanu Vallabhu, KVP Business Solutions
        Created On    :    5 Mar 2013
        Modified by   :    
        Modified on   :
        Description   :    Test class for caseRedirect, SetRecordtype and set Contact Recordtype classes
*************************************************************************************************/

@isTest
Private class testcaseRedirect {
    static testmethod void testNewCase() {
        Id caseAOSIRecTy    =   [SELECT Id,Name FROM RecordType WHERE  DeveloperName =:'AOSI' and SobjectType =:'Case' LIMIT 1].Id;
        
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        
        list<AOSI_Time_Calculation_Settings__c> oTCS    =   TestHelpUtility.getTimeCalCustSttng();
        insert oTCS;
        
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        list<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        
        City_Master__c cityMasterSouth  =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai'); 
        insert cityMasterSouth;
        
        Pin_Master__c oPinMasterSouth   =   TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka'); 
        insert oPinMasterSouth;
       
        Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
        insert oServEngg;
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Color Panel',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        list<Product2> lInsertProd                      =   new list<Product2>();   
        Product2 oProdWT                                =   TestHelpUtility.getProduct();
        oProdWT.Name                                    =   'WT-TEST-PROD1';
        oProdWT.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c                          =   'Water Purifier';
        oProdWT.AOSI_Product_Code_for_Serial_Number__c  =   'B082';
        lInsertProd.add(oProdWT);
        insert lInsertProd;
        
        list<Asset> lInsertAsset  =  new list<Asset>();   
        Asset oAsset                        =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
        oAsset.Name                         =   'B0820104041233';
        oAsset.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset);
        insert oAsset;
        
        ApexPages.StandardController sc1 = new ApexPages.standardController(oContactSouth);
        apexpages.currentpage().getparameters().put('Id',oContactSouth.id);
    
        list<Case> lstColorPanelCase        =   new list<Case>();
        Case oCase1                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
        oCase1.Reason                       =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Preferred_Color__c      =   'Ivory';
        oCase1.Courier_Number__c            =   'COU123456';
        lstColorPanelCase.add(oCase1);
        insert lstColorPanelCase;
        
        ApexPages.StandardController sc = new ApexPages.standardController(oCase1);
        apexpages.currentpage().getparameters().put('Id',oCase1.id);
        
        caseRedirect cr = new caseRedirect(sc);
        
        PageReference pageRef = cr.redirect();
        
        SetRecordtype srt = new SetRecordtype(sc);
    }
}
/*Static testmethod void TestNewCase()
{
       
    
    Account acc = new Account();
    acc.Name = 'Test Account';
    Insert acc;
    
    Pin_Master__c objPin =  new Pin_Master__c();
    objPin.AOSI_Area__c = 'Test';
    objPin.AOSI_City__c = 'Test';
    objPin.AOSI_Country__c = 'Test';
    objPin.AOSI_Region__c = 'East';
    objPin.AOSI_State__c = 'Bihar';
    objPin.AOSI_Street__c = 'Test';
    objPin.AOSI_Type__c = 'Local';
    insert objPin;
   
    Contact ct = new Contact();
    ct.Lastname = 'Test';
    ct.accountid = acc.id;
    ct.phone = '8861825544';
    ct.AOSI_Region__c = 'South';
    ct.AOSI_State__c = 'Andhra Pradesh';
    ct.mailingstate = 'Andhra Pradesh';
    ct.mailingcity= 'HYDERABAD';
    ct.MailingPostalCode = '500070';
    ct.AOSI_Pin_Code__c = objPin.Id;
    insert ct;
    
    
     Product2 pr = new Product2();
   pr.name = 'AOSI123456';
   pr.IsActive = True;
   pr.AOSIColorPanel_Free__c='Yes';
     pr.AOSI_Product_Code_for_Serial_Number__c='00001303120319';
   pr.AOSI_Free_Installtion__c='Yes';
   pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
   insert pr;
   
    
    
    Asset ast = new Asset();
    ast.Name = '00001303120319';
    ast.contactid = ct.id;
    ast.Product2id = pr.id;
    ast.PurchaseDate = system.today();
    insert ast;
    
    system.debug('---- AOSI_Manufacture_Date__c  ----'+ast.AOSI_Manufacture_Date__c );
    
     ApexPages.StandardController sc1 = new ApexPages.standardController(ct);
    apexpages.currentpage().getparameters().put('Id',ct.id);
    
    
    
    Case c = new Case();
    c.recordtypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
    c.reason =  'Color Panel (Free)';
    c.AOSI_Preferred_Color__c= 'Blue';
    c.contactid = ct.id;
    c.Assetid = ast.id;
    //c.Service_Engineer__c = se.id;
    c.AOSIProduct__c= pr.id;
    c.Courier_Number__c = 'COU123456';
    insert c;
    
    
    ApexPages.StandardController sc = new ApexPages.standardController(c);
    apexpages.currentpage().getparameters().put('Id',c.id);
    
    caseRedirect cr = new caseRedirect(sc);
    
    PageReference pageRef = cr.redirect();
    
    SetRecordtype srt = new SetRecordtype(sc);
    
 
      
}*/