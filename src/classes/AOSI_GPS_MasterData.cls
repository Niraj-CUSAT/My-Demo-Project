@RestResource(urlmapping='/getmasterdata/*')
global class AOSI_GPS_MasterData {
    @HttpPost
    global static void getData()
    {
        Id contact_recordtype = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();
        Id product_recordtype = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();
        Id account_recordtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();
        Id case_recordtype = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();
        MasterData master_data=new MasterData();
        RestRequest request=RestContext.request;
        RestResponse response=RestContext.response;
        String sync_date=request.params.get('date');
        //String master_table=request.params.get('mastertable');
        //sync_date=null;

            //List<Contact> contactlist=null;
			//List<AOSI_Contract__c> contractlist=null;
			//List<Asset> assetlist=null;
			List<Account> accountlist=null;
        	List<Product2> productlist=null;
        	List<Spare_Product_Junction__c> spare_product_junction;
			if(sync_date =='null')
			{    
			//contactlist=[select Id,Title, Name,Account.Name,MailingPostalCode,MailingState,MailingCity,MailingStreet,Phone,MobilePhone,OtherPhone,Email,AOSI_Pin_Code__r.Name,AOSI_Region__c,AOSI_Locality__r.Name,AOSI_State__c,AOSI_City_Picklist__c from Contact where RecordTypeId=:contact_recordtype];
            //contractlist=[select Id,AOSI_Contract_Number__c,Name,AOSI_AMC_Pin__c,AOSI_Case_Number__c,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Contact__c,AOSI_Product_Model__c,AOSI_Asset__c,AOSI_Contract_Status__c,AOSI_Manual_OTP__c,AOSI_Manual_Base_Amount__c,AOSI_Base_Amount__c,AOSI_Discount__c,AOSI_Tax__c,AOSI_Total_Amount__c,AOSI_Amount_Received__c,AOSI_Amount_Received_Date__c,AOSI_Contract_Charges__c,AOSI_Mode_Of_Payment__c,AOSI_Reference_Number__c,AOSI_Payment_Collected_By__c,AOSI_Invoice_Number__c,AOSI_Invoice_Date__c from AOSI_Contract__c where AOSI_Case__r.recordtypeid=: case_recordtype];
        	//assetlist=[select Id,Name,Product2.Name,PurchaseDate,AOSI_Asset_Status__c,AOSI_Product_Vertical__c,AOSI_Dealer_Asset__c,AOSI_Contract_Status__c,Account.Name,AOSI_Active__c,InstallDate,AOSI_Warranty_End_Date__c,Warranty_Final_End_Date_AOSI__c,AOSI_Warranty_Registered_In_Time__c,OPW_End_Date_AOSI__c,AOSI_Warranty_registration_Date__c,AOSI_Contract_Start_Date__c,AOSI_Contract_Charges__c,AOSI_Contract_End_Date__c,AOSI_Contract_Number__c,AOSI_Replaced_Asset__c,AOSI_Replacement_Date__c,AOSI_Old_Asset_Purchase_Date__c,Invoice_Date__c,AOSI_Membrane_Warranty__c,Invoice_Number__c,AOSI_Automatic_PM_Service__c,AOSI_PM_Service1_Date__c,AOSI_PM_Service4_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c  from  Asset where Product2.RecordTypeId=:product_recordtype];
            accountlist=[select Id,Name,Parent.Name,AOSI_Active__c,AOSI_Region__c,AOSI_State__c,AOSI_Categories__c,AOSI_Email__c,Phone,Other_Phone__c,Customer_Code__c,Website,AOSI_Distributor_s_Name__c,AOSI_Related_Service_Manager__r.Name,AOSI_Service_Manager_Email__c,AOSI_Service_Manager_Phone__c,AOSI_Related_Sales_Manager__c,AOSI_Sales_manager_Email__c,AOSI_Sales_manager_Phone__c,AOSI_Pin_Code__c,ShippingPostalCode,ShippingState,ShippingCity,ShippingStreet from Account where recordtypeid =:account_recordtype limit 25];
            productlist=[select Id,Name,ProductCode,IsActive,AOSI_Product_Code_for_Serial_Number__c,AOSI_Vertical__c,AOSI_Family__c,AOSIColor__c,Product_Warranty_AOS_India__c,AOSI_Comprehensive_Warranty__c,AOSI_Element_Warranty__c,AOSI_Free_Installtion__c,AOSIColorPanel_Free__c,AOSI_Visit_Charges__c,AOSI_Installation_Charges__c,AOSI_Color_Panel_Charges__c,AOSI_Demounting_Charge__c,AOSI_Membrane_Wty__c  from  Product2 where RecordTypeId=:product_recordtype limit 25];    
            spare_product_junction = [Select Spares__r.Name,Spares__r.Type__c,Spares__r.Part_Code__c,Spares__r.Active__c,Spares__r.AMC_Covered__c,Spares__r.Family__c,Spares__r.Part_Type__c,Spares__r.Part_Sr_Number_Required__c,Spares__r.Chargeable_Under_Warranty__c,Spares__r.MRP__c from Spare_Product_Junction__c where Product__r.recordtypeid =:product_recordtype limit 25];                   
			}
			else{
            //Date Format : 2015-06-30    
			List<String> dateParts = sync_date.split('-');
			Datetime sync_datetime = Datetime.newInstance(Integer.valueOf(dateParts[0]), Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[2]));
            //DateTime sync_datetime=DateTime.parse(sync_date);   
			//contactlist=[select Id,Title, Name,Account.Name,MailingPostalCode,MailingState,MailingCity,MailingStreet,Phone,MobilePhone,OtherPhone,Email,AOSI_Pin_Code__r.Name,AOSI_Region__c,AOSI_Locality__r.Name,AOSI_State__c,AOSI_City_Picklist__c from Contact where RecordTypeId=:contact_recordtype and CreatedDate >:sync_datetime];
        	//assetlist=[select Id,Name,Product2.Name,PurchaseDate,AOSI_Asset_Status__c,AOSI_Product_Vertical__c,AOSI_Dealer_Asset__c,AOSI_Contract_Status__c,Account.Name,AOSI_Active__c,InstallDate,AOSI_Warranty_End_Date__c,Warranty_Final_End_Date_AOSI__c,AOSI_Warranty_Registered_In_Time__c,OPW_End_Date_AOSI__c,AOSI_Warranty_registration_Date__c,AOSI_Contract_Start_Date__c,AOSI_Contract_Charges__c,AOSI_Contract_End_Date__c,AOSI_Contract_Number__c,AOSI_Replaced_Asset__c,AOSI_Replacement_Date__c,AOSI_Old_Asset_Purchase_Date__c,Invoice_Date__c,AOSI_Membrane_Warranty__c,Invoice_Number__c,AOSI_Automatic_PM_Service__c,AOSI_PM_Service1_Date__c,AOSI_PM_Service4_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c  from  Asset where Product2.RecordTypeId=:product_recordtype and CreatedDate >:sync_datetime ];
            //contractlist=[select Id,AOSI_Contract_Number__c,Name,AOSI_AMC_Pin__c,AOSI_Case_Number__c,AOSI_Start_Date__c,AOSI_End_Date__c,AOSI_Contact__c,AOSI_Product_Model__c,AOSI_Asset__c,AOSI_Contract_Status__c,AOSI_Manual_OTP__c,AOSI_Manual_Base_Amount__c,AOSI_Base_Amount__c,AOSI_Discount__c,AOSI_Tax__c,AOSI_Total_Amount__c,AOSI_Amount_Received__c,AOSI_Amount_Received_Date__c,AOSI_Contract_Charges__c,AOSI_Mode_Of_Payment__c,AOSI_Reference_Number__c,AOSI_Payment_Collected_By__c,AOSI_Invoice_Number__c,AOSI_Invoice_Date__c from AOSI_Contract__c where AOSI_Case__r.recordtypeid=: case_recordtype and CreatedDate >:sync_datetime];
            productlist=[select Id,Name,ProductCode,IsActive,AOSI_Product_Code_for_Serial_Number__c,AOSI_Vertical__c,AOSI_Family__c,AOSIColor__c,Product_Warranty_AOS_India__c,AOSI_Comprehensive_Warranty__c,AOSI_Element_Warranty__c,AOSI_Free_Installtion__c,AOSIColorPanel_Free__c,AOSI_Visit_Charges__c,AOSI_Installation_Charges__c,AOSI_Color_Panel_Charges__c,AOSI_Demounting_Charge__c,AOSI_Membrane_Wty__c  from  Product2 where RecordTypeId=:product_recordtype and LastModifiedDate >:sync_datetime  limit 25];
            accountlist=[select Id,Name,Parent.Name,AOSI_Active__c,AOSI_Region__c,AOSI_State__c,AOSI_Categories__c,AOSI_Email__c,Phone,Other_Phone__c,Customer_Code__c,Website,AOSI_Distributor_s_Name__c,AOSI_Related_Service_Manager__r.Name,AOSI_Service_Manager_Email__c,AOSI_Service_Manager_Phone__c,AOSI_Related_Sales_Manager__c,AOSI_Sales_manager_Email__c,AOSI_Sales_manager_Phone__c,AOSI_Pin_Code__c,ShippingPostalCode,ShippingState,ShippingCity,ShippingStreet from Account where recordtypeid =:account_recordtype and LastModifiedDate >:sync_datetime  limit 25];    
            spare_product_junction = [Select Spares__r.Name,Spares__r.Type__c,Spares__r.Part_Code__c,Spares__r.Active__c,Spares__r.AMC_Covered__c,Spares__r.Family__c,Spares__r.Part_Type__c,Spares__r.Part_Sr_Number_Required__c,Spares__r.Chargeable_Under_Warranty__c,Spares__r.MRP__c from Spare_Product_Junction__c where Product__r.recordtypeid =:product_recordtype and LastModifiedDate >:sync_datetime limit 25];                       
			}
           /*
            if(contactlist !=null)
            {
                List<ContactInfo> json_contacts=new List<ContactInfo>();
                for(Contact cont_act:contactlist)
                {
				  ContactInfo contact=new ContactInfo();
                  contact.Id=cont_act.Id;  
                  contact.Title=cont_act.Title;
                  contact.ContactName=cont_act.Name;
                  contact.Account_Name=cont_act.Account.Name;
                  contact.Mobile_Number_1=cont_act.Phone;
                  contact.Mobile_Number_2=cont_act.MobilePhone;
                  contact.Landline_Number=cont_act.OtherPhone;
                  contact.Email=cont_act.Email;
                  contact.Pin_Code=cont_act.AOSI_Pin_Code__r.Name;
                  contact.Region=cont_act.AOSI_Region__c;
                  contact.Locality=cont_act.AOSI_Locality__r.Name;
                  contact.State=cont_act.AOSI_State__c;
                  contact.City=cont_act.AOSI_City_Picklist__c ;
                  contact.MailingPostalCode=cont_act.MailingPostalCode;
                  contact.MailingState=cont_act.MailingState;
                  contact.MailingCity=cont_act.MailingCity;
                  contact.MailingStreet=cont_act.MailingStreet ;
                  json_contacts.add(contact);  
                    
                }
               master_data.contacts= json_contacts;
            }
            */
            if(productlist!=null)
            {
                 List<ProductInfo>json_products=new List<ProductInfo>();
                  for(Product2 prod_uct:productlist)
                  {
                  ProductInfo product =new ProductInfo();
                  product.Id=prod_uct.Id;    
                  product.Item_ID=prod_uct.Name;
                  product.Model=prod_uct.ProductCode;
                  product.Active=prod_uct.IsActive;
                  product.Product_Code_for_Serial_Number=prod_uct.AOSI_Product_Code_for_Serial_Number__c;
                  product.Vertical=prod_uct.AOSI_Vertical__c;
                  product.India_Family=prod_uct.AOSI_Family__c;
                  product.Color=prod_uct.AOSIColor__c;
                  product.Tank_Warranty_India=prod_uct.Product_Warranty_AOS_India__c;
                  product.Comprehensive_Warranty=prod_uct.AOSI_Comprehensive_Warranty__c;
                  product.Element_Warranty=prod_uct.AOSI_Element_Warranty__c;
                  product.Free_Installtion=prod_uct.AOSI_Free_Installtion__c;
                  product.Color_Panel_Free=prod_uct.AOSIColorPanel_Free__c;
                  product.Visit_Charges=prod_uct.AOSI_Visit_Charges__c;
                  product.Installation_Charges=prod_uct.AOSI_Installation_Charges__c;
                  product.Color_Panel_Charges=prod_uct.AOSI_Color_Panel_Charges__c;
                  product.Demounting_Charges=prod_uct.AOSI_Demounting_Charge__c;
                  product.Membrane_Wty=prod_uct.AOSI_Membrane_Wty__c; 
                  json_products.add(product);    
                  }
                master_data.products=json_products;
            }
        /*    
            if(assetlist!=null)
            {
                 List<AssetInfo> json_assetinfo=new List<AssetInfo>();
                 for(Asset as_set:assetlist)	
                 {
                  AssetInfo asset=new AssetInfo();
                  asset.Id=as_set.Id;   
                  asset.Serial_Number=as_set.Name;
                  asset.Product=as_set.Product2.Name;
                  asset.Purchase_Date=as_set.PurchaseDate;
                  asset.Asset_Status=as_set.AOSI_Asset_Status__c;
                  asset.Product_Vertical=as_set.AOSI_Product_Vertical__c;
                  asset.Dealer_Asset=as_set.AOSI_Dealer_Asset__c;
                  asset.Contract_Status=as_set.AOSI_Contract_Status__c;
                  asset.Account=as_set.Account.Name;
                  asset.Active=as_set.AOSI_Active__c;
                  asset.Install_Date=as_set.InstallDate;
                  asset.Warranty_End_Date=as_set.AOSI_Warranty_End_Date__c;
                  asset.Optional_Warranty_2=as_set.Warranty_Final_End_Date_AOSI__c;
                  asset.Warranty_Registered_In_Time=as_set.AOSI_Warranty_Registered_In_Time__c;
                  asset.Optional_Warranty_1=as_set.OPW_End_Date_AOSI__c;
                  asset.Warranty_registration_Date=as_set.AOSI_Warranty_registration_Date__c;
                  asset.Contract_Start_Date=as_set.AOSI_Contract_Start_Date__c;
                  asset.Contract_Charges=as_set.AOSI_Contract_Charges__c;
                  asset.Contract_End_Date=as_set.AOSI_Contract_End_Date__c;
                  asset.Contract_Number=as_set.AOSI_Contract_Number__c;
                  asset.Replaced_Asset=as_set.AOSI_Replaced_Asset__c;
                  asset.Replacement_Date=as_set.AOSI_Replacement_Date__c;
                  asset.Old_Asset_Purchase_Date=as_set.AOSI_Old_Asset_Purchase_Date__c;
                  asset.Invoice_Date=as_set.Invoice_Date__c;
                  asset.Membrane_Warranty=as_set.AOSI_Membrane_Warranty__c;
                  asset.Invoice_Number=as_set.Invoice_Number__c;
                  asset.Automatic_PM_Service=as_set.AOSI_Automatic_PM_Service__c;
                  asset.W_PM_Service1_Date=as_set.AOSI_PM_Service1_Date__c;
                  asset.W_PM_Service4_Date=as_set.AOSI_PM_Service4_Date__c;
                  asset.W_PM_Service2_Date=as_set.AOSI_PM_Service2_Date__c;
                  asset.W_PM_Service3_Date=as_set.AOSI_PM_Service3_Date__c;
                  json_assetinfo.add(asset);    
                 }
                master_data.assets=json_assetinfo;
            }
            */
            if(accountlist !=null)
            {
                List<AccountInfo> json_accountinfo=new List<AccountInfo>();
                for(Account acc_out:accountlist)
                {
                  AccountInfo account=new AccountInfo();
                  account.Id = acc_out.Id;  
                  account.Account_Name = acc_out.Name;
                  account.Parent_Account=acc_out.Parent.Name;
                  account.Active=acc_out.AOSI_Active__c;
                  account.Region=acc_out.AOSI_Region__c;
                  account.State=acc_out.AOSI_State__c;
                  account.Categories=acc_out.AOSI_Categories__c;
                  account.Email=acc_out.AOSI_Email__c;
                  account.Phone=acc_out.Phone;
                  account.Other_Phone=acc_out.Other_Phone__c;
                  account.Customer_Code=acc_out.Customer_Code__c;
                  account.Website=acc_out.Website;
                  account.Distributor_Name=acc_out.AOSI_Distributor_s_Name__c;
                  account.Related_Service_Manager=acc_out.AOSI_Related_Service_Manager__r.Name;
                  account.Service_Manager_Email=acc_out.AOSI_Service_Manager_Email__c;
                  account.Service_Manager_Phone=acc_out.AOSI_Service_Manager_Phone__c;
                  account.Related_Sales_Manager=acc_out.AOSI_Related_Sales_Manager__c;
                  account.Sales_manager_Email=acc_out.AOSI_Sales_manager_Email__c;
                  account.Sales_manager_Phone=acc_out.AOSI_Sales_manager_Phone__c;
                  account.Pin_Code=acc_out.AOSI_Pin_Code__c;
                  account.ShippingPostalCode=acc_out.ShippingPostalCode;
                  account.ShippingState=acc_out.ShippingState;
                  account.ShippingCity=acc_out.ShippingCity;
                  account.ShippingStreet=acc_out.ShippingStreet;
                  json_accountinfo.add(account);
                }
                master_data.accounts=json_accountinfo;
                
            }
           /* 
            if(contractlist !=null)
            {
              List<ContractInfo> json_contractinfo=  new List<ContractInfo>();     
                    for(AOSI_Contract__c con:contractlist)
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
                      json_contractinfo.add(obj_con_info);      
                    }
                    master_data.contracts=json_contractinfo ;
            }
            
            	  List<PRR__c> listofPRR=[Select AOSI_PRR_Number__c,Request_Type__c,AOSI_Type__c,AOSI_Case__c,AOSI_Approval_Status__c,AOSI_Customer_Name__c,AOSI_Delivery_Address__c,Landmark__c,AOSI_Product__c,AOSI_Asset__c,AOSI_DOP__c,AOSI_Account__c,AOSI_DOA_Dead_On_Arrival__c,AOSI_Repeat_Failure__c,AOSI_Transit_Damaged__c,AOSI_Others__c,AOSI_Manufacture_Fault_Non_Repairable__c,AOSI_Serious_Issue_Product_Burnt__c,Tank_Failure__c,AOSI_Other_Reason__c,AOSI_Refund_Value__c,AOSI_Justification__c from PRR__c where AOSI_Case__r.recordtypeid =: case_recordtype] ;  
                  if(listofPRR != null)
                  {
                    List<PRRInfo> json_prrinfo=new List<PRRInfo>();
                    
                    for(PRR__c prr:listofPRR)
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
                      json_prrinfo.add(prrinfo);
   
                    }
                    master_data.prrs=json_prrinfo;
                  }
            */
           		  
                  if(spare_product_junction !=null)
                  {
                    List<SpareInfo> spareinfojson=new List<SpareInfo>();
                    for(Spare_Product_Junction__c sp:spare_product_junction)
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
                    master_data.spares=spareinfojson;
                  }
        /*
        list<GPS_Picklist_Value__c> picklistvals=[select Object_Name__c,Values__c,Field_Name__c,Dependent_Values__c,Dependent_Field__c from GPS_Picklist_Value__c where Active__c=true ];
        master_data.picklistvalues=picklistvals;
		*/
        
		RestContext.response.responseBody=Blob.valueOf(Json.serialize(master_data));
        RestContext.response.addHeader('Content-Type','applicaton/json');
        
        
    }

Class MasterData
{
   List<ProductInfo> products;  
   List<AccountInfo> accounts; 
   List<SpareInfo> spares;
   //List<ContactInfo> contacts;
   //List<AssetInfo> assets;
   //List<ContractInfo> contracts;
   //List<PRRInfo> prrs;
   //list<GPS_Picklist_Value__c> picklistvalues;
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

    
}