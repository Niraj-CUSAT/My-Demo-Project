public class SendSMSfromTrigger
{
  //This class is used to send SMS. It is used by trigger  SendSMSonCase. SendSMSonCase trigger calls the  sendMethod , sendMethod parses the template text and sends the SMS. 
 Public static void sendMethod(String SMSText,Case SMSCase,String Phone)
 {
    
        smagicinteract.TemplateEngine TEngine   = new smagicinteract.TemplateEngine(SMSText); 
        List<String> fields ;
        String extraFieldText = '' ;
        List<String> args = new List<String>{};
        String query; 
        List<String> recordIds ;  // List of Ids of selected Contacts.
        String  objectType   = 'Case'; 
        fields = TEngine.getFieldsFromSMSTextOfObjectType(objectType); 
        String Dupefields = '';
        for(string x: fields){
            
            if( ! Dupefields.Contains(x) )
            extraFieldText = extraFieldText + ', '+x;
            Dupefields = Dupefields + x;
        } 
        
        args = new List<String>{};
        if( extraFieldText != null )
        args.add(extraFieldText );
        else
        args.add('');
        args.add(objectType);
        query = 'select id  {0} from {1} where id = ';
        query = String.format(query, args);
        query = query + '\''+SMSCase.id+'\'';
        System.debug(query);
        Case CurrentCase  = Database.query(query);
        Tengine.getFieldMap(CurrentCase  ); 
        String ConvertedTemplate = TEngine.getReplacedTextForObject(CurrentCase  , 0);
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c(); 
        List<smagicinteract__smsMagic__c> smsObjectList = new List<smagicinteract__smsMagic__c>();
        smsObject.smagicinteract__SenderId__c = 'senderId';
        smsObject.smagicinteract__PhoneNumber__c = Phone; 
        smsObject.smagicinteract__ObjectType__c = 'Case';
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0;
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        smsObject.smagicinteract__SMSText__c =  ConvertedTemplate  ;
        smsObjectList.add(smsObject);
        if(!Test.isrunningtest())
        {
         //smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
         insert smsObject;  
        }    
 }
 
 public static  testMethod  void testsendMethod() {
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
        
        Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
        insert oContactSouth;
        
        Product2 oProdWH                                =   TestHelpUtility.getProduct();
        oProdWH.Name                                    =   'WH-TEST-PROD1';
        oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
        oProdWH.AOSI_Family__c                          =   'Storage';
        oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
        insert oProdWH;       

        
        list<Asset> lInsertAsset  =  new list<Asset>();
        Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
        oAsset1.Name                        =   'B0800104041234';
        lInsertAsset.add(oAsset1);        
        insert lInsertAsset;
        
        Case oCase1                     =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
        oCase1.Reason                   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCase1.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCase1.AOSI_City__c             =   'Chennai';      
        insert oCase1;
        
        sendSMSfromTrigger.sendMethod('Hello {!Case.contact_name__c}',oCase1,'1234567');
       test.stopTest();
 }
 
/* public static  testMethod  void testsendMethod()
 {
 
   Account acc = new Account();
    acc.Name = 'Test Account';
    Insert acc;
    
    Pin_Master__c objPin =  new Pin_Master__c();
    objPin.AOSI_Area__c = 'Test';
    objPin.AOSI_City__c = 'Test';
    objPin.AOSI_Country__c = 'Test';
    objPin.AOSI_Region__c = 'East';
    objPin.AOSI_State__c = 'Bihar';
    objPin.AOSI_Street__c = 'Test';
    objPin.AOSI_Type__c = 'Local';
    insert objPin;
   
    Contact ct = new Contact();
    ct.Lastname = 'Test';
    ct.accountid = acc.id;
    ct.phone = '8861825544';
    ct.AOSI_Region__c = 'South';
    ct.AOSI_State__c = 'Andhra Pradesh';
    ct.mailingstate = 'Andhra Pradesh';
    ct.mailingcity= 'HYDERABAD';
    ct.MailingPostalCode = '500070';
    ct.AOSI_Pin_Code__c = objPin.Id;
    insert ct; 
 
    Case testCase = new Case(ContactId = ct.Id );
    insert testCase ;
  
  sendSMSfromTrigger.sendMethod('Hello {!Case.contact_name__c}',testCase ,'1234567');
 
 } */
 
}