@RestResource(urlMapping='/createrecord/*')
global class AOSI_GPS_CreateRecord {
  
  @HttpPost
  global static void createRecord(){
    Response response =new Response();
    RestRequest req = RestContext.request; 
    String record_details = req.params.get('record'); 
    if(record_details!=null)
    {
      Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(record_details);
      
      if(json_req_input.get('master') == 'Asset')
      {
        Asset newasset=new Asset();
        newasset.Name = (String)json_req_input.get('serialnumber');	
        newasset.Product2Id = (String)json_req_input.get('product');
        newasset.PurchaseDate = Date.valueOf((String)json_req_input.get('purchasedate'));
        newasset.AOSI_Membrane_Warranty__c=(String)json_req_input.get('membrane_warranty');
        newasset.AOSI_GPS_MobileId__c=(String)json_req_input.get('AppId');  
        newasset.AOSI_GPS_TimeStamp__c   = DateTime.valueOf((String)json_req_input.get('TimeStamp'));
        newasset.AOSI_GPS_Resource__c=(String)json_req_input.get('ResourceId');
        Database.SaveResult sr=null;
        sr=Database.insert(newasset,false);
        if(sr!=null)
        { 
          if (sr.isSuccess()) {
           response.success =true;
           response.Id=sr.getId();   
         }
         else {
        // Operation failed, so get all errors  
          List<Error> errors=new List<Error>();
          for(Database.Error err : sr.getErrors()) {
            Error error=new Error();  
            error.StatusCode=err.getStatusCode();
            error.Message=err.getMessage();
            errors.add(error);
          }
          response.success =false;
          response.errors= errors; 
        }       
      }
    }  
  }
		string json_data = json.serialize(response);
		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.responseBody = Blob.valueOf(json_data);   
    
}
class Response
{
  String Id;
  Boolean success;
  Error[] errors;
}

class Error
{
  StatusCode StatusCode;
  String Message;
  
}    


}