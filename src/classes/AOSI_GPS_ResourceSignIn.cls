@RestResource(urlMapping='/resourcelogin/*')
global class AOSI_GPS_ResourceSignIn{
  @HttpPost
  global static void signIn(){
    Data data=new Data();  
    data.message='Success';
    data.status='Success';
    data.cases=null;  
    data.timestamp=DateTime.now();  
    try
    {
      RestRequest req = RestContext.request; 
      string sign_up_json = req.params.get('res_signup_params');
      system.debug('sign_up_json'+sign_up_json);   
      if(sign_up_json!=null)
      {

        String mobilenumber;
        String firstname;
        String lastname;
        String IMEI;
        String password;
        String timestamp;  
		
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
            else if(fieldName == 'TimeStamp'){
            timestamp=parser.getText();
            }
              
          }

        }
        if(mobilenumber!=null && IMEI!=null && password!=null)
        {
          Service_Engineer__c resource=null;
          try{
            
            resource=[select Id,Redirect_to_password_change_page__c,Name,Mobile_Number__c,AOSI_IMEI_Number__c,AOSI_IMEI_Approved__c,AOSI_password__c from Service_Engineer__c where Mobile_Number__c =:mobilenumber.substring(3, mobilenumber.length()) limit 1];
          }catch(Exception ex)
          {
            system.debug('Exception'+ex);
            //Resource does not exist in the system
            data.message=AOSI_GPS_MessageHandler.getMessage('1').get(0);
            data.status=AOSI_GPS_MessageHandler.getMessage('1').get(1);  
          }

          if(resource !=null)
          {
            ResourceDetails resourceinfo=new ResourceDetails();
            resourceinfo.Id=resource.Id;  
            resourceinfo.ResourceName=resource.Name;
            resourceinfo.MobileNumber=resource.Mobile_Number__c;
            resourceinfo.IMEI=resource.AOSI_IMEI_Number__c;
            resourceinfo.redirecttochangepassword =resource.Redirect_to_password_change_page__c;
            AggregateResult ar=[select count(Id),SUM(AOSI_New_Final_Amount__c) from Case where Status='Closed' and ClosedDate =THIS_MONTH and Service_Engineer__c=:resource.Id] ;
            resourceinfo.TotalClosedCases=(Decimal)ar.get('expr0'); 
            if((Decimal)ar.get('expr1') == null)
            {
                resourceinfo.TotalRevenue=0;
            }
              else
              {
            resourceinfo.TotalRevenue=(Decimal)ar.get('expr1');      
              }
             
            
                
            data.ResourceDetails=resourceinfo;
              
            if(resource.AOSI_IMEI_Number__c != IMEI)
            {
              
              //data.status='Failure';
              //data.message='IMEI is not matching';
              data.message=AOSI_GPS_MessageHandler.getMessage('12').get(0);
            data.status=AOSI_GPS_MessageHandler.getMessage('12').get(1);      
            }
            else if(resource.AOSI_password__c!=password)
            {
              
              //data.status='Failure';
              //data.message='Password Incorrect';
                data.message=AOSI_GPS_MessageHandler.getMessage('13').get(0);
            data.status=AOSI_GPS_MessageHandler.getMessage('13').get(1);    
              
            }
            else if(resource.AOSI_IMEI_Approved__c!='Approved')
            {
              
              //data.status='Failure';
              //data.message='IMEI Approval pending';
              data.message=AOSI_GPS_MessageHandler.getMessage('14').get(0);
            data.status=AOSI_GPS_MessageHandler.getMessage('14').get(1);      
            }

            else if (resource.AOSI_IMEI_Number__c == IMEI && resource.AOSI_password__c==password && resource.AOSI_IMEI_Approved__c=='Approved')
            {
// dump all the cases.
              List<Case> cases_of_resource=null;
              if(timestamp=='unknown')
              {
               cases_of_resource=[SELECT Id,Contact.AOSI_Locality__r.Id,AOSI_Replaced_Product__c,Contact.AOSI_Pin_Code__r.Id,Asset.Id,ContactId,Contact.Name,AOSIProduct__r.Id,Account.Id,AOSI_GPS_Operation_Type__c,CaseNumber,Status,Reason,Asset.Name,AOSI_Asset_Purchase_Date__c,AOSI_Asset_Status__c,AOSI_Purchase_Value__c,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Warranty_Status_I__c,WE_CARE__c,AOSI_Escalate_to_HO__c,AOSI_Call_Escalated__c,AOSI_Response_on_escalation__c,CreatedDate,Contact_Name__c,AOSI_Preferred_Color__c,Parent.CaseNumber,AOSI_Appointment_Date__c,Account.Name,AOSI_Response_on_escalation_date_time__c,AOSI_Customer_Concern__c,Courier_Number__c,AOSI_Agents_Comment__c,Description,AOSI_Work_Done__c,AOSI_Hardness__c,AOSI_Water_Source__c,AOSI_pH__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_TDS_Input__c,AOSI_TDS_Output__c,AOSI_Water_Storage__c , Contact.Title ,Contact.Account.Name,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet ,Contact.Phone,Contact.MobilePhone,Contact.OtherPhone,Contact.Email,Contact.AOSI_Pin_Code__r.Name,Contact.AOSI_Region__c,Contact.AOSI_Locality__r.Name,Contact.AOSI_State__c,Contact.AOSI_City_Picklist__c ,AOSIProduct__r.Name,AOSIProduct__r.ProductCode,AOSIProduct__r.IsActive,AOSIProduct__r.AOSI_Product_Code_for_Serial_Number__c,AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__r.AOSI_Family__c,AOSIProduct__r.AOSIColor__c,AOSIProduct__r.Product_Warranty_AOS_India__c,AOSIProduct__r.AOSI_Comprehensive_Warranty__c,AOSIProduct__r.AOSI_Element_Warranty__c,AOSIProduct__r.AOSI_Free_Installtion__c,AOSIProduct__r.AOSIColorPanel_Free__c,AOSIProduct__r.AOSI_Visit_Charges__c,AOSIProduct__r.AOSI_Installation_Charges__c,AOSIProduct__r.AOSI_Color_Panel_Charges__c,AOSIProduct__r.AOSI_Demounting_Charge__c,AOSIProduct__r.AOSI_Membrane_Wty__c , Asset.Product2.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Asset.AOSI_Product_Vertical__c,Asset.AOSI_Dealer_Asset__c,Asset.AOSI_Contract_Status__c,Asset.Account.Name,Asset.AOSI_Active__c,Asset.InstallDate,Asset.AOSI_Warranty_End_Date__c,Asset.Warranty_Final_End_Date_AOSI__c,Asset.AOSI_Warranty_Registered_In_Time__c,Asset.OPW_End_Date_AOSI__c,Asset.AOSI_Warranty_registration_Date__c,Asset.AOSI_Contract_Start_Date__c,Asset.AOSI_Contract_Charges__c,Asset.AOSI_Contract_End_Date__c,Asset.AOSI_Contract_Number__c,Asset.AOSI_Replaced_Asset__c,Asset.AOSI_Replacement_Date__c,Asset.AOSI_Old_Asset_Purchase_Date__c,Asset.Invoice_Date__c,Asset.AOSI_Membrane_Warranty__c,Asset.Invoice_Number__c,Asset.AOSI_Automatic_PM_Service__c,Asset.AOSI_PM_Service1_Date__c,Asset.AOSI_PM_Service4_Date__c,Asset.AOSI_PM_Service2_Date__c,Asset.AOSI_PM_Service3_Date__c ,Account.Parent.Name,Account.AOSI_Active__c,Account.AOSI_Region__c,Account.AOSI_State__c,Account.AOSI_Categories__c,Account.AOSI_Email__c,Account.Phone,Account.Other_Phone__c,Account.Customer_Code__c,Account.Website,Account.AOSI_Distributor_s_Name__c,Account.AOSI_Related_Service_Manager__r.Name,Account.AOSI_Service_Manager_Email__c,Account.AOSI_Service_Manager_Phone__c,Account.AOSI_Related_Sales_Manager__c,Account.AOSI_Sales_manager_Email__c,Account.AOSI_Sales_manager_Phone__c,Account.AOSI_Pin_Code__c,Account.ShippingPostalCode,Account.ShippingState,Account.ShippingCity,Account.ShippingStreet from Case where Service_Engineer__c =:resource.Id and Status!='Closed'];   
              }else
              {
               //String [] timestamp_datetime   
               timestamp=timestamp.replaceAll('T', ' ');
               timestamp=timestamp.replaceAll('Z', '');   
               DateTime timestamp_datetime=Datetime.valueOf(timestamp);
               cases_of_resource=[SELECT Id,Contact.AOSI_Locality__r.Id,AOSI_Replaced_Product__c,Asset.Id,Contact.AOSI_Pin_Code__r.Id,ContactId,Contact.Name,AOSIProduct__r.Id,Account.Id,AOSI_GPS_Operation_Type__c,CaseNumber,Status,Reason,Asset.Name,AOSI_Asset_Purchase_Date__c,AOSI_Asset_Status__c,AOSI_Purchase_Value__c,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Warranty_Status_I__c,WE_CARE__c,AOSI_Escalate_to_HO__c,AOSI_Call_Escalated__c,AOSI_Response_on_escalation__c,CreatedDate,Contact_Name__c,AOSI_Preferred_Color__c,Parent.CaseNumber,AOSI_Appointment_Date__c,Account.Name,AOSI_Response_on_escalation_date_time__c,AOSI_Customer_Concern__c,Courier_Number__c,AOSI_Agents_Comment__c,Description,AOSI_Work_Done__c,AOSI_Hardness__c,AOSI_Water_Source__c,AOSI_pH__c,Assignment_Start_Time__c,Assignment_End_Time__c,AOSI_TDS_Input__c,AOSI_TDS_Output__c,AOSI_Water_Storage__c , Contact.Title ,Contact.Account.Name,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet ,Contact.Phone,Contact.MobilePhone,Contact.OtherPhone,Contact.Email,Contact.AOSI_Pin_Code__r.Name,Contact.AOSI_Region__c,Contact.AOSI_Locality__r.Name,Contact.AOSI_State__c,Contact.AOSI_City_Picklist__c ,AOSIProduct__r.Name,AOSIProduct__r.ProductCode,AOSIProduct__r.IsActive,AOSIProduct__r.AOSI_Product_Code_for_Serial_Number__c,AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__r.AOSI_Family__c,AOSIProduct__r.AOSIColor__c,AOSIProduct__r.Product_Warranty_AOS_India__c,AOSIProduct__r.AOSI_Comprehensive_Warranty__c,AOSIProduct__r.AOSI_Element_Warranty__c,AOSIProduct__r.AOSI_Free_Installtion__c,AOSIProduct__r.AOSIColorPanel_Free__c,AOSIProduct__r.AOSI_Visit_Charges__c,AOSIProduct__r.AOSI_Installation_Charges__c,AOSIProduct__r.AOSI_Color_Panel_Charges__c,AOSIProduct__r.AOSI_Demounting_Charge__c,AOSIProduct__r.AOSI_Membrane_Wty__c , Asset.Product2.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Asset.AOSI_Product_Vertical__c,Asset.AOSI_Dealer_Asset__c,Asset.AOSI_Contract_Status__c,Asset.Account.Name,Asset.AOSI_Active__c,Asset.InstallDate,Asset.AOSI_Warranty_End_Date__c,Asset.Warranty_Final_End_Date_AOSI__c,Asset.AOSI_Warranty_Registered_In_Time__c,Asset.OPW_End_Date_AOSI__c,Asset.AOSI_Warranty_registration_Date__c,Asset.AOSI_Contract_Start_Date__c,Asset.AOSI_Contract_Charges__c,Asset.AOSI_Contract_End_Date__c,Asset.AOSI_Contract_Number__c,Asset.AOSI_Replaced_Asset__c,Asset.AOSI_Replacement_Date__c,Asset.AOSI_Old_Asset_Purchase_Date__c,Asset.Invoice_Date__c,Asset.AOSI_Membrane_Warranty__c,Asset.Invoice_Number__c,Asset.AOSI_Automatic_PM_Service__c,Asset.AOSI_PM_Service1_Date__c,Asset.AOSI_PM_Service4_Date__c,Asset.AOSI_PM_Service2_Date__c,Asset.AOSI_PM_Service3_Date__c ,Account.Parent.Name,Account.AOSI_Active__c,Account.AOSI_Region__c,Account.AOSI_State__c,Account.AOSI_Categories__c,Account.AOSI_Email__c,Account.Phone,Account.Other_Phone__c,Account.Customer_Code__c,Account.Website,Account.AOSI_Distributor_s_Name__c,Account.AOSI_Related_Service_Manager__r.Name,Account.AOSI_Service_Manager_Email__c,Account.AOSI_Service_Manager_Phone__c,Account.AOSI_Related_Sales_Manager__c,Account.AOSI_Sales_manager_Email__c,Account.AOSI_Sales_manager_Phone__c,Account.AOSI_Pin_Code__c,Account.ShippingPostalCode,Account.ShippingState,Account.ShippingCity,Account.ShippingStreet from Case where Service_Engineer__c =:resource.Id and Status!='Closed' and LastModifiedDate >:timestamp_datetime];  
              }
                  
              if(cases_of_resource !=null && cases_of_resource.size() >0)
              {
                //List<Case> casetobeupdated=new List<Case>();
                List<Cases> listofcases=new List<Cases>();
                Set<Id>  contactlist=new Set<Id>();
                Set<Id>  caselist=new Set<Id>();
                Set<Id>  productlist=new Set<Id>();  
                // Storing list of contacts to fetch the asset information
                for(Case obj:cases_of_resource)
                {
                    contactlist.add(obj.ContactId);
                    caselist.add(obj.Id);
                    productlist.add(obj.AOSIProduct__c);
                }

                Map<Id,List<Asset>> mapassetcon=new Map<Id,List<Asset>>();
                Map<Id,List<AOSI_Contract__c>> mapcontracts=new Map<Id,List<AOSI_Contract__c>>();
                Map<Id,List<PRR__c>> mapprr=new Map<Id,List<PRR__c>>();  
                Map<Id,List<Spare_Product_Junction__c>> mapspares=new Map<Id,List<Spare_Product_Junction__c>>();    
                Map<Id,List<Case_Customer_Concern__c>>mapcustomerconcern=new Map<Id,List<Case_Customer_Concern__c>>();  
                Map<Id,List<Service_Charges__c>>mapservicecharges=new Map<Id,List<Service_Charges__c>>();    
                //List<Spare_Product_Junction__c> spare_product_junction = [Select Id,Spares__r.Name,Spares__r.Type__c,Spares__r.Part_Code__c,Spares__r.Active__c,Spares__r.AMC_Covered__c,Spares__r.Family__c,Spares__r.Part_Type__c,Spares__r.Part_Sr_Number_Required__c,Spares__r.Chargeable_Under_Warranty__c,Spares__r.MRP__c from Spare_Product_Junction__c where Product__c =:obj.AOSIProduct__c ];                     
                for(Case service_charges:[select Id,(select id,Name,Type__c,Spares__c,Quantity__c,Case__c,Final_Charges__c,AmountMRP__c,MRP_Charges__c,Chargable__c from Service_Charges__r ) from Case where Id IN: caselist]  )
                {
                    mapservicecharges.put(service_charges.Id,service_charges.Service_Charges__r);      
                } 
                for(Case customer_concern:[select Id,(select Id,Action__c,Call_Category_Type__c,Cause__c,Customer_Concern__c,Reason__c from Customer_Conserns__r ) from Case where Id IN: caselist]  )
                {
                    mapcustomerconcern.put(customer_concern.Id,customer_concern.Customer_Conserns__r);      
                } 
				for(Contact c:[select Id,(select Id,Name,Product2.Name,PurchaseDate,AOSI_Asset_Status__c,AOSI_Product_Vertical__c,AOSI_Dealer_Asset__c,AOSI_Contract_Status__c,Account.Name,AOSI_Active__c,InstallDate,AOSI_Warranty_End_Date__c,Warranty_Final_End_Date_AOSI__c,AOSI_Warranty_Registered_In_Time__c,OPW_End_Date_AOSI__c,AOSI_Warranty_registration_Date__c,AOSI_Contract_Start_Date__c,AOSI_Contract_Charges__c,AOSI_Contract_End_Date__c,AOSI_Contract_Number__c,AOSI_Replaced_Asset__c,AOSI_Replacement_Date__c,AOSI_Old_Asset_Purchase_Date__c,Invoice_Date__c,AOSI_Membrane_Warranty__c,Invoice_Number__c,AOSI_Automatic_PM_Service__c,AOSI_PM_Service1_Date__c,AOSI_PM_Service4_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c from Assets ) from Contact where Id IN: contactlist]  )
                {
                    mapassetcon.put(c.Id,c.Assets);      
                }
                  
        		for(Case ind_case:[select Id,(Select Id,AOSI_Contract_Number__c,Name,AOSI_AMC_Pin__c,AOSI_Case_Number__c,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Contact__c,AOSI_Product_Model__c,AOSI_Asset__c,AOSI_Contract_Status__c,AOSI_Manual_OTP__c,AOSI_Manual_Base_Amount__c,AOSI_Base_Amount__c,AOSI_Discount__c,AOSI_Tax__c,AOSI_Total_Amount__c,AOSI_Amount_Received__c,AOSI_Amount_Received_Date__c,AOSI_Contract_Charges__c,AOSI_Mode_Of_Payment__c,AOSI_Reference_Number__c,AOSI_Payment_Collected_By__c,AOSI_Invoice_Number__c,AOSI_Invoice_Date__c from Contracts__r) from Case where Id IN: caselist])
                { 
                   mapcontracts.put(ind_case.Id, ind_case.Contracts__r); 
                }
                
                for(Case prr_case:[select Id,(Select AOSI_Invoice_Attached__c,AOSI_Final_Refund_Value__c,AOSI_Depreciation_Allowed__c,AOSI_Depreciation_value__c,Id,AOSI_PRR_Number__c,Request_Type__c,AOSI_Type__c,AOSI_Case__c,AOSI_Approval_Status__c,AOSI_Customer_Name__c,AOSI_Delivery_Address__c,Landmark__c,AOSI_Product__c,AOSI_Asset__c,AOSI_DOP__c,AOSI_Account__c,AOSI_DOA_Dead_On_Arrival__c,AOSI_Repeat_Failure__c,AOSI_Transit_Damaged__c,AOSI_Others__c,AOSI_Manufacture_Fault_Non_Repairable__c,AOSI_Serious_Issue_Product_Burnt__c,Tank_Failure__c,AOSI_Other_Reason__c,AOSI_Refund_Value__c,AOSI_Justification__c from PRR__r ) from Case where Id IN: caselist])
                { 
                   mapprr.put(prr_case.Id, prr_case.PRR__r); 
                }
                
                for(Product2 pro:[select Id,(Select Id,Spares__r.Name,Spares__r.Type__c,Spares__r.Part_Code__c,Spares__r.Active__c,Spares__r.AMC_Covered__c,Spares__r.Family__c,Spares__r.Part_Type__c,Spares__r.Part_Sr_Number_Required__c,Spares__r.Chargeable_Under_Warranty__c,Spares__r.MRP__c from Spare_Product_Junction__r) from Product2 where Id in:productlist])  
                {
                  mapspares.put(pro.Id,pro.Spare_Product_Junction__r );  
                } 
                for(Case obj:cases_of_resource)
                {      
                  Cases c=new Cases();
				  // Case Details
                  c.Id=obj.Id; 
                  c.Case_Number=obj.CaseNumber;
                  c.Status=obj.Status;
                  c.Case_Reason=obj.Reason;
                  c.Product=obj.AOSIProduct__r.Name+';'+obj.AOSIProduct__r.Id;
                  c.Asset=obj.Asset.Name+';'+obj.Asset.Id;
                  c.Asset_Purchase_Date=obj.AOSI_Asset_Purchase_Date__c;
                  c.Asset_Status=obj.AOSI_Asset_Status__c;
                  c.Purchase_Value=obj.AOSI_Purchase_Value__c;
                  c.Cancelled_and_On_HOLD_Reason=obj.AOSI_Cancelled_On_HOLD_Reason__c;
                  c.Warranty_Status=obj.AOSI_Warranty_Status_I__c;
                  c.WE_CARE=obj.WE_CARE__c;
                  c.Escalate_to_HO=obj.AOSI_Escalate_to_HO__c;
                  c.Call_Escalated=obj.AOSI_Call_Escalated__c;
                  c.Response_on_escalation=obj.AOSI_Response_on_escalation__c;
                  c.Date_or_Time_Opened=obj.CreatedDate;
                  c.Contact_Name=obj.Contact_Name__c;
                  c.Preferred_Color=obj.AOSI_Preferred_Color__c;
                  c.Parent_Case=obj.Parent.CaseNumber;
                  c.Appointment_Date=obj.AOSI_Appointment_Date__c;
                  c.Account_Name=obj.Account.Name+';'+obj.Account.Id;
                  c.Response_on_escalation_date_time=obj.AOSI_Response_on_escalation_date_time__c;
                  c.Customer_Concern=obj.AOSI_Customer_Concern__c;
                  c.Courier_Number=obj.Courier_Number__c;
                  c.Agent_s_Comment=obj.AOSI_Agents_Comment__c;
                  c.Description=obj.Description;
                  c.Work_Done=obj.AOSI_Work_Done__c;
                  c.Hardness=obj.AOSI_Hardness__c;
                  c.Water_Source=obj.AOSI_Water_Source__c;
                  c.Input_Pressure=obj.AOSI_pH__c;
                  c.Responded_Time=obj.Assignment_Start_Time__c;
                  c.Assignment_End_Time=obj.Assignment_End_Time__c;
                  c.TDS_Input=obj.AOSI_TDS_Input__c;
                  c.TDS_Output=obj.AOSI_TDS_Output__c;
                  c.Water_Storage=obj.AOSI_Water_Storage__c;
                  c.surverylink=getSurveyLink(obj.ContactId,obj.Id);
                  c.ProductId=obj.AOSIProduct__r.Id;
   				  c.AssetId=obj.Asset.Id;
    			  c.AccountId=obj.Account.Id; 

// Contact Details
                  ContactInfo contact=new ContactInfo();
                  contact.Id=obj.Contact.Id;  
                  contact.Title=obj.Contact.Title;
                  contact.ContactName=obj.Contact.Name;
                  contact.Account_Name=obj.Contact.Account.Name;
                  contact.Mobile_Number_1=obj.Contact.Phone;
                  contact.Mobile_Number_2=obj.Contact.MobilePhone;
                  contact.Landline_Number=obj.Contact.OtherPhone;
                  contact.Email=obj.Contact.Email;
                  
                  contact.Region=obj.Contact.AOSI_Region__c;
                  
                  contact.State=obj.Contact.AOSI_State__c;
                  contact.City=obj.Contact.AOSI_City_Picklist__c ;
                  contact.MailingPostalCode=obj.Contact.MailingPostalCode;
                  contact.MailingState=obj.Contact.MailingState;
                  contact.MailingCity=obj.Contact.MailingCity;
                  contact.MailingStreet=obj.Contact.MailingStreet ;
                    
                  
                  contact.Pin_CodeId=obj.Contact.AOSI_Pin_Code__r.Id;
                  contact.LocalityId=obj.Contact.AOSI_Locality__r.Id;  
                  contact.Pin_Code=obj.Contact.AOSI_Pin_Code__r.Name;
                  contact.Locality=obj.Contact.AOSI_Locality__r.Name;
				  
                  // Fetching the assets of the contact
				  List<ServiceCharge> json_servicecharges=new List<ServiceCharge>();
                  if(mapservicecharges.get(obj.Id)!=null && mapservicecharges.get(obj.Id).size() > 0)
                  {  
                    for(Service_Charges__c c_service_charge:mapservicecharges.get(obj.Id))
                    {
                      if(c_service_charge.Id !=null)
                      { 
                      ServiceCharge service_charge=new ServiceCharge();
                      service_charge.Id=c_service_charge.Id;     
                      service_charge.ChargeType=c_service_charge.Type__c;     
                      service_charge.Chargeable=c_service_charge.Chargable__c;     
                      service_charge.Spares=c_service_charge.Spares__c;     
                      service_charge.Quantity=c_service_charge.Quantity__c;   
                      service_charge.Charges_or_Price=c_service_charge.MRP_Charges__c; 
                      service_charge.Amount=c_service_charge.Final_Charges__c;     
                      json_servicecharges.add(service_charge);
                      }    
                    }
                    c.ServiceCharges=json_servicecharges;      
                  }else
                  {
                      List<ServiceCharge> json_servicecharges1=new List<ServiceCharge>();
                      c.ServiceCharges=json_servicecharges1;
                  }
                    
			      List<CustomerConcern> json_customer_concerns=new List<CustomerConcern>();
                  if(mapcustomerconcern.get(obj.Id)!=null && mapcustomerconcern.get(obj.Id).size() > 0)
                  {  
                    for(Case_Customer_Concern__c c_customer_concern:mapcustomerconcern.get(obj.Id))
                    {
                      if(c_customer_concern.Id !=null)
                      { 
                      CustomerConcern customer_concern=new CustomerConcern();
                      customer_concern.Id=c_customer_concern.Id;     
                      customer_concern.Action=c_customer_concern.Action__c;     
                      customer_concern.Call_Category_Type=c_customer_concern.Call_Category_Type__c;     
                      customer_concern.Cause=c_customer_concern.Cause__c;     
                      customer_concern.Customer_Concern=c_customer_concern.Customer_Concern__c;   
                      customer_concern.Reason=c_customer_concern.Reason__c;  
                      json_customer_concerns.add(customer_concern);
                      }    
                    }
                    c.CustomerConcerns=json_customer_concerns;      
                  }else
                  {
                      List<CustomerConcern> json_customer_concerns1=new List<CustomerConcern>();
                      c.CustomerConcerns=json_customer_concerns1;
                  }	 
				  List<AssetInfo> json_contact_assets=new List<AssetInfo>();
                  if(mapassetcon.get(obj.ContactId)!=null && mapassetcon.get(obj.ContactId).size() > 0)
                  {  
                    for(Asset c_asset:mapassetcon.get(obj.ContactId))
                    {
                      if(c_asset.Id !=null)
                      { 
                      
                      AssetInfo contact_asset=new AssetInfo();
                      contact_asset.Id=c_asset.Id;     
                      contact_asset.Serial_Number=c_asset.Name;
                      contact_asset.Product=c_asset.Product2.Name;
                      contact_asset.Purchase_Date=c_asset.PurchaseDate;
                      contact_asset.Asset_Status=c_asset.AOSI_Asset_Status__c;
                      contact_asset.Product_Vertical=c_asset.AOSI_Product_Vertical__c;
                      contact_asset.Dealer_Asset=c_asset.AOSI_Dealer_Asset__c;
                      contact_asset.Contract_Status=c_asset.AOSI_Contract_Status__c;
                      contact_asset.Account=c_asset.Account.Name;
                      contact_asset.Active=c_asset.AOSI_Active__c;
                      contact_asset.Install_Date=c_asset.InstallDate;
                      contact_asset.Warranty_End_Date=c_asset.AOSI_Warranty_End_Date__c;
                      contact_asset.Optional_Warranty_2=c_asset.Warranty_Final_End_Date_AOSI__c;
                      contact_asset.Warranty_Registered_In_Time=c_asset.AOSI_Warranty_Registered_In_Time__c;
                      contact_asset.Optional_Warranty_1=c_asset.OPW_End_Date_AOSI__c;
                      contact_asset.Warranty_registration_Date=c_asset.AOSI_Warranty_registration_Date__c;
                      contact_asset.Contract_Start_Date=c_asset.AOSI_Contract_Start_Date__c;
                      contact_asset.Contract_Charges=c_asset.AOSI_Contract_Charges__c;
                      contact_asset.Contract_End_Date=c_asset.AOSI_Contract_End_Date__c;
                      contact_asset.Contract_Number=c_asset.AOSI_Contract_Number__c;
                      contact_asset.Replaced_Asset=c_asset.AOSI_Replaced_Asset__c;
                      contact_asset.Replacement_Date=c_asset.AOSI_Replacement_Date__c;
                      contact_asset.Old_Asset_Purchase_Date=c_asset.AOSI_Old_Asset_Purchase_Date__c;
                      contact_asset.Invoice_Date=c_asset.Invoice_Date__c;
                      contact_asset.Membrane_Warranty=c_asset.AOSI_Membrane_Warranty__c;
                      contact_asset.Invoice_Number=c_asset.Invoice_Number__c;
                      contact_asset.Automatic_PM_Service=c_asset.AOSI_Automatic_PM_Service__c;
                      contact_asset.W_PM_Service1_Date=c_asset.AOSI_PM_Service1_Date__c;
                      contact_asset.W_PM_Service4_Date=c_asset.AOSI_PM_Service4_Date__c;
                      contact_asset.W_PM_Service2_Date=c_asset.AOSI_PM_Service2_Date__c;
                      contact_asset.W_PM_Service3_Date=c_asset.AOSI_PM_Service3_Date__c;
                      //system.debug('c_id'+obj.ContactId+'c_asset'+c_asset);       
                      json_contact_assets.add(contact_asset);
                      }    
                    }
                    contact.Assets=json_contact_assets;
                    system.debug('contact'+obj.ContactId+'json_contact_assets'+json_contact_assets);
                  }else
                  {
                      List<AssetInfo> json_contact_assets1=new List<AssetInfo>();
                      contact.Assets=json_contact_assets1;
                  }
				 ProductInfo product =new ProductInfo();
                 if(obj.AOSIProduct__r.Id!=null)
                 {
                  product.Id=obj.AOSIProduct__r.Id;  
                  product.Item_ID=obj.AOSIProduct__r.Name;
                  product.Model=obj.AOSIProduct__r.ProductCode;
                  product.Active=obj.AOSIProduct__r.IsActive;
                  product.Product_Code_for_Serial_Number=obj.AOSIProduct__r.AOSI_Product_Code_for_Serial_Number__c;
                  product.Vertical=obj.AOSIProduct__r.AOSI_Vertical__c;
                  product.India_Family=obj.AOSIProduct__r.AOSI_Family__c;
                  product.Color=obj.AOSIProduct__r.AOSIColor__c;
                  product.Tank_Warranty_India=obj.AOSIProduct__r.Product_Warranty_AOS_India__c;
                  product.Comprehensive_Warranty=obj.AOSIProduct__r.AOSI_Comprehensive_Warranty__c;
                  product.Element_Warranty=obj.AOSIProduct__r.AOSI_Element_Warranty__c;
                  product.Free_Installtion=obj.AOSIProduct__r.AOSI_Free_Installtion__c;
                  product.Color_Panel_Free=obj.AOSIProduct__r.AOSIColorPanel_Free__c;
                  product.Visit_Charges=obj.AOSIProduct__r.AOSI_Visit_Charges__c;
                  product.Installation_Charges=obj.AOSIProduct__r.AOSI_Installation_Charges__c;
                  product.Color_Panel_Charges=obj.AOSIProduct__r.AOSI_Color_Panel_Charges__c;
                  product.Demounting_Charges=obj.AOSIProduct__r.AOSI_Demounting_Charge__c;
                  product.Membrane_Wty=obj.AOSIProduct__r.AOSI_Membrane_Wty__c; 
				}
                      
                  
                  AssetInfo asset=new AssetInfo();
                  if(obj.Asset.Id !=null)
                  {  
                  asset.Id=obj.Asset.Id;  
                  asset.Serial_Number=obj.Asset.Name;
                  asset.Product=obj.Asset.Product2.Name;
                  asset.Purchase_Date=obj.Asset.PurchaseDate;
                  asset.Asset_Status=obj.Asset.AOSI_Asset_Status__c;
                  asset.Product_Vertical=obj.Asset.AOSI_Product_Vertical__c;
                  asset.Dealer_Asset=obj.Asset.AOSI_Dealer_Asset__c;
                  asset.Contract_Status=obj.Asset.AOSI_Contract_Status__c;
                  asset.Account=obj.Asset.Account.Name;
                  asset.Active=obj.Asset.AOSI_Active__c;
                  asset.Install_Date=obj.Asset.InstallDate;
                  asset.Warranty_End_Date=obj.Asset.AOSI_Warranty_End_Date__c;
                  asset.Optional_Warranty_2=obj.Asset.Warranty_Final_End_Date_AOSI__c;
                  asset.Warranty_Registered_In_Time=obj.Asset.AOSI_Warranty_Registered_In_Time__c;
                  asset.Optional_Warranty_1=obj.Asset.OPW_End_Date_AOSI__c;
                  asset.Warranty_registration_Date=obj.Asset.AOSI_Warranty_registration_Date__c;
                  asset.Contract_Start_Date=obj.Asset.AOSI_Contract_Start_Date__c;
                  asset.Contract_Charges=obj.Asset.AOSI_Contract_Charges__c;
                  asset.Contract_End_Date=obj.Asset.AOSI_Contract_End_Date__c;
                  asset.Contract_Number=obj.Asset.AOSI_Contract_Number__c;
                  asset.Replaced_Asset=obj.Asset.AOSI_Replaced_Asset__c;
                  asset.Replacement_Date=obj.Asset.AOSI_Replacement_Date__c;
                  asset.Old_Asset_Purchase_Date=obj.Asset.AOSI_Old_Asset_Purchase_Date__c;
                  asset.Invoice_Date=obj.Asset.Invoice_Date__c;
                  asset.Membrane_Warranty=obj.Asset.AOSI_Membrane_Warranty__c;
                  asset.Invoice_Number=obj.Asset.Invoice_Number__c;
                  asset.Automatic_PM_Service=obj.Asset.AOSI_Automatic_PM_Service__c;
                  asset.W_PM_Service1_Date=obj.Asset.AOSI_PM_Service1_Date__c;
                  asset.W_PM_Service4_Date=obj.Asset.AOSI_PM_Service4_Date__c;
                  asset.W_PM_Service2_Date=obj.Asset.AOSI_PM_Service2_Date__c;
                  asset.W_PM_Service3_Date=obj.Asset.AOSI_PM_Service3_Date__c;
                  }

                  AccountInfo account=new AccountInfo();
                  account.Id = obj.Account.Id;  
                  account.Account_Name = obj.Account.Name;
                  account.Parent_Account=obj.Account.Parent.Name;
                  account.Active=obj.Account.AOSI_Active__c;
                  account.Region=obj.Account.AOSI_Region__c;
                  account.State=obj.Account.AOSI_State__c;
                  account.Categories=obj.Account.AOSI_Categories__c;
                  account.Email=obj.Account.AOSI_Email__c;
                  account.Phone=obj.Account.Phone;
                  account.Other_Phone=obj.Account.Other_Phone__c;
                  account.Customer_Code=obj.Account.Customer_Code__c;
                  account.Website=obj.Account.Website;
                  account.Distributor_Name=obj.Account.AOSI_Distributor_s_Name__c;
                  account.Related_Service_Manager=obj.Account.AOSI_Related_Service_Manager__r.Name;
                  account.Service_Manager_Email=obj.Account.AOSI_Service_Manager_Email__c;
                  account.Service_Manager_Phone=obj.Account.AOSI_Service_Manager_Phone__c;
                  account.Related_Sales_Manager=obj.Account.AOSI_Related_Sales_Manager__c;
                  account.Sales_manager_Email=obj.Account.AOSI_Sales_manager_Email__c;
                  account.Sales_manager_Phone=obj.Account.AOSI_Sales_manager_Phone__c;
                  account.Pin_Code=obj.Account.AOSI_Pin_Code__c;
                  account.ShippingPostalCode=obj.Account.ShippingPostalCode;
                  account.ShippingState=obj.Account.ShippingState;
                  account.ShippingCity=obj.Account.ShippingCity;
                  account.ShippingStreet=obj.Account.ShippingStreet;
                  if(obj.AOSIProduct__r.Id !=null)
                  {
                      c.ProductDetails=product;
                  }
                  
                  c.ContactDetails=contact;
                  if(obj.Asset.Id  !=null)
                  {
                  c.AssetDetails=asset;    
                  }
                  
                  c.AccountDetails=account;
                  List<AOSI_Contract__c> listofcontracts =null; 
                  if(mapcontracts.get(obj.Id)!=null)  
                  //if(listofcontracts != null)
                  {
                    List<ContractInfo> for_json_listofcontracts=  new List<ContractInfo>();     
                    for(AOSI_Contract__c con:mapcontracts.get(obj.Id))
                    {
                      ContractInfo obj_con_info=new ContractInfo();
                      obj_con_info.Id=con.Id;
                      obj_con_info.Contract_Number=con.AOSI_Contract_Number__c;
                      obj_con_info.Contract_Key=con.Name;
                      
                      obj_con_info.AMC=con.AOSI_AMC_Pin__c;
                      obj_con_info.CaseNumber=con.AOSI_Case_Number__c;
                      obj_con_info.Start_Date=con.AOSI_Start_Date__c;
                      obj_con_info.End_Date=con.AOSI_End_Date__c;
                      obj_con_info.Contact=con.AOSI_Contact__c;
                      obj_con_info.Product_Model=con.AOSI_Product_Model__c;
                      obj_con_info.Asset=con.AOSI_Asset__c;
                      obj_con_info.Contract_Status=con.AOSI_Contract_Status__c;
                      obj_con_info.OTP=con.AOSI_Manual_OTP__c;
                      obj_con_info.Received_base_amount=con.AOSI_Manual_Base_Amount__c;
                      obj_con_info.Base_Amount=con.AOSI_Base_Amount__c;
                      obj_con_info.Discount=con.AOSI_Discount__c;
                      obj_con_info.Tax=con.AOSI_Tax__c;
                      obj_con_info.Total_Amount=con.AOSI_Total_Amount__c;
                      obj_con_info.Amount_Received=con.AOSI_Amount_Received__c;
                      obj_con_info.Amount_Received_Date=con.AOSI_Amount_Received_Date__c;
                      obj_con_info.Contract_Charges=con.AOSI_Contract_Charges__c;
                      obj_con_info.Mode_of_Payment=con.AOSI_Mode_Of_Payment__c;
                      obj_con_info.Reference_Number=con.AOSI_Reference_Number__c;
                      obj_con_info.Payment_Collected_By=con.AOSI_Payment_Collected_By__c;
                      obj_con_info.Invoice_Number=con.AOSI_Invoice_Number__c;
                      obj_con_info.Invoice_Date=con.AOSI_Invoice_Date__c;
                      for_json_listofcontracts.add(obj_con_info);      
                    }
                    c.ContractDetails=for_json_listofcontracts ;
                  }
                  

                  if(mapprr.get(obj.Id)!= null)
                  {
                    List<PRRInfo> json_prrinfo=new List<PRRInfo>();  
                    for(PRR__c prr:mapprr.get(obj.Id))
                    {
                      PRRInfo prrinfo=new PRRInfo();
                      prrinfo.Id=prr.Id;  
                      prrinfo.PRR_Number=prr.AOSI_PRR_Number__c;
                      prrinfo.Request_Type=prr.Request_Type__c;
                      prrinfo.PRRType=prr.AOSI_Type__c;
                      prrinfo.CaseNumber=prr.AOSI_Case__c;
                      prrinfo.Approval_Status=prr.AOSI_Approval_Status__c;
                      prrinfo.Customer_Name=prr.AOSI_Customer_Name__c;
                      prrinfo.Delivery_Address=prr.AOSI_Delivery_Address__c;
                      prrinfo.Landmark=prr.Landmark__c;
                      prrinfo.Product=prr.AOSI_Product__c;
                      prrinfo.Asset=prr.AOSI_Asset__c;
                      prrinfo.DOP=prr.AOSI_DOP__c;
                      prrinfo.Account=prr.AOSI_Account__c;
                      prrinfo.DOA_Dead_On_Arrival=prr.AOSI_DOA_Dead_On_Arrival__c;
                      prrinfo.Repeat_Failure=prr.AOSI_Repeat_Failure__c;
                      prrinfo.Transit_Damaged=prr.AOSI_Transit_Damaged__c;
                      prrinfo.Others=prr.AOSI_Others__c;
                      prrinfo.Manufacture_Fault_Non_Repairable=prr.AOSI_Manufacture_Fault_Non_Repairable__c;
                      prrinfo.Serious_Issue_Critical_Issue=prr.AOSI_Serious_Issue_Product_Burnt__c;
                      prrinfo.Tank_Failure=prr.Tank_Failure__c;
                      prrinfo.Other_Reason=prr.AOSI_Other_Reason__c;
                      prrinfo.Refund_Value=prr.AOSI_Refund_Value__c;
                      prrinfo.Justification=prr.AOSI_Justification__c; 
					  prrinfo.Depreciation_Allowed=prr.AOSI_Depreciation_Allowed__c;
                      if(prr.AOSI_Depreciation_value__c!=null)
                      {
                       prrinfo.Depreciation_Value=prr.AOSI_Depreciation_value__c;
                      }
                      else
                      {
                         prrinfo.Depreciation_Value=0; 
                      }
    				  
    				  prrinfo.Final_Refund_Value=prr.AOSI_Final_Refund_Value__c;
    				  prrinfo.Invoice_Attached=prr.AOSI_Invoice_Attached__c;	                        
                      json_prrinfo.add(prrinfo);       
                    }
                    c.PRRDetails=json_prrinfo;
                  }
                  //List<Spare_Product_Junction__c> spare_product_junction = [Select Id,Spares__r.Name,Spares__r.Type__c,Spares__r.Part_Code__c,Spares__r.Active__c,Spares__r.AMC_Covered__c,Spares__r.Family__c,Spares__r.Part_Type__c,Spares__r.Part_Sr_Number_Required__c,Spares__r.Chargeable_Under_Warranty__c,Spares__r.MRP__c from Spare_Product_Junction__c where Product__c =:obj.AOSIProduct__c ];                   
                  if(mapspares.get(obj.AOSIProduct__c) !=null)
                  {
                    List<SpareInfo> spareinfojson=new List<SpareInfo>();
                    for(Spare_Product_Junction__c sp:mapspares.get(obj.AOSIProduct__c))
                    {
                      SpareInfo spareinfo=new SpareInfo();
                      spareinfo.Id=sp.Spares__r.Id;  
                      spareinfo.Part_Description=sp.Spares__r.Name;
                      spareinfo.Type=sp.Spares__r.Type__c;
                      spareinfo.Part_Code=sp.Spares__r.Part_Code__c;
                      spareinfo.Active=sp.Spares__r.Active__c;
                      spareinfo.AMC_Covered=sp.Spares__r.AMC_Covered__c;
                      spareinfo.Family=sp.Spares__r.Family__c;
                      spareinfo.Part_Clasification=sp.Spares__r.Part_Type__c;
                      spareinfo.Part_Sr_Number_Required=sp.Spares__r.Part_Sr_Number_Required__c;
                      spareinfo.Chargeable_Under_Warrenty=sp.Spares__r.Chargeable_Under_Warranty__c;
                      spareinfo.MRP=sp.Spares__r.MRP__c ;  
                      spareinfojson.add(spareinfo);
                    }
                    c.SpareDetails=spareinfojson;
                  }
                  
                  listofcases.add(c);
                }
                //data.status='Success';
                data.cases= listofcases; 
                //data.message='Cases Available';
                data.message=AOSI_GPS_MessageHandler.getMessage('15').get(0);
            	data.status=AOSI_GPS_MessageHandler.getMessage('15').get(1);                    
              }else
              {
                
                //data.status='Failure';
                //data.message='No cases found';
                data.message=AOSI_GPS_MessageHandler.getMessage('9').get(0);
            data.status=AOSI_GPS_MessageHandler.getMessage('9').get(1);      
              }
            }    
          }
          else
          {
            
            data.message=AOSI_GPS_MessageHandler.getMessage('1').get(0);
          data.status=AOSI_GPS_MessageHandler.getMessage('1').get(1);
          }
        }
        else
        {
          data.message=AOSI_GPS_MessageHandler.getMessage('10').get(0);
          data.status=AOSI_GPS_MessageHandler.getMessage('10').get(1);
          //data.status='Failure';
          //data.message='Information insufficient to fetch details';
        }


      }
      else
      {
        //data.status='Failure';
        //data.message='Request body not set';
        data.message=AOSI_GPS_MessageHandler.getMessage('11').get(0);
        data.status=AOSI_GPS_MessageHandler.getMessage('11').get(1);  
      }

    }catch(Exception ex)
    {
      data.status='Failure';
      data.message='Critical Error : '+ex.getMessage();
      System.debug('Exception'+ex);
      

    }
    //system.debug('data'+data);  
    //return JSON.serializePretty(data);
    string json_data = json.serialize(data);
	RestContext.response.addHeader('Content-Type', 'application/json');
	RestContext.response.responseBody = Blob.valueOf(json_data);   
  }
    
  private static String getSurveyLink(String contactId,String caseId)
  {
  
    CCTSettings__c settings=CCTSettings__c.getValues('Default');
    return settings.Feedback_URL__c+''+contactId+'&case_id='+caseId+'&wf=yes';  
  }
  
  class Cases
  {
    String Id;
    String ProductId;
    String AssetId;
    String AccountId;  
    String Case_Number;
    String Status;
    String Case_Reason;
    String Product;
    String Asset;
    Date Asset_Purchase_Date;
    String Asset_Status;
    Decimal Purchase_Value;
    String Cancelled_and_On_HOLD_Reason;
    String Warranty_Status;
    Boolean WE_CARE;
    Boolean Escalate_to_HO;
    Boolean Call_Escalated;
    Boolean Response_on_escalation;
    DateTime Date_or_Time_Opened;
    String Contact_Name;
    String Preferred_Color;
    String Parent_Case;
    DateTime Appointment_Date;
    String Account_Name;
    DateTime Response_on_escalation_date_time;
    String Customer_Concern;
    String Courier_Number;
    String Agent_s_Comment;
    String Description;
    String Work_Done;
    String Hardness;
    String Water_Source;
    String Input_Pressure;
    DateTime Responded_Time;
    DateTime Assignment_End_Time;
    String TDS_Input;
    String TDS_Output;
    String Water_Storage;
    String Operation;
    String surverylink;
    String Replaced_Product;
    String Refund_Value;
    String GIN_Number;
    String Replaced_Asset;
    DateTime Refund_Date;
    DateTime GIN_Date;
    String Discount;
    String Mode_of_Payment;  
    DateTime Cash_Receipt_Date;  
    String Bank_and_Branch_Details;
    String Cheque_Number;
    String Cash_Recipt;
    String Total_Charges;  
    ContactInfo ContactDetails;
    ProductInfo ProductDetails;
    AssetInfo AssetDetails;
    AccountInfo AccountDetails;
    List<ContractInfo> ContractDetails;
    List<PRRInfo> PRRDetails;
    List<SpareInfo> SpareDetails; 
    List<CustomerConcern> CustomerConcerns;
    List<ServiceCharge> ServiceCharges;  
  }

  class ContactInfo
  {
    String Id;  
    String Title;
    String ContactName;
    String Account_Name;
    String Mobile_Number_1;
    String Mobile_Number_2;
    String Landline_Number;
    String Email;
    String Pin_Code;
    String Region;
    String Locality;
    String State;
    String City;
    String MailingPostalCode;
    String MailingState;
    String MailingCity;
    String MailingStreet;
	String Pin_CodeId;
    String LocalityId;  
    List<AssetInfo> Assets;


  }

  class ProductInfo
  {
    String Id;  
    String Item_ID;
    String Model;
    Boolean Active;
    String Product_Code_for_Serial_Number;
    String Vertical;
    String India_Family;
    String Color;
    Decimal Tank_Warranty_India;
    Decimal Comprehensive_Warranty;
    Decimal Element_Warranty;
    String Free_Installtion;
    String Color_Panel_Free;
    Decimal Visit_Charges;
    Decimal Installation_Charges;
    Decimal Color_Panel_Charges;
    Decimal Demounting_Charges;
    String Membrane_Wty;

  }  

  class AssetInfo
  {
    String Id;  
    String Serial_Number;
    String Product;
    Date Purchase_Date;
    String Asset_Status;
    String Product_Vertical;
    Boolean Dealer_Asset;
    String Contract_Status;
    String Account;
    Boolean Active;
    Date Install_Date;
    Date Warranty_End_Date;
    Date Optional_Warranty_2;
    String Warranty_Registered_In_Time;
    Date Optional_Warranty_1;
    Date Warranty_registration_Date;
    Date Contract_Start_Date;
    Decimal Contract_Charges;
    Date Contract_End_Date;
    String Contract_Number;
    String Replaced_Asset;
    Date Replacement_Date;
    Date Old_Asset_Purchase_Date;
    Date Invoice_Date;
    String Membrane_Warranty;
    String Invoice_Number;
    String Automatic_PM_Service;
    Date W_PM_Service1_Date;
    Date W_PM_Service4_Date;
    Date W_PM_Service2_Date;
    Date W_PM_Service3_Date;       
  }


  class AccountInfo
  {
    String Id;  
    String Account_Name;
    String Parent_Account;
    Boolean Active;
    String Region;
    String State;
    String Categories;
    String Email;
    String Phone;
    String Other_Phone;
    String Customer_Code;
    String Website;
    String Distributor_Name;
    String Related_Service_Manager;
    String Service_Manager_Email;
    String Service_Manager_Phone;
    String Related_Sales_Manager;
    String Sales_manager_Email;
    String Sales_manager_Phone;
    String Pin_Code;
    String ShippingPostalCode;
    String ShippingState;
    String ShippingCity;
    String ShippingStreet;
  }

  class ContractInfo
  {
    String Id;  
    String Contract_Number;
    String Contract_Key;
    String AMC;
    String CaseNumber;
    Date Start_Date;
    Date End_Date;
    String Contact;
    String Product_Model;
    String Asset;
    String Contract_Status;
    String OTP;
    Decimal Received_base_amount;
    Decimal Base_Amount;
    Decimal Discount;
    Decimal Tax;
    Decimal Total_Amount;
    Boolean Amount_Received;
    Date Amount_Received_Date;
    Decimal Contract_Charges;
    String Mode_of_Payment;
    String Reference_Number;
    String Payment_Collected_By;
    String Invoice_Number;
    date Invoice_Date;
  }

  class PRRInfo
  {
    String Id;  
    String PRR_Number;
    String Request_Type;
    String PRRType;
    String CaseNumber;
    String Approval_Status;
    String Customer_Name;
    String Delivery_Address;
    String Landmark;
    String Product;
    String Asset;
    Date DOP;
    String Account;
    Boolean DOA_Dead_On_Arrival;
    Boolean Repeat_Failure;
    Boolean Transit_Damaged;
    Boolean Others;
    Boolean Manufacture_Fault_Non_Repairable;
    Boolean Serious_Issue_Critical_Issue;
    Boolean Tank_Failure;
    String Other_Reason;
    Decimal Refund_Value;
    String Justification;
    Boolean Depreciation_Allowed;
    Decimal Depreciation_Value;
    Decimal Final_Refund_Value;
    Boolean Invoice_Attached;
      
  }

  class SpareInfo
  {
    String Id;  
    String Part_Description;
    String Type;
    String Part_Code;
    Boolean Active;
    String AMC_Covered;
    String Family;
    String Part_Clasification;
    String Part_Sr_Number_Required;
    Boolean Chargeable_Under_Warrenty;
    Decimal MRP;    
  }
  
  Class ResourceDetails
  {
    String Id;
    String ResourceName;
    String MobileNumber;
    String IMEI;
    Boolean redirecttochangepassword;  
    Decimal TotalClosedCases;
    Decimal TotalRevenue;
  }    

  class Data
  {
    String Status;
    String Message;
    DateTime TimeStamp;
    List<Cases> Cases;
    ResourceDetails ResourceDetails;
  }
  
  class CustomerConcern 
  {
      String Id;
      String Customer_Concern;
      String Cause;
      String Reason;
      String Action;
      String Call_Category_Type;
  }
    
  class ServiceCharge
  {
      String Id;
      String ChargeType;
      String Chargeable;
      String Spares;
      Decimal Quantity;
      Decimal Charges_or_Price;
      Decimal Amount;
  }
  
  
  

}