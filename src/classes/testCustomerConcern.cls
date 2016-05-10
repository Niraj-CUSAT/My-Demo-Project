/*************************************************************************************************
        Created by    :    Bhanu Vallabhu, KVP Business Solutions
        Created On    :    15 APR 2013
        Modified by   :    Shweta Kumari, KVP Business Solutions    
        Modified on   :    05/03/2014
        Description   :    Test class for customer concern Trigger
**************************************************************************************************/

@isTest
Private class testCustomerConcern{
    Static testmethod void TestConcern()
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
        
       /* Asset ast = new Asset();
        ast.Name = '12341308130123';
        ast.contactid = ct.id;
        ast.Product2id = pr.id;
        ast.AOSI_Active__c = true;
        insert ast;*/
       
        Customer_Concern__c cc = new Customer_Concern__c();
        cc.Name = 'Sound from Heater';
        insert cc;                
           
        ID Rtid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
        list<case> caselist = new list<case>();
       /* Case c = new Case();
        c.recordtypeid = Rtid;
        c.reason =  'Service';
        c.contactid = ct.id;
        //c.Assetid = ast.id;       
        c.AOSIProduct__c= pr.id;
        c.AOSI_Customer_Concern__c  = 'Sound from Heater';
        caselist.add(c);*/
        
       Case c1 = new Case();
        c1.recordtypeid = Rtid;
        c1.reason =  'Chargeable Installation';
        c1.contactid = ct.id;
        //c1.Assetid = ast.id;       
        c1.AOSIProduct__c= pr.id;        
        c1.Quantity__c ='2';
                
        caselist.add(c1);
        
        Case c2 = new Case();
        c2.recordtypeid = Rtid;
        c2.reason =  'Contract Request';
        c2.contactid = ct.id;
       // c2.Assetid = ast.id;       
        c2.AOSIProduct__c= pr.id;                      
        caselist.add(c2);       
       /* test.startTest(); 
        try{
            database.insert(caselist,false);
        }
        Catch(Exception e){
            system.debug('-------e------'+e);
        }               
        test.stopTest();*/
        
        /*c1.Quantity__c ='6';  
        update c1;*/
        
      /*   Case c3 = new Case();
        c3.recordtypeid = Rtid;
        c3.reason =  'Chargeable Installation';
        c3.contactid = ct.id;
        //c1.Assetid = ast.id;       
        c3.AOSIProduct__c= pr.id;        
        c3.Quantity__c ='1';
        c3.ParentId=c1.id;  
        insert c3;   */   
        //caselist.add(c1);
        
          
    }
}