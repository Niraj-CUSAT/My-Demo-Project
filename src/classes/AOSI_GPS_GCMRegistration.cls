@RestResource(URLMapping='/registerdevice/*')
global class AOSI_GPS_GCMRegistration {
    
    @HttpPost
    global static void registerDevice()
    {
        RestRequest request=Restcontext.request;
        String requestjson=request.params.get('registrationinfo');
        RegistrationInfo reginfo=(RegistrationInfo)Json.deserialize(requestjson,RegistrationInfo.class);
        Service_Engineer__c resource=[select AOSI_GCM_Registration_ID__c from Service_Engineer__c where Id =:reginfo.resourceid];
        Response response=new Response();
        if(resource != null)
        {
          resource.AOSI_GCM_Registration_ID__c=reginfo.registration_id;
          Database.SaveResult saveresult=Database.update(resource,false);  
          if(saveresult.isSuccess())
          {
              
           response.resourceid=reginfo.resourceid;
           response.status='Success' ;
           response.message='Registration Id successfully updated'; 
          }
				else {
                    response.status='Failure';
                    List<Error> errors=new List<Error>();
					for(Database.Error err : saveresult.getErrors()) {
                        Error error=new Error();
                        error.message=err.getMessage();
                        errors.add(error);
					}
                    response.errors=errors;
				}
            
        }
        else
        {
           response.resourceid=reginfo.resourceid;
           response.status='Failure' ;
           response.message='Resource not found.'; 
        }
        string json_data = json.serialize(response);
		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.responseBody = Blob.valueOf(json_data);
    }

class RegistrationInfo
{
    String resourceid;
    String registration_id;
}

class Response
{
    String resourceid;
    String message;
    String status;
    List<Error> errors;
}

    class Error
    {
        String message;
    }    
}