/*
Created By : Rajesh Kumar.
Created Date : 
Last Modified By: Dheeraj Gangulli.
Last Modified Date: 27/04/2016.
Recently Modified/Added Contents:
									1. insertion of new Customer concern and service charges records into salesforce from mobile device.
									2. deletion of Customer concern and service charge records from Salesforce which are not in mobile devices.
									3. added timestamp and resources fields to the sc, cc, prr etc objects.
									4. seperated contact's full name into first name and last name.
*/
@RestResource(urlMapping='/updatecase/*')
global class AOSI_GPS_CaseUpdater {

  @HttpPost
  global static void updateCase()
  {
    RestRequest request=RestContext.request;
    String requestjson=request.params.get('cases');
    Data dataa=(Data)json.deserialize(requestjson, Data.class);
    List<Case> casetobeupdated=new List<Case>();
    List<Contact> contacttobeupdated=new List<Contact>();
    List<Asset> assettobeupdated=new List<Asset>();
    List<AOSI_Contract__c> contracttobeupdated=new List<AOSI_Contract__c>();
    List<PRR__c> prrtobeupdated=new List<PRR__c>();
    List<Case_Customer_Concern__c> customerconcerntobeupdated=new List<Case_Customer_Concern__c>();
    List<Service_Charges__c> servicechargestobeupdated=new List<Service_Charges__c>();
    List<Case_Customer_Concern__c> deleteCustConcernList = new List<Case_Customer_Concern__c>();
    List<Service_Charges__c> deleteServiceChargeList = new List<Service_Charges__c>();
    List<Case_Customer_Concern__c> newCustConcernList = new List<Case_Customer_Concern__c>();
    List<Service_Charges__c> newerviceChargeList = new List<Service_Charges__c>();
    Set<Id> allIdSet = new Set<Id>();
    Set<Id> caseIdSet = new Set<Id>();
      
    for(Cases c:dataa.Cases)
    {
      if(c.Id !=null)
      {

        Case mycase=new Case();
        mycase.Id=c.Id;
        mycase.AOSI_GPS_TimeStamp__c = DateTime.valueOf(dataa.TimeStamp);
        mycase.Service_Engineer__c =dataa.ResourceId;
        mycase.Status=c.Status;
		mycase.AOSIProduct__c=c.ProductId;
		mycase.AssetId=c.AssetId;
        mycase.AOSI_Purchase_Value__c=c.Purchase_Value;
        mycase.AOSI_Cancelled_On_HOLD_Reason__c=c.Cancelled_and_On_HOLD_Reason;
        mycase.AOSI_Call_Escalated__c=c.Call_Escalated;
        mycase.AOSI_Response_on_escalation__c=c.Response_on_escalation;
        mycase.AOSI_Preferred_Color__c=c.Preferred_Color;
        mycase.AOSI_Appointment_Date__c=c.Appointment_Date;
		mycase.AccountId=c.AccountId;
        mycase.AOSI_Response_on_escalation_date_time__c=c.Response_on_escalation_date_time;
        mycase.AOSI_Customer_Concern__c=c.Customer_Concern;
        mycase.Courier_Number__c=c.Courier_Number;
        mycase.AOSI_Work_Done__c=c.Work_Done;
        mycase.AOSI_Hardness__c=c.Hardness;
        mycase.AOSI_Water_Source__c= c.Water_Source;
        mycase.AOSI_pH__c=c.Input_Pressure;
        mycase.AOSI_TDS_Input__c= c.TDS_Input;
        mycase.AOSI_TDS_Output__c=c.TDS_Output;
        mycase.AOSI_Water_Storage__c=c.Water_Storage;     
        casetobeupdated.add(mycase);
        caseIdSet.add(c.Id);
      } 
        
      if(c.CustomerConcerns !=null)
      {
       for(CustomerConcern customer_concern:c.CustomerConcerns)
       {
           Case_Customer_Concern__c c_customer_concern=new Case_Customer_Concern__c();
           c_customer_concern.Action__c= customer_concern.Action;     
           c_customer_concern.Call_Category_Type__c=customer_concern.Call_Category_Type;     
           c_customer_concern.Cause__c=customer_concern.Cause;     
           c_customer_concern.Customer_Concern__c=customer_concern.Customer_Concern;   
           c_customer_concern.Reason__c=customer_concern.Reason;
           c_customer_concern.AOSI_GPS_TimeStamp__c   = DateTime.valueOf(dataa.TimeStamp);
           c_customer_concern.AOSI_GPS_Resource__c =dataa.ResourceId;             
           c_customer_concern.AOSI_GPS_MobileId__c=customer_concern.AppId;
           if(customer_concern.Id == null){               
               newCustConcernList.add(c_customer_concern);
               
           }else{
               c_customer_concern.Id=customer_concern.Id;
               customerconcerntobeupdated.add(c_customer_concern); 
           }          
       } 

      }
    
      if(c.ServiceCharges !=null)
      {
          for(ServiceCharge service_charge:c.ServiceCharges)
          {
             Service_Charges__c c_service_charge=new Service_Charges__c();
                 
             c_service_charge.Type__c=service_charge.ChargeType;     
             c_service_charge.Chargable__c=service_charge.Chargeable;     
             c_service_charge.Spares__c=service_charge.Spares;     
             c_service_charge.Quantity__c=service_charge.Quantity;   
             c_service_charge.AOSI_GPS_TimeStamp__c   = DateTime.valueOf(dataa.TimeStamp);
             c_service_charge.AOSI_GPS_Resource__c =dataa.ResourceId;    
             c_service_charge.AOSI_GPS_MobileId__c=service_charge.AppId;
              if(service_charge.Id == null){ 
                  newerviceChargeList.add(c_service_charge);
              }else{
                  c_service_charge.Id=service_charge.Id;
                  servicechargestobeupdated.add(c_service_charge); 
              }
             //c_service_charge.MRP_Charges__c=service_charge.Charges_or_Price; 
             //c_service_charge.Final_Charges__c=service_charge.Amount;  
          }
      }
        
      if(c.ContactDetails !=null)
      {
        Contact contact=new Contact(Id=c.ContactDetails.Id);
        contact.Title= c.ContactDetails.Title;
        contact.Phone=c.ContactDetails.Mobile_Number_1;
        contact.MobilePhone=c.ContactDetails.Mobile_Number_2;
        contact.OtherPhone=c.ContactDetails.Landline_Number;
        contact.Email=c.ContactDetails.Email;
        contact.MailingPostalCode=c.ContactDetails.MailingPostalCode;
        contact.MailingState=c.ContactDetails.MailingState;
        contact.MailingCity=c.ContactDetails.MailingCity;
        contact.MailingStreet =c.ContactDetails.MailingStreet;
        contact.AOSI_GPS_TimeStamp__c   = DateTime.valueOf(dataa.TimeStamp);
        contact.AOSI_GPS_Resource__c =dataa.ResourceId;
        //Add pincode and locality  (Not required, as the pin master and locality master is not loaded in the mobile)
        //contact.AOSI_Pin_Code__c = c.ContactDetails.Pin_CodeId;
        //contact.AOSI_Locality__c = c.ContactDetails.LocalityId;  
        String[] namesplit=c.ContactDetails.ContactName.split(' ');
        system.debug('namesplit'+namesplit);  
        if(namesplit.size() < 2)
        {
        contact.LastName =c.ContactDetails.ContactName;
        contact.FirstName ='';     
        }
        else
        {
        contact.FirstName=namesplit[0];    
        contact.LastName =namesplit[1];          
        }
        
        
		//Attempt to dereference error, need to check//contact.AccountName=c.ContactDetails.Account_Name;
		//Attempt to dereference error, need to check//contact.AOSI_Locality__r.Name=c.ContactDetails.Locality;
		//Attempt to dereference error, need to check//contact.AOSI_Pin_Code__r.Name=c.ContactDetails.Pin_Code; 
		 
        contacttobeupdated.add(contact);
      }

      if(c.AssetDetails !=null)
      {
        Asset asset=new Asset(Id=c.AssetDetails.Id); 
        asset.Name=c.AssetDetails.Serial_Number;
        asset.PurchaseDate=c.AssetDetails.Purchase_Date;
        asset.AOSI_Dealer_Asset__c=  c.AssetDetails.Dealer_Asset;
        asset.InstallDate=c.AssetDetails.Install_Date;
        asset.AOSI_Replaced_Asset__c=c.AssetDetails.Replaced_Asset;
        asset.AOSI_Replacement_Date__c=c.AssetDetails.Replacement_Date;
        asset.AOSI_Old_Asset_Purchase_Date__c=c.AssetDetails.Old_Asset_Purchase_Date;
        asset.Invoice_Date__c=c.AssetDetails.Invoice_Date;
        asset.Invoice_Number__c=c.AssetDetails.Invoice_Number;        
        asset.AOSI_GPS_TimeStamp__c   = DateTime.valueOf(dataa.TimeStamp);
        asset.AOSI_GPS_Resource__c =dataa.ResourceId; 
        //asset.Account.Name=c.AssetDetails.Account;
        //asset.Product2.Name=c.AssetDetails.Product;  
        assettobeupdated.add(asset);
      }

      if(c.ContractDetails!=null)
      {
        List<ContractInfo> listofcontracts=c.ContractDetails;
        for(ContractInfo obj_con_info:listofcontracts)
        {
          AOSI_Contract__c contract=new AOSI_Contract__c(Id=obj_con_info.Id);
          contract.AOSI_Start_Date__c=obj_con_info.Start_Date; 
          contract.AOSI_Manual_OTP__c=obj_con_info.OTP;      
          contract.AOSI_Manual_Base_Amount__c=obj_con_info.Received_base_amount;
          contract.AOSI_Discount__c=obj_con_info.Discount;
          contract.AOSI_Amount_Received__c=obj_con_info.Amount_Received;
          contract.AOSI_Amount_Received_Date__c=obj_con_info.Amount_Received_Date;
          contract.AOSI_Mode_Of_Payment__c=obj_con_info.Mode_of_Payment;
          contract.AOSI_Reference_Number__c=obj_con_info.Reference_Number;
          contract.AOSI_Payment_Collected_By__c=obj_con_info.Payment_Collected_By;
          contract.AOSI_Invoice_Number__c=obj_con_info.Invoice_Number; 
          contract.AOSI_Invoice_Date__c=obj_con_info.Invoice_Date; 
          contract.AOSI_GPS_TimeStamp__c   = DateTime.valueOf(dataa.TimeStamp);
          contract.AOSI_GPS_Resource__c =dataa.ResourceId;  
          //contract.AOSI_End_Date__c=obj_con_info.End_Date; // Field is not writable  
          contracttobeupdated.add(contract);                    
        }
      }

      if(c.PRRDetails!=null)
      {
        List<PRRInfo> listofprr=c.PRRDetails;
        for(PRRInfo obj_prr_info:listofprr)
        {
          PRR__c prr=new PRR__c(Id=obj_prr_info.Id);   
          //prr.AOSI_PRR_Number__c=obj_prr_info.PRR_Number;
          prr.AOSI_Type__c=obj_prr_info.PRRType;
          prr.AOSI_Case__c=obj_prr_info.CaseNumber;
          //prr.AOSI_Approval_Status__c=obj_prr_info.Approval_Status;
          prr.AOSI_Product__c=obj_prr_info.Product;
          prr.AOSI_Asset__c=obj_prr_info.Asset;
          //prr.AOSI_Account__c=obj_prr_info.Account;
          prr.AOSI_DOA_Dead_On_Arrival__c=obj_prr_info.DOA_Dead_On_Arrival;
          prr.AOSI_Repeat_Failure__c=obj_prr_info.Repeat_Failure;
          prr.AOSI_Transit_Damaged__c=obj_prr_info.Transit_Damaged;
          prr.AOSI_Others__c=obj_prr_info.Others;
          prr.AOSI_Manufacture_Fault_Non_Repairable__c=obj_prr_info.Manufacture_Fault_Non_Repairable;
          prr.AOSI_Serious_Issue_Product_Burnt__c=obj_prr_info.Serious_Issue_Critical_Issue;
          prr.Tank_Failure__c=obj_prr_info.Tank_Failure;
          prr.AOSI_Other_Reason__c=obj_prr_info.Other_Reason;
          prr.AOSI_Refund_Value__c=obj_prr_info.Refund_Value;
          prr.AOSI_Justification__c=obj_prr_info.Justification;
          if(obj_prr_info.Depreciation_Allowed ==true)
          {
          prr.AOSI_Depreciation_Allowed__c=obj_prr_info.Depreciation_Allowed;
          prr.AOSI_Depreciation_value__c=obj_prr_info.Depreciation_Value;    
          }
          prr.AOSI_Invoice_Attached__c=obj_prr_info.Invoice_Attached;
   		  prr.AOSI_GPS_TimeStamp__c   = DateTime.valueOf(dataa.TimeStamp);
          prr.AOSI_GPS_Resource__c =dataa.ResourceId;
          /******************Fields Not Writable
			//prr.AOSI_DOP__c=obj_prr_info.DOP; 
			//prr.Request_Type__c=obj_prr_info.Request_Type; //Not writable         
		  *************************************/
          prrtobeupdated.add(prr);                    
        }

      }
    }
    Response response=new Response();
    if(servicechargestobeupdated.size() > 0 || customerconcerntobeupdated.size()>0 || prrtobeupdated.size() > 0 || casetobeupdated.size() > 0 || contacttobeupdated.size() >0 ||contracttobeupdated.size() > 0 || assettobeupdated.size() > 0 )
    {
      List<SObject> allobjectstobeupdated=new List<SObject>();
      if(prrtobeupdated.size() > 0)
      {
        allobjectstobeupdated.addAll((List<SObject>)prrtobeupdated);     
      }
      if(casetobeupdated.size() > 0)
      {
        allobjectstobeupdated.addAll((List<SObject>)casetobeupdated);    
      }
      if(contacttobeupdated.size() > 0)
      {
        allobjectstobeupdated.addAll((List<SObject>)contacttobeupdated);
      }
      if(contracttobeupdated.size() >0)
      {
        allobjectstobeupdated.addAll((List<SObject>)contracttobeupdated);
      }
      if(assettobeupdated.size() > 0)
      {
        allobjectstobeupdated.addAll((List<SObject>)assettobeupdated);
      }
      
      if(customerconcerntobeupdated.size() > 0)
      {
        allobjectstobeupdated.addAll((List<SObject>)customerconcerntobeupdated);
      }
      if(servicechargestobeupdated.size() > 0)
      {
        allobjectstobeupdated.addAll((List<SObject>)servicechargestobeupdated);
      }
      

      	List<Database.SaveResult> srList=Database.update(allobjectstobeupdated,false);
      
        for(Database.SaveResult result:srList) {
            allIdSet.add(result.getId());
        }
        List<SObject> allobjectstobeinserted=new List<SObject>();
        
        if(newCustConcernList.size()>0){
            allobjectstobeinserted.addAll((List<SObject>)newCustConcernList);
        }
        if(newerviceChargeList.size()>0){
            allobjectstobeinserted.addAll((List<SObject>)newerviceChargeList);
        }
        List<Database.SaveResult> srInsertList=Database.insert(allobjectstobeinserted,false);
        
        for(Database.SaveResult result:srInsertList) {
            allIdSet.add(result.getId());
        }
        
        //finding the records which are not present in mobile device and present in salesforce, then deleting it 
        for(Service_Charges__c sc: [SELECT ID FROM Service_Charges__c WHERE Case__c IN: caseIdSet AND Id NOT IN: allIdSet ]){
            deleteServiceChargeList.add(sc);
        }
        
        for(Case_Customer_Concern__c cc: [SELECT ID FROM Case_Customer_Concern__c WHERE Case__c IN: caseIdSet AND Id NOT IN: allIdSet ]){
            deleteCustConcernList.add(cc);
        }
       
      //deleting the customer concerns which are not in the mobile device  
      if(deleteCustConcernList.size()>0){
          delete deleteCustConcernList;
      }
      //deleting the service charges which are not in the mobile device 
      if(deleteServiceChargeList.size()>0){
          delete deleteServiceChargeList;
      }
      List<Result> resultlist=new List<Result>();
		
       
        for (Integer i=0;i<allobjectstobeinserted.size();i++) {
            Result result=new Result();
            result.Id=allobjectstobeinserted[i].Id;
            result.ObjectName=allobjectstobeinserted[i].getSobjectType().getDescribe().getName();
            if (srList[i].isSuccess()) {                
              result.Status='Success';
            }
            else {
              result.Status='Failure';
              List<Error> errors=new List<Error>();
              for(Database.Error err : srList[i].getErrors()) {
                Error error=new Error();
                error.message=err.getMessage();
                errors.add(error);
              }
              result.errors=errors;
            }
            resultlist.add(result);
      }
        /*************************************************************************************************************************/
      for (Integer i=0;i<allobjectstobeupdated.size();i++) {

        Result result=new Result();
        result.Id=allobjectstobeupdated[i].Id;
        result.ObjectName=allobjectstobeupdated[i].getSobjectType().getDescribe().getName();
        if (srList[i].isSuccess()) {
            
          result.Status='Success';
        }
        else {
          result.Status='Failure';
          List<Error> errors=new List<Error>();
          for(Database.Error err : srList[i].getErrors()) {
            Error error=new Error();
            error.message=err.getMessage();
            errors.add(error);
          }
          result.errors=errors;
        }
        resultlist.add(result);
      }
      response.result=resultlist;
    }

    string json_data = json.serialize(response);
    system.debug('json_data'+json_data);  
    RestContext.response.addHeader('Content-Type', 'application/json');
    RestContext.response.responseBody = Blob.valueOf(json_data);     
//return json.serialize(response);
  }

  class Response
  {
    List<Result> result;
  }
  class Result
  {
    String Id;
    String ObjectName;
    List<Error> errors;
    String Status;
  }
  class Error
  {
    String message;
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
    String TimeStamp;
    List<Cases> Cases;
    String ResourceId;
  }
    
    class CustomerConcern 
  {
      String Id;
      String Customer_Concern;
      String Cause;
      String Reason;
      String Action;
      String Call_Category_Type;
      String AppId;
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
      String AppId;
  }  


}