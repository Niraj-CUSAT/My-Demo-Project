/*Written By:Dhriti Krishna Ghosh Moulick
  Created Date:2/06/2015
  Modified Date:
  Description:This Test Class is used in Before insert,before update Trigger.
              1.Need to check Duplicate Asset Serial Number.
              2.If Asset is created and edited with duplicate  serial number with Same Contact Name,System will throws following error Messages:
                 -Asset is already registered for same Customer 
              3.If Asset is created with same serial number as stored in Manufactured serial nuber,System will allows,else it will throw error:
                 -Asset Serial number not exist
*/  
@isTest
private class AssetTriggerTest{
  
    static testMethod void myUnitTest() {
    	
       list<RecordTypeDetails__c> recordTypes	=	TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
       
       System.debug('^^^^^^recordTypes^^^^^^^'+recordTypes);
       
       Account accDetails = TestHelpUtility.getAccount();
       insert accDetails;
       
       System.debug('^^^^^^accDetails^^^^^^^'+accDetails);
       
       Pin_Master__c pinDetails = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       insert pinDetails;
       
       System.debug('^^^^^^pinDetails^^^^^^^'+pinDetails);
       
       /*RecordTypeDetails__c contactrecordType = new RecordTypeDetails__c();
       contactrecordType.Name='Contact Name';
       contactrecordType.Developer_Name__c='AOS_India';
       contactrecordType.SobjectType__c='Contact';
       insert contactrecordType;
       
       Recordtype rtContact = DAL.getRecordTypeId(contactrecordType.Developer_Name__c,contactrecordType.SobjectType__c);*/
       
    
       
       Contact ctDetails = TestHelpUtility.getContact(accDetails, pinDetails);
      // ctDetails.Lastname = 'Test';
      // ctDetails.recordtypeid = rtContact.Id;
     //  ctDetails.accountid = accDetails.id;
       //ctDetails.phone = '8861925544';
      // ctDetails.AOSI_Pin_Code__c= pinDetails.id;
       insert ctDetails ;
       
        System.debug('^^^^^^ctDetails^^^^^^^'+ctDetails);
       
      /* RecordTypeDetails__c productrecordType= new RecordTypeDetails__c();
       productrecordType.Name='Product Name';
       productrecordType.Developer_Name__c='AOSIndia';
       productrecordType.SobjectType__c='Product2';
       insert productrecordType;
       
       Recordtype rtProduct=DAL.getRecordTypeId(productrecordType.Developer_Name__c,productrecordType.SobjectType__c);*/
       
       Product2 prDetails = new Product2();
       prDetails.name = 'AOSI123456';
       prDetails.IsActive = True;
       prDetails.AOSIColorPanel_Free__c='Yes';
       prDetails.AOSI_Product_Code_for_Serial_Number__c='1234';
       prDetails.AOSI_Free_Installtion__c='Yes';
   //    prDetails.RecordTypeid = rtProduct.Id;
       insert prDetails;
       
       System.debug('^^^^^^prDetails^^^^^^^'+prDetails);
       
        Manufactured_Serial_Numbers__c manufac = new Manufactured_Serial_Numbers__c();
        manufac.Name='12341212130002';
        insert manufac;
        
        System.debug('^^^^^^manufac^^^^^^^'+manufac);
        
        Asset ast = new Asset();
        ast.Name = '12341212130002';
        ast.contactid =  ctDetails.id;
        ast.Product2id = prDetails.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        try{
          insert ast ;
        }catch(Exception e){
          system.assert(e.getMessage().contains('Asset is Already registered for same Customer'));
          system.assert(e.getMessage().contains('Asset Serial number not exist'));
        }
        
          System.debug('^^^^^^ast^^^^^^^'+ast);
        
        Manufactured_Serial_Numbers__c  manufac1 = new Manufactured_Serial_Numbers__c();
        manufac1.Name='12341212130402';
        insert manufac1;
        
        Asset ast1 = new Asset();
        ast1.Name = '12341212130002';
        ast1.contactid =  ctDetails.id;
        ast1.Product2id = prDetails.id;
        ast1.AOSI_Active__c=true;
        ast1.PurchaseDate = system.today();
        try{
          insert ast1 ;
        }catch(Exception e){
          system.assert(e.getMessage().contains('Asset is Already registered for same Customer'));
        }
   }
   static testMethod void negativeUnitTest() {
   	
   	   list<RecordTypeDetails__c> recordTypes	=	TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
   	   
       Account accDetails = TestHelpUtility.getAccount();
       insert accDetails;
       
       Pin_Master__c pinDetails = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       insert pinDetails;
       
       /*RecordTypeDetails__c contactrecordType = new RecordTypeDetails__c();
       contactrecordType.Name='Contact Name';
       contactrecordType.Developer_Name__c='AOS_India';
       contactrecordType.SobjectType__c='Contact';
       insert contactrecordType;
       
       Recordtype rtContact = DAL.getRecordTypeId(contactrecordType.Developer_Name__c,contactrecordType.SobjectType__c);*/
       
       Contact ctDetails = TestHelpUtility.getContact(accDetails, pinDetails);
      // ctDetails.Lastname = 'Test';
      // ctDetails.recordtypeid = rtContact.Id;
      // ctDetails.accountid = accDetails.id;
      // ctDetails.phone = '8861925544';
     //  ctDetails.AOSI_Pin_Code__c= pinDetails.id;
       insert ctDetails ;
       
       /*RecordTypeDetails__c productrecordType= new RecordTypeDetails__c();
       productrecordType.Name='Product Name';
       productrecordType.Developer_Name__c='AOSIndia';
       productrecordType.SobjectType__c='Product2';
       insert productrecordType;
 
       Recordtype rtProduct=DAL.getRecordTypeId(productrecordType.Developer_Name__c,productrecordType.SobjectType__c);*/
       
       Product2 prDetails = new Product2();
       prDetails.name = 'AOSI123456';
       prDetails.IsActive = True;
       prDetails.AOSIColorPanel_Free__c='Yes';
       prDetails.AOSI_Product_Code_for_Serial_Number__c='1234';
       prDetails.AOSI_Free_Installtion__c='Yes';
      // prDetails.RecordTypeid = rtProduct.Id;
       insert prDetails;
       
        Manufactured_Serial_Numbers__c manufac = new Manufactured_Serial_Numbers__c();
        manufac.Name='12341212130002';
        insert manufac;
        
        Asset ast = new Asset();
        ast.Name = '12341212130002';
        ast.contactid =  ctDetails.id;
        ast.Product2id = prDetails.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        try{
          insert ast ;
        }catch(Exception e){
          system.assert(e.getMessage().contains('Asset is Already registered for same Customer'));
          system.assert(e.getMessage().contains('Asset Serial number not exist'));
        }
        System.debug('^^^^^^^^^^^^^^^'+ast);
        Manufactured_Serial_Numbers__c manufac1 = new Manufactured_Serial_Numbers__c();
        manufac1.Name='12341212130402';
        insert manufac1;
        
        Asset ast1 = new Asset();
        ast1.Name = '12341212130042';
        ast1.contactid =  ctDetails.id;
        ast1.Product2id = prDetails.id;
        ast1.AOSI_Active__c=true;
        ast1.PurchaseDate = system.today();
        try{
          insert ast1 ;
        }catch(Exception e){
          system.assert(e.getMessage().contains('Asset Serial number not exist'));
        }
   }
   static testMethod void negativeUnitTestUpdate() {
   	
   	   list<RecordTypeDetails__c> recordTypes	=	TestHelpUtility.getRecTyCustomSettings();
       insert recordTypes;
   	   
       Account accDetails = TestHelpUtility.getAccount();
       insert accDetails;
       
       Pin_Master__c pinDetails = TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka');
       insert pinDetails;
       
       
       Contact ctDetails = TestHelpUtility.getContact(accDetails, pinDetails);
   
       insert ctDetails ;
       
       Contact ctDetails1 = TestHelpUtility.getContact(accDetails, pinDetails);
   
       insert ctDetails1 ;
       Product2 prDetails = new Product2();
       prDetails.name = 'AOSI123456';
       prDetails.IsActive = True;
       prDetails.AOSIColorPanel_Free__c='Yes';
       prDetails.AOSI_Product_Code_for_Serial_Number__c='1234';
       prDetails.AOSI_Free_Installtion__c='Yes';
      // prDetails.RecordTypeid = rtProduct.Id;
       insert prDetails;
       
        Manufactured_Serial_Numbers__c manufac = new Manufactured_Serial_Numbers__c();
        manufac.Name='12341212130002';
        insert manufac;
        
        Asset ast = new Asset();
        ast.Name = '12341212130002';
        ast.contactid =  ctDetails.id;
        ast.Product2id = prDetails.id;
        ast.AOSI_Active__c=true;
        ast.PurchaseDate = system.today();
        try{
          insert ast ;
        }catch(Exception e){
          system.assert(e.getMessage().contains('Asset is Already registered for same Customer'));
          system.assert(e.getMessage().contains('Asset Serial number not exist'));
        }
        System.debug('^^^^^^^^^^^^^^^'+ast);
        Manufactured_Serial_Numbers__c manufac1 = new Manufactured_Serial_Numbers__c();
        manufac1.Name='12341212130402';
        insert manufac1;
        
        ast.contactid=ctDetails1.Id;
        update ast;
       
   }
}