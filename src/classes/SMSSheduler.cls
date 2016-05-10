global class SMSSheduler implements Schedulable{
   global void execute(SchedulableContext SC) { 
     //Batch class and method to send SMS for cases closed at night
     Database.executeBatch(new BatchSMS (),1);
       
   }
}