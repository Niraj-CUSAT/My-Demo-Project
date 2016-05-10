/*
crated By: Bhanu Vallabhu, Created On : 
*/
public class AddServiceCharges {
        public string caseStatus{get;set;}
        public ApexPages.StandardController sController;  
        public boolean showRefund {get;set;}
        public case cc{get;set;}
        public case currentcase{get; set;}
        public String selectedAssetatatus{get;set;}
        public List<Service_Charges__c> defaultlist{get;set;}
     
    //Code added by vishwanath 
    Public String Customercon;
    public List<Case_Customer_Concern__c> Customerconsernlist{get;set;}
    
    public AddServiceCharges(ApexPages.StandardController controller) {
        sController = controller;  
        cc = (case)controller.getRecord();
        currentcase = [select Id,casenumber,Assetid,Asset.AOSI_Asset_Status__c,AOSI_Category_of_Sales_Query__c,Status,AOSI_Cash_Receipt__c from Case where Id =: ApexPages.currentPage().getParameters().get('id') ];
        if(currentcase.AssetId !=Null){
            selectedAssetatatus = currentcase.Asset.AOSI_Asset_Status__c;
        }
        Customercon=cc.AOSI_Customer_Concern__c;
        // system.debug('CCCCCCCCCCCCC'+cc.AOSI_Customer_Concern__c);             
        defaultlist = [select id,Name,Type__c,Spares__c,Quantity__c,Case__c,Final_Charges__c,AmountMRP__c,MRP_Charges__c,Chargable__c   from Service_Charges__c where Case__c =: Apexpages.currentPage().getParameters().get('Id') ORDER by CreatedDate];
        Customerconsernlist=[select id,Reason__c,Customer_Concern__c,Cause__c,Action__c,Case__c,Call_Category_Type__c  from Case_Customer_Concern__c where Case__c=:Apexpages.currentPage().getParameters().get('Id') ORDER by CreatedDate];
     system.debug('AddServiceCharges**Customerconsernlist'+Customerconsernlist);   
    }
    
    //Added by vishwanath
    public void addmore1() {
        Case_Customer_Concern__c CC = new Case_Customer_Concern__c();
        CC.Case__c = Apexpages.currentPage().getParameters().get('Id');
        CC.Customer_Concern__c=Customercon;
        insert CC;
        Customerconsernlist.add(CC);
    }
    
    public void deleterow1(){
        integer row = Customerconsernlist.Size();
        if(Customerconsernlist.size()>0){
            delete Customerconsernlist[row-1];
            Customerconsernlist= [select id,Reason__c,Customer_Concern__c,Cause__c,Action__c,Case__c,Call_Category_Type__c  from Case_Customer_Concern__c where Case__c=:Apexpages.currentPage().getParameters().get('Id') ORDER by CreatedDate];
           // system.debug('-----------'+Customerconsernlist.size());    
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No row to delete ');
            ApexPages.addMessage(myMsg);
        }
    }
        
    public void SaveCustomerconsern() {
        try {
                if(Customerconsernlist.size()>0) {
                        update Customerconsernlist;
                        Customerconsernlist= [select id,Reason__c,Customer_Concern__c,Cause__c,Action__c,Case__c,Call_Category_Type__c from Case_Customer_Concern__c where Case__c=:Apexpages.currentPage().getParameters().get('Id') ORDER by CreatedDate];
                } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Customer concern to save ');
                ApexPages.addMessage(myMsg);
          }
        } catch(Exception e) {
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0) );
            ApexPages.addMessage(msg);
        }
        }
     
    public void addmore() {
        Service_Charges__c sc1 = new Service_Charges__c();
        sc1.Case__c = Apexpages.currentPage().getParameters().get('Id');
        system.debug('------currentcase.AssetId-----'+cc.AssetId);
        if(selectedAssetatatus == Null && cc.AssetId !=Null) {
                System.debug('Query run');
                Asset currentAsset = [select id,AOSI_Asset_Status__c from Asset where Id =: cc.AssetId ];
                selectedAssetatatus = currentAsset.AOSI_Asset_Status__c;
        }     
    
        if(selectedAssetatatus != Null && (selectedAssetatatus.equalsIgnorecase('Out Of Warranty') || selectedAssetatatus.equalsIgnorecase('Out of Contract')) || (cc.AssetId == Null)){
                sc1.Chargable__c='Yes';
        } else {
                sc1.Chargable__c='No';
        } 
    
        insert sc1;
        defaultlist.add(sc1);
   }
    
     public void deleterow(){
        integer row = defaultlist.Size();
        if(defaultlist.size()>0){
            delete defaultlist[row-1];
            defaultlist.remove(row-1);
            //defaultlist = [select id,Name,Type__c,Spares__c,Quantity__c,Case__c,Final_Charges__c,AmountMRP__c,MRP_Charges__c,Chargable__c   from Service_Charges__c where Case__c =: Apexpages.currentPage().getParameters().get('Id') ORDER by CreatedDate];
            system.debug('-----------'+defaultlist.size());    
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No row to delete ');
            ApexPages.addMessage(myMsg);
        }
     }
     
    public void SaveCharges() {
        try {
                if(defaultlist.size()>0) {
                        update Defaultlist;
                        defaultlist = [select id,Name,Type__c,Spares__c,Quantity__c,Case__c,Final_Charges__c,AmountMRP__c,MRP_Charges__c,Chargable__c  from Service_Charges__c where Case__c =: Apexpages.currentPage().getParameters().get('Id') ORDER by CreatedDate];
                } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Charges to Save ');
                ApexPages.addMessage(myMsg);
           }
       } catch(Exception e) {
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0) );
            ApexPages.addMessage(msg);
       }
    }
     
          
       //added by Tanay 
        public  List<Case_Customer_Concern__c> Replacedlist=new List<Case_Customer_Concern__c>();
        public  List<Service_Charges__c> partreplaced=new List<Service_Charges__c>();
    public  List<Service_Charges__c> serviceCharge=new List<Service_Charges__c>();
   
    public PageReference save() { 
        if(!Customerconsernlist.isempty()){
            update Customerconsernlist;
        }
        Schema.DescribeFieldResult F = case.status.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        // cc = (case)controller.getRecord();
        Replacedlist= [select id,Action__c from Case_Customer_Concern__c where Case__c=:Apexpages.currentPage().getParameters().get('Id') and Action__c='Replaced'];
        partreplaced = [select id,Type__c from Service_Charges__c where Case__c =: Apexpages.currentPage().getParameters().get('Id') and Type__c='Part Replacement'];
        serviceCharge   =       [SELECT Id,Type__c from Service_Charges__c where Case__c =: Apexpages.currentPage().getParameters().get('Id')];
        //system.debug('------------cc.AOSI_Action__c----------'+cc.AOSI_Action__c);
        //  system.debug('------------partreplaced.size()----------'+partreplaced.size());
        if(Replacedlist.size()>0 && partreplaced.size() <= 0 && cc.status=='Closed'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'the “spare charges/ usage spares” section part replacement is mandatory when Action Is "replaced"');
                ApexPages.addMessage(myMsg);
                return null; 
        } else if ( cc.status == 'Closed' && (cc.Reason == 'Chargeable Installation' || cc.Reason == 'Color Panel (Chargeable)') && serviceCharge.isEmpty()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Service Charges are mandatory to close Chargeable Installation/Color Panel (Chargeable) case');
                ApexPages.addMessage(myMsg);
                return null;
        } else {
                PageReference pr = sController.save();  
                return pr;  
       } 
    } 
      
    
}