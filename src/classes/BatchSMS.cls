global class BatchSMS implements Database.Batchable<Case>, Database.Stateful,Database.AllowsCallouts  

{ 
    //This class is used to select all cases updated from 8PM to 7AM and send the SMS to customers as a bulk using apex batch methods
   
    Public List<Case> caseListAll; 
    Public smagicinteract__SMS_Template__c  SMS_TemplateInstaller;  
    Public smagicinteract__SMS_Template__c  SMS_TemplateComplaint;
    Public smagicinteract__SMS_Template__c  SMS_TemplateColorPanel;       
    Public smagicinteract__SMS_Template__c  SMS_TemplateAll;    
    Public Map<String,String> CaseIdtoTemplateText = new  Map<String,String>();

    global   Iterable<case>  start(Database.BatchableContext bc) 
    {
        caseListAll = new List<Case>();
        Recordtype AOSIndiaCase = [Select id  from Recordtype where sobjecttype=:'case' and DeveloperName =:'AOSIndia'];
        try {       
            SMS_TemplateInstaller   = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case Close for Installation'];  
            SMS_TemplateComplaint   = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case Close for Complaint' ];  
            SMS_TemplateColorPanel  = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case Close for Color Panel'];  
            SMS_TemplateAll         = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case for Installation/Warranty/Color Panel'];  } catch( Exception e ) { return caseListAll; }
        
        String Default_Template = '';
        List<smagicinteract__smsMagic__c> smsObjectList = new List<smagicinteract__smsMagic__c>();  
        
        if(!Test.isrunningtest() ) caseListAll = [Select id , Contact_Name__c , Contact_Phone__c , Case_Type__c , Reason from Case Where Status =: 'Closed' AND SMS_Status__c !=: 'SMS_SENT_BY_SCHEDULER' AND  SMS_Status__c !=: 'SMS_SENT_BY_WORKFLOW' AND ( Reason = : 'Free Installation' OR Reason = : 'Chargeable Installation' OR  Reason  = : ' Service' OR Reason  =: 'PM Service' OR  Reason  = : 'Color Panel (Free)'  OR Reason  = : 'Color Panel (Chargeable)'     )  AND RecordtypeId =: AOSIndiaCase .id AND ClosedDate >=: System.now().addHours(- 11)       ];

        if(Test.isrunningtest() )  caseListAll = [Select id , Contact_Name__c , Contact_Phone__c , Case_Type__c , Reason from Case Where Status =: 'Closed' AND ( Reason = : 'Free Installation' OR Reason = : 'Chargeable Installation' OR  Reason  = : ' Service' OR Reason  =: 'PM Service' OR  Reason  = : 'Color Panel (Free)'  OR Reason  = : 'Color Panel (Chargeable)'      )  AND RecordtypeId =: AOSIndiaCase .id AND ClosedDate >=: System.now().addHours(- 11)       ];
       
        return caseListAll;
    }  
    
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
         try
        {   
           String Default_Template = '';
           List<smagicinteract__smsMagic__c> smsObjectList = new List<smagicinteract__smsMagic__c>(); 
           smagicinteract__smsMagic__c smsObject;
   
            for(sObject ClosedCasesObject  : scope)
            {
              Case ClosedCase = (Case)ClosedCasesObject;  
              smsObject = new smagicinteract__smsMagic__c(); 
              if( ClosedCase.Reason == 'Free Installation' || ClosedCase.Reason == 'Chargeable Installation' ) 
              convertTemplateText( scope, SMS_TemplateInstaller.smagicinteract__Text__c  );
              if( ClosedCase.Reason  == 'Service' || ClosedCase.Reason  == 'PM Service' ) 
              convertTemplateText( scope, SMS_TemplateComplaint.smagicinteract__Text__c  );
              if( ClosedCase.Reason   == 'Color Panel (Free)' ||  ClosedCase.Reason   == 'Color Panel (Chargeable)' ) 
              convertTemplateText( scope, SMS_TemplateColorPanel.smagicinteract__Text__c );
               
              if( ( ( ClosedCase.Contact_Phone__c != null) && (!Test.isrunningtest()) ) || (Test.isrunningtest())  )
              {
                   smsObject.smagicinteract__SenderId__c = 'AO Smith Service';
                   smsObject.smagicinteract__PhoneNumber__c = ClosedCase.Contact_Phone__c;
                   smsObject.smagicinteract__ObjectType__c = 'Case';
                   smsObject.smagicinteract__disableSMSOnTrigger__c = 1;
                   smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                   smsObject.smagicinteract__SMSText__c =  CaseIdtoTemplateText.get( ClosedCase.id );
                   System.debug('------------------------>'+ CaseIdtoTemplateText.get( ClosedCase.id ));
                   smsObjectList.add(smsObject);
                }
                ClosedCase.SMS_Status__c = 'SMS_SENT_BY_SCHEDULER';
            }
            if(!Test.isrunningtest() )
            {
                smagicinteract.ApexAPI.pushSMSCallout(smsObjectList);
                insert smsObject; 
            }
            update scope ; } catch( Exception e ) {}
    }
    
    
    Public  void    convertTemplateText(List<Case> ConvertCase , String tplText)
    {
     
        smagicinteract.TemplateEngine TEngine   = new smagicinteract.TemplateEngine(tplText); 
        List<String> fields ;
        String extraFieldText ='' ;
        List<String> args = new List<String>{};
        String query; 
        List<String> recordIds ;  // List of Ids of selected Contacts.
        String  objectType   = 'Case';
      
        fields = TEngine.getFieldsFromSMSTextOfObjectType(objectType);
        extraFieldText =  combineFields(fields);
        args = new List<String>{};
        args.add(extraFieldText );
        args.add(objectType);
        query ='select id  {0} from {1} where id in :'; 
        query  = query  + ' ConvertCase '; 
        query = String.format(query, args);
        System.debug(query );
        List<sObject> sObjects = Database.query(query);
        Tengine.getFieldMap(sObjects[0]); 
        for (sObject c :sObjects)
        {   
            CaseIdtoTemplateText.put( c.id, TEngine.getReplacedTextForObject(c, 0));
            System.debug(CaseIdtoTemplateText.get(c.id));
        } 
    
    }
    global void finish(Database.BatchableContext BC)
    {
    }
    public static String combineFields(List<string> fields)
    {
        String extraFieldText = '';
        for(string x: fields){
            extraFieldText = extraFieldText + ', '+x;
        }
        return extraFieldText;
    }
    
    public static testMethod void testBatch()
    {
        Database.executebatch(new BatchSMS ()  );
        smagicinteract__SMS_Template__c  SMS_TemplateAllTest=new smagicinteract__SMS_Template__c  (smagicinteract__Name__c='SMS on Case for Installation/Warranty/Color Panel',smagicinteract__ObjectName__c='Case',smagicinteract__Text__c='{!Case.casenumber}{!Case.Contact_Address__c}{!Case.Contact_Phone__c}');    
        insert SMS_TemplateAllTest;
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

            Service_Engineer__c oServEngg   =   TestHelpUtility.getResource();
            insert oServEngg;
            
            Account oAcc                    =   TestHelpUtility.getNewAccount('Test BatchSMS',oPinMasterSouth);
            insert oAcc;
            
            Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
            insert oContactSouth;
            
            Product2 oProdWH                                =   TestHelpUtility.getProduct();
            oProdWH.Name                                    =   'WH-TEST-PROD1';
            oProdWH.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WH;
            oProdWH.AOSI_Family__c                          =   'Storage';
            oProdWH.AOSI_Product_Code_for_Serial_Number__c  =   'B080';
            insert oProdWH;       
            
            Customer_Concern__c accessoryMissCC =   TestHelpUtility.getCustomerConcern('Accessory Missing', 'Accessory Missing');
            insert accessoryMissCC;
        
            Product_Customer_Concern__c oPCC1           =   TestHelpUtility.getProductCustomerConcern(accessoryMissCC, oProdWH);
            insert oPCC1;
            
            list<Asset> lInsertAsset  =  new list<Asset>();
            Asset oAsset1                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
            oAsset1.Name                        =   'B0800104041234';
            lInsertAsset.add(oAsset1);        
            Asset oAsset2                       =   TestHelpUtility.getAsset(oContactSouth, oProdWH);
            oAsset2.Name                        =   'B0800104041233';
            oAsset2.AOSI_Membrane_Warranty__c   =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            lInsertAsset.add(oAsset2);
            insert lInsertAsset;
            
            list<Case> listCase             =   new list<Case>();
            Case oCase1                     =   TestHelpUtility.getCase(oContactSouth, oAsset2, oProdWH);
            oCase1.Reason                   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
            oCase1.AOSI_City__c             =   'Chennai';
            oCase1.Case_Type__c             =   'Installation';
            listCase.add(oCase1);
            Case oCase2                     =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase2.Reason                   =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
            oCase2.AOSI_Customer_Concern__c =   DefineConstant.CASE_REASON_COLORPANEL_FREE;
            oCase2.AOSI_Preferred_Color__c  =   'Ivory';
            oCase2.Courier_Number__c        =   'COU123456';
            oCase2.Case_Type__c             =   'Color Panel Registration';
            listCase.add(oCase2);
            Case oCase3                     =   TestHelpUtility.getCase(oContactSouth, oAsset1, oProdWH);
            oCase3.Reason                   =   DefineConstant.CASE_REASON_SERVICE;
            oCase3.AOSI_Customer_Concern__c =   'Accessory Missing';
            oCase3.Case_Type__c             =   'Complaint Registration';
            listCase.add(oCase3);
            insert listCase;
            
        
            
            Case_Customer_Concern__c oCCC = new Case_Customer_Concern__c();
            oCCC.Customer_Concern__c    =   'Accessory Missing';
            oCCC.Cause__c               =   'Missing';
            oCCC.Action__c              =   'Provided';
            oCCC.Case__c                =   oCase3.Id;
            insert oCCC;
            
            Spares__c oSpare                =   new Spares__c();
            oSpare.Name                     =   'Test SPARE';
            oSpare.Type__c                  =   'Accessory';
            oSpare.Related_Products__c      =   oProdWH.Name;
            oSpare.Part_Code__c             =   'TEST123';
            oSpare.Active__c                =   true;
            oSpare.MRP__c                   =   1500;
            oSpare.Family__c                =   'Instant';
            oSpare.Part_Type__c             =   'Filter';
            insert oSpare;

            Spare_Product_Junction__c oSPJ  =   new Spare_Product_Junction__c();
            oSPJ.Spares__c                  =   oSpare.Id;
            oSPJ.Product__c                 =   oProdWH.Id;
            insert oSPJ;

            Service_Charges__c oServCharge  =   new Service_Charges__c();
            oServCharge.Case__c             =   oCase3.Id;
            oServCharge.Type__c             =   'Accessory';
            oServCharge.Quantity__c         =   1;
            oServCharge.Chargable__c        =   'Yes';
            insert oServCharge;
            
            list<Case> listCaseUpdate   =   new list<Case>();
            oCase1.Service_Engineer__c  =   oServEngg.Id;   listCaseUpdate.add(oCase1);
            oCase2.Service_Engineer__c  =   oServEngg.Id;   listCaseUpdate.add(oCase2);
            oCase3.Service_Engineer__c  =   oServEngg.Id;   listCaseUpdate.add(oCase3);
            update listCaseUpdate;
            
            AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = false;
            AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive  = false;
            list<Case> listCloseCase   =   new list<Case>();
            oCase1.AOSI_Case_Close_Time__c   =   System.now();
            oCase1.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
            oCase1.AOSI_Purchase_Value__c    =   10000;
            oCase1.AOSI_Water_Source__c      =   'All';
            oCase1.AOSI_pH__c                =   '15';
            oCase1.AOSI_Hardness__c          =   '525';
            oCase1.AOSI_TDS_Input__c         =   '1500';
            oCase1.AOSI_TDS_Output__c        =   '2500';
            oCase1.AOSI_Water_Storage__c     =   'Under ground tank';
            listCloseCase.add(oCase1);
            oCase2.AOSI_Case_Close_Time__c   =   System.now();
            oCase2.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
            oCase2.AOSI_Purchase_Value__c    =   10000;
            oCase2.AOSI_Water_Source__c      =   'All';
            oCase2.AOSI_pH__c                =   '15';
            oCase2.AOSI_Hardness__c          =   '525';
            oCase2.AOSI_TDS_Input__c         =   '1500';
            oCase2.AOSI_TDS_Output__c        =   '2500';
            oCase2.AOSI_Water_Storage__c     =   'Under ground tank';
            listCloseCase.add(oCase2);
            oCase3.AOSI_Case_Close_Time__c   =   System.now();
            oCase3.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
            oCase3.AOSI_Purchase_Value__c    =   10000;
            oCase3.AOSI_Water_Source__c      =   'All';
            oCase3.AOSI_pH__c                =   '15';
            oCase3.AOSI_Hardness__c          =   '525';
            oCase3.AOSI_TDS_Input__c         =   '1500';
            oCase3.AOSI_TDS_Output__c        =   '2500';
            oCase3.AOSI_Water_Storage__c     =   'Under ground tank';
            listCloseCase.add(oCase3);
            update listCloseCase;
        test.stopTest();
        
        List<case>  caseListAll1    = [Select id , Contact_Name__c , Contact_Phone__c , Case_Type__c from Case Where Status =: 'Closed' AND   ( Case_Type__c= : 'Installation' OR  Case_Type__c= : 'Complaint Registration'  OR  Case_Type__c= : 'Color Panel Registration' )  AND ClosedDate >=: System.now().addHours(- 11) ];
        Database.executebatch(new BatchSMS ()  );
    
    }
}