@istest
private class TestAddServiceCharges {

    static testmethod  void AddServiceCharges() {

        PageReference pageRef = Page.CloseCase;
        Test.setCurrentPageReference(pageRef);

        test.startTest();
        
            Id caseAOSIRecTy    =   [SELECT Id,Name FROM RecordType WHERE  DeveloperName =:'AOSI' and SobjectType =:'Case' LIMIT 1].Id;
            
            list<RecordTypeDetails__c> recordTypes    =  TestHelpUtility.getRecTyCustomSettings();
            insert recordTypes;
            
            list<AOSI_Time_Calculation_Settings__c> oTCS    =   TestHelpUtility.getTimeCalCustSttng();
            insert oTCS;
            
            smagicinteract__SMS_SenderId__c senderId   =  TestHelpUtility.getSMSSenderID();
            insert senderId;
            
            list<smagicinteract__SMS_Template__c> smsTemplate  =  TestHelpUtility.getSMSTemplate(DefineConstant.OBJECT_NAME_CASE);  
            insert smsTemplate;
            
            City_Master__c cityMasterSouth  =   TestHelpUtility.getCityMaster('Chennai', 'South', 'Karnataka', 'Chennai'); 
            insert cityMasterSouth;
            
            Pin_Master__c oPinMasterSouth   =   TestHelpUtility.getPinMaster('600114', 'South', 'Chennai', 'Karnataka'); 
            insert oPinMasterSouth;
           
            Account oAcc                    =   TestHelpUtility.getNewAccount('Test Color Panel',oPinMasterSouth);
            insert oAcc;
            
            Contact oContactSouth           =   TestHelpUtility.getContact(oAcc, oPinMasterSouth);    
            insert oContactSouth;
              
            Product2 oProdWT                                =   TestHelpUtility.getProduct();
            oProdWT.Name                                    =   'WT-TEST-PROD1';
            oProdWT.AOSI_Vertical__c                        =   DefineConstant.PROD_VERTICAL_WT;
            oProdWT.AOSI_Family__c                          =   'Water Purifier';
            oProdWT.AOSI_Product_Code_for_Serial_Number__c  =   'B082';
            insert oProdWT;
             
            Asset oAsset                        =   TestHelpUtility.getAsset(oContactSouth, oProdWT);
            oAsset.Name                         =   'B0820104041233';
            oAsset.AOSI_Membrane_Warranty__c    =   DefineConstant.ASSET_MEMBRANE_WRRTY_2YRS;
            insert oAsset;
            
     
            Case oCase1                         =   TestHelpUtility.getCase(oContactSouth, oAsset, oProdWT);
            oCase1.Reason                       =   DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE;
            oCase1.AOSI_Customer_Concern__c     =   DefineConstant.CASE_REASON_COLORPANEL_CHARGEABLE;
            oCase1.AOSI_Preferred_Color__c      =   'Red Brick';
            insert oCase1;
            
            Service_Engineer__c se = new Service_Engineer__c();
            se.Name = 'Test SE';
            se.Mobile_Number__c = '8080808080';
            se.Region__c='South';
            se.State__c='Andra Pradesh';
            se.AOSI_City__c='Hyderabad'; 
            se.AOSI_Active__c = true;  
            se.City_Master__c=cityMasterSouth.id;
            insert se;
            
            oCase1.Service_Engineer__c = se.Id;
            update oCase1;
            
            ApexPages.StandardController sc = new ApexPages.standardController(oCase1);
            apexpages.currentpage().getparameters().put('Id',oCase1.id);
            AddServiceCharges sch = new AddServiceCharges(sc);

            sch.addmore();
            sch.SaveCharges();
            sch.deleterow();
            sch.deleterow();
            sch.SaveCharges();
            sch.save();
            Service_Charges__c scr = new Service_Charges__c();
            scr.Case__c = oCase1.id;
            scr.Type__c = 'Visit Charges';
            scr.Quantity__c = 1;
            insert scr;
            
            Case_Customer_Concern__c  ccustcon=new Case_Customer_Concern__c ();
            ccustcon.case__c=oCase1.id;
            ccustcon.Customer_Concern__c='Color Panel (Chargeable)';
            ccustcon.Reason__c='Other';
            ccustcon.Action__c='Replaced';
            insert ccustcon;
            sch.addmore1();
            sch.deleterow1();
            sch.SaveCustomerconsern();
            sch.addmore();
            scr.Quantity__c = 2;
            sch.SaveCharges();
            
            Spares__c sp = new Spares__c();
            sp.Name ='Spare 123';
            sp.Type__c= 'Spare Part';
            sp.Part_Type__c='Pre Filter';
            insert sp;
            
            Spare_Product_Junction__c oSPJ    =    new Spare_Product_Junction__c();
            oSPJ.Product__c                   =    oProdWT.Id;
            oSPJ.Spares__c                    =    sp.Id;
            insert oSPJ;
            
            Service_Charges__c scr2 = new Service_Charges__c();
            scr2.Case__c = oCase1.id;
            scr2.Type__c = 'Part Replacement';
            scr2.Quantity__c = 1;
            scr2.spares__c = sp.id;
            scr2.Asset_Status_Hidden__c='In Contract';

            insert scr2;
        test.stopTest();
    }
}