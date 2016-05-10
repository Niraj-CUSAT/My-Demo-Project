/*************************************************************************************************
    Created by    :    Bhanu Vallabhu, KVP Business Solutions
    Created On    :    22 Feb 2013
    Modified by   :    
    Modified on   :
    Description   :    This class sets the recordtype to AOS India
**************************************************************************************************/


public class SetRecordtype {

    public Case c {get;set;}  
    public list<Part_Code__c> partCodeList {get;set;}
    public list<Part_Code__c> newPartCodeList {get;set;}
    public list<Part_Code__c> insertPartCodeList {get;set;}
    
    public List<Part_Code__c> Partcodedetil{get;set;}
    public Case caseRecord{get;set;}
    public boolean showPanel{get;set;}
 
    public SetRecordtype(ApexPages.StandardController controller) {  
        Partcodedetil=new List<Part_Code__c>();
        c = (Case)controller.getrecord();
        c.RecordtypeID = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;  
        //query to get record of selected case 
        caseRecord = [select id,AOSI_Promoter_Name__c,AOSI_Promoter_Counter_Name__c,CaseNumber,AOSI_Escalate_to_HO__c,WE_CARE__c,OwnerId,AOSI_TDS_Output__c,AOSI_pH__c,AOSI_City_Master__c,AOSI_Sales_Query_Reference__c,AOSI_Category_of_Sales_Query__c,AOSI_TDS_Input__c,AOSI_Water_Source__c,AOSI_Water_Storage__c,AOSI_Hardness__c,AOSI_Purchase_Value__c,AOSI_Transaction_Number__c,AOSI_Contract_Charges__c,AOSI_Bank_Branch_Details__c,AOSI_Mode_of_Payment__c,AOSI_Cheque_Number__c,Customer_Satisfaction_Status__c,AOSI_Case_Close_Time__c,Origin,AOSI_Final_Amount__c,Assignment_End_Time__c,AOSI_Discount__c,Courier_Number__c,Assignment_Start_Time__c,AOSI_Total_Charges__c,AOSI_City_Picklist__c,AOSI_Work_Done__c,AOSI_Action__c,Description,AOSI_Cause__c,Subject,AOSI_Customer_Concern__c,Service_Engineer__c,AccountId,AOSI_Call_Escalated__c,AOSI_State_Picklist__c,AssetId,Quantity__c,AOSI_Region_picklist__c,AOSIProduct__c,AOSI_Warranty_Status_I__c,AOSI_City__c,AOSI_Appointment_Date__c,AOSI_Preferred_Color__c,ContactId,Reason,AOSI_No_Of_Parts__c,Status,AOSI_Cancelled_On_HOLD_Reason__c,AOSI_Part_Code_Name__c,AOSI_Vertical__c from case where id =: c.id limit 1];
        if(caseRecord.Status == 'On Hold' && caseRecord.AOSI_Cancelled_On_HOLD_Reason__c == 'Part Pending Branch'){
            showPanel = True;
        }
        else{
            showPanel = false;
        }
        //query to all part code related to case
        Partcodedetil = [Select id ,Spares__c,Case__c,Spares__r.part_code__c from Part_Code__c where Case__c =: c.id order by Createddate]; 
       // newPartCodeList = new List<Part_Code__c>();  
     //   insertPartCodeList = new List<Part_Code__c>();      
        //code to create new instance of part code
      /*  if(partCodeList.size() <= 0){
            newPartCodeList.add(new Part_Code__c(Case__c = c.id ));                     
            partCodeList.addAll(newPartCodeList);            
        }   */         
    }  
    //code to add row
    Public void addMore(){
        Part_Code__c PP = new Part_Code__c();
        PP.Case__c =c.id;
        insert PP;
        Partcodedetil.add(PP);
    }
    // Delete Part code
     public void deleteRow(){
        integer row = Partcodedetil.Size();
        if(Partcodedetil.size()>0){
            delete Partcodedetil[row-1];
            Partcodedetil = [Select id ,Spares__c,Spares__r.part_code__c,Case__c from Part_Code__c where Case__c =: c.id order by Createddate]; 
              
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No row to delete ');
            ApexPages.addMessage(myMsg);
        }
    }
    public void savePartCode (){
        try{
            if(Partcodedetil.size()>0){
                update Partcodedetil;
                Partcodedetil = [Select id ,Spares__c,Spares__r.part_code__c,Case__c from Part_Code__c where Case__c =: c.id order by Createddate]; 
            }
            else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Cutomer consern to save ');
                ApexPages.addMessage(myMsg); } } catch( Exception e ) { ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0) ); ApexPages.addMessage(msg); }
   
    }
     
    public void ShowPartDetail(){        
        if(caseRecord.Status == 'On Hold' && caseRecord.AOSI_Cancelled_On_HOLD_Reason__c == 'Part Pending Branch'){
            showPanel = True;
        }
        else{
            showPanel = false;
        }    
    }
    public PageReference CustomeSave(){
        Partcodedetil = [Select id ,Spares__c,Spares__r.part_code__c,Case__c, name from Part_Code__c where Case__c =: c.id order by Createddate]; 
        caseRecord.AOSI_No_Of_Parts__c = Partcodedetil.size();
        List<string> partdata=new List<string>();
        for(Part_Code__c part : Partcodedetil){
            partdata.add(part.Spares__r.part_code__c);
                //caseRecord.AOSI_Part_Code_Name__c =part.Spares__r.part_code__c+','+part.Spares__r.part_code__c; 
         
        }
        caseRecord.AOSI_Part_Code_Name__c=String.join(partdata,',');
        system.debug('-------caseRecord--------'+ caseRecord);
        try{
            update caseRecord; } catch(Exception e) { ApexPages.addMessages(e); return null; }  
        PageReference pageRef = new PageReference('/'+c.id);
        pageRef.setRedirect(true);
        return pageRef;   
    } 
}