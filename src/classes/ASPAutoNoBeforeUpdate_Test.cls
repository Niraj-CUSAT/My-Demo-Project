@isTest
public Class ASPAutoNoBeforeUpdate_Test{
    public Static TestMethod void AspAutoUpdateTest(){
        ASP__c Asp = new ASP__c();
        Asp.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp.AOSI_Company_Name__c = 'Test__Com';
        Asp.AOSI_Approval_Status__c= 'Pending';
        Asp.AOSI_Mobile_No__c = '8080808080';
        Asp.AOSI_WATER_HEATER_I_W__c =1; 
        insert Asp;
        
        Asp.AOSI_Approval_Status__c= 'Approved';
        Update Asp;
        
        ASP__c Asp1 = new ASP__c();
        Asp1.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp1.AOSI_Company_Name__c = 'Test__Com';
        Asp1.AOSI_Approval_Status__c= 'Pending';
        Asp1.AOSI_Mobile_No__c = '8080808080';
        Asp1.AOSI_WATER_HEATER_I_W__c =1; 
        insert Asp1;
        
        Asp1.AOSI_Approval_Status__c= 'Approved';
        
        Update Asp1;
        
        Asp1.AOSI_Agreement_Number__c = 'AOS/SVC/0009';
        Update Asp1;
        
        ASP__c Asp2 = new ASP__c();
        Asp2.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp2.AOSI_Company_Name__c = 'Test__Com';
        Asp2.AOSI_Approval_Status__c= 'Pending';
        Asp2.AOSI_Mobile_No__c = '8080808080';
        Asp2.AOSI_WATER_HEATER_I_W__c =1; 
        insert Asp2; 
        Asp2.AOSI_Approval_Status__c= 'Approved';               
        Update Asp2;
        Asp2.AOSI_Agreement_Number__c = 'AOS/SVC/0099';
        Update Asp2;
        
        ASP__c Asp3 = new ASP__c();
        Asp3.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp3.AOSI_Company_Name__c = 'Test__Com';
        Asp3.AOSI_Approval_Status__c= 'Pending';  
        Asp3.AOSI_Mobile_No__c = '8080808080';
        Asp3.AOSI_WATER_HEATER_I_W__c =1;      
        insert Asp3; 
        Asp3.AOSI_Approval_Status__c= 'Approved';               
        Update Asp3; 
        
        ASP__c Asp4 = new ASP__c();
        Asp4.AOSI_Account_Name_Firm_Person__c = 'Test_ACC';
        Asp4.AOSI_Company_Name__c = 'Test__Com';
        Asp4.AOSI_Approval_Status__c= 'Pending';
        Asp4.AOSI_Mobile_No__c = '8080808080';
        Asp4.AOSI_Renewal__c = true;
        Asp4.AOSI_WATER_HEATER_I_W__c =1; 
        insert Asp4; 
        Asp4.AOSI_Approval_Status__c= 'Approved';               
        Update Asp4;
        ASP__c Aspnew = [Select id,AOSI_Agreement_Number__c from ASP__c where Id =: Asp1.id];
        System.assertNotEquals(Aspnew.AOSI_Agreement_Number__c,null);                
    }
}