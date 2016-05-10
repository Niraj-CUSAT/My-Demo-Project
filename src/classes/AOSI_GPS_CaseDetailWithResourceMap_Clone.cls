/*********************************************************
@ClassName      :   AOSI_GPS_CaseDetailWithResourceMap_Clone
@CreatedDate    :   17-03-2016
@Description    :   Display the all open cases on vf-page.
**********************************************************/ 
public with sharing class AOSI_GPS_CaseDetailWithResourceMap_Clone{
    //Variable
    public Integer intAvailableRes                                                                      { get; set; }               // Count total no.of available resources.
    public Case objSelectedCase                                                                         { get; set; }       // To get selected case details on resource and map page.
    public List<Service_Engineer__c> lstResources                                                       { get; set; }       // List of filtered resources.
    public List<wrapperResourceDetails> lstWrapperOfResourceDetails                                     { get; set; }       // To get selected case details.
    public List<wrapperResourceCaseDetails> lstWrapperOfResourceCaseDetails                             { get; set; }           // To bind Cases with related Resource.
    
    //For pop-up select option 
    public List<SelectOption> lstAvailableResource                                                      { get; set; }
    public String strSelectedResource                                                                   { get; set; }
    public Map<Id,String> mapAvailableResource                                                          { get; set; }   
        
    /************ Constructor ************/
    public AOSI_GPS_CaseDetailWithResourceMap_Clone(){
        //Initialization
        Boolean flag                                        = false;
        intAvailableRes                                     = 0;
        lstResources                                        = new List<Service_Engineer__c>();
        lstAvailableResource                                = new List<SelectOption>();        
        String strCaseId                                    = ApexPages.currentPage().getParameters().get('caseId'); 
        String strFlag                                      = ApexPages.currentPage().getParameters().get('flag'); 
        mapAvailableResource = new Map<Id, String>();
        system.debug('*********Constructor*********str*********************'+strFlag);
        
        //Setting flag to identify that is updated with resource from Case detail page.
        if(strFlag != NULL){
            flag = true;
        }
        
        lstWrapperOfResourceDetails         = new List<wrapperResourceDetails>(); 
        lstWrapperOfResourceCaseDetails = new List<wrapperResourceCaseDetails>();
        
        objSelectedCase = [Select Id, CaseNumber, Contact_Phone__c, Contact.Name, Contact.Email, Contact.MailingCity, Contact.Pincode__c, Contact.MailingPostalCode, Status, 
                           Type, Reason, AOSI_Region__c, Service_Engineer__c, Service_Engineer__r.Name, AOSI_Appointment_Date__c, AOSI_Product_Vertical__c, AOSIProduct__r.Name 
                           From Case Where Id =: strCaseId];
        
        bindResourceAndCaseToWrapper(flag, null);           //Binding resources and cases with wrapper on page load (when resource not selected on GPS Page).
        
        system.debug('objSelectedCase::::::: ' + objSelectedCase);
        system.debug('lstResources::::::: ' + lstResources);
    }
    
    /********* Helping method to get resources ***********/
    private void bindResourceAndCaseToWrapper(Boolean isResourceUpdated, String strSelectedResId){
            
        intAvailableRes = 0;                                                                                                                    //Resetting the count of resources.
        List<Service_Engineer__c> lstTempResources = new List<Service_Engineer__c>();       //Temporary list
        Set<String> setProducts = new Set<String>{'Water Heater; Water Treatment'};         //Set of products, case belonging to
        setProducts.add(objSelectedCase.AOSI_Product_Vertical__c);
        
        if(isResourceUpdated){
            system.debug('isResourceUpdated:::T::: ' + isResourceUpdated);
            //Clearing all list because of to show only details of selected resource on GPS Page.
            lstTempResources.clear();
            lstResources.clear();
            lstWrapperOfResourceDetails.clear();
            lstWrapperOfResourceCaseDetails.clear();
            
            //Getting resource where Resource is updating manualy from GPS page.
            lstTempResources = [Select Id, Name, PIN_Code__c, Region__c, AOSI_ASP__r.AOSI_Product_Category__c, Type__c,
                               (Select Id From Attendance__r Where  AOSI_Present__c = true ),
                               (Select Id, CaseNumber, AOSI_Appointment_Date__c From Cases__r) 
                              From Service_Engineer__c 
                              Where Id =: objSelectedCase.Service_Engineer__c];
        }
        else{
            system.debug('isResourceUpdated:::F:::: ' + isResourceUpdated);
            //Getting resource on load of page where Resource is not updating manualy from GPS page
            lstTempResources = [Select Id, Name, PIN_Code__c, Region__c, AOSI_ASP__r.AOSI_Product_Category__c, Type__c,
                               (Select Id From Attendance__r Where  AOSI_Present__c = true ),
                               (Select Id, CaseNumber, AOSI_Appointment_Date__c From Cases__r)  //Where Status =: 'Open' Or Status =: 'On Hold'
                              From Service_Engineer__c 
                              Where PIN_Code__c =: objSelectedCase.Contact.MailingPostalCode AND AOSI_ASP__r.AOSI_Product_Category__c IN: setProducts And PIN_Code__c != Null]; //PIN_Code__c =: objSelectedCase.Contact.MailingPostalCode AND AOSI_ASP__r.AOSI_Product_Category__c IN: setProducts And
        }
        
        system.debug('lstTempResources>>>>>>> ' + lstTempResources);
        for(Service_Engineer__c objResource : lstTempResources){
            //Resource should be present to dispaly on map.
            if(objResource.Attendance__r.size() > 0){
                lstResources.add(objResource);
                mapAvailableResource.put(objResource.Id, objResource.Name);
                lstAvailableResource.add(new SelectOption(objResource.Id, objResource.Name));
                
                intAvailableRes++;
                //Getting those resources which having cases to display in Scheduler table.
                lstWrapperOfResourceDetails.add(new wrapperResourceDetails(objResource));
                if(objResource.Cases__r.size() > 0 && objResource.Cases__r.size() < 10){
                    //lstWrapperOfResourceDetails.add(new wrapperResourceDetails(objResource));
                    for(Case objCase : objResource.Cases__r){
                        lstWrapperOfResourceCaseDetails.add(new wrapperResourceCaseDetails(objCase, objResource.Id));
                    }
                }
                //Getting those resources which not having cases to display in Scheduler table.
                else{
                    lstWrapperOfResourceCaseDetails.add(new wrapperResourceCaseDetails(objResource.Id));
                }
            }
        }
        system.debug('---11111--lstResources------' + lstResources);
        system.debug('---22222--lstWrapperOfResourceDetails------' + lstWrapperOfResourceDetails);
        system.debug('---33333--lstWrapperOfResourceCaseDetails------' + lstWrapperOfResourceCaseDetails);
    }
    
    /*
    MethodName  :   getResourceDetails
    Param       :   None
    Desc        :   Get all resource details based on criterias.
    */
    public String getResourceDetails(){
        system.debug('------getResourceDetails-----' + JSON.serialize(lstWrapperOfResourceDetails));
        return JSON.serialize(lstWrapperOfResourceDetails);
    }
    
    /*
    MethodName  :   getResourceCaseDetails
    Param       :   None
    Desc        :   Get all cases details based on related to resource.
    */
    public String getResourceCaseDetails(){
        system.debug('------getResourceCaseDetails------' + JSON.serialize(lstWrapperOfResourceCaseDetails));
        return JSON.serialize(lstWrapperOfResourceCaseDetails);
    }
    
    /*
    MethodName  :   saveCaseWithResource
    Param       :   None
    Desc        :   Save GPS Page case with updated resource.
    */
    public PageReference saveCaseWithResource(){
        PageReference curentGPSPage;    // = new PageReference('/apex/AOSI_GPS_CaseDetailWithResourMap_Clone?caseId='+ objSelectedCase.Id + '&flag=true');
        system.debug('::::::: CurrentPage ::::::::> ' + ApexPages.currentPage().getParameters().get('caseId'));
        try{
            Service_Engineer__c objSelectedResource;
            
            if(! String.isBlank(objSelectedCase.Service_Engineer__c)){
                objSelectedResource = [Select Id, Name, AOSI_City__c From Service_Engineer__c Where Id =: objSelectedCase.Service_Engineer__c];                         
                        
                        //Update case with resource only when City Name of resource and the Case Contact's City is matching.
                if(objSelectedCase.Contact.MailingCity.equalsIgnoreCase(objSelectedResource.AOSI_City__c)){
                        update objSelectedCase;
                        curentGPSPage = new PageReference('/apex/AOSI_GPS_CaseDetailWithResourMap_Clone?caseId='+ objSelectedCase.Id + '&flag=true');
                        curentGPSPage.setRedirect(true);
                        return curentGPSPage;
                }
                else{
                        //curentGPSPage = new PageReference('/apex/AOSI_GPS_CaseDetailWithResourceAndMap?caseId='+ objSelectedCase.Id);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Sorry Selected resource city is not matching with case contact\'s city !!'));
                        return null;
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please provide resource !!'));
                return null;
            }
        }
        catch(DmlException ex){
            system.debug('----ex---' + ex);
            objSelectedCase.Service_Engineer__c = null;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
            return null;
        }
        //System.currentPageReference().getParameters().put('caseId', objSelectedCase.Id);
    }
    
    /*
    Use it for POP Save functionality
    MethodName  :   saveCaseByPopDetails
    Param       :   None
    Desc        :   Save GPS Page case with updated value on pop as event.
    */
    public PageReference saveCaseByPopDetails(){                                                     //(String strStartDate, String strDescription, String strSelectedResId){
        system.debug('------saveCaseWithResource----' + objSelectedCase.Service_Engineer__c );
        String strAppDate                                   = ApexPages.currentPage().getParameters().get('appDate');
        String strDescription                               = ApexPages.currentPage().getParameters().get('description');
        String strSelectedResId                             = ApexPages.currentPage().getParameters().get('resId');
        
        PageReference curentGPSPage;
        system.debug('------strAppDate----' + strAppDate );
        system.debug('------strDescription----' + strDescription);
        system.debug('------strSelectedResId----' + strSelectedResId);
        
        try{
            Datetime dtAppointment = getFormattedAppDate(strAppDate);
            Date todayDate = system.today();
             
            system.debug('------dtAppointment-1111---' + dtAppointment);
            
            //appointment datetime should be future/current.
            if(dtAppointment >= system.now()){
                system.debug('------dtAppointment----' + dtAppointment);
                Boolean isUpdateCaseAppDate = true;
                //Getting Cases of Resource which appointment datet
                Service_Engineer__c objRes = [Select Id, Name, PIN_Code__c, Region__c, AOSI_ASP__r.AOSI_Product_Category__c, Type__c,
                                                (Select Id From Attendance__r Where  AOSI_Present__c = true ),
                                                (Select Id, CaseNumber, AOSI_Appointment_Date__c From Cases__r Where (Status =: 'Open' Or Status =: 'On Hold') And  AOSI_Appointment_Date__c >=: todayDate) 
                                              From Service_Engineer__c Where Id =: strSelectedResId];
                if(objRes != null){
 
                    if(objRes.Cases__r.size() < 10){
 
                        for(Case objCase : objRes.Cases__r){
                            //Case appointment time(2.30 hrs, -2.30 hrs) should not matched in pop-up time
                            system.debug('---->objCase.AOSI_Appointment_Date__c: ' + objCase.AOSI_Appointment_Date__c);
                            if( objCase.AOSI_Appointment_Date__c != null && (objCase.AOSI_Appointment_Date__c.addMinutes(150) > dtAppointment && objCase.AOSI_Appointment_Date__c.addMinutes(-150) < dtAppointment)){
                                isUpdateCaseAppDate = false;
                                break;
                            }
                        }
                    }
                    else{
                        bindResourceAndCaseToWrapper(false, objSelectedCase.Id);
                        
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Resource is already assigned for the given time, please check with some other time !!'));
                        return null;
 
                    }
                }
                 
                if(isUpdateCaseAppDate){
                    system.debug('---->IF isUpdateCaseAppDate: ' + isUpdateCaseAppDate);
                    system.debug('---->IF BA objSelectedCase: ' + objSelectedCase);
 
 
                    //Updating selected unassigned open case as an event from POPUp
                    objSelectedCase.AOSI_Appointment_Date__c = dtAppointment;
                    objSelectedCase.Service_Engineer__c      = strSelectedResId;
                    objSelectedCase.AOSI_Comment_Resource__c = strDescription;
 
                    system.debug('---->IF AA objSelectedCase: ' + objSelectedCase);
                    update objSelectedCase;
                    
                    curentGPSPage = new PageReference('/apex/AOSI_GPS_CaseDetailWithResourMap_Clone?caseId='+ objSelectedCase.Id + '&flag=true');
                    curentGPSPage.setRedirect(true);
                    return curentGPSPage;
                }
                else{
                    system.debug('---->ELSE isUpdateCaseAppDate: ' + isUpdateCaseAppDate);
                    system.debug('---->ELSE objSelectedCase: ' + objSelectedCase);
                    
                    //bindResourceAndCaseToWrapper(false, objSelectedCase.Service_Engineer__c);
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Resource is already assigned for the given time, please check with some other time !!'));
                }
            }
            else{
                //bindResourceAndCaseToWrapper(false, objSelectedCase.Service_Engineer__c);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Appointment date and time should be future/present !!'));
            }   
        }
        catch(DMLException ex){
                system.debug('--------Exception-------' + ex);  
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
            //return null;   
        }
        bindResourceAndCaseToWrapper(false, objSelectedCase.Service_Engineer__c);
        return null;
    }
    

        /********Create Datetime value based on given appointment date from Pop-up*******/
    private Datetime getFormattedAppDate(String strAppDate){
        List<String> splitDateAndTime = strAppDate.split(' ');        // It will devide into (Date, Time, AM/PM)
        List<String> splitedDate = splitDateAndTime[0].split('/');    // It will devide into (MM, DD, YYYY)
        List<String> splitHrsMin = splitDateAndTime[1].split(':');    // It will devide into (HH, MM)
        Datetime formattedAppDT; 
        //Datetime newInstance(Integer year, Integer month, Integer day, Integer hour, Integer minute, Integer second)
        Integer intHH = 0;
        if(splitDateAndTime[2].equalsIgnoreCase('PM'))
            intHH = Integer.valueof(splitHrsMin[0].trim()) + 12;
        else
            intHH = Integer.valueof(splitHrsMin[0].trim());
        
        formattedAppDT = Datetime.newInstance(Integer.valueof(splitedDate[2].trim()), Integer.valueof(splitedDate[0].trim()), Integer.valueof(splitedDate[1].trim()), intHH, Integer.valueof(splitHrsMin[1].trim()), 0);
        
        system.debug('strAppDate: ' + strAppDate);
        system.debug('splitDateAndTime: ' + splitDateAndTime);
        system.debug('splitHrsMin: ' + splitHrsMin);
        system.debug('formattedDT fin: ' + formattedAppDT);
        
        return formattedAppDT;
    }

    // Method to get save data from kendo popup.
    @RemoteAction
    public static string updateAccountData(string strJsonDataToUpdate) {
        system.debug('strJsonDataToUpdate.....' + strJsonDataToUpdate);
        String strJsonDataToUpdate1 = strJsonDataToUpdate;

        JSONParser parser = JSON.createParser(strJsonDataToUpdate1);
        //clsJsonData wrap = (clsJsonData)parser.readValueAs(clsJsonData.class);
        
        system.debug('-----Remote Method--------' + parser);
        return null;
    }
    
    /*
    WrapperClass    :   wrapperResourceDetails
    Desc            :   Binding all details related to resource
    */
    public class wrapperResourceDetails{
        //Variables
        public String strResId              { get; set; }
        
        //Testing { text: "Alex", value: 1, color: "#f8a398" }
        public String text                                  { get; set; }           //Map with kendo 'text' attribute as resource name.
        public string value                                 { get; set; }           //Map with kendo 'value' attribute as resource id.
        public string color                                 { get; set; }           //Map with kendo 'value' attribute as resource id.
        
        /********** Constructor ***********/
        public wrapperResourceDetails(Service_Engineer__c objResource){
            strResId   = objResource.Id;
            text    =       objResource.Name;
            value   =       objResource.Id;
        }
    }
    
    /*
    WrapperClass    :   wrapperResourceDetails
    Desc            :   Binding all case details related to a particular resource.
    */
    public class wrapperResourceCaseDetails{
        //Variables
        public String Id                                { get; set; }
        public String strCaseNo                         { get; set; }
        public String strCaseResource                   { get; set; }
        public DateTime dtAppointmentStart              { get; set; }
        public DateTime dtAppointmentEnd                { get; set; }
        public String strCaseAppointmentColor                   { get; set; }
        
        /********* Constructor without case availability **********/
        public wrapperResourceCaseDetails(String strResourceId){
                Id = '';
                strCaseNo = '';
                dtAppointmentStart = System.Now();                              //objCase.AOSI_Appointment_Date__c;
                dtAppointmentEnd = System.Now().addHours(2);    //objCase.AOSI_Appointment_Date__c.addHours(2);
                strCaseResource = strResourceId;
                strCaseAppointmentColor = 'grey';
        }
        
        /********* Constructor with case availability **********/
        public wrapperResourceCaseDetails(Case objCase, String strResourceId){
            Id = objCase.Id;
            strCaseNo = objCase.CaseNumber;
            dtAppointmentStart = (objCase.AOSI_Appointment_Date__c != null ? objCase.AOSI_Appointment_Date__c : System.Now());//objCase.AOSI_Appointment_Date__c;
            dtAppointmentEnd = (objCase.AOSI_Appointment_Date__c != null ? objCase.AOSI_Appointment_Date__c.addHours(2) : System.Now().addHours(2));//objCase.AOSI_Appointment_Date__c.addHours(2);
            strCaseResource = strResourceId;
            
            //Criteria based case highlighting.
            if(objCase.AOSI_Appointment_Date__c >= System.now() && dtAppointmentEnd <= System.now()){ 
            strCaseAppointmentColor = 'green';
            }
            else if(dtAppointmentEnd > System.now()){
                strCaseAppointmentColor = 'yellow';                     
            }
            else if(objCase.AOSI_Appointment_Date__c < System.now()){
                strCaseAppointmentColor = 'red';
            }
            else{
                    strCaseAppointmentColor = 'grey';
            }
        }
    }
}
/******* End Of Class ********/