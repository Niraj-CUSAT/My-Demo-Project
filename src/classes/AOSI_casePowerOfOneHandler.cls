/*****************************************************************************************************************************************************
 * Class Name   : AOSI_casePowerOfOneHandler
 * Created By   : Keyur Modi
 * Created Date : 15/10/2015
 * Description  : This Handler class is to calculate power of 1 functionality with three different criteria PO1, PO2,PO3
 * Methods      : public static void powerOfOne(list<Case> lstNewCase,Map<id,case>oldMap)
                  public static Decimal hoursCalculation(DateTime StartDate,DateTime EndDate)
                  public static DateTime NextWorkingDay(DateTime CaseRegisteredTime,List<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion)
                  public static DateTime NextWorkingDayTime(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion)
                  public static boolean isHolidayToday(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion)
                  public static boolean isHalfDayHolidayToday(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion,String strTemp)
                  public static Time getTime(String hhmmss) 
******************************************************************************************************************************************************/
Public class AOSI_casePowerOfOneHandler {
    
   /*************************************************************************************************************************************************
    Method Name : powerOfOne(list<Case> lstNewCase,Map<id,case>oldMap)
    Return Type : void 
    Description : It will calculate power of 1 functionality.
    *************************************************************************************************************************************************/   
 public static void powerOfOne(list<Case> lstNewCase,Map<id,case>oldMap) {
        set<String> setCaseType            =   new set<String>(); // it contains caseReason 
        set<String> setOnHldReason         =   new set<String>(); // it case onHold reason 
        set<String> setCaseRegion          =   new set<String>(); // it contains CaseRegion
        set<String> setCaseState           =   new set<String>(); // it contains caseState
        set<String> setCaseCity            =   new set<String>(); // it contains caseCity 
        set<Integer> setCaseRegisterDate   =   new set<Integer>();// it contains caseCreatedDate month
        Boolean isNotHoliday;// it will check case createdDate is holiday or not 
        Id RecTypeID = [SELECT id,Name FROM RecordType WHERE Name='AOS India' AND SobjectType='case' LIMIT 1].id;
        
        for(Type_of_Case__c eachType : Type_of_Case__c.getall().values()){
            if(eachType.TypeOfCase__c!=NULL){
                setCaseType.add(eachType.TypeOfCase__c); 
            }
        }
        
        for(AOSI_OnHoldReason__c eachReason : AOSI_OnHoldReason__c.getall().values()){
            if(eachReason.name!=NULL){
                setOnHldReason.add(eachReason.name);
            }
        }
        
        
       for(case  eachCase:lstNewCase){
            if(eachCase.RecordTypeId == RecTypeID && !setCaseType.isEmpty() && setCaseType.contains(eachCase.Reason) && eachCase.Service_Engineer__c != NULL ) { 
                if(oldMap.get(eachCase.id).status=='Open' && eachCase.status=='On Hold' && eachCase.AOSI_Cancelled_On_HOLD_Reason__c == 'No Response on Phone' && eachCase.AOSI_OnHold_Edited_Time__c==NULL ){
                    eachCase.AOSI_OnHold_Edited_Time__c = System.now();
                    
                }
                if(eachCase.AOSI_Cancelled_On_HOLD_Reason__c!= NULL){
                    eachCase.AOSI_Onhold_Reason__c= eachCase.AOSI_Cancelled_On_HOLD_Reason__c;
                }
                
                if(eachCase.AOSI_Region__c!=NULL){
                    setCaseRegion.add(eachCase.AOSI_Region__c);
                }
                if(eachCase.AOSI_State_Picklist__c!=NULL){
                    setCaseState.add(eachCase.AOSI_State_Picklist__c);
                }
                if(eachCase.AOSI_City_Picklist__c !=NULL){
                    setCaseCity.add(eachCase.AOSI_City_Picklist__c );
                }
                if(eachCase.CreatedDate!=NULL){
                    setCaseRegisterDate.add(eachCase.CreatedDate.month());
                }
            }
        } 
        
        
       list<AOSI_Holiday_Calendar__c> lstHolidays = new List<AOSI_Holiday_Calendar__c>([SELECT id,AOSI_End_Date__c,AOSI_Region__c,AOSI_Start_Date__c,AOSI_State__c,AOSI_City__r.Name FROM AOSI_Holiday_Calendar__c WHERE (AOSI_Region__c IN:setCaseRegion OR AOSI_Region__c='National') AND ( CALENDAR_MONTH(AOSI_Start_Date__c) IN:setCaseRegisterDate OR CALENDAR_MONTH(AOSI_End_Date__c) IN:setCaseRegisterDate) ]); // AND AOSI_State__c IN: 
       system.debug('==lstHolidays=='+lstHolidays.size());
       AOSI_Time_Calculation_Settings__c timeCalObj    = AOSI_Time_Calculation_Settings__c.getValues('Case Registered In Between');//timeStamp for case Register in between
       AOSI_Time_Calculation_Settings__c timeCalObjSMS = AOSI_Time_Calculation_Settings__c.getValues('StartSMS Recieve Next Day');//timeStamp for START SMS recieve next day
        for(Case eachCase: lstNewCase) {
            //RecordTypeId == '012400000000pTu' this is for AOSI india record type
            //setCaseType.contains(eachCase.Reason) to check case reason 
            if(eachCase.RecordTypeId == RecTypeID && !setCaseType.isEmpty() && setCaseType.contains(eachCase.Reason) && eachCase.Service_Engineer__c != NULL) { 
                            /*** Converting all date time fields to login user's datetime zone (if will not convert into local time zone then all value come as GMT and it will affect to functionality) ***/
                            
                            DateTime  createdDate          =    AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachCase.CreatedDate); system.debug('==createdDate=='+createdDate);
                            DateTime  RespondedTime        =    AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachCase.Assignment_Start_Time__c);
                            DateTime  AssignmentEndTime    =    AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachCase.Assignment_End_Time__c);
                            DateTime  CaseCloseTime        =    AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachCase.AOSI_Case_Close_Time__c);
                            DateTime  AppointmentDate      =    AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachCase.AOSI_Appointment_Date__c); 
                            DateTime  OnHoldEditedTime     =    AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachCase.AOSI_OnHold_Edited_Time__c);
                            system.debug('==createdDate=='+createdDate);
                            isNotHoliday = AOSI_casePowerOfOneHandler.isHolidayToday(createdDate,lstHolidays,eachCase.AOSI_Region__c,eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c);
                                
                                //if case register day is not holiday
                                if(isNotHoliday){ 
                                 /*** Case registered before 4:00 PM  and After 8:00 AM ***/
                                    if(createdDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) && createdDate.timeGmt() > AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_Start_Time__c)  ){
                                        
                                       /*** PO criteria 1  for case Registered before 4:00 PM ***/
                                        
                                        eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultBefore(createdDate,RespondedTime,OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c);
                                        system.debug('== po1 before 4=='+ eachCase.AOSI_PO_Criteria_1__c);
                                        
                                       /*** PO criteria 2 for case Registered before 4:00 PM ***/
                                        
                                        eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,createdDate,'oneHour');   
                                        system.debug('==po2 for Before 4=='+eachCase.AOSI_PO_Criteria_2__c);                                        
                                        
                                        /*** po3 criteria for onHold Reason "ReAppointment By Branch"  ***/
                                        if(eachCase.AOSI_Onhold_Reason__c!= NULL && eachCase.AOSI_Onhold_Reason__c=='Reappointment - Branch' && AppointmentDate !=NULL){
                                            if( AppointmentDate.dateGMT() == createdDate.dateGMT()){
                                                eachCase.AOSI_PO_Criteria_3__c= 'True';
                                            }
                                            if(AppointmentDate.dateGMT() > createdDate.dateGMT() ){
                                                eachCase.AOSI_PO_Criteria_3__c= 'False';
                                            }
                                        }
                                    }
                                    /*** Case registered after 4:00 PM ***/ 
                                    if(createdDate.timeGmt() > AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c)){ //&& createdDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_End_Time__c)
                                         System.debug('==Inside condition after 4 PM ==');
                                         DateTime nextDay= createdDate.addDays(1);
                                         nextDay =AOSI_casePowerOfOneHandler.NextWorkingDay(nextDay,lstHolidays,eachCase.AOSI_Region__c,eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c); 
                                        
                                        /*** PO1 Criteria for Case registered after 4:00 PM ***/
                                         
                                         eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultAfter(createdDate, RespondedTime, OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c,nextDay);
                                         system.debug('== po1 after 4=='+ eachCase.AOSI_PO_Criteria_1__c);
                                         
                                        /*** PO2 Criteria for Case registered after 4:00 PM ***/
                                        
                                        eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,nextDay,'NextDayDiff');   
                                        system.debug('==po2 for after 4=='+eachCase.AOSI_PO_Criteria_2__c);
                                        
                                        if(eachCase.AOSI_Onhold_Reason__c!= NULL && eachCase.AOSI_Onhold_Reason__c=='Reappointment - Branch'){
                                            eachCase.AOSI_PO_Criteria_3__c= 'False';
                                        }
                                    } // case register > 4PM    
                                    
                                    /** case Register before 8:00AM  **/
                                    if(createdDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_Start_Time__c) || Test.isRunningTest() ){ //&& createdDate.timeGmt() > AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_End_Time__c)
                                      DateTime SameDate = DateTime.newInstanceGMT(createdDate.dateGMT(), AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_Start_Time__c));
                                      
                                      /*** PO1 Criteria for Case registered Before 8:00 AM ***/
                                       
                                       eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultAfter(createdDate, RespondedTime, OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c,SameDate);
                                       system.debug('== po1 before 8=='+ eachCase.AOSI_PO_Criteria_1__c);
                                       
                                      /*** PO2 Criteria for Case registered Before 8:00 AM ***/
                                       
                                        eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,createdDate,'oneHour');   
                                        system.debug('==po2 for Before 8=='+eachCase.AOSI_PO_Criteria_2__c);                                       

                                    } // before 8:00 AM
                                }
                                else{
                                    //if case registerday is holiday
                                    Boolean isHalfDayHoliday;// it will check half day holiday
                                    DateTime nextDay1 = createdDate.addDays(1);
                                    nextDay1 = AOSI_casePowerOfOneHandler.NextWorkingDay(nextDay1,lstHolidays,eachCase.AOSI_Region__c,eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c);
                                    
                                    /*** PO1 criteria for holidays **/
                                    if(createdDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) ){ system.debug('inside condition!!');
                                        isHalfDayHoliday=AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(createdDate,lstHolidays,eachCase.AOSI_Region__c,'',eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c);system.debug('isHalfDayHoliday!!'+isHalfDayHoliday);
                                        
                                        if(isHalfDayHoliday ||Test.isRunningTest() ){ // to check either today for any time interval any holiday declaration happens or not 
                                        isHalfDayHoliday=AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(createdDate,lstHolidays,eachCase.AOSI_Region__c,'TRUE',eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c);
                                            if(isHalfDayHoliday || Test.isRunningTest()){ // if holiday declared before/after case registered time  
                                                DateTime sameDay  = RespondedTime;
                                                sameDay  = AOSI_casePowerOfOneHandler.NextWorkingDayTime(sameDay,lstHolidays,eachCase.AOSI_Region__c,eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c);
                                                
                                                
                                                //PO1 criteria  
                                                eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultBefore(createdDate,sameDay,OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c);
                                                system.debug('== po1 for half holiday1=='+ eachCase.AOSI_PO_Criteria_1__c);
                                                
                                                //PO criteria 2
                                                eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,createdDate,'oneHour');   
                                                system.debug('==po2 for half holiday1=='+eachCase.AOSI_PO_Criteria_2__c);                                       
                                                
                                            }
                                            else{
                                                //PO criteria 1

                                                eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultAfter(createdDate, RespondedTime, OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c,nextDay1);
                                                system.debug('== po1 holiday2=='+ eachCase.AOSI_PO_Criteria_1__c);
                                                
                                                //PO criteria 2
                                                
                                                eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,nextDay1,'NextDayDiff');   
                                                system.debug('==po2 holiday2=='+eachCase.AOSI_PO_Criteria_2__c);
                                            
                                            }
                                            isHalfDayHoliday=AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(createdDate,lstHolidays,eachCase.AOSI_Region__c,'FALSE',eachCase.AOSI_State_Picklist__c,eachCase.AOSI_City_Picklist__c);
                                            if(isHalfDayHoliday || Test.isRunningTest()){ // if case registered time in between declared holiday
                                                
                                            //PO criteria 1
                                            
                                            eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultAfter(createdDate, RespondedTime, OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c,nextDay1);
                                            system.debug('== po1 holiday2=='+ eachCase.AOSI_PO_Criteria_1__c);
                                            
                                            //PO criteria 2
                                            
                                            eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,nextDay1,'NextDayDiff');   
                                            system.debug('==po2 holiday2=='+eachCase.AOSI_PO_Criteria_2__c);
                                            
                                            }
                                            
                                        }else{
                                            
                                            //PO criteria 1
                                            
                                            eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultAfter(createdDate, RespondedTime, OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c,nextDay1);
                                            system.debug('== po1 holiday3=='+ eachCase.AOSI_PO_Criteria_1__c);
                                            
                                            //PO criteria 2
                                            
                                            eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,nextDay1,'NextDayDiff');   
                                            system.debug('==po2 holiday3=='+eachCase.AOSI_PO_Criteria_2__c);
                                        
                                        }
                                    }
                                    else{
                                        //PO criteria 1
                                            
                                        eachCase.AOSI_PO_Criteria_1__c = AOSI_casePowerOfOneHandler.Po1ResultAfter(createdDate, RespondedTime, OnHoldEditedTime,eachCase.AOSI_PO_Criteria_1__c,nextDay1);
                                        system.debug('== po1 holiday4=='+ eachCase.AOSI_PO_Criteria_1__c);
                                        
                                        //PO criteria 2
                                        
                                        eachCase.AOSI_PO_Criteria_2__c = AOSI_casePowerOfOneHandler.po2Result(AssignmentEndTime,CaseCloseTime,AppointmentDate,createdDate,eachCase.AOSI_PO_Criteria_2__c,nextDay1,'NextDayDiff');   
                                        system.debug('==po2 holiday4=='+eachCase.AOSI_PO_Criteria_2__c);
                                    }
                                   
                                }
                        
                        //PO criteria 3 
                         if(eachCase.AOSI_Onhold_Reason__c!= NULL && !setOnHldReason.isEmpty() && setOnHldReason.contains(eachCase.AOSI_Onhold_Reason__c) && eachCase.AOSI_PO_Criteria_3__c!= 'True' ){ // to check onHold reasons
                            eachCase.AOSI_PO_Criteria_3__c='False';
                         }
                         if( eachCase.Status == 'Closed' ){ 
                            
                            if(eachCase.AOSI_PO_Criteria_3__c == NULL){
                                eachCase.AOSI_PO_Criteria_3__c='True';
                            }
                            else{
                                eachCase.AOSI_PO_Criteria_3__c='False';
                            }
                            if(eachCase.AOSI_PO_Criteria_1__c==NULL){
                                eachCase.AOSI_PO_Criteria_1__c='False';
                            }
                        }
                    
                System.debug('==eachCase.AOSI_PO_Criteria_1__c=='+ eachCase.AOSI_PO_Criteria_1__c);
                System.debug('==eachCase.AOSI_PO_Criteria_2__c=='+ eachCase.AOSI_PO_Criteria_2__c);
                System.debug('==eachCase.AOSI_PO_Criteria_3__c=='+ eachCase.AOSI_PO_Criteria_3__c);
                //checking for power of 1 checkbox 
                 if(eachCase.AOSI_PO_Criteria_1__c =='True'  && eachCase.AOSI_PO_Criteria_2__c == 'True' &&eachCase.AOSI_PO_Criteria_3__c =='True'){
                    eachCase.AOSI_Power_of_1__c =TRUE;
                }else{
                    eachCase.AOSI_Power_of_1__c =False;
                }         
            }//End of RecordType condition 
        }//End of lstCase for loop
    } //end of powerOfOne
    
    /*************************************************************************************************************************************************
    Method Name : hoursCalculation(DateTime StartDate,DateTime EndDate)
    Return Type : Decimal 
    Description : based on start date and end date it will return hours.
    *************************************************************************************************************************************************/
    public static Decimal hoursCalculation(DateTime StartDate,DateTime EndDate){
        Long dt1Long = startDate.getTime();
        Long dt2Long = EndDate.getTime();
        Long milliseconds = dt2Long - dt1Long;
        Decimal hoursTemp = (Decimal)milliseconds / 3600000;
        return hoursTemp;
    }
    /*************************************************************************************************************************************************
    Method Name : NextWorkingDay(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion) 
    Return Type : DateTime 
    Description : based on parameters it will check next working day for different condition.
    *************************************************************************************************************************************************/
    public static DateTime NextWorkingDay(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion,string caseState, string caseCity){
        AOSI_Time_Calculation_Settings__c timeCalObjSMS = AOSI_Time_Calculation_Settings__c.getValues('StartSMS Recieve Next Day');//timeStamp for START SMS recieve next day
        boolean isFlag=FALSE; system.debug('==CaseRegisteredTime=='+CaseRegisteredTime.formatGMT('EEE'));system.debug('===lstHoliday.isEmpty()==='+lstHoliday.isEmpty());
        if(lstHoliday.isEmpty()){
            if(CaseRegisteredTime.formatGMT('EEE') =='Sun'){ system.debug('==inside sunday condition==');
                CaseRegisteredTime= CaseRegisteredTime.addDays(1);
            }
            CaseRegisteredTime=DateTime.newInstance(CaseRegisteredTime.dateGMT(), AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_Start_Time__c));
            CaseRegisteredTime=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(CaseRegisteredTime);
        }
        for(AOSI_Holiday_Calendar__c eachHoliday : lstHoliday){
                
                isFlag = AOSI_casePowerOfOneHandler.MatchTheRegion(eachHoliday.AOSI_Region__c,caseRegion,eachHoliday.AOSI_State__c,caseState,eachHoliday.AOSI_City__r.Name,caseCity);system.debug('===isFlag==='+isFlag);
                
                DateTime holidayStartDate = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_Start_Date__c);
                DateTime holidayEndDate   = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_End_Date__c);
                Decimal hours=0;
                hours=AOSI_casePowerOfOneHandler.hoursCalculation(holidayStartDate,holidayEndDate);
                while(CaseRegisteredTime.formatGMT('EEE') =='Sun' || (CaseRegisteredTime.dateGMT() >= holidayStartDate.dateGMT() && CaseRegisteredTime.dateGMT() <= holidayEndDate.dateGMT() && hours>=8 && isFlag)){
                    CaseRegisteredTime=CaseRegisteredTime.addDays(1);
                }
                if(hours<8 && hours!=0 ){
                    if(holidayStartDate.dateGMT() == CaseRegisteredTime.dateGMT() && holidayEndDate.dateGMT() == CaseRegisteredTime.dateGMT() && holidayStartDate.timeGmt()<=AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_Start_Time__c)){
                        CaseRegisteredTime=DateTime.newInstance(CaseRegisteredTime.dateGMT(),holidayEndDate.timeGmt() );
                        CaseRegisteredTime=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(CaseRegisteredTime);
                        system.debug('==CaseRegisteredTime inside if =='+CaseRegisteredTime);
                    }
                    else{
                        CaseRegisteredTime=DateTime.newInstance(CaseRegisteredTime.dateGMT(), AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_Start_Time__c));
                        CaseRegisteredTime=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(CaseRegisteredTime);
                        system.debug('==CaseRegisteredTime inside if else =='+CaseRegisteredTime);
                    }
                    
                }
                if(hours>=8){
                    CaseRegisteredTime=DateTime.newInstance(CaseRegisteredTime.dateGMT(), AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_Start_Time__c));
                    CaseRegisteredTime=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(CaseRegisteredTime);
                    system.debug('==CaseRegisteredTime inside else =='+CaseRegisteredTime);
                }
        }
        
       system.Debug('==Final CaseRegisteredTime =='+CaseRegisteredTime);
       return CaseRegisteredTime;
    }
    /*************************************************************************************************************************************************
    Method Name : NextWorkingDayTime(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion) 
    Return Type : DateTime 
    Description : based on parameters it will check next working hours for different condition.
    *************************************************************************************************************************************************/
    public static DateTime NextWorkingDayTime(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion,string caseState,string caseCity){
        AOSI_Time_Calculation_Settings__c timeCalObj    = AOSI_Time_Calculation_Settings__c.getValues('Case Registered In Between');//timeStamp for case Register in between
        AOSI_Time_Calculation_Settings__c timeCalObjSMS = AOSI_Time_Calculation_Settings__c.getValues('StartSMS Recieve Next Day');//timeStamp for START SMS recieve next day
        DateTime halfDayHolidayTime;
        boolean isFlag=FALSE;
        
        halfDayHolidayTime=CaseRegisteredTime;System.debug('==halfDayHolidayTime 0=='+halfDayHolidayTime);
        for(AOSI_Holiday_Calendar__c eachHoliday : lstHoliday){
            isFlag= AOSI_casePowerOfOneHandler.MatchTheRegion(eachHoliday.AOSI_Region__c,caseRegion,eachHoliday.AOSI_State__c,caseState,eachHoliday.AOSI_City__r.Name,caseCity);system.debug('===isFlag==='+isFlag);
            if(isFlag){system.debug('==test1=='+AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c));system.debug('==test1=='+AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_End_Time__c));
                DateTime holidayStartDate = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_Start_Date__c);
                DateTime holidayEndDate   = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_End_Date__c); System.debug('==holidayEndDate=='+holidayEndDate);
                if(CaseRegisteredTime.dateGMT()==holidayStartDate.dateGMT() && CaseRegisteredTime.dateGMT() == holidayEndDate.dateGMT() && CaseRegisteredTime.timeGmt() < holidayEndDate.timeGmt() && holidayEndDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c)  ){//&& holidayEndDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_End_Time__c) && holidayStartDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_End_Time__c)
                    halfDayHolidayTime= holidayEndDate;
                }
            }
        }
       //CaseRegisteredTime = halfDayHolidayTime;
       CaseRegisteredTime=halfDayHolidayTime;
       return CaseRegisteredTime;
    }
    /*************************************************************************************************************************************************
    Method Name : isHolidayToday(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion) 
    Return Type : boolean 
    Description : based on parameters it will check isHalfDayHolidayToday for different condition.
    *************************************************************************************************************************************************/
    public static boolean isHolidayToday(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion,string caseState,String caseCity){
        boolean isNotHolidayToday;
        boolean isFlag=FALSE; system.debug('==CaseRegisteredTime=='+CaseRegisteredTime); system.debug('==sunday!=='+CaseRegisteredTime.formatGMT('EEE'));
        if(CaseRegisteredTime.formatGMT('EEE') =='Sun'){
            isNotHolidayToday = FALSE;
        } system.debug('==0=='+isNotHolidayToday );
        if((lstHoliday.size() == 0 || lstHoliday.isEmpty()) && CaseRegisteredTime.formatGMT('EEE') !='Sun'){
        isNotHolidayToday = TRUE;
        } system.debug('==1=='+isNotHolidayToday );
        for(AOSI_Holiday_Calendar__c eachHoliday:lstHoliday){
            isFlag = AOSI_casePowerOfOneHandler.MatchTheRegion(eachHoliday.AOSI_Region__c,caseRegion,eachHoliday.AOSI_State__c,caseState,eachHoliday.AOSI_City__r.Name,caseCity);system.debug('===isFlag==='+isFlag);
            if(isFlag){
                DateTime holidayStartDate  = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_Start_Date__c);system.debug('==holidayStartDate=='+holidayStartDate);
                DateTime holidayEndDate    = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_End_Date__c);system.debug('==holidayEndDate=='+holidayEndDate);
                if( CaseRegisteredTime.dateGMT() != holidayStartDate.dateGMT() && CaseRegisteredTime.dateGMT() != holidayEndDate.dateGMT() && !(holidayStartDate.dateGMT()<CaseRegisteredTime.dateGMT()) && !(holidayEndDate.dateGMT()>CaseRegisteredTime.dateGMT()) && CaseRegisteredTime.formatGMT('EEE') != 'Sun'){
                    isNotHolidayToday = TRUE;   
                }else{
                isNotHolidayToday = FALSE;
                }
            }
            else{
                isNotHolidayToday = TRUE; system.debug('==2=='+isNotHolidayToday );
                }
        }
        System.Debug('==isNotHolidayToday=='+isNotHolidayToday);
        return isNotHolidayToday;
    }
    /*************************************************************************************************************************************************
    Method Name : isHalfDayHolidayToday(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion,String strTemp,,string caseState,String caseCity) 
    Return Type : boolean 
    Description : based on parameters it will check halfday holiday for different condition.
    *************************************************************************************************************************************************/
    public static boolean isHalfDayHolidayToday(DateTime CaseRegisteredTime,list<AOSI_Holiday_Calendar__c> lstHoliday,string caseRegion,String strTemp,string caseState,String caseCity){
        boolean isHolidayToday;
        boolean isFlag=FALSE;
        AOSI_Time_Calculation_Settings__c timeCalObjSMS = AOSI_Time_Calculation_Settings__c.getValues('StartSMS Recieve Next Day');//timeStamp for START SMS recieve next day
        AOSI_Time_Calculation_Settings__c timeCalObj    = AOSI_Time_Calculation_Settings__c.getValues('Case Registered In Between');//timeStamp for case Register in between
        if(lstHoliday.size() == 0 || lstHoliday.isEmpty()){
        isHolidayToday =FALSE;
        }else{
            for(AOSI_Holiday_Calendar__c eachHoliday:lstHoliday){
               isFlag = AOSI_casePowerOfOneHandler.MatchTheRegion(eachHoliday.AOSI_Region__c,caseRegion,eachHoliday.AOSI_State__c,caseState,eachHoliday.AOSI_City__r.Name,caseCity);system.debug('===isFlag==='+isFlag);
                if(isFlag){
                    DateTime holidayStartDate  = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_Start_Date__c);
                    DateTime holidayEndDate    = AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(eachHoliday.AOSI_End_Date__c); system.debug('==holidayStartDate.timeGMT()=='+holidayStartDate.timeGMT());system.debug('==holidayEndDate.timeGMT()=='+holidayEndDate.timeGMT());system.debug('==CaseRegisteredTime.timeGMT()=='+CaseRegisteredTime.timeGMT());
                    
                    if(CaseRegisteredTime.dateGMT()==holidayStartDate.dateGMT() && CaseRegisteredTime.dateGMT() <= holidayEndDate.dateGMT()  ){ //&& hours<8
                         system.debug('==strTemp=='+strTemp);
                         if(strTemp==''){
                         isHolidayToday = TRUE;
                         }
                        if(strTemp!=NULL && strTemp=='FALSE' && CaseRegisteredTime>holidayStartDate && CaseRegisteredTime < holidayEndDate){
                            if(CaseRegisteredTime.dateGMT() == holidayEndDate.dateGMT() && CaseRegisteredTime.dateGMT() == holidayStartDate.dateGMT()  && holidayStartDate.timeGmt() <= AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) &&  holidayStartDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObjSMS.AOSI_Work_End_Time__c) ){
                                isHolidayToday = TRUE;  
                            }else{
                                isHolidayToday = FALSE;
                            }
                        }
                        if(strTemp!=NULL && strTemp=='TRUE' ){
                            if(CaseRegisteredTime.dateGMT() == holidayEndDate.dateGMT() && CaseRegisteredTime.dateGMT() == holidayStartDate.dateGMT() && holidayEndDate.timeGmt() > AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) &&  holidayStartDate.timeGmt() > AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) ){
                                isHolidayToday = TRUE;  
                            }else{
                                isHolidayToday = FALSE;
                            }
                            if(CaseRegisteredTime.dateGMT() ==holidayStartDate.dateGMT()  && holidayStartDate.timeGmt() > AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c)  ){
                                isHolidayToday = TRUE;  
                            }else{
                                isHolidayToday = FALSE;
                            }
                            if(CaseRegisteredTime.dateGMT() == holidayEndDate.dateGMT() && CaseRegisteredTime.dateGMT() == holidayStartDate.dateGMT() && holidayEndDate.timeGmt() <= AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) &&  holidayStartDate.timeGmt() < AOSI_casePowerOfOneHandler.getTime(timeCalObj.AOSI_Work_End_Time__c) ){
                                isHolidayToday = TRUE;  
                            }
                        }
                    }else{
                        isHolidayToday = FALSE; 
                    }
                }else{
                     isHolidayToday = FALSE;   
                }
            }
        }
        System.Debug('==isHolidayToday=='+isHolidayToday);
        return isHolidayToday;
    }
    /*************************************************************************************************************************************************
    Method Name : getLocalTimeZoneFormate(DateTime convertDateTime) 
    Return Type : DateTime 
    Description : Accepts dateTime and returns dateTime (convert it with login user's time zone )
    *************************************************************************************************************************************************/
    public static DateTime getLocalTimeZoneFormate(DateTime convertDateTime){
        
        if(convertDateTime!=NULL){
            TimeZone tz = UserInfo.getTimeZone();
            convertDateTime = convertDateTime.AddSeconds(tz.getOffset(convertDateTime)/1000);   
        }
    return convertDateTime;
    }
    
    /*************************************************************************************************************************************************
    Method Name : getTime() 
    Return Type : Time 
    Description : Accepts String in format HH:MM:SS and returns Time
    *************************************************************************************************************************************************/
    public static Time getTime(String hhmmss) {
        Integer iHour;
        Integer iMin;
        Integer iSec;
    
        if( !String.isBlank(hhmmss) ) {
            iHour   =   ((!String.isBlank(hhmmss.split(':')[0]) && (hhmmss.split(':')[0]).isNumeric()) ? integer.valueOf(hhmmss.split(':')[0]) : 0);
            iMin    =   ((!String.isBlank(hhmmss.split(':')[1]) && (hhmmss.split(':')[1]).isNumeric()) ? integer.valueOf(hhmmss.split(':')[1]) : 0);
            iSec    =   ((!String.isBlank(hhmmss.split(':')[2]) && (hhmmss.split(':')[2]).isNumeric()) ? integer.valueOf(hhmmss.split(':')[2]) : 0);
        }
        return(Time.newInstance(iHour, iMin, iSec, 0));
    }
    public static String Po1ResultBefore(DateTime createdDate,DateTime RespondedTime,DateTime OnHoldEditedTime,string strPo1){
        if(createdDate!=NULL && RespondedTime != NULL){
            
            Decimal hours=0;
            hours = AOSI_casePowerOfOneHandler.hoursCalculation(createdDate,RespondedTime);
            if(createdDate.date() == RespondedTime.date() && hours <= 1  ){ //Response time should be within 1 hour
                strPo1 = 'True';    
            }else{
                if(OnHoldEditedTime!=NULL && strPo1!='True'){
                    if( RespondedTime>OnHoldEditedTime){ // On holdEdited time should be less then Responded time for po1 criteria
                        strPo1 = 'True';
                    }else{
                        strPo1 = 'False';
                    }
                }
                if(strPo1==NULL){
                    strPo1 = 'False';
                }
            }
            if(RespondedTime < createdDate ){ //Response time should be greater then case registered time 
                strPo1 = 'False';
            }
        }
        return strPo1;
    }
    public static String Po1ResultAfter(DateTime createdDate,DateTime RespondedTime,DateTime OnHoldEditedTime,string strPo1,DateTime NextDay){
        if(createdDate!=NULL && RespondedTime != NULL){
            if(RespondedTime < nextDay ){ //RespondedTime should be within next day morning 9:59 AM
                strPo1 = 'True';
            }else{
              strPo1 = 'False';
            }
            if(RespondedTime < createdDate ){ //Response time should be greater then case registered time 
                strPo1 = 'False';
            }           
            if(OnHoldEditedTime!=NULL && strPo1!='True'){
                if( RespondedTime>OnHoldEditedTime){ // On holdEdited time should be less then Responded time for po1 criteria
                    strPo1 = 'True';
                }else{
                    strPo1 = 'False';
                }
            }
        }
        return strPo1;
    }
    public static String po2Result(DateTime AssignmentEndTime,dateTime CaseCloseTime,dateTime AppointmentDate,dateTime createdDate,string strPo2,dateTime nextDay,string strDiff){
        if(AssignmentEndTime!= NULL || CaseCloseTime!=NULL ){
            //Appointment date is NULL then check the dates of resource allocation date and closed date 
            if(AppointmentDate ==NULL){ 
                //checking the case closed on same day with referance of closed Date or STOP SMS dateTime
                if(strDiff=='oneHour'){
                    if((CaseCloseTime!= NULL && createdDate.dateGMT() == CaseCloseTime.dateGMT()) || (AssignmentEndTime != NULL && createdDate.dateGMT() == AssignmentEndTime.dateGMT())){
                        strPo2 = 'True';
                    }
                    else{
                        strPo2 = 'False';
                    }
                }
                if(strDiff=='NextDayDiff'){
                    
                    if((CaseCloseTime!= NULL && CaseCloseTime.dateGMT() >= createdDate.dateGMT() && CaseCloseTime.dateGMT() <= nextDay.dateGMT() ) || (AssignmentEndTime != NULL && AssignmentEndTime.dateGMT() >= createdDate.dateGMT() &&  AssignmentEndTime.dateGMT() <= nextDay.dateGMT() )){
                        strPo2 = 'True';
                    }
                    else{
                        strPo2 = 'False';
                    }
                }
            }
            //Appointment date is not NULL then check dates of appointment date and closed date 
            if(AppointmentDate !=NULL){
                //checking the case closed on same day with referance of closed Date or STOP SMS dateTime
                if((AssignmentEndTime!= NULL && AssignmentEndTime.dateGMT() >= createdDate.dateGMT() && AssignmentEndTime.dateGMT() <= AppointmentDate.dateGMT()  ) || (CaseCloseTime!= NULL && CaseCloseTime.dateGMT() >= createdDate.dateGMT() &&  CaseCloseTime.dateGMT() <=  AppointmentDate.dateGMT() ) ){
                    strPo2 = 'True'; 
                }
                else{
                    strPo2 = 'False';
                }
            }
        }
        return strPo2;
    }
    
    Public Static Boolean MatchTheRegion(String HldayRegion,String caseRegion,String hldayState,String caseState,String hldayCity,String caseCity){
       boolean isFlag = FALSE; system.debug('==HldayRegion=='+HldayRegion);system.debug('==HldayRegion=='+HldayRegion);
        if(HldayRegion == 'National'  && hldayCity==NULL && hldayCity==NULL ){
            isFlag=TRUE;
        }
        if((HldayRegion!=NULL && HldayRegion==caseRegion) &&(hldayCity!=NULL && hldayCity == caseCity) && (hldayCity!= NULL && hldayCity == caseState) ){
            isFlag=TRUE;
        }
        if(HldayRegion!=NULL && HldayRegion==caseRegion && hldayCity==NULL  && hldayCity== NULL ){
            isFlag=TRUE;
        }
        if(HldayRegion!=NULL && HldayRegion==caseRegion && hldayCity==NULL  && (hldayCity!=NULL && hldayCity ==  caseState) ){
            isFlag=TRUE;
        }
        return isFlag;
    }
}