@isTest
public class AOSI_Restrict_Duplicate_Survey_Test{
    static testMethod void testMethodOne(){
        Pin_Master__c pinMaster = TestHelpUtility.getPinMaster('560050', 'India', 'Blore', 'State');
        Account acc = TestHelpUtility.getNewAccount('Test Account',pinMaster);
        Contact con = TestHelpUtility.getContact(acc, pinMaster);
        Product2 prod2 = TestHelpUtility.getProduct();
        Asset ast = TestHelpUtility.getAsset(con, prod2);
        Case cs = TestHelpUtility.getCase(con, ast, prod2);
        
        TIMBASURVEYS__Survey_Summary__c ts1 = new TIMBASURVEYS__Survey_Summary__c();
        ts1.Name = 'Test Survey';
        ts1.TIMBASURVEYS__RelatedCase__c = cs.Id;
        insert ts1;
        
        TIMBASURVEYS__Survey_Summary__c ts2 = new TIMBASURVEYS__Survey_Summary__c();
        ts2.Name = 'Test Survey';
        ts2.TIMBASURVEYS__RelatedCase__c = cs.Id;
        try{
            insert ts2;
        }Catch(Exception e){}
        
    } 
}