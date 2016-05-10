@isTest
public Class photoValidationforASP_Test{
    public static testmethod void aspTest(){
        ASP__c Asp = new ASP__c();
        Asp.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp.AOSI_Company_Name__c = 'Test__Com';
        Asp.AOSI_Approval_Status__c= 'Submit For Approval';
        Asp.AOSI_Mobile_No__c = '8080808080';
        Asp.AOSI_WATER_HEATER_I_W__c =1; 
        insert Asp;
        
        Attachment att = new Attachment();
        att.Name = 'test.jpg';
        att.parentid = Asp.id;
        att.Body=blob.valueOf('body');
        insert att;
        
        delete att;      
    }
}