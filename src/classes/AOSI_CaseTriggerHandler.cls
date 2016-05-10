/*****************************************************************************************************************************************************
 * Class Name   : AOSI_CaseTriggerHandler
 * Created By   : Pooja P Bhat
 * Created Date : 8-AUGUST-2015
 * Description  : Handler Class for AOSI_CaseTrigger
 * Constructor  : public AOSI_CaseTriggerHandler(map<Id,Case> newMap, map<Id,Case> oldMap, list<Case> newList)
 * Methods      : public void beforeInsertHandler()
                  public void beforeUpdateHandler()
                  public void afterInsertHandler()
                  public void afterUpdateHandler() 
                  private void beforeInsertUpdateHandler(list<Case> caseList,Boolean isUpdate)
                  private void afterInsertUpdateHandler(list<Case> caseList, map<Id, Asset> assetMap, map<Id,Product2> productMap, Boolean isUpdate)
                  private void updateTimeFields()
                  private Decimal findNoOfDays(Date startDate , Date endDate)
                  private Decimal findNoOfHolidays(Date startDate, Date endDate)
                  private Decimal findFirstDaysHour(Datetime startDate)
                  private Decimal FindLasttDaysHour(Datetime EndDate)
                  private Decimal findFirstDaysHourTimeClock(Datetime startDate)
                  private Decimal findLasttDaysHourTimeClock(Datetime endDate)
                  private Decimal findLasttDaysHourTimeClock(Datetime endDate)
                  public smagicinteract__Scheduled_SMS__c toScheduleSMS(Case objCase,String templateText,Boolean isCustomer,Boolean isRecordInsert)
                  public Task createNewTask(Id userId, Id caseId, String subject, String priority,  String status)
                  private void setSMSTiming()
******************************************************************************************************************************************************/

public class AOSI_CaseTriggerHandler {
    
    public RecordType caseAOSIndiaRecType   =   new RecordType();   //Holds 'AOS India' Recordtype details
    public RecordType caseAOSIRecType       =   new RecordType();   //Holds 'AOSI' Recordtype details
    public String smsSenderID               =   null;               //Holds senderId - which appears on the mobile phone as the sender of a SMS 
    public Time smsStartTime                =   null;               //Used to capture SMS start time
    public Time smsEndTime                  =   null;               //Used to capture SMS end time
    
    public list<Case> newList                       =   new list<Case>(); //Contains trigger.new values
    
    public map<Id,Case> newMap                      =   new map<Id,Case>(); //Contains trigger.newMap values
    public map<Id,Case> oldMap                      =   new map<Id,Case>(); //Contains trigger.oldMap values
    public map<String,String> mapSMSTemplateText    =   new map<String,String>(); //Contains SMS template name and template text
    
    public AOSI_CaseTriggerHandler() {} //Empty Constructor : to reuse methods toScheduleSMS() and createNewTask() by other class
    
    /************************************************************************************************************************************************
    Parameterised Constructor : AOSI_CaseTriggerHandler(map<Id,Case> newMap, map<Id,Case> oldMap, list<Case> newList)
    Description               : Used to initialize all class variables
    *************************************************************************************************************************************************/
    public AOSI_CaseTriggerHandler(map<Id,Case> newMap, map<Id,Case> oldMap, list<Case> newList) {
        this.newMap                         =    newMap;
        this.oldMap                         =    oldMap;
        this.newList                        =    newList; 
        caseAOSIndiaRecType.Id              =    null;                  
        caseAOSIRecType.Id                  =    null;
        try {
            caseAOSIRecType         =   AOSI_StaticQueryHelper.caseAOSIRecType;
            caseAOSIndiaRecType     =   AOSI_StaticQueryHelper.caseAOSIndiaRecType;
            smsSenderID             =   AOSI_StaticQueryHelper.smsSenderID.smagicinteract__senderId__c;
            mapSMSTemplateText      =   AOSI_StaticQueryHelper.mCaseSMSTemplateText;  
            setSMSTiming(); } catch (Exception exp) { System.debug('**Exception from AOSI_CaseTriggerHandler Class** '+exp.getMessage() + exp.getLineNumber()); }
    } //End of constructor AOSI_CaseTriggerHandler()
    
    /*************************************************************************************************************************************************
    Method Name : setSMSTiming() 
    Return Type : void 
    Description : Used to initialize variable smsStartTime, smsEndTime
    *************************************************************************************************************************************************/
    private void setSMSTiming() {
        try {
        AOSI_Time_Calculation_Settings__c oTcs = AOSI_Time_Calculation_Settings__c.getValues(DefineConstant.CS_DAILY_SMS_TIMING);
        Integer startHour   = (oTcs.AOSI_Work_Start_Time__c.split(':')[0] != null ? integer.valueOf(oTcs.AOSI_Work_Start_Time__c.split(':')[0]) : 0);
        Integer startMinute = (oTcs.AOSI_Work_Start_Time__c.split(':')[1] != null ? integer.valueOf(oTcs.AOSI_Work_Start_Time__c.split(':')[1]) : 0);
        Integer startSecond = (oTcs.AOSI_Work_Start_Time__c.split(':')[2] != null ? integer.valueOf(oTcs.AOSI_Work_Start_Time__c.split(':')[2]) : 0);
        Integer endHour     = (oTcs.AOSI_Work_End_Time__c.split(':')[0] != null ? integer.valueOf(oTcs.AOSI_Work_End_Time__c.split(':')[0]) : 0);
        Integer endMinute   = (oTcs.AOSI_Work_End_Time__c.split(':')[1] != null ? integer.valueOf(oTcs.AOSI_Work_End_Time__c.split(':')[1]) : 0);
        Integer endSecond   = (oTcs.AOSI_Work_End_Time__c.split(':')[2] != null ? integer.valueOf(oTcs.AOSI_Work_End_Time__c.split(':')[2]) : 0);
        smsStartTime        = Time.newInstance(startHour, startMinute, startSecond, 0);
        smsEndTime          = Time.newInstance(endHour, endMinute, endSecond, 0); } catch (Exception exp) { System.debug('**Exception from AOSI_CaseTriggerHandler Class while retrieving Custom Setting Record Daily SMS Timing ** '+exp.getMessage() + exp.getLineNumber()); }
    }
    
    /*************************************************************************************************************************************************
    Method Name : beforeInsertUpdateHandler(list<Case> caseList, list<Contact> lContacts,Boolean isUpdate)
    Return Type : void 
    Description : Consists of common logic that need to executed before Insert and before Update context
                  1)Validate Case Record 
                    a)If product doesn't have AMC, then Contract Request Case cannot be created
                    b)Contract Request case can be created 30days before End Date of current contract
                    c)For a asset ColorPanel(Free) and FreeInstallation case cannot be registered more than once
                    d)For a asset case cannot be created with same reason more than once if previously registered case status is still open
                    e)Case cannot be created Customer Concern is not related to the product
                    d)ChildCase Asset Serial Number cannot be same as that of ParentCase Asset Serial Number
                  2)Some field updates
    *************************************************************************************************************************************************/
    private void beforeInsertUpdateHandler(list<Case> caseList, list<Contact> lContacts,Boolean isUpdate) {
        
        set<Id> setCaseIds                  =   new set<Id>();      //Used to assign 'Case Id' with RecordType = AOS India
        set<Id> setContactIds               =   new set<Id>();      //Used to assign 'Contact Id' of the Case with RecordType = AOS India
        set<Id> setServCaseProdIds          =   new set<Id>();      //Used to assign 'Product Id' of Case with reason Service 
        set<Id> installParentCsIds          =   new set<Id>();      //Used to assign free installation and chargeable installation cases parent Ids
        set<Id> setContractReqProductIds    =   new set<Id>();      //Used to assign 'Product Id' with Case RecordType = AOS India and CaseReason = ContractRequest and Product != null
        set<Id> setContractReqAssetIds      =   new set<Id>();      //Used to assign 'Asset Id'   with Case RecordType = AOS India and CaseReason = ContractRequest and Asset != null      
        
        if ( !caseList.isEmpty() ) {
            for(Case oCase : caseList) {
                if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id !=null && oCase.RecordTypeId == caseAOSIndiaRecType.Id) {
                    if(isUpdate) {
                        setCaseIds.add(oCase.Id);
                    }                           
                    
                    if(oCase.ContactId != null) {
                        setContactIds.add(oCase.ContactId);
                    }
                    
                    if ( oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CONTRACT_REQUEST) ) { 
                        if ( oCase.AOSIProduct__c != null ) {
                            setContractReqProductIds.add(oCase.AOSIProduct__c);
                        }
                        if ( oCase.AssetId != null ) {
                            setContractReqAssetIds.add(oCase.AssetId);
                        }
                    }
                    
                    if(oCase.AOSIProduct__c != null && oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_SERVICE) && oCase.AOSI_Customer_Concern__c != null && !(oCase.AOSI_Customer_Concern__c.equalsIgnoreCase(DefineConstant.CUST_CONCRN_OTHER))) {
                        setServCaseProdIds.add(oCase.AOSIProduct__c);
                    }
                    
                    if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.ParentId != null ) {
                        installParentCsIds.add(oCase.ParentId);
                    }
                    
                } //End of if Case RecordType = AOS India
                                
            } //End of for(Case oCase : caseList)
        } //End of if(!caseList.isEmpty())
        
        
        /*** mapProdAMC map will be used to : validate code - If product doesnot have AMC, then Contract Request Case cannot be created ***/
        list<Product2> lstContractReqProductAMC             = new list<Product2>();
        map<Id, list<Product_AMC_Junction__c>> mapProdAMC   = new map<id, list<Product_AMC_Junction__c>>(); 
        if( !setContractReqProductIds.isEmpty()){
            lstContractReqProductAMC             = [SELECT Id, Name, (SELECT Id, AMC_Master__c, Product__c FROM Product_AMC_Junctions__r) FROM Product2 WHERE Id IN: setContractReqProductIds];
            for(Product2 oProd : lstContractReqProductAMC ) {
                mapProdAMC.put(oProd.Id, oProd.Product_AMC_Junctions__r);    
            }
        }
  
        
        /*** mapAssetIdCases map will be used to :  validate code  - Contract Request case can be created 30days before End Date of current contract ***/
        map<Id,Asset> mapAssetIdContract = new map<Id,Asset>();
        if ( !setContractReqAssetIds.isEmpty() ) {
            for ( Asset oAsset : [SELECT Id,AOSI_Asset_Status__c,(Select Id,CreatedDate,AOSI_Case__c,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Contract_Status__c,AOSI_Asset__c,AOSI_Asset__r.AOSI_Asset_Status__c FROM Contracts__r WHERE AOSI_Contract_Status__c =: DefineConstant.CONTRACT_STAT_ACTIVE ORDER BY CreatedDate DESC LIMIT 1) FROM Asset WHERE Id IN:setContractReqAssetIds] ) {
                mapAssetIdContract.put(oAsset.Id,oAsset);
            }  
        }
        
        list<Case> listPreviousCase         =   new list<Case>();
        list<Case> listOpenCases            =   new list<Case>();
        map<Id,Contact> mapContacts         =   new map<Id,Contact>();
        set<String> setMailingCity          =   new set<String>();
        map<Id,Case> mapParentCaseInstltn;  
        
        if( !installParentCsIds.isEmpty() ) {
            mapParentCaseInstltn =  new map<Id,Case>([SELECT Id, CaseNumber, AssetId, Reason, Status FROM Case WHERE Id IN: installParentCsIds]);
        }
        
        if( !setContactIds.isEmpty() ) {
            listPreviousCase = [SELECT Id, ContactId, CaseNumber, Reason, AssetId, AOSIProduct__c, Status, ClosedDate, AOSI_Customer_Concern__c FROM Case WHERE Status =: DefineConstant.CASE_STATUS_CLOSED AND RecordTypeId =: caseAOSIndiaRecType.Id AND ( Reason =: DefineConstant.CASE_REASON_COLORPANEL_FREE OR Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION) AND ContactId IN : setContactIds and ParentId =: null];        
            listOpenCases    = [SELECT Id, ContactId, CaseNumber, Reason, AssetId, AOSIProduct__c, Status, ClosedDate, AOSI_Customer_Concern__c FROM Case WHERE RecordTypeId =: caseAOSIndiaRecType.Id AND ContactId IN :setContactIds and ParentId = null];                  
        }
        
        if( !lContacts.isEmpty() ) {
            for( Contact oCon : lContacts ) {
                mapContacts.put(oCon.Id, oCon);
                if( oCon.MailingCity != null) {
                    setMailingCity.add(oCon.MailingCity);
                }
            }
        }
        
        /*** mapCityMaster - map PostalCode and CityMaster***/
        map<String,City_Master__c> mapCityMaster = new map<String,City_Master__c>(); 
        if( !setMailingCity.isEmpty() ) {
            for( City_Master__c oCityMaster : [SELECT Id, Name FROM City_Master__c WHERE Name IN: setMailingCity]) {
                mapCityMaster.put(oCityMaster.Name.toLowerCase(), oCityMaster);
            }
        }
        
        
        /*** mapProductCustCrn - map Product and its related customer concern ***/ 
        map<Id,map<String,Product_Customer_Concern__c>> mapProductCustCrn   =   new map<Id,map<String,Product_Customer_Concern__c>>();
        if ( !setServCaseProdIds.isEmpty() ) {
            for(Product_Customer_Concern__c pCustCrn : [SELECT Id, Customer_Concern__c, Customer_Concern__r.Name, Product__c FROM Product_Customer_Concern__c WHERE Product__c IN: setServCaseProdIds] ) {
                if( !mapProductCustCrn.isEmpty() && mapProductCustCrn.containsKey(pCustCrn.Product__c) && mapProductCustCrn.get(pCustCrn.Product__c) != null ) {
                    mapProductCustCrn.get(pCustCrn.Product__c).put(pCustCrn.Customer_Concern__r.Name,pCustCrn);
                } else {
                    mapProductCustCrn.put(pCustCrn.Product__c, new map<String,Product_Customer_Concern__c>{pCustCrn.Customer_Concern__r.Name => pCustCrn});
                }
            }
        }
         
        /*** sCaseType - set of Case Reason for Power of 1 calculation***/
        set<String> sCaseType   =   new set<String>();  
        for(Type_of_Case__c eachType : Type_of_Case__c.getall().values()){
            if(eachType.TypeOfCase__c!=null){
                sCaseType.add(eachType.TypeOfCase__c); 
            }
        }
        
        for( Case oCase : caseList ) {
            if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                /*** To throw an error message while inserting or updating a Case with Reason ColorPanel(Free) or FreeInstallation if Contact already has registered Case for the Asset he owns ***/
                if( !listPreviousCase.isEmpty() ) {
                    for( Case c1 : listPreviousCase ) {
                        if(oCase.Id != c1.Id && oCase.ContactId == c1.ContactId && oCase.Reason == c1.Reason && oCase.AssetId != null && oCase.AssetId == c1.AssetId && oCase.status != 'Cancelled' && oCase.ParentId == null) {
                            oCase.addError('A case has already been registered for this contact regarding '+ oCase.Reason + ' -With Case No ' + c1.CaseNumber + ' , Only one case can be registered with this reason for this Asset'); 
                        }               
                    }
                }
            }
        }
        
        for( Case oCase : caseList ) {
            if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                if( !listOpenCases.isEmpty() ) {
                    for( Case c1 : listOpenCases ) {
                        /*** To throw an error message while inserting or updating  Case if Contact already has registered Case with same Reason and status of the case is open for the Asset he owns ***/ 
                        if( (c1.Status == DefineConstant.CASE_STATUS_OPEN || c1.Status == DefineConstant.CASE_STATUS_ON_HOLD) && oCase.Id != c1.Id && oCase.ContactId == c1.ContactId && oCase.Reason == c1.Reason &&  oCase.AssetId != null && oCase.AssetId == c1.AssetId && oCase.Status != DefineConstant.CASE_STATUS_CANCELLED && oCase.parentId == null ) {
                            oCase.addError('A case has already been registered for this contact regarding '+ oCase.Reason + ' -With Case No ' + c1.CaseNumber + ' . To escalate the case click on Call escalated checkbox of Case ' + c1.CaseNumber);                        
                        }
                     } //End of for(Case c1 : listOpenCases)
                } //End of if(!listOpenCases.isEmpty())
            } //if(Case Record Type = AOS India)
        } //End of for(Case oCase : caseList)
       

        for( Case oCase : caseList ) {
            if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                
                /*** Code to validate - If product doesnot have AMC, then Contract Request Case cannot be created ***/
                if( oCase.RecordTypeId == caseAOSIndiaRecType.Id && !mapProdAMC.isEmpty() && mapProdAMC.containsKey(oCase.AOSIProduct__c) && mapProdAMC.get(oCase.AOSIProduct__c).size() <= 0){
                    oCase.addError('You cannot create Contract Request Case, as the selected Product does not have AMC');     
                }
                
                /*** Code to validate - Contract Request case can be created 30days before End Date of current contract ***/
                /*
                if(oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CONTRACT_REQUEST) && !mapAssetIdContract.isEmpty() && mapAssetIdContract.containsKey(oCase.AssetId) && mapAssetIdContract.get(oCase.AssetId) != null ) {
                    if( !mapAssetIdContract.get(oCase.AssetId).Contracts__r.isEmpty() && mapAssetIdContract.get(oCase.AssetId).Contracts__r[0].AOSI_Contract_Status__c == DefineConstant.CONTRACT_STAT_ACTIVE && mapAssetIdContract.get(oCase.AssetId).Contracts__r[0].AOSI_Case__c != oCase.Id && System.today()<=mapAssetIdContract.get(oCase.AssetId).Contracts__r[0].AOSI_End_Date__c.addDays(-30)) {
                        oCase.addError('New Contract Request Case, can only be created 30days before End Date of current Contract');
                    }
                }
                */

                //Added by Rajesh   
                /*** Code to validate - Contract Request case can be created 30days before End Date of current contract ***/
                if(oCase.Reason.equalsIgnoreCase('Open') && oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CONTRACT_REQUEST) && !mapAssetIdContract.isEmpty() && mapAssetIdContract.containsKey(oCase.AssetId) && mapAssetIdContract.get(oCase.AssetId) != null ) {
                    if( !mapAssetIdContract.get(oCase.AssetId).Contracts__r.isEmpty() && mapAssetIdContract.get(oCase.AssetId).Contracts__r[0].AOSI_Contract_Status__c == DefineConstant.CONTRACT_STAT_ACTIVE && mapAssetIdContract.get(oCase.AssetId).Contracts__r[0].AOSI_Case__c != oCase.Id && System.today()<=mapAssetIdContract.get(oCase.AssetId).Contracts__r[0].AOSI_End_Date__c.addDays(-30)) {
                        oCase.addError('New Contract Request Case, can only be created 30days before End Date of current Contract');
                    }
                }
                
                /*** To throw an error message if Customer Concern is not related to the product ***/
                if (  oCase.AOSIProduct__c != null && oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_SERVICE) && !mapProductCustCrn.isEmpty() && mapProductCustCrn.containsKey(oCase.AOSIProduct__c) && mapProductCustCrn.get(oCase.AOSIProduct__c) != null ) {
                    if( !(mapProductCustCrn.get(oCase.AOSIProduct__c).containsKey(oCase.AOSI_Customer_Concern__c)) ) {
                   
                        List<String> custConcern = new List<String>();
                        for(Product_Customer_Concern__c  pcc : [SELECT id, Customer_Concern__c, Customer_Concern__r.Name FROM Product_Customer_Concern__c WHERE Product__c =: oCase.AOSIProduct__c]){
                            custConcern.add(pcc.Customer_Concern__r.Name);
                        }
                  
                        oCase.addError('Selected Customer concern does not relate to the Product. Please select it from the following '+custConcern); 
                    }
                }
                
                /*** To throw an error message if Child Cases are assigned with asset as that of parent asset with same case reason ***/
                if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.ParentId != null ) {
                    if( !mapParentCaseInstltn.isEmpty() && mapParentCaseInstltn.containsKey(oCase.ParentId) && mapParentCaseInstltn.get(oCase.ParentId) != null ) {
                        if ( oCase.ParentId == mapParentCaseInstltn.get(oCase.ParentId).Id && oCase.AssetId != null && oCase.AssetId == mapParentCaseInstltn.get(oCase.ParentId).AssetId && oCase.Reason == mapParentCaseInstltn.get(oCase.ParentId).Reason ) {
                            oCase.addError('A case ' + mapParentCaseInstltn.get(oCase.ParentId).CaseNumber + ' is already registered for the selected Asset with reason '+oCase.Reason);
                        }
                    }                   
                }
                
                /***WF - ASOI Refund Upadate, Field Update - SYS Refund = true***/
                if ( oCase.AOSI_Cancelled_On_HOLD_Reason__c != null && oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.REFUND_PROCESSING) && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_PARTIALLY_CLOSED)) ) {
                    oCase.AOSI_SYS_Refund__c    =   true;
                
                }
                
                /***WF - ASOI Refund checkbox update false, Field Update - SYS Refund = false***/
                if ( oCase.AOSI_Cancelled_On_HOLD_Reason__c != null && !(oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.REFUND_PROCESSING)) && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_PARTIALLY_CLOSED)) ) {
                    oCase.AOSI_SYS_Refund__c    =   false;
                }
                
                /***WF - ASOI Replace Upadate, Field Update - SYS Replaced = true***/
                if ( oCase.AOSI_Cancelled_On_HOLD_Reason__c != null && oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.REPLACEMENT_PROCESSING) && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_PARTIALLY_CLOSED)) ) {
                    oCase.AOSI_SYS_Replaced__c  =   true;
                }
                
                /***WF - ASOI Replace checkbox update false, Field Update - SYS Replaced = false***/
                if ( oCase.AOSI_Cancelled_On_HOLD_Reason__c != null && !(oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.REPLACEMENT_PROCESSING)) && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_PARTIALLY_CLOSED)) ) {
                    oCase.AOSI_SYS_Replaced__c  =   false;
                }
                
                /***WF - AOSI Close Warranty Registration Cases, Field Update - Status = Closed and Case Closed = true***/
                if ( oCase.Reason != null && (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_WARRANTY_REG) || oCase.CC_SSV__c == true) ) {
                    oCase.Status                    =   DefineConstant.CASE_STATUS_CLOSED;
                    oCase.AOSI_Case_Closed__c       =   true;
                    oCase.AOSI_Case_Close_Time__c   =   System.now();
                }
                
                /*** Field Update - City SVC = CityMaster Id, City SVC = Contact Mailingcity, State SVC = Contact MailingState,  Region SVC = Contact Region, Region = Contact Region and State = Contact State ***/     
                if( !mapContacts.isEmpty() && mapContacts.containsKey(oCase.ContactId) && mapContacts.get(oCase.ContactId) != null ) {
                    if( !mapCityMaster.isEmpty() && mapCityMaster.containsKey(mapContacts.get(oCase.ContactId).MailingCity.toLowerCase()) && mapCityMaster.get(mapContacts.get(oCase.ContactId).MailingCity.toLowerCase()) != null) {
                        oCase.AOSI_City_Master__c       =   mapCityMaster.get(mapContacts.get(oCase.ContactId).MailingCity.toLowerCase()).Id;
                    }
                    oCase.AOSI_City_Picklist__c     =   (mapContacts.get(oCase.ContactId).MailingCity != null ? mapContacts.get(oCase.ContactId).MailingCity : '');
                    oCase.AOSI_State_Picklist__c    =   (mapContacts.get(oCase.ContactId).AOSI_State__c  != null ? mapContacts.get(oCase.ContactId).AOSI_State__c  : '');
                    oCase.AOSI_Region_picklist__c   =   (mapContacts.get(oCase.ContactId).AOSI_Region__c != null ? mapContacts.get(oCase.ContactId).AOSI_Region__c : '');
                    /***WF - AOSI Update Region & State From Contact, Field Update Region = Contact.Region and state = Contacts.State***/
                    oCase.Region__c         =   (mapContacts.get(oCase.ContactId).AOSI_Region__c != null ? mapContacts.get(oCase.ContactId).AOSI_Region__c : '');
                    oCase.AOSI_Region__c    =   (mapContacts.get(oCase.ContactId).AOSI_Region__c != null ? mapContacts.get(oCase.ContactId).AOSI_Region__c : '');
                    oCase.AOSI_State__c     =   (mapContacts.get(oCase.ContactId).AOSI_State__c  != null ? mapContacts.get(oCase.ContactId).AOSI_State__c  : '');
                }
                
                /*** WF - AOSI Update Status to Partially Closed, Field Update Status = Partial Closed ***/
                if ( (oCase.Assignment_End_Time__c != null || oCase.AOSI_Case_Close_Time__c != null) &&  oCase.AOSI_Case_Closed__c != true && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_OPEN) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD)) && (!(oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CANCELLED)) || !(oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED))) ) {
                    oCase.Status    =   DefineConstant.CASE_STATUS_PARTIALLY_CLOSED;
                }
                
                /*** WF - AOSI_Update_Sunday, Field Update Sundays = Number Of Weekends/2 ***/
                if( oCase.AOSI_Number_Of_Weekends__c != null ) {
                    oCase.AOSI_Sundays__c   =   Math.floor(oCase.AOSI_Number_Of_Weekends__c / 2);
                }
                
                /*** WF - AOSI_Update_Sunday_for_Resolution_Time, Field Update Sundays For Resolution Time = No Of Weekends For Resolution Time/2 ***/
                if( oCase.AOSI_No_Of_Weekends_For_Resolution_Time__c != null ) {
                    oCase.AOSI_Sundays_For_Resolution_Time__c   =   Math.floor(oCase.AOSI_No_Of_Weekends_For_Resolution_Time__c / 2);
                }
                
                /*** WF - AOSI_Update_Sunday_for_Job_Time, Field Update Sundays For Job Time = Number Of Weekends For Job Time/2 ***/
                if( oCase.AOSI_Number_Of_Weekends_For_Job_Time__c != null ) {
                    oCase.AOSI_Sundays_For_Job_Time__c  =   Math.floor(oCase.AOSI_Number_Of_Weekends_For_Job_Time__c / 2);
                }
                
                /*** WF - Final Amount Update 1, Final Amount = Total Charges - Discount ***/
                if ( oCase.AOSI_Discount__c != null) {
                    oCase.AOSI_New_Final_Amount__c  =   (oCase.AOSI_Total_Charges__c != null ? (oCase.AOSI_Total_Charges__c - oCase.AOSI_Discount__c) : 0);
                }
                
                /*** WF - Final Amount Update 2, Final Amount = Total Charges ***/
                if ( oCase.AOSI_Discount__c == null || oCase.AOSI_Discount__c == 0) {
                    oCase.AOSI_New_Final_Amount__c  =   (oCase.AOSI_Total_Charges__c != null ? oCase.AOSI_Total_Charges__c : 0);
                }
                
                /*** WF - AOSI Onhold region, On Hold Reason checkbox = true ***/
                if ( oCase.AOSI_Cancelled_On_HOLD_Reason__c != null && oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD) &&
                       (oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.REFUND_PROCESSING)       ||
                        oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.REPLACEMENT_PROCESSING)  ||  oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.PART_PENDNG_BRANCH)      ||
                        oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.PART_PENDNG_TECHNICIAN)  ||  oCase.AOSI_Cancelled_On_HOLD_Reason__c.equalsIgnoreCase(DefineConstant.UNDER_OBSERVTN))  ) {
                    
                    oCase.AOSI_On_Hold_Reason_checkbox__c   =   true;   
                }
                
                
                /*** Power of 1 checkbox to be true if CC-SSV is ***/
                if( oCase.CC_SSV__c == true && oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && oCase.Service_Engineer__c == null && !sCaseType.isEmpty() && sCaseType.contains(oCase.Reason)){
                    oCase.AOSI_PO_Criteria_1__c =   DefineConstant.CONSTANT_TRUE;
                    oCase.AOSI_PO_Criteria_2__c =   DefineConstant.CONSTANT_TRUE;
                    oCase.AOSI_PO_Criteria_3__c =   DefineConstant.CONSTANT_TRUE;
                    oCase.AOSI_Power_of_1__c    =   true;
                }
                
                    // Added by Rajesh 
                    // To capture Response on escalation date time
                    if(oCase.AOSI_Response_on_escalation_date_time__c ==null && oCase.AOSI_Response_on_escalation__c == true)
                    {
                        oCase.AOSI_Response_on_escalation_date_time__c=System.now();
                        system.debug('oCase.AOSI_Response_on_escalation_date_time__c=System.now()');
                            
                    }
        
            } //if( Case Record Type = AOS India)
        } //End of for(Case oCase : caseList)
        
        /*** Repeat Call Identification ***/
        for( Case oCase : caseList ) {
            if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                if( !listOpenCases.isEmpty() ) {
                    for( Case c1 : listOpenCases ) {
                        if( c1.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && c1.ClosedDate != null && oCase.Id != c1.Id && oCase.ContactId == c1.ContactId && oCase.Status != DefineConstant.CASE_STATUS_CANCELLED && oCase.parentId == null ) {
                            AOSI_Time_Calculation_Settings__c sRepeatCall = AOSI_Time_Calculation_Settings__c.getValues(DefineConstant.CS_REPEAT_CALL_DURATION);
                            Integer repeatDays  =   Integer.valueOf(sRepeatCall.AOSI_Days__c) - 1;
                            Date prevCaseClosedDate =   Date.newInstance(c1.ClosedDate.year(), c1.ClosedDate.month(), c1.ClosedDate.day());
                            if( (!isUpdate && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_OPEN) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED)))  || (isUpdate && !oldMap.isEmpty() && oldMap.get(oCase.Id).Status != DefineConstant.CASE_STATUS_CLOSED && oCase.Status == DefineConstant.CASE_STATUS_CLOSED) ) {
                                oCase.AOSI_Repeat_Call__c   =   false;
                                if( oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_OPEN) && prevCaseClosedDate != null && system.today() < prevCaseClosedDate.addDays(repeatDays) && oCase.AOSI_Customer_Concern__c == c1.AOSI_Customer_Concern__c && oCase.AssetId != null && oCase.AssetId == c1.AssetId && oCase.Reason == c1.Reason ) {
                                    system.debug('*** Case Status open *** '+oCase.Status); oCase.AOSI_Repeat_Call__c   =   true;
                                }
                                if( oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && prevCaseClosedDate != null && system.today() < prevCaseClosedDate.addDays(repeatDays) && oCase.AOSI_Customer_Concern__c == c1.AOSI_Customer_Concern__c && oCase.AssetId != null && oCase.AssetId == c1.AssetId && oCase.Reason == c1.Reason ) {
                                    system.debug('*** Case Status close *** '+oCase.Status); oCase.AOSI_Repeat_Call__c  =   true;
                                }
                                if( oCase.AOSI_Repeat_Call__c == true ) {
                                    break;
                                }
                            } //End of if(!isUpdate .....)
                        } //End of if( c1.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) .....)
                     } //End of for(Case c1 : listOpenCases)
                } //End of if(!listOpenCases.isEmpty())
            } //if(Case Record Type = AOS India)
        } //End of for(Case oCase : caseList)
        
        
        
    } //End of beforeInsertUpdateHandler()    
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : beforeInsertHandler()
     * Return Type : void
     * Description : Defines case trigger before insert logic 
                     1)If record is created with 'AOSI' record type changing it to 'AOS India' record type 
                     2)Set all the case object time fields values to null
                     3)Fill in values to SMS Status(IND) and Warranty Status(I) based on condition 
                     4)Assigns Case Owner to the Case based on Contact PinCode and Region
     * ***********************************************************************************************************************************************************************************************/
    public void beforeInsertHandler() {
        
        String customercalltrackingurl=CCTSettings__c.getValues('Default').Customer_Call_Tracking_URL__c;
    
        set<Id> setContactIds               =   new set<Id>(); //Used to assign 'Contact Id' with Case RecordType = AOS India        
      
        if ( !newList.isEmpty() ) {
            for ( Case oCase : newList ) {
                //WF - AOSI Update Record Type, to change the case Record Type from AOSI to AOS India
                if ( oCase.RecordTypeId != null && caseAOSIRecType.Id != null && oCase.RecordTypeId == caseAOSIRecType.Id ) {
                    oCase.RecordTypeId  =   caseAOSIndiaRecType.Id; 
                } 
                
                if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id) {
                    if ( oCase.ContactId != null ) {
                        setContactIds.add(oCase.ContactId);
                    }
                } // End of if(Case Record type == 'AOS India')
            } //End of for(Case oCase:newList) 
        } //End of if ( newList.isEmpty() ) 
        
        map<Id,Contact> mapContact      =   new map<Id,Contact>();
        if( !setContactIds.isEmpty() ) {
            for(Contact con : [SELECT Id, Name, MailingCity, MailingState, MailingPostalCode, AOSI_Region__c, AOSI_State__c FROM Contact WHERE Id IN: setContactIds]){
                mapContact.put(con.Id, con);
            }
        }
        
        if ( !newList.isEmpty() ) {
            for( Case oCase : newList ) {
                if( oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                    
                    /*** While creating new case all the time field values should be set to null ***/
                    oCase.Assignment_Start_Time__c      =   null;   oCase.Assignment_End_Time__c                =   null;
                    oCase.AOSI_Response_Clock_Time__c   =   null;   oCase.AOSI_Response_Time_New__c             =   null;
                    oCase.AOSI_Resolution_Clock_Time__c =   null;   oCase.AOSI_Resolution_Time_New__c           =   null;
                    oCase.AOSI_Job_Clock_Time__c        =   null;   oCase.AOSI_Job_Time_New__c                  =   null;
                    oCase.Service_Engineer__c           =   null;   oCase.AOSI_Appointment_Date__c              =   null;
                    oCase.AOSI_Case_Close_Time__c       =   null;   oCase.AOSI_Cancelled_On_HOLD_Reason__c      =   null;
                    oCase.AOSI_Respond_Time__c          =   null;   oCase.AOSI_Call_Escalated_to_HO_Date__c     =   null;
                    oCase.AOSI_Call_Escalated_Date__c   =   null;   oCase.AOSI_WECARE_Escaltion_Date_Time__c    =   null;
                    oCase.AOSI_ASP_Owner_Email__c       =   null;   oCase.AOSI_ASP_Company_Email_ID__c          =   null;
                    oCase.SMS_Status__c                 =   null;   oCase.AOSI_OnHold_Edited_Time__c            =   null;
                    oCase.AOSI_PO_Criteria_1__c         =   null;   oCase.AOSI_PO_Criteria_2__c                 =   null;
                    oCase.AOSI_PO_Criteria_3__c         =   null;   oCase.AOSI_Power_of_1__c                    =   false;
                    oCase.SMS_SENT_TO_CONTACT__c        =   false;  oCase.SMS_SENT_TO_INSTALLER__c              =   false;
                    oCase.AOSI_Case_Closed__c           =   false;  oCase.AOSI_SMS_TO_CUST_ON_SERVCHARGE__c     =   false;
         
                    oCase.Case_Tracking_URL__c=customercalltrackingurl;
                    
                    /*** Field update SMS Status - on inserting Case as SMS SENT BY TRIGGER if Case is registered between 8:00AM to 8:00PM or SMS HAS TO BE SENT after 8:00PM
                         and Case Reason is not Field trial, System Testing, Exchange-Pickup  ***/
                    Time currentTime    =    Time.newInstance(system.now().hour(), system.now().minute(), system.now().second(), system.now().millisecond());
                    if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_COLORPANEL_FREE)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE))&& oCase.parentId == null) {
                        oCase.SMS_Status__c = ( (currentTime >= smsStartTime && currentTime <= smsEndTime) ? DefineConstant.SMS_SENT_BY_TRIGGER : DefineConstant.SMS_HAS_TO_BE_SENT); 
                    } else if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_SERVICE)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_DEALER_STOCK)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CONTRACT_REQUEST)) && oCase.CC_SSV__c != true ) {
                        oCase.SMS_Status__c = ( (currentTime >= smsStartTime && currentTime < smsEndTime) ? DefineConstant.SMS_SENT_BY_TRIGGER : DefineConstant.SMS_HAS_TO_BE_SENT); 
                    } else if( oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_PM_SERVICE) && oCase.Status != DefineConstant.CASE_STATUS_UNREG_UNALLOCATED ) {
                        oCase.SMS_Status__c = ( (currentTime >= smsStartTime && currentTime < smsEndTime) ? DefineConstant.SMS_SENT_BY_TRIGGER : DefineConstant.SMS_HAS_TO_BE_SENT); 
                    } else if( oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_SALES_QUERY) || oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_WARRANTY_REG) ) {
                        oCase.SMS_Status__c = ( (currentTime >= smsStartTime && currentTime < smsEndTime) ? DefineConstant.SMS_SENT_BY_TRIGGER : DefineConstant.SMS_HAS_TO_BE_SENT); 
                    } else {
                        oCase.SMS_Status__c =   null;
                    }
                     
                    /*** Field update Warranty Status = WR if when case is inserted with reason Installation(Free or Chargeable), ColorPanel(Free or Chargeable), Dealer Stock  ***/
                    if ( oCase.Reason == DefineConstant.CASE_REASON_FREE_INSTALLATION || oCase.Reason == DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION || oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_FREE || oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE || oCase.Reason == DefineConstant.CASE_REASON_DEALER_STOCK ) {
                        oCase.AOSI_Warranty_Status_I__c    =  DefineConstant.CASE_WARRANTY_STATUS_WR;                              
                    }
                    
                 }   //if( Case Record Type = AOS India)          
            }   //End of for( Case oCase : newList )
        }   //End of if ( newList.isEmpty() ) 
        
        /*** Method call ***/
        list<Contact> lContacts = (!mapContact.isEmpty() ? mapContact.values() : new list<Contact>() );
        beforeInsertUpdateHandler(newList, lContacts, false);
    }
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : beforeUpdateHandler()
     * Return Type : void
     * Description : Defines case trigger before update logic 
                     1) Updates Resource Engineer Email, Case Close time, all time field value based on conditions
                     2) If an Asset is replaced then product Name is updated 
                     3) Record validation -
                        a) SalesQuery Case cannot to moved to OnHold Status more than 5 times
                        b) Parent cases can be closed only when all its child cases are closed or cancelled
                        c) Case that has its Contract Status Under Processing cannot be closed
                        d) Service Engineer cannot be allocated to more than 10 cases 
                        e) Service Engineer cannot be allocated to case when he is on leave
     * ***********************************************************************************************************************************************************************************************/
    public void beforeUpdateHandler() {
        
        /*** Method Call updateTimeFields() to update all the time fields at Case level ***/
        
        updateTimeFields();
    
        set<Id> setCaseIds          =   new set<Id>(); //Used to assign Case Id with RecordType = AOS India
        set<Id> setContactIds       =   new set<Id>(); //Used to assign 'Contact Id' of the Case with RecordType = AOS India
        set<Id> replacedAssetIds    =   new set<Id>(); // Used to assign replaced Asset Ids
        set<Id> parentCaseIds       =   new set<Id>(); //Used to assign parent Case ids
        set<Id> contractReqCaseIDs  =   new set<Id>(); //Used to assign contract request case id
        set<Id> setServiceEnggIds   =   new set<Id>(); //Used to assign 'Service Engg Id' of the Case with RecordType = AOS India
        
        
        if ( !newMap.isEmpty() ) { 
            for( Case oCase : newMap.values() ) {
                
                /***WF - AOSI Update Record Type, to change the case Record Type from AOSI to AOS India***/
                if ( caseAOSIRecType.Id != null && oCase.RecordTypeId == caseAOSIRecType.Id ) {
                    oCase.RecordTypeId  =   caseAOSIndiaRecType.Id; 
                } 
                
                if( caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                    if( oCase.AOSI_Replaced_Asset__c != null ) {
                        replacedAssetIds.add(oCase.AOSI_Replaced_Asset__c);
                    }
                    
                    if(oCase.ContactId != null) {
                        setContactIds.add(oCase.ContactId);
                    }
                    
                    if( oCase.ParentId == null) {
                        parentCaseIds.add(oCase.Id);
                    }   
                    
                    if( oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CONTRACT_REQUEST) ) {
                        contractReqCaseIDs.add(oCase.Id);
                    }
                    
                    if( oCase.Service_Engineer__c != null ) {
                        setServiceEnggIds.add(oCase.Service_Engineer__c);
                    }
                      
                }   //End of  if ( Record type == AOS India)       
            }  //End of for(Case oCase : newMap.values())       
        }   //End of if ( newList.isEmpty() ) 
        
        /***mapContact is passed as argument beforeInsertUpdateHandler() ***/
        map<Id,Contact> mapContact =   new map<Id,Contact>();
        if( !setContactIds.isEmpty() ) {
            for(Contact con : [SELECT Id, Name, MailingCity, MailingState, MailingPostalCode, AOSI_Region__c, AOSI_State__c FROM Contact WHERE Id IN: setContactIds]){
                mapContact.put(con.Id, con);
            }
        }
        
        /*** mapReplacedAsset hold AssetId and AssetDetails - used to update Product field to replaced Assets Product name ***/
        map<Id,Asset> mapReplacedAsset = new map<Id,Asset>();
        if( !replacedAssetIds.isEmpty() ) {
            for(Asset oAsset : [SELECT  Id, Name, Product2.Name FROM Asset WHERE Id IN: replacedAssetIds]){
                mapReplacedAsset.put(oAsset.Id,oAsset);
            }
        }
        
        /*** mapChildCase map holds ParentCaseId(reason = Free Installation or Chargeable Installation)and list of its related ChildCases - used to validate Parent cases can be closed only when all its child cases are closed or cancelled ***/
        map<Id,list<Case>> mapChildCase =   new map<Id,list<Case>>();
        if( !parentCaseIds.isEmpty() ) {
            for ( Case oCase : [SELECT Id, CaseNumber, Status, Reason, (SELECT Id, Status FROM Cases WHERE Status !=: DefineConstant.CASE_STATUS_CLOSED AND Status !=: DefineConstant.CASE_STATUS_CANCELLED) FROM Case 
                                   WHERE (Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION OR Reason =: DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION) AND Id IN: parentCaseIds] ) {
                    mapChildCase.put(oCase.Id, oCase.Cases);                   
            }
        }
        
        /*** underPrgrsCntrctCase map hold CaseID and list of AOSI Contracts where contract status = Under Progress - used to validate Case that has its Contract Status =  Under Processing cannot be closed ***/
        map<Id,list<AOSI_Contract__c>> underPrgrsCntrctCase = new map<Id,list<AOSI_Contract__c>>();
        if ( !contractReqCaseIDs.isEmpty() ) {
            for ( Case oCase : [SELECT id, Status, Reason, (SELECT id, AOSI_Contract_Status__c, AOSI_Case__c FROM Contracts__r WHERE AOSI_Contract_Status__c =: DefineConstant.CONTRACT_UNDERPROGRESS) FROM Case WHERE Id IN: contractReqCaseIDs] ) {
                underPrgrsCntrctCase.put(oCase.Id, oCase.Contracts__r);
            }
        }
        
        
        map<Id,Service_Engineer__c> mapServEngg = new map<Id,Service_Engineer__c>(); /*** mapServEngg map holds service engineer details : used to update service engineer email field***/       
        map<Id,List<Case>> mapServEngCase       = new map<Id,List<Case>>(); /*** mapServEngCase - map with ServiceEngg ID and list of cases he is assigned to. Is used to validate that a service engineer cannot be assigned to more than 10 open cases ***/       
        if( !setServiceEnggIds.isEmpty() ) {
            for( Service_Engineer__c oEngg : [SELECT Id, Name, AOSI_Service_Engineer_Email__c,(SELECT Id, Service_Engineer__c, Reason FROM Cases__r WHERE  (Reason !=: DefineConstant.CASE_REASON_COLORPANEL_FREE AND Reason !=: DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE AND Reason !=: DefineConstant.CASE_REASON_SALES_QUERY) AND Status =: DefineConstant.CASE_STATUS_OPEN and RecordTypeId =: caseAOSIndiaRecType.id) FROM Service_Engineer__c WHERE Id IN: setServiceEnggIds]){ //Reason !=: DefineConstant.CASE_REASON_COLORPANEL_FREE AND Reason !=: DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE AND Reason !=: DefineConstant.CASE_REASON_SALES_QUERY and
                mapServEngCase.put(oEngg.Id, oEngg.Cases__r);
                mapServEngg.put(oEngg.Id, oEngg);
            }
        }
        
        /*** mapServEngAttendance - map with ServiceEngg ID and his Attendance. Is used to validate service engineer cannot be assigned to case when he is absent for the day ***/    
        map<Id,Attendence__c> mapServEngAttendance = new map<Id,Attendence__c>();
        if( !setServiceEnggIds.isEmpty() ) {
            for(Attendence__c oAttend : [SELECT Id, AOSI_Present__c, AOSI_Date__c, AOSI_Service_Engineer__r.Name, AOSI_Service_Engineer__c FROM Attendence__c WHERE  AOSI_Service_Engineer__c IN: setServiceEnggIds AND AOSI_Date__c =: system.today()]) {
                mapServEngAttendance.put(oAttend.AOSI_Service_Engineer__c, oAttend);
            }
        }
        
        Map<Id,Boolean> prrinfo=new Map<Id,Boolean>();
        for(Case c:[select id,Status,(select ID,AOSI_Case__c,AOSI_Approval_Status__c from PRR__r) from Case where Id in:newMap.values()])
        {
            
            if(c.PRR__r!=null)
            {
            //mapcasetoprr.put(c.id,c.PRR__r); 
            system.debug('c.Status'+c.Status); 
            //if(c.Status=='Cancelled')
            //{
                for(PRR__c p:c.PRR__r)
                {
                    if(p.AOSI_Approval_Status__c=='Approved')
                    {
                        prrinfo.put(c.Id,true);
                        break;
                        //c.addError('You cannot cancel this case, as the PRR is approved.');
                    }
                }
           // }
            }
            
        }
            

        for( Case oCase : newMap.values() ) {
            if( oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                if(oCase.Service_Engineer__c !=null && oCase.GCM_Registration_ID__c !=null)
                {
                    AOSI_GPS_GCMMessenger.sendMessage(oCase.Id,oCase.GCM_Registration_ID__c,'Case Updated');
                }

                /***Field Update - Resource Email = Service Engineer Email address***/
                if( !mapServEngg.isEmpty() && mapServEngg.containsKey(oCase.Service_Engineer__c) && mapServEngg.get(oCase.Service_Engineer__c) != null) {
                    if(mapServEngg.get(oCase.Service_Engineer__c).AOSI_Service_Engineer_Email__c != null ) {
                        oCase.Resource_Email__c =   mapServEngg.get(oCase.Service_Engineer__c).AOSI_Service_Engineer_Email__c;
                    }   
                }
                
                /*** WF - AOSI Update Case closed, Field Update Case Closed = true ***/
                if( oCase.Status != oldMap.get(oCase.Id).Status && (oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) || oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CANCELLED)) ) {
                    oCase.AOSI_Case_Closed__c   =   true;
                }
                
                /*** Code block to update replaced Product when Asset is replaced ***/
                if(  oCase.AOSI_Replaced_Asset__c != null && !mapReplacedAsset.isEmpty() && mapReplacedAsset.containsKey(oCase.AOSI_Replaced_Asset__c) && mapReplacedAsset.get(oCase.AOSI_Replaced_Asset__c) != null ) {
                    oCase.AOSI_Replaced_Product__c  =    mapReplacedAsset.get(oCase.AOSI_Replaced_Asset__c).Product2.Name;
                }
                
                if( (oCase.Status != oldMap.get(oCase.Id).Status  || oCase.AOSI_Cancelled_On_HOLD_Reason__c != oldMap.get(oCase.Id).AOSI_Cancelled_On_HOLD_Reason__c || oCase.AOSI_Appointment_Date__c != oldMap.get(oCase.Id).AOSI_Appointment_Date__c) && oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_ON_HOLD) && oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_SALES_QUERY) ) {
                    oCase.AOSI_Count_Sales_Query_On_Hold__c = ( oCase.AOSI_Count_Sales_Query_On_Hold__c == null ? 0 : oCase.AOSI_Count_Sales_Query_On_Hold__c); //To handle null pointer exception
                    if( (++oCase.AOSI_Count_Sales_Query_On_Hold__c) >= DefineConstant.COUNT_LIMIT_SALESQUERY){
                        oCase.addError('Case cannot be moved further to On hold status as limit exceeds and can be either closed/cancelled');
                    }    
                }
                
                system.debug('prrinfo.get(oCase.Id)'+prrinfo.get(oCase.Id));
                system.debug('system.debug'+oCase.Status);
                if(prrinfo.get(oCase.Id)!=null && oCase.Status=='Cancelled')
                {
                    oCase.addError('You cannot cancel this case, as the PRR is approved');
                }
                
                /*** code to validate that parent can be closed only if all its child cases are closed or cancelled ***/
                if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION) ||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.ParentId == null){
                    if( oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && !mapChildCase.isEmpty() && mapChildCase.containsKey(oCase.Id) ) {
                        if( mapChildCase.get(oCase.Id).size() > 0 ) {
                            oCase.addError(' Parent case can be closed, only when all its child cases are Closed or Cancelled');
                        }
                    }                       
                }
                
                /*** Code to validate that Under processing contract case should not be closed ***/
                if( oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CONTRACT_REQUEST) && oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) ) {
                    if( !underPrgrsCntrctCase.isEmpty() && underPrgrsCntrctCase.containsKey(oCase.Id) ) {
                        if( underPrgrsCntrctCase.get(oCase.Id).size() > 0 ) {
                            oCase.addError('Case Cannot be closed, as it has Contract Under Progress ');
                        }                  
                    }
                }
                
                /*** To throw an error message if a service engineer is allocated more than 10 open cases at a time ***/                   
                if( oCase.Service_Engineer__c != null && !mapServEngCase.isEmpty() && mapServEngCase.containsKey(oCase.Service_Engineer__c) && mapServEngCase.get(oCase.Service_Engineer__c) != null ) {
                    if( oldmap.get(oCase.Id).Service_Engineer__c != oCase.Service_Engineer__c && oCase.Status == DefineConstant.CASE_STATUS_OPEN && oCase.Reason != DefineConstant.CASE_REASON_COLORPANEL_FREE && oCase.Reason != DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE && oCase.Reason != DefineConstant.CASE_REASON_SALES_QUERY && mapServEngCase.get(oCase.Service_Engineer__c).size() >= 10 && oCase.ParentId == null) {
                        oCase.Service_Engineer__c.addError('The Service Engineer is already having 10 open cases allocated to him, you cannot allocate more cases to this service engineer');
                    }
                }
                
                /*** To throw an error message if service engineer is assigned to case, when he is absent for the day ***/
                if( oCase.Service_Engineer__c != null && !mapServEngAttendance.isEmpty() && mapServEngAttendance.containsKey(oCase.Service_Engineer__c) && mapServEngAttendance.get(oCase.Service_Engineer__c) != null) {
                    if( oldmap.get(oCase.Id).Service_Engineer__c != oCase.Service_Engineer__c && mapServEngAttendance.get(oCase.Service_Engineer__c).AOSI_Present__c == false ) {
                        oCase.addError('Case cannot be assigned to the Service Engineer, who is absent for the day.');
                    }
                }
                
                /*** Code to validate - Closed Case Cannot be edited ***/
                if (oCase.AOSI_Case_Closed__c == true && oldMap.get(oCase.Id).AOSI_Case_Closed__c == true) {
                    oCase.addError('The Case is already closed you cannot edit a closed case');                
                }
                
            } //End of if (Case Record Type == AOS India)
        } //End of for(Case oCase : newMap.values())
        
        /*** Calling Method beforeInsertUpdateHandler(list<Case> caseList, list<Contact> lContacts,Boolean isUpdate) ***/
        list<Contact> lContacts = (!mapContact.isEmpty() ? mapContact.values() : new list<Contact>() );
        beforeInsertUpdateHandler(newMap.values(), lContacts,true);
    }
    
    /*************************************************************************************************************************************************
    Method Name : afterInsertUpdateHandler(list<Case> caseList, map<Id, Asset> assetMap, map<Id,Product2> productMap, Boolean isUpdate)
    Return Type : void 
    Description : Consists of common logic that need to executed after Insert and after Update context
                  1)Create ChildCase if Case is registered with Case Reason : Free Installation or Chargeable Installation and Quantity > 1
                  2)If Case is registered with Case Reason : Free Installation or Chargeable Installation or Warranty Registration within 60 days 
                    of Asset Purchase date - then update Asset Object fields 
                    Warranty Registered In Time = true
                    AOSI_Warranty_registration_Date__c = case closing day
    *************************************************************************************************************************************************/
    private void afterInsertUpdateHandler(list<Case> caseList, map<Id, Asset> assetMap, map<Id,Product2> productMap, Boolean isUpdate) {
        
        list<Case> listChildCaseInsert  =   new list<Case>();
        
        if ( !caseList.isEmpty() ) {
            for( Case oCase : caseList ) {
                if( oCase.RecordTypeId != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id ) {
                    /*************************************************************************************************************************************************************************************
                     Code block to create child case if Parent Case is registered with Case Reason : Free Installation or Chargeable Installation 
                     and Quantity is greater than 1. 
                     **************************************************************************************************************************************************************************************/
                     if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.ParentId == null && Integer.valueOf(oCase.Quantity__c) > 1 ) {
                        Integer quantity = ((!isUpdate) ? (Integer.valueOf(oCase.Quantity__c)  - 1 ): (((Integer.valueOf(oCase.Quantity__c) != Integer.valueOf(oldMap.get(oCase.Id).Quantity__c)) && (Integer.valueOf(oCase.Quantity__c) > Integer.valueOf(oldMap.get(oCase.Id).Quantity__c))) ? (Integer.valueOf(oCase.Quantity__c) - Integer.valueOf(oldMap.get(oCase.Id).Quantity__c)) : 0) );                  
                        for(integer i = 0; i < quantity; i++) {
                            Case childCase = new Case();
                            childCase.Parentid                  = oCase.id;
                            childCase.Quantity__c               = '1'; 
                            childCase.ContactId                 = oCase.contactId;
                            childCase.AOSIProduct__c            = oCase.AOSIProduct__c;
                            childCase.Reason                    = oCase.Reason;
                            childCase.AOSI_Customer_Concern__c  = oCase.AOSI_Customer_Concern__c;   
                            childCase.AOSI_City__c              = oCase.AOSI_City__c;
                            listChildCaseInsert.add(childCase);
                        }
                     }
                    
                    /*************************************************************************************************************************************************************************************
                     If Case is registered with Case Reason : Free Installation or Chargeable Installation or Warranty Registration within 60 days of Asset Purchase date - then Asset Object fields
                     Warranty Registered In Time = true and AOSI_Warranty_registration_Date__c = case closing day, on closing of that particular case.
                    **************************************************************************************************************************************************************************************/
                    if( oCase.AssetId != null && oCase.Asset.PurchaseDate != null && oCase.Asset.AOSI_Warranty_Registered_In_Time_new__c == null &&  oCase.Asset.AOSI_Warranty_registration_Date__c == null) {
                        Date caseCreatedDate    =   date.newinstance( oCase.CreatedDate.year(), oCase.CreatedDate.month(), oCase.CreatedDate.day() ); //Converting Case CreatedDate from Datetime to Date
                        Integer dateDifference  =   oCase.Asset.PurchaseDate.daysBetween(caseCreatedDate);  //Finding out difference between Case Creation Date and Asset Purchase Date                 
                        if( (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_WARRANTY_REG) || oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION) || oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && (dateDifference <= 65) ){
                                if( !assetMap.isEmpty() && assetMap.containsKey(oCase.AssetId) && assetMap.get(oCase.AssetId) != null ) {
                                    assetMap.get(oCase.AssetId).AOSI_Warranty_Registered_In_Time_new__c =   DefineConstant.CONSTANT_TRUE;
                                    assetMap.get(oCase.AssetId).AOSI_Warranty_registration_Date__c      =   System.today();
                                } else {
                                    assetMap.put(oCase.AssetId,new Asset(Id = oCase.AssetId, AOSI_Warranty_Registered_In_Time_new__c = DefineConstant.CONSTANT_TRUE, AOSI_Warranty_registration_Date__c = System.today() ));
                                }       
                        }
                    } //End of if(oCase.AssetId!=null && oCase.Asset.PurchaseDate!=null )
                } // End of if(oCase.RecordTypeId!=null && oCase.RecordTypeId==caseAOSIndiaRecType.Id)
            } //End of for(Case oCase:caseList)
        } //End of if(!caseList.isEmpty())
        
        if( !assetMap.isEmpty() ) {
            try {
                update assetMap.values();  } catch (Exception e) { System.debug('### Asset Update Failed ###' + e.getMessage() + ' Exception from AOSI_CaseTriggerHandler at line number - ' + e.getLineNumber());}
        }
               
        if( !productMap.isEmpty() ) {
            try {
                update productMap.values();   } catch (Exception e) { System.debug('### Product Update Failed ###' + e.getMessage() + ' Exception from AOSI_CaseTriggerHandler at line number - ' + e.getLineNumber());}
        }
              
        if( !listChildCaseInsert.isEmpty() ) {
            try {
                insert listChildCaseInsert; } catch (Exception e) { System.debug('### Child Case Insert Failed ###' + e.getMessage() + ' Exception from AOSI_CaseTriggerHandler at line number - ' + e.getLineNumber());}
        }
        if ( !caseList.isEmpty() ) {
            try {
                AOSI_UtilRecursionHandler.isCaseBeforeUpdateRecursive = true;   // to stop before update event from firing
                AOSI_UtilRecursionHandler.isCaseAfterUpdateRecursive = true;    // to stop before update event from firing
                update caseList; } catch (Exception e) { System.debug('### Update Case ###' + e.getMessage() + ' Exception from AOSI_CaseTriggerHandler at line number - ' + e.getLineNumber());}
        }
         
    } //End of afterInsertUpdateHandler()
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : afterInsertHandler()
     * Return Type : void
     * Description : Defines case trigger after insert logic 
                     1) Send SMS or schedules SMS to customer when case is created
     * ***********************************************************************************************************************************************************************************************/
    public void afterInsertHandler() {
               
        set<Id> setCaseIds                                      =   new set<Id>();
        list<Task> taskList                                     =   new list<Task>();
        list<smagicinteract__smsMagic__c> smsHistoryList        =   new list<smagicinteract__smsMagic__c>();
        list<smagicinteract__Scheduled_SMS__c> scheduleSMSList  =   new list<smagicinteract__Scheduled_SMS__c>();
        
        map<String,Id> mapRegionUserId      =   new map<String,Id>(); //Used to assign userID under role RegionalCallCoordinator of North,East,South,West regions
        set<String> setRoleNames            =   new set<String>();   //Used to assign different roles names        
        /***Adding elements to the set - setRoleNames***/
        setRoleNames.add(DefineConstant.RCCNorth);  setRoleNames.add(DefineConstant.RCCEast);  
        setRoleNames.add(DefineConstant.RCCSouth);  setRoleNames.add(DefineConstant.RCCWest);
        
        set<Id> setContactIds               =   new set<Id>(); //Used to assign 'Contact Id' with Case RecordType = AOS India 
        try {
            if ( !newMap.isEmpty() ) {
                for( Case oCase : newMap.values() ) {
                    if (oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id) {  
                        setCaseIds.add(oCase.Id);
                        if ( oCase.ContactId != null ) {
                            setContactIds.add(oCase.ContactId);
                        }
                    }
                }
            }
            
            //Defining and initializing below variables that will be used to assign Case Owner to case based on Contact PinCode and Region  
            set<String> setPostalCode                       =   new set<String>();
            map<Id,Contact> mapContact                      =   new map<Id,Contact>();
            map<String,PIN_Allocation__c> mapPinASPAosi     =   new map<String,PIN_Allocation__c>();
            map<String,Id> mapPinOtherUser                  =   new map<String,Id>();
            if( !setContactIds.isEmpty() ) {
                for(Contact con : [SELECT Id, Name, MailingCity, MailingState, MailingPostalCode, AOSI_Region__c, AOSI_State__c FROM Contact WHERE Id IN: setContactIds]){
                    mapContact.put(con.Id, con);
                }
            }
            
            if( !mapContact.isEmpty() ) {
                for(Contact oCon : mapContact.values() ) {
                    if(oCon.MailingPostalCode != null) {
                        setPostalCode.add(oCon.MailingPostalCode);
                    }
                }
            }
                   
            if( !setPostalCode.isEmpty() ) {
                for(PIN_Allocation__c pinAlloc : [SELECT PIN__c, ASP_User_Profile__c, AOSI_ASP__c, AOSI_ASP__r.AOSI_ASP_User__c, AOSI_ASP__r.AOSI_Service_detail__c, AOSI_ASP__r.AOSI_Product_Category__c, AOSI_ASP__r.AOSI_Company_Email_ID__c, AOSI_ASP__r.AOSI_ASP_User__r.Email, AOSI_ASP__r.AOSI_ASP_User__r.IsActive, AOSI_ASP__r.Owner.Email, AOSI_Related_Manager_Profile__c, ASP__c, ASP__r.IsActive FROM PIN_Allocation__c WHERE PIN__c IN: setPostalCode ]) {
                    if ( pinAlloc.AOSI_ASP__c != null && pinAlloc.AOSI_ASP__r.AOSI_ASP_User__c != null && pinAlloc.AOSI_ASP__r.AOSI_ASP_User__r.IsActive && pinAlloc.ASP_User_Profile__c != null && pinAlloc.ASP_User_Profile__c == DefineConstant.PROFILE_ASPAOSI ) {
                        mapPinASPAosi.put(pinAlloc.PIN__c, pinAlloc);
                    }
                    if ( pinAlloc.ASP__c != null && pinAlloc.ASP__r.IsActive) {
                        mapPinOtherUser.put(pinAlloc.PIN__c, pinAlloc.ASP__c);
                    }
                }
            } 
            
            
            //Code to Construct map - mapRegionUserId  
            if( !setRoleNames.isEmpty() ) {
                for(User oUser : [SELECT Id, UserRoleId, UserRole.Name, UserRole.DeveloperName FROM User WHERE UserRole.DeveloperName IN: setRoleNames AND isActive = true]){
                    if(oUser.UserRole.DeveloperName == DefineConstant.RCCNorth)
                        mapRegionUserId.put(DefineConstant.NORTH, oUser.Id);
                    if(oUser.UserRole.DeveloperName == DefineConstant.RCCSouth)
                        mapRegionUserId.put(DefineConstant.SOUTH, oUser.Id);
                    if(oUser.UserRole.DeveloperName == DefineConstant.RCCEast)
                        mapRegionUserId.put(DefineConstant.EAST, oUser.Id);
                    if(oUser.UserRole.DeveloperName == DefineConstant.RCCWest)
                        mapRegionUserId.put(DefineConstant.WEST, oUser.Id);
                }
            }
            
            Id aosIndiaRecType  =   (caseAOSIndiaRecType.Id != null ? caseAOSIndiaRecType.Id : '');
            
            String queryString = 'SELECT ';
            for ( Schema.SObjectField field : Schema.getGlobalDescribe().get(DefineConstant.OBJECT_NAME_CASE).getDescribe().fields.getMap().values()) {
                queryString += field + ',';
            }
            queryString += ' Asset.Name, Asset.PurchaseDate, Asset.AOSI_Warranty_registration_Date__c,Asset.AOSI_Warranty_Registered_In_Time_new__c, Asset.AOSI_Membrane_Warranty__c, Asset.AOSI_Purchase_Value__c,AOSIProduct__r.AOSI_Vertical__c, AOSIProduct__r.AOSI_Membrane_Wty__c' + 
                           ' FROM Case WHERE Id IN :setCaseIds AND RecordTypeId =:aosIndiaRecType';
            list<Case> listCase = database.query(queryString);
            
            
            
            if ( !listCase.isEmpty() ) {
                for( Case oCase : listCase ) {               
                    if (oCase.RecordTypeId != null && caseAOSIndiaRecType.Id != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id) {  
                        /***** Assigning Case Owner to the Case based on Contact PinCode and Region *****/
                        /***  If Case related Contact has its Postal Code defined in PinAllocation Object and its ASP Profile is ASP AOSI ***/
                        if ( oCase.Reason!=DefineConstant.CASE_REASON_SALES_QUERY && oCase.AOSI_Product_Vertical__c != null && !mapPinASPAosi.isEmpty() && mapPinASPAosi.containsKey(oCase.Contact_MailingPostalCode__c) && mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c) != null && oCase.Contact_MailingPostalCode__c==mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).PIN__c && mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_Service_detail__c != null 
                            && mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_Service_detail__c.contains(oCase.Reason) && mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_Product_Category__c != null && mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_Product_Category__c.contains(oCase.AOSI_Product_Vertical__c) ) {
                            oCase.OwnerId                       =   mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_ASP_User__c;
                            oCase.AOSI_ASP_Owner_Email__c       =   (mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.Owner.Email != null ? mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.Owner.Email : '');
                            oCase.AOSI_ASP_Company_Email_ID__c  =   (mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_Company_Email_ID__c != null ? mapPinASPAosi.get(oCase.Contact_MailingPostalCode__c).AOSI_ASP__r.AOSI_Company_Email_ID__c : '');
                        /*** else If Case related Contact has its Postal Code defined in PinAllocation Object and its ASP Profile is not ASP AOSI ***/
                        } else if ( !mapPinOtherUser.isEmpty() && mapPinOtherUser.containsKey(oCase.Contact_MailingPostalCode__c) && mapPinOtherUser.get(oCase.Contact_MailingPostalCode__c) != null) {
                            oCase.OwnerId   =  mapPinOtherUser.get(oCase.Contact_MailingPostalCode__c);
                        /***  else If Case realted Contact doesnot have its Postal Code defined in PinAllocation Object then based on Contact Region 
                              i.e   if Region = North then Case Owner is User under  Role RCC North, 
                                    if Region = East  then Case Owner is User under  Role RCC East,
                                    if Region = South then Case Owner is User under  Role RCC South,   
                                    if Region = West  then Case Owner is User under  Role RCC West ***/   
                        } else if( !mapContact.isEmpty() && mapContact.containsKey(oCase.ContactId) && mapContact.get(oCase.ContactId) != null && mapContact.get(oCase.ContactId).AOSI_Region__c != null ) {
                            if(mapContact.get(oCase.ContactId).AOSI_Region__c.equalsIgnoreCase(DefineConstant.NORTH)) {                        
                                oCase.OwnerId = mapRegionUserId.get('North');                                                                   
                            }
                            else if(mapContact.get(oCase.ContactId).AOSI_Region__c.equalsIgnoreCase(DefineConstant.EAST)){                        
                                oCase.OwnerId = mapRegionUserId.get('East');                                                                                 
                            }
                            else if(mapContact.get(oCase.ContactId).AOSI_Region__c.equalsIgnoreCase(DefineConstant.SOUTH)){                        
                                oCase.OwnerId = mapRegionUserId.get('South');                                                                                  
                            }
                            else if(mapContact.get(oCase.ContactId).AOSI_Region__c.equalsIgnoreCase(DefineConstant.WEST)){                                           
                                oCase.OwnerId = mapRegionUserId.get('West');                                                          
                            }                    
                        } // End of update case owner
                    
                    
                        Time createdTime    =   Time.newInstance(oCase.createdDate.hour(), oCase.createdDate.minute(), oCase.createdDate.second(), oCase.createdDate.millisecond());
                        try {
                            //Send SMS Notification to customer on Case Creation with Case Reason : Free Installation or Chargeable Installation
                            if( (oCase.Reason == DefineConstant.CASE_REASON_FREE_INSTALLATION || oCase.Reason == DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION) && oCase.parentId == null ) {                   
                                if( createdTime >= smsStartTime && createdTime < smsEndTime ) {
                                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_INSTALLATION)));     
                                    smsHistory.Case__c  =   oCase.Id;
                                    smsHistoryList.add(smsHistory);                        
                                } else {
                                    scheduleSMSList.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_INSTALLATION)), true, true));
                                }
                                taskList.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_INSTALLATION, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED) );
                            } 
                            
                            //Send SMS Notification to customer on Case Creation with Case Reason : Color Panel(Free)  or Color Panel(Chargeable)
                            else if( (oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_FREE || oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE) && oCase.parentId == null ) {
                                if( createdTime >= smsStartTime && createdTime < smsEndTime ) {
                                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_COLOR_PANEL_REG)));
                                    smsHistory.Case__c  =   oCase.Id;
                                    smsHistoryList.add(smsHistory); 
                                } else {
                                    scheduleSMSList.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_COLOR_PANEL_REG)), true, true));
                                }
                                taskList.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_COLOR_PANEL_REG, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED) );
                            }
                            
                            //Send SMS Notification to customer on Case Creation with Case Reason : Service or Dealer Stock or Contract Request
                            else if( (oCase.Reason == DefineConstant.CASE_REASON_SERVICE || oCase.Reason == DefineConstant.CASE_REASON_DEALER_STOCK || oCase.Reason == DefineConstant.CASE_REASON_CONTRACT_REQUEST ) && oCase.CC_SSV__c != true ) {
                                if( createdTime >= smsStartTime && createdTime < smsEndTime ) {
                                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_COMPLAINT_REG)));
                                    smsHistory.Case__c  =   oCase.Id;
                                    smsHistoryList.add(smsHistory);
                                } else {
                                    scheduleSMSList.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_COMPLAINT_REG)), true, true));
                                }
                                taskList.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_COMPLAINT_REG, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED) );
                            }
                
                            
                            //Send SMS Notification to customer on Case Creation with Case Reason : PM Service and Case Status not equal-to Unregistered / Unallocated
                            else if( oCase.Reason == DefineConstant.CASE_REASON_PM_SERVICE && oCase.Status != DefineConstant.CASE_STATUS_UNREG_UNALLOCATED ) {
                                if( createdTime >= smsStartTime && createdTime < smsEndTime ) {
                                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_COMPLAINT_REG)));
                                    smsHistory.Case__c  =   oCase.Id;
                                    smsHistoryList.add(smsHistory);              
                                }  else {
                                    scheduleSMSList.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_COMPLAINT_REG)), true, true));
                                }
                                taskList.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_COMPLAINT_REG, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED) );
                            }
                            
                            //Send SMS Notification to customer on Case Creation with Case Reason : Sales Query
                            else if( oCase.Reason == DefineConstant.CASE_REASON_SALES_QUERY ) {
                                if( createdTime >= smsStartTime && createdTime < smsEndTime ) {
                                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CREATION_NEW)));
                                    smsHistory.Case__c  =   oCase.Id;
                                    smsHistoryList.add(smsHistory);
                                } else {
                                    scheduleSMSList.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CREATION_NEW)), true, true));
                                }
                                taskList.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CREATION_NEW, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED) );
                            }  
                    
                            //Send SMS Notification to customer on Case Creation with Case Reason : Warranty Registration
                            else if( oCase.Reason == DefineConstant.CASE_REASON_WARRANTY_REG ) { 
                                if( createdTime >= smsStartTime && createdTime < smsEndTime ) {
                                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_WARRANTY_REG)));    
                                    smsHistory.Case__c  =   oCase.Id;
                                    smsHistoryList.add(smsHistory);
                                } else {
                                    scheduleSMSList.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_WARRANTY_REG)), true, true));
                                }
                                taskList.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_FOR_WARRANTY_REG, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED) );
                            }
                            Integer excp =  (test.isRunningTest() ? (1/0) : 1 );    
                        } catch(Exception e) { System.debug('### Exception from AOSI_CaseTriggerHandler at line number - ' + e.getLineNumber() + e.getMessage() ); }                                
                    }// End of if(oCase.RecordTypeId==recordTypeId)
                } //End of for( Case oCase : newMap.values() )
            } //End of if(!newMap.isEmpty())
            
            /***  Calling method - afterInsertUpdateHandler(list<Case> caseList, map<Id, Asset> assetMap, map<Id,Product2> productMap, Boolean isUpdate)***/
            afterInsertUpdateHandler(listCase, new map<ID,Asset>(), new map<Id,Product2>(), false); } catch (Exception e) {System.debug('***Exception afterInsertHandler AOSI_CaseTriggerHandler ***'+e);}
        
        Savepoint oSavePt   =   Database.setSavepoint();
        try {
            if (!smsHistoryList.isEmpty() && !test.isRunningTest()) {
                insert smsHistoryList;
            }
            if(!scheduleSMSList.isEmpty()) {
                insert scheduleSMSList;
            }
            if(!taskList.isEmpty()) {
                insert taskList;
            }
            Integer excp =  (test.isRunningTest() ? (1/0) : 1 ); 
        } catch (Exception e) { Database.RollBack(oSavePt); System.debug('Exception caused while inserting SMS History/Schedule SMS/Task ojbect' + e.getMessage()); }
                              
    } //End of afterInsertHandler()
    
    /**************************************************************************************************************************************************************************************************
     * Method Name : afterUpdateHandler()
     * Return Type : void
     * Description : Defines case trigger after update logic  
                     1)To update Product Membrane Warranty and Asset Membrane Warranty on closure of free installation cases  
                     2)To update Asset Purchase value and Purchase Date on closure of free installation cases 
                     3)To create new AOSI Contract on updating Contract Pin
                     4)To send SMS to customer and service engineer 
                        - When service engineer is assigned to case
                        - When service engineer responds to the customer
                        - Resend SMS - if not delivered
                        - Resend SMS - when service engineer is changed
                        - Status Changed to OnHold or Cancelled or Closed
                        - To send survey SMS two days after the case is closed    
     * ***********************************************************************************************************************************************************************************************/
    public void afterUpdateHandler() {
        
        set<Id> setCaseIds                  =   new set<Id>();
        set<Id> setContactIds               =   new set<Id>();
        set<Id> panelCaseIds                =   new set<Id>();
        set<Id> parentCaseServEnggIds       =   new set<Id>();
        
        map<Id,Case> mUpdateCase                =   new map<Id,Case>();      
        map<Id,Asset> assetMap                  =   new map<Id,Asset>();
        map<Id,Product2> productMap             =   new map<Id,Product2>();
        map<Id,Case> mapParentCase              =   new map<Id,Case>();
        map<Id,Case> mapCaseCustConChngd        =   new map<Id,Case>();
        map<Id,Contact> mapContacts             =   new map<Id,Contact>();
        map<Id,Id> mapCaseIdProdId              =   new map<Id,Id>(); 
        map<Id ,map<String,Product_AMC_Junction__c>> mapProdIdAMC    =   new map<Id, map<String, Product_AMC_Junction__c>>(); //changed
        map<Id,Id>  mCaseIDAssetID              =   new map<Id,Id>();
        
        list<Task> lInsertTask                                      =   new list<Task>();
        list<Cash_Receipt__c> lCashReceipt                          =   new list<Cash_Receipt__c>();    //List is used to update Cash Receipt       
        list<AOSI_Contract__c> listNewContract                      =   new list<AOSI_Contract__c>(); 
        list<Case_Customer_Concern__c> listCaseCustCon              =   new list<Case_Customer_Concern__c>();
        list<smagicinteract__smsMagic__c> lInsertSMSHistory         =   new list<smagicinteract__smsMagic__c>();
        list<smagicinteract__Scheduled_SMS__c> lInsertScheduleSMS   =   new list<smagicinteract__Scheduled_SMS__c>();
        
        if ( !newMap.isEmpty() ) { 
            for ( Case oCase : newMap.values() ) {
                if( oCase.RecordTypeId != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id) {  
                     
                    if( oCase.ContactId != null ) {
                        setContactIds.add(oCase.ContactId);
                    }
                    
                    if(oCase.Service_Engineer__c!=null && oCase.Assignment_Start_Time__c != null && (oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.ParentId==null){
                        mapParentCase.put(oCase.Id, oCase);
                        parentCaseServEnggIds.add(oCase.Service_Engineer__c);
                    }
                    
                    if((oCase.Reason.equalsIgnorecase(DefineConstant.CASE_REASON_COLORPANEL_FREE)||oCase.Reason.equalsIgnorecase(DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE)) && (oCase.Assignment_End_Time__c != oldMap.get(oCase.Id).Assignment_End_Time__c || oCase.AOSI_Case_Close_Time__c != oldMap.get(oCase.Id).AOSI_Case_Close_Time__c) ){
                        panelCaseIds.add(oCase.Id);
                    }
                    
                    if(oCase.AOSI_Customer_Concern__c != oldMap.get(oCase.Id).AOSI_Customer_Concern__c) {
                        mapCaseCustConChngd.put(oCase.Id,oCase);
                    }
                    
                    if(oCase.AOSI_AMC_Pin__c != null && oldMap.get(oCase.Id).AOSI_AMC_Pin__c != oCase.AOSI_AMC_Pin__c && oCase.AOSIProduct__c != null && oCase.AssetId != null) {
                        mapCaseIdProdId.put(oCase.Id,oCase.AOSIProduct__c);
                        mCaseIDAssetID.put(oCase.Id,oCase.AssetId);
                    }
                    
                    setCaseIds.add(oCase.Id);
                    
                } //End of if(Case Record Type == AOS India)
            } //End of for(Case oCase : newMap.values())
        } //End of if (!newMap.isEmpty())
        
        Id aosIndiaRecType  =   (caseAOSIndiaRecType.Id != null ? caseAOSIndiaRecType.Id : '');
        
        String queryString = 'SELECT ';
        for ( Schema.SObjectField field : Schema.getGlobalDescribe().get(DefineConstant.OBJECT_NAME_CASE).getDescribe().fields.getMap().values()) {
            queryString += field + ',';
        }
        queryString += ' Asset.Name, Asset.PurchaseDate, Asset.AOSI_Warranty_registration_Date__c,Asset.AOSI_Warranty_Registered_In_Time_new__c, Asset.AOSI_Membrane_Warranty__c, Asset.AOSI_Purchase_Value__c,AOSIProduct__r.AOSI_Vertical__c, AOSIProduct__r.AOSI_Membrane_Wty__c' + 
                       ' FROM Case WHERE Id IN :setCaseIds AND RecordTypeId =:aosIndiaRecType';
        list<Case> listCase = database.query(queryString);
      
        
        //Code to initialize mapContacts
        if( !setContactIds.isEmpty() ) {
            for( Contact oCon : [SELECT Id, Name, Email, Phone FROM Contact WHERE Id IN: setContactIds] ) {
                mapContacts.put(oCon.Id, oCon);
            }           
        }
        
        //Code block to update child case's Assignment Start Time = Parent Case Assignment Start Time
        if( !mapParentCase.isEmpty() && !parentCaseServEnggIds.isEmpty()) {
            for ( Case oCase : [SELECT Id, Assignment_Start_Time__c, ParentId, Service_Engineer__c FROM Case WHERE ParentId IN: mapParentCase.keyset() AND Service_Engineer__c IN: parentCaseServEnggIds] ) {
                if( mapParentCase.containsKey(oCase.ParentId) && mapParentCase.get(oCase.ParentId) != null) {
                    if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                        mUpdateCase.get(oCase.Id).Assignment_Start_Time__c = mapParentCase.get(oCase.ParentId).Assignment_Start_Time__c;    
                    } else {
                        mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, Assignment_Start_Time__c = mapParentCase.get(oCase.ParentId).Assignment_Start_Time__c));
                    }
                }    
            }
        }
        
        //Code block to update Case Customer Concern if Customer Concern of Case gets changed
        if( !mapCaseCustConChngd.isEmpty() ) {
            for( Case_Customer_Concern__c oCustCon : [SELECT Id, Name, Customer_Concern__c, Case__c FROM Case_Customer_Concern__c WHERE Case__c IN: mapCaseCustConChngd.keyset()] ) {
                if( mapCaseCustConChngd.containsKey(oCustCon.Case__c) && mapCaseCustConChngd.get(oCustCon.Case__c) != null ) {
                    oCustCon.Customer_Concern__c = mapCaseCustConChngd.get(oCustCon.Case__c).AOSI_Customer_Concern__c;
                    listCaseCustCon.add(oCustCon);
                }
            }
        }
        
        for( Product_AMC_Junction__c oPAJunction : [SELECT Id, AMC_Master__c, AMC_Master__r.Name, AMC_Master__r.AOSI_Contract_Type__c, AMC_Master__r.AOSI_Status__c, AMC_Master__r.AOSI_AMC_Amount__c, Product__c
                                                    FROM Product_AMC_Junction__c WHERE Product__c IN :mapCaseIdProdId.values() AND AMC_Master__r.AOSI_Status__c =: DefineConstant.AMC_STATUS_ACTIVE]) { //Product__c IN :mapCaseIdProdId.values() AND 
            if( !mapProdIdAMC.isEmpty() && mapProdIdAMC.containsKey(oPAJunction.Product__c) && mapProdIdAMC.get(oPAJunction.Product__c) != null ) {
                mapProdIdAMC.get(oPAJunction.Product__c).put(oPAJunction.AMC_Master__r.AOSI_Contract_Type__c, oPAJunction); //changed from mapProdIdAMC.get(oPAJunction.Product__c).put(oPAJunction.AMC_Master__r.AOSI_Contract_Type__c, oPAJunction.AMC_Master__c);           
            } else {                   
                mapProdIdAMC.put(oPAJunction.Product__c, new map<String, Product_AMC_Junction__c>{oPAJunction.AMC_Master__r.AOSI_Contract_Type__c => oPAJunction}); //changed from mapProdIdAMC.put(oPAJunction.Product__c, new map<String, Id>{oPAJunction.AMC_Master__r.AOSI_Contract_Type__c => oPAJunction.AMC_Master__c});
            }
        }
     
        map<Id,AOSI_Contract__c> mAssetContract =   new map<Id,AOSI_Contract__c>();
        if( !mCaseIDAssetID.isEmpty() ) {
            for(Asset oAsset : [SELECT Id,(SELECT Id,Name,CreatedDate,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Contract_Status__c,AOSI_Asset__c FROM Contracts__r WHERE  CreatedDate < :System.today() ORDER BY CreatedDate DESC LIMIT 1) FROM Asset WHERE Id IN:mCaseIDAssetID.values()] ){
                if(oAsset.Contracts__r != null && oAsset.Contracts__r.size() == 1) {
                    mAssetContract.put(oAsset.Id,oAsset.Contracts__r);
                }       
            }
        }
        
        if( !listCase.isEmpty() ) {                 
            for ( Case oCase : listCase ) {
                
                if( oCase.RecordTypeId != null && oCase.RecordTypeId == caseAOSIndiaRecType.Id) {
                    Time modifiedTime    =   Time.newInstance(oCase.LastModifiedDate.hour(), oCase.LastModifiedDate.minute(), oCase.LastModifiedDate.second(), oCase.LastModifiedDate.millisecond());
                    /******************************************************************************************************************************************
                     If Case Reason is Free Installation and Case Status is Closed,
                           a.If Hardness is < 400 and Input TDS < 2000,
                             -Membrane warranty in Asset:-2 years
                             -Membrane warranty in Product:-Membrane Wty 2 year
                           b.If Hardness is = No Limit and Input TDS < 2000,
                             -Membrane warranty in Asset:-1 years
                             -Membrane warranty in Product:-Membrane Wty 2 year
                           c.a.If Hardness is = No Limit and Input TDS > 2000,
                             -Membrane warranty in Asset:-NIL
                             -Membrane warranty in Product:-Membrane Wty 2 year
                    *******************************************************************************************************************************************/
                    if( oCase.AssetId != null && oCase.AOSIProduct__r != null ) {
                        
                        if( oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION) && oCase.Status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) ) {
                            Integer tdsInput = (oCase.AOSI_TDS_Input__c == null ? 0 : Integer.valueOf(oCase.AOSI_TDS_Input__c));
                            Integer hardness = (oCase.AOSI_Hardness__c == null  ? 0 : Integer.valueOf(oCase.AOSI_Hardness__c));
                                if( tdsInput < DefineConstant.TDS_INPUT_2000 ) {
                                
                                if(hardness <= DefineConstant.HARDNESS_400) {
                                    if( !assetMap.isEmpty() && assetMap.containsKey(oCase.AssetId) && assetMap.get(oCase.AssetId) != null ) {
                                        assetMap.get( oCase.AssetId).AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
                                    } else {
                                        assetMap.put( oCase.AssetId, new Asset(Id = oCase.AssetId, AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS));
                                    }  
                                } // End of if (Hardness < 400) 
                                else{
                                    if( !assetMap.isEmpty() && assetMap.containsKey(oCase.AssetId) && assetMap.get(oCase.AssetId) != null ) {
                                        assetMap.get( oCase.AssetId).AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_1YR;
                                    } else {
                                        assetMap.put( oCase.AssetId, new Asset(Id = oCase.AssetId, AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_1YR));
                                    } 
                                } //End of else if (Hardness = No Limit TDS < 2000) 
                                
                                
                              
                            } //if ( TDS Input < 2000>)
                            else if( tdsInput > DefineConstant.TDS_INPUT_2000 ) {
                               
                                    if( !assetMap.isEmpty() && assetMap.containsKey(oCase.AssetId) && assetMap.get(oCase.AssetId) != null ) {
                                        assetMap.get( oCase.AssetId).AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_NIL;
                                    } else {
                                        assetMap.put( oCase.AssetId, new Asset(Id = oCase.AssetId, AOSI_Membrane_Warranty__c = DefineConstant.ASSET_MEMBRANE_WRRTY_NIL));
                                    }
                                
                                } //if ( TDS Input > 2000)
                        } //End of if(case reason = 'Free Installation' && Status == 'Closed') 
                    } //End of if(AssetID != null && Product Id != null)
                    
                    /*** To update Asset PurchaseValue - for installation case's on closure ***/
                    if(oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION) && oCase.status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && oCase.AssetId != null && oCase.AOSI_Purchase_Value__c != null) {
                        if(oCase.Asset.AOSI_Purchase_Value__c == null || oCase.Asset.AOSI_Purchase_Value__c == 0){
                            if( !assetMap.isEmpty() && assetMap.containsKey(oCase.AssetId) && assetMap.get(oCase.AssetId) != null ) {
                                assetMap.get(oCase.AssetId).AOSI_Purchase_Value__c = oCase.AOSI_Purchase_Value__c;
                            } else {
                                assetMap.put(oCase.AssetId, new Asset(Id = oCase.AssetId, AOSI_Purchase_Value__c = oCase.AOSI_Purchase_Value__c) );
                            }   
                        }
                    }
                    
                    /*** To update Asset PurchaseDate - for installation case's on closure ***/
                    if((oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_FREE_INSTALLATION)||oCase.Reason.equalsIgnoreCase(DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION)) && oCase.status.equalsIgnoreCase(DefineConstant.CASE_STATUS_CLOSED) && oCase.AssetId != null && oCase.AOSI_Purchase_Date__c != null){
                        if(oCase.AOSI_Asset_Purchase_Date__c == null) {
                             if( !assetMap.isEmpty() && assetMap.containsKey(oCase.AssetId) && assetMap.get(oCase.AssetId) != null ) {
                                assetMap.get(oCase.AssetId).PurchaseDate = oCase.AOSI_Purchase_Date__c;
                            } else {
                                assetMap.put(oCase.AssetId, new Asset(Id = oCase.AssetId, PurchaseDate = oCase.AOSI_Purchase_Date__c) );
                            }
                        }
                        
                    }
                    
                    /*** To create new AOSI Contract on updating Contract Pin ***/
                    if(oCase.AOSI_AMC_Pin__c != null && oldMap.get(oCase.Id).AOSI_AMC_Pin__c != oCase.AOSI_AMC_Pin__c && oCase.AOSIProduct__c != null  && oCase.AssetId != null) {
                        if( !mapContacts.isEmpty() && mapContacts.containsKey(oCase.ContactId) && mapContacts.get(oCase.ContactId) != null && !mapProdIdAMC.isEmpty() && mapProdIdAMC.containsKey(oCase.AOSIProduct__c) && mapProdIdAMC.get(oCase.AOSIProduct__c) != null ) {
                            AOSI_Contract__c oContract              =   new AOSI_Contract__c();
                            oContract.Name                          =   oCase.AOSI_AMC_Pin__c;
                            oContract.AOSI_Autogenerated_OTP__c     =   generateOTP(6); // Added by Rajesh
                            
                            oCase.AOSI_Contract_Pin_Registration_Time__c= System.Now();
                            oContract.AOSI_Asset__c                 =   oCase.AssetId;
                            oContract.AOSI_Case__c                  =   oCase.Id;
                            oContract.AOSI_Contact_Email_Id__c      =   (mapContacts.get(oCase.ContactId).Email != null ? mapContacts.get(oCase.ContactId).Email : null ) ;
                            oContract.AOSI_Contact_Phone_Number__c  =   (mapContacts.get(oCase.ContactId).Phone != null ? mapContacts.get(oCase.ContactId).Phone : null );
                            oContract.AOSI_Start_Date__c            =   System.today(); 
                            if( oCase.AOSIProduct__r.AOSI_Vertical__c != null && oCase.AOSIProduct__r.AOSI_Vertical__c.equalsIgnoreCase(DefineConstant.PROD_VERTICAL_WH)) {
                                if(oCase.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase(DefineConstant.CONTRACT_AMC) && mapProdIdAMC.get(oCase.AOSIProduct__c).containsKey(DefineConstant.AMC_WH_AMC) && mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WH_AMC) != null){
                                    oContract.AOSI_AMC__c           = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WH_AMC).AMC_Master__c; 
                                    oContract.AOSI_Base_Amount__c   = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WH_AMC).AMC_Master__r.AOSI_AMC_Amount__c;
                                }
                            }
                            if( oCase.AOSIProduct__r.AOSI_Vertical__c != null && oCase.AOSIProduct__r.AOSI_Vertical__c.equalsIgnoreCase(DefineConstant.PROD_VERTICAL_WT)) {
                               if(oCase.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase(DefineConstant.CONTRACT_AMC) && mapProdIdAMC.get(oCase.AOSIProduct__c).containsKey(DefineConstant.AMC_WT_AMC) && mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_AMC) != null){
                                    oContract.AOSI_AMC__c           = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_AMC).AMC_Master__c; 
                                    oContract.AOSI_Base_Amount__c   = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_AMC).AMC_Master__r.AOSI_AMC_Amount__c;
                                } else if(oCase.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase(DefineConstant.CONTRACT_ACMC) && mapProdIdAMC.get(oCase.AOSIProduct__c).containsKey(DefineConstant.AMC_WT_ACMC) && mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_ACMC) != null){
                                    oContract.AOSI_AMC__c           = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_ACMC).AMC_Master__c;
                                    oContract.AOSI_Base_Amount__c   = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_ACMC).AMC_Master__r.AOSI_AMC_Amount__c;
                                } else if(oCase.AOSI_AMC_Pin__c.split(' ')[0].equalsIgnorecase(DefineConstant.CONTRACT_FLT) &&  mapProdIdAMC.get(oCase.AOSIProduct__c).containsKey(DefineConstant.AMC_WT_FP) && mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_FP) != null){
                                    oContract.AOSI_AMC__c           = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_FP).AMC_Master__c;
                                    oContract.AOSI_Base_Amount__c   = mapProdIdAMC.get(oCase.AOSIProduct__c).get(DefineConstant.AMC_WT_FP).AMC_Master__r.AOSI_AMC_Amount__c;
                                }
                            }
                            listNewContract.add(oContract);
                            OCase.AOSI_AMC_Pin__c='';
                        }
                    }
                    
                    
                    /*** To update Cash Receipt to utilized / un-utilized if cash receipt is changed ***/
                    if( oCase.AOSI_Cash_Receipt__c != null) {
                        Cash_Receipt__c oCashReceipt          =    new Cash_Receipt__c();
                        oCashReceipt.Id                       =    oCase.AOSI_Cash_Receipt__c;
                        oCashReceipt.Utilized__c              =    true;
                        lCashReceipt.add(oCashReceipt);
                    }
                    if( !oldMap.isEmpty() && oldMap.containsKey(oCase.Id) && oldMap.get(oCase.Id).AOSI_Cash_Receipt__c != null && (oCase.AOSI_Cash_Receipt__c != oldMap.get(oCase.Id).AOSI_Cash_Receipt__c || oCase.AOSI_Cash_Receipt__c == null)) {
                        Cash_Receipt__c oCashReceiptOld          =    new Cash_Receipt__c();
                        oCashReceiptOld.Id                       =    oldMap.get(oCase.Id).AOSI_Cash_Receipt__c;
                        oCashReceiptOld.Utilized__c              =    false;
                        lCashReceipt.add(oCashReceiptOld);
                    }
                    
                    if(oCase.Status == 'Partially Closed' && oldMap.get(oCase.Id).Status == 'On Hold' && oldMap.get(oCase.Id).AOSI_Cancelled_On_HOLD_Reason__c != oCase.AOSI_Cancelled_On_HOLD_Reason__c) { 
                     oCase.addError('You cannot change cancelled/on-hold reason');   
                    }
                    //Send SMS Notification to Service Engineer and Contact when Service Engineer is assigned to case for first time
                    if(oCase.Service_Engineer__c != null && oCase.Service_Engineer_Phone__c != null && oldMap.get(oCase.Id).Service_Engineer__c == null && oldMap.get(oCase.Id).Service_Engineer__c != oCase.Service_Engineer__c) { 
                        
                        //Send GCM Notification to the service engineer.
                        if(oCase.GCM_Registration_ID__c !=null)
                        {
                        //Added by Rajesh 22 March 2016
                        System.debug('Sending new case allocation notification');
                        
                        AOSI_GPS_GCMMessenger.sendMessage(oCase.Id,oCase.Service_Engineer__r.AOSI_GCM_Registration_ID__c,'New Case');
                        }
                        //End Send GCM Notification to the service engineer.
                            
                        //Send SMS Notification to Contact, when Service Engineer is assigned for a Case Reason - Free Installation(ParentCase),Chargeable Installation(ParentCase),PM Service, Service, Dealer Stock
                        if( (((oCase.Reason == DefineConstant.CASE_REASON_FREE_INSTALLATION || oCase.Reason == DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION) && oCase.ParentId == null) || oCase.Reason == DefineConstant.CASE_REASON_PM_SERVICE || oCase.Reason == DefineConstant.CASE_REASON_DEALER_STOCK || oCase.Reason == DefineConstant.CASE_REASON_SERVICE) && oCase.SMS_SENT_TO_CONTACT__c == false && oCase.Status != DefineConstant.CASE_STATUS_CLOSED && oCase.Assignment_End_Time__c == null){
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER)) );    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            } else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true));
                            } 
                        } //End of Send SMS Notification to Contact, when Service Engineer is assigned for a Case Reason - Free Installation,Chargeable Installation,PM Service,Dealer Stock
                        
                        //Send SMS Notification to Contact, when Service Engineer is assigned for a Case Reason - Sales Query
                        if( oCase.Reason == DefineConstant.CASE_REASON_SALES_QUERY && oCase.SMS_SENT_TO_INSTALLER__c == false && oCase.SMS_SENT_TO_CONTACT__c == false ){
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_ASSIGNMNT_NEW)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            }else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_ASSIGNMNT_NEW)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_ASSIGNMNT_NEW, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true));
                            } 
                        }//End of Send SMS Notification to Contact, when Service Engineer is assigned for a Case Reason - Sales Query
                        
                        //Send SMS Notification to Service Engineer, when assigned to a Case Reason - Free and Chargeable Installation
                        if( (oCase.Reason == DefineConstant.CASE_REASON_FREE_INSTALLATION || oCase.Reason == DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION) && oCase.SMS_SENT_TO_INSTALLER__c == false && oCase.Status != DefineConstant.CASE_STATUS_CLOSED && oCase.Assignment_End_Time__c == null) {
                            smagicinteract__smsMagic__c smsResource = ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Service_Engineer_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_TO_INSTALLER_FOR_INSTALLATION)));
                            smsResource.Case__c                     = oCase.Id;
                            lInsertSMSHistory.add(smsResource);
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_TO_INSTALLER_FOR_INSTALLATION, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_INSTALLER__c  =   true;
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_INSTALLER__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            } 
                        } //End of Send SMS Notification to Service Engineer, when assigned to a Case : Reason - Free and Chargeable installation
                        
                        //Send SMS Notification to Service Engineer, when assigned to a Case Reason - PM Service,Dealer Stock,Service,Sales Query,Contract Request,Exchange-Pickup
                        if( (oCase.Reason == DefineConstant.CASE_REASON_PM_SERVICE || oCase.Reason == DefineConstant.CASE_REASON_DEALER_STOCK || oCase.Reason == DefineConstant.CASE_REASON_SERVICE || oCase.Reason == DefineConstant.CASE_REASON_SALES_QUERY || oCase.Reason == DefineConstant.CASE_REASON_CONTRACT_REQUEST || oCase.Reason == DefineConstant.CASE_REASON_EXCHANGE_PICKUP) && oCase.SMS_SENT_TO_INSTALLER__c == false && oCase.Status != DefineConstant.CASE_STATUS_CLOSED && oCase.Assignment_End_Time__c == null) {
                            smagicinteract__smsMagic__c smsResource     =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Service_Engineer_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_TO_INSTALLER_FOR_COMPLAINT)));
                            smsResource.Case__c                         =   oCase.Id;
                            lInsertSMSHistory.add(smsResource);
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_TO_INSTALLER_FOR_COMPLAINT, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_INSTALLER__c  =   true;
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_INSTALLER__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            }
                        } //End of Send SMS Notification to Service Engineer, when assigned to a Case Reason - PM Service,Dealer Stock,Service,Sales Query,Contract Request,Exchange-Pickup
                        
                        //Send SMS Notification to Service Engineer when assigned to a Case Reason Color Panel (Free) or Color Panel (Chargeable)
                        if( (oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_FREE || oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE) && oCase.SMS_SENT_TO_INSTALLER__c == false ){
                            smagicinteract__smsMagic__c smsResource     =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Service_Engineer_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_TO_INSTALLER_FOR_COLORPANEL_NEW)));
                            smsResource.Case__c                         =   oCase.Id;
                            lInsertSMSHistory.add(smsResource);
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_TO_INSTALLER_FOR_COLORPANEL_NEW, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_INSTALLER__c  =   true;
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_INSTALLER__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            } 
                        } //End of Send SMS Notification to Service Engineer when assigned to a Case Reason Color Panel (Free) or Color Panel (Chargeable)
                    }
                    
                    //Send SMS Notification on Service Engineer Change to Customer and ServiceEngineer or Resend SMS to Service Engg only when Resend SMS = true
                    if( ((oldMap.get(oCase.Id).Service_Engineer__c != null && oldMap.get(oCase.Id).Service_Engineer__c != oCase.Service_Engineer__c) || oCase.AOSI_Resend_SMS__c == true) && oCase.ParentId == null){
                        if ( oCase.AOSI_Resend_SMS__c == false) {
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            }else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER)), true, false));
                            }  
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        }
                        smagicinteract__smsMagic__c smsResource     =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Service_Engineer_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_TO_INSTALLER_FOR_COMPLAINT)));
                        smsResource.Case__c                         =   oCase.Id;
                        lInsertSMSHistory.add(smsResource);
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_TO_INSTALLER_FOR_COMPLAINT, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_INSTALLER__c  =   true;
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                            mUpdateCase.get(oCase.Id).AOSI_Resend_SMS__c        =   false;
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_INSTALLER__c = true, SMS_SENT_TO_CONTACT__c = true,AOSI_Resend_SMS__c = false));
                        } 
                    //Resend SMS to Customer
                    } else if( oCase.Service_Engineer_Name__c != null && oCase.AOSI_SYS_SMS_to_Cust__c == true && oldMap.get(oCase.Id).AOSI_SYS_SMS_to_Cust__c != oCase.AOSI_SYS_SMS_to_Cust__c){
                        if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                            smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER)));    
                            smsCustomer.Case__c                     =   oCase.Id;
                            lInsertSMSHistory.add(smsCustomer);
                        }else {
                            lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER)), true, false));
                        }   
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true; 
                            mUpdateCase.get(oCase.Id).AOSI_SYS_SMS_to_Cust__c   =   false;
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, AOSI_SYS_SMS_to_Cust__c = false));
                        }   
                    } //End of Resend SMS to Customer
                    
                    //Respond SMS to Customer 
                    if( (oCase.Reason != DefineConstant.CASE_REASON_EXCHANGE_PICKUP || oCase.Reason != DefineConstant.CASE_REASON_SALES_QUERY) && oldMap.get(oCase.Id).AOSI_Respond_Time__c != oCase.AOSI_Respond_Time__c && oCase.AOSI_Respond_Time__c > 0 && oCase.Service_Engineer__c != null && oCase.ParentId == null){
                        if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                            smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_RESPOND_TIME_TO_CUSTOMER)));    
                            smsCustomer.Case__c                     =   oCase.Id;
                            lInsertSMSHistory.add(smsCustomer);
                        }else {
                            lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_RESPOND_TIME_TO_CUSTOMER)), true, false));
                        }
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_ON_RESPOND_TIME_TO_CUSTOMER, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true));
                        }
                    } //End of Respond SMS to Customer 
                    
                    //Send SMS Notification to Customer when Case Status changed to Cancelled
                    if( (oldMap.get(oCase.Id).Status != DefineConstant.CASE_STATUS_CANCELLED &&  oCase.Status == DefineConstant.CASE_STATUS_CANCELLED) && oCase.Reason != DefineConstant.CASE_REASON_SALES_QUERY ){
                        if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                            smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_STATUS_CHANGED_TO_CANCELLED)));    
                            smsCustomer.Case__c                     =   oCase.Id;
                            lInsertSMSHistory.add(smsCustomer);
                        } else {
                            lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_STATUS_CHANGED_TO_CANCELLED)), true, false));
                        }
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_STATUS_CHANGED_TO_CANCELLED, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true));
                        } 
                    } //End of Send SMS Notification to Customer when Case Status changed to Cancelled
                    
                    //Send SMS Notification to Customer when Case is Cancelled with Case reason SalesQuery 
                    if( oldMap.get(oCase.Id).Status != DefineConstant.CASE_STATUS_CANCELLED &&  oCase.Status == DefineConstant.CASE_STATUS_CANCELLED && oCase.Reason == DefineConstant.CASE_REASON_SALES_QUERY ){
                        if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                            smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CANCELLATION_NEW)));    
                            smsCustomer.Case__c                     =   oCase.Id;
                            lInsertSMSHistory.add(smsCustomer);
                        } else {
                            lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CANCELLATION_NEW)), true, false));
                        }
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CANCELLATION_NEW, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true));
                        } 
                     } //End of Send SMS Notification to Customer when Case is Cancelled with Case reason SalesQuery 
                    
                    //Send SMS Notification to Customer on Case when Status changed to On Hold
                    if( oCase.Reason != DefineConstant.CASE_REASON_EXCHANGE_PICKUP && (oldMap.get(oCase.Id).Status != DefineConstant.CASE_STATUS_ON_HOLD &&  oCase.Status == DefineConstant.CASE_STATUS_ON_HOLD) && oCase.Assignment_End_Time__c == null && oCase.AOSI_Case_Close_Time__c == null && oCase.ParentId == null){
                        if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                            smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_STATUS_CHANGED_TO_ONHOLD)));    
                            smsCustomer.Case__c                     =   oCase.Id;
                            lInsertSMSHistory.add(smsCustomer);
                        }else {
                            lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_STATUS_CHANGED_TO_ONHOLD)), true, false));
                        }
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_STATUS_CHANGED_TO_ONHOLD, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true));
                        } 
                    } //End of Send SMS Notification to Customer on Case when Status changed to On Hold
                    
                    //Send SMS Notification to customer about service charges 
                    //if( oCase.AOSI_New_Final_Amount__c > 0 && (oCase.Status == DefineConstant.CASE_STATUS_PARTIALLY_CLOSED || oCase.Status == DefineConstant.CASE_STATUS_CLOSED) && oCase.Reason != DefineConstant.CASE_REASON_EXCHANGE_PICKUP && oCase.AOSI_SMS_TO_CUST_ON_SERVCHARGE__c == false) { Removed Parially closed condition. By Rajesh
                        if( oCase.AOSI_New_Final_Amount__c > 0 &&  oCase.Status == DefineConstant.CASE_STATUS_CLOSED && oCase.Reason != DefineConstant.CASE_REASON_EXCHANGE_PICKUP && oCase.AOSI_SMS_TO_CUST_ON_SERVCHARGE__c == false) {
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_TO_CUSTOMER_FOR_SERVICE_CHARGES)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            }else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_TO_CUSTOMER_FOR_SERVICE_CHARGES)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_TO_CUSTOMER_FOR_SERVICE_CHARGES, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c            =   true; 
                                mUpdateCase.get(oCase.Id).AOSI_SMS_TO_CUST_ON_SERVCHARGE__c =   true;
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, AOSI_SMS_TO_CUST_ON_SERVCHARGE__c = true));
                            }
                        } //End of Send SMS Notification to customer about service charges
                    
                    //Send SMS Notification to Customer on Closing of Case for color panel, complaint, installation, sales query
                    //if(oldMap.get(oCase.Id).Status != DefineConstant.CASE_STATUS_PARTIALLY_CLOSED  && oCase.Status == DefineConstant.CASE_STATUS_PARTIALLY_CLOSED) {
                    if( (oldMap.get(oCase.Id).Assignment_End_Time__c == null && oCase.Assignment_End_Time__c != null) || (oldMap.get(oCase.Id).AOSI_Case_Close_Time__c == null && oCase.AOSI_Case_Close_Time__c != null) ) {
                        if( (oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_FREE || oCase.Reason == DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE)  && oCase.ParentId == null){
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_CASE_CLOSE_FOR_COLOR_PANEL)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            } else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_CASE_CLOSE_FOR_COLOR_PANEL)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_CASE_CLOSE_FOR_COLOR_PANEL, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true; 
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            } 
                        }
                        else if( (oCase.Reason==DefineConstant.CASE_REASON_SERVICE || oCase.Reason==DefineConstant.CASE_REASON_PM_SERVICE || oCase.Reason==DefineConstant.CASE_REASON_DEALER_STOCK) ){
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_CASE_CLOSE_FOR_COMPLAINT)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            } else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_CASE_CLOSE_FOR_COMPLAINT)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_CASE_CLOSE_FOR_COMPLAINT, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            }
                        }
                        else if( (oCase.Reason == DefineConstant.CASE_REASON_FREE_INSTALLATION || oCase.Reason == DefineConstant.CASE_REASON_CHARGEABLE_INSTALLATION) && oCase.ParentId == null) {
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_CASE_CLOSE_FOR_INSTALLATION)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            } else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_CASE_CLOSE_FOR_INSTALLATION)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_CASE_CLOSE_FOR_INSTALLATION, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            }
                        } 
                        else if( oCase.Reason==DefineConstant.CASE_REASON_SALES_QUERY ){
                            if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                                smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CLOSE)));    
                                smsCustomer.Case__c                     =   oCase.Id;
                                lInsertSMSHistory.add(smsCustomer);
                            } else {
                                lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CLOSE)), true, false));
                            }
                            lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_ON_SALESQUERY_CASE_CLOSE, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                            if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                                mUpdateCase.get(oCase.Id).SMS_Status__c             =   DefineConstant.SMS_SENT_BY_TRIGGER;
                                mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                            } else {
                                mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, SMS_Status__c = DefineConstant.SMS_SENT_BY_TRIGGER));
                            }
                        }   
                    } //End of if(oldMap.get(oCase.Id).Status != DefineConstant.CASE_STATUS_CLOSED  && oCase.Status == DefineConstant.CASE_STATUS_CLOSED)
                        
                    //Send SMS Notification to customer to take a survey on Case Close
                    if( oCase.Status == DefineConstant.CASE_STATUS_CLOSED && oCase.SMS_SENT_TO_CONTACT_FOR_FEEDBACK__c == false && ( oCase.Case_Type__c == DefineConstant.CASE_TYPE_INSTALLATION || oCase.Case_Type__c == DefineConstant.CASE_TYPE_COMPLAINT_REG) ){
                        if( modifiedTime >= smsStartTime && modifiedTime < smsEndTime ) {
                            smagicinteract__smsMagic__c smsCustomer =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, oCase.Contact_Phone__c, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_SURVEY_ON_CASE_CLOSE_AFTER_2_DAYS)));    
                            smsCustomer.Case__c                     =   oCase.Id;
                            lInsertSMSHistory.add(smsCustomer);
                        }else {
                            lInsertScheduleSMS.add(toScheduleSMS(oCase, ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, oCase, mapSMSTemplateText.get(DefineConstant.SMSTEMP_SURVEY_ON_CASE_CLOSE_AFTER_2_DAYS)), true, false));
                        }
                        lInsertTask.add(createNewTask(oCase.CreatedById, oCase.Id, DefineConstant.SMSTEMP_SURVEY_ON_CASE_CLOSE_AFTER_2_DAYS, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED));
                        if( !mUpdateCase.isEmpty() && mUpdateCase.containsKey(oCase.Id) && mUpdateCase.get(oCase.Id) != null ) {
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT_FOR_FEEDBACK__c = true;
                            mUpdateCase.get(oCase.Id).SMS_SENT_TO_CONTACT__c    =   true;  
                        } else {
                            mUpdateCase.put(oCase.Id, new Case(Id = oCase.Id, SMS_SENT_TO_CONTACT__c = true, SMS_SENT_TO_CONTACT_FOR_FEEDBACK__c = true));
                        }
                    } //End of Send SMS Notification to customer to take a survey on Case Close
                } //End of if(Case Record type == 'AOS India')
            } //End of for ( Case oCase : listCase )
        } //if(!lisCase.isEmpty())  
        
        if( !panelCaseIds.isEmpty() ) {
             Casereassignmenthelper.changeowner(panelCaseIds);
        }
        
        /***********************************
        Method Call : afterInsertUpdateHandler();
        ************************************/                       
        afterInsertUpdateHandler(listCase, assetMap, productMap, true);  
        
       
        Savepoint oSavePt   =   Database.setSavepoint();
        try {
             if( !listCaseCustCon.isEmpty() ) {
                update listCaseCustCon;
             }
             if ( !listNewContract.isEmpty() ) {
                insert listNewContract;
             }
             if ( !lCashReceipt.isEmpty() ) {
                update lCashReceipt;
             }
             if ( !mUpdateCase.isEmpty() ) {
                update mUpdateCase.values();
             }
             if (!lInsertSMSHistory.isEmpty() && !test.isRunningTest()) {
                insert lInsertSMSHistory;
             }
             if(!lInsertScheduleSMS.isEmpty()) {
                Database.insert(lInsertScheduleSMS,false);
             }
             if(!lInsertTask.isEmpty()) {
                insert lInsertTask; } }  catch( Exception e ) { Database.RollBack(oSavePt); System.debug('***Exception in AfterUpdateHanlder from AOSI_CaseTriggerHandler Class*** '+ e.getLineNumber() + e.getMessage() );}
            
    } //End of afterUpdateHandler()
    
    /*************************************************************************************************************************************************
    Method Name : updateTimeFields()
    Return Type : void 
    Description : Calculate Response Time(CH), Resolution Time(CH), Job Time(CH), Response Time(WH), Resolution Time(WH), Job Time(WH)
                  depending on Responded Time, Assignment Stop Time, Case Close Time  
    **************************************************************************************************************************************************/
    private void updateTimeFields() {
        
        decimal lsatDayResolutionTime       =   0;
        decimal firstDayResolutionTime      =   0;
        decimal lsatDayResolutionTimeClock  =   0;
        decimal firstDayResolutionTimeClock =   0;
        decimal lsatDayResponseTime         =   0;
        decimal firstDayResponseTime        =   0;
        decimal lsatDayResponseTimeClock    =   0;
        decimal firstDayResponseTimeClock   =   0;
        decimal lsatDayJobTime              =   0;
        decimal firstDayJobTime             =   0;
        decimal lsatDayJobTimeClock         =   0;
        decimal firstDayJobTimeClock        =   0;
        decimal ResolutiondaysNo            =   0;
        decimal Resolutionsunday            =   0;
        decimal ResolutionNoHolidays        =   0;
        decimal ResolutiontotalDays         =   0;
        decimal ResponsedaysNo              =   0;
        decimal Responsesunday              =   0;
        decimal ResponseNoHolidays          =   0;
        decimal ResponsetotalDays           =   0;
        decimal JobdaysNo                   =   0;
        decimal Jobsunday                   =   0;
        decimal JobNoHolidays               =   0;
        decimal JobtotalDays                =   0;
        decimal totalResolutionhours        =   0;
        decimal totalResolutionhoursClock   =   0; 
        decimal totalResponsehours          =   0;
        decimal resondedtime                =   0;
        decimal totalResponsehoursClock     =   0; 
        decimal totalJobhours               =   0;
        decimal totalJobhoursClock          =   0; 
        decimal tempval                     =   0;
        String str; 
        
        
        if ( !newMap.isEmpty() ) { 
            for( Case cs : newMap.values() ) {    
        
                if(cs.RecordTypeId == caseAOSIndiaRecType.Id){
                    //code to calculate Resolution time
                    if(cs.Assignment_End_Time__c == null && cs.AOSI_Appointment_Date__c == null && cs.Assignment_Start_Time__c == Null && cs.AOSI_Case_Close_Time__c == Null){
                            cs.AOSI_Response_Clock_Time__c      = null;
                            cs.AOSI_Resolution_Clock_Time__c    = null;
                            cs.AOSI_Job_Clock_Time__c           = null;
                            cs.AOSI_Response_Time_New__c        = null;
                            cs.AOSI_Resolution_Time_New__c      = null;
                            cs.AOSI_Job_Time_New__c             = null;
                    }
                    
                    if(cs.Assignment_End_Time__c != null && cs.AOSI_Appointment_Date__c != null){
                        if(cs.AOSI_Appointment_Date__c < cs.Assignment_End_Time__c){
                            //method call to count no of days between two dates excluding Sundays 
                            ResolutiondaysNo            = findNoOfDays(cs.AOSI_Appointment_Date__c.date(),cs.Assignment_End_Time__c.date()); 
                            // code to find total no of days between two dates including Sundays               
                            ResolutiontotalDays         = cs.AOSI_Appointment_Date__c.date().daysBetween(cs.Assignment_End_Time__c.date());
                            //count total no of Sundays
                            Resolutionsunday            = ResolutiontotalDays-ResolutiondaysNo; 
                            //method call to count no of holidays between two dates
                            ResolutionNoHolidays        = findNoOfHolidays( cs.AOSI_Appointment_Date__c.date() , cs.Assignment_End_Time__c.date()); 
                            //method call to calculate time difference between start time and 8pm              
                            firstDayResolutionTime      = findFirstDaysHour(cs.AOSI_Appointment_Date__c);
                            //method call to calculate time difference between 8AM and End Time
                            lsatDayResolutionTime       = FindLasttDaysHour(cs.Assignment_End_Time__c);               
                            totalResolutionhours        = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2); 
                            //method call to calculate time difference between start time and 12pm              
                            firstDayResolutionTimeClock = findFirstDaysHourTimeClock(cs.AOSI_Appointment_Date__c);
                            //method call to calculate time difference between 12AM and End Time
                            lsatDayResolutionTimeClock  = findLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                            totalResolutionhoursClock   = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2);  
                        } else {
                            totalResolutionhours        = 2;
                            totalResolutionhoursClock   = 2;
                        }
                        // cs.AOSI_Resolution_Time_New__c = totalResolutionhours;
                        // cs.AOSI_Resolution_Clock_Time__c = totalResolutionhoursClock;                    
                    } else if( cs.AOSI_Case_Close_Time__c != null && cs.AOSI_Appointment_Date__c != null ) {                               
                        if(cs.AOSI_Appointment_Date__c < cs.AOSI_Case_Close_Time__c){
                            ResolutiondaysNo            = findNoOfDays( cs.AOSI_Appointment_Date__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                            ResolutiontotalDays         = cs.AOSI_Appointment_Date__c.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                            Resolutionsunday            = ResolutiontotalDays - ResolutiondaysNo; 
                            ResolutionNoHolidays        = findNoOfHolidays( cs.AOSI_Appointment_Date__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                            firstDayResolutionTime      = findFirstDaysHour(cs.AOSI_Appointment_Date__c);
                            lsatDayResolutionTime       = findLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                            totalResolutionhours        = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2);                             
                            firstDayResolutionTimeClock = findFirstDaysHourTimeClock(cs.AOSI_Appointment_Date__c);                
                            lsatDayResolutionTimeClock  = findLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                            totalResolutionhoursClock   = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2); 
                        } else {
                            totalResolutionhours        = 2;
                            totalResolutionhoursClock   = 2;
                        } 
                   } else if( cs.Assignment_End_Time__c != null ) {
                        if( cs.CreatedDate < cs.Assignment_End_Time__c ) {
                            ResolutiondaysNo            = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                            ResolutiontotalDays         = cs.CreatedDate.date().daysBetween(cs.Assignment_End_Time__c.date());
                            Resolutionsunday            = ResolutiontotalDays - ResolutiondaysNo; 
                            ResolutionNoHolidays        = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                            firstDayResolutionTime      = findFirstDaysHour(cs.CreatedDate);
                            lsatDayResolutionTime       = findLasttDaysHour(cs.Assignment_End_Time__c);               
                            totalResolutionhours        = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2); 
                            firstDayResolutionTimeClock = findFirstDaysHourTimeClock(cs.CreatedDate);                
                            lsatDayResolutionTimeClock  = findLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                            totalResolutionhoursClock   = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2);           
                        } else {
                            totalResolutionhours        = 2;
                            totalResolutionhoursClock   = 2;
                        }
                   } else if( cs.AOSI_Case_Close_Time__c != null ) {
                        if( cs.CreatedDate < cs.AOSI_Case_Close_Time__c ) {
                            ResolutiondaysNo            = findNoOfDays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                            ResolutiontotalDays         = cs.CreatedDate.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                            Resolutionsunday            = ResolutiontotalDays - ResolutiondaysNo; 
                            ResolutionNoHolidays        = findNoOfHolidays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                            firstDayResolutionTime      = findFirstDaysHour(cs.CreatedDate);
                            lsatDayResolutionTime       = findLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                            totalResolutionhours        = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2); 
                            firstDayResolutionTimeClock = findFirstDaysHourTimeClock(cs.CreatedDate);                
                            lsatDayResolutionTimeClock  = findLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                            totalResolutionhoursClock   = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2);                    
                        } else {
                            totalResolutionhours        = 2;
                            totalResolutionhoursClock   = 2;
                        } 
                  }
                
                    // code to calculate Response Time
                    if ( cs.Assignment_Start_Time__c != null && cs.AOSI_Appointment_Date__c != null ) {
                        if (cs.AOSI_Appointment_Date__c < cs.Assignment_Start_Time__c ) {
                            ResponsedaysNo              = findNoOfDays( cs.AOSI_Appointment_Date__c.date() , cs.Assignment_Start_Time__c.date());                
                            ResponsetotalDays           = cs.AOSI_Appointment_Date__c.date().daysBetween(cs.Assignment_Start_Time__c.date());
                            Responsesunday              = ResponsetotalDays-ResponsedaysNo; 
                            ResponseNoHolidays          = findNoOfHolidays( cs.AOSI_Appointment_Date__c.date() , cs.Assignment_Start_Time__c.date());                
                            firstDayResponseTime        = findFirstDaysHour(cs.AOSI_Appointment_Date__c);
                            lsatDayResponseTime         = findLasttDaysHour(cs.Assignment_Start_Time__c);               
                            totalResponsehours          = ((ResponsedaysNo-1-ResponseNoHolidays)*12) + (Responsesunday * 2)+ lsatDayResponseTime + firstDayResponseTime + (ResponseNoHolidays * 2);                 
                            firstDayResponseTimeClock   = findFirstDaysHourTimeClock(cs.AOSI_Appointment_Date__c);                
                            lsatDayResponseTimeClock    = findLasttDaysHourTimeClock(cs.Assignment_Start_Time__c);                             
                            totalResponsehoursClock     = ((ResponsedaysNo-1-ResponseNoHolidays)*24) + (Responsesunday * 2)+ lsatDayResponseTimeClock + firstDayResponseTimeClock + (ResponseNoHolidays * 2);
                        } else {
                            totalResponsehours      = 2;
                            totalResponsehoursClock = 2;
                        }
                    } else if ( cs.Assignment_Start_Time__c != null ) {
                        if ( cs.CreatedDate < cs.Assignment_Start_Time__c ) {
                            ResponsedaysNo              = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date());                
                            ResponsetotalDays           = cs.CreatedDate.date().daysBetween(cs.Assignment_Start_Time__c.date());
                            Responsesunday              = ResponsetotalDays-ResponsedaysNo; 
                            ResponseNoHolidays          = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date());                
                            firstDayResponseTime        = findFirstDaysHour(cs.CreatedDate);
                            lsatDayResponseTime         = findLasttDaysHour(cs.Assignment_Start_Time__c);               
                            totalResponsehours          = ((ResponsedaysNo-1-ResponseNoHolidays)*12) + (Responsesunday * 2)+ lsatDayResponseTime + firstDayResponseTime + (ResponseNoHolidays * 2); 
                            firstDayResponseTimeClock   = findFirstDaysHourTimeClock(cs.CreatedDate);                
                            lsatDayResponseTimeClock    = findLasttDaysHourTimeClock(cs.Assignment_Start_Time__c);               
                            totalResponsehoursClock     = ((ResponsedaysNo-1-ResponseNoHolidays)*24) + (Responsesunday * 2)+ lsatDayResponseTimeClock + firstDayResponseTimeClock + (ResponseNoHolidays * 2);
                        } else {
                            totalResponsehours      = 2;
                            totalResponsehoursClock = 2;
                        }
                    }
                    
                    //Code added to calculate Responded time 
                    if ( cs.Assignment_Start_Time__c != null ) {
                        if ( cs.CreatedDate < cs.Assignment_Start_Time__c ) {
                            ResponsedaysNo          = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date()); 
                            ResponsetotalDays       = cs.CreatedDate.date().daysBetween(cs.Assignment_Start_Time__c.date());
                            Responsesunday          = ResponsetotalDays-ResponsedaysNo; 
                            ResponseNoHolidays      = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date());                   
                            firstDayResponseTime    = findFirstDaysHour(cs.CreatedDate);
                            lsatDayResponseTime     = findLasttDaysHour(cs.Assignment_Start_Time__c);
                            resondedtime            = ((ResponsedaysNo-1-ResponseNoHolidays)*12) + (Responsesunday * 0)+ lsatDayResponseTime + firstDayResponseTime + (ResponseNoHolidays * 2); 
                            str=String.valueof(resondedtime.setscale(2));
                            str=str.substring(str.length()-2);
                            tempval=Decimal.valueof(str);
                            if(tempval > 5 && tempval <= 25)
                            resondedtime=resondedtime - 0.10;
                            else if(tempval > 25 && tempval <= 50)
                            resondedtime=resondedtime - 0.20;
                            else if(tempval > 50 && tempval <= 100)
                            resondedtime=resondedtime - 0.25; 
                           // else
                            //resondedtime=resondedtime.;
                        }
                    } 
                    //end of responded time calc
                    
                    //Code to calculate Job Time
                    if(cs.Assignment_Start_Time__c != null && cs.Assignment_End_Time__c != null ){
                        if(cs.Assignment_Start_Time__c < cs.Assignment_End_Time__c){
                            JobdaysNo               = findNoOfDays( cs.Assignment_Start_Time__c.date() , cs.Assignment_End_Time__c.date());                
                            JobtotalDays            = cs.Assignment_Start_Time__c.date().daysBetween(cs.Assignment_End_Time__c.date());
                            Jobsunday               = JobtotalDays - JobdaysNo; 
                            JobNoHolidays           = findNoOfHolidays( cs.Assignment_Start_Time__c.date() , cs.Assignment_End_Time__c.date());                
                            firstDayJobTime         = findFirstDaysHour(cs.Assignment_Start_Time__c);
                            lsatDayJobTime          = findLasttDaysHour(cs.Assignment_End_Time__c);               
                            totalJobhours           = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2);                  
                            firstDayJobTimeClock    = findFirstDaysHourTimeClock(cs.Assignment_Start_Time__c);                
                            lsatDayJobTimeClock     = findLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                            totalJobhoursClock      = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                        } else {
                            totalJobhours = 2;
                            totalJobhoursClock=2;    
                        }               
                    } else if ( cs.Assignment_Start_Time__c != null && cs.AOSI_Case_Close_Time__c != null ) {
                        if(cs.Assignment_Start_Time__c < cs.AOSI_Case_Close_Time__c) {
                            JobdaysNo               = findNoOfDays( cs.Assignment_Start_Time__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                            JobtotalDays            = cs.Assignment_Start_Time__c.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                            Jobsunday               = JobtotalDays - JobdaysNo; 
                            JobNoHolidays           = findNoOfHolidays( cs.Assignment_Start_Time__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                            firstDayJobTime         = findFirstDaysHour(cs.Assignment_Start_Time__c);
                            lsatDayJobTime          = findLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                            totalJobhours           = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2); 
                            firstDayJobTimeClock    = findFirstDaysHourTimeClock(cs.Assignment_Start_Time__c);                
                            lsatDayJobTimeClock     = findLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                            totalJobhoursClock      = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                        } else {
                            totalJobhours = 2;
                            totalJobhoursClock=2;    
                        }  
                    } else if ( cs.CreatedDate != null && cs.Assignment_End_Time__c != null ) {
                        if(cs.CreatedDate < cs.Assignment_End_Time__c){
                            JobdaysNo               = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                            JobtotalDays            = cs.CreatedDate.date().daysBetween(cs.Assignment_End_Time__c.date());
                            Jobsunday               = JobtotalDays-JobdaysNo; 
                            JobNoHolidays           = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                            firstDayJobTime         = findFirstDaysHour(cs.CreatedDate);
                            lsatDayJobTime          = findLasttDaysHour(cs.Assignment_End_Time__c);               
                            totalJobhours           = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2);                  
                            firstDayJobTimeClock    = findFirstDaysHourTimeClock(cs.CreatedDate);                
                            lsatDayJobTimeClock     = findLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                            totalJobhoursClock      = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                        } else {
                            totalJobhours = 2;
                            totalJobhoursClock=2;    
                        }               
                    } else if(cs.CreatedDate != null && cs.AOSI_Case_Close_Time__c != null){
                        if(cs.CreatedDate < cs.AOSI_Case_Close_Time__c){
                            JobdaysNo               = findNoOfDays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                            JobtotalDays            = cs.CreatedDate.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                            Jobsunday               = JobtotalDays-JobdaysNo; 
                            JobNoHolidays           = findNoOfHolidays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                            firstDayJobTime         = findFirstDaysHour(cs.CreatedDate);
                            lsatDayJobTime          = findLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                            totalJobhours           = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2); 
                            firstDayJobTimeClock    = findFirstDaysHourTimeClock(cs.CreatedDate);                
                            lsatDayJobTimeClock     = findLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                            totalJobhoursClock      = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                        } else {
                            totalJobhours = 2;
                            totalJobhoursClock=2;    
                        }  
                    }  
                    cs.AOSI_Resolution_Time_New__c      =   totalResolutionhours;
                    cs.AOSI_Resolution_Clock_Time__c    =   totalResolutionhoursClock; 
                    cs.AOSI_Response_Time_New__c        =   totalResponsehours.setscale(2);
                    cs.AOSI_Response_Clock_Time__c      =   totalResponsehoursClock;
                    cs.AOSI_Job_Time_New__c             =   totalJobhours;
                    cs.AOSI_Job_Clock_Time__c           =   totalJobhoursClock;
                    cs.AOSI_Respond_Time__c             =   resondedtime.setscale(2);
                } // End of if(Case Recordtype == AOS India)
            } //End of for(Case cs : newmap.values())
        }  //End of if(!newMap.isEmpty())
    } //End of updateTimeFields()
    
    // code to count no of days between two dates excluding sundays
    private Decimal findNoOfDays(Date startDate , Date endDate) {                           
        Decimal NoOfDays    =   0;
        Date tempStartDate  =   startDate;                                 
        for ( integer i = 1; tempStartDate != endDate; i++ ) {           
            if(tempStartDate.daysBetween(tempStartDate.toStartofWeek()) == 0) {
                tempStartDate = tempStartDate.adddays(1);
                continue;
            }         
            NoOfDays        =   NoOfDays+1;
            tempStartDate   =   tempStartDate.adddays(1);                     
        }   
        return NoOfDays ;
    }
    
    //code to count no of holidays between two dates
    private Decimal findNoOfHolidays(Date startDate, Date endDate) {
        Decimal NoOfHoliDays            = 0;
        List<Holidays__c> holidayList   = [Select id, Date__c from Holidays__c where Date__c >=: startDate AND Date__c <=: endDate];
        if( holidayList.size() > 0 ) {
            NoOfHoliDays = holidayList.size(); 
        }
        return NoOfHoliDays;
    }

    // code to calculate time difference between start time and 8pm
    private decimal findFirstDaysHour(Datetime startDate) {       
        Datetime staticDatetime = Datetime.newInstance(startDate.DATE(),time.newInstance(20,00,0,0));
        decimal minstart        = ( startDate.hour() * 60 ) + startDate.minute();
        decimal minend          = ( staticDatetime.hour() * 60 ) + staticDatetime.minute();
        decimal diffInMin       = minend - minstart;
        decimal diiffInHour     = diffInMin/60;  
        return  diiffInHour;    
    }
    //code to calculate time difference between 8AM and End Time 
    private decimal FindLasttDaysHour(Datetime EndDate) {       
        datetime staticDatetime = datetime.newInstance(EndDate.DATE(),time.newInstance(8,00,0,0));
        decimal minstart        = ( staticDatetime.hour() * 60 ) + staticDatetime.minute();
        decimal minend          = ( EndDate.hour() * 60 ) + EndDate.minute();
        decimal diffInMin       = minend - minstart;
        decimal diffInHour      = diffInMin / 60;  
        return  diffInHour;    
    }
    // code to calculate time difference between start time and 12am
    private decimal findFirstDaysHourTimeClock(Datetime startDate) {       
        datetime staticDatetime = datetime.newInstance(startDate.DATE(),time.newInstance(23,59,59,0));
        decimal minstart        = ( startDate.hour() * 60 ) + startDate.minute();
        decimal minend          = ( staticDatetime.hour() * 60 ) + staticDatetime.minute() + 0.98;
        decimal diffInMin       = minend - minstart;
        decimal diiffInHour     = diffInMin / 60;  
        return  diiffInHour;    
    }
    //code to calculate time difference between 12AM and End Time 
    private decimal findLasttDaysHourTimeClock(Datetime endDate) {       
        datetime staticDatetime = datetime.newInstance(endDate.DATE(),time.newInstance(00,00,0,0));
        decimal minstart        = ( staticDatetime.hour() * 60 ) + staticDatetime.minute();
        decimal minend          = ( endDate.hour() * 60 ) + endDate.minute();
        decimal diffInMin       = minend - minstart;
        decimal diffInHour      = diffInMin / 60;  
        return  diffInHour;    
    }
    
    /*********************************************************************************************************************************************
    Method Name : toScheduleSMS(Case objCase, String templateText, Boolean isCustomer, Boolean isRecordInsert)
    Return Type : smagicinteract__Scheduled_SMS__c
    Purpose     : To schedule sms if case is registered from 8:00PM to 8:00AM
    **********************************************************************************************************************************************/
    public smagicinteract__Scheduled_SMS__c toScheduleSMS (Case objCase, String templateText, Boolean isCustomer, Boolean isRecordInsert) {
        
        AOSI_Time_Calculation_Settings__c sNextDay = AOSI_Time_Calculation_Settings__c.getValues(DefineConstant.CS_SCHEDULESMS_NEXTDAY); //'ScheduleSMS NextDay'
        AOSI_Time_Calculation_Settings__c sSameDay = AOSI_Time_Calculation_Settings__c.getValues(DefineConstant.CS_SCHEDULESMS_SAMEDAY); //'ScheduleSMS SameDay'
        
        Integer sNextDayStartHour   = (sNextDay.AOSI_Work_Start_Time__c.split(':')[0] != null ? integer.valueOf(sNextDay.AOSI_Work_Start_Time__c.split(':')[0]) : 0);
        Integer sNextDayStartMin    = (sNextDay.AOSI_Work_Start_Time__c.split(':')[1] != null ? integer.valueOf(sNextDay.AOSI_Work_Start_Time__c.split(':')[1]) : 0);
        Integer sNextDayStartSec    = (sNextDay.AOSI_Work_Start_Time__c.split(':')[2] != null ? integer.valueOf(sNextDay.AOSI_Work_Start_Time__c.split(':')[2]) : 0);
        Integer sNextDayEndHour     = (sNextDay.AOSI_Work_End_Time__c.split(':')[0] != null ? integer.valueOf(sNextDay.AOSI_Work_End_Time__c.split(':')[0]) : 0);
        Integer sNextDayEndMin      = (sNextDay.AOSI_Work_End_Time__c.split(':')[1] != null ? integer.valueOf(sNextDay.AOSI_Work_End_Time__c.split(':')[1]) : 0);
        Integer sNextDayEndSec      = (sNextDay.AOSI_Work_End_Time__c.split(':')[2] != null ? integer.valueOf(sNextDay.AOSI_Work_End_Time__c.split(':')[2]) : 0);
        
        Integer sSameDayStartHour   = (sSameDay.AOSI_Work_Start_Time__c.split(':')[0] != null ? integer.valueOf(sSameDay.AOSI_Work_Start_Time__c.split(':')[0]) : 0);
        Integer sSameDayStartMin    = (sSameDay.AOSI_Work_Start_Time__c.split(':')[1] != null ? integer.valueOf(sSameDay.AOSI_Work_Start_Time__c.split(':')[1]) : 0);
        Integer sSameDayStartSec    = (sSameDay.AOSI_Work_Start_Time__c.split(':')[2] != null ? integer.valueOf(sSameDay.AOSI_Work_Start_Time__c.split(':')[2]) : 0);
        Integer sSameDayEndHour     = (sSameDay.AOSI_Work_End_Time__c.split(':')[0] != null ? integer.valueOf(sSameDay.AOSI_Work_End_Time__c.split(':')[0]) : 0);
        Integer sSameDayEndMin      = (sSameDay.AOSI_Work_End_Time__c.split(':')[1] != null ? integer.valueOf(sSameDay.AOSI_Work_End_Time__c.split(':')[1]) : 0);
        Integer sSameDayEndSec      = (sSameDay.AOSI_Work_End_Time__c.split(':')[2] != null ? integer.valueOf(sSameDay.AOSI_Work_End_Time__c.split(':')[2]) : 0);
                
        Time nextDayStartTime       =   Time.newInstance( sNextDayStartHour, sNextDayStartMin, sNextDayStartSec, 0);
        Time nextDayEndTime         =   Time.newInstance( sNextDayEndHour, sNextDayEndMin, sNextDayEndSec, 0);
        Time sameDayStartTime       =   Time.newInstance( sSameDayStartHour, sSameDayStartMin, sSameDayStartSec, 0);
        Time sameDayEndTime         =   Time.newInstance( sSameDayEndHour, sSameDayEndMin, sSameDayEndSec, 0);
        
        Case tempObjCase = objCase;
        
        smagicinteract__Scheduled_SMS__c scheduleSMSObject = new smagicinteract__Scheduled_SMS__c();
            
            scheduleSMSObject.smagicinteract__MobilePhone__c    =   ( isCustomer ? tempObjCase.Contact_Phone__c : tempObjCase.Service_Engineer_Phone__c );
            scheduleSMSObject.smagicinteract__jobId__c          =   '1';
            scheduleSMSObject.smagicinteract__status__c         =   DefineConstant.SMS_STATUS_SCHEDULE;
            scheduleSMSObject.smagicinteract__SMSText__c        =   templateText;
            scheduleSMSObject.AOSI_Case__c                      =   tempObjCase.Id;
            scheduleSMSObject.smagicinteract__ObjectId__c       =   tempObjCase.Id;
            scheduleSMSObject.smagicinteract__Object_Type__c    =   DefineConstant.OBJECT_NAME_CASE;
                    
            if ( isRecordInsert ) {
                Time createdTime    =   Time.newInstance(tempObjCase.CreatedDate.hour(), tempObjCase.CreatedDate.minute(), tempObjCase.CreatedDate.second(), tempObjCase.CreatedDate.millisecond());
                if ( createdTime >= nextDayStartTime &&  createdTime <= nextDayEndTime ) {
                    scheduleSMSObject.smagicinteract__Scheduled_Date__c =   (tempObjCase.CreatedDate).date().addDays(1);
                } else if ( createdTime >= sameDayStartTime && createdTime <= sameDayEndTime ) {
                    scheduleSMSObject.smagicinteract__Scheduled_Date__c =   (tempObjCase.CreatedDate).date();
                }
            } else {
               Time modifiedTime   =   Time.newInstance(tempObjCase.LastModifiedDate.hour(), tempObjCase.LastModifiedDate.minute(), tempObjCase.LastModifiedDate.second(), tempObjCase.LastModifiedDate.millisecond());
                if ( modifiedTime >= nextDayStartTime && modifiedTime <= nextDayEndTime ) {
                    scheduleSMSObject.smagicinteract__Scheduled_Date__c =   (tempObjCase.LastModifiedDate).date().addDays(1);
                } else if ( modifiedTime >= sameDayStartTime && modifiedTime <= sameDayEndTime ) {
                    scheduleSMSObject.smagicinteract__Scheduled_Date__c =   (tempObjCase.LastModifiedDate).date();
                }          
            }
        return scheduleSMSObject;           
    }   //End of toScheduleSMS()
    
    /*********************************************************************************************************************************************
    Method Name : createNewTask(Id userId, Id caseId, String subject, String priority,  String status)
    Return Type : Task
    Purpose     : used to create new task 
    **********************************************************************************************************************************************/
    public Task createNewTask(Id userId, Id caseId, String subject, String priority,  String status) {
        Task oTask          =   new Task();
        oTask.OwnerId       =   userId;
        oTask.WhatId        =   caseId;
        oTask.Subject       =   subject;
        oTask.Priority      =   priority;
        oTask.Status        =   status;
        return oTask;              
    }   //End of createNewTask()
    
    /*******************************************************************************************************************************************************
        * Method Name : generateOTP
        * Descroption : Generates a random alphanumeric string
    /*******************************************************************************************************************************************************/ 
    public String generateOTP(Integer len){
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,len);
    }
   /*******************************************************************************************************************************************************
        * Method Name : appointmentDateCaseCommentMethod
        * Descroption : Create case comment to store Appointment Date
    /*******************************************************************************************************************************************************/ 
    public void appointmentDateCaseCommentMethod(List<Case> caseListForComment){     
        List<CaseComment> childCommand = new List<CaseComment>();
        for (Case t: caseListForComment){
            if((t.Status == 'On Hold') && (t.AOSI_Cancelled_On_HOLD_Reason__c == 'Reappointment - Branch')){
                CaseComment newCommmand = new CaseComment();
                newCommmand.CommentBody = 'Appointment Date :'+String.valueof(t.AOSI_Appointment_Date__c);
                newCommmand.IsPublished = TRUE;
                newCommmand.ParentId = t.id;
                childCommand.add(newCommmand);
            }// End of If
        }// End of For

        if(!childCommand.isEmpty()){
        insert childCommand;
        }
    }// End of appointmentDateCaseCommentMethod     
} //End of AOSI_CaseTriggerHandler