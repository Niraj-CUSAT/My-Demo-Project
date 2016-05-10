@isTest
public class AOSI_ASP_RenewalProcessTest {

    static testMethod void UnitTest1() { 
        test.startTest();
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
       AOSI_ASP_RenewalProcess.renewContract(Asp.Id);

       test.stopTest();
    }
}