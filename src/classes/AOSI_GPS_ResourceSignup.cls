@RestResource(urlMapping='/resourcesignin/*')
global class AOSI_GPS_ResourceSignup{
	@HttpPost
	global static String signUp(){
        //User already registered  
		StatusMessage statusmessage=new StatusMessage();
		statusmessage.status=AOSI_GPS_MessageHandler.getMessage('16').get(1);
		String ret=AOSI_GPS_MessageHandler.getMessage('16').get(0);
		statusmessage.message=ret;
		RestRequest req = RestContext.request; 
        system.debug('request'+req);
		String sign_up_json = null;
		if(req.params.get('res_signup_params') !=null)
		{
			sign_up_json=req.params.get('res_signup_params');
		}		      
		if(sign_up_json==null)
		{
			ret=AOSI_GPS_MessageHandler.getMessage('11').get(0);
			statusmessage.status=AOSI_GPS_MessageHandler.getMessage('11').get(1);
		}
		else{
			String mobilenumber;
			String firstname;
			String lastname;
			String IMEI;
			String password;
			
			JSONParser parser = JSON.createParser(sign_up_json);
			
			while (parser.nextToken()!= null) {
				if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
					String fieldName = parser.getText();
					parser.nextToken();
					if(fieldName == 'res_mobile_number') {
						mobilenumber = parser.getText();
					} else if(fieldName == 'res_first_name'){
						firstname = parser.getText();
					}else if(fieldName == 'res_last_name'){
						lastname = parser.getText();
					}else if(fieldName == 'res_imei'){
						IMEI = parser.getText();
					}else if(fieldName == 'res_pwd'){
						password = parser.getText();
					}
				}
			}

			if(mobilenumber!=null)
			{
                if(mobilenumber.startsWith('+91') && mobilenumber.length()==13)
                {
                    mobilenumber=mobilenumber.replaceAll('+91','');
                }else if(mobilenumber.startsWith(' 91') && mobilenumber.length()==13)
                {
                    mobilenumber=mobilenumber.replaceAll(' 91','');
                }
				if(mobilenumber.length() == 10)
				{
					Service_Engineer__c resource=null;
					try{
						resource=[select Id,AOSI_IMEI_Number__c,AOSI_IMEI_Approved__c from Service_Engineer__c where Mobile_Number__c =:mobilenumber limit 1];
					}catch(Exception ex)
					{
						system.debug('Exception'+ex);
						ret='Error '+ex.getMessage();
						statusmessage.status='Failure';
						statusmessage.message=ex.getMessage();    
						
					}
					
           if(resource != null) // If resource exists
           {
           	if(resource.AOSI_IMEI_Number__c !=IMEI)
           	{
           		resource.AOSI_IMEI_Number__c=IMEI;
           		resource.AOSI_password__c=password;
           		resource.AOSI_IMEI_Approved__c='Submit For Approval'; 
           		update resource; 
              //updating the record with the new IMEI number
              // IMEI Number doesn't match, submit the record for approval
           		try
           		{  
           			
           			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
           			req1.setObjectId(resource.id);
           			Approval.ProcessResult result = Approval.process(req1);
                //IMEI updated and sent for approval  
           			ret=AOSI_GPS_MessageHandler.getMessage('17').get(0);
           			statusmessage.status=AOSI_GPS_MessageHandler.getMessage('17').get(1);
           			statusmessage.message=ret;  

           		}
           		Catch(Exception ex)
           		{
           			system.debug('Exception in approval process'+ex);
                //IMEI updated but not sent for approval  
           			ret =AOSI_GPS_MessageHandler.getMessage('18').get(0);
           			statusmessage.status=AOSI_GPS_MessageHandler.getMessage('18').get(1);
           			statusmessage.message=ret;  
           		}  
           	}
           }        else
           {
           //Resource does not exist in the system   
           	ret =AOSI_GPS_MessageHandler.getMessage('1').get(0);
           	statusmessage.status=AOSI_GPS_MessageHandler.getMessage('1').get(1);
           	statusmessage.message=ret;    
           /*   
          // Create a new resource if it doesn't exist
            Service_Engineer__c newresource =new Service_Engineer__c();
            newresource.Name = firstname + ' '+lastname;
            newresource.Mobile_Number__c=mobilenumber.substring(3, mobilenumber.length());
            newresource.AOSI_IMEI_Number__c=IMEI;
              
            insert newresource;
          // Send the record for approval
            try
            {  
             
              Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
              req1.setObjectId(newresource.id);
              Approval.ProcessResult result = Approval.process(req1);
              ret='Created a new resource and sent for approval'; 
            }
            Catch(Exception ex)
            {
              //message='This approval request does not match the entry criteria.\nPlease make sure this record fulfils all the criteria to be submitted for approval.';
              system.debug('Exception in approval process'+ex);
            } 
            */  
        } 
    }
    else
    {
    	ret=AOSI_GPS_MessageHandler.getMessage('19').get(0);
    	statusmessage.status=AOSI_GPS_MessageHandler.getMessage('19').get(1);
    	statusmessage.message=ret;   
    }
}
}    
System.debug('response'+JSON.serializePretty(statusmessage));        
return JSON.serializePretty(statusmessage);
}
class StatusMessage
{
	String status;
	String message;
}
}