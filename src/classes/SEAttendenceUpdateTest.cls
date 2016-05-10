/*=============================================================================================
CreatedBy : Vishwanath Attikeri(KVP business solution)
ModifiedBy :
Description : Test class for SEattendenceUpdate
=================================================================================================*/
@isTest
public class SEAttendenceUpdateTest{
    public static testMethod void test1(){
        
        Service_Engineer__c se = new Service_Engineer__c();
        se.Name = 'Test';
        se.Mobile_Number__c = '9222222222';
        se.AOSI_Active__c = TRUE;
        insert se;
        
        Attendence__c att = new Attendence__c();
        att.AOSI_Service_Engineer__c = se.id;
        att.AOSI_Date__c = Date.Today()+10;
        //insert att;
        
        SEAttendenceUpdate SEU = new SEAttendenceUpdate();
        SEU.getregiondata();
        SEU.getstatedata();
        SEU.getcitydata();
        SEU.getServEnggType();
        SEU.displaySE();
        SEU.save();
        
    }
}