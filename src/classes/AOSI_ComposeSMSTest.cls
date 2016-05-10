/*************************************************************************************************************************
 * Class Name   : AOSI_ComposeSMSTest
 * Created By   : Pooja P Bhat
 * Created Date : 08-OCTOBER-2015
 * Description  : Test class for ComposeSMS Class 
 * Methods      : static testMethod void myUnitTest()
**************************************************************************************************************************/
@isTest
private class AOSI_ComposeSMSTest{

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.startTest();
        
        String smsSenderId = '';
        String smsTempText = '';
        smagicinteract__SMS_Template__c smsTempobj = new smagicinteract__SMS_Template__c();
        list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
        insert recordTypes;
        for ( RecordTypeDetails__c oRec : recordTypes ) {
            if(oRec.Name.equalsIgnoreCase('SMS SenderID') && oRec.Developer_Name__c.equalsIgnoreCase('AOSSVC'))
                smsSenderId = oRec.Developer_Name__c;
        }
        smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
        insert senderId;
        
        list<AOSI_Time_Calculation_Settings__c> lTimeSettng =   TestHelpUtility.getTimeCalCustSttng();
        insert lTimeSettng;
        
        List<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
        insert smsTemplate;
        for ( smagicinteract__SMS_Template__c oSMS : smsTemplate ) {
            if(oSMS.smagicinteract__Name__c.equalsIgnoreCase('SMS on Case for Installation')) {
                smsTempText = oSMS.smagicinteract__Text__c;
                smsTempobj  = oSMS;
            }               
        }
        
        Pin_Master__c oPin  =   TestHelpUtility.getPinMaster('565444', 'South', 'Bangalore', 'Karnataka');
        insert oPin;
        
        Account oAcc    =   TestHelpUtility.getNewAccount('Test Account', oPin);
        insert oAcc;
        
        Contact oContact    =   TestHelpUtility.getContact(oAcc, oPin);
        oContact.Lastname       =   'Test contact';
        insert oContact;
        
        Product2 oProd  =   TestHelpUtility.getProduct();
        oProd.AOSI_Vertical__c    =    DefineConstant.PROD_VERTICAL_WH;
        insert oProd;
        
        Asset oAsset    =   TestHelpUtility.getAsset(oContact, oProd);
        insert oAsset;
        
        Case oCaseInstall                       =   TestHelpUtility.getCase(oContact, oAsset, oProd);
        oCaseInstall.Reason                     =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_Customer_Concern__c   =   DefineConstant.CASE_REASON_FREE_INSTALLATION;
        oCaseInstall.AOSI_City__c               =   'Bangalore';
        
        AOSI_Contract__c oContract              =   new AOSI_Contract__c();
        oContract.Name                          =   'AMC 12345';
        oContract.AOSI_Asset__c                 =   oAsset.Id;                           
        oContract.AOSI_Contact_Email_Id__c      =   'test@aosmith.com';
        oContract.AOSI_Contact_Phone_Number__c  =   '9052871852';
        oContract.AOSI_Start_Date__c            =   System.today(); 
                            
        try { 
            insert oCaseInstall;
            insert oContract;
        } catch ( Exception e ) { System.debug('****** ComposeSMSTest Exception while inserting case' + e);}
        
        case csFreeinstall = [SELECT Id,CaseNumber,Reason,Contact_name__c,AOSI_Customer_Concern__c,AOSI_City__c FROM Case WHERE Reason =: DefineConstant.CASE_REASON_FREE_INSTALLATION LIMIT 1];
        
        String renderedText1 = ComposeSMS.toRenderTemplate('Hello, {!Case.contact_name__c} ' + smsTempobj.smagicinteract__Text__c, 'Case', csFreeinstall.Id);
        String renderedText2 = ComposeSMS.toRenderSMSTemplate( smsTempobj.smagicinteract__ObjectName__c, csFreeinstall, smsTempobj.smagicinteract__Text__c ); 
        String renderedText3 = ComposeSMS.toRenderSMSTemplate( 'AOSI_Contract__c', oContract, smsTempobj.smagicinteract__Text__c ); 
        ComposeSMS.toSendSMS(smsSenderId, 'Case', '9632828880', 'Test SMS' );
        
        system.assertEquals(renderedText2, smsTempobj.smagicinteract__Text__c, 'renderedText2 matches');
        
        test.stopTest();
    }
    
}