/***************************************************************************************************************************************************************************************
    * Created By   : Rajesh Kumar
    * Created Date : 25-NOVEMBER-2015
    * Description  : Controller for AOSI_caseTracking Page
    ********************************************************************************************************************************************************************************/
    public class AOSI_caseTrackingController {

        public String showfeedback { get; set; }
        
        public String casenumber{get;set;}
        public String contactnumber{get;set;}
        public List<Service_Charges__c> servicecharges{get;set;}
        public Case customer_case{get;set;}
        public boolean displayPopup {get; set;}  
        public boolean displayfeedbackform{get;set;}
        public String escalation_mail_content{get;set;} 
        public boolean displaymainpageerror{get;set;} 
        public boolean displaysuccessfeedbackmessage{get;set;} 
        public String mainpageerror{get;set;}
        public boolean expired{get;set;}
        public String RequestResolvedDateTime{get;set;}

        //Method to rewrite the URL
        public PageReference URLChange(boolean nullref)
        {
            PageReference pageRef;
            if(!nullref)
            {
                pageRef = Page.AOSI_caseTracking;
                pageRef.getParameters().put('casenumber',casenumber);
                pageRef.getParameters().put('contactnumber',contactnumber);
                pageRef.setRedirect(true);
            }
            else
            {
                pageRef=null;
            }

            return pageRef;
        }

        //Constuctor
        public AOSI_caseTrackingController()
        {

            if(ApexPages.currentPage().getParameters().get('casenumber')!=null && ApexPages.currentPage().getParameters().get('contactnumber')!=null)
            {
                // Fetching the case number and contact number from the URL Parameters
                casenumber=ApexPages.currentPage().getParameters().get('casenumber');
                contactnumber=ApexPages.currentPage().getParameters().get('contactnumber'); 
                getCaseHistory();
            }
            showfeedbackform();
        }

    //Method to show the feedback form
        public PageReference showfeedbackform()
        {

            PageReference reference=Page.AOSI_caseTracking;
            String strTemp,strSurveyLink;
            if(customer_case!=null)
            {

                CCTSettings__c settings=CCTSettings__c.getValues('Default');
                strTemp=settings.Feedback_URL__c;
                strSurveyLink = strTemp+''+customer_case.ContactId+'&case_id='+customer_case.Id+'&wf=yes';
                showfeedback =  strSurveyLink;
                reference.getParameters().put('casenumber',casenumber);
                reference.getParameters().put('contactnumber',contactnumber);
                reference.getParameters().put('feedback','false');
                reference.setRedirect(true);

            }
            return reference;
        }

    //Method to hide feedback form
        public PageReference hidefeedbackform()
        {
            PageReference pageRef = Page.AOSI_caseTracking;
            pageRef.getParameters().put('casenumber',casenumber);
            pageRef.getParameters().put('contactnumber',contactnumber);
            pageRef.getParameters().put('feedback','false');
            pageRef.setRedirect(true);
            return pageRef;
        }

    //Method to display feedback popup
        public void showPopup() {        
            displayPopup = true;    
        }

    // Method to show the case details 
        public PageReference getCaseHistory()
        {

            displaymainpageerror =false;
            displaysuccessfeedbackmessage=false;
            customer_case=null;
            servicecharges=null;
            if(ApexPages.currentPage().getParameters().get('escalated')=='true')
            {
                displaysuccessfeedbackmessage=true;
            }
            if(!casenumber.isNumeric() || casenumber.length()!=8)
            {
                displaymainpageerror=true;
                mainpageerror='Incorrect case number'; 
            }
            else
            {
                {   try
                    {
                        customer_case=[select Contact.MobilePhone,AOSI_Preferred_Color__c,AOSI_Case_Close_Time__c,Assignment_End_Time__c,Contact.FirstName,Contact.LastName,Contact.MailingPostalCode,Contact.MailingState,Contact.MailingCity,Contact.MailingStreet,Contact.OtherPhone,AOSI_Appointment_Date__c,AOSI_Cancelled_On_HOLD_Reason__c,Assignment_Start_Time__c,Asset.Name,Asset.PurchaseDate,Asset.AOSI_Asset_Status__c,Contact.Email,AOSIProduct__r.Name,Id,ContactId,AOSI_Total_Charges__c,AOSI_Discount__c,AOSI_New_Final_Amount__c,AOSI_Transaction_Number__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,CaseNumber, Service_Engineer__r.Name,Status,Service_Engineer_Phone__c,Reason,CreatedDate,ClosedDate,Contact_Phone__c from Case where CaseNumber=:casenumber];
                        
                        if(customer_case.Assignment_End_Time__c != null)
                        {
                            RequestResolvedDateTime=customer_case.Assignment_End_Time__c.format();
                        }
                        else if(customer_case.AOSI_Case_Close_Time__c !=null)
                        {
                            RequestResolvedDateTime=customer_case.AOSI_Case_Close_Time__c.format();
                        }
                        else
                        {
                            RequestResolvedDateTime=customer_case.ClosedDate.format();
                        }
                        
                    }
                    catch(Exception ex)
                    {

                    }
                    if(customer_case!=null){

                        if(customer_case.Contact_Phone__c == contactnumber)
                        {
                            expired=false;
                            if(customer_case.Status=='Closed' && (ApexPages.currentPage().getParameters().get('feedback')== null ||ApexPages.currentPage().getParameters().get('feedback')!='false'))
                            {
                                
                                
                                TIMBASURVEYS__Survey_Summary__c hascompletedsurvey=null;
                                try
                                {
                                    hascompletedsurvey=[select Id from TIMBASURVEYS__Survey_Summary__c where TIMBASURVEYS__RelatedCase__c =:customer_case.Id limit 1];
                                }
                                catch(Exception ex)
                                {
                                    
                                }
                                
                                // If customer has not completed the survey, ask the user to fill it.
                                if(hascompletedsurvey==null)
                                {
                                    displayfeedbackform =true; 
                                }   
                            }
                            else
                            {
                                displayfeedbackform=false;
                            }

                            if(customer_case.ClosedDate !=null )
                            {
                                Date myDate = date.newinstance(customer_case.ClosedDate.year(), customer_case.ClosedDate.month(), customer_case.ClosedDate.day());
                                integer intNumOfDays=myDate.daysBetween(System.Today());
                                system.debug(intNumOfDays);    
                                If(intNumOfDays > 90)
                                {
                                    expired=true;

                                }
                            }    
                            if(!expired)
                            {   
                                if(customer_case.Status=='Partially Closed')
                                {
                                    try
                                    {
                                        servicecharges=[select Id,Spares__r.Name,Type__c,Final_Charges__c from Service_Charges__c where  Case__r.Id=:customer_case.Id];

                                    }
                                    catch(Exception ex)
                                    {
                                        servicecharges=null;
                                    }


                                }

                            }else
                            {
                                displaymainpageerror=true;
                                mainpageerror='Data not found';    
                                customer_case=null;

                            }

                        }
                        else
                        {
                            displaymainpageerror=true;
                            mainpageerror='Please enter the correct mobile number'; 
                            customer_case=null;
                        }

                    }else
                    {
                        displaymainpageerror=true;
                        mainpageerror='Call tracking link has expired.'; 
                        customer_case=null;   
                    }
                }
            }


            return URLChange(false);
        }

    //Method to hide the escalation form
        public PageReference cancelescalation()
        {
            displayPopUp=false;
            return URLChange(false);
        }

    //Method to handle escalations originated from the tracking page
        public PageReference escalationHandler()
        {
            PageReference pageRef;  
            if(escalation_mail_content.trim()!='')
            { 
              
                if(customer_case.Status=='Open' || customer_case.Status=='On Hold'|| customer_case.Status=='Partially Closed' ) {
                  Escalation__c escalate = null;
                  
                  try
                  {
                     escalate=[SELECT Id,CreatedDate FROM  Escalation__c WHERE Related_Case__c =:customer_case.Id order by CreatedDate DESC limit 1];
                 }
                 catch(Exception ex)
                 {
                     
                 }
                 if(escalate==null || (escalate.CreatedDate).Date() != System.Today()){
                    //Insert a record in escaltion to record the escalation content.
                    Escalation__c objEscalation = new Escalation__c();
                    objEscalation.Related_Case__c=customer_case.Id;
                    objEscalation.Escalation_Reason__c=escalation_mail_content;
                    objEscalation.Origin__c='Website';
                    insert objEscalation;
                    
                    displaysuccessfeedbackmessage=true;
                    displayPopUp=false;
                    pageRef = URLChange(false);
                    pageRef.getParameters().put('escalated','true');
                }                    
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You already have submitted an escalation and it’s under review/process.','')); 
                    displaymainpageerror=false;
                    pageRef=URLChange(true);
                }
            }     else{
               
               
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You cannot escalate a closed case.','')); 
               displaymainpageerror=false;
               pageRef=URLChange(true);
               
           }             
       }
       else
       {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Escalation reason cannot be blank.','')); 
        displaymainpageerror=false;
        pageRef=URLChange(true);
        
    }

    return pageRef;

}

    //Method to logout from the tracking page
        public PageReference logOut()
        {
            customer_case=null;
            casenumber=null;
            contactnumber=null;
            PageReference pageRef = Page.AOSI_caseTracking;
            pageRef.setRedirect(true);
            return pageRef;
        }

}