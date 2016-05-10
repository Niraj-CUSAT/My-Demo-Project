Global class ISP_Createscheduledtask implements Schedulable{
  
 public  Set<Id> userids;
 public ISP_Createscheduledtask (){
   userIds =  new Set<Id>();
     for(User u : [select id from user where profileId in (select id from profile where name = 'Instore Promoter')]){
            userids.add(u.id);
        }
  }   

 public void Createtasks(){
       
        //userids.add('00540000001utEuAAI'); 
        
        list<Task> taskList = new list<Task>();
        
        for(id owid:userids){
            Task task1          = new Task();
            task1.Subject       = 'Daily Attendance - '+system.today();
            task1.Status        = 'Not Started';
            task1.Priority      = 'Normal';
            task1.IsReminderSet = True;
            task1.activityDate  = system.today();
            task1.OwnerId       = owid;
            taskList.add(task1);
            
            Task task2          = new Task();
            task2.Subject       = 'Submit Daily Sales Reports - '+system.today();
            task2.Status        = 'Not Started';
            task2.Priority      = 'Normal';
            task2.IsReminderSet = True;
            task1.activityDate  = system.today();
            task2.OwnerId       = owid;
            taskList.add(task2);                    
        }
        
                
        try{
            Insert taskList;
        }
        catch(Exception ex){
            System.debug('------------Exception-----------------'+ex);
        }
        
    }

   public void updateTasks(){
          list<task> taskList =  new list<task>();
          for(task t : [select id, status from task where ownerId in: userids and status = 'Not Started']){
                   t.status = 'Not Completed';
                  taskList.add(t);
          }

          if(!taskList.isEmpty()){
                 update taskList;
           }

   }
   
   
   public void createAlbumschedule(){
      
       list<Task> taskList = new list<Task>();
       Map<id,ISP_Store_Album__c> albumMap = new Map<id,ISP_Store_Album__c>();
       String userLocation =  [select Location__c from user where id =: userInfo.getUserId()].Location__c ;
       //ISP_Store_location__c location = [select id from ISP_Store_location__c where name =:userLocation ];
       date weekEndDate     = system.today()+7;
       date currentDate     = date.newInstance(system.today().year(),system.today().month(),system.today().day()); //string.ValueOf(system.Today()).split(' ')[0];
       Date endDate= date.newinstance(weekEndDate.year(), weekEndDate.month(), weekEndDate.day());
       for(id owid:userids){  
           ISP_Store_Album__c newalbum = new ISP_Store_Album__c();
           newalbum.Name               = userLocation + '-'+ currentDate + '-' + endDate;
           newalbum.From__c            = system.today();
           newalbum.To__c              = system.today()+7;
           //newalbum.Store_Location__c  = location.id;
           newalbum.ownerId            = owid;
           albumMap.put(owid,newalbum);
       }
       
       //Inserting albums for each promoter 
       if(!albumMap.isEmpty()){
           insert albumMap.values();
       }
       
       for(id owid:userids){
            Task task1         = new Task();
            task1.Subject      = 'Upload Store Album - '+system.today()+' - '+system.today()+7;
            task1.Status       = 'Not Started';
            task1.Priority     = 'Normal';
            task1.IsReminderSet= True;
            task1.activityDate = system.today();
            task1.OwnerId      = owid;
            task1.WhatId       = albumMap.get(owid).id;
            taskList.add(task1);
       }
       
       //Inserting upload store album tasks
       if(!taskList.isEmpty()){
           insert taskList;
       }
       
   }//End of Method
   
    global void execute(SchedulableContext sc){
   
        ISP_Createscheduledtask obj = new ISP_Createscheduledtask ();
        obj.createAlbumschedule();
    
    }

     
}