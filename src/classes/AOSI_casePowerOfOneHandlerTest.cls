@isTest(SeeAllData=true)
private class AOSI_casePowerOfOneHandlerTest {

    static testMethod void myTest() {
       test.startTest();
       AOSI_Time_Calculation_Settings__c timeCalObj    = AOSI_Time_Calculation_Settings__c.getValues('Case Registered In Between');//timeStamp for case Register in between 
       DateTime mydate;
       //DateTime mydate1;
       string strRegion;
        list<Case> listCase                        =   new list<Case>();
        list<Case> lstCase                         =   new list<Case>();
        list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        listCase =[SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND (Reason='Service' OR Reason='Free Installation') LIMIT 10];
        system.debug('==listCase=='+listCase);
        for(case eachCase: listCase){
            OldMap.put(eachCase.id,eachCase);
        }
        lstCase=listCase.deepClone(True,True,True);
        system.debug('==lstCase=='+lstCase);
        
        for(case eachCase:lstCase){
            eachCase.Assignment_Start_Time__c = eachCase.createdDate.addHours(1);
            eachCase.Assignment_End_Time__c = eachCase.createdDate.addHours(3);
            eachCase.AOSI_Appointment_Date__c=null;
            eachCase.AOSI_PO_Criteria_3__c=null;
            eachCase.AOSI_OnHold_Edited_Time__c= eachCase.createdDate.addMinutes(30);
            mydate=eachCase.createdDate;
            strRegion=eachCase.AOSI_Region__c;
            
        }
        
        AOSI_Holiday_Calendar__c  eachHoliday    =   new AOSI_Holiday_Calendar__c();
        eachHoliday.AOSI_Start_Date__c = mydate.addHours(-4);
        eachHoliday.AOSI_End_Date__c   = mydate.addHours(-2);
        eachHoliday.AOSI_Region__c     = strRegion;
        lstHolidays.add(eachHoliday);
        
        AOSI_Holiday_Calendar__c  eachHoliday1    =   new AOSI_Holiday_Calendar__c();
        eachHoliday1.AOSI_Start_Date__c = mydate.addHours(+2);
        eachHoliday1.AOSI_End_Date__c   = mydate.addHours(+4);
        eachHoliday1.AOSI_Region__c     = strRegion;
        lstHolidays.add(eachHoliday1);
       
        
      
        if(lstHolidays.size()>0){
           insert lstHolidays;
        }
        date myCreatedDate = date.newInstance(2015, 11, 26);
        case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate<= 2015-11-26T10:10:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:myCreatedDate AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1];
        lstCase.add(oCase1);
        OldMap.put(oCase1.id,oCase1);
        AOSI_Holiday_Calendar__c  eachHoliday01    =   new AOSI_Holiday_Calendar__c();
        eachHoliday01.AOSI_Start_Date__c = oCase1.createdDate.addHours(+2);
        eachHoliday01.AOSI_End_Date__c   = oCase1.createdDate.addHours(+4);
        eachHoliday01.AOSI_Region__c     = oCase1.AOSI_Region__c;
        lstHolidays.add(eachHoliday01);
        insert  eachHoliday01;
        
        AOSI_Holiday_Calendar__c  eachHoliday02    =   new AOSI_Holiday_Calendar__c();
        eachHoliday02.AOSI_Start_Date__c = oCase1.createdDate.addHours(+5);
        eachHoliday02.AOSI_End_Date__c   = oCase1.createdDate.addHours(+7);
        eachHoliday02.AOSI_Region__c     = oCase1.AOSI_Region__c;
        lstHolidays.add(eachHoliday02);
        insert  eachHoliday02;
         
        AOSI_casePowerOfOneHandler powerof1 =new AOSI_casePowerOfOneHandler();
        AOSI_casePowerOfOneHandler.powerOfOne(lstCase,OldMap);
        AOSI_casePowerOfOneHandler.powerOfOne(listCase,OldMap);
        /*AOSI_casePowerOfOneHandler.NextWorkingDayTime(mydate,lstHolidays,strRegion);
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydate,lstHolidays,strRegion,'TRUE');
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydate,lstHolidays,strRegion,'FALSE'); */
        test.stopTest(); 
    } 

    static testMethod void Test() {
       test.startTest();
        
       
        list<Case> listCase                     =   new list<Case>();
        Map<id,Case>OldMap                      =   new Map<id,Case>();
        listCase =[SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND AOSI_OnHold_Edited_Time__c!=null AND Assignment_Start_Time__c!=null LIMIT 2];
        system.debug('==listCase=='+listCase);
        for(case eachCase: listCase){
            OldMap.put(eachCase.id,eachCase);
        }
        AOSI_casePowerOfOneHandler powerof1 =new AOSI_casePowerOfOneHandler();
        AOSI_casePowerOfOneHandler.powerOfOne(listCase,OldMap);
        test.stopTest(); 
    }
    

    static testMethod void Test1() {
       test.startTest();
        
        list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
        list<Case> listCase                        =   new list<Case>();
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        date mydate = date.newInstance(2015, 11, 26);
        case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate<= 2015-11-26T10:10:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1]; 
        case oCase2 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate> 2015-11-26T10:30:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')  LIMIT 1]; 
       
        listCase.add(oCase1);
        listCase.add(oCase2);
        system.debug('==listCase=='+listCase);
           OldMap.put(oCase1.id,oCase1);
           OldMap.put(oCase2.id,oCase2);
        AOSI_casePowerOfOneHandler powerof1 =new AOSI_casePowerOfOneHandler();
        AOSI_casePowerOfOneHandler.powerOfOne(listCase,OldMap);
        //AOSI_casePowerOfOneHandler.hoursCalculation(oCase1.Assignment_Start_Time__c,oCase1.AOSI_Case_Close_Time__c);
        AOSI_casePowerOfOneHandler.getTime('20:00:00');
        test.stopTest(); 
    }
    
  /*  static testMethod void Test2() {
       test.startTest();
        
        list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
        list<Case> listCase                        =   new list<Case>();
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        date mydate = date.newInstance(2015, 11, 26);
        dateTIme mydateTime = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('09:00:00'));
        case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate<= 2015-11-26T10:10:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1]; 
        case oCase2 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_State_Picklist__c,AOSI_City_Picklist__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate> 2015-11-26T10:30:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')  LIMIT 1]; 
        
        AOSI_Holiday_Calendar__c  eachHoliday    =   new AOSI_Holiday_Calendar__c();
        eachHoliday.AOSI_Start_Date__c = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('09:00:00'));
        eachHoliday.AOSI_End_Date__c   = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('11:00:00'));
        eachHoliday.AOSI_Region__c     = 'North';
        lstHolidays.add(eachHoliday);
        
        AOSI_Holiday_Calendar__c  eachHoliday1    =   new AOSI_Holiday_Calendar__c();
        eachHoliday1.AOSI_Start_Date__c = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('15:00:00'));
        eachHoliday1.AOSI_End_Date__c   = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
        eachHoliday1.AOSI_Region__c     = 'East';
        lstHolidays.add(eachHoliday1);
        
        AOSI_Holiday_Calendar__c  eachHoliday2    =   new AOSI_Holiday_Calendar__c();
        eachHoliday2.AOSI_Start_Date__c = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
        eachHoliday2.AOSI_End_Date__c   = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('19:00:00'));
        eachHoliday2.AOSI_Region__c     = 'South';
        lstHolidays.add(eachHoliday2);
        
      
        if(lstHolidays.size()>0){
           insert lstHolidays;
        }
        listCase.add(oCase1);
        listCase.add(oCase2);
        system.debug('==listCase=='+listCase);
           OldMap.put(oCase1.id,oCase1);
           OldMap.put(oCase2.id,oCase2);
        AOSI_casePowerOfOneHandler powerof1 =new AOSI_casePowerOfOneHandler();
        AOSI_casePowerOfOneHandler.powerOfOne(listCase,OldMap);
       /* AOSI_casePowerOfOneHandler.NextWorkingDayTime(mydateTime,lstHolidays,'South');
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydateTime,lstHolidays,'South','TRUE');
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydateTime,lstHolidays,'South','FALSE'); 
        //AOSI_casePowerOfOneHandler.hoursCalculation(oCase1.Assignment_Start_Time__c,oCase1.AOSI_Case_Close_Time__c);
        AOSI_casePowerOfOneHandler.getTime('20:00:00');
        test.stopTest(); 
    }
    static testMethod void test01(){
     Test.StartTest();
     
     list<Case> lstCs    = Test.loadData(Case.sObjectType,'testCases');
     list<Case> lstCase  = new List<Case>();
     map<id,case> OldMap = new map<id,case>(); 
     
     if(lstCs.size()>0){
     id serviceEngId = [SELECT id FROM Service_Engineer__c WHERE AOSI_Active__c=TRUE LIMIT 1].id;
     system.debug('==lstCs=='+lstCs);
     case cs = (case)lstCs[0];
     OldMap.put(cs.id,cs);
     cs.Service_Engineer__c=serviceEngId;
     //string strDateTime='2016-01-04T08:29:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
     DateTime testDate = DateTime.newInstance(2016,01,04,08,29,00);
     testDate=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(testDate);
     system.Debug('==testDate=='+testDate);
     cs.AOSI_Appointment_Date__c= testDate;
     //string strDateTime='2015-12-31T01:09:00.000Z';
     testDate = DateTime.newInstance(2015,12,31,01,09,00);
     cs.Assignment_Start_Time__c=testDate;
     cs.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,31,01,00,00);
     //string strDateTime='2016-01-04T07:09:00.000Z';
     testDate = DateTime.newInstance(2016,01,04,07,09,00);
     cs.Assignment_End_Time__c=testDate;
     update cs;
     
     case cs2 = (case)lstCs[2];
     OldMap.put(cs2.id,cs2);
     cs2.Service_Engineer__c=serviceEngId;
     //string strDateTime='2016-01-04T08:29:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
    
     //string strDateTime='2015-12-31T01:09:00.000Z';
     testDate = DateTime.newInstance(2015,12,31,01,09,00);
     cs2.Assignment_Start_Time__c=testDate;
     cs2.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,31,01,30,00);
     //string strDateTime='2016-01-04T07:09:00.000Z';
     testDate = DateTime.newInstance(2016,01,04,07,09,00);
     cs2.Assignment_End_Time__c=testDate;
     update cs2;
     
     case cs1 = (case)lstCs[1];
     OldMap.put(cs1.id,cs1);
     cs1.Service_Engineer__c=serviceEngId;
     
     //string strDateTime='  2015-12-26T10:19:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
     testDate = DateTime.newInstance(2015,12,26,10,19,00);
     system.debug('==testDate=='+testDate);
     cs1.AOSI_Appointment_Date__c= testDate;
      system.debug('==cs1.AOSI_Appointment_Date__c=='+cs1.AOSI_Appointment_Date__c); 
     //string strDateTime='2015-12-24T15:17:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,37,00);
     cs1.Assignment_Start_Time__c=testDate;
     system.debug('==cs1.createdDate=='+cs1.createdDate);
     system.Debug('==cs1.Assignment_Start_Time__c=='+cs1.Assignment_Start_Time__c);
     cs1.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,24,15,27,00);
     //string strDateTime='2015-12-24T10:22:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,45,00);
     cs1.Assignment_End_Time__c=testDate;
     system.Debug('==cs1.Assignment_End_Time__c=='+cs1.Assignment_End_Time__c);
     update cs1;
     
     case cs3 = (case)lstCs[3];
     OldMap.put(cs3.id,cs3);
     cs3.Service_Engineer__c=serviceEngId;
     
     //string strDateTime='  2015-12-26T10:19:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
  
     //string strDateTime='2015-12-24T15:17:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,37,00);
     cs3.Assignment_Start_Time__c=testDate;
     system.debug('==cs1.createdDate=='+cs3.createdDate);
     system.Debug('==cs1.Assignment_Start_Time__c=='+cs3.Assignment_Start_Time__c);
     cs3.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,24,15,47,00);
     //string strDateTime='2015-12-24T10:22:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,45,00);
     cs3.Assignment_End_Time__c=testDate;
     system.Debug('==cs1.Assignment_End_Time__c=='+cs3.Assignment_End_Time__c);
     update cs3;
     
     lstCase.add(cs1);
     lstCase.add(cs2);
     lstCase.add(cs3);
     lstCase.add(cs);
     
     }
         if(lstCase.size()>0){
             system.debug('==lstCase=='+lstCase);
             AOSI_casePowerOfOneHandler.powerOfOne(lstCase,OldMap);
         } 
     Test.StopTest();
    }
    
    static testMethod void test012(){
    Test.StartTest();
    list<Case> lstCs    = Test.loadData(Case.sObjectType,'testCases');
    list<Case> lstCase  = new List<Case>();
    list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
    map<id,case> OldMap = new map<id,case>(); 
    //2015-12-30T12:20:56.000Z
    date mydate = date.newInstance(2015, 12, 30);
     
    AOSI_Holiday_Calendar__c  eachHoliday    =   new AOSI_Holiday_Calendar__c();
   
    eachHoliday.AOSI_Start_Date__c = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('09:00:00'));
    eachHoliday.AOSI_End_Date__c   = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('11:00:00'));
    eachHoliday.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday);
    
    AOSI_Holiday_Calendar__c  eachHoliday1    =   new AOSI_Holiday_Calendar__c();
    eachHoliday1.AOSI_Start_Date__c = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('15:00:00'));
    eachHoliday1.AOSI_End_Date__c   = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
    eachHoliday1.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday1);
    
    AOSI_Holiday_Calendar__c  eachHoliday2    =   new AOSI_Holiday_Calendar__c();
    eachHoliday2.AOSI_Start_Date__c = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
    eachHoliday2.AOSI_End_Date__c   = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('19:00:00'));
    eachHoliday2.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday2);
    
    
    //2015-12-24T09:58:51.000Z
    date mydate1 = date.newInstance(2015, 12, 24);
     
    AOSI_Holiday_Calendar__c  eachHoliday3    =   new AOSI_Holiday_Calendar__c();
    eachHoliday3.AOSI_Start_Date__c = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('09:00:00'));
    eachHoliday3.AOSI_End_Date__c   = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('11:00:00'));
    eachHoliday3.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday3);
    
    AOSI_Holiday_Calendar__c  eachHoliday4    =   new AOSI_Holiday_Calendar__c();
    eachHoliday4.AOSI_Start_Date__c = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('15:00:00'));
    eachHoliday4.AOSI_End_Date__c   = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
    eachHoliday4.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday4);
    
    AOSI_Holiday_Calendar__c  eachHoliday5    =   new AOSI_Holiday_Calendar__c();
    eachHoliday5.AOSI_Start_Date__c = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
    eachHoliday5.AOSI_End_Date__c   = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('19:00:00'));
    eachHoliday5.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday5);
    
  
    if(lstHolidays.size()>0){
       insert lstHolidays;
    }
     
     
     if(lstCs.size()>0){
     id serviceEngId = [SELECT id FROM Service_Engineer__c WHERE AOSI_Active__c=TRUE LIMIT 1].id;
     system.debug('==lstCs=='+lstCs);
     case cs = (case)lstCs[0];
     OldMap.put(cs.id,cs);
     cs.Service_Engineer__c=serviceEngId;
     //string strDateTime='2016-01-04T08:29:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
     DateTime testDate = DateTime.newInstance(2016,01,04,08,29,00);
     testDate=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(testDate);
     system.Debug('==testDate=='+testDate);
     cs.AOSI_Appointment_Date__c= testDate;
     //string strDateTime='2015-12-31T01:09:00.000Z';
     testDate = DateTime.newInstance(2015,12,31,01,09,00);
     cs.Assignment_Start_Time__c=testDate;
     cs.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,31,01,00,00);
     //string strDateTime='2016-01-04T07:09:00.000Z';
     testDate = DateTime.newInstance(2016,01,04,07,09,00);
     cs.Assignment_End_Time__c=testDate;
     update cs;
     
     case cs2 = (case)lstCs[2];
     OldMap.put(cs2.id,cs2);
     cs2.Service_Engineer__c=serviceEngId;
     //string strDateTime='2016-01-04T08:29:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
    
     //string strDateTime='2015-12-31T01:09:00.000Z';
     testDate = DateTime.newInstance(2015,12,31,01,09,00);
     cs2.Assignment_Start_Time__c=testDate;
     cs2.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,31,01,30,00);
     //string strDateTime='2016-01-04T07:09:00.000Z';
     testDate = DateTime.newInstance(2016,01,04,07,09,00);
     cs2.Assignment_End_Time__c=testDate;
     update cs2;
     
     case cs1 = (case)lstCs[1];
     OldMap.put(cs1.id,cs1);
     cs1.Service_Engineer__c=serviceEngId;
     
     //string strDateTime='  2015-12-26T10:19:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
     testDate = DateTime.newInstance(2015,12,26,10,19,00);
     system.debug('==testDate=='+testDate);
     cs1.AOSI_Appointment_Date__c= testDate;
      system.debug('==cs1.AOSI_Appointment_Date__c=='+cs1.AOSI_Appointment_Date__c); 
     //string strDateTime='2015-12-24T15:17:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,37,00);
     cs1.Assignment_Start_Time__c=testDate;
     system.debug('==cs1.createdDate=='+cs1.createdDate);
     system.Debug('==cs1.Assignment_Start_Time__c=='+cs1.Assignment_Start_Time__c);
     cs1.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,24,15,27,00);
     //string strDateTime='2015-12-24T10:22:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,45,00);
     cs1.Assignment_End_Time__c=testDate;
     system.Debug('==cs1.Assignment_End_Time__c=='+cs1.Assignment_End_Time__c);
     update cs1;
     
     case cs3 = (case)lstCs[3];
     OldMap.put(cs3.id,cs3);
     cs3.Service_Engineer__c=serviceEngId;
     
     //string strDateTime='  2015-12-26T10:19:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
  
     //string strDateTime='2015-12-24T15:17:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,37,00);
     cs3.Assignment_Start_Time__c=testDate;
     system.debug('==cs1.createdDate=='+cs3.createdDate);
     system.Debug('==cs1.Assignment_Start_Time__c=='+cs3.Assignment_Start_Time__c);
     cs3.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,24,15,47,00);
     //string strDateTime='2015-12-24T10:22:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,45,00);
     cs3.Assignment_End_Time__c=testDate;
     system.Debug('==cs1.Assignment_End_Time__c=='+cs3.Assignment_End_Time__c);
     update cs3;
     
     lstCase.add(cs1);
     lstCase.add(cs2);
     lstCase.add(cs3);
     lstCase.add(cs);
     
     }
         if(lstCase.size()>0){
             system.debug('==lstCase=='+lstCase);
             AOSI_casePowerOfOneHandler.powerOfOne(lstCase,OldMap);
         }
     Test.StopTest(); 
    }
    
     static testMethod void test3(){
    Test.StartTest();
    list<Case> lstCs    = Test.loadData(Case.sObjectType,'testCases');
    list<Case> lstCase  = new List<Case>();
    list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
    map<id,case> OldMap = new map<id,case>(); 
    //2015-12-30T12:20:56.000Z
    
    //2015-12-24T09:58:51.000Z
    date mydate1 = date.newInstance(2015, 12, 24);
     
    AOSI_Holiday_Calendar__c  eachHoliday3    =   new AOSI_Holiday_Calendar__c();
    eachHoliday3.AOSI_Start_Date__c = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('09:00:00'));
    eachHoliday3.AOSI_End_Date__c   = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('11:00:00'));
    eachHoliday3.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday3);
    
    AOSI_Holiday_Calendar__c  eachHoliday4    =   new AOSI_Holiday_Calendar__c();
    eachHoliday4.AOSI_Start_Date__c = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('15:00:00'));
    eachHoliday4.AOSI_End_Date__c   = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
    eachHoliday4.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday4);
    
    AOSI_Holiday_Calendar__c  eachHoliday5    =   new AOSI_Holiday_Calendar__c();
    eachHoliday5.AOSI_Start_Date__c = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('17:00:00'));
    eachHoliday5.AOSI_End_Date__c   = DateTime.newInstance(mydate1, AOSI_casePowerOfOneHandler.getTime('19:00:00'));
    eachHoliday5.AOSI_Region__c     = 'South';
    lstHolidays.add(eachHoliday5);
    
  
    if(lstHolidays.size()>0){
       insert lstHolidays;
    }
     
     
     if(lstCs.size()>0){
     id serviceEngId = [SELECT id FROM Service_Engineer__c WHERE AOSI_Active__c=TRUE LIMIT 1].id;
     system.debug('==lstCs=='+lstCs);
     case cs = (case)lstCs[0];
     OldMap.put(cs.id,cs);
     cs.Service_Engineer__c=serviceEngId; //'a0ee0000003xc0hAAA'
     //string strDateTime='2016-01-04T08:29:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
     DateTime testDate = DateTime.newInstance(2016,01,04,08,29,00);
     testDate=AOSI_casePowerOfOneHandler.getLocalTimeZoneFormate(testDate);
     system.Debug('==testDate=='+testDate);
     cs.AOSI_Appointment_Date__c= testDate;
     //string strDateTime='2015-12-31T01:09:00.000Z';
     testDate = DateTime.newInstance(2015,12,31,01,09,00);
     cs.Assignment_Start_Time__c=testDate;
     cs.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,31,01,00,00);
     //string strDateTime='2016-01-04T07:09:00.000Z';
     testDate = DateTime.newInstance(2016,01,04,07,09,00);
     cs.Assignment_End_Time__c=testDate;
     update cs;
     
     case cs2 = (case)lstCs[2];
     OldMap.put(cs2.id,cs2);
     cs2.Service_Engineer__c=serviceEngId;
     //string strDateTime='2016-01-04T08:29:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
    
     //string strDateTime='2015-12-31T01:09:00.000Z';
     testDate = DateTime.newInstance(2015,12,31,01,09,00);
     cs2.Assignment_Start_Time__c=testDate;
     cs2.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,31,01,30,00);
     //string strDateTime='2016-01-04T07:09:00.000Z';
     testDate = DateTime.newInstance(2016,01,04,07,09,00);
     cs2.Assignment_End_Time__c=testDate;
     update cs2;
     
     case cs1 = (case)lstCs[1];
     OldMap.put(cs1.id,cs1);
     cs1.Service_Engineer__c=serviceEngId;
     
     //string strDateTime='  2015-12-26T10:19:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
     testDate = DateTime.newInstance(2015,12,26,10,19,00);
     system.debug('==testDate=='+testDate);
     cs1.AOSI_Appointment_Date__c= testDate;
      system.debug('==cs1.AOSI_Appointment_Date__c=='+cs1.AOSI_Appointment_Date__c); 
     //string strDateTime='2015-12-24T15:17:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,37,00);
     cs1.Assignment_Start_Time__c=testDate;
     system.debug('==cs1.createdDate=='+cs1.createdDate);
     system.Debug('==cs1.Assignment_Start_Time__c=='+cs1.Assignment_Start_Time__c);
     cs1.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,24,15,27,00);
     //string strDateTime='2015-12-24T10:22:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,45,00);
     cs1.Assignment_End_Time__c=testDate;
     system.Debug('==cs1.Assignment_End_Time__c=='+cs1.Assignment_End_Time__c);
     update cs1;
     
     case cs3 = (case)lstCs[3];
     OldMap.put(cs3.id,cs3);
     cs3.Service_Engineer__c=serviceEngId;
     
     //string strDateTime='  2015-12-26T10:19:00.000Z';
     //newInstance(year, month, day, hour, minute, second)
  
     //string strDateTime='2015-12-24T15:17:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,37,00);
     cs3.Assignment_Start_Time__c=testDate;
     system.debug('==cs1.createdDate=='+cs3.createdDate);
     system.Debug('==cs1.Assignment_Start_Time__c=='+cs3.Assignment_Start_Time__c);
     cs3.AOSI_OnHold_Edited_Time__c= DateTime.newInstance(2015,12,24,15,47,00);
     //string strDateTime='2015-12-24T10:22:00.000Z';
     testDate = DateTime.newInstance(2015,12,24,15,45,00);
     cs3.Assignment_End_Time__c=testDate;
     system.Debug('==cs1.Assignment_End_Time__c=='+cs3.Assignment_End_Time__c);
     update cs3;
     
     lstCase.add(cs1);
     lstCase.add(cs2);
     lstCase.add(cs3);
     lstCase.add(cs);
     
     }
         if(lstCase.size()>0){
             system.debug('==lstCase=='+lstCase);
             AOSI_casePowerOfOneHandler.powerOfOne(lstCase,OldMap);
         }
     Test.StopTest(); 
    }  */
  
}