trigger SendSMSonCase on Case (before insert ,after insert,after update,before update ) {
   /*  if( RecursionMonitor.recursionCheck.contains('SendSMSonCase')){
     return;
     }
     else{
     RecursionMonitor.recursionCheck.add('SendSMSonCase');
     } 
     */     
  // This trigger is used to send SMS for Installation,Color Panel Registration and Complaint Registration to customer, 
  //also it will update the SMSFiringTime__c  field on case to store the time delay(30 mins) from the time a service enginner is assigned to a case
   Id recordtypeId =  [Select id from Recordtype where DeveloperName =:'AOSIndia' AND SobjectType =: 'Case' ].id;
   System.debug( ( recordtypeId == trigger.new[0].RecordTypeID ));
   
   
   
   if ( recordtypeId == trigger.new[0].RecordTypeID && trigger.new[0].parentid==null) 
   {
        
      if( (trigger.isbefore) && (trigger.isinsert) )
      {
           trigger.new[0].SMS_Status__c  =  'SMS_HAS_TO_BE_SEND';
           
           if( ( ( ( System.now() ).hour() ) >= 6  ) && ( ( ( System.now() ).hour() ) <= 20  ) ) // Changed from 7 to 6
           {
              trigger.new[0].SMS_Status__c  =  'SMS_SENT_BY_TRIGGER';
           }
      }
      if( (trigger.isbefore)  )
      { 
        
         if( trigger.new[0].Service_Engineer__c != null )
         {
            if(  (system.now()).hour() > 18 )  
             trigger.new[0].SMSFiringTime__c  =  ( system.now() ).addHours( 12 );
            else
            if( ( system.now()).hour() < 7 )
             trigger.new[0].SMSFiringTime__c  =  ( system.now() ).addHours( 7 );
            else
              trigger.new[0].SMSFiringTime__c = system.now().addMinutes(10);

         }
         if( ( trigger.new[0].Status == 'Closed' ) && ( trigger.oldmap.get(Trigger.new[0].id).status != 'Closed' ) ) 
         { 
            if(  (system.now()).hour() > 18 )  
             trigger.new[0].FeedbackSMS_Firing_Time__c =  ( system.now().addDays(2) ).addHours( 12 );
            else
            if( ( system.now()).hour() < 7 )
             trigger.new[0].FeedbackSMS_Firing_Time__c =  ( system.now().addDays(2) ).addHours( 7 );
            else
             trigger.new[0].FeedbackSMS_Firing_Time__c =  system.now().addDays(2) ;
         }
      } 
        
      if( (trigger.isafter) && (trigger.isinsert) )
      {
           try
           { 
           
           if( ( ( ( trigger.new[0].createddate).hour() ) >= 7  ) && ( ( ( trigger.new[0].createddate).hour() ) <= 20  ) )
           {
               smagicinteract__SMS_Template__c SMS_Template;
               if( ( trigger.isinsert ) && ( trigger.new[0].recordtypeID == recordtypeId ) && (  trigger.new[0].Reason == 'Free Installation' || trigger.new[0].Reason == 'Chargeable Installation'  ) && trigger.new[0].parentId == null )
               {   
                     SMS_Template  = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case for Installation'];  
                     sendSMSfromTrigger.sendMethod( SMS_Template.smagicinteract__Text__c,trigger.new[0],trigger.new[0].Contact_Phone__c);                                      
               }
               
               if( ( trigger.isinsert ) && ( trigger.new[0].recordtypeID == recordtypeId ) && (  trigger.new[0].Reason  == 'Color Panel (Free)' ||  trigger.new[0].Reason  == 'Color Panel (Chargeable)' ) && trigger.new[0].parentId == null  )
               {   
                    SMS_Template = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case for Color Panel Registration'];  
                    sendSMSfromTrigger.sendMethod( SMS_Template.smagicinteract__Text__c,trigger.new[0],trigger.new[0].Contact_Phone__c);
                    
                    
               }
                
               if( ( trigger.isinsert ) && ( trigger.new[0].recordtypeID == recordtypeId ) && (  trigger.new[0].Reason   == 'Service' ||  trigger.new[0].Reason   == 'Dealer Stock' || trigger.new[0].Reason   == 'Contract Request') && trigger.new[0].CC_SSV__c!=True )
               {   
                    SMS_Template = [ Select id , smagicinteract__Text__c , Name from  smagicinteract__SMS_Template__c where smagicinteract__Name__c=: 'SMS on Case for Complaint Registration'];  
                    sendSMSfromTrigger.sendMethod( SMS_Template.smagicinteract__Text__c,trigger.new[0],trigger.new[0].Contact_Phone__c);
                    
                   
               }
           
           }
            
          }
          catch(Exception e)
          {
          }
          
        }  
     }
}