/*=============================================================================================
CreatedBy : Vishwanath Attikeri(KVP business solution)
ModifiedBy :
Description : This class is used to update the service engineer attendence detail for next 7 days
=================================================================================================*/
Public class SEAttendenceUpdate{
    
    public String regionval{get;set;}
    public List<SelectOption> getregiondata(){
        List<SelectOption> options = new List<SelectOption>();
          options.add(new selectOption('', '- None -'));
           options.add(new selectOption('All', 'All'));
           options.add(new selectOption('East', 'East')); 
           options.add(new selectOption('West', 'West')); 
           options.add(new selectOption('South', 'South')); 
           options.add(new selectOption('North', 'North'));  
           return options;
    
    }
    
    public String Stateval{get;set;}
    Public Set<String> statestr=new Set<String>();
    public List<SelectOption> getstatedata(){
    statestr.clear();
        List<SelectOption> options = new List<SelectOption>();
          options.add(new selectOption('', '- None -'));
          for(Pin_Master__c PM:[select id,AOSI_State__c from Pin_Master__c where AOSI_Region__c=:regionval order by AOSI_State__c]){
              statestr.add(PM.AOSI_State__c);
          }
          for(String str: statestr){
           options.add(new selectOption(str, str)); 
          }
          options.sort();
           return options;
    
    }
    
     public String Cityval{get;set;}
    Public Set<String> Citystr=new Set<String>();
    public List<SelectOption> getcitydata(){
    Citystr.clear();
        List<SelectOption> options = new List<SelectOption>();
          options.add(new selectOption('', '- None -'));
          for(Pin_Master__c PM:[select id,AOSI_City__c from Pin_Master__c where AOSI_State__c=:Stateval order by AOSI_City__c]){
              Citystr.add(PM.AOSI_City__c);
          }
          for(String str: Citystr){
           options.add(new selectOption(str, str)); 
          }
          options.sort();
           return options;
    
    }
    
    public  List<SelectOption>  getServEnggType() {
        List<SelectOption> options = new List<SelectOption>();
          options.add(new selectOption('', '- None -')); 
          Set<String> seList = new Set<String>{'Co-ordinator' ,'Sales Executive'};
         
          //to get all the picklist values associated with the Service Engineer Type
          Schema.DescribeFieldResult fieldResult =  Service_Engineer__c.Type__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
            for( Schema.PicklistEntry f : ple)
            {
                string strValue = f.getValue();
                if(!seList.contains(strValue))
                options.add(new SelectOption(f.getValue(), f.getValue()));//To put the values in select options
            }           
         return options;
    }


    public String selectedEnggType { get; set; }
    Public Boolean updated{get;set;}
    Public List<Service_Engineer__c> SEList{get;set;}
    public list<date> lstdates {get;set;}
    Public List<Integer> Intlist{get;set;}
    Public List<String> Daylist{get;set;}
    Public Date firstDayOfWeek{get;set;}
    Public Date lastDayOfWeek{get;set;}
    Public Date todaydate{get;set;}
    Public Date lastDayOfWeek_Disp{get;set;}
    Public List<Attendence__c> attlist=new List<Attendence__c>();
    Public Service_Engineer__c Serv_Eng{get;set;}
    Public List<User> ulist;
    public SEAttendenceUpdate(){
        updated=false;
        todaydate=system.today();
        Daylist=new List<String>();
        Intlist=new List<Integer>();
        Serv_Eng=new Service_Engineer__c();
        //start date of the week
        firstDayOfWeek = System.today(); //.toStartOfWeek();
        system.debug('====='+firstDayOfWeek);
        //End date of the week
        lastDayOfWeek = firstDayOfWeek.addDays(7);
        lastDayOfWeek_Disp = firstDayOfWeek.addDays(6);
        //Number of dates between the week
        integer daysBetween = firstDayOfWeek.daysBetween(lastDayOfWeek);
        lstdates = new list<date>();
        set<id> asproleid=new set<id>();
        list<UserRole> lstRole = [Select id,name from UserRole where id =: Userinfo.getUserRoleId()];
        for(UserRole l : lstRole){
          system.debug('==========l.Name '+l.Name );
            if((l.Name == 'Service Executive South') || (l.Name == 'Regional Manager South') || (l.Name == 'Regional Call Coordinator South')){          
                regionval ='South';
                system.debug('==========south'+regionval);
            }
            else if((l.Name == 'Service Executive North') || (l.Name == 'Regional Manager North') || (l.Name == 'Regional Call Coordinator North')){               
                 regionval = 'North';
                 system.debug('==========North'+regionval);
            }
            else if((l.Name == 'Service Executive East') || (l.Name == 'Regional Manager East') || (l.Name == 'Regional Call Coordinator East')){               
                 regionval = 'East';
                 system.debug('==========East'+regionval);
            }
            else if((l.Name == 'Service Executive West') || (l.Name == 'Regional Manager West') || (l.Name == 'Regional Call Coordinator West')){               
                 regionval = 'West';
                 system.debug('==========West'+regionval);
            }
            else if((l.Name == 'ASP South') || (l.Name == 'ASP North') || (l.Name == 'ASP East') ||  (l.Name == 'ASP West')){
                SEList=[select id,name,Region__c,type__c,(select id,AOSI_Present__c,AOSI_Service_Engineer__c,AOSI_Date__c from Attendance__r where  (AOSI_Date__c >=: firstDayOfWeek and AOSI_Date__c <=:lastDayOfWeek) order by AOSI_Date__c) from Service_Engineer__c where AOSI_ASP_User_New__c=: UserInfo.getName()  AND AOSI_Active__c =: TRUE ORDER BY Name ];
            }
            system.debug('==========regionval'+regionval);
           
        }
        //loop to add number of days and add the days in list
        for(integer i = 0; i < daysBetween ; i++){
            lstdates.add(system.today().addDays(i));
            Intlist.add(Integer.valueof((firstDayOfWeek.addDays(i)).day()));
            Date weekStart = (firstDayOfWeek.addDays(i)).toStartofWeek();
            Integer dayOfWeek = weekStart.daysBetween((firstDayOfWeek.addDays(i)));
             String dn;
            if(dayOfWeek==0)
                {dn='Sun';}
            else if(dayOfWeek==1)
                {dn='Mon';}
            else if(dayOfWeek==2)
                {dn='Tue';}
            else if(dayOfWeek==3)
                {dn='Wed';}
            else if(dayOfWeek==4)
                {dn='Thu';}
            else if(dayOfWeek==5)
                {dn='Fri';}
            else 
                {dn='Sat';}
                Daylist.add(dn);
                dayOfWeek=0;
                dn='';
        }
       
     
    }
    public void displaySE(){
        //Query to extract the records
        system.debug('Region++'+Serv_Eng);
        system.debug('Region++'+Serv_Eng.Region__c);
        if(regionval != 'All')
        SEList=[select id,name,(select id,AOSI_Present__c,AOSI_Service_Engineer__c,AOSI_Date__c from Attendance__r where  (AOSI_Date__c >=: firstDayOfWeek and AOSI_Date__c <=:lastDayOfWeek) order by AOSI_Date__c) from Service_Engineer__c where  AOSI_City__c =: cityval AND AOSI_Active__c =: TRUE AND Type__c =: selectedEnggType ORDER BY name];
        else
        SEList=[select id,name,(select id,AOSI_Present__c,AOSI_Service_Engineer__c,AOSI_Date__c from Attendance__r where  (AOSI_Date__c >=: firstDayOfWeek and AOSI_Date__c <=:lastDayOfWeek) order by AOSI_Date__c) from Service_Engineer__c where  AOSI_Active__c =: TRUE AND Type__c =:selectedEnggType ORDER BY name];
    }   
    //Update Attendence Detail
    public PageReference save(){
        updated=true;
         system.debug('====='+updated);
        for(Service_Engineer__c SE:SEList){
            for(Attendence__c a:SE.Attendance__r){
                attlist.add(a);
            }
        }
        if(!attlist.isempty())
        try{
            update attlist;
            }
           Catch(DMLException E){
               System.debug(E);
           }
        PageReference pp=new PageReference('/apex/SEAttendenceUpdateSuccess');
        pp.setredirect(True);
        return pp;
        }
        
}