@isTest
public Class GenarateASPBillTest{
    static testMethod void sspClaimFormTest() { 
        date dateFrom = System.today();
        Date dateTo = System.today().adddays(5);
       
       
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
       
        Account oAcc                    =   TestHelpUtility.getNewAccount('Test Service Case',oPinMasterSouth);
        insert oAcc;
        
        list<Contact>   lstContact      =   new list<Contact>();
        Contact oContactSouth1          =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        oContactSouth1.Lastname         =   'Test Contact1';
        lstContact.add(oContactSouth1);
        Contact oContactSouth2          =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        oContactSouth2.Lastname         =   'Test Contact2';
        lstContact.add(oContactSouth2);
        insert lstContact;
        
        list<Product2> lInsertProd                      =   new list<Product2>();   
        Product2 oProdWT                                =   TestHelpUtility.getProduct();
        oProdWT.Name                                    =   'WT-TEST-PROD1';
        oProdWT.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WT;
        oProdWT.AOSI_Family__c                          =   'Water Purifier';
        oProdWT.AOSI_Product_Code_for_Serial_Number__c  =   'B082';
        lInsertProd.add(oProdWT);
        insert lInsertProd;
        
        list<Asset> lInsertAsset            =   new list<Asset>();   
        Asset oAsset1                        =   TestHelpUtility.getAsset(oContactSouth1, oProdWT);
        oAsset1.Name                         =   'B0820104041233';
        oAsset1.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset1);
        Asset oAsset2                        =   TestHelpUtility.getAsset(oContactSouth2, oProdWT);
        oAsset2.Name                         =   'B0820104041122';
        oAsset2.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
        lInsertAsset.add(oAsset2);
        insert lInsertAsset;
       
        list<Customer_Concern__c> listCC    =   new list<Customer_Concern__c>();
        Customer_Concern__c accessoryMissCC =   TestHelpUtility.getCustomerConcern('Accessory Missing', 'Accessory Missing');
        listCC.add(accessoryMissCC);
        Customer_Concern__c crticalIssue =   TestHelpUtility.getCustomerConcern('Critical Issue/Smell', 'Critical Issue/Smell');
        listCC.add(crticalIssue);
        insert listCC;
        
        list<Product_Customer_Concern__c> lstPCC    =   new list<Product_Customer_Concern__c>();
        Product_Customer_Concern__c oPCC1           =   TestHelpUtility.getProductCustomerConcern(accessoryMissCC, oProdWT);
        lstPCC.add(oPCC1);
        Product_Customer_Concern__c oPCC2           =   TestHelpUtility.getProductCustomerConcern(crticalIssue, oProdWT);
        lstPCC.add(oPCC2);
        insert lstPCC;
        
         //ASP_Rate_Master__c asr =[select id, Name from ASP_Rate_Master__c where id = aspRate.id Limit 1];
        // Id id   
        Profile pAosi = [select id from Profile where Name =: 'ASP AOSI' limit 1];
        User AOSUser = [select id from User where ProfileId =: PAosi.id limit 1];     
        ASP__c Asp = new ASP__c();
        Asp.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp.AOSI_Company_Name__c = 'Test__Com';
        Asp.AOSI_Approval_Status__c= 'Pending'; 
        //Asp.AOSI_CITY_DISTRICT_NAME__c = aspRate.id;         
        Asp.AOSI_Region__c ='South'; 
        Asp.AOSI_State__c ='Andra Pradesh'; 
        Asp.AOSI_City__c ='Hyderabad'; 
        Asp.AOSI_Contract_Effective_From_Date__c = system.Today();
        Asp.AOSI_Contract_Effective_To_Date__c = system.Today().adddays(5); 
        Asp.AOSI_WATER_HEATER_I_W__c =1; 
        Asp.AOSI_ASP_User__c = AOSUser.id;  
        Asp.AOSI_Mobile_No__c = '8080808080';   
        insert Asp;        
        Asp.AOSI_Approval_Status__c= 'Approved';
        Update Asp;
        
         List<ASP_Rate_Master__c> aspRateList = new List<ASP_Rate_Master__c>();
        
        ASP_Rate_Master__c aspRate = new ASP_Rate_Master__c();
        aspRate.Name = 'A'; 
        aspRate.AOSI_6hrs_to_24hrs__c =100.50;
        aspRate.AOSI_6hrs__c =100.50;
        aspRate.AOSI_24hrs__c =100;           
        aspRate.AOSI_48_Hrs__c=100;               
        aspRate.AOSI_Fixed_Compensation__c=4000;
        aspRate.AOSI_If_80_calls_completed_24hrs_Upcont__c=100;
        aspRate.AOSI_If_80_calls_completed_within_24hrs__c=100;               
        aspRate.AOSI_X6hrs_to_24hrs_Upcountry__c=100;
        aspRate.AOSI_X6hrs_Upcountry__c=100;
        aspRate.AOSI_X24hrs_Upcountry__c=100;        
        aspRate.AOSI_X48_Hrs_Upcountry__c=100;
        aspRate.AOSI_70_calls_completed_within_24Hrs__c=100;
        aspRate.AOSI_Only_60_to_69__c=100;
        aspRate.AOSI_Only_50_to_59__c=100;
        aspRate.AOSI_50__c=100;
        aspRate.Minimum_Number_Of_Call__c=5;
        aspRate.Active__c=True;
        aspRate.Product_Category__c='Water Heater';
        aspRate.X1_1_1__c=100;
        insert aspRate;
       // aspRateList.add(aspRate);              
        
        ASP_Rate_Master__c aspRate1 = new ASP_Rate_Master__c();
        aspRate1.Name = 'B'; 
        aspRate1.AOSI_6hrs_to_24hrs__c =100.50;
        aspRate1.AOSI_6hrs__c =100;
        aspRate1.AOSI_24hrs__c =100;               
        aspRate1.AOSI_48_Hrs__c=100;              
        aspRate1.AOSI_Fixed_Compensation__c=4000;
        aspRate1.AOSI_If_80_calls_completed_24hrs_Upcont__c=100;
        aspRate1.AOSI_If_80_calls_completed_within_24hrs__c=100;               
        aspRate1.AOSI_X6hrs_to_24hrs_Upcountry__c=100;
        aspRate1.AOSI_X6hrs_Upcountry__c=100;
        aspRate1.AOSI_X24hrs_Upcountry__c=100;        
        aspRate1.AOSI_X48_Hrs_Upcountry__c=100;
        aspRate1.AOSI_70_calls_completed_within_24Hrs__c=100;
        aspRate1.AOSI_Only_60_to_69__c=100;
        aspRate1.AOSI_Only_50_to_59__c=100;
        aspRate1.AOSI_50__c=100;
        aspRate1.Minimum_Number_Of_Call__c=5;       
        aspRate1.Active__c=True;
        aspRate1.Product_Category__c='Water Treatment'; 
        aspRate1.X1_1_1__c=100;
        //aspRateList.add(aspRate1);
        insert aspRate1;
        
        Service_Line__c SL=new Service_Line__c();
        SL.X6_hrs__c=100;
        SL.X6hrs_Upcountry__c=100;
        SL.X24hrs_City__c=100;
        SL.X24hrs_Upcountry__c=100;
        SL.X48_hrs_City__c=100;
        SL.X48_hrs_Upcountry__c=100;
        SL.X6hrs_to_24hrs_City__c=100;
        SL.X6hrs_to_24hrs_Upcountry__c=100;
        SL.Type__c='Service';
        SL.ASP_Rate_Master__c=aspRate.id;
        insert SL;
        
        Service_Line__c SL1=new Service_Line__c();
        SL1.X6_hrs__c=100;
        SL1.X6hrs_Upcountry__c=100;
        SL1.X24hrs_City__c=100;
        SL1.X24hrs_Upcountry__c=100;
        SL1.X48_hrs_City__c=100;
        SL1.X48_hrs_Upcountry__c=100;
        SL1.X6hrs_to_24hrs_City__c=100;
        SL1.X6hrs_to_24hrs_Upcountry__c=100;
        SL1.Type__c='PM Service';
        SL1.ASP_Rate_Master__c=aspRate.id;
        insert SL1;
        
        Service_Line__c SL2=new Service_Line__c();
        SL2.X6_hrs__c=100;
        SL2.X6hrs_Upcountry__c=100;
        SL2.X24hrs_City__c=100;
        SL2.X24hrs_Upcountry__c=100;
        SL2.X48_hrs_City__c=100;
        SL2.X48_hrs_Upcountry__c=100;
        SL2.X6hrs_to_24hrs_City__c=100;
        SL2.X6hrs_to_24hrs_Upcountry__c=100;
        SL2.Type__c='Dealer Stock';
        SL2.ASP_Rate_Master__c=aspRate.id;
        insert SL2;
        
        Service_Line__c SL3=new Service_Line__c();
        SL3.X6_hrs__c=100;
        SL3.X6hrs_Upcountry__c=100;
        SL3.X24hrs_City__c=100;
        SL3.X24hrs_Upcountry__c=100;
        SL3.X48_hrs_City__c=100;
        SL3.X48_hrs_Upcountry__c=100;
        SL3.X6hrs_to_24hrs_City__c=100;
        SL3.X6hrs_to_24hrs_Upcountry__c=100;
        SL3.Type__c='Free Installation';
        SL3.ASP_Rate_Master__c=aspRate.id;
        insert SL3;
        
        Service_Line__c SL4=new Service_Line__c();
        SL4.X6_hrs__c=100;
        SL4.X6hrs_Upcountry__c=100;
        SL4.X24hrs_City__c=100;
        SL4.X24hrs_Upcountry__c=100;
        SL4.X48_hrs_City__c=100;
        SL4.X48_hrs_Upcountry__c=100;
        SL4.X6hrs_to_24hrs_City__c=100;
        SL4.X6hrs_to_24hrs_Upcountry__c=100;
        SL4.Type__c='Service';
        SL4.ASP_Rate_Master__c=aspRate1.id;
        insert SL4;
        
        Service_Line__c SL5=new Service_Line__c();
        SL5.X6_hrs__c=100;
        SL5.X6hrs_Upcountry__c=100;
        SL5.X24hrs_City__c=100;
        SL5.X24hrs_Upcountry__c=100;
        SL5.X48_hrs_City__c=100;
        SL5.X48_hrs_Upcountry__c=100;
        SL5.X6hrs_to_24hrs_City__c=100;
        SL5.X6hrs_to_24hrs_Upcountry__c=100;
        SL5.Type__c='PM Service';
        SL5.ASP_Rate_Master__c=aspRate1.id;
        insert SL5;
        
        Service_Line__c SL6=new Service_Line__c();
        SL6.X6_hrs__c=100;
        SL6.X6hrs_Upcountry__c=100;
        SL6.X24hrs_City__c=100;
        SL6.X24hrs_Upcountry__c=100;
        SL6.X48_hrs_City__c=100;
        SL6.X48_hrs_Upcountry__c=100;
        SL6.X6hrs_to_24hrs_City__c=100;
        SL6.X6hrs_to_24hrs_Upcountry__c=100;
        SL6.Type__c='Dealer Stock';
        SL6.ASP_Rate_Master__c=aspRate1.id;
        insert SL6;
        
        Service_Line__c SL7=new Service_Line__c();
        SL7.X6_hrs__c=100;
        SL7.X6hrs_Upcountry__c=100;
        SL7.X24hrs_City__c=100;
        SL7.X24hrs_Upcountry__c=100;
        SL7.X48_hrs_City__c=100;
        SL7.X48_hrs_Upcountry__c=100;
        SL7.X6hrs_to_24hrs_City__c=100;
        SL7.X6hrs_to_24hrs_Upcountry__c=100;
        SL7.Type__c='Free Installation';
        SL7.ASP_Rate_Master__c=aspRate1.id;
        insert SL7;
        
        ASP_Rate_Master_Junction__c ratejunction=new ASP_Rate_Master_Junction__c();
        ratejunction.ASP__c=Asp.id;
        ratejunction.ASP_Rate_Master__c=aspRate.id;
        insert ratejunction;
        
        ASP_Rate_Master_Junction__c ratejunction1=new ASP_Rate_Master_Junction__c();
        ratejunction1.ASP__c=Asp.id;
        ratejunction1.ASP_Rate_Master__c=aspRate1.id;
        insert ratejunction1;
        
        Service_Engineer__c se = new Service_Engineer__c();
        se.Name = 'Test SE';
        se.Mobile_Number__c = '8080808080';
        se.Region__c='South';
        se.State__c='Andra Pradesh';
        se.AOSI_City__c='Hyderabad'; 
        se.AOSI_Active__c = true;  
        se.AOSI_ASP__c = Asp.id;     
        insert se;         
       
       test.startTest(); 
        Case oCase1                         =   TestHelpUtility.getCase(oContactSouth1, oAsset1, oProdWT);
        oCase1.Reason                       =   DefineConstant.CASE_REASON_SERVICE;
        oCase1.AOSI_Customer_Concern__c     =   'Critical Issue/Smell';
        insert oCase1;
        
        oCase1.Service_Engineer__c = se.id;
        update oCase1;
        AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
        AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
        oCase1.Assignment_End_Time__c=system.today().adddays(-15);
        update oCase1;
        
        ASP_Billing__c billing = new ASP_Billing__c();
        billing.AOSI_Billing_From__c = system.today().adddays(10);
        billing.AOSI_Billing_To__c = system.today().adddays(15);
        billing.AOSI_ASP__c = Asp.id;
        Date datobj=system.today().addmonths(-1);
        Integer dy = datobj.day();
        Integer mon = (datobj.month());
        Integer yr = datobj.year();
        string Monthandyear=String.valueof(mon)+'-'+String.valueof(yr);
        billing.Month_and_Year__c=Monthandyear;
        insert billing;  
        
        ApexPages.StandardController sc = new ApexPages.standardController(Asp);        
        ApexPages.currentPage().getParameters().put('id',Asp.id);
        ApexPages.currentPage().getParameters().put('othercharge','1000000000.00');
        ApexPages.currentPage().getParameters().put('Servicetax','100');
        ApexPages.currentPage().getParameters().put('claimcharge','100');
        ApexPages.currentPage().getParameters().put('Remark','test r');
        ApexPages.currentPage().getParameters().put('Deduction','100');
        ApexPages.currentPage().getParameters().put('ReasonDeduc','test');
       
        GenarateASPBill ASPbill = new GenarateASPBill(sc); 
        GenarateASPBillPDF ASPbillPDF = new GenarateASPBillPDF(sc); 
        ASPbill.ServiceTax=10;
        ASPbill.Deduction=100;
        ASPbill.reasonDeduction='';
        ASPbill.finalAmount=1000000000.00;
        ASPbill.totalAmount();
        ASPbill.buttonflag=false;
        long longDecimalnumber = long.valueof('1000000000');
        
        ASPbill.convert(longDecimalnumber);
        ASPbill.GeneratePDF();
       test.stopTest();
    }
}

/*********** public Static TestMethod void AspclaimFormTest(){
        date dateFrom = System.today();
        Date dateTo = System.today().adddays(5);
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Pin_Master__c pin = new Pin_Master__c();
        pin.AOSI_Region__c = 'South';
        pin.AOSI_State__c = 'Andra Pradesh';
        pin.AOSI_City__c = 'Hyderabad';               
        pin.Name = '560089';
        pin.AOSI_Type__c = 'Local';
        insert pin;
        
        Pin_Master__c pin1 = new Pin_Master__c();
        pin1.AOSI_Region__c = 'South';
        pin1.AOSI_State__c = 'Andra Pradesh';
        pin1.AOSI_City__c = 'Hyderabad';              
        pin1.Name = '560080';
        pin1.AOSI_Type__c = 'Upcountry';
        insert pin1;
        ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
        List<contact> contactList = new List<Contact>();
        Contact ct = new Contact();
        ct.Lastname = 'Test';
        ct.recordtypeid = Conrtid;
        ct.accountid = acc.id;
        ct.phone = '8861925544';
        ct.AOSI_Pin_Code__c= pin.id;        
        contactList.add(ct);
        
        Contact ct1 = new Contact();
        ct1.Lastname = 'Test';
        ct1.recordtypeid = Conrtid;
        ct1.accountid = acc.id;
        ct1.phone = '8861925544';
        ct1.AOSI_Pin_Code__c= pin1.id; 
        contactList.add(ct1);       
        insert contactList;
        
        Product2 pr = new Product2();
        pr.name = 'AOSI123456';
        pr.IsActive = True;
        pr.AOSIColorPanel_Free__c='Yes';
        pr.AOSI_Product_Code_for_Serial_Number__c='1234';
        pr.AOSI_Free_Installtion__c='Yes';
        pr.AOSI_PM_Service__c = 'Yes';
        pr.AOSI_Vertical__c = 'Water Heater';
        pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
        insert pr;
        List<Asset> assetList = new List<asset>();
        Asset ast = new Asset();
        ast.Name = '12341212130001';
        ast.contactid = ct.id;
        ast.Product2id = pr.id;
        ast.PurchaseDate = system.today();
        ast.AOSI_Active__c = true;
        ast.AOSI_Purchase_Value__c=100;
        assetList.add(ast);
        
        Asset ast1 = new Asset();
        ast1.Name = '12341212130002';
        ast1.contactid = ct1.id;
        ast1.Product2id = pr.id;
        ast1.PurchaseDate = system.today();
        ast1.AOSI_Active__c = true;
        ast1.AOSI_Purchase_Value__c=100;
        assetList.add(ast1);
        insert assetList;
                     
         //ASP_Rate_Master__c asr =[select id, Name from ASP_Rate_Master__c where id = aspRate.id Limit 1];
        // Id id   
        Profile pAosi = [select id from Profile where Name =: 'ASP AOSI' limit 1];
        User AOSUser = [select id from User where ProfileId =: PAosi.id limit 1];     
        ASP__c Asp = new ASP__c();
        Asp.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp.AOSI_Company_Name__c = 'Test__Com';
        Asp.AOSI_Approval_Status__c= 'Pending'; 
        //Asp.AOSI_CITY_DISTRICT_NAME__c = aspRate.id;         
        Asp.AOSI_Region__c ='South'; 
        Asp.AOSI_State__c ='Andra Pradesh'; 
        Asp.AOSI_City__c ='Hyderabad'; 
        Asp.AOSI_Contract_Effective_From_Date__c = system.Today();
        Asp.AOSI_Contract_Effective_To_Date__c = system.Today().adddays(5); 
        Asp.AOSI_WATER_HEATER_I_W__c =1; 
        Asp.AOSI_ASP_User__c = AOSUser.id;  
        Asp.AOSI_Mobile_No__c = '8080808080';   
        insert Asp;        
        Asp.AOSI_Approval_Status__c= 'Approved';
        Update Asp;
        
         List<ASP_Rate_Master__c> aspRateList = new List<ASP_Rate_Master__c>();
        
        ASP_Rate_Master__c aspRate = new ASP_Rate_Master__c();
        aspRate.Name = 'A'; 
        aspRate.AOSI_6hrs_to_24hrs__c =100.50;
        aspRate.AOSI_6hrs__c =100.50;
        aspRate.AOSI_24hrs__c =100;           
        aspRate.AOSI_48_Hrs__c=100;               
        aspRate.AOSI_Fixed_Compensation__c=4000;
        aspRate.AOSI_If_80_calls_completed_24hrs_Upcont__c=100;
        aspRate.AOSI_If_80_calls_completed_within_24hrs__c=100;               
        aspRate.AOSI_X6hrs_to_24hrs_Upcountry__c=100;
        aspRate.AOSI_X6hrs_Upcountry__c=100;
        aspRate.AOSI_X24hrs_Upcountry__c=100;        
        aspRate.AOSI_X48_Hrs_Upcountry__c=100;
        aspRate.AOSI_70_calls_completed_within_24Hrs__c=100;
        aspRate.AOSI_Only_60_to_69__c=100;
        aspRate.AOSI_Only_50_to_59__c=100;
        aspRate.AOSI_50__c=100;
        aspRate.Minimum_Number_Of_Call__c=5;
        aspRate.Active__c=True;
        aspRate.Product_Category__c='Water Heater';
        aspRate.X1_1_1__c=100;
        insert aspRate;
       // aspRateList.add(aspRate);              
        
        ASP_Rate_Master__c aspRate1 = new ASP_Rate_Master__c();
        aspRate1.Name = 'B'; 
        aspRate1.AOSI_6hrs_to_24hrs__c =100.50;
        aspRate1.AOSI_6hrs__c =100;
        aspRate1.AOSI_24hrs__c =100;               
        aspRate1.AOSI_48_Hrs__c=100;              
        aspRate1.AOSI_Fixed_Compensation__c=4000;
        aspRate1.AOSI_If_80_calls_completed_24hrs_Upcont__c=100;
        aspRate1.AOSI_If_80_calls_completed_within_24hrs__c=100;               
        aspRate1.AOSI_X6hrs_to_24hrs_Upcountry__c=100;
        aspRate1.AOSI_X6hrs_Upcountry__c=100;
        aspRate1.AOSI_X24hrs_Upcountry__c=100;        
        aspRate1.AOSI_X48_Hrs_Upcountry__c=100;
        aspRate1.AOSI_70_calls_completed_within_24Hrs__c=100;
        aspRate1.AOSI_Only_60_to_69__c=100;
        aspRate1.AOSI_Only_50_to_59__c=100;
        aspRate1.AOSI_50__c=100;
        aspRate1.Minimum_Number_Of_Call__c=5;       
        aspRate1.Active__c=True;
        aspRate1.Product_Category__c='Water Treatment'; 
        aspRate1.X1_1_1__c=100;
        //aspRateList.add(aspRate1);
        insert aspRate1;
        
        Service_Line__c SL=new Service_Line__c();
        SL.X6_hrs__c=100;
        SL.X6hrs_Upcountry__c=100;
        SL.X24hrs_City__c=100;
        SL.X24hrs_Upcountry__c=100;
        SL.X48_hrs_City__c=100;
        SL.X48_hrs_Upcountry__c=100;
        SL.X6hrs_to_24hrs_City__c=100;
        SL.X6hrs_to_24hrs_Upcountry__c=100;
        SL.Type__c='Service';
        SL.ASP_Rate_Master__c=aspRate.id;
        insert SL;
        
        Service_Line__c SL1=new Service_Line__c();
        SL1.X6_hrs__c=100;
        SL1.X6hrs_Upcountry__c=100;
        SL1.X24hrs_City__c=100;
        SL1.X24hrs_Upcountry__c=100;
        SL1.X48_hrs_City__c=100;
        SL1.X48_hrs_Upcountry__c=100;
        SL1.X6hrs_to_24hrs_City__c=100;
        SL1.X6hrs_to_24hrs_Upcountry__c=100;
        SL1.Type__c='PM Service';
        SL1.ASP_Rate_Master__c=aspRate.id;
        insert SL1;
        
        Service_Line__c SL2=new Service_Line__c();
        SL2.X6_hrs__c=100;
        SL2.X6hrs_Upcountry__c=100;
        SL2.X24hrs_City__c=100;
        SL2.X24hrs_Upcountry__c=100;
        SL2.X48_hrs_City__c=100;
        SL2.X48_hrs_Upcountry__c=100;
        SL2.X6hrs_to_24hrs_City__c=100;
        SL2.X6hrs_to_24hrs_Upcountry__c=100;
        SL2.Type__c='Dealer Stock';
        SL2.ASP_Rate_Master__c=aspRate.id;
        insert SL2;
        
        Service_Line__c SL3=new Service_Line__c();
        SL3.X6_hrs__c=100;
        SL3.X6hrs_Upcountry__c=100;
        SL3.X24hrs_City__c=100;
        SL3.X24hrs_Upcountry__c=100;
        SL3.X48_hrs_City__c=100;
        SL3.X48_hrs_Upcountry__c=100;
        SL3.X6hrs_to_24hrs_City__c=100;
        SL3.X6hrs_to_24hrs_Upcountry__c=100;
        SL3.Type__c='Free Installation';
        SL3.ASP_Rate_Master__c=aspRate.id;
        insert SL3;
        
        Service_Line__c SL4=new Service_Line__c();
        SL4.X6_hrs__c=100;
        SL4.X6hrs_Upcountry__c=100;
        SL4.X24hrs_City__c=100;
        SL4.X24hrs_Upcountry__c=100;
        SL4.X48_hrs_City__c=100;
        SL4.X48_hrs_Upcountry__c=100;
        SL4.X6hrs_to_24hrs_City__c=100;
        SL4.X6hrs_to_24hrs_Upcountry__c=100;
        SL4.Type__c='Service';
        SL4.ASP_Rate_Master__c=aspRate1.id;
        insert SL4;
        
        Service_Line__c SL5=new Service_Line__c();
        SL5.X6_hrs__c=100;
        SL5.X6hrs_Upcountry__c=100;
        SL5.X24hrs_City__c=100;
        SL5.X24hrs_Upcountry__c=100;
        SL5.X48_hrs_City__c=100;
        SL5.X48_hrs_Upcountry__c=100;
        SL5.X6hrs_to_24hrs_City__c=100;
        SL5.X6hrs_to_24hrs_Upcountry__c=100;
        SL5.Type__c='PM Service';
        SL5.ASP_Rate_Master__c=aspRate1.id;
        insert SL5;
        
        Service_Line__c SL6=new Service_Line__c();
        SL6.X6_hrs__c=100;
        SL6.X6hrs_Upcountry__c=100;
        SL6.X24hrs_City__c=100;
        SL6.X24hrs_Upcountry__c=100;
        SL6.X48_hrs_City__c=100;
        SL6.X48_hrs_Upcountry__c=100;
        SL6.X6hrs_to_24hrs_City__c=100;
        SL6.X6hrs_to_24hrs_Upcountry__c=100;
        SL6.Type__c='Dealer Stock';
        SL6.ASP_Rate_Master__c=aspRate1.id;
        insert SL6;
        
        Service_Line__c SL7=new Service_Line__c();
        SL7.X6_hrs__c=100;
        SL7.X6hrs_Upcountry__c=100;
        SL7.X24hrs_City__c=100;
        SL7.X24hrs_Upcountry__c=100;
        SL7.X48_hrs_City__c=100;
        SL7.X48_hrs_Upcountry__c=100;
        SL7.X6hrs_to_24hrs_City__c=100;
        SL7.X6hrs_to_24hrs_Upcountry__c=100;
        SL7.Type__c='Free Installation';
        SL7.ASP_Rate_Master__c=aspRate1.id;
        insert SL7;
        
        ASP_Rate_Master_Junction__c ratejunction=new ASP_Rate_Master_Junction__c();
        ratejunction.ASP__c=Asp.id;
        ratejunction.ASP_Rate_Master__c=aspRate.id;
        insert ratejunction;
        
        ASP_Rate_Master_Junction__c ratejunction1=new ASP_Rate_Master_Junction__c();
        ratejunction1.ASP__c=Asp.id;
        ratejunction1.ASP_Rate_Master__c=aspRate1.id;
        insert ratejunction1;
        
        Service_Engineer__c se = new Service_Engineer__c();
        se.Name = 'Test SE';
        se.Mobile_Number__c = '8080808080';
        se.Region__c='South';
        se.State__c='Andra Pradesh';
        se.AOSI_City__c='Hyderabad'; 
        se.AOSI_Active__c = true;  
        se.AOSI_ASP__c = Asp.id;     
        insert se;         
        ID Rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
        List<Case> caselist = New List<case>();
        Case c = new Case();
        c.recordtypeid = Rtid;
        c.reason =  'Service';        
        c.contactid = ct.id;
        c.Assetid = ast.id;
        c.Service_Engineer__c = se.id;
        c.AOSIProduct__c= pr.id;        
        c.AOSI_Resolution_Time_New__c = 5;
        c.AOSI_Region_picklist__c ='South';
        c.AOSI_State_Picklist__c ='Andra Pradesh';
        c.AOSI_City_Picklist__c ='Hyderabad';
        c.AOSI_Customer_Concern__c = 'Other';
        //c.AOSI_Appointment_Date__c = system.Now().addDays(-1) ;                
        caselist.add(c);******/
             
                              
      /*  Case c3 = new Case();
        c3.recordtypeid = Rtid;
        c3.reason =  'PM Service';        
        c3.contactid = ct.id;
        c3.Assetid = ast.id;
        c3.Service_Engineer__c = se.id;
        c3.AOSIProduct__c= pr.id;       
        c3.AOSI_Resolution_Time_New__c = 5;
        c3.AOSI_Region_picklist__c ='South';
        c3.AOSI_State_Picklist__c ='Andra Pradesh';
        c3.AOSI_City_Picklist__c ='Hyderabad';
        c3.AOSI_Customer_Concern__c = 'Other';
       // c3.AOSI_Appointment_Date__c = system.Now().addDays(-1);        
        caselist.add(c3); 
        
        Case c5 = new Case();
        c5.recordtypeid = Rtid;
        c5.reason =  'Free Installation';        
        c5.contactid = ct.id;
        c5.Assetid = ast.id;
        c5.AOSI_City__c='HYDERABAD';
        c5.Service_Engineer__c = se.id;
        c5.AOSIProduct__c= pr.id;       
        c5.AOSI_Resolution_Time_New__c = 5;
        c5.AOSI_Region_picklist__c ='South';
        c5.AOSI_State_Picklist__c ='Andra Pradesh';
        c5.AOSI_City_Picklist__c ='Hyderabad';
        c5.AOSI_Customer_Concern__c = 'Other';
        //c5.AOSI_Appointment_Date__c = system.Now().addDays(-1);        
        caselist.add(c5); 
        
        
        Case c2 = new Case();
        c2.recordtypeid = Rtid;
        c2.reason =  'Dealer Stock';        
        c2.contactid = ct1.id;
        c2.Assetid = ast1.id;
        c2.Service_Engineer__c = se.id;
        c2.AOSIProduct__c= pr.id;        
        c2.AOSI_Resolution_Time_New__c = 5;
        c2.AOSI_Region_picklist__c ='South';
        c2.AOSI_State_Picklist__c ='Andra Pradesh';
        c2.AOSI_City_Picklist__c ='Hyderabad';
        c2.AOSI_Customer_Concern__c = 'Other';
        //c2.AOSI_Appointment_Date__c = system.Now().addDays(-1);                
        caselist.add(c2);
             
                              
        Case c1 = new Case();
        c1.recordtypeid = Rtid;
        c1.reason =  'System Testing';        
        c1.contactid = ct1.id;
        c1.Assetid = ast1.id;
        c1.Service_Engineer__c = se.id;
        c1.AOSIProduct__c= pr.id;       
        c1.AOSI_Resolution_Time_New__c = 5;
        c1.AOSI_Region_picklist__c ='South';
        c1.AOSI_State_Picklist__c ='Andra Pradesh';
        c1.AOSI_City_Picklist__c ='Hyderabad';
        c1.AOSI_Customer_Concern__c = 'Other';
        //c1.AOSI_Appointment_Date__c = system.Now().addDays(-1);        
        caselist.add(c1);
        
        Case c4 = new Case();
        c4.recordtypeid = Rtid;
        c4.reason =  'Chargeable Installation';        
        c4.contactid = ct1.id;
        c4.Assetid = ast1.id;
        c4.Service_Engineer__c = se.id;
        c4.AOSIProduct__c= pr.id;       
        c4.AOSI_Resolution_Time_New__c = 5;
        c4.AOSI_Region_picklist__c ='South';
        c4.AOSI_State_Picklist__c ='Andra Pradesh';
        c4.AOSI_City_Picklist__c ='Hyderabad';
        c4.AOSI_Customer_Concern__c = 'Other';
        //c4.AOSI_Appointment_Date__c = system.Now().addDays(-2);               
        caselist.add(c4);
        */
        /* ****** try{
            insert caselist;
        }
        catch(exception e){
            system.debug('--------e--------'+e);
        }
         test.starttest();
        for(Case UC:caselist){
            UC.Assignment_End_Time__c=system.today().adddays(-15);
            //UC.status='Closed';
            Update UC;
        } 
      
        ASP_Billing__c billing = new ASP_Billing__c();
        billing.AOSI_Billing_From__c = system.today().adddays(10);
        billing.AOSI_Billing_To__c = system.today().adddays(15);
        billing.AOSI_ASP__c = Asp.id;
        Date datobj=system.today().addmonths(-1);
      Integer dy = datobj.day();
      Integer mon = (datobj.month());
      Integer yr = datobj.year();
      string Monthandyear=String.valueof(mon)+'-'+String.valueof(yr);
        billing.Month_and_Year__c=Monthandyear;
        insert billing;  
        
        ApexPages.StandardController sc = new ApexPages.standardController(Asp);        
       ApexPages.currentPage().getParameters().put('id',Asp.id);
        ApexPages.currentPage().getParameters().put('othercharge','1000000000.00');
        ApexPages.currentPage().getParameters().put('Servicetax','100');
        ApexPages.currentPage().getParameters().put('claimcharge','100');
        ApexPages.currentPage().getParameters().put('Remark','test r');
        ApexPages.currentPage().getParameters().put('Deduction','100');
        ApexPages.currentPage().getParameters().put('ReasonDeduc','test');
       
        GenarateASPBill ASPbill = new GenarateASPBill(sc); 
         GenarateASPBillPDF ASPbillPDF = new GenarateASPBillPDF(sc); 
        ASPbill.ServiceTax=10;
        ASPbill.Deduction=100;
        ASPbill.reasonDeduction='';
        ASPbill.finalAmount=1000000000.00;
        ASPbill.totalAmount();
        ASPbill.buttonflag=false;
        long longDecimalnumber = long.valueof('1000000000');
        
        ASPbill.convert(longDecimalnumber);
        ASPbill.GeneratePDF();
        test.stopTest();
  } *********/