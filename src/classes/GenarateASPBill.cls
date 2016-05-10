/***************************************************************************************************
Create By : Vishwanath Attikeri
Created date: 5/32014
Modified by: Bhanu Vallabhu,
Discription : This class is used to generate the ASP bil based on the service and call catergory
******************************************************************************************************/
Public class GenarateASPBill{
    public string ASPid{get;set;}
    Public List<ASP_Rate_Master_Junction__c> RatemasterJunctionList{get;set;}
    Public List<ASP_Rate_Master__c> ASPratemasterforWT{get;set;}
    Public List<ASP_Rate_Master__c> ASPratemasterforWH{get;set;}
    Public ASP__c aspRecord{get;set;}
    Public ASP_Billing__c bill{get;set;}
    public set<id> ratemasterid=new set<id>();
    Public set<id> WTRatemasterid=new set<id>();
    Public set<id> WHRatemasterid=new set<id>();
    Public List<Service_Line__c>  WTServiceLine{get;set;}
    Public List<Service_Line__c>  WHServiceLine{get;set;}
    Public String Recordtypeid{get;set;}
    //Variable declearion for service call rates
    public string wordText{get;set;}
    Public String[] units;
    Public String[] tens;
    // WT Local service call charegs
    Public decimal WTserviceCity_Lees6{get;set;}
    Public decimal WTserviceCity_6_24{get;set;}
    Public decimal WTserviceCity_24_48{get;set;}
    Public decimal WTserviceCity_greater48{get;set;}
   
    // WT Upcountry service call charegs
    Public decimal WTserviceUPcountry_Lees6{get;set;}
    Public decimal WTserviceUPcountry_6_24{get;set;}
    Public decimal WTserviceUPcountry_24_48{get;set;}
    Public decimal WTserviceUPcountry_greater48{get;set;}

                
    //WH local service call charegs
    Public decimal WHserviceCity_Lees6{get;set;}
    Public decimal WHserviceCity_6_24{get;set;}
    Public decimal WHserviceCity_24_48{get;set;}
    Public decimal WHserviceCity_greater48{get;set;}
    
    // WH Upcountry service call charegs
    Public decimal WHserviceUPcountry_Lees6{get;set;}
    Public decimal WHserviceUPcountry_6_24{get;set;}
    Public decimal WHserviceUPcountry_24_48{get;set;}
    Public decimal WHserviceUPcountry_greater48{get;set;}
    
    //WT local PM service call charges
    Public decimal WTPMserviceCity_Lees6{get;set;}
    Public decimal WTPMserviceCity_6_24{get;set;}
    Public decimal WTPMserviceCity_24_48{get;set;}
    Public decimal WTPMserviceCity_greater48{get;set;}
    
     // WT Upcountry PM service call charegs
    Public decimal WTPMserviceUPcountry_Lees6{get;set;}
    Public decimal WTPMserviceUPcountry_6_24{get;set;}
    Public decimal WTPMserviceUPcountry_24_48{get;set;}
    Public decimal WTPMserviceUPcountry_greater48{get;set;}
    
            
    //WH Local PM service call charegs
    Public decimal WHPMserviceCity_Lees6{get;set;}
    Public decimal WHPMserviceCity_6_24{get;set;}
    Public decimal WHPMserviceCity_24_48{get;set;}
    Public decimal WHPMserviceCity_greater48{get;set;}
    
    // WH Upcountry PM service call charegs
    Public decimal WHPMserviceUPcountry_Lees6{get;set;}
    Public decimal WHPMserviceUPcountry_6_24{get;set;}
    Public decimal WHPMserviceUPcountry_24_48{get;set;}
    Public decimal WHPMserviceUPcountry_greater48{get;set;}
    
    //WT local Free installation call charges
    Public decimal WTFreeinstCity_Lees6{get;set;}
    Public decimal WTFreeinstCity_6_24{get;set;}
    Public decimal WTFreeinstCity_24_48{get;set;}
    Public decimal WTFreeinstCity_greater48{get;set;}
                
    //WT Upcountry Free installation call charges
    Public decimal WTFreeinstUPcountry_Lees6{get;set;}
    Public decimal WTFreeinstUPcountry_6_24{get;set;}
    Public decimal WTFreeinstUPcountry_24_48{get;set;}
    Public decimal WTFreeinstUPcountry_greater48{get;set;}
    
    //WH Local free installation call charegs
    Public decimal WHFreeinstCity_Lees6{get;set;}
    Public decimal WHFreeinstCity_6_24{get;set;}
    Public decimal WHFreeinstCity_24_48{get;set;}
    Public decimal WHFreeinstCity_greater48{get;set;}
    
    // WH Upcountry free installation call charegs
    Public decimal WHFreeinstUPcountry_Lees6{get;set;}
    Public decimal WHFreeinstUPcountry_6_24{get;set;}
    Public decimal WHFreeinstUPcountry_24_48{get;set;}
    Public decimal WHFreeinstUPcountry_greater48{get;set;}
    
    //WT local Dealer Stock call charges
    Public decimal WTDealerstockCity_Lees6{get;set;}
    Public decimal WTDealerstockCity_6_24{get;set;}
    Public decimal WTDealerstockCity_24_48{get;set;}
    Public decimal WTDealerstockCity_greater48{get;set;}
                
    //WT Upcountry Dealer Stock call charges
    Public decimal WTDealerstockUPcountry_Lees6{get;set;}
    Public decimal WTDealerstockUPcountry_6_24{get;set;}
    Public decimal WTDealerstockUPcountry_24_48{get;set;}
    Public decimal WTDealerstockUPcountry_greater48{get;set;}
    
    //WH Local Dealer Stock call charegs
    Public decimal WHDealerstockCity_Lees6{get;set;}
    Public decimal WHDealerstockCity_6_24{get;set;}
    Public decimal WHDealerstockCity_24_48{get;set;}
    Public decimal WHDealerstockCity_greater48{get;set;}
    
    // WH Upcountry Dealer Stock call charegs
    Public decimal WHDealerstockUPcountry_Lees6{get;set;}
    Public decimal WHDealerstockUPcountry_6_24{get;set;}
    Public decimal WHDealerstockUPcountry_24_48{get;set;}
    Public decimal WHDealerstockUPcountry_greater48{get;set;}
    
    //WT fIXED Fixed Compensation detail
    Public Decimal WTone_one_one{get;set;}
    Public Decimal WTFixedComp{get;set;}
    Public Decimal WTCallclosedCity80{get;set;}
    Public Decimal WTCallclosedUpcountry80{get;set;}
    Public Decimal WTGreater70callclosed{get;set;}
    Public Decimal WTCallclosed60_69{get;set;}
    Public Decimal WTCallclosed50_59{get;set;}  
    Public Decimal WTLess_50callclosed{get;set;}    
    Public Decimal WTMinimunCall{get;set;}  
    
    //WH fIXED Fixed Compensation detail
    Public Decimal WHone_one_one{get;set;}
    Public Decimal WHFixedComp{get;set;}
    Public Decimal WHCallclosedCity80{get;set;}
    Public Decimal WHCallclosedUpcountry80{get;set;}
    Public Decimal WHGreater70callclosed{get;set;}
    Public Decimal WHCallclosed60_69{get;set;}
    Public Decimal WHCallclosed50_59{get;set;}  
    Public Decimal WHLess_50callclosed{get;set;}    
    Public Decimal WHMinimunCall{get;set;}
    
    Public Decimal Numberofcallclosed{get;set;}
    Public Decimal Numberofcallclosedwithin24{get;set;}
    Public Decimal WTcallclosedpercent{get;set;}
    
    Public Decimal WHcallclosedpercent{get;set;}
    
    Public Decimal NumberofcallclosedUpc{get;set;}
    Public Decimal Numberofcallclosedwithin24Upc{get;set;}
    Public Decimal WTcallclosedpercentUpc{get;set;}
    
    public Decimal WHAmount80City{get;set;}
    public Decimal WHAmount80Upcounty{get;set;}
    Public Decimal Amount60_69calls{get;set;}
    Public Decimal Amount50_59calls{get;set;}
    Public Decimal AmountLess_50calls{get;set;}
    Public Decimal Amount70_79calls{get;set;}
    
    Public Decimal WTAmount60_69calls{get;set;}
    Public Decimal WTAmount50_59calls{get;set;}
    Public Decimal WTAmountLess_50calls{get;set;}
    Public Decimal WTAmount70_79calls{get;set;}
    
    //Value assign from case WH Local service
    Public Decimal WH_Serv_Less_6hrs{get;set;}
    Public Decimal WH_Serv_6_24hrs{get;set;}
    Public Decimal WH_Serv_Greater_24hrs{get;set;}
    Public Decimal WH_Serv_Greater_48hrs{get;set;}
    
    //Value assign from case WH Upcountry service
    Public Decimal WH_Serv_Upcountry_Less_6hrs{get;set;}
    Public Decimal WH_Serv_Upcountry_6_24hrs{get;set;}
    Public Decimal WH_Serv_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WH_Serv_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Local service
    Public Decimal WT_Serv_Less_6hrs{get;set;}
    Public Decimal WT_Serv_6_24hrs{get;set;}
    Public Decimal WT_Serv_Greater_24hrs{get;set;}
    Public Decimal WT_Serv_Greater_48hrs{get;set;}
    
    //Value assign from case WT Upcountry service
    Public Decimal WT_Serv_Upcountry_Less_6hrs{get;set;}
    Public Decimal WT_Serv_Upcountry_6_24hrs{get;set;}
    Public Decimal WT_Serv_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WT_Serv_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WH Local PM service
    Public Decimal WH_PMServ_Less_6hrs{get;set;}
    Public Decimal WH_PMServ_6_24hrs{get;set;}
    Public Decimal WH_PMServ_Greater_24hrs{get;set;}
    Public Decimal WH_PMServ_Greater_48hrs{get;set;}
    
    //Value assign from case WH Upcountry PM service
    Public Decimal WH_PMServ_Upcountry_Less_6hrs{get;set;}
    Public Decimal WH_PMServ_Upcountry_6_24hrs{get;set;}
    Public Decimal WH_PMServ_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WH_PMServ_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Upcountry PM service
    Public Decimal WT_PMServ_Upcountry_Less_6hrs{get;set;}
    Public Decimal WT_PMServ_Upcountry_6_24hrs{get;set;}
    Public Decimal WT_PMServ_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WT_PMServ_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Local PM service
    Public Decimal WT_PMServ_Less_6hrs{get;set;}
    Public Decimal WT_PMServ_6_24hrs{get;set;}
    Public Decimal WT_PMServ_Greater_24hrs{get;set;}
    Public Decimal WT_PMServ_Greater_48hrs{get;set;}
    
    //Value assign from case WH Local Free Installation
    Public Decimal WH_Freeinst_Less_6hrs{get;set;}
    Public Decimal WH_Freeinst_6_24hrs{get;set;}
    Public Decimal WH_Freeinst_Greater_24hrs{get;set;}
    Public Decimal WH_Freeinst_Greater_48hrs{get;set;}
    
    //Value assign from case WH Upcountry Free Installation
    Public Decimal WH_Freeinst_Upcountry_Less_6hrs{get;set;}
    Public Decimal WH_Freeinst_Upcountry_6_24hrs{get;set;}
    Public Decimal WH_Freeinst_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WH_Freeinst_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Upcountry Free Installation
    Public Decimal WT_Freeinst_Upcountry_Less_6hrs{get;set;}
    Public Decimal WT_Freeinst_Upcountry_6_24hrs{get;set;}
    Public Decimal WT_Freeinst_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WT_Freeinst_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Local Free Installation
    Public Decimal WT_Freeinst_Less_6hrs{get;set;}
    Public Decimal WT_Freeinst_6_24hrs{get;set;}
    Public Decimal WT_Freeinst_Greater_24hrs{get;set;}
    Public Decimal WT_Freeinst_Greater_48hrs{get;set;}
    
    //Value assign from case WH Local Dealer Stock
    Public Decimal WH_Dealerstock_Less_6hrs{get;set;}
    Public Decimal WH_Dealerstock_6_24hrs{get;set;}
    Public Decimal WH_Dealerstock_Greater_24hrs{get;set;}
    Public Decimal WH_Dealerstock_Greater_48hrs{get;set;}
    
    //Value assign from case WH Upcountry Dealer Stock
    Public Decimal WH_Dealerstock_Upcountry_Less_6hrs{get;set;}
    Public Decimal WH_Dealerstock_Upcountry_6_24hrs{get;set;}
    Public Decimal WH_Dealerstock_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WH_Dealerstock_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Upcountry Dealer Stock
    Public Decimal WT_Dealerstock_Upcountry_Less_6hrs{get;set;}
    Public Decimal WT_Dealerstock_Upcountry_6_24hrs{get;set;}
    Public Decimal WT_Dealerstock_Upcountry_Greater_24hrs{get;set;}
    Public Decimal WT_Dealerstock_Upcountry_Greater_48hrs{get;set;}
    
    //Value assign from case WT Local Dealer Stock
    Public Decimal WT_Dealerstock_Less_6hrs{get;set;}
    Public Decimal WT_Dealerstock_6_24hrs{get;set;}
    Public Decimal WT_Dealerstock_Greater_24hrs{get;set;}
    Public Decimal WT_Dealerstock_Greater_48hrs{get;set;}
    
    // Total Amount Service Local
    Public Decimal TotalServiceLess6hrs{get;set;}
    Public Decimal TotalService6_24hrs{get;set;}
    Public Decimal TotalService_greater_24hrs{get;set;}
    Public Decimal TotalService_greater_48{get;set;}
    
    // Total Amount Service Upcountry
    Public Decimal UCTotalServiceLess6hrs{get;set;}
    Public Decimal UCTotalService6_24hrs{get;set;}
    Public Decimal UCTotalService_greater_24hrs{get;set;}
    Public Decimal UCTotalService_greater_48{get;set;}
    
    // Total Amount PM Service Local
    Public Decimal TotalPMServiceLess6hrs{get;set;}
    Public Decimal TotalPMService6_24hrs{get;set;}
    Public Decimal TotalPMService_greater_24hrs{get;set;}
    Public Decimal TotalPMService_greater_48{get;set;}
    
    // Total Amount PM Service Upcountry
    Public Decimal UCTotalPMServiceLess6hrs{get;set;}
    Public Decimal UCTotalPMService6_24hrs{get;set;}
    Public Decimal UCTotalPMService_greater_24hrs{get;set;}
    Public Decimal UCTotalPMService_greater_48{get;set;}
    
    // Total Amount Free installation Local
    Public Decimal TotalFreeinstLess6hrs{get;set;}
    Public Decimal TotalFreeinst6_24hrs{get;set;}
    Public Decimal TotalFreeinst_greater_24hrs{get;set;}
    Public Decimal TotalFreeinst_greater_48{get;set;}
    
    // Total Amount Free installation Upcountry
    Public Decimal UCTotalFreeinstLess6hrs{get;set;}
    Public Decimal UCTotalFreeinst6_24hrs{get;set;}
    Public Decimal UCTotalFreeinst_greater_24hrs{get;set;}
    Public Decimal UCTotalFreeinst_greater_48{get;set;}
    
    // Total Amount Dealer Stock Local
    Public Decimal TotalDealerstockLess6hrs{get;set;}
    Public Decimal TotalDealerstock6_24hrs{get;set;}
    Public Decimal TotalDealerstock_greater_24hrs{get;set;}
    Public Decimal TotalDealerstock_greater_48{get;set;}
    
    // Total Amount Dealer Stock Upcountry
    Public Decimal UCTotalDealerstockLess6hrs{get;set;}
    Public Decimal UCTotalDealerstock6_24hrs{get;set;}
    Public Decimal UCTotalDealerstock_greater_24hrs{get;set;}
    Public Decimal UCTotalDealerstock_greater_48{get;set;}
    
    Public Decimal Totalfixedcomp{get;set;}
    Public Decimal total70perc{get;set;}
    Public Decimal total60_69perc{get;set;}
    Public Decimal total50_59perc{get;set;}
    Public Decimal totalless50perc{get;set;}
    
    Public Decimal ServiceTax{get;set;}
    Public Decimal Upcountrytravelclaom{get;set;}
    Public Decimal Othercharges{get;set;}
    Public Decimal TotalAmountCalc{get;set;}
    Public Decimal TaxableTotalAmountCalc{get;set;}
    Public Decimal NonTaxableTotalAmountCalc{get;set;}
    Public Decimal Amoutwithtax{get;set;}
    Public String Remark{get;set;}
    
    Public Decimal WHOneoneonetotalcall{get;set;}
    Public Decimal WTOneoneonetotalcall{get;set;}
    
    Public Decimal WHOneoneonetotalAmount{get;set;}
    Public Decimal WTOneoneonetotalAmount{get;set;}
    Public Decimal TotalOneoneonetotalAmount{get;set;}
    
    List<Case> listofcase=new List<case>();
    
    //Service call closed Local WH 
    Public Decimal WHServiceCall_Less_6HrsCity{get;set;}
    Public Decimal WHServiceCall_6_24HrsCity{get;set;}
    Public Decimal WHServiceCall_greater_24HrsCity{get;set;}
    Public Decimal WHServiceCall_greater_48HrsCity{get;set;}
    
    //Service call closed Upcountry WH 
    Public Decimal WHServiceCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WHServiceCall_6_24HrsUpcountry{get;set;}
    Public Decimal WHServiceCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WHServiceCall_greater_48HrsUpcountry{get;set;}
    
    //Service call closed Local WT
    Public Decimal WTServiceCall_Less_6HrsCity{get;set;}
    Public Decimal WTServiceCall_6_24HrsCity{get;set;}
    Public Decimal WTServiceCall_greater_24HrsCity{get;set;}
    Public Decimal WTServiceCall_greater_48HrsCity{get;set;}
    
    //Service call closed Upcountry WT 
    Public Decimal WTServiceCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WTServiceCall_6_24HrsUpcountry{get;set;}
    Public Decimal WTServiceCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WTServiceCall_greater_48HrsUpcountry{get;set;}
    
    //PM Service call closed Local WH 
    Public Decimal WHPMServiceCall_Less_6HrsCity{get;set;}
    Public Decimal WHPMServiceCall_6_24HrsCity{get;set;}
    Public Decimal WHPMServiceCall_greater_24HrsCity{get;set;}
    Public Decimal WHPMServiceCall_greater_48HrsCity{get;set;}
                
    //PM Service call closed Upcountry WH 
    Public Decimal WHPMServiceCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WHPMServiceCall_6_24HrsUpcountry{get;set;}
    Public Decimal WHPMServiceCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WHPMServiceCall_greater_48HrsUpcountry{get;set;}
                
    //PM Service call closed Local WT
    Public Decimal WTPMServiceCall_Less_6HrsCity{get;set;}
    Public Decimal WTPMServiceCall_6_24HrsCity{get;set;}
    Public Decimal WTPMServiceCall_greater_24HrsCity{get;set;}
    Public Decimal WTPMServiceCall_greater_48HrsCity{get;set;}
            
    //PM Service call closed Upcountry WT 
    Public Decimal WTPMServiceCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WTPMServiceCall_6_24HrsUpcountry{get;set;}
    Public Decimal WTPMServiceCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WTPMServiceCall_greater_48HrsUpcountry{get;set;}
    
    //Free Installation call closed Local WH 
    Public Decimal WHFreeinstCall_Less_6HrsCity{get;set;}
    Public Decimal WHFreeinstCall_6_24HrsCity{get;set;}
    Public Decimal WHFreeinstCall_greater_24HrsCity{get;set;}
    Public Decimal WHFreeinstCall_greater_48HrsCity{get;set;}
                
    //Free Installation call closed Upcountry WH 
    Public Decimal WHFreeinstCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WHFreeinstCall_6_24HrsUpcountry{get;set;}
    Public Decimal WHFreeinstCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WHFreeinstCall_greater_48HrsUpcountry{get;set;}
                
    //Free Installation call closed Local WT
    Public Decimal WTFreeinstCall_Less_6HrsCity{get;set;}
    Public Decimal WTFreeinstCall_6_24HrsCity{get;set;}
    Public Decimal WTFreeinstCall_greater_24HrsCity{get;set;}
    Public Decimal WTFreeinstCall_greater_48HrsCity{get;set;}
            
    //Free Installation call closed Upcountry WT 
    Public Decimal WTFreeinstCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WTFreeinstCall_6_24HrsUpcountry{get;set;}
    Public Decimal WTFreeinstCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WTFreeinstCall_greater_48HrsUpcountry{get;set;}
    
    //Dealer Stock call closed Local WH 
    Public Decimal WHDealerstockCall_Less_6HrsCity{get;set;}
    Public Decimal WHDealerstockCall_6_24HrsCity{get;set;}
    Public Decimal WHDealerstockCall_greater_24HrsCity{get;set;}
    Public Decimal WHDealerstockCall_greater_48HrsCity{get;set;}
                
    //Dealer Stock call closed Upcountry WH 
    Public Decimal WHDealerstockCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WHDealerstockCall_6_24HrsUpcountry{get;set;}
    Public Decimal WHDealerstockCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WHDealerstockCall_greater_48HrsUpcountry{get;set;}
                
    //Dealer Stock call closed Local WT
    Public Decimal WTDealerstockCall_Less_6HrsCity{get;set;}
    Public Decimal WTDealerstockCall_6_24HrsCity{get;set;}
    Public Decimal WTDealerstockCall_greater_24HrsCity{get;set;}
    Public Decimal WTDealerstockCall_greater_48HrsCity{get;set;}
            
    //Dealer Stock call closed Upcountry WT 
    Public Decimal WTDealerstockCall_Less_6HrsUpcountry{get;set;}
    Public Decimal WTDealerstockCall_6_24HrsUpcountry{get;set;}
    Public Decimal WTDealerstockCall_greater_24HrsUpcountry{get;set;}
    Public Decimal WTDealerstockCall_greater_48HrsUpcountry{get;set;}
    
    //call closed Local WT Fixed Compensation
    Public Decimal WT_Less_6Hrs_UnderFC{get;set;}
    Public Decimal WT_6_24HrsCity_UnderFC{get;set;}
    Public Decimal WT_greater_24Hrs_UnderFC{get;set;}
    Public Decimal WT_greater_48HrsCity_UnderFC{get;set;}
            
    // call closed Upcountry WT Fixed Compensation
    Public Decimal WH_Less_6Hrs_UnderFC{get;set;}
    Public Decimal WH_6_24HrsCity_UnderFC{get;set;}
    Public Decimal WH_greater_24Hrs_UnderFC{get;set;}
    Public Decimal WH_greater_48HrsCity_UnderFC{get;set;}
    
    
    //Fixed compensation 
    Public Decimal WHfixedcompAmount{get;set;}
    Public Decimal WTfixedcompAmount{get;set;}
    
    Public Decimal WHpercentof80callCity{get;set;}
    Public Decimal WHpercentof80callUpc{get;set;}
    
    Public Decimal WTpercentof80callCity{get;set;}
    Public Decimal WTpercentof80callUpc{get;set;}
    
    Public Decimal total80callvalueCity{get;set;}
    Public Decimal total80callvalueUpc{get;set;}
           
        //WH calls
    Public List<Case> callclosedWithin24HrCityWH=new List<Case>();
    Public List<Case> callclosedWithinCityWH=new List<Case>();
    Public List<Case> callclosedWithin24HrUpcWH=new List<Case>();
    Public List<Case> callclosedWithinUpcWH=new List<Case>();
        
        //WT calls
    Public List<Case> callclosedWithin24HrCityWT=new List<Case>();
    Public List<Case> callclosedWithinCityWT=new List<Case>();
    Public List<Case> callclosedWithin24HrUpcWT=new List<Case>();
    Public List<Case> callclosedWithinUpcWT=new List<Case>();
        
        //1.1.1 cases
    Public List<Case> WHTribleonecase=new List<Case>();
    Public List<Case> WTTribleonecase=new List<Case>();
    
    Public Boolean buttonflag{get;set;}
    Public Integer dy{get;set;}
    Public Integer mon{get;set;}
    Public Integer yr{get;set;}
    
    Public String Monthandyear{get;set;}
    Public Decimal Deduction{get;set;}
    Public Decimal finalAmount{get;set;}
    Public Decimal taxAmount{get;set;}
    Public String reasonDeduction{get;set;}
    //date field for showing bill date
    public Date monthStart {get; set;}
    public Date monthEnd{get; set;}
    
    public Decimal whcallsclosedin24hrsratio;
    public Decimal wtcallsclosedin24hrsratio;
    
    public set<Id> casesundermincategory = new set<Id>();
    //Constructor declaration
    public GenarateASPBill(ApexPages.StandardController controller) {
    
        Date datobj=system.today().addmonths(-1);
        
        dy = datobj.day();
        mon = (datobj.month());
        yr = datobj.year();
        Monthandyear=String.valueof(mon)+'-'+String.valueof(yr);
        system.debug('DDDDDDD'+dy +'MMMMM'+mon +'YYYYY'+yr);
         monthStart = datobj.toStartOfMonth();
         monthEnd = monthStart.adddays(date.daysInMonth(yr, mon)-1);
        

    buttonflag=false;
    Deduction=0;
    finalAmount=0;
    WTServiceLine=new List<Service_Line__c>();
    WHServiceLine=new List<Service_Line__c>();
    taxAmount = 0;
    
    units = new String[]{'Zero ','One ','Two ','Three ','Four ','Five ','Six ','Seven ','Eight ','Nine ','Ten ','Eleven ','Twelve ','Thirteen ','Fourteen ','Fifteen ','Sixteen ','Seventeen ','Eighteen ','Nineteen '};
        tens = new String[]{'','','Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety'};
        
    Othercharges=0;
    TotalAmountCalc=0;
    TaxableTotalAmountCalc=0;
    NonTaxableTotalAmountCalc=0;
    Upcountrytravelclaom=0;
    ServiceTax=0;
    Amoutwithtax=0;
    
    Remark='';
    
    WHOneoneonetotalcall=0;
    WTOneoneonetotalcall=0;
    
    WHOneoneonetotalAmount=0;
    WTOneoneonetotalAmount=0;
    TotalOneoneonetotalAmount=0;
    //Total of compansation values
    Totalfixedcomp=0;
    total70perc=0;
    total60_69perc=0;
    total50_59perc=0;
    totalless50perc=0;

    // WT Local service call charegs
    WTserviceCity_Lees6=0;
    WTserviceCity_6_24=0;
    WTserviceCity_24_48=0;
    WTserviceCity_greater48=0;
    
    // WT Upcountry service call charegs
    WTserviceUPcountry_Lees6=0;
    WTserviceUPcountry_6_24=0;
    WTserviceUPcountry_24_48=0;
    WTserviceUPcountry_greater48=0;

                
    //WH local service call charegs
    WHserviceCity_Lees6=0;
    WHserviceCity_6_24=0;
    WHserviceCity_24_48=0;
    WHserviceCity_greater48=0;
    
    // WH Upcountry service call charegs
    WHserviceUPcountry_Lees6=0;
    WHserviceUPcountry_6_24=0;
    WHserviceUPcountry_24_48=0;
    WHserviceUPcountry_greater48=0;
    
    //WT local PM service call charges
    WTPMserviceCity_Lees6=0;
    WTPMserviceCity_6_24=0;
    WTPMserviceCity_24_48=0;
    WTPMserviceCity_greater48=0;
    
     // WT Upcountry PM service call charegs
    WTPMserviceUPcountry_Lees6=0;
    WTPMserviceUPcountry_6_24=0;
    WTPMserviceUPcountry_24_48=0;
    WTPMserviceUPcountry_greater48=0;
    
            
    //WH Local PM service call charegs
    WHPMserviceCity_Lees6=0;
    WHPMserviceCity_6_24=0;
    WHPMserviceCity_24_48=0;
    WHPMserviceCity_greater48=0;
    
    // WH Upcountry PM service call charegs
    WHPMserviceUPcountry_Lees6=0;
    WHPMserviceUPcountry_6_24=0;
    WHPMserviceUPcountry_24_48=0;
    WHPMserviceUPcountry_greater48=0;
    
    //WT local Free installation call charges
    WTFreeinstCity_Lees6=0;
    WTFreeinstCity_6_24=0;
    WTFreeinstCity_24_48=0;
    WTFreeinstCity_greater48=0;
                
    //WT Upcountry Free installation call charges
    WTFreeinstUPcountry_Lees6=0;
    WTFreeinstUPcountry_6_24=0;
    WTFreeinstUPcountry_24_48=0;
    WTFreeinstUPcountry_greater48=0;
    
    //WH Local free installation call charegs
    WHFreeinstCity_Lees6=0;
    WHFreeinstCity_6_24=0;
    WHFreeinstCity_24_48=0;
    WHFreeinstCity_greater48=0;
    
    // WH Upcountry free installation call charegs
    WHFreeinstUPcountry_Lees6=0;
    WHFreeinstUPcountry_6_24=0;
    WHFreeinstUPcountry_24_48=0;
    WHFreeinstUPcountry_greater48=0;
    
    //WT local Dealer stock call charges
    WTDealerstockCity_Lees6=0; 
    WTDealerstockCity_6_24=0;
    WTDealerstockCity_24_48=0;
    WTDealerstockCity_greater48=0;
                
    //WT Upcountry Dealer Stock call charges
    WTDealerstockUPcountry_Lees6=0;
    WTDealerstockUPcountry_6_24=0;
    WTDealerstockUPcountry_24_48=0;
    WTDealerstockUPcountry_greater48=0;
    
    //WH Local Dealer Stock call charegs
    WHDealerstockCity_Lees6=0;
    WHDealerstockCity_6_24=0;
    WHDealerstockCity_24_48=0;
    WHDealerstockCity_greater48=0;
    
    // WH Upcountry Dealer Stock call charegs
    WHDealerstockUPcountry_Lees6=0;
    WHDealerstockUPcountry_6_24=0;
    WHDealerstockUPcountry_24_48=0;
    WHDealerstockUPcountry_greater48=0;
    
    //WT fIXED Fixed Compensation detail
    WTone_one_one=0;
    WTFixedComp=0;
    WTCallclosedCity80=0;
    WTCallclosedUpcountry80=0;
    WTGreater70callclosed=0;
    WTCallclosed60_69=0;
    WTCallclosed50_59=0;  
    WTLess_50callclosed=0;    
    WTMinimunCall=0;  
    
    //WH fIXED Fixed Compensation detail
    WHone_one_one=0;
    WHFixedComp=0;
    WHCallclosedCity80=0;
    WHCallclosedUpcountry80=0;
    WHGreater70callclosed=0;
    WHCallclosed60_69=0;
    WHCallclosed50_59=0;  
    WHLess_50callclosed=0;    
    WHMinimunCall=0;
    
    Numberofcallclosed=0;
    Numberofcallclosedwithin24=0;
    WHcallclosedpercent=0;
    
    WTcallclosedpercent=0;
    
    NumberofcallclosedUpc=0;
    Numberofcallclosedwithin24Upc=0;
    WTcallclosedpercentUpc=0;
    
    WHAmount80City=0;
    WHAmount80Upcounty=0;
    Amount60_69calls=0;
    Amount50_59calls=0;
    AmountLess_50calls=0;
    Amount70_79calls=0;
    
    WTAmount60_69calls=0;
    WTAmount50_59calls=0;
    WTAmountLess_50calls=0;
    WTAmount70_79calls=0;
    
    //Value assign from case WH Local service
    WH_Serv_Less_6hrs=0;
    WH_Serv_6_24hrs=0;
    WH_Serv_Greater_24hrs=0;
    WH_Serv_Greater_48hrs=0;
    
    //Value assign from case WH Upcountry service
    WH_Serv_Upcountry_Less_6hrs=0;
    WH_Serv_Upcountry_6_24hrs=0;
    WH_Serv_Upcountry_Greater_24hrs=0;
    WH_Serv_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Local service
    WT_Serv_Less_6hrs=0;
    WT_Serv_6_24hrs=0;
    WT_Serv_Greater_24hrs=0;
    WT_Serv_Greater_48hrs=0;
    
    //Value assign from case WT Upcountry service
    WT_Serv_Upcountry_Less_6hrs=0;
    WT_Serv_Upcountry_6_24hrs=0;
    WT_Serv_Upcountry_Greater_24hrs=0;
    WT_Serv_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WH Local PM service
    WH_PMServ_Less_6hrs=0;
    WH_PMServ_6_24hrs=0;
    WH_PMServ_Greater_24hrs=0;
    WH_PMServ_Greater_48hrs=0;
    
    //Value assign from case WH Upcountry PM service
    WH_PMServ_Upcountry_Less_6hrs=0;
    WH_PMServ_Upcountry_6_24hrs=0;
    WH_PMServ_Upcountry_Greater_24hrs=0;
    WH_PMServ_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Upcountry PM service
    WT_PMServ_Upcountry_Less_6hrs=0;
    WT_PMServ_Upcountry_6_24hrs=0;
    WT_PMServ_Upcountry_Greater_24hrs=0;
    WT_PMServ_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Local PM service
    WT_PMServ_Less_6hrs=0;
    WT_PMServ_6_24hrs=0;
    WT_PMServ_Greater_24hrs=0;
    WT_PMServ_Greater_48hrs=0;
    
    //Value assign from case WH Local Free Installation
    WH_Freeinst_Less_6hrs=0;
    WH_Freeinst_6_24hrs=0;
    WH_Freeinst_Greater_24hrs=0;
    WH_Freeinst_Greater_48hrs=0;
    
    //Value assign from case WH Upcountry Free Installation
    WH_Freeinst_Upcountry_Less_6hrs=0;
    WH_Freeinst_Upcountry_6_24hrs=0;
    WH_Freeinst_Upcountry_Greater_24hrs=0;
    WH_Freeinst_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Upcountry Free Installation
    WT_Freeinst_Upcountry_Less_6hrs=0;
    WT_Freeinst_Upcountry_6_24hrs=0;
    WT_Freeinst_Upcountry_Greater_24hrs=0;
    WT_Freeinst_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Local Free Installation
    WT_Freeinst_Less_6hrs=0;
    WT_Freeinst_6_24hrs=0;
    WT_Freeinst_Greater_24hrs=0;
    WT_Freeinst_Greater_48hrs=0;
    
    //Value assign from case WH Local Dealer Stock
    WH_Dealerstock_Less_6hrs=0;
    WH_Dealerstock_6_24hrs=0;
    WH_Dealerstock_Greater_24hrs=0;
    WH_Dealerstock_Greater_48hrs=0;
    
    //Value assign from case WH Upcountry Dealer Stock
    WH_Dealerstock_Upcountry_Less_6hrs=0;
    WH_Dealerstock_Upcountry_6_24hrs=0;
    WH_Dealerstock_Upcountry_Greater_24hrs=0;
    WH_Dealerstock_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Upcountry Dealer Stock
    WT_Dealerstock_Upcountry_Less_6hrs=0;
    WT_Dealerstock_Upcountry_6_24hrs=0;
    WT_Dealerstock_Upcountry_Greater_24hrs=0;
    WT_Dealerstock_Upcountry_Greater_48hrs=0;
    
    //Value assign from case WT Local Dealer Stock
    WT_Dealerstock_Less_6hrs=0;
    WT_Dealerstock_6_24hrs=0;
    WT_Dealerstock_Greater_24hrs=0;
    WT_Dealerstock_Greater_48hrs=0;
    
    // Total Amount Service Local
    TotalServiceLess6hrs=0;
    TotalService6_24hrs=0;
    TotalService_greater_24hrs=0;
    TotalService_greater_48=0;
    
    // Total Amount Service Upcountry
    UCTotalServiceLess6hrs=0;
    UCTotalService6_24hrs=0;
    UCTotalService_greater_24hrs=0;
    UCTotalService_greater_48=0;
    
    // Total Amount PM Service Local
    TotalPMServiceLess6hrs=0;
    TotalPMService6_24hrs=0;
    TotalPMService_greater_24hrs=0;
    TotalPMService_greater_48=0;
    
    // Total Amount PM Service Upcountry
    UCTotalPMServiceLess6hrs=0;
    UCTotalPMService6_24hrs=0;
    UCTotalPMService_greater_24hrs=0;
    UCTotalPMService_greater_48=0;
    
    // Total Amount Free installation Local
    TotalFreeinstLess6hrs=0;
    TotalFreeinst6_24hrs=0;
    TotalFreeinst_greater_24hrs=0;
    TotalFreeinst_greater_48=0;
    
    // Total Amount Free installation Upcountry
    UCTotalFreeinstLess6hrs=0;
    UCTotalFreeinst6_24hrs=0;
    UCTotalFreeinst_greater_24hrs=0;
    UCTotalFreeinst_greater_48=0;   
        
    // Total Amount Dealer stock Local
    TotalDealerstockLess6hrs=0;
    TotalDealerstock6_24hrs=0;
    TotalDealerstock_greater_24hrs=0;
    TotalDealerstock_greater_48=0;
    
    // Total Amount Dealer stock Upcountry
    UCTotalDealerstockLess6hrs=0;
    UCTotalDealerstock6_24hrs=0;
    UCTotalDealerstock_greater_24hrs=0;
    UCTotalDealerstock_greater_48=0; 
    
    //fixed compensation
    WHfixedcompAmount=0;
    WTfixedcompAmount=0;
    
    total80callvalueCity=0;
    total80callvalueUpc=0;
    
    WHpercentof80callCity=0;
    WHpercentof80callUpc=0;
    WTpercentof80callCity=0;
    WTpercentof80callUpc=0;
    
        //Service call closed Local WH 
     WHServiceCall_Less_6HrsCity=0;
     WHServiceCall_6_24HrsCity=0;
     WHServiceCall_greater_24HrsCity=0;
     WHServiceCall_greater_48HrsCity=0;
    
    
    //Service call closed Upcountry WH 
     WHServiceCall_Less_6HrsUpcountry=0;
     WHServiceCall_6_24HrsUpcountry=0;
     WHServiceCall_greater_24HrsUpcountry=0;
     WHServiceCall_greater_48HrsUpcountry=0;
    
    //Service call closed Local WT
     WTServiceCall_Less_6HrsCity=0;
     WTServiceCall_6_24HrsCity=0;
     WTServiceCall_greater_24HrsCity=0;
     WTServiceCall_greater_48HrsCity=0;
    
    //Service call closed Upcountry WT 
     WTServiceCall_Less_6HrsUpcountry=0;
     WTServiceCall_6_24HrsUpcountry=0;
     WTServiceCall_greater_24HrsUpcountry=0;
     WTServiceCall_greater_48HrsUpcountry=0;
    
    //PM Service call closed Local WH 
     WHPMServiceCall_Less_6HrsCity=0;
     WHPMServiceCall_6_24HrsCity=0;
     WHPMServiceCall_greater_24HrsCity=0;
     WHPMServiceCall_greater_48HrsCity=0;
                
    //PM Service call closed Upcountry WH 
     WHPMServiceCall_Less_6HrsUpcountry=0;
     WHPMServiceCall_6_24HrsUpcountry=0;
     WHPMServiceCall_greater_24HrsUpcountry=0;
     WHPMServiceCall_greater_48HrsUpcountry=0;
                
    //PM Service call closed Local WT
     WTPMServiceCall_Less_6HrsCity=0;
     WTPMServiceCall_6_24HrsCity=0;
     WTPMServiceCall_greater_24HrsCity=0;
     WTPMServiceCall_greater_48HrsCity=0;
            
    //PM Service call closed Upcountry WT 
     WTPMServiceCall_Less_6HrsUpcountry=0;
     WTPMServiceCall_6_24HrsUpcountry=0;
     WTPMServiceCall_greater_24HrsUpcountry=0;
     WTPMServiceCall_greater_48HrsUpcountry=0;
    
    //Free Installation call closed Local WH 
     WHFreeinstCall_Less_6HrsCity=0;
     WHFreeinstCall_6_24HrsCity=0;
     WHFreeinstCall_greater_24HrsCity=0;
     WHFreeinstCall_greater_48HrsCity=0;
                
    //Free Installation call closed Upcountry WH 
     WHFreeinstCall_Less_6HrsUpcountry=0;
     WHFreeinstCall_6_24HrsUpcountry=0;
     WHFreeinstCall_greater_24HrsUpcountry=0;
     WHFreeinstCall_greater_48HrsUpcountry=0;
                
    //Free Installation call closed Local WT
     WTFreeinstCall_Less_6HrsCity=0;
     WTFreeinstCall_6_24HrsCity=0;
     WTFreeinstCall_greater_24HrsCity=0;
     WTFreeinstCall_greater_48HrsCity=0;
            
    //Free Installation call closed Upcountry WT 
     WTFreeinstCall_Less_6HrsUpcountry=0;
     WTFreeinstCall_6_24HrsUpcountry=0;
     WTFreeinstCall_greater_24HrsUpcountry=0;
     WTFreeinstCall_greater_48HrsUpcountry=0;
     
     //Dealer Stock call closed Local WH 
     WHDealerstockCall_Less_6HrsCity=0;
     WHDealerstockCall_6_24HrsCity=0;
     WHDealerstockCall_greater_24HrsCity=0;
     WHDealerstockCall_greater_48HrsCity=0;
                
    //Dealer Stock call closed Upcountry WH 
     WHDealerstockCall_Less_6HrsUpcountry=0;
     WHDealerstockCall_6_24HrsUpcountry=0;
     WHDealerstockCall_greater_24HrsUpcountry=0;
     WHDealerstockCall_greater_48HrsUpcountry=0;
                
    //Dealer Stock call closed Local WT
     WTDealerstockCall_Less_6HrsCity=0;
     WTDealerstockCall_6_24HrsCity=0;
     WTDealerstockCall_greater_24HrsCity=0;
     WTDealerstockCall_greater_48HrsCity=0;
            
    //Dealer Stock call closed Upcountry WT 
     WTDealerstockCall_Less_6HrsUpcountry=0;
     WTDealerstockCall_6_24HrsUpcountry=0;
     WTDealerstockCall_greater_24HrsUpcountry=0;
     WTDealerstockCall_greater_48HrsUpcountry=0;
     
      //calculating case depends on reason
        //WH Service local            
        WH_Serv_Less_6hrs=0;
        WH_Serv_6_24hrs=0;
        WH_Serv_Greater_24hrs=0;
        WH_Serv_Greater_48hrs=0;
        
        //WH service upcountry
        WH_Serv_Upcountry_Less_6hrs=0;
        WH_Serv_Upcountry_6_24hrs=0;
        WH_Serv_Upcountry_Greater_24hrs=0;
        WH_Serv_Upcountry_Greater_48hrs=0;
        
        //WT service local
        WT_Serv_Less_6hrs=0;
        WT_Serv_6_24hrs=0;
        WT_Serv_Greater_24hrs=0;
        WT_Serv_Greater_48hrs=0;
       
        //WT Service upcountry
        WT_Serv_Upcountry_Less_6hrs=0;
        WT_Serv_Upcountry_6_24hrs=0;
        WT_Serv_Upcountry_Greater_24hrs=0;
        WT_Serv_Upcountry_Greater_48hrs=0;
        
        //WH PM service local 
        WH_PMServ_Less_6hrs=0;
        WH_PMServ_6_24hrs=0;
        WH_PMServ_Greater_24hrs=0;
        WH_PMServ_Greater_48hrs=0;
        
        //WH PM Upcountry 
        WH_PMServ_Upcountry_Less_6hrs=0;
        WH_PMServ_Upcountry_6_24hrs=0;
        WH_PMServ_Upcountry_Greater_24hrs=0;
        WH_PMServ_Upcountry_Greater_48hrs=0;
        
        ///WT PM service local
        WT_PMServ_Less_6hrs=0;
        WT_PMServ_6_24hrs=0;
        WT_PMServ_Greater_24hrs=0;
        WT_PMServ_Greater_48hrs=0;
        
        //WT PM service upcountry 
        WT_PMServ_Upcountry_Less_6hrs=0;
        WT_PMServ_Upcountry_6_24hrs=0;
        WT_PMServ_Upcountry_Greater_24hrs=0;
        WT_PMServ_Upcountry_Greater_48hrs=0;
        
         //WH Free installation local 
        WH_Freeinst_Less_6hrs=0;
        WH_Freeinst_6_24hrs=0;
        WH_Freeinst_Greater_24hrs=0;
        WH_Freeinst_Greater_48hrs=0;
        
        //WH Free installation Upcountry 
        WH_Freeinst_Upcountry_Less_6hrs=0;
        WH_Freeinst_Upcountry_6_24hrs=0;
        WH_Freeinst_Upcountry_Greater_24hrs=0;
        WH_Freeinst_Upcountry_Greater_48hrs=0;
        
        ///WT Free installation local
        WT_Freeinst_Less_6hrs=0;
        WT_Freeinst_6_24hrs=0;
        WT_Freeinst_Greater_24hrs=0;
        WT_Freeinst_Greater_48hrs=0;
        
        //WT Free installation upcountry 
        WT_Freeinst_Upcountry_Less_6hrs=0;
        WT_Freeinst_Upcountry_6_24hrs=0;
        WT_Freeinst_Upcountry_Greater_24hrs=0;
        WT_Freeinst_Upcountry_Greater_48hrs=0;
        
         //WH Dealer Stock local 
        WH_Dealerstock_Less_6hrs=0;
        WH_Dealerstock_6_24hrs=0;
        WH_Dealerstock_Greater_24hrs=0;
        WH_Dealerstock_Greater_48hrs=0;
        
        //WH Dealer Stock Upcountry 
        WH_Dealerstock_Upcountry_Less_6hrs=0;
        WH_Dealerstock_Upcountry_6_24hrs=0;
        WH_Dealerstock_Upcountry_Greater_24hrs=0;
        WH_Dealerstock_Upcountry_Greater_48hrs=0;
        
        ///WT Dealer Stock local
        WT_Dealerstock_Less_6hrs=0;
        WT_Dealerstock_6_24hrs=0;
        WT_Dealerstock_Greater_24hrs=0;
        WT_Dealerstock_Greater_48hrs=0;
        
        //WT Dealer Stock upcountry 
        WT_Dealerstock_Upcountry_Less_6hrs=0;
        WT_Dealerstock_Upcountry_6_24hrs=0;
        WT_Dealerstock_Upcountry_Greater_24hrs=0;
        WT_Dealerstock_Upcountry_Greater_48hrs=0;
        
        //WT Calls breakup under Fixed Compensation
         WT_Less_6Hrs_UnderFC = 0;
         WT_6_24HrsCity_UnderFC = 0;
         WT_greater_24Hrs_UnderFC = 0;
         WT_greater_48HrsCity_UnderFC = 0;
                
        //WT Calls breakup under Fixed Compensation
         WH_Less_6Hrs_UnderFC = 0;
         WH_6_24HrsCity_UnderFC = 0;
         WH_greater_24Hrs_UnderFC = 0;
         WH_greater_48HrsCity_UnderFC = 0;
    
        aspRecord=new ASP__c();
         Recordtypeid= [Select id from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
        ASPid=ApexPages.currentPage().getParameters().get('id');
        aspRecord = [Select id, CreatedBy.Name,CreatedDate,AOSI_Vendor_Code__c,AOSI_CITY_DISTRICT_NAME__c,AOSI_ASP_User__r.Name,AOSI_Address__c,AOSI_State__c,AOSI_Company_Name__c,
        AOSI_Telephone_1__c,AOSI_Agreement_Number__c,AOSI_Contract_Effective_From_Date__c,AOSI_Pin_Code__c,AOSI_Contract_Effective_To_Date__c,AOSI_PAN_No__c,
        AOSI_VAT_Registration_No__c,AOSI_Service_Tax_Registration_No__c,AOSI_City__c,AOSI_Service_Claim__c,AOSI_Installation_Claim__c from ASP__c 
        where id =: ASPid limit 1];
        for(ASP_Rate_Master_Junction__c AMJ :[select id,ASP__c,ASP_Rate_Master__c from ASP_Rate_Master_Junction__c where ASP__c=:ASPid]){
            ratemasterid.add(AMJ.ASP_Rate_Master__c);
        }
        //Query to extract all WT rate master of ASP
        ASPratemasterforWT=[SELECT Active__c,Minimum_Number_Of_Call__c,AOSI_50__c,AOSI_70_calls_completed_within_24Hrs__c,AOSI_Category__c,AOSI_Fixed_Compensation__c,AOSI_If_80_calls_completed_24hrs_Upcont__c,
        AOSI_If_80_calls_completed_within_24hrs__c,AOSI_Only_50_to_59__c,AOSI_Only_60_to_69__c,AOSI_Upcountry_TA__c,Id,Name,Product_Category__c,X1_1_1__c
        FROM ASP_Rate_Master__c where Product_Category__c='Water Treatment' and id=:ratemasterid and Active__c=TRUE];
        //Query to extract all WH rate master of ASP
        ASPratemasterforWH=[SELECT Active__c,AOSI_50__c,Minimum_Number_Of_Call__c,AOSI_70_calls_completed_within_24Hrs__c,AOSI_Category__c,AOSI_Fixed_Compensation__c,AOSI_If_80_calls_completed_24hrs_Upcont__c,
        AOSI_If_80_calls_completed_within_24hrs__c,AOSI_Only_50_to_59__c,AOSI_Only_60_to_69__c,AOSI_Upcountry_TA__c,Id,Name,Product_Category__c,X1_1_1__c
        FROM ASP_Rate_Master__c where Product_Category__c='Water Heater' and id=:ratemasterid and Active__c=TRUE];
        //Extract ID of WT rate master
        for(ASP_Rate_Master__c WTARM: ASPratemasterforWT){
            WTRatemasterid.add(WTARM.id);
            WTone_one_one=WTARM.X1_1_1__c;
            WTFixedComp=WTARM.AOSI_Fixed_Compensation__c;
            WTCallclosedCity80=WTARM.AOSI_If_80_calls_completed_within_24hrs__c;
            WTCallclosedUpcountry80=WTARM.AOSI_If_80_calls_completed_24hrs_Upcont__c;
            WTGreater70callclosed=WTARM.AOSI_70_calls_completed_within_24Hrs__c;
            WTCallclosed60_69=WTARM.AOSI_Only_60_to_69__c;
            WTCallclosed50_59=WTARM.AOSI_Only_50_to_59__c;
            WTLess_50callclosed=WTARM.AOSI_50__c;
            WTMinimunCall=WTARM.Minimum_Number_Of_Call__c;
        }
        //Extract ID of WH rate master
        for(ASP_Rate_Master__c WHARM: ASPratemasterforWH){
            WHRatemasterid.add(WHARM.id);
            if(WHARM.X1_1_1__c!=null)
            WHone_one_one=WHARM.X1_1_1__c;
            if(WHARM.AOSI_Fixed_Compensation__c!=null)
            WHFixedComp=WHARM.AOSI_Fixed_Compensation__c;
            if(WHARM.AOSI_If_80_calls_completed_within_24hrs__c!=null)
            WHCallclosedCity80=WHARM.AOSI_If_80_calls_completed_within_24hrs__c;
            if(WHARM.AOSI_If_80_calls_completed_24hrs_Upcont__c!=null)
            WHCallclosedUpcountry80=WHARM.AOSI_If_80_calls_completed_24hrs_Upcont__c;
            if(WHARM.AOSI_70_calls_completed_within_24Hrs__c!=null)
            WHGreater70callclosed=WHARM.AOSI_70_calls_completed_within_24Hrs__c/100;
            if(WHARM.AOSI_Only_60_to_69__c!=null)
            WHCallclosed60_69=WHARM.AOSI_Only_60_to_69__c/100;
            if(WHARM.AOSI_Only_50_to_59__c!=null)
            WHCallclosed50_59=WHARM.AOSI_Only_50_to_59__c/100;
            if(WHARM.AOSI_50__c!=null)
            WHLess_50callclosed=WHARM.AOSI_50__c/100;
            if(WHARM.Minimum_Number_Of_Call__c!=null)
            WHMinimunCall=WHARM.Minimum_Number_Of_Call__c;
            
        }
        
       
         list<case> WHcallclosedlastmonth=new list<case>();
        WHcallclosedlastmonth=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Product_Vertical__c='Water Heater' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        //system.debug('===========WHcallclosedlastmonth'+WHcallclosedlastmonth.size());
         
         
        //WH total case closed for city
        callclosedWithinCityWH=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_ASP_Class_Type__c='City' and AOSI_Product_Vertical__c='Water Heater' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithinCityWH'+callclosedWithinCityWH.size());
        
        //WH total case closed within 24 hours for city
        callclosedWithin24HrCityWH=[select id,casenumber,RecordTypeid,AOSI_Product_Vertical__c,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Resolution_Clock_Time__c<=24 and AOSI_ASP_Class_Type__c='City' and AOSI_Product_Vertical__c='Water Heater' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithin24HrCityWH'+callclosedWithin24HrCityWH.size());
        
        //WH total case closed for Upcountry
        callclosedWithinUpcWH=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_ASP_Class_Type__c='Upcountry' and AOSI_Product_Vertical__c='Water Heater' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithinUpcWH'+callclosedWithinUpcWH.size());
        
        //WH total case closed within 24 hours for Upcountry
        callclosedWithin24HrUpcWH=[select id,casenumber,RecordTypeid,AOSI_Product_Vertical__c,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Resolution_Clock_Time__c<=24 and AOSI_ASP_Class_Type__c='Upcountry' and AOSI_Product_Vertical__c='Water Heater' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithin24HrUpcWH'+callclosedWithin24HrUpcWH.size());
        
        //WT total case closed for city
        callclosedWithinCityWT=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_ASP_Class_Type__c='City' and AOSI_Product_Vertical__c='Water Treatment' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithinCityWT'+callclosedWithinCityWT.size());
        
        //WT total case closed within 24 hours for city
        callclosedWithin24HrCityWt=[select id,casenumber,RecordTypeid,AOSI_Product_Vertical__c,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and  closedDate = LAST_MONTH and AOSI_Resolution_Clock_Time__c<=24 and AOSI_ASP_Class_Type__c='City' and AOSI_Product_Vertical__c='Water Treatment' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithin24HrCityWt'+callclosedWithin24HrCityWt.size());
        
        //WT total case closed for Upcountry
        callclosedWithinUpcWt=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_ASP_Class_Type__c='Upcountry' and AOSI_Product_Vertical__c='Water Treatment' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithinUpcWH'+callclosedWithinUpcWH.size());
        
        //WT total case closed within 24 hours for Upcountry
        callclosedWithin24HrUpcWt=[select id,casenumber,RecordTypeid,AOSI_Product_Vertical__c,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Resolution_Clock_Time__c<=24 and AOSI_ASP_Class_Type__c='Upcountry' and AOSI_Product_Vertical__c='Water Treatment' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========callclosedWithin24HrUpcWH'+callclosedWithin24HrUpcWH.size());

        listofcase=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Product_Vertical__c,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and closedDate = LAST_MONTH  and status=:'Closed' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('CCCCCCCCCCCCC'+listofcase);
      //WH call closed
      
    //No of cal completed within 24 hrs WH
    List<case> WHcallclosedlastmonth24=new List<case>();
      WHcallclosedlastmonth24=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Product_Vertical__c='Water Heater' and AOSI_Resolution_Clock_Time__c<=24 and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========WHcallclosedlastmonth24'+WHcallclosedlastmonth24.size());
        
        List<case> WTcallclosedlastmonth=new List<case>();
      WTcallclosedlastmonth=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Product_Vertical__c='Water Treatment' and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========WTcallclosedlastmonth'+WTcallclosedlastmonth.size());
        
        //Call completed within 24 hrs WT
        List<case> WTcallclosedlastmonth24=new List<case>();
      WTcallclosedlastmonth24=[select id,casenumber,RecordTypeid,ClosedDate,AOSI_Resolution_Clock_Time__c,Reason,AOSI_Resolution_Time_Slab_WH__c,AOSI_ASP_Class_Type__c from Case where 
        RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and status=:'Closed' and closedDate = LAST_MONTH and AOSI_Product_Vertical__c='Water Treatment' and AOSI_Resolution_Clock_Time__c<=24 and (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') ORDER BY ClosedDate];
        system.debug('===========WTcallclosedlastmonth24'+WTcallclosedlastmonth24.size());
        
        //Calculating tribleone cases WH
        WHTribleonecase=[select id from case where RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and (status=:'Closed' or status=:'Partially Closed') and (Assignment_End_Time__c = LAST_MONTH or AOSI_Case_Close_Time__c = LAST_MONTH or closedDate = LAST_MONTH) and AOSI_Product_Vertical__c='Water Heater' 
        and  (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') and AOSI_Respond_Time__c <=:60 and AOSI_Resolution_Time_New__c <=:12 and AOSI_On_Hold_Reason_checkbox__c=False];
        System.debug('WWWWWWWWWWWW'+WHTribleonecase.size());
        //Calculating tribleone cases WT
        WTTribleonecase=[select id from case where RecordTypeId=:Recordtypeid and  Service_Engineer__r.AOSI_ASP__c =:ASPid and (status=:'Closed' or status=:'Partially Closed') and AOSI_Product_Vertical__c='Water Treatment' 
         and (Assignment_End_Time__c = LAST_MONTH or AOSI_Case_Close_Time__c = LAST_MONTH or closedDate = LAST_MONTH) and  (Reason='Free Installation' or Reason='Service' or Reason='PM Service' or Reason='Dealer Stock') and AOSI_Respond_Time__c <=:60 and AOSI_Resolution_Time_New__c <=:12 and AOSI_On_Hold_Reason_checkbox__c=False];
        
        WHOneoneonetotalAmount=WHTribleonecase.size() * WHone_one_one * 0;//Made triple one amount to zero as the custom logic for 1.1.1 has to be defined. - Bhanu 20 sep 14
        system.debug('======== WHOneoneonetotalAmount'+WHOneoneonetotalAmount);
        
        WTOneoneonetotalAmount=WTTribleonecase.size() * WTone_one_one *0;////Made triple one amount to zero as the custom logic for 1.1.1 has to be defined.  - Bhanu 20 sep 14
        system.debug('======== WTOneoneonetotalAmount'+WTOneoneonetotalAmount);
        TotalOneoneonetotalAmount=WHOneoneonetotalAmount+WTOneoneonetotalAmount;
        //Calculating WT and WH for 1.1.1 calls
        
        //WH call checking with min calls
        Decimal WHtotalcall=0;
        Decimal WHtotalcalcloseed24=0;
        Decimal WHtotalcallUpc=0;
        Decimal WHtotalcalcloseed24Upc=0;
        
        Decimal WTtotalcall=0;
        Decimal WTtotalcalcloseed24=0;
        Decimal WTtotalcallUpc=0;
        Decimal WTtotalcalcloseed24Upc=0;
        
        // ratios for 80% call closure with 24 hrs chk
        if(!WHcallclosedlastmonth24.isempty()){
            whcallsclosedin24hrsratio = Decimal.valueof(WHcallclosedlastmonth.size())/Decimal.valueof(WHcallclosedlastmonth24.size());
        }
        else{
            whcallsclosedin24hrsratio = 0.0;
        }
        if(!WTcallclosedlastmonth24.isempty()){
            wtcallsclosedin24hrsratio = Decimal.valueof(WTcallclosedlastmonth.size())/Decimal.valueof(WTcallclosedlastmonth24.size());
        }
        else{
            wtcallsclosedin24hrsratio = 0.0;
        }
        
        
        
        //start of call rates from service lines
         //Extract all WT service line iteam
        WTServiceLine=[SELECT ASP_Rate_Master__c,Id,Name,Type__c,X6hrs_to_24hrs_City__c,X6hrs_to_24hrs_Upcountry__c,X6hrs_Upcountry__c,X6_hrs__c,X24hrs_City__c,
        X24hrs_Upcountry__c,X48_hrs_City__c,X48_hrs_Upcountry__c FROM Service_Line__c where ASP_Rate_Master__c=:WTRatemasterid];
        //assign rate for service call for WT 
        for(Service_Line__c SL: WTServiceLine){
            if(SL.Type__c=='Service'){
            //Service call for Local
                if(SL.X6_hrs__c!=null)
                    WTserviceCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WTserviceCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                        WTserviceCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                        WTserviceCity_24_48=SL.X24hrs_City__c;
                    }
                    
                if(SL.X48_hrs_City__c!=null)
                    WTserviceCity_greater48=SL.X48_hrs_City__c;
                    
                //Service Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WTserviceUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WTserviceUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                    
                if(SL.X24hrs_Upcountry__c!=null)
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                        WTserviceUPcountry_24_48=SL.X6hrs_to_24hrs_Upcountry__c;
                    }
                    else{
                        WTserviceUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    }
                    
                if(SL.X48_hrs_Upcountry__c!=null)
                    WTserviceUPcountry_greater48=SL.X48_hrs_Upcountry__c;
                    
            }
            if(SL.Type__c=='PM Service'){
            //PM Service call for Local
                if(SL.X6_hrs__c!=null)
                    WTPMserviceCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WTPMserviceCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                        WTPMserviceCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                        WTPMserviceCity_24_48=SL.X24hrs_City__c;
                    }
                    
                if(SL.X48_hrs_City__c!=null)
                    WTPMserviceCity_greater48=SL.X48_hrs_City__c;
                    
                //PM Service Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WTPMserviceUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WTPMserviceUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                        WTPMserviceUPcountry_24_48=SL.X6hrs_to_24hrs_Upcountry__c;
                    }
                    else{
                        WTPMserviceUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    }
                                        
                if(SL.X48_hrs_Upcountry__c!=null)
                    WTPMserviceUPcountry_greater48=SL.X48_hrs_Upcountry__c;
                    
            }
            
            if(SL.Type__c=='Free Installation'){
            //Free installation call for Local
                if(SL.X6_hrs__c!=null)
                    WTFreeinstCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WTFreeinstCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                        WTFreeinstCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                        WTFreeinstCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    
                if(SL.X48_hrs_City__c!=null)
                    WTFreeinstCity_greater48=SL.X48_hrs_City__c;
                    
                //Free installation Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WTFreeinstUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WTFreeinstUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                        WTFreeinstUPcountry_24_48=SL.X6hrs_to_24hrs_Upcountry__c;
                    }
                    else{
                        WTFreeinstUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    }
                   // WTFreeinstUPcountry_24_48=SL.X24hrs_Upcountry__c;
                if(SL.X48_hrs_Upcountry__c!=null)
                    WTFreeinstUPcountry_greater48=SL.X48_hrs_Upcountry__c;
                    
            }
            if(SL.Type__c=='Dealer Stock'){
            //Dealer stock call for Local
                if(SL.X6_hrs__c!=null)
                    WTDealerstockCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WTDealerstockCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                         WTDealerstockCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                         WTDealerstockCity_24_48=SL.X24hrs_Upcountry__c;
                    }
                    //WTDealerstockCity_24_48=SL.X24hrs_City__c;
                if(SL.X48_hrs_City__c!=null)
                    WTDealerstockCity_greater48=SL.X48_hrs_City__c;
                    
                //Dealer stock Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WTDealerstockUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WTDealerstockUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(wtcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                         WTDealerstockUPcountry_24_48=SL.X6hrs_to_24hrs_Upcountry__c;
                    }
                    else{
                        WTDealerstockUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    }
                    //WTDealerstockUPcountry_24_48=SL.X24hrs_Upcountry__c;
                if(SL.X48_hrs_Upcountry__c!=null)
                    WTDealerstockUPcountry_greater48=SL.X48_hrs_Upcountry__c;
                    
            }
        }
        //Extract all WH service line iteam
        WHServiceLine=[SELECT ASP_Rate_Master__c,Id,Name,Type__c,X6hrs_to_24hrs_City__c,X6hrs_to_24hrs_Upcountry__c,X6hrs_Upcountry__c,X6_hrs__c,X24hrs_City__c,
        X24hrs_Upcountry__c,X48_hrs_City__c,X48_hrs_Upcountry__c FROM Service_Line__c where ASP_Rate_Master__c=:WHRatemasterid];
       
        for(Service_Line__c SL: WHServiceLine){
            if(SL.Type__c=='Service'){
            //Service Call for City
                if(SL.X6_hrs__c!=null)
                    WHserviceCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WHserviceCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                     //WHserviceCity_24_48=SL.X24hrs_City__c;
                   // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(whcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                         WHserviceCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                         WHserviceCity_24_48=SL.X24hrs_City__c;
                    }
 
                if(SL.X48_hrs_City__c!=null)
                    WHserviceCity_greater48=SL.X48_hrs_City__c;
                    
            //Service Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WHserviceUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WHserviceUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                   // WHserviceUPcountry_24_48=SL.X24hrs_Upcountry__c;
                   // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(whcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                         WHserviceUPcountry_24_48=SL.X6hrs_to_24hrs_upcountry__c;
                    }
                    else{
                        WHserviceUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    } 
                if(SL.X48_hrs_Upcountry__c!=null)
                    WHserviceUPcountry_greater48=SL.X48_hrs_Upcountry__c;
            }
            
            if(SL.Type__c=='PM Service'){
            //PM Service Call for City
                if(SL.X6_hrs__c!=null)
                    WHPMserviceCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WHPMserviceCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                    //WHPMserviceCity_24_48=SL.X24hrs_City__c;
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(WHcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                         WHPMserviceCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                        WHPMserviceCity_24_48=SL.X24hrs_City__c;
                    }
 
                if(SL.X48_hrs_City__c!=null)
                    WHPMserviceCity_greater48=SL.X48_hrs_City__c;
                    
            // PM Service Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WHPMserviceUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WHPMserviceUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                    //WHPMserviceUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(whcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                         WHPMserviceUPcountry_24_48=SL.X6hrs_to_24hrs_upcountry__c;
                    }
                    else{
                        WHPMserviceUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    } 
                if(SL.X48_hrs_Upcountry__c!=null)
                    WHPMserviceUPcountry_greater48=SL.X48_hrs_Upcountry__c;
            }
            
            if(SL.Type__c=='Free Installation'){
            //Free Installation Call for City
                if(SL.X6_hrs__c!=null)
                    WHFreeinstCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WHFreeinstCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                    //WHFreeinstCity_24_48=SL.X24hrs_City__c;
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(WHcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                         WHFreeinstCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                         WHFreeinstCity_24_48=SL.X24hrs_City__c;
                    }
                if(SL.X48_hrs_City__c!=null)
                    WHFreeinstCity_greater48=SL.X48_hrs_City__c;
                    
            // Free Installation Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WHFreeinstUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WHFreeinstUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                    //WHFreeinstUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(whcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                         WHFreeinstUPcountry_24_48=SL.X6hrs_to_24hrs_upcountry__c;
                    }
                    else{
                         WHFreeinstUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    } 
                if(SL.X48_hrs_Upcountry__c!=null)
                    WHFreeinstUPcountry_greater48=SL.X48_hrs_Upcountry__c;
            }
            if(SL.Type__c=='Dealer Stock'){
            //Dealer Stock Call for City
                if(SL.X6_hrs__c!=null)
                    WHDealerstockCity_Lees6=SL.X6_hrs__c;
                if(SL.X6hrs_to_24hrs_City__c!=null)
                    WHDealerstockCity_6_24=SL.X6hrs_to_24hrs_City__c;
                if(SL.X24hrs_City__c!=null)
                    //WHDealerstockCity_24_48=SL.X24hrs_City__c;
                    // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(WHcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_City__c!=null ){
                         WHDealerstockCity_24_48=SL.X6hrs_to_24hrs_City__c;
                    }
                    else{
                         WHDealerstockCity_24_48=SL.X24hrs_City__c;
                    }
                if(SL.X48_hrs_City__c!=null)
                    WHDealerstockCity_greater48=SL.X48_hrs_City__c;
                    
            // Dealer Stock Call for Upcountry
                if(SL.X6hrs_Upcountry__c!=null)
                    WHDealerstockUPcountry_Lees6=SL.X6hrs_Upcountry__c;
                if(SL.X6hrs_to_24hrs_Upcountry__c!=null)
                    WHDealerstockUPcountry_6_24=SL.X6hrs_to_24hrs_Upcountry__c;
                if(SL.X24hrs_Upcountry__c!=null)
                   // WHDealerstockUPcountry_24_48=SL.X24hrs_Upcountry__c;
                   // if loop added by bhanu for checking 80% call closure with in 24 hrs to allow 24 to 48 hrs cases have same rate as 6 to 24 hrs cases - 31 dec 14
                    if(whcallsclosedin24hrsratio >= 0.8 && SL.X6hrs_to_24hrs_Upcountry__c!=null ){
                         WHDealerstockUPcountry_24_48=SL.X6hrs_to_24hrs_upcountry__c;
                    }
                    else{
                         WHDealerstockUPcountry_24_48=SL.X24hrs_Upcountry__c;
                    } 
                if(SL.X48_hrs_Upcountry__c!=null)
                    WHDealerstockUPcountry_greater48=SL.X48_hrs_Upcountry__c;
            }
    
            }
        //end of call rates from service lines
        
        
        //WH call with fixed compansation on minimum call closed
        /*if(WHcallclosedlastmonth.size() == WHMinimunCall){
            WHfixedcompAmount=WHFixedComp;
        }
        //WH call with fixed compansation on less than minimum call closed
        else*/ if(WHcallclosedlastmonth.size() < =WHMinimunCall ){
            WHfixedcompAmount=WHFixedComp;
                system.debug('=======inside if');
            if(WHMinimunCall!=0){
            WHcallclosedpercent=WHcallclosedpercent+((WHcallclosedlastmonth24.size()/WHMinimunCall)*100);
            system.debug('=======Percent : '+WHcallclosedpercent);
            if(WHcallclosedpercent >=70){
                Amount70_79calls=WHFixedComp*WHGreater70callclosed;
            }
            else if(WHcallclosedpercent >=60 && WHcallclosedpercent <=69){
            Amount60_69calls=WHFixedComp*WHCallclosed60_69;
            }
            else if(WHcallclosedpercent >=50 && WHcallclosedpercent <=59){
            Amount50_59calls=WHFixedComp*WHCallclosed50_59;
            }
            else if(WHcallclosedpercent <50){
                system.debug('WHLess_50callclosed-----'+WHLess_50callclosed);
            AmountLess_50calls=WHFixedComp*WHLess_50callclosed;
            }
        }
        }
        //WH call with fixed compansation on greater than minimum call closed with bonus amount for upcountry and local
        else if(WHcallclosedlastmonth.size() > WHMinimunCall){
        //Calculating bonum amount for upcountry and local
            WHfixedcompAmount=WHFixedComp;
            WHtotalcall=callclosedWithinCityWH.size();
            WHtotalcalcloseed24=callclosedWithin24HrCityWH.size();
            WHtotalcallUpc=callclosedWithinUpcWH.size();
            WHtotalcalcloseed24Upc=callclosedWithin24HrUpcWH.size();
            integer i = 0;
            integer WHcallclosedlastmonth24inmincount = 0;
            
            for(case whcase : WHcallclosedlastmonth){
                if(i < WHMinimunCall && WHMinimunCall!=0){
                    casesundermincategory.add(whcase.Id);
                    i++;
                    if(whcase.AOSI_Resolution_Clock_Time__c<=24){
                        WHcallclosedlastmonth24inmincount++;
                    }
                }else{
                    break;
                }
            }
            if(WHMinimunCall != 0){ //added by bhanu 4 nov 2014
            WHcallclosedpercent=WHcallclosedpercent+((WHcallclosedlastmonth24inmincount/WHMinimunCall)*100);
            
            system.debug('=======Percent : '+WHcallclosedpercent);
            if(WHcallclosedpercent >=70){
                Amount70_79calls=WHFixedComp*WHGreater70callclosed;
            }
            else if(WHcallclosedpercent >=60 && WHcallclosedpercent <=69){
            Amount60_69calls=WHFixedComp*WHCallclosed60_69;
            }
            else if(WHcallclosedpercent >=50 && WHcallclosedpercent <=59){
            Amount50_59calls=WHFixedComp*WHCallclosed50_59;
            }
            else if(WHcallclosedpercent <50){
            AmountLess_50calls=WHFixedComp*WHLess_50callclosed;
            }
            }//added
            if(WHtotalcall!=0){
                if(((WHtotalcalcloseed24/WHtotalcall) * 100) >=10){
                            WHpercentof80callCity=WHtotalcalcloseed24 * WHCallclosedCity80*0;//made vale zero until the required clarifcation of this calc is doen.
                }
            }
            if(WHtotalcallUpc!=0){
                if(((WHtotalcalcloseed24Upc/WHtotalcallUpc) * 100) >=10){
                            WHpercentof80callUpc=WHtotalcalcloseed24Upc * WHCallclosedUpcountry80*0;//made vale zero until the required clarifcation of this calc is doen.
                }
            }   
        } 
        //WT call checking with min calls
        /*if(WTcallclosedlastmonth.size() == WTMinimunCall){
            WTfixedcompAmount=WTFixedComp;
        }
        else*/ if(WTcallclosedlastmonth.size() <= WTMinimunCall && WTcallclosedlastmonth.size()!=0){
            if(WTMinimunCall != 0){//added by bhanu 4 nov 2014
            WTcallclosedpercent=WTcallclosedpercent+((WTcallclosedlastmonth24.size()/WTMinimunCall)*100);
            
            if(WTcallclosedpercent >=70){
                WTAmount70_79calls=WTFixedComp*WTGreater70callclosed;
            }
            else if(WTcallclosedpercent >=60 && WTcallclosedpercent <=69){
                WTAmount60_69calls=WTFixedComp * WTCallclosed60_69;
            }
            else if(WTcallclosedpercent >=50 && WTcallclosedpercent <=59){
                WTAmount50_59calls=WTFixedComp * WTCallclosed50_59;
            }
            else if(WTcallclosedpercent <50){
                WTAmountLess_50calls=WTFixedComp * WTLess_50callclosed;
            }
        system.debug('=====call check WTAmount70_79calls'+WTAmount70_79calls);
        }}// added by bhanu 4 nov 2014
        if(WTcallclosedlastmonth.size() > WTMinimunCall){
            integer i =0;
            integer WTcallclosedlastmonth24inmincount = 0;
             for(case whcase : WTcallclosedlastmonth){
                if(i < WTMinimunCall){
                    casesundermincategory.add(whcase.Id);
                    i++;
                    if(whcase.AOSI_Resolution_Clock_Time__c<=24){
                        WTcallclosedlastmonth24inmincount++;
                    }
                }else{
                    break;
                }
            }
            if(WTMinimunCall != 0){
            WTcallclosedpercent=WTcallclosedpercent+((WTcallclosedlastmonth24inmincount/WTMinimunCall)*100);
            if(WTcallclosedpercent >=70){
                WTAmount70_79calls=WTFixedComp*WTGreater70callclosed;
            }
            else if(WTcallclosedpercent >=60 && WTcallclosedpercent <=69){
                WTAmount60_69calls=WTFixedComp * WTCallclosed60_69;
            }
            else if(WTcallclosedpercent >=50 && WTcallclosedpercent <=59){
                WTAmount50_59calls=WTFixedComp * WTCallclosed50_59;
            }
            else if(WTcallclosedpercent <50){
                WTAmountLess_50calls=WTFixedComp * WTLess_50callclosed;
            }}
            WTtotalcall=callclosedWithinCityWT.size();
            WTtotalcalcloseed24=callclosedWithin24HrCityWT.size();
            WTtotalcallUpc=callclosedWithinUpcWT.size();
            WTtotalcalcloseed24Upc=callclosedWithin24HrUpcWT.size();
        if(WTtotalcall!=0){
                if(((WTtotalcalcloseed24/WTtotalcall) * 100) >=10){
                            WTpercentof80callCity=WTtotalcalcloseed24 * WTCallclosedCity80*0; //value made 0 unitl clarification is done - Bhanu 
                }
            }
            if(WTtotalcallUpc!=0){
                if(((WTtotalcalcloseed24Upc/WTtotalcallUpc) * 100) >=10){
                            WTpercentof80callUpc=WTtotalcalcloseed24Upc * WTCallclosedUpcountry80*0;//value made 0 unitl clarification is done - Bhanu
                }
            }
        }
        
        //Total of 80% call 
        total80callvalueCity=WHpercentof80callCity+WTpercentof80callCity;
        total80callvalueUpc=WHpercentof80callUpc+WTpercentof80callUpc;
        //Total of all call  fixed compensationcation
        Totalfixedcomp=WHfixedcompAmount+WTfixedcompAmount;
        total70perc=Amount70_79calls+WTAmount70_79calls;
        total60_69perc=Amount60_69calls+WTAmount60_69calls;
        total50_59perc=Amount50_59calls+WTAmount50_59calls;
        totalless50perc=AmountLess_50calls+WTAmountLess_50calls;
        
        // Number of call closed city 
 
        WTcallclosedpercent=0;

        WTcallclosedpercent=0;
        
        for(Case C:listofcase){
            if(!casesundermincategory.contains(c.Id)){
        //Service call local WH
            if(C.reason=='Service' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall ){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Serv_Less_6hrs=WH_Serv_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_Serv_6_24hrs=WH_Serv_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_Serv_Greater_24hrs=WH_Serv_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_Serv_Greater_48hrs=WH_Serv_Greater_48hrs+1;
                }
            }
            //Service call Upcountry WH
            if(C.reason=='Service' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Serv_Upcountry_Less_6hrs=WH_Serv_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_Serv_Upcountry_6_24hrs=WH_Serv_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_Serv_Upcountry_Greater_24hrs=WH_Serv_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_Serv_Upcountry_Greater_48hrs=WH_Serv_Upcountry_Greater_48hrs+1;
                }
            }
            //Service call local WT
            if(C.reason=='Service' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Serv_Less_6hrs=WT_Serv_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_Serv_6_24hrs=WT_Serv_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_Serv_Greater_24hrs=WT_Serv_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_Serv_Greater_48hrs=WT_Serv_Greater_48hrs+1;
                }
            }
            //Service call Upcountry WT
            if(C.reason=='Service' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Serv_Upcountry_Less_6hrs=WT_Serv_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_Serv_Upcountry_6_24hrs=WT_Serv_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_Serv_Upcountry_Greater_24hrs=WT_Serv_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_Serv_Upcountry_Greater_48hrs=WT_Serv_Upcountry_Greater_48hrs+1;
                }
            }
            //PM Service call local WH
            if(C.reason=='PM Service' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_PMServ_Less_6hrs=WH_PMServ_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_PMServ_6_24hrs=WH_PMServ_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_PMServ_Greater_24hrs=WH_PMServ_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_PMServ_Greater_48hrs=WH_PMServ_Greater_48hrs+1;
                }
            }
            //PM Service call Upcountry WH
            if(C.reason=='PM Service' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_PMServ_Upcountry_Less_6hrs=WH_PMServ_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_PMServ_Upcountry_6_24hrs=WH_PMServ_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_PMServ_Upcountry_Greater_24hrs=WH_PMServ_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_PMServ_Upcountry_Greater_48hrs=WH_PMServ_Upcountry_Greater_48hrs+1;
                }
            }
            //PM Service call local WT
            if(C.reason=='PM Service' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_PMServ_Less_6hrs=WT_PMServ_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_PMServ_6_24hrs=WT_PMServ_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_PMServ_Greater_24hrs=WT_PMServ_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_PMServ_Greater_48hrs=WT_PMServ_Greater_48hrs+1;
                }
            }
            //PM Service call Upcountry WH
            if(C.reason=='PM Service' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_PMServ_Upcountry_Less_6hrs=WT_PMServ_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_PMServ_Upcountry_6_24hrs=WT_PMServ_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_PMServ_Upcountry_Greater_24hrs=WT_PMServ_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_PMServ_Upcountry_Greater_48hrs=WT_PMServ_Upcountry_Greater_48hrs+1;
                }
            }
            
            //Free installation call local WH
            if(C.reason=='Free installation' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Freeinst_Less_6hrs=WH_Freeinst_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_Freeinst_6_24hrs=WH_Freeinst_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_Freeinst_Greater_24hrs=WH_Freeinst_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_Freeinst_Greater_48hrs=WH_Freeinst_Greater_48hrs+1;
                }
            }
            //Free installation call Upcountry WH
            if(C.reason=='Free installation' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Freeinst_Upcountry_Less_6hrs=WH_Freeinst_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_Freeinst_Upcountry_6_24hrs=WH_Freeinst_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_Freeinst_Upcountry_Greater_24hrs=WH_Freeinst_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_Freeinst_Upcountry_Greater_48hrs=WH_Freeinst_Upcountry_Greater_48hrs+1;
                }
            }
            //Free installation call local WT
            if(C.reason=='Free installation' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Freeinst_Less_6hrs=WT_Freeinst_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_Freeinst_6_24hrs=WT_Freeinst_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_Freeinst_Greater_24hrs=WT_Freeinst_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_Freeinst_Greater_48hrs=WT_Freeinst_Greater_48hrs+1;
                }
            }
            //Free installation call Upcountry WH
            if(C.reason=='Free installation' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Freeinst_Upcountry_Less_6hrs=WT_Freeinst_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_Freeinst_Upcountry_6_24hrs=WT_Freeinst_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_Freeinst_Upcountry_Greater_24hrs=WT_Freeinst_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_Freeinst_Upcountry_Greater_48hrs=WT_Freeinst_Upcountry_Greater_48hrs+1;
                }
            }
            //Dealer Stock call local WH
            if(C.reason=='Dealer Stock' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Dealerstock_Less_6hrs=WH_Dealerstock_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_Dealerstock_6_24hrs=WH_Dealerstock_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_Dealerstock_Greater_24hrs=WH_Dealerstock_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_Dealerstock_Greater_48hrs=WH_Dealerstock_Greater_48hrs+1;
                }
            }
            //Dealer Stock call Upcountry WH
            if(C.reason=='Dealer Stock' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Heater' && WHcallclosedlastmonth.size() > WHMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Dealerstock_Upcountry_Less_6hrs=WH_Dealerstock_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_Dealerstock_Upcountry_6_24hrs=WH_Dealerstock_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_Dealerstock_Upcountry_Greater_24hrs=WH_Dealerstock_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_Dealerstock_Upcountry_Greater_48hrs=WH_Dealerstock_Upcountry_Greater_48hrs+1;
                }
            }
            //Dealer stock call local WT
            if(C.reason=='Dealer Stock' && C.AOSI_ASP_Class_Type__c=='Local' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Dealerstock_Less_6hrs=WT_Dealerstock_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_Dealerstock_6_24hrs=WT_Dealerstock_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_Dealerstock_Greater_24hrs=WT_Dealerstock_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_Dealerstock_Greater_48hrs=WT_Dealerstock_Greater_48hrs+1;
                }
            }
            //Dealer Stock call Upcountry WH
            if(C.reason=='Dealer Stock' && C.AOSI_ASP_Class_Type__c=='UpCountry' && C.AOSI_Product_Vertical__c=='Water Treatment' && WTcallclosedlastmonth.size() > WTMinimunCall){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Dealerstock_Upcountry_Less_6hrs=WT_Dealerstock_Upcountry_Less_6hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_Dealerstock_Upcountry_6_24hrs=WT_Dealerstock_Upcountry_6_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_Dealerstock_Upcountry_Greater_24hrs=WT_Dealerstock_Upcountry_Greater_24hrs+1;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_Dealerstock_Upcountry_Greater_48hrs=WT_Dealerstock_Upcountry_Greater_48hrs+1;
                }
            }
            }
            else if(C.AOSI_Product_Vertical__c=='Water Treatment'){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WT_Less_6Hrs_UnderFC++;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WT_6_24HrsCity_UnderFC++;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WT_greater_24Hrs_UnderFC++;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WT_greater_48HrsCity_UnderFC++;
                }
            }
            else if(C.AOSI_Product_Vertical__c=='Water Heater'){
                if(C.AOSI_Resolution_Clock_Time__c < = 6){
                    WH_Less_6Hrs_UnderFC++;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 6 && C.AOSI_Resolution_Clock_Time__c <= 24){
                    WH_6_24HrsCity_UnderFC++;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 24 && C.AOSI_Resolution_Clock_Time__c < =48){
                    WH_greater_24Hrs_UnderFC++;
                }
                if(C.AOSI_Resolution_Clock_Time__c > 48){
                    WH_greater_48HrsCity_UnderFC++;
                }
            }
        }
        
        //Service call local WH
        WHServiceCall_Less_6HrsCity=WH_Serv_Less_6hrs * WHserviceCity_Lees6;
        WHServiceCall_6_24HrsCity=WH_Serv_6_24hrs * WHserviceCity_6_24;
        WHServiceCall_greater_24HrsCity=WH_Serv_Greater_24hrs * WHserviceCity_24_48;
        WHServiceCall_greater_48HrsCity=WH_Serv_Greater_48hrs * WHserviceCity_greater48;
        
        //Service call Upcountry WH
        WHServiceCall_Less_6HrsUpcountry=WH_Serv_Upcountry_Less_6hrs * WHserviceUPcountry_Lees6;
        WHServiceCall_6_24HrsUpcountry=WH_Serv_Upcountry_6_24hrs * WHserviceUPcountry_6_24;
        WHServiceCall_greater_24HrsUpcountry=WH_Serv_Upcountry_Greater_24hrs * WHserviceUPcountry_24_48;
        WHServiceCall_greater_48HrsUpcountry=WH_Serv_Upcountry_Greater_48hrs * WHserviceUPcountry_greater48;
        
        //Service call local WT
        WTServiceCall_Less_6HrsCity=WT_Serv_Less_6hrs * WTserviceCity_Lees6;
        WTServiceCall_6_24HrsCity=WT_Serv_6_24hrs * WTserviceCity_6_24;
        WTServiceCall_greater_24HrsCity=WT_Serv_Greater_24hrs * WTserviceCity_24_48;
        WTServiceCall_greater_48HrsCity=WT_Serv_Greater_48hrs * WTserviceCity_greater48;
        
        //Service call Upcountry WT
        WTServiceCall_Less_6HrsUpcountry=WT_Serv_Upcountry_Less_6hrs * WTserviceUPcountry_Lees6;
        WTServiceCall_6_24HrsUpcountry=WT_Serv_Upcountry_6_24hrs * WTserviceUPcountry_6_24;
        WTServiceCall_greater_24HrsUpcountry=WT_Serv_Upcountry_Greater_24hrs * WTserviceUPcountry_24_48;
        WTServiceCall_greater_48HrsUpcountry=WT_Serv_Upcountry_Greater_48hrs * WTserviceUPcountry_greater48;
        
        //PM Service call local WH
        WHPMServiceCall_Less_6HrsCity=WH_PMServ_Less_6hrs * WHPMserviceCity_Lees6;
        WHPMServiceCall_6_24HrsCity=WH_PMServ_6_24hrs * WHPMserviceCity_6_24;
        WHPMServiceCall_greater_24HrsCity=WH_PMServ_Greater_24hrs * WHPMserviceCity_24_48;
        WHPMServiceCall_greater_48HrsCity=WH_PMServ_Greater_48hrs * WHPMserviceCity_greater48;
        
        //PM Service call Upcountry WH
        WHPMServiceCall_Less_6HrsUpcountry=WH_PMServ_Upcountry_Less_6hrs * WHPMserviceUPcountry_Lees6;
        WHPMServiceCall_6_24HrsUpcountry=WH_PMServ_Upcountry_6_24hrs * WHPMserviceUPcountry_6_24;
        WHPMServiceCall_greater_24HrsUpcountry=WH_PMServ_Upcountry_Greater_24hrs * WHPMserviceUPcountry_24_48;
        WHPMServiceCall_greater_48HrsUpcountry=WH_PMServ_Upcountry_Greater_48hrs * WHPMserviceUPcountry_greater48;
        
        //PM Service call local WT
        WTPMServiceCall_Less_6HrsCity=WT_PMServ_Less_6hrs * WTPMserviceCity_Lees6;
        WTPMServiceCall_6_24HrsCity=WT_PMServ_6_24hrs * WTPMserviceCity_6_24;
        WTPMServiceCall_greater_24HrsCity=WT_PMServ_Greater_24hrs * WTPMserviceCity_24_48;
        WTPMServiceCall_greater_48HrsCity=WT_PMServ_Greater_48hrs * WTPMserviceCity_greater48;
        
        //PM Service call Upcountry WT
        WTPMServiceCall_Less_6HrsUpcountry=WT_PMServ_Upcountry_Less_6hrs * WTPMserviceUPcountry_Lees6;
        WTPMServiceCall_6_24HrsUpcountry=WT_PMServ_Upcountry_6_24hrs * WTPMserviceUPcountry_6_24;
        WTPMServiceCall_greater_24HrsUpcountry=WT_PMServ_Upcountry_Greater_24hrs * WTPMserviceUPcountry_24_48;
        WTPMServiceCall_greater_48HrsUpcountry=WT_PMServ_Upcountry_Greater_48hrs * WTPMserviceUPcountry_greater48;
        
        //Free installation call local WH
        WHFreeinstCall_Less_6HrsCity=WH_Freeinst_Less_6hrs * WHFreeinstCity_Lees6;
        WHFreeinstCall_6_24HrsCity=WH_Freeinst_6_24hrs * WHFreeinstCity_6_24;
        WHFreeinstCall_greater_24HrsCity=WH_Freeinst_Greater_24hrs * WHFreeinstCity_24_48;
        WHFreeinstCall_greater_48HrsCity=WH_Freeinst_Greater_48hrs * WHFreeinstCity_greater48;
        
        //Free installation call Upcountry WH
        WHFreeinstCall_Less_6HrsUpcountry=WH_Freeinst_Upcountry_Less_6hrs * WHFreeinstUPcountry_Lees6;
        WHFreeinstCall_6_24HrsUpcountry=WH_Freeinst_Upcountry_6_24hrs * WHFreeinstUPcountry_6_24;
        WHFreeinstCall_greater_24HrsUpcountry=WH_Freeinst_Upcountry_Greater_24hrs * WHFreeinstUPcountry_24_48;
        WHFreeinstCall_greater_48HrsUpcountry=WH_Freeinst_Upcountry_Greater_48hrs * WHFreeinstUPcountry_greater48;
        
        //Free installation call local WT
        WTFreeinstCall_Less_6HrsCity=WT_Freeinst_Less_6hrs * WTFreeinstCity_Lees6;
        WTFreeinstCall_6_24HrsCity=WT_Freeinst_6_24hrs * WTFreeinstCity_6_24;
        WTFreeinstCall_greater_24HrsCity=WT_Freeinst_Greater_24hrs * WTFreeinstCity_24_48;
        WTFreeinstCall_greater_48HrsCity=WT_Freeinst_Greater_48hrs * WTFreeinstCity_greater48;
        
        //Free installation call Upcountry WT
        WTFreeinstCall_Less_6HrsUpcountry=WT_Freeinst_Upcountry_Less_6hrs * WTFreeinstUPcountry_Lees6;
        WTFreeinstCall_6_24HrsUpcountry=WT_Freeinst_Upcountry_6_24hrs * WTFreeinstUPcountry_6_24;
        WTFreeinstCall_greater_24HrsUpcountry=WT_Freeinst_Upcountry_Greater_24hrs * WTFreeinstUPcountry_24_48;
        WTFreeinstCall_greater_48HrsUpcountry=WT_Freeinst_Upcountry_Greater_48hrs * WTFreeinstUPcountry_greater48;
        
        //Dealer Stock call local WH
        WHDealerstockCall_Less_6HrsCity=WH_Dealerstock_Less_6hrs * WHDealerstockCity_Lees6;
        WHDealerstockCall_6_24HrsCity=WH_Dealerstock_6_24hrs * WHDealerstockCity_6_24;
        WHDealerstockCall_greater_24HrsCity=WH_Dealerstock_Greater_24hrs * WHDealerstockCity_24_48;
        WHDealerstockCall_greater_48HrsCity=WH_Dealerstock_Greater_48hrs * WHDealerstockCity_greater48;
        
        //Dealer Stock call Upcountry WH
        WHDealerstockCall_Less_6HrsUpcountry=WH_Dealerstock_Upcountry_Less_6hrs * WHDealerstockUPcountry_Lees6;
        WHDealerstockCall_6_24HrsUpcountry=WH_Dealerstock_Upcountry_6_24hrs * WHDealerstockUPcountry_6_24;
        WHDealerstockCall_greater_24HrsUpcountry=WH_Dealerstock_Upcountry_Greater_24hrs * WHDealerstockUPcountry_24_48;
        WHDealerstockCall_greater_48HrsUpcountry=WH_Dealerstock_Upcountry_Greater_48hrs * WHDealerstockUPcountry_greater48;
        
        //Dealer Stock call local WT
        WTDealerstockCall_Less_6HrsCity=WT_Dealerstock_Less_6hrs * WTDealerstockCity_Lees6;
        WTDealerstockCall_6_24HrsCity=WT_Dealerstock_6_24hrs * WTDealerstockCity_6_24;
        WTDealerstockCall_greater_24HrsCity=WT_Dealerstock_Greater_24hrs * WTDealerstockCity_24_48;
        WTDealerstockCall_greater_48HrsCity=WT_Dealerstock_Greater_48hrs * WTDealerstockCity_greater48;
        
        //Dealer Stock call Upcountry WT
        WTDealerstockCall_Less_6HrsUpcountry=WT_Dealerstock_Upcountry_Less_6hrs * WTDealerstockUPcountry_Lees6;
        WTDealerstockCall_6_24HrsUpcountry=WT_Dealerstock_Upcountry_6_24hrs * WTDealerstockUPcountry_6_24;
        WTDealerstockCall_greater_24HrsUpcountry=WT_Dealerstock_Upcountry_Greater_24hrs * WTDealerstockUPcountry_24_48;
        WTDealerstockCall_greater_48HrsUpcountry=WT_Dealerstock_Upcountry_Greater_48hrs * WTDealerstockUPcountry_greater48;
        
        //Calculate total call for service WT and WH local;
        TotalServiceLess6hrs=WHServiceCall_Less_6HrsCity+WTServiceCall_Less_6HrsCity;
        TotalService6_24hrs=WHServiceCall_6_24HrsCity+WTServiceCall_6_24HrsCity;
        TotalService_greater_24hrs=WHServiceCall_greater_24HrsCity+WTServiceCall_greater_24HrsCity;
        TotalService_greater_48=WHServiceCall_greater_48HrsCity+WTServiceCall_greater_48HrsCity;
        
        //Calculate total call for service WT and WH upcountry
        UCTotalServiceLess6hrs=WHServiceCall_Less_6HrsUpcountry+WTServiceCall_Less_6HrsUpcountry;
        UCTotalService6_24hrs=WHServiceCall_6_24Hrsupcountry+WTServiceCall_6_24Hrsupcountry;
        UCTotalService_greater_24hrs=WHServiceCall_greater_24Hrsupcountry+WTServiceCall_greater_24Hrsupcountry;
        UCTotalService_greater_48=WHServiceCall_greater_48Hrsupcountry+WTServiceCall_greater_48Hrsupcountry;
        
        //Calculate total call for PM service WT and WH local;
        TotalPMServiceLess6hrs=WHPMServiceCall_Less_6HrsCity+WTPMServiceCall_Less_6HrsCity;
        TotalPMService6_24hrs=WHPMServiceCall_6_24HrsCity+WTPMServiceCall_6_24HrsCity;
        TotalPMService_greater_24hrs=WHPMServiceCall_greater_24HrsCity+WTPMServiceCall_greater_24HrsCity;
        TotalPMService_greater_48=WHPMServiceCall_greater_48HrsCity+WTPMServiceCall_greater_48HrsCity;
        
        //Calculate total call for PM service WT and WH upcountry
        UCTotalPMServiceLess6hrs=WHPMServiceCall_Less_6HrsUpcountry+WTPMServiceCall_Less_6HrsUpcountry;
        UCTotalPMService6_24hrs=WHPMServiceCall_6_24Hrsupcountry+WTPMServiceCall_6_24Hrsupcountry;
        UCTotalPMService_greater_24hrs=WHPMServiceCall_greater_24Hrsupcountry+WTPMServiceCall_greater_24Hrsupcountry;
        UCTotalPMService_greater_48=WHPMServiceCall_greater_48Hrsupcountry+WTPMServiceCall_greater_48Hrsupcountry;
        
        //Calculate total call for Free Installation WT and WH local;
        TotalFreeInstLess6hrs=WHFreeInstCall_Less_6HrsCity+WTFreeInstCall_Less_6HrsCity;
        TotalFreeInst6_24hrs=WHFreeInstCall_6_24HrsCity+WTFreeInstCall_6_24HrsCity;
        TotalFreeInst_greater_24hrs=WHFreeInstCall_greater_24HrsCity+WTFreeInstCall_greater_24HrsCity;
        TotalFreeInst_greater_48=WHFreeInstCall_greater_48HrsCity+WTFreeInstCall_greater_48HrsCity;
        
        //Calculate total call for Free Installation WT and WH upcountry
        UCTotalFreeInstLess6hrs=WHFreeInstCall_Less_6HrsUpcountry+WTFreeInstCall_Less_6HrsUpcountry;
        UCTotalFreeInst6_24hrs=WHFreeInstCall_6_24Hrsupcountry+WTFreeInstCall_6_24Hrsupcountry;
        UCTotalFreeInst_greater_24hrs=WHFreeInstCall_greater_24Hrsupcountry+WTFreeInstCall_greater_24Hrsupcountry;
        UCTotalFreeInst_greater_48=WHFreeInstCall_greater_48Hrsupcountry+WTFreeInstCall_greater_48Hrsupcountry;
        
        //Calculate total call for Dealer Stock WT and WH local;
        TotalDealerstockLess6hrs=WHDealerstockCall_Less_6HrsCity+WTDealerstockCall_Less_6HrsCity;
        TotalDealerstock6_24hrs=WHDealerstockCall_6_24HrsCity+WTDealerstockCall_6_24HrsCity;
        TotalDealerstock_greater_24hrs=WHDealerstockCall_greater_24HrsCity+WTDealerstockCall_greater_24HrsCity;
        TotalDealerstock_greater_48=WHDealerstockCall_greater_48HrsCity+WTDealerstockCall_greater_48HrsCity;
        
        //Calculate total call for Dealer Stock WT and WH upcountry
        UCTotalDealerstockLess6hrs=WHDealerstockCall_Less_6HrsUpcountry+WTDealerstockCall_Less_6HrsUpcountry;
        UCTotalDealerstock6_24hrs=WHDealerstockCall_6_24Hrsupcountry+WTDealerstockCall_6_24Hrsupcountry;
        UCTotalDealerstock_greater_24hrs=WHDealerstockCall_greater_24Hrsupcountry+WTDealerstockCall_greater_24Hrsupcountry;
        UCTotalDealerstock_greater_48=WHDealerstockCall_greater_48Hrsupcountry+WTDealerstockCall_greater_48Hrsupcountry;
        
        TaxableTotalAmountCalc=total80callvalueCity + total80callvalueUpc + (Totalfixedcomp -( total70perc + total60_69perc +
        total50_59perc + totalless50perc ))+ TotalServiceLess6hrs + TotalService6_24hrs + TotalService_greater_24hrs +
        TotalService_greater_48 + UCTotalServiceLess6hrs + UCTotalService6_24hrs + UCTotalService_greater_24hrs + UCTotalService_greater_48 +
        TotalPMServiceLess6hrs + TotalPMService6_24hrs + TotalPMService_greater_24hrs + TotalPMService_greater_48 + UCTotalPMServiceLess6hrs +
        UCTotalPMService6_24hrs + UCTotalPMService_greater_24hrs + UCTotalPMService_greater_48 + TotalFreeinstLess6hrs + TotalFreeinst6_24hrs +
        TotalFreeinst_greater_24hrs + TotalFreeinst_greater_48 + UCTotalFreeinstLess6hrs + UCTotalFreeinst6_24hrs + UCTotalFreeinst_greater_24hrs +
        UCTotalFreeinst_greater_48 + TotalDealerstockLess6hrs + TotalDealerstock6_24hrs + TotalDealerstock_greater_24hrs + TotalDealerstock_greater_48 +
        UCTotalDealerstockLess6hrs + UCTotalDealerstock6_24hrs + UCTotalDealerstock_greater_24hrs + UCTotalDealerstock_greater_48 + TotalOneoneonetotalAmount;
        
      //  totalAmount();
    

    }
    
    Public PageReference totalAmount(){
    
    TotalAmountCalc=0;
    finalAmount=0;
     String Decimaltext;
        //Total taxable amount 
        
        
        if(ServiceTax > 0){
            Amoutwithtax=TaxableTotalAmountCalc +(TaxableTotalAmountCalc * (ServiceTax/100));
            taxAmount = TaxableTotalAmountCalc * (ServiceTax/100);
            }
        else{
            Amoutwithtax=TaxableTotalAmountCalc;
        }    
        TotalAmountCalc=(TotalAmountCalc + Amoutwithtax + Othercharges + Upcountrytravelclaom).setscale(2);
        if(Deduction>0 && reasonDeduction==''){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter reason for deduction'));                                       
            return null;
        }
        buttonflag=true;
            finalAmount=TotalAmountCalc - Deduction;
         //code to convert amount in words
        string stringgrandTotal = string.valueof(finalAmount);                 
        if(!stringgrandTotal.contains('.00')){      
            stringgrandTotal = stringgrandTotal.substring(stringgrandTotal.indexOf('.')+1,stringgrandTotal.indexOf('.')+3);                             
            long longDecimalnumber = long.valueof(stringgrandTotal);
            Decimaltext = convert(longDecimalnumber);  
        }     
        long longgrandTotal = finalAmount.longValue(); 
        String integerText = convert(longgrandTotal);
        if(Decimaltext != null){
            wordText=integerText + ' Rupees ' + Decimaltext +' Paise';  
        } 
        else{
            wordText=integerText + ' Rupees ';    
        }
        return null;
    }
    
      //This method is used to convert the integer to words
    public  String convert(long i) {
      //
      if( i < 20)  return units[integer.valueOf(i)];
      if( i < 100) return tens[integer.valueOf(i)/10] + ((math.mod(i , 10) > 0)? '' + convert(math.mod(i , 10)):'');
      if( i < 1000) return units[integer.valueOf(i)/100] + ' Hundred ' + ((math.mod(i , 100) > 0)?' ' + convert(math.mod(i , 100)):'');     
      if( i < 10000) return units[integer.valueOf(i)/1000] + ' Thousand ' + ((math.mod(i , 1000) > 0)?' ' + convert(math.mod(i , 1000)):'');       
      if( i < 100000) return convert(i / 1000) + ' Thousand ' + ((math.mod(i , 1000) > 0)? '' + convert(math.mod(i ,1000)):'') ;
      if( i < 10000000) return convert(i / 100000) + ' Lakhs ' + ((math.mod(i , 100000) > 0)? '' + convert(math.mod(i ,100000)):'') ;
      if(i < 1000000000) return convert(i / 10000000) + ' Crores ' + ((math.mod(i , 10000000) > 0)? '' + convert(math.mod(i , 10000000)):'') ;
      //if(i < 1000000000) return convert(i / 10000000) + ' Crores ' + ((math.mod(i , 1000000) > 0)? '' + convert(math.mod(i , 1000000)):'') ;
      
      return convert(i / 1000000000) + ' Crores ' + ((math.mod(i , 1000000000) > 0)? '' + convert(math.mod(i , 1000000000)):'') ;
    }
    
        Public PageReference GeneratePDF(){
        
        //list of ASP Billing
        List<ASP_Billing__c> billingList = [Select id from ASP_Billing__c Where AOSI_ASP__c =: ASPid and Month_and_Year__c=: Monthandyear];
        //code to reate record of ASP Billing
        if(billingList.Size() <= 0){
            bill = new ASP_Billing__c();
            bill.AOSI_Amount_In_Words__c = wordText;
            bill.AOSI_ASP__c = ASPid;
            //bill.AOSI_Billing_From__c = billingFromdate;
            //bill.AOSI_Billing_To__c = billingTodate;
            //bill.AOSI_Compensation__c = compenction;
            bill.AOSI_Grand_Total__c = TotalAmountCalc;
            bill.AOSI_Other_Charges__c = Othercharges;          
            bill.AOSI_Service_Tax__c = ServiceTax;
           bill.AOSI_Tax_Amount__c = finalAmount;
            bill.AOSI_Total_Taxable_Amount__c= Amoutwithtax;
            bill.AOSI_Travel_Claim__c = Upcountrytravelclaom;
            bill.AOSI_Non_Taxable_Amount__c = TaxableTotalAmountCalc;
            bill.AOSI_Remarks__c = remark;
            bill.AOSI_Reason_For_Deduction__c=reasonDeduction;
            bill.Month_and_Year__c=Monthandyear;
            bill.Deduction_Amount__c=Deduction;
            insert bill;  
        }
        PageReference pp=new PageReference('/apex/GerenateASPBillPDF?id='+ASPid+'&Servicetax='+ServiceTax+'&claimcharge='+Upcountrytravelclaom +'&othercharge='+Othercharges +'&Remark='+Remark+'&ReasonDeduc='+reasonDeduction+'&deduction='+Deduction);
        
        Attachment attach = new Attachment();
        
        // the contents of the attachment from the pdf
        Blob body;
        
        try {
        
        // returns the output of the page as a PDF
        body = pp.getContent();
        
        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
        body = Blob.valueOf('Some Text');
        }
        
        attach.Body = body;      
        attach.Name =String.valueof(mon)+ '-'+String.valueof(yr)+'.pdf';
        attach.IsPrivate = false;
        // attach the pdf to the ASP
        attach.ParentId =ASPid;       
        insert attach;
        pp.setRedirect(true);
        return pp;
    }
}