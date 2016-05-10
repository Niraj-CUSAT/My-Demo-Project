/********************************************************************************
Created by    :    Shweta Kumari, KVP Business Solutions
Created On    :    7th Jan 2014
description   :    Code to calculate Response Time,resolution Time and Job Time
*********************************************************************************/
trigger CaseupdateTimebeforeUpdate on Case (before Update) {      
    Recordtype rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1]; //recordtype AOS India for validating case recordtype         
    decimal lsatDayResolutionTime=0;
    decimal firstDayResolutionTime=0;
    decimal lsatDayResolutionTimeClock=0;
    decimal firstDayResolutionTimeClock=0;
    decimal lsatDayResponseTime=0;
    decimal firstDayResponseTime=0;
    decimal lsatDayResponseTimeClock=0;
    decimal firstDayResponseTimeClock=0;
    decimal lsatDayJobTime=0;
    decimal firstDayJobTime=0;
    decimal lsatDayJobTimeClock=0;
    decimal firstDayJobTimeClock=0;
    decimal ResolutiondaysNo=0;
    decimal Resolutionsunday=0;
    decimal ResolutionNoHolidays=0;
    decimal ResolutiontotalDays=0;
    decimal ResponsedaysNo=0;
    decimal Responsesunday=0;
    decimal ResponseNoHolidays=0;
    decimal ResponsetotalDays=0;
    decimal JobdaysNo=0;
    decimal Jobsunday=0;
    decimal JobNoHolidays=0;
    decimal JobtotalDays=0;
    decimal totalResolutionhours=0;
    decimal totalResolutionhoursClock=0; 
    decimal totalResponsehours=0;
    decimal resondedtime=0;
    decimal totalResponsehoursClock=0; 
    decimal totalJobhours=0;
    decimal totalJobhoursClock=0; 
    String str; 
    decimal tempval=0;
    for(Case cs : Trigger.new){
        if(cs.RecordTypeId == rt.id){            
            //code to calculate Resolution time
            if(cs.Assignment_End_Time__c == null && cs.AOSI_Appointment_Date__c == null && cs.Assignment_Start_Time__c == Null && cs.AOSI_Case_Close_Time__c == Null){
                        cs.AOSI_Response_Clock_Time__c = null;
                        cs.AOSI_Resolution_Clock_Time__c = null;
                        cs.AOSI_Job_Clock_Time__c = null;
                        cs.AOSI_Response_Time_New__c = null;
                        cs.AOSI_Resolution_Time_New__c  = null;
                        cs.AOSI_Job_Time_New__c = null;
                    }
            if(cs.Assignment_End_Time__c != null && cs.AOSI_Appointment_Date__c != null){
                if(cs.AOSI_Appointment_Date__c < cs.Assignment_End_Time__c){
                    //metohod call to count no of days between two dates excluding sundays 
                    ResolutiondaysNo = findNoOfDays(cs.AOSI_Appointment_Date__c.date(),cs.Assignment_End_Time__c.date()); 
                    // code to find total no of days between two dates including sundays               
                    ResolutiontotalDays = cs.AOSI_Appointment_Date__c.date().daysBetween(cs.Assignment_End_Time__c.date());
                    //count total no of sundays
                    Resolutionsunday = ResolutiontotalDays-ResolutiondaysNo; 
                    //metohod call to count no of holidays between two dates
                    ResolutionNoHolidays = findNoOfHolidays( cs.AOSI_Appointment_Date__c.date() , cs.Assignment_End_Time__c.date()); 
                    //metohod call to calculate time diffrence between start time and 8pm              
                    firstDayResolutionTime = FindfirstDaysHour(cs.AOSI_Appointment_Date__c);
                    //metohod call to calculate time diffrence between 8AM and End Time
                    lsatDayResolutionTime = FindLasttDaysHour(cs.Assignment_End_Time__c);               
                    totalResolutionhours = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2); 
                    //metohod call to calculate time diffrence between start time and 12pm              
                    firstDayResolutionTimeClock = FindfirstDaysHourTimeClock(cs.AOSI_Appointment_Date__c);
                    //metohod call to calculate time diffrence between 12AM and End Time
                    lsatDayResolutionTimeClock = FindLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                    totalResolutionhoursClock = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2);  
                }
                else{
                    totalResolutionhours = 2;
                    totalResolutionhoursClock = 2;
                }
               // cs.AOSI_Resolution_Time_New__c = totalResolutionhours;
               // cs.AOSI_Resolution_Clock_Time__c = totalResolutionhoursClock;                    
            }
            else if(cs.AOSI_Case_Close_Time__c != null && cs.AOSI_Appointment_Date__c != null ){                               
                if(cs.AOSI_Appointment_Date__c < cs.AOSI_Case_Close_Time__c){
                    ResolutiondaysNo = findNoOfDays( cs.AOSI_Appointment_Date__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                    ResolutiontotalDays = cs.AOSI_Appointment_Date__c.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                    Resolutionsunday = ResolutiontotalDays-ResolutiondaysNo; 
                    ResolutionNoHolidays = findNoOfHolidays( cs.AOSI_Appointment_Date__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                    firstDayResolutionTime = FindfirstDaysHour(cs.AOSI_Appointment_Date__c);
                    lsatDayResolutionTime = FindLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                    totalResolutionhours = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2);                             
                    firstDayResolutionTimeClock = FindfirstDaysHourTimeClock(cs.AOSI_Appointment_Date__c);                
                    lsatDayResolutionTimeClock = FindLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                    totalResolutionhoursClock = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2); 
                } 
                else{
                    totalResolutionhours = 2;
                    totalResolutionhoursClock = 2;
                }                                
            }
            else if(cs.Assignment_End_Time__c != null){
                if(cs.CreatedDate < cs.Assignment_End_Time__c ){
                    ResolutiondaysNo = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                    ResolutiontotalDays = cs.CreatedDate.date().daysBetween(cs.Assignment_End_Time__c.date());
                    Resolutionsunday = ResolutiontotalDays-ResolutiondaysNo; 
                    ResolutionNoHolidays = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                    firstDayResolutionTime = FindfirstDaysHour(cs.CreatedDate);
                    lsatDayResolutionTime = FindLasttDaysHour(cs.Assignment_End_Time__c);               
                    totalResolutionhours = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2); 
                    firstDayResolutionTimeClock = FindfirstDaysHourTimeClock(cs.CreatedDate);                
                    lsatDayResolutionTimeClock = FindLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                    totalResolutionhoursClock = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2);           
                }
                else{
                    totalResolutionhours = 2;
                    totalResolutionhoursClock = 2;
                } 
            }
            else if(cs.AOSI_Case_Close_Time__c != null){
                if(cs.CreatedDate < cs.AOSI_Case_Close_Time__c){
                    ResolutiondaysNo = findNoOfDays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                    ResolutiontotalDays = cs.CreatedDate.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                    Resolutionsunday = ResolutiontotalDays-ResolutiondaysNo; 
                    ResolutionNoHolidays = findNoOfHolidays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                    firstDayResolutionTime = FindfirstDaysHour(cs.CreatedDate);
                    lsatDayResolutionTime = FindLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                    totalResolutionhours = ((ResolutiondaysNo-1-ResolutionNoHolidays)*12) + (Resolutionsunday * 2)+ lsatDayResolutionTime + firstDayResolutionTime + (ResolutionNoHolidays * 2); 
                    firstDayResolutionTimeClock = FindfirstDaysHourTimeClock(cs.CreatedDate);                
                    lsatDayResolutionTimeClock = FindLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                    totalResolutionhoursClock = ((ResolutiondaysNo-1-ResolutionNoHolidays)*24) + (Resolutionsunday * 2)+ lsatDayResolutionTimeClock + firstDayResolutionTimeClock + (ResolutionNoHolidays * 2);                    
                }
                else{
                    totalResolutionhours = 2;
                    totalResolutionhoursClock = 2;
                } 
            }
            
            // code to calculate Response Time
            if(cs.Assignment_Start_Time__c != null && cs.AOSI_Appointment_Date__c != null){
                if(cs.AOSI_Appointment_Date__c < cs.Assignment_Start_Time__c){
                    ResponsedaysNo = findNoOfDays( cs.AOSI_Appointment_Date__c.date() , cs.Assignment_Start_Time__c.date());                
                    ResponsetotalDays = cs.AOSI_Appointment_Date__c.date().daysBetween(cs.Assignment_Start_Time__c.date());
                    Responsesunday = ResponsetotalDays-ResponsedaysNo; 
                    ResponseNoHolidays = findNoOfHolidays( cs.AOSI_Appointment_Date__c.date() , cs.Assignment_Start_Time__c.date());                
                    firstDayResponseTime = FindfirstDaysHour(cs.AOSI_Appointment_Date__c);
                    lsatDayResponseTime = FindLasttDaysHour(cs.Assignment_Start_Time__c);               
                    totalResponsehours = ((ResponsedaysNo-1-ResponseNoHolidays)*12) + (Responsesunday * 2)+ lsatDayResponseTime + firstDayResponseTime + (ResponseNoHolidays * 2);                 
                    firstDayResponseTimeClock = FindfirstDaysHourTimeClock(cs.AOSI_Appointment_Date__c);                
                    lsatDayResponseTimeClock = FindLasttDaysHourTimeClock(cs.Assignment_Start_Time__c);                             
                    totalResponsehoursClock = ((ResponsedaysNo-1-ResponseNoHolidays)*24) + (Responsesunday * 2)+ lsatDayResponseTimeClock + firstDayResponseTimeClock + (ResponseNoHolidays * 2);
                }
                else{
                    totalResponsehours = 2;
                    totalResponsehoursClock = 2;
                }
            }
            else if(cs.Assignment_Start_Time__c != null){
                if(cs.CreatedDate < cs.Assignment_Start_Time__c){
                    ResponsedaysNo = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date());                
                    ResponsetotalDays = cs.CreatedDate.date().daysBetween(cs.Assignment_Start_Time__c.date());
                    Responsesunday = ResponsetotalDays-ResponsedaysNo; 
                    ResponseNoHolidays = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date());                
                    firstDayResponseTime = FindfirstDaysHour(cs.CreatedDate);
                    lsatDayResponseTime = FindLasttDaysHour(cs.Assignment_Start_Time__c);               
                    totalResponsehours = ((ResponsedaysNo-1-ResponseNoHolidays)*12) + (Responsesunday * 2)+ lsatDayResponseTime + firstDayResponseTime + (ResponseNoHolidays * 2); 
                    firstDayResponseTimeClock = FindfirstDaysHourTimeClock(cs.CreatedDate);                
                    lsatDayResponseTimeClock = FindLasttDaysHourTimeClock(cs.Assignment_Start_Time__c);               
                    totalResponsehoursClock = ((ResponsedaysNo-1-ResponseNoHolidays)*24) + (Responsesunday * 2)+ lsatDayResponseTimeClock + firstDayResponseTimeClock + (ResponseNoHolidays * 2);
                }
                else{
                    totalResponsehours = 2;
                    totalResponsehoursClock = 2;
                }
            }
            //Code added by vishwanath to calculate Responded time 
            if(cs.Assignment_Start_Time__c != null){
                if(cs.CreatedDate < cs.Assignment_Start_Time__c){
                    ResponsedaysNo = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date()); 
                    ResponsetotalDays = cs.CreatedDate.date().daysBetween(cs.Assignment_Start_Time__c.date());
                    Responsesunday = ResponsetotalDays-ResponsedaysNo; 
                    ResponseNoHolidays = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_Start_Time__c.date());                   
                    firstDayResponseTime = FindfirstDaysHour(cs.CreatedDate);
                    lsatDayResponseTime = FindLasttDaysHour(cs.Assignment_Start_Time__c);
                    resondedtime = ((ResponsedaysNo-1-ResponseNoHolidays)*12) + (Responsesunday * 0)+ lsatDayResponseTime + firstDayResponseTime + (ResponseNoHolidays * 2); 
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
            //code to calculate Job Time
            if(cs.Assignment_Start_Time__c != null && cs.Assignment_End_Time__c != null ){
                if(cs.Assignment_Start_Time__c < cs.Assignment_End_Time__c){
                    JobdaysNo = findNoOfDays( cs.Assignment_Start_Time__c.date() , cs.Assignment_End_Time__c.date());                
                    JobtotalDays = cs.Assignment_Start_Time__c.date().daysBetween(cs.Assignment_End_Time__c.date());
                    Jobsunday = JobtotalDays-JobdaysNo; 
                    JobNoHolidays = findNoOfHolidays( cs.Assignment_Start_Time__c.date() , cs.Assignment_End_Time__c.date());                
                    firstDayJobTime = FindfirstDaysHour(cs.Assignment_Start_Time__c);
                    lsatDayJobTime = FindLasttDaysHour(cs.Assignment_End_Time__c);               
                    totalJobhours = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2);                  
                    firstDayJobTimeClock = FindfirstDaysHourTimeClock(cs.Assignment_Start_Time__c);                
                    lsatDayJobTimeClock = FindLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                    totalJobhoursClock = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                }
                else{
                    totalJobhours = 2;
                    totalJobhoursClock=2;    
                }               
            }
            else if(cs.Assignment_Start_Time__c != null && cs.AOSI_Case_Close_Time__c != null){
                if(cs.Assignment_Start_Time__c < cs.AOSI_Case_Close_Time__c){
                    JobdaysNo = findNoOfDays( cs.Assignment_Start_Time__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                    JobtotalDays = cs.Assignment_Start_Time__c.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                    Jobsunday = JobtotalDays-JobdaysNo; 
                    JobNoHolidays = findNoOfHolidays( cs.Assignment_Start_Time__c.date() , cs.AOSI_Case_Close_Time__c.date());                
                    firstDayJobTime = FindfirstDaysHour(cs.Assignment_Start_Time__c);
                    lsatDayJobTime = FindLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                    totalJobhours = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2); 
                    firstDayJobTimeClock = FindfirstDaysHourTimeClock(cs.Assignment_Start_Time__c);                
                    lsatDayJobTimeClock = FindLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                    totalJobhoursClock = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                }
                else{
                    totalJobhours = 2;
                    totalJobhoursClock=2;    
                }  
            }  
            else if(cs.CreatedDate != null && cs.Assignment_End_Time__c != null){
                if(cs.CreatedDate < cs.Assignment_End_Time__c){
                        JobdaysNo = findNoOfDays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                        JobtotalDays = cs.CreatedDate.date().daysBetween(cs.Assignment_End_Time__c.date());
                        Jobsunday = JobtotalDays-JobdaysNo; 
                        JobNoHolidays = findNoOfHolidays( cs.CreatedDate.date() , cs.Assignment_End_Time__c.date());                
                        firstDayJobTime = FindfirstDaysHour(cs.CreatedDate);
                        lsatDayJobTime = FindLasttDaysHour(cs.Assignment_End_Time__c);               
                        totalJobhours = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2);                  
                        firstDayJobTimeClock = FindfirstDaysHourTimeClock(cs.CreatedDate);                
                        lsatDayJobTimeClock = FindLasttDaysHourTimeClock(cs.Assignment_End_Time__c);               
                        totalJobhoursClock = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                }
                else{
                    totalJobhours = 2;
                    totalJobhoursClock=2;    
                }               
            }
            else if(cs.CreatedDate != null && cs.AOSI_Case_Close_Time__c != null){
                if(cs.CreatedDate < cs.AOSI_Case_Close_Time__c){
                    JobdaysNo = findNoOfDays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                    JobtotalDays = cs.CreatedDate.date().daysBetween(cs.AOSI_Case_Close_Time__c.date());
                    Jobsunday = JobtotalDays-JobdaysNo; 
                    JobNoHolidays = findNoOfHolidays( cs.CreatedDate.date() , cs.AOSI_Case_Close_Time__c.date());                
                    firstDayJobTime = FindfirstDaysHour(cs.CreatedDate);
                    lsatDayJobTime = FindLasttDaysHour(cs.AOSI_Case_Close_Time__c);               
                    totalJobhours = ((JobdaysNo-1-JobNoHolidays)*12) + (Jobsunday * 2)+ lsatDayJobTime + firstDayJobTime + (JobNoHolidays * 2); 
                    firstDayJobTimeClock = FindfirstDaysHourTimeClock(cs.CreatedDate);                
                    lsatDayJobTimeClock = FindLasttDaysHourTimeClock(cs.AOSI_Case_Close_Time__c);               
                    totalJobhoursClock = ((JobdaysNo-1-JobNoHolidays)*24) + (Jobsunday * 2)+ lsatDayJobTimeClock + firstDayJobTimeClock + (JobNoHolidays * 2);
                }
                else{
                    totalJobhours = 2;
                    totalJobhoursClock=2;    
                }  
            }  
            cs.AOSI_Resolution_Time_New__c = totalResolutionhours;
            cs.AOSI_Resolution_Clock_Time__c = totalResolutionhoursClock; 
            cs.AOSI_Response_Time_New__c = totalResponsehours.setscale(2);
            cs.AOSI_Response_Clock_Time__c = totalResponsehoursClock;
            cs.AOSI_Job_Time_New__c = totalJobhours;
            cs.AOSI_Job_Clock_Time__c = totalJobhoursClock;
            cs.AOSI_Respond_Time__c= resondedtime.setscale(2);
        }
    }    
    // code to count no of days between two dates excluding sundays
    public Decimal findNoOfDays( Date startDate , Date endDate ) {                           
         Decimal NoOfDays = 0;
         Date tempStartDate = startDate;                                 
         for(integer i=1; tempStartDate!= endDate;i+1) {           
           if(tempStartDate.daysBetween(tempStartDate.toStartofWeek()) == 0)
           {
               tempStartDate = tempStartDate.adddays(1);
               continue;
           }         
           NoOfDays = NoOfDays+1;
           tempStartDate = tempStartDate.adddays(1);                     
        }   
        return NoOfDays ;
    }
    //code to count no of holidays between two dates
    public Decimal findNoOfHolidays (Date startDate , Date endDate){
        Decimal NoOfHoliDays = 0;
        List<Holidays__c> holidayList = [Select id, Date__c from Holidays__c where Date__c >=: startDate AND Date__c <=: endDate];
        if(holidayList.size()>0){
            NoOfHoliDays = holidayList.size(); 
        }
        return NoOfHoliDays;
    }
    // code to calculate time diffrence between start time and 8pm
    public decimal FindfirstDaysHour( Datetime startDate ){       
        datetime staticDatetime = datetime.newInstance(startDate.DATE(),time.newInstance(20,00,0,0));
        decimal minstart = startDate.hour()*60 + startDate.minute();
        decimal minend = staticDatetime.hour()*60 + staticDatetime.minute();
        decimal diffInMin = minend-minstart;
        decimal diiffInHour = diffInMin/60;  
        return  diiffInHour;    
    }
    //code to calculate time diffrence between 8AM and End Time 
    public decimal FindLasttDaysHour( Datetime EndDate ){       
        datetime staticDatetime = datetime.newInstance(EndDate.DATE(),time.newInstance(8,00,0,0));
        decimal minstart = staticDatetime.hour()*60 + staticDatetime.minute();
        decimal minend = EndDate.hour()*60 + EndDate.minute();
        decimal diffInMin = minend-minstart;
        decimal diffInHour = diffInMin/60;  
        return  diffInHour;    
    }
    // code to calculate time diffrence between start time and 12am
    public decimal FindfirstDaysHourTimeClock( Datetime startDate ){       
        datetime staticDatetime = datetime.newInstance(startDate.DATE(),time.newInstance(23,59,59,0));
        decimal minstart = startDate.hour()*60 + startDate.minute();
        decimal minend = staticDatetime.hour()*60 + staticDatetime.minute()+0.98;
        decimal diffInMin = minend-minstart;
        decimal diiffInHour = diffInMin/60;  
        return  diiffInHour;    
    }
    //code to calculate time diffrence between 12AM and End Time 
    public decimal FindLasttDaysHourTimeClock( Datetime EndDate ){       
        datetime staticDatetime = datetime.newInstance(EndDate.DATE(),time.newInstance(00,00,0,0));
        decimal minstart = staticDatetime.hour()*60 + staticDatetime.minute();
        decimal minend = EndDate.hour()*60 + EndDate.minute();
        decimal diffInMin = minend-minstart;
        decimal diffInHour = diffInMin/60;  
        return  diffInHour;    
    }
}