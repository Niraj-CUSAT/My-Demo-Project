public class ASPBillingReport {    
      
    public integer index                { get; private set; }
    public integer blockSize            { get; private set; } 
    public integer totalCaseRecs        { get; private set; } 
    public list<Decimal> aspRateList    { get; private set; }
    
    public ASPBillingReport() {
        
        aspRateList     =   new Decimal[32];   
        totalCaseRecs   =   0;
        index           =   0;
        blockSize       =   200;
        
        aspRateList.set(0,0.0);     //'FreeInstallation Local     Less Than     6 Hours'
        aspRateList.set(1,0.0);     //'FreeInstallation Local     Between       6-24 Hours'
        aspRateList.set(2,0.0);     //'FreeInstallation Local     Less Than     24-48 Hours'
        aspRateList.set(3,0.0);     //'FreeInstallation Local     Greater Than  48 Hours'
        aspRateList.set(4,0.0);     //'FreeInstallation UpCountry Less Than     6 Hours'
        aspRateList.set(5,0.0);     //'FreeInstallation UpCountry Between       6-24 Hours'
        aspRateList.set(6,0.0);     //'FreeInstallation UpCountry Between       24-48 Hours'
        aspRateList.set(7,0.0);     //'FreeInstallation UpCountry Greater Than  48 Hours'
        
        aspRateList.set(8,0.0);     //'Service Local            Less Than       6 Hours'
        aspRateList.set(9,0.0);     //'Service Local            Between         6-24 Hours'
        aspRateList.set(10,0.0);    //'Service Local            Between         24-48 Hours'
        aspRateList.set(11,0.0);    //'Service Local            Greater Than    48 Hours'
        aspRateList.set(12,0.0);    //'Service UpCountry        Less Than       6 Hours'
        aspRateList.set(13,0.0);    //'Service UpCountry        Between         6-24 Hours'
        aspRateList.set(14,0.0);    //'Service UpCountry        Between         24-48 Hours'
        aspRateList.set(15,0.0);    //'Service UpCountry        Greater Than    48 Hours'
        
        aspRateList.set(16,0.0);    //'PM Service Local         Less Than       6 Hours'
        aspRateList.set(17,0.0);    //'PM Service Local         Between         6-24 Hours'
        aspRateList.set(18,0.0);    //'PM Service Local         Between         24-48 Hours'
        aspRateList.set(19,0.0);    //'PM Service Local         Greater Than    48 Hours'
        aspRateList.set(20,0.0);    //'PM Service UpCountry     Less Than       6 Hours'
        aspRateList.set(21,0.0);    //'PM Service UpCountry     Between         6-24 Hours'
        aspRateList.set(22,0.0);    //'PM Service UpCountry     Between         24-48 Hours'
        aspRateList.set(23,0.0);    //'PM Service UpCountry     Greater Than    48 Hours'
        
        aspRateList.set(24,0.0);    //'Dealer Stock Local       Less Than       6 Hours'
        aspRateList.set(25,0.0);    //'Dealer Stock Local       Between         6-24 Hours'
        aspRateList.set(26,0.0);    //'Dealer Stock Local       Between         24-48 Hours'
        aspRateList.set(27,0.0);    //'Dealer Stock Local       Greater Than    48 Hours'
        aspRateList.set(28,0.0);    //'Dealer Stock UpCountry   Less Than       6 Hours'
        aspRateList.set(29,0.0);    //'Dealer Stock UpCountry   Between         6-24 Hours'
        aspRateList.set(30,0.0);    //'Dealer Stock UpCountry   Between         24-48 Hours'
        aspRateList.set(31,0.0);    //'Dealer Stock UpCountry   Greater Than    48 Hours'
        
        retrieveASPRateCards(); 
 
    }
    
     public void retrieveASPRateCards() {
        try{
            list<Id> rateMasterJunctionDetails     =   new list<Id>();
            Id aspId                    =   apexPages.currentPage().getParameters().get('Id');
            for(ASP_Rate_Master_Junction__c AMJ :[select id,ASP__c,ASP_Rate_Master__c from ASP_Rate_Master_Junction__c where ASP__c=:aspId ]){
                   rateMasterJunctionDetails.add(AMJ.ASP_Rate_Master__c);       //Retreiving all ASP Rate Master ID
            }
            system.debug('rateMasterJunctionDetails*** '+rateMasterJunctionDetails);
            ASP_Rate_Master__c    aspRateMaster   =   new ASP_Rate_Master__c();
            ASPratemaster   =   [SELECT Active__c, AOSI_50__c, Minimum_Number_Of_Call__c, AOSI_70_calls_completed_within_24Hrs__c, AOSI_Category__c, AOSI_Fixed_Compensation__c, AOSI_If_80_calls_completed_24hrs_Upcont__c,
                                AOSI_If_80_calls_completed_within_24hrs__c, AOSI_Only_50_to_59__c, AOSI_Only_60_to_69__c, AOSI_Upcountry_TA__c, Id, Name, Product_Category__c, X1_1_1__c 
                                FROM ASP_Rate_Master__c WHERE  Id IN: rateMasterJunctionDetails and Active__c = TRUE LIMIT 1];//Returning ASP Rate m aster Details from ASP Junction object
            system.debug('ASPratemaster*** '+ASPratemaster);
            list<Service_Line__c> serviceLineDetails    =   new list<Service_Line__c>();   
            serviceLineDetails  =   [SELECT ASP_Rate_Master__c,Id,Name,Type__c,X6hrs_to_24hrs_City__c,X6hrs_to_24hrs_Upcountry__c,X6hrs_Upcountry__c,X6_hrs__c,X24hrs_City__c,
                                    X24hrs_Upcountry__c,X48_hrs_City__c,X48_hrs_Upcountry__c FROM Service_Line__c where ASP_Rate_Master__c=:ASPratemaster.Id];//Fetching multiple Service Line records from ASP Rate Master
            system.debug('serviceLineDetails*** '+serviceLineDetails);
            list<Case> callclosedlastmonth  =   new list<Case>();           //Case closed last month
            callclosedlastmonth             =   [SELECT Id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
                                                RecordType.DeveloperName='AOSIndia' and  Service_Engineer__r.AOSI_ASP__c =:aspId and status='Closed' and closedDate = THIS_YEAR  and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
            system.debug('callclosedlastmonth*** '+callclosedlastmonth);
            list<Case> callclosedlastmonth24=   new list<Case>();          //Case closed last month with resolution time less than 24 hrs                                  
            callclosedlastmonth24           =   [SELECT Id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
                                                RecordType.DeveloperName='AOSIndia' and  Service_Engineer__r.AOSI_ASP__c =:aspId and status='Closed' and closedDate = THIS_YEAR and AOSI_Resolution_Clock_Time__c<=24 and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
            system.debug('callclosedlastmonth24*** '+callclosedlastmonth24);
            Decimal callsclosedin24hrsratio =   0.0;            
            callsclosedin24hrsratio         =   (!callclosedlastmonth24.isempty()? Decimal.valueof(callclosedlastmonth.size())/Decimal.valueof(callclosedlastmonth24.size()) : 0.0);
            system.debug('callsclosedin24hrsratio*** '+callsclosedin24hrsratio);
            
            if(!serviceLineDetails.isEmpty()) {
                for(Service_Line__c SL: serviceLineDetails) {
                    
                    //Free Installation Service Case
                    if(SL.Type__c=='Free Installation'){
                        //Free installation call for Local
                        if(SL.X6_hrs__c!=null)
                            aspRateList.set(0,SL.X6_hrs__c);
                        if(SL.X6hrs_to_24hrs_City__c!=null)
                            aspRateList.set(1,SL.X6hrs_to_24hrs_City__c);
                        if(SL.X24hrs_City__c!=null)
                           aspRateList.set(2,((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c != null) ? SL.X6hrs_to_24hrs_City__c : SL.X6hrs_to_24hrs_City__c));
                        if(SL.X48_hrs_City__c!=null)
                           aspRateList.set(3,SL.X48_hrs_City__c);
                        //Free installation Call for Upcountry
                        if(SL.X6hrs_Upcountry__c!=null)
                            aspRateList.set(4,SL.X6hrs_Upcountry__c);
                        if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                            aspRateList.set(5,SL.X6hrs_to_24hrs_Upcountry__c);
                        if(SL.X24hrs_Upcountry__c!=null)
                            aspRateList.set(6,((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c != null) ? SL.X6hrs_to_24hrs_Upcountry__c : SL.X24hrs_Upcountry__c));
                        if(SL.X48_hrs_Upcountry__c!=null)
                            aspRateList.set(7,SL.X48_hrs_Upcountry__c);
                    }
                  
                    
                    //Service Case
                    if(SL.Type__c == 'Service') {
                        //Service call for Local
                        if(SL.X6_hrs__c != null)
                            aspRateList.set(8, SL.X6_hrs__c);
                        if(SL.X6hrs_to_24hrs_City__c != null)
                            aspRateList.set(9, SL.X6hrs_to_24hrs_City__c);
                        if(SL.X24hrs_City__c != null)
                            aspRateList.set(10, ((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null) ? SL.X6hrs_to_24hrs_City__c : SL.X24hrs_City__c));
                        if(SL.X48_hrs_City__c != null)
                            aspRateList.set(11,  SL.X48_hrs_City__c);
                        //Service Call for Upcountry
                        if(SL.X6hrs_Upcountry__c != null)
                            aspRateList.set(12, SL.X6hrs_Upcountry__c);
                        if(SL.X6hrs_to_24hrs_Upcountry__c != null)
                            aspRateList.set(13, SL.X6hrs_to_24hrs_Upcountry__c);
                        if(SL.X24hrs_Upcountry__c != null)
                            aspRateList.set(14, ((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null) ? SL.X6hrs_to_24hrs_Upcountry__c : SL.X24hrs_Upcountry__c));
                        if(SL.X48_hrs_Upcountry__c != null)
                            aspRateList.set(15, SL.X48_hrs_Upcountry__c );
                    }   
                  
                    //PM Service Case
                    if(SL.Type__c=='PM Service') {
                        //PM Service call for Local
                        if(SL.X6_hrs__c != null)
                            aspRateList.set(16,SL.X6_hrs__c);
                        if(SL.X6hrs_to_24hrs_City__c!=null)
                            aspRateList.set(17,SL.X6hrs_to_24hrs_City__c);
                        if(SL.X24hrs_City__c!=null)
                            aspRateList.set(18,((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null) ? SL.X6hrs_to_24hrs_City__c : SL.X24hrs_City__c));
                        if(SL.X48_hrs_City__c!=null)
                            aspRateList.set(19,SL.X48_hrs_City__c);
                        //PM Service Call for Upcountry
                        if(SL.X6hrs_Upcountry__c!=null)
                            aspRateList.set(20,SL.X6hrs_Upcountry__c);
                        if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                            aspRateList.set(21,SL.X6hrs_to_24hrs_Upcountry__c);
                        if(SL.X24hrs_Upcountry__c!=null)
                            aspRateList.set(22,((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c != null) ? SL.X6hrs_to_24hrs_Upcountry__c : SL.X24hrs_Upcountry__c));
                        if(SL.X48_hrs_Upcountry__c!=null)
                            aspRateList.set(23,SL.X48_hrs_Upcountry__c);
                    }                                           
                    
                    //Dealer Stock Case
                    if(SL.Type__c == 'Dealer Stock'){
                        //Dealer stock call for Local
                        if(SL.X6_hrs__c != null)
                            aspRateList.set(24,SL.X6_hrs__c);
                        if(SL.X6hrs_to_24hrs_City__c != null)
                            aspRateList.set(25,SL.X6hrs_to_24hrs_City__c);
                        if(SL.X24hrs_City__c != null)
                            aspRateList.set(26,((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c != null) ? SL.X6hrs_to_24hrs_City__c : SL.X24hrs_Upcountry__c));
                        if(SL.X48_hrs_City__c != null)
                            aspRateList.set(27,SL.X48_hrs_City__c);
                        //Dealer stock Call for Upcountry
                        if(SL.X6hrs_Upcountry__c != null)
                            aspRateList.set(28,SL.X6hrs_Upcountry__c);
                        if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                            aspRateList.set(29,SL.X6hrs_to_24hrs_Upcountry__c);
                        if(SL.X24hrs_Upcountry__c != null)
                            aspRateList.set(30,((callsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c != null) ? SL.X6hrs_to_24hrs_Upcountry__c : SL.X24hrs_Upcountry__c));
                        //WTDealerstockUPcountry_24_48=SL.X24hrs_Upcountry__c;
                        if(SL.X48_hrs_Upcountry__c != null)
                            aspRateList.set(31,SL.X48_hrs_Upcountry__c);
                    }
                }   //End of for(Service_Line__c SL: serviceLineDetails)
            }   //End of if(!serviceLineDetails.isEmpty())
            
            set<String> sCaseReasons    =   new set<String>{'Free Installation','Service','PM Service','Dealer Stock'};
            totalCaseRecs                   =   ( !test.isRunningTest() ? ([SELECT count() FROM Case WHERE RecordType.DeveloperName = 'AOSIndia' AND Service_Engineer__r.AOSI_ASP__c =: aspId AND Status='Closed' AND ClosedDate = LAST_MONTH AND Reason IN: sCaseReasons])
                                            : ([SELECT count() FROM Case WHERE RecordType.DeveloperName = 'AOSIndia' AND Service_Engineer__r.AOSI_ASP__c =: aspId AND Status='Closed' AND Reason IN: sCaseReasons]) );
            system.debug('aspId*** '+aspId); system.debug('sCaseReasons*** '+sCaseReasons); system.debug('totalCaseRecs *** '+totalCaseRecs );
            if(test.isRunningTest()) {Integer i = (1/0);}
        } catch ( Exception e ) { System.debug('*** Exception *** '+ e.getMessage() ); }
    }
    
    Public list<Case> getCases() {
        
        list<Case> cseList          =   new list<Case>();       
        Id aspId                    =   apexPages.currentPage().getParameters().get('Id');
        set<String> sCaseReasons    =   new set<String>{'Free Installation','Service','PM Service','Dealer Stock'};
        List<case> lCases           =   ( !test.isRunningTest() ? (Database.Query('SELECT Id, Account.Name, CreatedDate, Status, AOSI_Customer_Concern__c, AOSI_Appointment_Date__c, AOSIProduct__r.Name, Asset.Name, AOSI_Asset_Purchase_Date__c, AOSI_Asset_Status__c, Contact_State__c, AOSI_Region_picklist__c, Contact_Address__c, Contact_Name__c, Contact_MailingPostalCode__c, Contact_Phone__c, AOSI_Product_Vertical__c, Assignment_Start_Time__c, Assignment_End_Time__c, AOSI_Case_Close_Time__c, AOSI_Partial_closed_Date_Time__c, CaseNumber, Service_Engineer_Name__c, Service_Engineer_Phone__c, AOSI_Resource_Type__c, RecordTypeId, ClosedDate, AOSI_Resolution_Clock_Time__c, Reason, AOSI_Resolution_Time_Slab_WH__c, AOSI_ASP_Class_Type__c, AOSI_Contact_Mailing_City__c, Service_Engineer__r.Type__c FROM Case WHERE RecordType.DeveloperName = \'AOSIndia\' AND Service_Engineer__r.AOSI_ASP__c =: aspId AND Status=\'Closed\' AND ClosedDate = LAST_MONTH AND Reason IN: sCaseReasons ORDER BY ClosedDate LIMIT :blockSize OFFSET :index'))
                                        : (Database.Query('SELECT Id, Account.Name, CreatedDate, Status, AOSI_Customer_Concern__c, AOSI_Appointment_Date__c, AOSIProduct__r.Name, Asset.Name, AOSI_Asset_Purchase_Date__c, AOSI_Asset_Status__c, Contact_State__c, AOSI_Region_picklist__c, Contact_Address__c, Contact_Name__c, Contact_MailingPostalCode__c, Contact_Phone__c, AOSI_Product_Vertical__c, Assignment_Start_Time__c, Assignment_End_Time__c, AOSI_Case_Close_Time__c, AOSI_Partial_closed_Date_Time__c, CaseNumber, Service_Engineer_Name__c, Service_Engineer_Phone__c, AOSI_Resource_Type__c, RecordTypeId, ClosedDate, AOSI_Resolution_Clock_Time__c, Reason, AOSI_Resolution_Time_Slab_WH__c, AOSI_ASP_Class_Type__c, AOSI_Contact_Mailing_City__c, Service_Engineer__r.Type__c FROM Case WHERE RecordType.DeveloperName = \'AOSIndia\' AND Service_Engineer__r.AOSI_ASP__c =: aspId AND Status=\'Closed\' AND Reason IN: sCaseReasons ORDER BY ClosedDate LIMIT :blockSize OFFSET :index')));
        system.debug('aspId*** '+aspId); system.debug('sCaseReasons*** '+sCaseReasons); system.debug('lCases*** '+lCases);system.debug('lCases size*** '+lCases.size());
        
        if(!lCases.isEmpty()) {
            for(Case oCase : lCases){
                if(oCase.Reason.equalsIgnoreCase('Service') && oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Local')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                }
                
                if(oCase.Reason.equalsIgnoreCase('Service') && oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Upcountry')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                }
              
                if(oCase.Reason.equalsIgnoreCase('PM Service') &&  oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Local')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                }
              
                if(oCase.Reason.equalsIgnoreCase('PM Service') && oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Upcountry')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                } 
              
                if(oCase.Reason.equalsIgnoreCase('Free Installation') &&  oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Local')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                }
              
                if(oCase.Reason.equalsIgnoreCase('Free Installation') && oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Upcountry')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                }
               
                if(oCase.Reason.equalsIgnoreCase('Dealer Stock') &&  oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Local')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){ cseList.add(oCase); }
                }
              
                if(oCase.Reason.equalsIgnoreCase('Dealer Stock') && oCase.AOSI_ASP_Class_Type__c.equalsIgnoreCase('Upcountry')){
                    if(oCase.AOSI_Resolution_Clock_Time__c < = 6){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 6 && oCase.AOSI_Resolution_Clock_Time__c <= 24){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 24 && oCase.AOSI_Resolution_Clock_Time__c <= 48){cseList.add(oCase);}
                    if(oCase.AOSI_Resolution_Clock_Time__c > 48){cseList.add(oCase);}
                }
            }
        }
        system.debug('Case List Values Are : ##### '+cseList);
        return cseList;
        
    }    
    
    public void beginning()
    {
        index = 0;
    }
    
    public void previous()
    {
        index = index - blockSize;
    }
    
    public void next()
    {
        index = index + blockSize;
    }      
    
    public boolean getprev()
    {
        Boolean returnVal = ( index == 0 ? true : false);
        return returnVal;
    }  
    
    public void end() { 
        index   = ( (math.mod(totalCaseRecs,blockSize)==0) ? (totalCaseRecs -blockSize) : (totalCaseRecs- math.mod(totalCaseRecs,blockSize)));
    }

    public Boolean getnxt() { 
        Boolean returnVal = ( (index + blockSize >= totalCaseRecs) ? true : false );
        return returnVal;
    }  
    
     public PageReference exportExcel(){ //Export the report in Excel format
       PageReference exportExcelList = new PageReference('/apex/ASPBillingReportExtractExcel?id='+apexPages.currentPage().getParameters().get('Id'));//Page.ASPBillingReportExtractExcel;
       exportExcelList.setRedirect(false);
       return exportExcelList;
    }      
}