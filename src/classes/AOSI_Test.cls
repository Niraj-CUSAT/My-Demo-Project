@isTest(SeeAllData=true)
private class AOSI_Test {

    static testMethod void myTest() {
       test.startTest();
      /* AOSI_Time_Calculation_Settings__c timeCalObj    = AOSI_Time_Calculation_Settings__c.getValues('Case Registered In Between');//timeStamp for case Register in between 
       DateTime mydate;
       //DateTime mydate1;
       string strRegion;
        list<Case> listCase                        =   new list<Case>();
        list<Case> lstCase                         =   new list<Case>();
        list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        listCase =[SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND (Reason='Service' OR Reason='Free Installation') LIMIT 10];
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
        } */
        date myCreatedDate = date.newInstance(2015, 11, 26);
        date myCreatedDate1 = date.newInstance(2015, 11,18);

        case oCase2 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate<= 2015-11-26T10:30:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:myCreatedDate AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1];
        case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate> 2015-11-18T10:30:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:myCreatedDate1 AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1];
        list<Case> listCase                        =   new list<Case>();
        listCase.add(oCase1);
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        OldMap.put(oCase1.id,oCase1);
       /* AOSI_Holiday_Calendar__c  eachHoliday01    =   new AOSI_Holiday_Calendar__c();
        eachHoliday01.AOSI_Start_Date__c = oCase1.createdDate.addHours(-4);
        eachHoliday01.AOSI_End_Date__c   = oCase1.createdDate.addHours(-2);
        eachHoliday01.AOSI_Region__c     = oCase1.AOSI_Region__c;
        
        insert  eachHoliday01; */
        
         AOSI_Holiday_Calendar__c  eachHoliday02    =   new AOSI_Holiday_Calendar__c();
        eachHoliday02.AOSI_Start_Date__c = oCase1.createdDate.addHours(-5);
        eachHoliday02.AOSI_End_Date__c   = oCase1.createdDate.addHours(+5);
        eachHoliday02.AOSI_Region__c     = oCase1.AOSI_Region__c;
        
        insert  eachHoliday02;
         
        AOSI_casePowerOfOneHandler powerof1 =new AOSI_casePowerOfOneHandler();
        //AOSI_casePowerOfOneHandler.powerOfOne(lstCase,OldMap);
        AOSI_casePowerOfOneHandler.powerOfOne(listCase,OldMap);
       /* AOSI_casePowerOfOneHandler.NextWorkingDayTime(mydate,lstHolidays,strRegion);
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydate,lstHolidays,strRegion,'TRUE');
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydate,lstHolidays,strRegion,'FALSE'); */
        test.stopTest(); 
    }
    

   /* static testMethod void Test1() {
       test.startTest();
        
        list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
        list<Case> listCase                        =   new list<Case>();
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        date mydate = date.newInstance(2015, 11, 26);
        case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate<= 2015-11-26T10:10:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1]; 
        case oCase2 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate> 2015-11-26T10:30:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')  LIMIT 1]; 
       
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
    
    static testMethod void Test2() {
       test.startTest();
        
        list<AOSI_Holiday_Calendar__c> lstHolidays =   new List<AOSI_Holiday_Calendar__c>();
        list<Case> listCase                        =   new list<Case>();
        Map<id,Case>OldMap                         =   new Map<id,Case>();
        date mydate = date.newInstance(2015, 11, 26);
        dateTIme mydateTime = DateTime.newInstance(mydate, AOSI_casePowerOfOneHandler.getTime('09:00:00'));
        case oCase1 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate<= 2015-11-26T10:10:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')   LIMIT 1]; 
        case oCase2 = [SELECT id,AOSI_Onhold_Reason__c,AOSI_OnHold_Edited_Time__c,AOSI_Appointment_Date__c,RecordTypeId,Reason,createdDate,Status,AOSI_Cancelled_On_HOLD_Reason__c,CC_SSV__c,AOSI_Region__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_Case_Close_Time__c,Service_Engineer__c,AOSI_PO_Criteria_1__c,AOSI_PO_Criteria_2__c,AOSI_PO_Criteria_3__c FROM case WHERE Service_Engineer__c!=null AND RecordType.Name='AOS India' AND Assignment_Start_Time__c!=null AND (Assignment_End_Time__c!=null OR AOSI_Case_Close_Time__c!=null) AND Status!='On Hold' AND createdDate> 2015-11-26T10:30:32Z AND DAY_ONLY(convertTimezone(CreatedDate)) =:mydate AND (Reason='Service' OR Reason='Free Installation')  LIMIT 1]; 
        
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
        AOSI_casePowerOfOneHandler.NextWorkingDayTime(mydateTime,lstHolidays,'South');
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydateTime,lstHolidays,'South','TRUE');
        AOSI_casePowerOfOneHandler.isHalfDayHolidayToday(mydateTime,lstHolidays,'South','FALSE');
        //AOSI_casePowerOfOneHandler.hoursCalculation(oCase1.Assignment_Start_Time__c,oCase1.AOSI_Case_Close_Time__c);
        AOSI_casePowerOfOneHandler.getTime('20:00:00');
        test.stopTest(); 
    }*/
 }