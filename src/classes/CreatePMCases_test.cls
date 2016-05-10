@isTest
Private class CreatePMCases_test{
    Static testmethod void TestCreatePMCase()
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
        Contact ct = new Contact();
        ct.Lastname = 'Test';
        ct.accountid = acc.id;
        ct.phone = '8861925544';
        ct.AOSI_Pin_Code__c= pin.id;
        ct.recordtypeid = Conrtid;
        insert ct;
        
        Contact ct2 = new Contact();
        ct2.Lastname = 'Test2';
        ct2.accountid = acc.id;
        ct2.phone = '8861925542';
        ct2.recordtypeid = Conrtid;
        ct2.AOSI_Pin_Code__c= pin.id;
        insert ct2;
        
        Contact ct3 = new Contact();
        ct3.Lastname = 'Test3';
        ct3.accountid = acc.id;
        ct3.phone = '9949643992';
        ct3.AOSI_Pin_Code__c= pin.id;
        ct3.recordtypeid = Conrtid;
        insert ct3;
        
        Contact ct4 = new Contact();
        ct4.Lastname = 'Test4';
        ct4.accountid = acc.id;
        ct4.phone = '9949643993';
        ct4.AOSI_Pin_Code__c= pin.id;
        ct4.recordtypeid = Conrtid;
        insert ct4;
        
        AMC_Master__c amc = new AMC_Master__c();
        amc.name = 'test';
        amc.AOSI_Contract_Type__c = 'WH-AMC';
        amc.AOSI_Contract_Period_In_Years__c = '2';
        amc.AOSI_Status__c = 'active';
        amc.AOSI_Number_Of_PM_s_Visit__c=4;
        insert amc;
        
         Product2 pr = new Product2();
         pr.name = 'AOSI123456';
         pr.IsActive = True;
         pr.AOSIColorPanel_Free__c='Yes';
         pr.AOSI_Product_Code_for_Serial_Number__c='1234';
         pr.AOSI_Free_Installtion__c='Yes';
         pr.AOSI_PM_Service__c = 'Yes';
         pr.AOSI_Vertical__c = 'Water Treatment';
         pr.AOSI_AMC__c = amc.id;
         pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
         insert pr;
        
        Asset ast = new Asset();
        ast.Name = '12341212130001';
        ast.contactid = ct.id;
        ast.Product2id = pr.id;
        ast.PurchaseDate = System.today()-90;
        ast.AOSI_Active__c = true;       
        insert ast;
        
        Asset ast2 = new Asset();
        ast2.Name = '12341212130002';
        ast2.contactid = ct2.id;
        ast2.Product2id = pr.id;
        ast2.PurchaseDate = System.today()-180;
        ast2.AOSI_Active__c = true;     
        insert ast2;   
        
        Asset ast3 = new Asset();
        ast3.Name = '12341212130003';
        ast3.contactid = ct3.id;
        ast3.Product2id = pr.id;
        ast3.PurchaseDate = System.today()-270;        
        ast3.AOSI_Active__c = true;
        insert ast3;
        
        Asset ast4 = new Asset();
        ast4.Name = '12341212130004';
        ast4.contactid = ct4.id;
        ast4.Product2id = pr.id;
        ast4.PurchaseDate = System.today()-360;
        ast4.AOSI_Active__c = true;     
        insert ast4;  
         
      /*  List<AOSI_Contract__c> contList = new List<AOSI_Contract__c>();
        AOSI_Contract__c cont = new AOSI_Contract__c();
        cont.Name = 'Test';
        cont.AOSI_AMC__c = amc.id;
        cont.AOSI_Contract_Status__c = 'Active';
        cont.AOSI_Start_Date__c = system.today();
        //cont.AOSI_Contact__c = ct.id;
        cont.AOSI_Asset__c = ast.id;
        cont.AOSI_Amount_Received__c = true;
        contList.add(cont);
                
        AOSI_Contract__c cont1 = new AOSI_Contract__c();
        cont1.Name = 'Test';
        cont1.AOSI_AMC__c = amc.id;
        cont1.AOSI_Contract_Status__c = 'Active';
        cont1.AOSI_Start_Date__c = system.today();
        //cont1.AOSI_Contact__c = ct2.id;
        cont1.AOSI_Asset__c = ast2.id;
        cont1.AOSI_Amount_Received__c = true;
        contList.add(cont1);
        
        AOSI_Contract__c cont2 = new AOSI_Contract__c();
        cont2.Name = 'Test';
        cont2.AOSI_AMC__c = amc.id;
        cont2.AOSI_Contract_Status__c = 'Active';
        cont2.AOSI_Start_Date__c = system.today();
       // cont2.AOSI_Contact__c = ct3.id;
        cont2.AOSI_Asset__c = ast3.id;
        cont2.AOSI_Amount_Received__c = true;
        contList.add(cont2);
        
        AOSI_Contract__c cont3 = new AOSI_Contract__c();
        cont3.Name = 'Test';
        cont3.AOSI_AMC__c = amc.id;
        cont3.AOSI_Contract_Status__c = 'Active';
        cont3.AOSI_Start_Date__c = system.today();
       // cont3.AOSI_Contact__c = ct4.id;
        cont3.AOSI_Asset__c = ast4.id;
        cont3.AOSI_Amount_Received__c = true;
        contList.add(cont3);
        insert contList;*/
        Test.StartTest();
        
        
        
        // Schedule the test job
        
        
        CreatePMCases sh1 = new CreatePMCases();
        String sch = '0 0 23 * * ?'; 
        system.schedule('TestCreatePMCases', sch, sh1); 
        Test.stopTest(); 
    }
}