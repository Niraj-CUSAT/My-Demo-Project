/*
* Developer Name: Rajesh Kumar
* Created Date : 
* Description : This web service is creates a new PRR and attaches itself to the Case.
* Request Parameters : 1) record
* Modified By : Rajesh Kumar
*/

@RestResource(urlMapping='/createprr/*')
global class AOSI_GPS_CreatePRR {
	@HttpPost   
	global static void createPRR()
	{
		Response response =new Response();
		RestRequest req = RestContext.request; 
		String record_details = req.params.get('record');
		if(record_details!=null)
		{
			Map<String, Object> json_req_input = (Map<String, Object>)JSON.deserializeUntyped(record_details);
			PRR__c prr=new PRR__c(); 
			prr.AOSI_PRR_Number__c=(String)json_req_input.get('PRR_Number');
			prr.AOSI_Type__c=(String)json_req_input.get('PRRType');
			prr.AOSI_Case__c=(String)json_req_input.get('CaseNumber');
			prr.AOSI_Approval_Status__c=(String)json_req_input.get('Approval_Status');
			prr.AOSI_Product__c=(String)json_req_input.get('Product');
			prr.AOSI_Asset__c=(String)json_req_input.get('Asset');
			prr.AOSI_Account__c=(String)json_req_input.get('Account');
			prr.AOSI_DOA_Dead_On_Arrival__c=(Boolean)json_req_input.get('DOA_Dead_On_Arrival');
			prr.AOSI_Repeat_Failure__c=(Boolean)json_req_input.get('Repeat_Failure');
			prr.AOSI_Transit_Damaged__c=(Boolean)json_req_input.get('Transit_Damaged');
			prr.AOSI_Others__c=(Boolean)json_req_input.get('Others');
			prr.AOSI_Manufacture_Fault_Non_Repairable__c=(Boolean)json_req_input.get('Manufacture_Fault_Non_Repairable');
			prr.AOSI_Serious_Issue_Product_Burnt__c=(Boolean)json_req_input.get('Serious_Issue_Critical_Issue');
			prr.Tank_Failure__c=(Boolean)json_req_input.get('Tank_Failure');
			prr.AOSI_Other_Reason__c=(String)json_req_input.get('Other_Reason');
			prr.AOSI_Refund_Value__c=(Decimal)json_req_input.get('Refund_Value');
			prr.AOSI_Justification__c=(String)json_req_input.get('Justification');
			prr.AOSI_GPS_MobileId__c = (String)json_req_input.get('AppId');
			prr.AOSI_Invoice_Attached__c=(Boolean)json_req_input.get('Invoice_Attached');
            prr.AOSI_GPS_Resource__c = (String)json_req_input.get('ResourceId');
            prr.AOSI_GPS_TimeStamp__c = DateTime.valueOf((String)json_req_input.get('TimeStamp'));
            //**************************Fields Not Writable********************************
            //prr.Request_Type__c=json_req_input.get('Request_Type');
            //prr.AOSI_Customer_Name__c=json_req_input.get('Customer_Name');
            //prr.AOSI_Delivery_Address__c=json_req_input.get('Delivery_Address');
            //prr.Landmark__c=json_req_input.get('Landmark');
            //prr.AOSI_DOP__c=json_req_input.get('DOP');  
            //prr.AOSI_Final_Refund_Value__c=json_req_input.get('Final_Refund_Value');     
            //*****************************************************************************  
			if((Boolean)json_req_input.get('Depreciation_Allowed')==true)
			{
				prr.AOSI_Depreciation_Allowed__c=(Boolean)json_req_input.get('Depreciation_Allowed');
				prr.AOSI_Depreciation_value__c=(Decimal)json_req_input.get('Depreciation_Value');    
			}

			Database.SaveResult sr=null;
			sr=Database.insert(prr,false);
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