public with sharing class ISP_Attendance_Ext {

    public ISP_Promotor_Attendance__c attendance{get;set;}
    public document doc{get;set;}
    public attachment attach{get;set;}
    public Boolean isLogIn{get;set;}
    public Boolean isLogOut{get;set;}
    public dateTime LoginTime{get;set;}
    
    public ISP_Attendance_Ext(ApexPages.StandardController controller) {
      attendance = new ISP_Promotor_Attendance__c();
      doc        = new document();
      try{
           attendance  = [select Logout_Time__c,Login_time__c  from ISP_Promotor_Attendance__c where Promotor__c =:Userinfo.getUserId() 
                                and Logout_Time__c = null order by createddate desc limit 1];
           LoginTime   = attendance.Login_time__c;
           if(attendance.Logout_Time__c != null){
              isLogIn  = true;
              isLogOut = false;
           }else{
              isLogIn  = false;
              isLogOut = true;
           }
      }catch(Exception e){
           isLogIn  = true;
      }
       
    }
     
     @RemoteAction
     public static ISP_Promotor_Attendance__c createLogin(String docId, String longitude,String latitude,String currentLocation){   //
           
           ISP_Promotor_Attendance__c att = new ISP_Promotor_Attendance__c();
           att.Login_time__c                = system.now();
           att.Login_Locaiton__Longitude__s = longitude != null ? decimal.valueOf(longitude):null;
           att.Login_Locaiton__Latitude__s  = latitude != null ? decimal.valueOf(latitude):null;
           att.Current_Location__c          = currentLocation;
           att.Promotor__c                  = UserInfo.getUserId(); 
           att.store_image__c  = '<img src="https://c.cs15.content.force.com/servlet/servlet.FileDownload?file='+docId+'" width="500" height="281"></img>'; 
           
           try{
                insert att;
           }catch(Exception e){
               apexpages.addMessage(new apexpages.message(apexpages.severity.error,e.getmessage()));
           }finally{
                  // delete new document(id=docId);
               }

           return att;
     }
     
     
     
     public void LoggedIn(){
       ISP_Promotor_Attendance__c att= new ISP_Promotor_Attendance__c();
       
       att.Login_time__c = system.now();
       att.Promotor__c   = UserInfo.getUserId(); 
       LoginTime         = system.now();
       try{
           insert att;
           system.debug('%%%%%attt%%%'+att);
           //Inserting document
          // if(doc.body != null){
               doc.name= 'test';
               doc.folderid= '00l40000000qFOvAAM';
               insert doc;
               system.debug('%%%%%doc%%%'+doc);
              if(doc.id != null){
                  att.store_image__c = '<img src="https://c.cs15.content.force.com/servlet/servlet.FileDownload?file='+doc.id+'" width="500" height="281"></img>'; 
                  // att.store_image__c = '<img src="https://c.cs15.content.force.com/servlet/servlet.FileDownload?file=00Pe0000004ZeG5" width="500" height="281"></img>';
                   update att;
               }
           // }
            system.debug('%%%%%attt after image%%%'+att);
       }catch(Exception e){
           apexpages.addMessage(new apexpages.message(apexpages.severity.error,e.getmessage()));
       }finally{
          doc =  new document();
           if(doc.id != null){
               delete doc;
           }
       }

       //Initializing boolean variables for conditional display
       isLogIn  = false;
       isLogOut = true;

    }
    
    @RemoteAction
    public static ISP_Promotor_Attendance__c UpdateLogout(String longitude, String latitude, String currentLocation){
                                 
       list<ISP_Promotor_Attendance__c> attList =  new list<ISP_Promotor_Attendance__c>();
       ISP_Promotor_Attendance__c att = new ISP_Promotor_Attendance__c();
       attlist = [select id,Logout_Time__c from ISP_Promotor_Attendance__c 
                  where Promotor__c =:Userinfo.getUserId() and Logout_Time__c = null order by createddate desc limit 1]; 
       if(attlist.size() > 0){
           att = attList[0];
           att.Logout_Time__c = system.now(); 
           att.Logout_Location__Longitude__s = longitude != null ? decimal.valueOf(longitude):null;
           att.Logout_Location__Latitude__s  = latitude != null ? decimal.valueOf(latitude):null; 
           att.Logout_Address__c             = currentLocation;
           update att;  
       }
       
       return att;
       
    }
    
    public  void LoggedOut(){
      /* attendance = [select Logout_Time__c,Login_time__c  from ISP_Promotor_Attendance__c where Promotor__c =:Userinfo.getUserId() 
                                and Logout_Time__c = null order by createddate desc limit 1]; */
                                
       list<ISP_Promotor_Attendance__c> attList =  new list<ISP_Promotor_Attendance__c>();
       attlist = [select id,Logout_Time__c from ISP_Promotor_Attendance__c 
                 where Promotor__c =:Userinfo.getUserId() and Logout_Time__c = null order by createddate limit 1]; 
       if(attlist.size() > 0){
           
           attlist[0].Logout_Time__c = system.now();         
           update attList;
           
           //Initializing boolean variables for conditional display
           isLogIn  = true;
           isLogOut = false;

       }
   } 
   //Javascript remote action method to save compressed image as an attachment from canvas start//
   
    @RemoteAction public static RemoteSaveResult saveFile(Id accountId, String imageData) {
        Attachment record = new Attachment(ParentId='001e000000mi0Lz', name='Signature.png', ContentType='image/png', Body=EncodingUtil.base64Decode(imageData));
        Database.saveResult result = Database.insert(record,false);
        RemoteSaveResult newResult = new RemoteSaveResult();
        newResult.success = result.isSuccess();
        newResult.attachmentId = record.Id;
        newResult.errorMessage = result.isSuccess()?'':result.getErrors()[0].getMessage();
        return newResult;
    }
    
    public class RemoteSaveResult {
        public Boolean success;
        public Id attachmentId;
        public String errorMessage;
    }
    
   //Javascript remote action method to save compressed image as an attachment from canvas End//
}