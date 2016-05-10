@istest
public class TestUpdateContractInfo {
    static testMethod void test1() {
       test.startTest();
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
        
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Installation',oPinMasterSouth);
        insert oAcc;
        
        Contact oContactSouth1          =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        oContactSouth1.Lastname         =   'Test Contact1';
        insert oContactSouth1;
        Contact oContactSouth2          =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        oContactSouth2.Lastname         =   'Test Contact2';
        insert oContactSouth2;
        
        Product2 oProdWH                                =   TestHelpUtility.getProduct();
        oProdWH.Name                                    =   'WH-TEST-PROD1';
        oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
        oProdWH.AOSI_Family__c                          =   'Storage';
        oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
        insert oProdWH; 
        
        list<Asset> lInsertAsset            =   new list<Asset>();
        Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth1, oProdWH);
        oAsset1.Name                        =   'B0800104041234';
        lInsertAsset.add(oAsset1);        
        insert  lInsertAsset;
        
        list<Case> lstColorPanelCase        =   new list<Case>();
        Case oCase1                         =   TestHelpUtility.getCase(oContactSouth1, oAsset1, oProdWH);
        oCase1.Reason                       =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
        oCase1.AOSI_Preferred_Color__c      =   'Ivory';
        oCase1.Courier_Number__c            =   'COU123456';
        lstColorPanelCase.add(oCase1);
        insert lstColorPanelCase;
        
        oAsset1.ContactId =  oContactSouth2.Id;
        update oAsset1;
       test.stopTest();
    }

}
   
   /*public Static testmethod void Test1(){
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
         ct2.AOSI_Pin_Code__c= pin.id;
         //ct2.MailingPostalCode='560089';
        contactList.add(ct2);               
        insert contactList;
       Product2 pr = new Product2();
       pr.name = 'AOSI123456';
       pr.IsActive = True;
       pr.AOSIColorPanel_Free__c='Yes';
       pr.AOSI_Product_Code_for_Serial_Number__c='1234';
       pr.AOSI_Free_Installtion__c='Yes';
       pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
       insert pr;
       
        
        list<Asset> AssetList = new List<Asset>();
        Asset ast = new Asset();
        ast.Name = '12341212130001';
        ast.contactid =  ct2.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c=true;

        ast.PurchaseDate = system.today();
        insert ast;
        
         Asset ast1 = new Asset();
        ast1.Name = '12341212130004';
        ast1.contactid =  ct2.id;
        ast1.Product2id = pr.id;
        ast1.AOSI_Active__c=false;
        ast1.AOSI_Replaced_Asset__c=ast.id;

        ast1.PurchaseDate = system.today();
        System.debug('#######ast1###########'+ast1);
        insert ast1;
           
        ID rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
        
        List<Case> NewCase = new List<Case>();
        Case c = new Case();
        c.recordtypeid = Rtid;
        c.reason =  'Color Panel (Free)';
        c.AOSI_Preferred_Color__c= 'Blue';
        c.contactid = ct2.id;
        c.Assetid = ast.id;
      //  c.Service_Engineer__c = se.id;
        c.AOSIProduct__c= pr.id;
       test.starttest();
       insert c;
       ast.contactid =  ct.id;
       update ast;
       test.stoptest();
       //AOSI_Contract__c Contr= new AOSI_Contract__c();
       //contr.name='test con';
       //contr.AOSI_Asset__c=ast1.id;
       //contr.AOSI_Contract_Status__c='Active';
       //insert contr;

       }*/