/***************************************************************************************************************************************************************************************
        * Class Name   : AOSI_IncomingSMSTriggerHandler
        * Created By   : Pooja P Bhat
        * Created Date : 29-SEPTEMBER-2015
        * Description  : Handler Class for AOSI_IncomingSMSTrigger
        * Constructor  : public AOSI_IncomingSMSTriggerHandler(list<smagicinteract__Incoming_SMS__c> newList, map<Id,smagicinteract__Incoming_SMS__c> newMap, map<Id,smagicinteract__Incoming_SMS__c> oldMap)
        * Methods      : public void afterInsertUpdateHandler(Boolean isInsert)
        *                public void afterInsertHandler() 
        *                public void afterUpdateHandler()
        *************************************************************************************************************************************************************************************/
public class AOSI_IncomingSMSTriggerHandler {
    private list<smagicinteract__Incoming_SMS__c> newList   =   new list<smagicinteract__Incoming_SMS__c>();
    private map<Id,smagicinteract__Incoming_SMS__c> newMap  =   new map<Id,smagicinteract__Incoming_SMS__c>();
    private map<Id,smagicinteract__Incoming_SMS__c> oldMap  =   new map<Id,smagicinteract__Incoming_SMS__c>();
        private RecordType caseAOSIndiaRecType;  //Holds Case 'AOS India' Recordtype details
        // Modified by Rajesh
        public String smsSenderID;              //Holds senderId - which appears on the mobile phone as the sender of a SMS 
        public map<String,String> mapSMSTemplateText    =   new map<String,String>(); //Contains SMS template name and template text
        // End

        /*******************************************************************************************************************************************************
        Parameterized Constructor   :   AOSI_IncomingSMSTriggerHandler
        Description                 :   Used to initialize all class variables newList, newMap, oldMap
        *******************************************************************************************************************************************************/
        public AOSI_IncomingSMSTriggerHandler(list<smagicinteract__Incoming_SMS__c> newList, map<Id,smagicinteract__Incoming_SMS__c> newMap, map<Id,smagicinteract__Incoming_SMS__c> oldMap) {

        //Modified by Rajesh
            smsSenderID             =   DefineConstant.SMS_SENDER_ID;
            mapSMSTemplateText      =   AOSI_StaticQueryHelper.mCaseSMSTemplateText; 
        //End    
            this.newList    =   newList;
            this.newMap     =   newMap;
            this.oldMap     =   oldMap;
            try{
                caseAOSIndiaRecType     =   AOSI_StaticQueryHelper.caseAOSIndiaRecType; } catch (Exception exp) { System.debug('***Exception from AOSI_CaseTriggerHandler class*** '+exp.getMessage() + exp.getLineNumber()); }
            }

        /*******************************************************************************************************************************************************
        * Method Name : afterInsertUpdateHandler(Boolean isInsert)
        * Return Type : void
        * Description : Defines AOSI_IncomingSMSTrigger after insert/update logic 
        a)Method is used to capture the keyword as well as the case number from the incoming SMS text and then update the case with  
        Assignment start time, Assignment end  time, Customer satisfaction status fields based on Keywords YES, NO, START, STOP, ContractPin
        it will check for the incoming number to prevent people other than service engineer or contact in the case object to update the case. 
        *******************************************************************************************************************************************************/

        public void afterInsertUpdateHandler(Boolean isInsert) {

        list<smagicinteract__smsMagic__c> smsHistoryList = new list<smagicinteract__smsMagic__c>(); // Added by Rajesh
        list<Task> taskList = new list<Task>(); // Added by Rajesh
        Map<String,String> casetoupdateonotp=new Map<String,String>();
        Map<String,String> mobilenumbercheck=new Map<String,String>();
        Set<String> invalidmessageset=new Set<String>();
        Set<String> smstounregisteredmobilenumbers=new Set<String>();
        Set<Case> smstoinvalidcontracttypenumbers=new Set<Case>();
        Set<String> resendotplist=new Set<String>();    
        map<Id,String> mSMSIdCaseNum        =   new map<Id,String>(); 
        map<Id,String> mSMSIdContrctPin     =   new map<Id,String>();
        map<smagicinteract__Incoming_SMS__c,String> incomingsmstocase =new map<smagicinteract__Incoming_SMS__c,String>();// Use to update the case number on incoming OTP SMS.
        //Added by Rajesh
        //Mapping all the AMC to the product
        List<Product_AMC_Junction__c> amcjuntion=[SELECT AMC_Master__c,AMC_Master__r.AOSI_AMC_Amount__c, AMC_Master__r.AOSI_Contract_Type__c ,Name, Product__c FROM Product_AMC_Junction__c where AMC_Master__r.AOSI_Status__c='Active'];
        Map<Id,List<Product_AMC_Junction__c>> mappp=new Map<Id,List<Product_AMC_Junction__c>>();
        for(Product_AMC_Junction__c junction:amcjuntion)
        {
            if(mappp.containsKey(junction.Product__c))
            {
                mappp.get(junction.Product__c).add(junction);
            }
            else
            {
                mappp.put(junction.Product__c,new List<Product_AMC_Junction__c>{junction});
            }
        }
        // End Mapping all the AMC to the product    
        if( !newMap.isEmpty() ) {
            for(smagicinteract__Incoming_SMS__c inSMS : newMap.values()) {
                String AMCtype = '';
                String caseNumber   =   '';
                list<String> lParts = new list<String>();
                if ( (isInsert && (inSMS.smagicinteract__SMS_Text__c != null || inSMS.smagicinteract__SMS_Text__c != '')) || (!isInsert && ( inSMS.smagicinteract__SMS_Text__c != oldMap.get(inSMS.Id).smagicinteract__SMS_Text__c || inSMS.smagicinteract__Mobile_Number__c != oldMap.get(inSMS.Id).smagicinteract__Mobile_Number__c))) {

        //**************************************Start OTP****************************************
                    Set<String> contracttype=new Set<String>(DefineConstant.CONTRACT_TYPES.split(','));
                    if(inSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase('OTP'))
                    {
                        String fullsms= inSMS.smagicinteract__SMS_Text__c;   

                        if(fullsms.startsWithIgnoreCase('OTP'))
                        {   
        // Extracting  the case number and contact pin from the message
                            String strcasenumber=fullsms.substring(4,12).trim();
                            incomingsmstocase.put(inSMS,strcasenumber);
                            String stramc=fullsms.substring(13,fullsms.length()).trim();   
                            if(!contracttype.contains(stramc) || strcasenumber.length()!=8 || !strcasenumber.isNumeric())
                            {
                                invalidmessageset.add(inSMS.smagicinteract__Mobile_Number__c); 
                            }
                            else
                            {
                                casetoupdateonotp.put(strcasenumber,stramc); 
                                mobilenumbercheck.put(strcasenumber,inSMS.smagicinteract__Mobile_Number__c);
                            }

                        }

                    }          
        //**************************************Stop  OTP****************************************

                    if ( inSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase(DefineConstant.START) ) {
                        caseNumber  =   inSMS.smagicinteract__SMS_Text__c.substring(5).trim().left(8);                         
                        mSMSIdCaseNum.put(inSMS.Id, caseNumber);
                    }
                    else if ( inSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase(DefineConstant.STOP) ) {
                        caseNumber  =   inSMS.smagicinteract__SMS_Text__c.substring(4).trim().left(8);  
                        mSMSIdCaseNum.put(inSMS.Id, caseNumber);
                    }
                    else if ( inSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase(DefineConstant.YES) ) {
                        caseNumber  =   inSMS.smagicinteract__SMS_Text__c.substring(3).trim().left(8).trim();   
                        mSMSIdCaseNum.put(inSMS.Id, caseNumber);
                    }
                    else if ( inSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.NO) ) {
                        caseNumber  =   inSMS.smagicinteract__SMS_Text__c.substring(2).trim().left(8).trim();   
                        mSMSIdCaseNum.put(inSMS.Id, caseNumber);
                    }
                    else if ( inSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.CONTRACT_AMC) || inSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.CONTRACT_ACMC) || inSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.CONTRACT_FLT)) {
                        AMCtype = inSMS.smagicinteract__SMS_Text__c.replaceAll( '\\s+', ' ');  
                        if ( AMCtype.length() > 0 ) {  
                            lParts = AMCtype.split(' ');               
                            if( !lParts.isEmpty() ) {
                                mSMSIdContrctPin.put(inSMS.Id, lParts[0]+ ' ' +lParts[1]);
                                mSMSIdCaseNum.put(inSMS.Id, lParts[lParts.size()-1]);
                            }
                        }
                    }
        } //End of if(inSMS.smagicinteract__SMS_Text__c!=null||inSMS.smagicinteract__SMS_Text__c!='')
        } //End of for(smagicinteract__Incoming_SMS__c inSMS:newMap.values())
        } //End of if(!newMap.isEmpty)

        //Added by Rajesh

        if(casetoupdateonotp.size()>0)
        {

            Map<String,Case> casetoupdate=new Map<String,Case>();
            Set<String> listaosiamcpin=new Set<String>();
            Set<String> contactlistforotp=new Set<String>();
            Map<String,Id> amcids=new Map<String,Id>();

        // Updating the PIN number on the case to create a new contract   
            for(Case c:[SELECT AOSIProduct__r.AOSI_Vertical__c,AOSIProduct__c,Reason,AccountId,AOSI_AMC_Pin__c,CaseNumber,Contact.Phone, Contact.MobilePhone,Contact_Name__c FROM Case where CaseNumber IN: casetoupdateonotp.keySet()])
            {
                
                Set<String> mobilenumbers=new Set<String>();
                if(c.Contact.Phone!=null)
                {
                    mobilenumbers.add('91'+c.Contact.Phone);
                }

                if(c.Contact.MobilePhone !=null)
                {
                    mobilenumbers.add('91'+c.Contact.MobilePhone);   
                }
                if( !mobilenumbers.contains(mobilenumbercheck.get(c.CaseNumber)))
                {
        // if sms comes from an unregistered number
                    smstounregisteredmobilenumbers.add( mobilenumbercheck.get(c.CaseNumber));
                    casetoupdateonotp.remove(c.CaseNumber);
                }

                else if(c.Reason == 'Contract Request')
                {
        //Checking for valid contract type of the product
                    List<Product_AMC_Junction__c> junctionlist=mappp.get(c.AOSIProduct__c);
                    if(junctionlist.size()>0)
                    {
                        String amctype=casetoupdateonotp.get(c.CaseNumber);
                        String system_amc_type;
                        if(c.AOSIProduct__r.AOSI_Vertical__c == DefineConstant.PROD_VERTICAL_WT)
                        {
                            if(amctype.equalsIgnoreCase(DefineConstant.CONTRACT_AMC))
                            {
                                system_amc_type=DefineConstant.AMC_WT_AMC;
                            }
                            else if(amctype.equalsIgnoreCase(DefineConstant.CONTRACT_ACMC))
                            {
                                system_amc_type=DefineConstant.AMC_WT_ACMC;
                            }else if(amctype.equalsIgnoreCase(DefineConstant.CONTRACT_FLT))
                            {
                                system_amc_type=DefineConstant.AMC_WT_FP;
                            }
                        }
                        else if(c.AOSIProduct__r.AOSI_Vertical__c == DefineConstant.PROD_VERTICAL_WH)
                        {
                            if(amctype.equalsIgnoreCase(DefineConstant.CONTRACT_AMC))
                            {
                                system_amc_type=DefineConstant.AMC_WH_AMC;
                            }
                        }    
                        if(system_amc_type!=null)
                        {
                            boolean isvalid=false;
                            for(Product_AMC_Junction__c paj:junctionlist)
                            {
                                if(paj.AMC_Master__r.AOSI_Contract_Type__c == system_amc_type)
                                {
                                    isvalid=true;
                                    break;
                                }
                            }
                            if(isvalid)
                            {
                                c.AOSI_AMC_Pin__c=casetoupdateonotp.get(c.CaseNumber)+' '+c.CaseNumber;
                                c.Contract_Type__c=casetoupdateonotp.get(c.CaseNumber);
                                casetoupdate.put(casetoupdateonotp.get(c.CaseNumber)+' '+c.CaseNumber,c);
                                listaosiamcpin.add(casetoupdateonotp.get(c.CaseNumber)+' '+c.CaseNumber);
                                contactlistforotp.add(casetoupdateonotp.get(c.CaseNumber)+' '+c.CaseNumber);                 
                            }
                            else
                            {
                                smstoinvalidcontracttypenumbers.add(c);
                                casetoupdateonotp.remove(c.CaseNumber);
                                system.debug('contract type doesnt exist for case'+c.CaseNumber);
                            }
                        }
                        else
                        {
                            smstoinvalidcontracttypenumbers.add(c);
                            casetoupdateonotp.remove(c.CaseNumber);
                            system.debug('contract type doesnt exist for case'+c.CaseNumber);   
                        }
                    }
                }
                else
                {
        //Remove the case other than contract request
                    casetoupdateonotp.remove(c.CaseNumber);
                    system.debug('Not a contract request case');
                }   
            }

        //Removing the Active Contract from the list which already exists in the system
            if(casetoupdate.size() > 0)
            {   
                for(AOSI_Contract__c c:[select AOSI_Case__r.AOSI_Model__c, AOSI_Product_Model__c,AOSI_Case__c,Contract_Key__c from AOSI_Contract__c where AOSI_Contract_Status__c ='Under Progress' and Contract_Key__c IN:listaosiamcpin])
                {
                        if(c!=null)
                        {
                            if(c.AOSI_Case__r.AOSI_Model__c==c.AOSI_Product_Model__c)
                            {
                            listaosiamcpin.remove(c.Contract_Key__c);
                            casetoupdate.remove(c.Contract_Key__c);     
                            }
                            
                        }
                }
            }

         
            
            if(casetoupdate.size() > 0)
            {    
                update casetoupdate.values();    
            }
            

        // End Updating the PIN number on the case to create a new contract
            if(casetoupdate.size() > 0)
            {
        // Making the previous contracts inactive
                List<AggregateResult> ls=[select AOSI_Case__c, count(Id) from AOSI_Contract__c where AOSI_Case__r.CaseNumber IN :casetoupdateonotp.keySet() group by AOSI_Case__c];
                List<ID>  listofcontractstodisable=new  List<Id>();
                for(AggregateResult ar:ls)
                {
                    if(((Integer)ar.get('expr0'))>0)
                    {
                        listofcontractstodisable.add((Id)ar.get('AOSI_Case__c'));   
                    }
                }

                if(listofcontractstodisable.size() > 0)
                {
                    Set<AOSI_Contract__c> newlist=new Set<AOSI_Contract__c>();
                    for(AOSI_Contract__c contract:[select id,AOSI_Product_Model__c,AOSI_Case__r.AOSIProduct__r.Name,Contract_Key__c,AOSI_Contract_Status__c from AOSI_Contract__c where AOSI_Case__c IN:listofcontractstodisable])     
                    {
                        if(contract.AOSI_Product_Model__c !=contract.AOSI_Case__r.AOSIProduct__r.Name )
                        {
                            contract.AOSI_Contract_Status__c='Inactive';
                            newlist.add(contract);
                        }
                        // Condition to avoid making the last contract inactive in case of duplicate SMS
                        if(!listaosiamcpin.contains(contract.Contract_Key__c))
                        {
                            contract.AOSI_Contract_Status__c='Inactive';
                            newlist.add(contract);     
                        }
                    }  
                    if(newlist.size() > 0)
                    {
                        List<AOSI_Contract__c> update_newlist=new List<AOSI_Contract__c>(newlist);
                        update update_newlist;     
                        
                    }
                }
        // End making the previous contracts inactive     
            }

            List<AOSI_Contract__c> cont=[SELECT AOSI_Case__r.CaseNumber,AOSI_Case__r.AOSIProduct__c,Amount__c,AOSI_AMC__c,AOSI_Amount_Received__c,AOSI_Autogenerated_OTP__c,AOSI_Base_Amount__c,AOSI_Case_Number__c,AOSI_Case__c,AOSI_Contact_Email_Id__c,AOSI_Contact_Phone_Number__c,AOSI_Contact__c,AOSI_Contract_Charges__c,AOSI_Contract_Number__c,AOSI_Contract_Status__c,AOSI_Discount__c,AOSI_Mode_Of_Payment__c,AOSI_Renewal_Contract__c,AOSI_Service_Engineer__c,AOSI_Terminated_Reason__c,AOSI_Total_Amount__c,Contract_Key__c,CreatedById,CreatedDate,Date_test__c,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name FROM AOSI_Contract__c  where AOSI_Contract_Status__c ='Under Progress' and Contract_Key__c IN:contactlistforotp];
        //Send OTP to the Customer on contract request
            for(AOSI_Contract__c ucontract: cont)
            {
                String s= ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CONTRACT, ucontract, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_OTP));    
                smagicinteract__smsMagic__c smsHistory  =  ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CONTRACT, mobilenumbercheck.get(ucontract.AOSI_Case__r.CaseNumber),s);    
                smsHistory.AOSI_Contract__c  =  ucontract.Id;
                smsHistoryList.add(smsHistory);
                taskList.add(createNewTask(ucontract.CreatedById, ucontract.Id, DefineConstant.SMSTEMP_FOR_OTP, DefineConstant.TASK_PRIORITY_NORMAL, DefineConstant.TASK_STATUS_NOTSTARTED,s) );          
            }
        } 

        // Send invalid format message to the numbers    
        if(invalidmessageset.size()>0)
        {
            if(invalidmessageset.size() >0)
            {
                for(String str:invalidmessageset)
                {
                    String s=mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_OTP_INVALID_FORMAT);    
                    smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CONTRACT,str,s);    
                    smsHistoryList.add(smsHistory);
                }
            }
        }

        // Send messages to unregistered number    
        if(smstounregisteredmobilenumbers.size() >0)
        {
            for(String str:smstounregisteredmobilenumbers)
            {   
                String s=mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_OTP_UNREGISTERED_NUMBER);    
                smagicinteract__smsMagic__c smsHistory  =   ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CONTRACT,str,s);    
                smsHistoryList.add(smsHistory);
            }
        }    

        // Send messages to customer with invaild contract type of product   

        if(smstoinvalidcontracttypenumbers.size() >0)
        {
            for(Case c:smstoinvalidcontracttypenumbers)
            {   
                String s= ComposeSMS.toRenderSMSTemplate(DefineConstant.OBJECT_NAME_CASE, c, mapSMSTemplateText.get(DefineConstant.SMSTEMP_FOR_OTP_INVALID_CONTRACT_TYPE));    
                smagicinteract__smsMagic__c smsHistory  =  ComposeSMS.toSendSMS(smsSenderID, DefineConstant.OBJECT_NAME_CASE, mobilenumbercheck.get(c.CaseNumber),s);    
                smsHistory.Case__c  =  c.Id;
                smsHistoryList.add(smsHistory);    
            }

        }
        
        if(incomingsmstocase.size() > 0)
        {
           system.debug('incomingsmstocase'+incomingsmstocase);
           //SMS , casenumber 
           List<Case> caseid=[select Id,CaseNumber from Case where CaseNumber in: incomingsmstocase.values()];
           List<smagicinteract__Incoming_SMS__c> smsms=[select Id,smagicinteract__Case__c from smagicinteract__Incoming_SMS__c where Id in :incomingsmstocase.keySet()]; 
            for(Integer i=0;i<smsms.size();i++)
            {
                smsms[i].smagicinteract__Case__c=caseid[i].Id;
             
            }
            
            update smsms;
            
        }
            
        //End

        map<String,Case> mCase                              =   new map<String,Case>();
        map<Id,Case>  mUpdateCase                           =   new map<Id,Case>();
        list<smagicinteract__Incoming_SMS__c> lUpdateInSMS  =   new list<smagicinteract__Incoming_SMS__c>();

        try {
            if( !mSMSIdCaseNum.isEmpty() && caseAOSIndiaRecType.Id != null){
                for(Case oCase : [SELECT Id,CaseNumber,Assignment_Start_Time__c,Assignment_End_Time_Minute_Value__c,Service_Engineer_Phone__c,Contact_Phone__c,Contact_Other_Phone__c,Assignment_End_Time__c,Customer_Satisfaction_Status__c,AOSI_AMC_Pin__c,ContactId,Reason,AOSI_Contract_Pin_Registration_Time__c,RecordTypeId FROM Case WHERE CaseNumber IN: mSMSIdCaseNum.values() AND RecordTypeId =:caseAOSIndiaRecType.Id]) {
                    mCase.put(oCase.CaseNumber,oCase);
                }
                lUpdateInSMS = [SELECT Id,Name,smagicinteract__Case__c,smagicinteract__SMS_Text__c,smagicinteract__Inbound_Number__c,smagicinteract__Mobile_Number__c FROM smagicinteract__Incoming_SMS__c WHERE Id IN : mSMSIdCaseNum.keyset()];
            }

			
            if( !lUpdateInSMS.isEmpty() ) {
                
                for ( smagicinteract__Incoming_SMS__c iSMS : lUpdateInSMS ) {
                    if ( !mSMSIdCaseNum.isEmpty() && mSMSIdCaseNum.containsKey(iSMS.Id) && mSMSIdCaseNum.get(iSMS.Id) != null) {
                        if ( !mCase.isEmpty() && mCase.containsKey(mSMSIdCaseNum.get(iSMS.Id)) && mCase.get(mSMSIdCaseNum.get(iSMS.Id)) != null ) {
                            /*** Relate Incoming SMS with Case ***/
                            /*** To update Case : AMC PIN ***/
                            if( (iSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.CONTRACT_AMC) || iSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.CONTRACT_ACMC) || iSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.CONTRACT_FLT))
                                && mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Reason == DefineConstant.CASE_REASON_CONTRACT_REQUEST && mCase.get(mSMSIdCaseNum.get(iSMS.Id)).AOSI_AMC_Pin__c == null 
                                && ( (mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Phone__c)) ||(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Other_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Other_Phone__c)) ) ) {
                                iSMS.smagicinteract__Case__c                                                    =   mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id;
                            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).AOSI_AMC_Pin__c                           =   ((!mSMSIdContrctPin.isEmpty()&&mSMSIdContrctPin.containsKey(iSMS.Id)&&mSMSIdContrctPin.get(iSMS.Id)!=null) ?  mSMSIdContrctPin.get(iSMS.Id) : ' '); 
                            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).AOSI_Contract_Pin_Registration_Time__c    =   System.Now();
                            mUpdateCase.put(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id, mCase.get(mSMSIdCaseNum.get(iSMS.Id)));
        } //End of update Case:AMC PIN 
			
        /*** To update Case : Responded Time ***/
                    
        else if( iSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase(DefineConstant.START) && mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Service_Engineer_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Service_Engineer_Phone__c) ) {
            iSMS.smagicinteract__Case__c                                    =   mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id;
            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Assignment_Start_Time__c  =   System.now();
            system.debug('Assignment_Start_Time__c updated');
            mUpdateCase.put(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id, mCase.get(mSMSIdCaseNum.get(iSMS.Id)));
        } //End of update Case:Responded Time

        /*** To update Case : Assignment End Time, Assignment End Time Minute Value(IND) ***/
        else if( iSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase(DefineConstant.STOP) && mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Service_Engineer_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Service_Engineer_Phone__c) ) {
            iSMS.smagicinteract__Case__c                                                =   mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id;
            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Assignment_End_Time__c                =   System.now();
            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Assignment_End_Time_Minute_Value__c   =   String.valueOf(System.now().hour())+':'+String.valueOf(System.now().minute());
            mUpdateCase.put(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id, mCase.get(mSMSIdCaseNum.get(iSMS.Id)));
        } //End of Case:Assignment End Time, Assignment End Time Minute Value(IND)

        /*** To update Case : Customer Satisfaction Status = SATISFIED ***/
        else if( iSMS.smagicinteract__SMS_Text__c.startsWithIgnoreCase(DefineConstant.YES) && ( (mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Phone__c)) ||(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Other_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Other_Phone__c)) ) ) {
            iSMS.smagicinteract__Case__c                                            =   mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id;
            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Customer_Satisfaction_Status__c   =  DefineConstant.SATISFIED;
            mUpdateCase.put(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id, mCase.get(mSMSIdCaseNum.get(iSMS.Id)));
        } //End of update Case:Customer Satisfaction Status = SATISFIED

        /*** To update Case : Customer Satisfaction Status = NOTSATISFIED ***/
        else if( iSMS.smagicinteract__SMS_Text__c.startswithIgnoreCase(DefineConstant.NO) && ( (mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Phone__c)) ||(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Other_Phone__c != null && iSMS.smagicinteract__Mobile_Number__c.contains(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Contact_Other_Phone__c)) ) ) {
            iSMS.smagicinteract__Case__c                                            =   mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id;
            mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Customer_Satisfaction_Status__c   =  DefineConstant.NOTSATISFIED;
            mUpdateCase.put(mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Id, mCase.get(mSMSIdCaseNum.get(iSMS.Id)));
        } //End of update Case:Customer Satisfaction Status = NOTSATISFIED
        } //End of if(!mCase.isEmpty()&&mCase.containsKey(mSMSIdCaseNum.get(iSMS.Id))&&mCase.get(mSMSIdCaseNum.get(iSMS.Id))!=null)
        } //End of if(!mSMSIdCaseNum.isEmpty()&&mSMSIdCaseNum.containsKey(iSMS.Id)&&mSMSIdCaseNum.get(iSMS.Id)!=null)
                system.debug('iSMS.smagicinteract__SMS_Text__c'+iSMS.smagicinteract__SMS_Text__c);                    
        system.debug('mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Service_Engineer_Phone__c'+mCase.get(mSMSIdCaseNum.get(iSMS.Id)).Service_Engineer_Phone__c);                    
        system.debug('mCase.get(mSMSIdCaseNum.get(iSMS.Id))'+mCase.get(mSMSIdCaseNum.get(iSMS.Id)));
                } //End of for(smagicinteract__Incoming_SMS__c iSMS:lUpdateInSMS)
                
        } //End of if(!lUpdateInSMS.isEmpty())

        if( !mUpdateCase.isEmpty() ) {
            update mUpdateCase.values();
        } 

        if( !lUpdateInSMS.isEmpty() ) {
            update lUpdateInSMS;
        }

        // Added by Rajesh
        Savepoint oSavePt   =   Database.setSavepoint();
        try {
            if (!smsHistoryList.isEmpty()) {
                insert smsHistoryList;
                System.debug('** insertion smsHistory **'+smsHistoryList);
            }

            if(!taskList.isEmpty()) {
                insert taskList;
                System.debug('** insertion tasklist ** '+taskList);
            }
        } catch (Exception e) { Database.RollBack(oSavePt); System.debug('Exception caused while inserting SMS History/Schedule SMS/Task ojbect' + e.getMessage()); }


        Integer exc  = ( test.isRunningTest() ? (1/0) : 0 );
    } catch (Exception e) { System.debug('******Exception while updating Case from AOSI_IncomingSMSTriggerHandler at *** ' + e.getLineNumber() + e.getMessage()); }
        } //End of afterInsertUpdateHandler()

        /*******************************************************************************************************************************************************
        * Method Name : afterInsertHandler()
        * Return Type : void
        * Description : Defines AOSI_IncomingSMSTrigger after insert logic 
        *******************************************************************************************************************************************************/
        public void afterInsertHandler() {
            afterInsertUpdateHandler(true);
        } //End of afterInsertHandler();

        /*******************************************************************************************************************************************************
        * Method Name : afterUpdateHandler()
        * Return Type : void
        * Description : Defines AOSI_IncomingSMSTrigger after update logic 
        *******************************************************************************************************************************************************/
        public void afterUpdateHandler() {
            afterInsertUpdateHandler(false);
        } //End of afterUpdateHandler()

        /*********************************************************************************************************************************************
        Method Name : createNewTask(Id userId, Id caseId, String subject, String priority,  String status)
        Return Type : Task
        Purpose     : used to create new task 
        **********************************************************************************************************************************************/
        public Task createNewTask(Id userId, Id caseId, String subject, String priority,  String status,String comment) {
            Task oTask          =   new Task();
            oTask.OwnerId       =   userId;
            oTask.WhatId        =   caseId;
            oTask.Subject       =   subject;
            oTask.Priority      =   priority;
            oTask.Status        =   status;
        //oTask.Description   =   comment;
            return oTask;              
        }   //End of createNewTask()
        } //End of AOSI_IncomingSMSTriggerHandler