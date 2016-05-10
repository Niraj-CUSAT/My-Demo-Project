/*
    Name:   ServiceChargesAfterBeforeInsertTest  
    Created By:  
    Created Date:  
    Modified By:  Dhriti Krishna Ghosh Moulick 
    Last Modified Date: 13/04/2015
    Description:Test class to achieve the following functionality
                1.Displays an error message when the spare product is not same for case product.
                2.Update part charges
                   a.if chargable is yes,then update part charges as spare MRP charge
                   b.if chargable is no,free parts will be become true,part charges updated as zero.
                   c.if conditions not satisfied,part charges will be spare MRP charge
*/
@isTest
private Class ServiceChargesAfterBeforeInsertTest{
  private static testMethod void positiveTest(){
 list<RecordTypeDetails__c> recordTypes  =  TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
	
       Account accDetails = TestHelpUtility.getAccount();//Inserting Account
       insert accDetails;
       
       Pin_Master__c pinDetails =  TestHelpUtility.getPinMaster('600114', 'South', 'Bangalore', 'Karnataka');//	Inserting Pin Master
       insert pinDetails;
       
    
        Contact ctDetails = TestHelpUtility.getContact(accDetails, pinDetails);
        insert ctDetails;
       
     
       Product2 prDetails = TestHelpUtility.getProduct();
       prDetails.name = 'AOSI123456';
       prDetails.IsActive = True;
       prDetails.AOSIColorPanel_Free__c='Yes';
       prDetails.AOSI_Product_Code_for_Serial_Number__c='1234';
       prDetails.AOSI_Free_Installtion__c='Yes';
       insert prDetails;
       
       Manufactured_Serial_Numbers__c manufac = new Manufactured_Serial_Numbers__c();//Inserting Manufactury Serial Number in Custom Settings
       manufac.Name='12341212130002';
       insert manufac;
        
       Asset ast = new Asset();
       ast.Name = '12341212130002';
       ast.contactid =  ctDetails.id;
       ast.Product2id = prDetails.id;
       ast.AOSI_Active__c=true;
       ast.PurchaseDate = system.today();
       insert ast ;
             
     
       Service_Engineer__c se = TestHelpUtility.getResource();
       insert se;
       
        smagicinteract__SMS_SenderId__c senderId = TestHelpUtility.getSMSSenderID();
        insert senderId;
        system.debug('*******************TEST SMS SENDER ID '+senderId);
        String objectType = 'Case';
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(objectType);  
        insert smsTemplate;
        
        
        Case c = new Case();
        c.reason =  'Field Trial';        
        c.contactid = ctDetails.id;                
        c.AOSIProduct__c= prDetails.id;                
        c.AOSI_Region_picklist__c ='South';
        c.AOSI_State_Picklist__c ='Karnataka';
        c.AOSI_City_Picklist__c ='Bangalore';  
        insert c;
        c=[SELECT Id,AOSI_City_Picklist__c FROM Case WHERE ID=:c.Id];
        System.assertEquals('Bangalore',c.AOSI_City_Picklist__c);
       
        
        Spares__c sp = new Spares__c();
        sp.Name ='Spare 123';
        sp.Type__c= 'Spare Part';
        sp.Part_Type__c='Pre Filter';
        insert sp;
        System.assertEquals(sp.Part_Type__c,'Pre Filter');
        
        Spare_Product_Junction__c spareJunction = new Spare_Product_Junction__c();
        spareJunction.Spares__c=sp.Id;
        spareJunction.Product__c=prDetails.Id;
        insert spareJunction;
      
        
        Service_Charges__c scr2 = new Service_Charges__c();
        scr2.Case__c = c.id;
        scr2.Type__c = 'Part Replacement';
        scr2.Quantity__c = 1;
        scr2.spares__c = prDetails.id;
        scr2.Asset_Status_Hidden__c='In Contract';
        try{
            insert scr2;
        }catch(DmlException de){
          System.debug('*******************'+de);
        }
        
        //checkRecursive.run =true;
        Service_Charges__c scr3 = new Service_Charges__c();
        scr3.Case__c = c.id;
        scr3.Type__c = 'Part Replacement';
        scr3.Quantity__c = 1;
        scr3.Chargable__c='No';
        scr3.spares__c = sp.id;
        scr3.Asset_Status_Hidden__c='In Contract';
        try{
            insert scr3;
        }catch(DmlException de){
          System.debug('*******************'+de);
        }
         System.debug('********scr3***********'+scr3);
  }
}