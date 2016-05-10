@isTest
private class TestServiceServiceCharges {

    static testMethod void test_ServiceChargesAfterBeforeInsert() 
    {
    
      Spares__c sp = new Spares__c();
      sp.Name ='Spare 123';
      sp.Type__c= 'Spare Part';
      sp.Part_Type__c='Pre Filter';
      insert sp;
     
       Product2 pr = new Product2();
    pr.name = 'AOSI123456';
    pr.IsActive = True;
    pr.AOSIColorPanel_Free__c='Yes';
    pr.AOSI_Product_Code_for_Serial_Number__c='1234';
    pr.AOSI_Free_Installtion__c='Yes';
   //pr.AOSI_AMC__c=AMC.id;
    pr.AOSI_In_Contract_Detail__c='Pre Filter';
    pr.RecordTypeid = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Product2' limit 1].id;
    insert pr;
     
     Spare_Product_Junction__c objSpareJunction = new Spare_Product_Junction__c(Spares__c = sp.Id,Product__c = pr.Id);
       insert objSpareJunction;
     
     Case c = new Case();
  c.reason = 'Color Panel Registration';
  c.AOSI_Preferred_Color__c= 'Blue';
  c.AOSIProduct__c= pr.id;
  insert c;
      
      
        Service_Charges__c scr = new Service_Charges__c();
     scr.Case__c = c.id;
     scr.Type__c = 'Part Replacement';
     scr.Quantity__c = 1;
     scr.Spares__c  = sp.Id;
     insert scr;
    }
}