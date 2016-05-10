@istest()
private class TestPRRObject{
    static testMethod void Test1(){
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
                         
            Account oAcc                    =   TestHelpUtility.getNewAccount('Test SalesQuery',oPinMasterSouth);
            insert oAcc;
            
            Contact oContactSouth           = TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
            insert oContactSouth;
            
            list<Product2> lInsertProd                      =   new list<Product2>();
            Product2 oProdWH                                =   TestHelpUtility.getProduct();
            oProdWH.Name                                    =   'WH-TEST-PROD1';
            oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
            oProdWH.AOSI_Family__c                          =   'Storage';
            oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
            lInsertProd.add(oProdWH);       
            insert lInsertProd;
            
            list<Asset> lInsertAsset  =  new list<Asset>();
            Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
            oAsset1.Name                        =   'B0800104041234';
            lInsertAsset.add(oAsset1);        
            insert lInsertAsset;
            
            Service_Engineer__c oServEngg1    =   TestHelpUtility.getResource();  
            oServEngg1.Name                   =   'Test Resource1';
            oServEngg1.Mobile_Number__c       =   '9773587451';
            insert oServEngg1;
            
            Case oCase1                             =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase1.Reason                           =   DefineConstant.CASE_REASON_SALES_QUERY;
            oCase1.AOSI_Customer_Concern__c         =   'Interested in Buying';
            oCase1.AOSI_Sales_Query_Reference__c    =   'Canopy';
            oCase1.AOSI_Category_of_Sales_Query__c  =   'Interested';
            oCase1.AOSI_Vertical__c                 =   DefineConstant.PROD_VERTICAL_WH;
            insert oCase1;
            
            PRR__c oPRR                                     =   new PRR__c();
            oPRR.AOSI_Case__c                               =   oCase1.id;
            oPRR.AOSI_Asset__c                              =   oAsset1.id;
            oPRR.AOSI_Type__c                               =   'Customer';
            oPRR.AOSI_Justification__c                      =   'testsss';
            oPRR.AOSI_Approval_Status__c                    =   'Approved';
            oPRR.AOSI_Manufacture_Fault_Non_Repairable__c   =   true;
            insert oPRR;
            
            ApexPages.StandardController controller = new ApexPages.StandardController(oPRR);
            apexpages.currentpage().getparameters().put('Id',oPRR.id);  
            PRRPdfcontroller PRRCont    =   new PRRPdfcontroller(controller );
        test.stopTest();
    }
   /*public Static testmethod void Test1(){
        
       list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
         
         Account acc = TestHelpUtility.getAccount();
        insert acc;
      
        Pin_Master__c pin = TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');
        insert pin;
       
        Contact ct2 = TestHelpUtility.getContact(acc, pin);
        insert ct2; 
     
        
        Service_Engineer__c oResource = TestHelpUtility.getResource();
        insert oResource;
        
         Product2 pr = TestHelpUtility.getProduct();
       
        insert pr;
         
      
        
        Asset ast = new Asset();
        ast.Name = 'B0800104041234';
        ast.contactid =  ct2.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        ast.AOSI_Membrane_Warranty__c ='1 year';
        insert ast ;
       
      
       smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
       
        Case c = new Case();
        c.status='New';
        c.AOSI_Cancelled_On_HOLD_Reason__c='Replacement Processing';
        c.AOSI_Appointment_Date__c=system.today().adddays(1);
       // c.recordtypeid = Rtid;
        c.reason =  'Sales query';    
        c.AOSI_Category_of_Sales_Query__c='Interested';   
        c.contactid = ct2.id;
        c.Assetid = ast.id;      
        c.AOSIProduct__c= pr.id;
        c.Service_Engineer__c = oResource.id;
        c.AOSI_Sales_Query_Reference__c ='Newspaper';
        insert c;
       // NewCase.add(c);
       
        Case c1 =  TestHelpUtility.getCase(ct2, ast, pr);
        c1.status='New';
        c1.AOSI_Cancelled_On_HOLD_Reason__c='Replacement Processing';
        c1.AOSI_Appointment_Date__c=system.today().adddays(1);
       // c1.recordtypeid = Rtid;
        c1.reason =  'Sales query';     
        c1.AOSI_Category_of_Sales_Query__c='Interested';   
        c1.contactid = ct2.id;
        c1.Assetid = ast.id;      
        c1.AOSIProduct__c= pr.id;
        c1.Service_Engineer__c = oResource.id;
        c1.AOSI_Sales_Query_Reference__c ='Newspaper';
        //NewCase.add(c1);
        test.starttest();
        insert c1;
                     
        PRR__c PRR=new PRR__c();
        PRR.AOSI_Case__c=c.id;
        PRR.AOSI_Asset__c=ast.id;
        PRR.AOSI_Type__c='Customer';
        PRR.AOSI_Justification__c='testsss';
        PRR.AOSI_Approval_Status__c='Approved';
        PRR.AOSI_Manufacture_Fault_Non_Repairable__c =true;
        
        insert PRR;
             
        ApexPages.StandardController controller = new ApexPages.StandardController(PRR);
        apexpages.currentpage().getparameters().put('Id',PRR.id);  
        PRRPdfcontroller PRRCont=new PRRPdfcontroller(controller );
        test.stopTest();
       }*/
}