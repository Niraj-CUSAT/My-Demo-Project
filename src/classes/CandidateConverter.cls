/*******************************************************************************
Created by    :    Rajesh Kumar, KVP Business Solutions Pvt. Ltd.
Created On    :    21/8/2015
Description   :    This class is used to convert a candidate to an inactive resource and to assign a dummy case to the inactive resource.
********************************************************************************/
public class CandidateConverter {
  
    public static void convertCandidateToResource(List<Candidate__c> candidatelist)
    {   
        //Record type id for contact
        Id contactrecordtype=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();        
        //This list will hold list of service engineers to be inserted
        List<Service_Engineer__c> serviceengineers=new List<Service_Engineer__c>();
        //This list will hold list of contacts to be inserted
        List<Contact> contactlist=new List<Contact>();
        //Reading the default values of dummy case,contact and account from the settings object.
        spExamsSettings__c settings=[SELECT Mailing_Street__c,Account_Name__c,Category__c,Customer_Concern__c,Description__c,Origin__c,Pincode__c,Product__c,Quantity__c,Reason__c,Region__c,Related_Service_Manager__c,State__c,Status__c,Mobile_Number__c FROM spExamsSettings__c limit 1];      
        Account acc;
        try
        {
            //Loading the values of dummy account from the database
            acc=[select Id from Account where name =: settings.Account_Name__c];
            
        }catch(Exception e)
        {
        // If the account doesn't exist then create an account using the dummy account values   
        acc=new Account();  
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();
        acc.Name=settings.Account_Name__c;
        acc.AOSI_Region__c=settings.Region__c;
        acc.AOSI_State__c=settings.State__c;
        acc.AOSI_Categories__c=settings.Category__c;
        acc.AOSI_Related_Service_Manager__c=settings.Related_Service_Manager__c;
        insert acc;
        }
        
        
        //Reading the value from candidate and creating a list of resource to insert in the database.
        for(Candidate__c candidate:candidatelist)
        {
        Service_Engineer__c resource=new Service_Engineer__c();
        resource.Name = candidate.firstname__c + ' '+candidate.lastname__c;
        resource.Mobile_Number__c=String.valueof(candidate.mobilenumber__c);
        resource.AOSI_Service_Engineer_Email__c=candidate.candidateemail__c;
        resource.Candidate__c=candidate.Id;
        resource.City_Master__c=candidate.City_Master__c;
        resource.Type__c = candidate.Type__c;
        if(candidate.Type__c == 'ASP Technician')
        {
        resource.AOSI_ASP__c=candidate.ASP__c;
        }
        // Making the resource inactive    
        resource.AOSI_Active__c=false;
        serviceengineers.add(resource);
            
        //Inserting Contact
        Contact contact=new Contact();
        contact.AccountId=acc.Id;
        contact.RecordTypeId = contactrecordtype;
        contact.LastName = 'Contact '+candidate.firstname__c;   
        contact.FirstName ='Dummy';   
        contact.Phone=settings.Mobile_Number__c;
        //Assigning PIN to the contact
        contact.AOSI_Pin_Code__c=settings.Pincode__c;
        contact.MailingStreet=settings.Mailing_Street__c;    
        contactlist.add(contact);
            
        }
        system.debug('contact list'+contactlist);
        //Inserting resources and contacts in the database
        Database.SaveResult[] lse = Database.insert(serviceengineers,false);
        Database.SaveResult[] lc = Database.insert(contactlist,false);
		system.debug('lc'+lc);
        List<Case> caselist=new List<Case>();
        for(Integer i=0;i<candidatelist.size();i++)
        {
        //Creating a case
        Case dummycase=new Case();
        dummycase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AOS India').getRecordTypeId();
        dummycase.Status = settings.Status__c;
        dummycase.Origin = settings.Origin__c;
        dummycase.ContactId = lc[i].getId();
        dummycase.Quantity__c=String.valueOf(settings.Quantity__c);
        dummycase.Reason = settings.Reason__c;
        dummycase.AOSI_Customer_Concern__c = settings.Customer_Concern__c;
        //Assigning the product to the Case
        dummycase.AOSIProduct__c=settings.Product__c;  
        caselist.add(dummycase);    
                    
        }
        system.debug('case list'+caselist);
        
        insert caselist;
        
        //This list will update the case by adding the service enginner to the case.
        List<Case> updatecaselist=new List<Case>();
        
        for(Integer i=0;i<candidatelist.size();i++)
        {
         Case case1=new Case();
         case1.Id=caselist.get(i).Id;   
         case1.Service_Engineer__c= serviceengineers.get(i).Id;
         updatecaselist.add(case1);   
        }
       
        update updatecaselist;      
    }

}