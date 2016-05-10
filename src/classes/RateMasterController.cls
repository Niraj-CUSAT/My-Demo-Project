public class RateMasterController {

public ASP_Rate_Master__c aspRecord {get;set;}  //Retrieve single record 
public Id  aspId  {get;set;} 
public boolean productcat{set;get;}
public String fixedcompensation{set;get;}
public ASP_Rate_Master__c ratemaster{get;set;}

//Product Category
public boolean productcat_wh{set;get;}
public boolean productcat_wt{set;get;}

//casetype
public boolean casetype_service{set;get;}
public boolean casetype_freeinstallation{set;get;}
public boolean casetype_pmservice{set;get;}
public boolean casetype_dealerstock{set;get;}
public boolean casetype_contractrequest{set;get;}
public boolean casetype_fieldtrial{set;get;}
public boolean casetype_exchangepickup{set;get;}

//po1 casetype
public boolean po1_casetype_service{set;get;}
public boolean po1_casetype_freeinstallation{set;get;}
public boolean po1_casetype_pmservice{set;get;}
public boolean po1_casetype_dealerstock{set;get;}
public boolean po1_casetype_contractrequest{set;get;}
public boolean po1_casetype_fieldtrial{set;get;}
public boolean po1_casetype_exchangepickup{set;get;}



    
public RateMasterController(ApexPages.StandardController stdController)
{
aspRecord=(ASP_Rate_Master__c)stdController.getRecord();//Retreiving current ASP details 
aspId=aspRecord.Id;//Retreiving current ASP Id 
ratemaster=[select Id,Product_Family_Gas__c,Product_Family_Instant__c,Product_Family_RO__c,Product_Family_Storage__c from ASP_Rate_Master__c where Id =:aspId limit 1];
if(ratemaster != null)
{

    List<Service_Line__c> service_line=[select Id, Type__c from Service_Line__c where ASP_Rate_Master__c=:ratemaster.Id];
    
    for(Service_Line__c sl:service_line)
    {
            if(sl.Type__c =='Free Installation')
            {
                casetype_freeinstallation =true;

            }
            else if(sl.Type__c =='Service')
            {
                casetype_service =true;
            }
            else if(sl.Type__c =='PM Service')
            {
                casetype_pmservice =true;
            } 
            else if(sl.Type__c =='Dealer Stock')
            {
                casetype_dealerstock =true;
            } 
            else if(sl.Type__c =='Contract Request')
            {
                casetype_contractrequest =true;
            } 
            else if(sl.Type__c =='Field Trial')
            {
                casetype_fieldtrial =true;
            } 
            else if(sl.Type__c =='Free Installation')
            {
                casetype_freeinstallation =true;
            }  
    }
   /* 
    if(ratemaster.Product_Category__c.contains(';'))
    {
        productcat_wh=true;
        productcat_wt=true;
        
    }
    else
    {
        if(ratemaster.Product_Category__c =='Water Heater')
        {
                productcat_wh=true;
        }
        
        if(ratemaster.Product_Category__c =='Water Treatment')
        {
                productcat_wt=true;
        }

        
    }
    */

}




}


}