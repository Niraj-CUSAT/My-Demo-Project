/***********************************************************************************************************************************************
 * Class Name   : TestHelpUtility
 * Description  : Define the objects, that will be helpful to write test class.  
 * Created By   : Pooja P Bhat
 * Created Date : 25/June/2015
 * Method Names : public static Account getAccount() 
                  public static Account getNewAccount(String name,Pin_Master__c pinMaster)                  
                  public static Pin_Master__c getPinMaster(String pinCode, String region, String city, String state)
                  public static City_Master__c getCityMaster(String cityName, String region, String state, String district)
                  public static Contact getContact(Account acc, Pin_Master__c pinMaster)
                  public static Service_Engineer__c getResource()
                  public static Product2 getProduct()
                  public static Customer_Concern__c getCustomerConcern(String customerConcernName, String customerConcern)
                  public static ASP_Rate_Master__c getASPRateMaster(String masterName, String prodCategory)
                  public static ASP__c getASP(User oUser, ASP_Rate_Master__c oAspRateMaster)
                  public static PIN_Allocation__c getPinAllocation(String pinCode, ASP__c oASP, User oUser)
                  public static list<RecordTypeDetails__c> getRecTyCustomSettings()
                  public static Product_Customer_Concern__c getProductCustomerConcern(Customer_Concern__c oCustConcern, Product2 oProduct )
                  public static Asset getAsset(Contact oCon, Product2 oProd) 
                  public static Case getCase(Contact oCon, Asset oAsset, Product2 oProd)
                  public static smagicinteract__SMS_SenderId__c getSMSSenderID()
                  public static list<smagicinteract__SMS_Template__c> getSMSTemplate(String objName)
                  public static AMC_Master__c getAMC(String name, Decimal amount, String contractType)
                  public static Product_AMC_Junction__c getProductAMCJunction(AMC_Master__c oAMC, Product2 oProd)
                  public static smagicinteract__Incoming_SMS__c getIncomingSMS(String externalId, String text, String inboundNum, String mobileNum)
                  public static AOSI_Contract__c getAOSIContract(String contractName, Asset oAsset, Case oCase)
                  public static Locality__c getLocality(String name, Pin_Master__c oPin)
 * ********************************************************************************************************************************************/
 
public class TestHelpUtility {
    
        public static Id caseAOSIRecTy      =   [SELECT Id,Name FROM RecordType WHERE DeveloperName =:'AOSI' and SobjectType =:'Case' LIMIT 1].Id;
        public static Id accAOSIndRecID     =   [SELECT Id,Name FROM RecordType WHERE DeveloperName =:'AOS_India' and SobjectType =:'Account'  LIMIT 1].Id;
        public static Id contactAOSIndRecID =   [SELECT Id,Name FROM RecordType WHERE DeveloperName =:'AOS_India' and SobjectType =:'Contact'  LIMIT 1].Id;
        public static Id caseAOSIndRecID    =   [SELECT Id,Name FROM RecordType WHERE DeveloperName =:'AOSIndia'  and SobjectType =:'Case'     LIMIT 1].Id;
        public static Id prodAOSIndRecID    =   [SELECT Id,Name FROM RecordType WHERE DeveloperName =:'AOSIndia'  and SobjectType =:'Product2' LIMIT 1].Id;
        
        /*************************************************************************************************************************************************
         * Method is used to return Account Object
         * **********************************************************************************************************************************************/
        public static Account getAccount() {            
            Pin_Master__c oPin = TestHelpUtility.getPinMaster('560000', 'South', 'Bangalore', 'Karnataka');
            insert oPin;
            Account oAcc            =   new Account();
            oAcc.RecordTypeId       =   accAOSIndRecID;
            oAcc.Name               =   'Test Account';
            oAcc.AOSI_Pin_Code__c   =   oPin.Id;
            oAcc.ShippingStreet     =   'Dhanashala';        
            return oAcc;
        }  
    
        /*************************************************************************************************************************************************
         * Method is used to return Account Object
         * **********************************************************************************************************************************************/
        public static Account getNewAccount(String name,Pin_Master__c pinMaster) {            
            Account oAcc            =   new Account();
            oAcc.RecordTypeId       =   accAOSIndRecID;
            oAcc.Name               =   name;
            oAcc.AOSI_Pin_Code__c   =   pinMaster.Id;
            oAcc.ShippingStreet     =   'Street 10';        
            return oAcc;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Pin Master Object
         * **********************************************************************************************************************************************/
        public static Pin_Master__c getPinMaster(String pinCode, String region, String city, String state) {
            Pin_Master__c oPinMaster    =   new Pin_Master__c();
            oPinMaster.Name             =   pinCode;
            oPinMaster.AOSI_Region__c   =   region;
            oPinMaster.AOSI_City__c     =   city;
            oPinMaster.AOSI_Type__c     =   'Upcountry';
            oPinMaster.AOSI_State__c    =   state;
            oPinMaster.AOSI_Country__c  =   'India';
            return oPinMaster;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return CityMaster Object
         * **********************************************************************************************************************************************/
        public static City_Master__c getCityMaster(String cityName, String region, String state, String district) {
            City_Master__c oCityMaster  =   new City_Master__c();
            oCityMaster.Name            =   cityName;
            oCityMaster.AOSI_Region__c  =   region;
            oCityMaster.AOSI_State__c   =   state;
            oCityMaster.District__c     =   district;
            return oCityMaster;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Contact Object
         * **********************************************************************************************************************************************/
        public static Contact getContact(Account acc, Pin_Master__c pinMaster) {
            Contact oCon            =   new Contact();
            oCon.RecordTypeId       =   contactAOSIndRecID;
            oCon.Lastname           =   'Test Contact';
            oCon.AccountId          =   acc.Id;
            oCon.Phone              =   '9632871788';
            oCon.AOSI_Pin_Code__c   =   pinMaster.Id;
            oCon.MailingStreet      =   'Test Mailing Street';
            return oCon;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Resource(Service Engineer) Object
         * **********************************************************************************************************************************************/
        public static Service_Engineer__c getResource() {
            Service_Engineer__c oServiceEngg    =   new Service_Engineer__c();
            oServiceEngg.Name                   =   'Test Resource';
            oServiceEngg.Mobile_Number__c       =   '9773587451';
            return oServiceEngg;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Product Object
         * **********************************************************************************************************************************************/
        public static Product2 getProduct() {
            Product2 oProd                                  =   new Product2();
            oProd.Name                                      =   'AOSI777888';
            oProd.IsActive                                  =   True;
            oProd.AOSIColorPanel_Free__c                    =   'Yes';
            oProd.AOSI_Product_Code_for_Serial_Number__c    =   'B080';
            oProd.AOSI_Free_Installtion__c                  =   'Yes';
            oProd.AOSI_PM_Service__c                        =   'Yes';
            oProd.RecordTypeId                              =   prodAOSIndRecID;
            oProd.AOSI_Available_Colors__c                  =   'Blue';
            return oProd;
        }
    
        /*************************************************************************************************************************************************
         * Method is used to return  Customer Concern Object
         * **********************************************************************************************************************************************/
        public static Customer_Concern__c getCustomerConcern(String customerConcernName, String customerConcern) {           
            Customer_Concern__c oCustConcern       =   new Customer_Concern__c();
            oCustConcern.Name                      =   customerConcernName;    
            oCustConcern.Customer_Concern__c       =   customerConcern;                
            return oCustConcern;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return ASP Rate Master Object
         * **********************************************************************************************************************************************/
        public static ASP_Rate_Master__c getASPRateMaster(String masterName, String prodCategory) {
            ASP_Rate_Master__c aspRateMaster        =   new ASP_Rate_Master__c();
            aspRateMaster.Name                      =   masterName;
            aspRateMaster.Product_Category__c       =   prodCategory;
            return aspRateMaster;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return ASP Object
         * **********************************************************************************************************************************************/
        public static  ASP__c getASP(User oUser, ASP_Rate_Master__c oAspRateMaster) {
            ASP__c oASP                                 =   new ASP__c();
            oASP.AOSI_Contract_Effective_From_Date__c   =   System.today().addDays(-365);
            oASP.AOSI_Contract_Effective_To_Date__c     =   System.today().addDays(365);
            oASP.Terminate__c                           =   false;
            oASP.AOSI_ASP_User__c                       =   oUser.Id;
            oASP.AOSI_Service_detail__c                 =   'Free Installation;Color Panel;PM Service;Chargeable Installation;Color Panel (Free);Color Panel (Chargeable);Warranty Registration;Dealer stock;Field Trial;System Testing;Contract Request;Service';
            oASP.AOSI_Product_Category__c               =   'Water Heater;Water Treatment';
            oASP.AOSI_Mobile_No__c                      =   '9632878788';
            oASP.AOSI_WATER_HEATER_I_W__c               =   1;
            oASP.AOSI_WATER_HEATER_O_W__c               =   1;
            oASP.AOSI_Water_Purifier_I_W__c             =   1;
            oASP.AOSI_Water_Purifier_O_W__c             =   1;
            oASP.AOSI_CITY_DISTRICT_NAME__c             =   oAspRateMaster.Id;        
            return oASP;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return PIN Allocation Object
         * **********************************************************************************************************************************************/
        public static PIN_Allocation__c getPinAllocation(String pinCode, ASP__c oASP, User oUser) {
            PIN_Allocation__c opinAlloc         =   new PIN_Allocation__c();
            opinAlloc.PIN__c                    =   pinCode;
            opinAlloc.AOSI_ASP__c               =   ( oASP.Id != null ? oASP.Id : null );
            opinAlloc.ASP__c                    =   oUser.Id;
            return opinAlloc;
        }
        
    
        /*************************************************************************************************************************************************
         * Method is used to return RecordType Details of Case,Product,Contact Object
         * **********************************************************************************************************************************************/
        public static list<RecordTypeDetails__c> getRecTyCustomSettings(){
            list<RecordTypeDetails__c> listRecType  =   new list<RecordTypeDetails__c>();
            
            RecordTypeDetails__c oRecType1  =   new RecordTypeDetails__c();
            oRecType1.Name                  =   'Account Name';
            oRecType1.Developer_Name__c     =   'AOS_India';
            oRecType1.SobjectType__c        =   'Account';
            listRecType.add(oRecType1);
            RecordTypeDetails__c oRecType2  =   new RecordTypeDetails__c();
            oRecType2.Name                  =   'Contact Name';
            oRecType2.Developer_Name__c     =   'AOS_India';
            oRecType2.SobjectType__c        =   'Contact';
            listRecType.add(oRecType2);
            RecordTypeDetails__c oRecType3  =   new RecordTypeDetails__c();
            oRecType3.Name                  =   'Case AOSI';
            oRecType3.Developer_Name__c     =   'AOSI';
            oRecType3.SobjectType__c        =   'Case';
            listRecType.add(oRecType3);         
            RecordTypeDetails__c oRecType4  =   new RecordTypeDetails__c();
            oRecType4.Name                  =   'Case Name';
            oRecType4.Developer_Name__c     =   'AOSIndia';
            oRecType4.SobjectType__c        =   'Case';
            listRecType.add(oRecType4);
            RecordTypeDetails__c oRecType5  =   new RecordTypeDetails__c();
            oRecType5.Name                  =   'Product Name';
            oRecType5.Developer_Name__c     =   'AOSIndia';
            oRecType5.SobjectType__c        =   'Product2';
            listRecType.add(oRecType5);
            RecordTypeDetails__c oRecType6  =   new RecordTypeDetails__c();
            oRecType6.Name                  =   'SMS SenderID';
            oRecType6.Developer_Name__c     =   'AOSSVC';
            oRecType6.SobjectType__c        =   'smagicinteract__SMS_SenderId__c';
            listRecType.add(oRecType6);
            return listRecType;
        } 
        
        
        /*************************************************************************************************************************************************
         * Method is used to return Product Customer Concern Object
         * **********************************************************************************************************************************************/
        public static Product_Customer_Concern__c getProductCustomerConcern(Customer_Concern__c oCustConcern, Product2 oProduct ) {
            Product_Customer_Concern__c prodCC  = new Product_Customer_Concern__c();
            prodCC.Customer_Concern__c          =   oCustConcern.Id;
            prodCC.Product__c                   =   oProduct.Id;
            return prodCC;   
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Asset Object
         * **********************************************************************************************************************************************/
        public static Asset getAsset(Contact oCon, Product2 oProd) {
            Asset oAsset        =   new Asset();
            oAsset.Name         =   'B0800104041234';
            oAsset.contactid    =   oCon.Id;
            oAsset.AccountId    =   oCon.AccountId;
            oAsset.Product2id   =   oProd.Id;
            oAsset.PurchaseDate =   System.today();
            return oAsset;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Case Object 
         * **********************************************************************************************************************************************/
        public static Case getCase(Contact oCon, Asset oAsset, Product2 oProd) {            
            Case oCase                      =   new Case();         
            oCase.RecordTypeId              =   caseAOSIndRecID;
            oCase.contactid                 =   oCon.Id;
            oCase.AssetId                   =   oAsset.Id;
            oCase.AOSIProduct__c            =   oProd.Id;
            oCase.AOSI_Preferred_Color__c   =   'Blue';
            oCase.AOSI_Promoter_Name__c     =   'Test Promoter';
            oCase.AOSI_Promoter_Counter_Name__c    =    'Test Promoter Counter';
            oCase.AOSI_Requested_By__c      =    'Customer';
            return oCase;
        } 
    
        /*************************************************************************************************************************************************
         * Method is used to return SMS Magic Interact Sender ID
         * **********************************************************************************************************************************************/
        public static smagicinteract__SMS_SenderId__c getSMSSenderID() {
            smagicinteract__SMS_SenderId__c senderId = new smagicinteract__SMS_SenderId__c();
            senderId.smagicinteract__senderId__c  = DefineConstant.SMS_SENDER_ID;
            return senderId; 
        }
    
        /*************************************************************************************************************************************************
         * Method is used to return list SMS Template from SMS Magic Interact - SMS Templates object
         * **********************************************************************************************************************************************/
        public static list<smagicinteract__SMS_Template__c> getSMSTemplate(String objName) {
            system.debug('!!OBJ'+objName);
                list<smagicinteract__SMS_Template__c> listSMSTemplate = new list<smagicinteract__SMS_Template__c>();
                smagicinteract__SMS_Template__c OTP_Temp             = new smagicinteract__SMS_Template__c();
                OTP_Temp.smagicinteract__Text__c                     = 'Test Text SMS on Case for OTP';
                OTP_Temp.smagicinteract__Name__c                     = 'SMS to send OTP to the customer';
                OTP_Temp.smagicinteract__ObjectName__c               = objName;
                listSMSTemplate.add(OTP_Temp);
            
                smagicinteract__SMS_Template__c tempInstall             = new smagicinteract__SMS_Template__c();
                tempInstall.smagicinteract__Text__c                     = 'Test Text SMS on Case for Installation';
                tempInstall.smagicinteract__Name__c                     = 'SMS on Case for Installation';
                tempInstall.smagicinteract__ObjectName__c               = objName;
                listSMSTemplate.add(tempInstall);
                smagicinteract__SMS_Template__c tempColorPanelReg       = new smagicinteract__SMS_Template__c();
                tempColorPanelReg.smagicinteract__Text__c               = 'Test Text SMS on Case for Color Panel Registration';
                tempColorPanelReg.smagicinteract__Name__c               = 'SMS on Case for Color Panel Registration';
                tempColorPanelReg.smagicinteract__ObjectName__c         = objName;  
                listSMSTemplate.add(tempColorPanelReg);
                smagicinteract__SMS_Template__c tempComplaintReg        = new smagicinteract__SMS_Template__c();
                tempComplaintReg.smagicinteract__Text__c                = 'Test Text SMS on Case for Complaint Registration';
                tempComplaintReg.smagicinteract__Name__c                = 'SMS on Case for Complaint Registration';
                tempComplaintReg.smagicinteract__ObjectName__c          = objName;  
                listSMSTemplate.add(tempComplaintReg);
                smagicinteract__SMS_Template__c tempWarrantyReg         = new smagicinteract__SMS_Template__c();
                tempWarrantyReg.smagicinteract__Text__c                 = 'Test Text SMS on Case for Warranty Registration';
                tempWarrantyReg.smagicinteract__Name__c                 = 'SMS on Case for Warranty Registration';
                tempWarrantyReg.smagicinteract__ObjectName__c           = objName;  
                listSMSTemplate.add(tempWarrantyReg);
                smagicinteract__SMS_Template__c tempSrvEnggDetail       = new smagicinteract__SMS_Template__c();
                tempSrvEnggDetail.smagicinteract__Text__c               = 'Test Text SMS on Case for Service Engineer Details to Customer';
                tempSrvEnggDetail.smagicinteract__Name__c               = 'SMS on Case for Service Engineer Details to Customer';
                tempSrvEnggDetail.smagicinteract__ObjectName__c         = objName;  
                listSMSTemplate.add(tempSrvEnggDetail);
                smagicinteract__SMS_Template__c tempInstallerComplaint  = new smagicinteract__SMS_Template__c();
                tempInstallerComplaint.smagicinteract__Text__c          = 'Test Text SMS on Case to Installer for Complaint';
                tempInstallerComplaint.smagicinteract__Name__c          = 'SMS on Case to Installer for Complaint';
                tempInstallerComplaint.smagicinteract__ObjectName__c    = objName;  
                listSMSTemplate.add(tempInstallerComplaint);
                smagicinteract__SMS_Template__c tempInstallerInstallation= new smagicinteract__SMS_Template__c();
                tempInstallerInstallation.smagicinteract__Text__c       = 'Test Text SMS on Case to Installer for Installation';
                tempInstallerInstallation.smagicinteract__Name__c       = 'SMS on Case to Installer for Installation';
                tempInstallerInstallation.smagicinteract__ObjectName__c = objName;  
                listSMSTemplate.add(tempInstallerInstallation);
                smagicinteract__SMS_Template__c tempCloseColorPanel     = new smagicinteract__SMS_Template__c();
                tempCloseColorPanel.smagicinteract__Text__c             = 'Test Text SMS on Case Close for Color Panel';
                tempCloseColorPanel.smagicinteract__Name__c             = 'SMS on Case Close for Color Panel';
                tempCloseColorPanel.smagicinteract__ObjectName__c       = objName;  
                listSMSTemplate.add(tempCloseColorPanel);
                smagicinteract__SMS_Template__c tempCloseInstall        = new smagicinteract__SMS_Template__c();
                tempCloseInstall.smagicinteract__Text__c                = 'Test Text SMS on Case Close for Installation';
                tempCloseInstall.smagicinteract__Name__c                = 'SMS on Case Close for Installation';
                tempCloseInstall.smagicinteract__ObjectName__c          = objName;  
                listSMSTemplate.add(tempCloseInstall);
                smagicinteract__SMS_Template__c tempCloseComplaint      = new smagicinteract__SMS_Template__c();
                tempCloseComplaint.smagicinteract__Text__c              = 'Test Text SMS on Case Close for Complaint';
                tempCloseComplaint.smagicinteract__Name__c              = 'SMS on Case Close for Complaint';
                tempCloseComplaint.smagicinteract__ObjectName__c        = objName;  
                listSMSTemplate.add(tempCloseComplaint);
                smagicinteract__SMS_Template__c tempStatusCancelled     = new smagicinteract__SMS_Template__c();
                tempStatusCancelled.smagicinteract__Text__c             = 'Test Text When call status is changed to Cancelled';
                tempStatusCancelled.smagicinteract__Name__c             = 'When call status is changed to Cancelled';
                tempStatusCancelled.smagicinteract__ObjectName__c       = objName;  
                listSMSTemplate.add(tempStatusCancelled);
                smagicinteract__SMS_Template__c tempStatusOnHold        = new smagicinteract__SMS_Template__c();
                tempStatusOnHold.smagicinteract__Text__c                = 'Test Text When call status is changed to onHold';
                tempStatusOnHold.smagicinteract__Name__c                = 'When call status is changed to onHold';
                tempStatusOnHold.smagicinteract__ObjectName__c          = objName;  
                listSMSTemplate.add(tempStatusOnHold);
                smagicinteract__SMS_Template__c tempServCharges         = new smagicinteract__SMS_Template__c();
                tempServCharges.smagicinteract__Text__c                 = 'Test Text SMS to customer for service charges';
                tempServCharges.smagicinteract__Name__c                 = 'SMS to customer for service charges';
                tempServCharges.smagicinteract__ObjectName__c           = objName;  
                listSMSTemplate.add(tempServCharges);
                smagicinteract__SMS_Template__c tempSalesQuery          = new smagicinteract__SMS_Template__c();
                tempSalesQuery.smagicinteract__Text__c                  = 'Test Text SMS On Case On Sales Query Case Creation New';
                tempSalesQuery.smagicinteract__Name__c                  = 'SMS On Case On Sales Query Case Creation New';
                tempSalesQuery.smagicinteract__ObjectName__c            = objName;  
                listSMSTemplate.add(tempSalesQuery);
                smagicinteract__SMS_Template__c tempColorPanelNew       = new smagicinteract__SMS_Template__c();
                tempColorPanelNew.smagicinteract__Text__c               = 'Test Text SMS on Case to Installer for Colorpanel new';
                tempColorPanelNew.smagicinteract__Name__c               = 'SMS on Case to Installer for Colorpanel new';
                tempColorPanelNew.smagicinteract__ObjectName__c         = objName;  
                listSMSTemplate.add(tempColorPanelNew);
                smagicinteract__SMS_Template__c tempRespondSMS          = new smagicinteract__SMS_Template__c();
                tempRespondSMS.smagicinteract__Text__c                  = 'Test Text SMS on Respond time to customer';
                tempRespondSMS.smagicinteract__Name__c                  = 'SMS on Respond time to customer';
                tempRespondSMS.smagicinteract__ObjectName__c            = objName;  
                listSMSTemplate.add(tempRespondSMS);
                smagicinteract__SMS_Template__c tempSQAssignNew         = new smagicinteract__SMS_Template__c();
                tempSQAssignNew.smagicinteract__Text__c                 = 'Test Text SMS On Case On Sales Query Case Assignment New';
                tempSQAssignNew.smagicinteract__Name__c                 = 'SMS On Case On Sales Query Case Assignment New';
                tempSQAssignNew.smagicinteract__ObjectName__c           = objName;  
                listSMSTemplate.add(tempSQAssignNew);
                smagicinteract__SMS_Template__c tempSQCancelNew         = new smagicinteract__SMS_Template__c();
                tempSQCancelNew.smagicinteract__Text__c                 = 'Test Text SMS On Case On Sales Query Case Cancellation New';
                tempSQCancelNew.smagicinteract__Name__c                 = 'SMS On Case On Sales Query Case Cancellation New';
                tempSQCancelNew.smagicinteract__ObjectName__c           = objName;  
                listSMSTemplate.add(tempSQCancelNew);
                smagicinteract__SMS_Template__c tempSQClose             = new smagicinteract__SMS_Template__c();
                tempSQClose.smagicinteract__Text__c                     = 'Test Text SMS On Case On Sales Query Case Close';
                tempSQClose.smagicinteract__Name__c                     = 'SMS On Case On Sales Query Case Close New'; 
                tempSQClose.smagicinteract__ObjectName__c               = objName;  
                listSMSTemplate.add(tempSQClose);  
                smagicinteract__SMS_Template__c tempSurveyOnClose       = new smagicinteract__SMS_Template__c();
                tempSurveyOnClose.smagicinteract__Text__c               = 'Test Text SMS Survey on Case After 2 Days of Closing';
                tempSurveyOnClose.smagicinteract__Name__c               = 'SMS Survey on Case After 2 Days of Closing'; 
                tempSurveyOnClose.smagicinteract__ObjectName__c         = objName;  
                listSMSTemplate.add(tempSurveyOnClose);  
            
            return listSMSTemplate;
            
        }
    
        /*************************************************************************************************************************************************
         * Method is used to return AMC Master Object 
         * **********************************************************************************************************************************************/
        public static AMC_Master__c getAMC(String name, Decimal amount, String contractType) {           
            AMC_Master__c oAMC                      =   new AMC_Master__c();            
            oAMC.Name                               =   name;
            oAMC.AOSI_AMC_Amount__c                 =   amount;
            oAMC.AOSI_Contract_Period_In_Years__c   =   '1';
            oAMC.AOSI_Contract_Type__c              =   contractType;
            oAMC.MRP__c                             =   3000;
            oAMC.AOSI_Number_Of_PM_s_Visit__c       =   5;
            oAMC.Number_Of_PM_Visits__c             =   '2';
            oAMC.AOSI_Status__c                     =   DefineConstant.AMC_STATUS_ACTIVE;
            oAMC.AMC_Deatil__c                      =   'Product Health Care Visit;Electrical Functional Parts;Pre Filter;Sediment Filter;Pre Carbon Filter;Post GAC Filter;Argonide Filter;Alkaline Filter;Membrane';
            return oAMC;
        }
        
        
        /*************************************************************************************************************************************************
         * Method is used to return Product AMC Junction Object 
         * **********************************************************************************************************************************************/
        public static Product_AMC_Junction__c getProductAMCJunction(AMC_Master__c oAMC, Product2 oProd) {
            Product_AMC_Junction__c oPAMC    =    new Product_AMC_Junction__c();
            oPAMC.AMC_Master__c              =    oAMC.Id;
            oPAMC.Product__c                 =    oProd.Id;
            return oPAMC;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Incoming SMS Object 
         * **********************************************************************************************************************************************/
        public static smagicinteract__Incoming_SMS__c getIncomingSMS(String externalId, String text, String inboundNum, String mobileNum) {
            smagicinteract__Incoming_SMS__c oInSMS      =   new smagicinteract__Incoming_SMS__c();
            oInSMS.smagicinteract__external_field__c    =   externalId;
            oInSMS.smagicinteract__SMS_Text__c          =   text;
            oInSMS.smagicinteract__Inbound_Number__c    =   inboundNum;
            oInSMS.smagicinteract__Mobile_Number__c     =   mobileNum;
            return oInSMS;
        }
    
        /*************************************************************************************************************************************************
         * Method is used to return AOSI Contract Object 
         * **********************************************************************************************************************************************/
        public static AOSI_Contract__c getAOSIContract(String contractName, Asset oAsset, Case oCase) {
            AOSI_Contract__c oContract              =   new AOSI_Contract__c();
            oContract.Name                          =   contractName;
            oContract.AOSI_Asset__c                 =   oCase.AssetId;
            oContract.AOSI_Case__c                  =   oCase.Id;
            oContract.AOSI_Start_Date__c            =   System.today(); 
            return oContract;
        }
        
        
        /*************************************************************************************************************************************************
         * Method is used to return Locality Object 
         * **********************************************************************************************************************************************/
        public static Locality__c getLocality(String name, Pin_Master__c oPin) {
            Locality__c oLoc           =   new Locality__c();
            oLoc.Name                  =   name;
            oLoc.AOSI_Pin_Master__c    =   oPin.Id; 
            return oLoc;
        }
        
        /*************************************************************************************************************************************************
         * Method is used to return Manufactured Serial Number Object 
         * **********************************************************************************************************************************************/
        public static Manufactured_Serial_Numbers__c getMnfctrSrlNum(String name) {
            Manufactured_Serial_Numbers__c oMSN =   new Manufactured_Serial_Numbers__c();
            oMSN.Name                  =   name;
            return oMSN;
        }
    
        
        /*************************************************************************************************************************************************
         * Method is used to return AOSI_Time_Calculation_Settings__c
         * **********************************************************************************************************************************************/
        public static list<AOSI_Time_Calculation_Settings__c> getTimeCalCustSttng() {
            list<AOSI_Time_Calculation_Settings__c> lTimeSettng  =   new list<AOSI_Time_Calculation_Settings__c>();
            
            AOSI_Time_Calculation_Settings__c timeSet1  =   new AOSI_Time_Calculation_Settings__c();
            timeSet1.Name                               =   DefineConstant.CS_DAILY_SMS_TIMING;
            timeSet1.AOSI_Work_End_Time__c              =   '20:00:00';
            timeSet1.AOSI_Work_Start_Time__c            =   '08:00:00';
            lTimeSettng.add(timeSet1);
            AOSI_Time_Calculation_Settings__c timeSet2  =   new AOSI_Time_Calculation_Settings__c();
            timeSet2.Name                               =   DefineConstant.CS_SCHEDULESMS_NEXTDAY;
            timeSet2.AOSI_Work_End_Time__c              =   '23:00:00';
            timeSet2.AOSI_Work_Start_Time__c            =   '20:00:00';
            lTimeSettng.add(timeSet2);
            AOSI_Time_Calculation_Settings__c timeSet3  =   new AOSI_Time_Calculation_Settings__c();
            timeSet3.Name                               =   DefineConstant.CS_SCHEDULESMS_SAMEDAY;
            timeSet3.AOSI_Work_End_Time__c              =   '07:00:00';
            timeSet3.AOSI_Work_Start_Time__c            =   '00:00:00';
            lTimeSettng.add(timeSet3);
            AOSI_Time_Calculation_Settings__c timeSet4  =   new AOSI_Time_Calculation_Settings__c();
            timeSet4.Name                               =   DefineConstant.CS_CASE_REG_IN_BTW;
            timeSet4.AOSI_Work_End_Time__c              =   '15:59:49';
            timeSet4.AOSI_Work_Start_Time__c            =   '08:00:00';
            lTimeSettng.add(timeSet4);
            AOSI_Time_Calculation_Settings__c timeSet5  =   new AOSI_Time_Calculation_Settings__c();
            timeSet5.Name                               =   DefineConstant.CS_START_SMS_NEXT_DAY;
            timeSet5.AOSI_Work_End_Time__c              =   '20:00:00';
            timeSet5.AOSI_Work_Start_Time__c            =   '10:00:00';
            lTimeSettng.add(timeSet5);
            AOSI_Time_Calculation_Settings__c timeSet6  =   new AOSI_Time_Calculation_Settings__c();
            timeSet6.Name                               =   DefineConstant.CS_REPEAT_CALL_DURATION;
            timeSet6.AOSI_Days__c                       =   90;
            lTimeSettng.add(timeSet6);
            
            return lTimeSettng;
        } 
    
        
        
    
    
        
    
        

}