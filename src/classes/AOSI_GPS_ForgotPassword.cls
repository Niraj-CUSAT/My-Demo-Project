@RestResource(urlMapping='/resetpassword/*')
global class AOSI_GPS_ForgotPassword {
  
  @HttpPost
  global static String createRecord(){
    String smsSenderID=DefineConstant.SMS_SENDER_ID;
    map<String,String> mapSMSTemplateText = new map<String,String>(); //Contains SMS template name and template text
    mapSMSTemplateText = AOSI_StaticQueryHelper.mCaseSMSTemplateText;   
    RestRequest req = RestContext.request; 
      
    string forgetpwd_json = req.params.get('data');
    System.debug('forgetpwd_json'+forgetpwd_json);  
    Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(forgetpwd_json);
    //String resourceid=(String)json_req_input.get('resource_id');
    String mobilenumber=(String)json_req_input.get('mobile_number');
    String mode=(String)json_req_input.get('mode');
    
    Response response=new Response();
    Service_Engineer__c resource=null;
    
    try{
      resource=[select Id,Redirect_to_password_change_page__c,AOSI_Temporary_Password__c,Name,Mobile_Number__c,AOSI_IMEI_Number__c,AOSI_IMEI_Approved__c,AOSI_password__c from Service_Engineer__c where Mobile_Number__c =:mobilenumber.substring(3, mobilenumber.length())];
    }catch(Exception ex)
    {
      system.debug('Exception'+ex);
    }
    if(resource !=null)
    {
        if(mode=='check_status')
        {
           response.changepasswordinprogress=resource.Redirect_to_password_change_page__c;
        }
        else if(mode=='generate_temp_pwd')
        {
			String temp_password= generateTempPassword(8);
            resource.AOSI_Temporary_Password__c=temp_password;
            resource.AOSI_password__c=temp_password;
            resource.Redirect_to_password_change_page__c=true;
            //update resource;
            Database.SaveResult saveresult=Database.update(resource, false);

            if(saveresult.isSuccess())
            {
            String s= ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_RESOURCE, resource, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_TEMP_PASSWORD));    
            s=s.replaceAll(':', temp_password+' :');
            smagicinteract__smsMagic__c smsHistory  =  ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_RESOURCE,resource.Mobile_Number__c,s); 
            smsHistory.Resource__c=resource.Id;
            
            Database.SaveResult smsHistory_saveresult =Database.insert(smsHistory, true);
            if(smsHistory_saveresult.isSuccess())
            {
            //response.message='Temporary password has been sent';
  		    //response.status='Success';
  		    response.message=AOSI_GPS_MessageHandler.getMessage('2').get(0);
  		    response.status=AOSI_GPS_MessageHandler.getMessage('2').get(1);
            }
            else
            {
                //response.message='Error while sending SMS';
  		    	//response.status='Failure'; 
  		    	response.message=AOSI_GPS_MessageHandler.getMessage('3').get(0);
  		    	response.status=AOSI_GPS_MessageHandler.getMessage('3').get(1);
            }

            }// if resource updated
            else
            {
                //response.message='Error while updating the record';
       		    //response.status='Failure'; 
                response.message=AOSI_GPS_MessageHandler.getMessage('4').get(0);
  		    	response.status=AOSI_GPS_MessageHandler.getMessage('4').get(1);
            }
            
        }
        else if(mode=='reset_password')
        {
         if((String)json_req_input.get('temp_password')==resource.AOSI_Temporary_Password__c)
         {
             resource.AOSI_password__c =(String)json_req_input.get('new_password');
             resource.Redirect_to_password_change_page__c=false;
             Database.SaveResult resource_saveresult=Database.update(resource, false);
             
             if(resource_saveresult.isSuccess())
             {
             response.message=AOSI_GPS_MessageHandler.getMessage('5').get(0);
  		     response.status=AOSI_GPS_MessageHandler.getMessage('5').get(1);    
             //response.message='Password successfully updated';
       		 //response.status='Success';    
             }
             else
             {
                 response.message=AOSI_GPS_MessageHandler.getMessage('6').get(0);
  		         response.status=AOSI_GPS_MessageHandler.getMessage('6').get(1); 
                 //response.message='Error while updating password';
       			 //response.status='Failure';
             }
             
         }else
         {
             // Temp password and user password doesn't match
             response.message=AOSI_GPS_MessageHandler.getMessage('20').get(0);
  		     response.status=AOSI_GPS_MessageHandler.getMessage('20').get(1); 
         }
        }
        response.changepasswordinprogress=resource.Redirect_to_password_change_page__c;
        
    }else
    {
        //Resource does not exist in the system
        response.message=AOSI_GPS_MessageHandler.getMessage('6').get(0);
  		response.status=AOSI_GPS_MessageHandler.getMessage('6').get(1); 
        //response.message='Resource does not exist in the system';
        //response.status='Failure';
    }
    
      return Json.serializePretty(response);
    
    
  }
    /*******************************************************************************************************************************************************
        * Method Name : generateTempPassword
        * Description : Generates a temporary password
    /*******************************************************************************************************************************************************/ 
    public static String generateTempPassword(Integer len){
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,len);
    }
    
 class Response
 {
     String message;
     String status;
     Boolean changepasswordinprogress;
     
 }

}