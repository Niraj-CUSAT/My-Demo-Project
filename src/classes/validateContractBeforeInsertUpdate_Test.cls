@isTest
Private class validateContractBeforeInsertUpdate_Test{
    Static testmethod void testContract(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        Insert acc;
        
        Pin_Master__c pin1 = new Pin_Master__c();
        pin1.AOSI_Region__c = 'South';
        pin1.AOSI_State__c = 'Andra Pradesh';
        pin1.AOSI_City__c = 'Hyderabad';               
        pin1.Name = '560089';
        pin1.AOSI_Type__c = 'City';
        insert pin1;
        
         ID Conrtid = [Select id,name from recordtype where  DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
        Contact ct = new Contact();
        ct.Lastname = 'Test';
        ct.recordtypeid = Conrtid;
        ct.accountid = acc.id;
        ct.phone = '8861925544';
        ct.AOSI_Pin_Code__c= pin1.id;
        test.starttest();
        insert ct;
        test.stoptest();
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
       
        Product_AMC_Junction__c proAmc = new Product_AMC_Junction__c();
        proAmc.AMC_Master__c = amc.id;
        proAmc.Product__c = pr.id;
        insert proAmc;                
        
        Asset ast = new Asset();
        ast.Name = '12341212130001';
        ast.contactid = ct.id;
        ast.Product2id = pr.id;
        ast.PurchaseDate = System.today()-90;
        ast.AOSI_Active__c = true;       
        insert ast;
        
      /*  Service_Engineer__c se = new Service_Engineer__c();
        se.Name = 'Test SE';
        se.Mobile_Number__c = '1234567890';
        se.Region__c='South';
        se.State__c='Andra Pradesh';
        se.AOSI_City__c='Hyderabad'; 
        se.AOSI_Active__c = true;           
        insert se;         
        ID Rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
        List<Case> caselist = New List<case>();
        Case c = new Case();
        c.recordtypeid = Rtid;
        c.reason =  'Contract Request';        
        c.contactid = ct.id;
        c.Assetid = ast.id;
        c.Service_Engineer__c = se.id;
        c.AOSIProduct__c= pr.id;
        c.AOSI_ASP_Class_Type__c='City';
        c.AOSI_Resolution_Time_New__c = 5;
        c.AOSI_Region_picklist__c ='South';
        c.AOSI_State_Picklist__c ='Andra Pradesh';
        c.AOSI_City_Picklist__c ='Hyderabad';
        c.AOSI_Appointment_Date__c =datetime.newInstance( system.today(),time.newInstance(8,00,0,0));
        insert c;*/
        AMC_Pin__c pin = new AMC_Pin__c();
        pin.AOSI_Active__c = true;        
        pin.AOSI_AMC_Pin_Number__c = 'AMC 12345678';               
        pin.AOSI_Type__c = 'AMC';
        insert pin; 
        
        list<AOSI_Contract__c> contList = new list<AOSI_Contract__c>();
        AOSI_Contract__c cont = new AOSI_Contract__c();
        cont.Name = 'AMC 12345678';
        cont.AOSI_AMC__c = amc.id;
        cont.AOSI_Contract_Status__c = 'Active';
        cont.AOSI_Start_Date__c = system.today();
        cont.AOSI_Amount_Received__c = true;
        cont.AOSI_Asset__c = ast.id;
        cont.AOSI_Mode_Of_Payment__c = 'Cash';
        //contList.add(cont);
               
       /* AOSI_Contract__c cont1 = new AOSI_Contract__c();
        cont1.Name = 'Test';
        cont1.AOSI_AMC__c = amc.id;
        cont1.AOSI_Contract_Status__c = 'Active';
        cont1.AOSI_Start_Date__c = system.today().addyears(1);
        cont1.AOSI_Amount_Received__c = true;        
        cont1.AOSI_Asset__c = ast.id; 
        contList.add(cont1);*/
        try{
            insert cont; 
            delete cont;
        } 
        catch(Exception e){
            system.debug('----------e-----------'+e);
        }             
        
    }
}