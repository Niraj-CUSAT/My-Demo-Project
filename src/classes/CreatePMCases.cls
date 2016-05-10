/****************************************************************************************************  
    Created by    :    Vishwanath Attikeri, KVP Business Solutions
    Created On    :    24/9/2013
    Modified by   :    shweta kumari
    Modified on   :    5/02/2014
    Description   :    This class creats PM cases when Asset PM Service1 Date,PM Service2 Date,PM Service3 Date or PM Service4 Date will match todays date
**************************************************************************************************/
global class CreatePMCases implements Schedulable {
    Public Integer Currentyear;
    Public Integer lastyear;
    

    Public Integer month1=1;
    Public Integer month4=4;
    Public Integer month8=8;
    Public Integer month12=12;
    global void execute(SchedulableContext ctx) {  
        Date datobj=system.today();
        Currentyear = datobj.year();
        lastyear=datobj.year()-1;    
        List<Asset> PMService1= new List<Asset>();
        List<Asset> PMService11= new List<Asset>();
        List<Asset> PMService111= new List<Asset>();
        List<Asset> PMService2= new List<Asset>();
        List<Asset> PMService22= new List<Asset>();
        List<Asset> PMService222= new List<Asset>();
        List<Case> CaseList = New List<Case>();
        List<Asset> allAsset=new List<Asset>();
        set<id> productid=new set<id>();
        for(Product2 PP: [Select id from Product2 where RecordType.Name= 'AOS India' and AOSI_PM_Service__c='Yes']){
            productid.add(PP.id);
        }
        system.debug('====productid'+productid.size());
        system.debug('====Currentyear'+Currentyear);
        system.debug('====Currentyear'+lastyear);
        Id CaseRecordtypeId = [Select id from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;         
        //list of asset  Pm service purchased last year
        for(Asset AA1: PMService1=[Select id,ContactId,Product2Id,AOSI_PM_Service1_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c,
        AOSI_PM_Service4_Date__c from Asset where Product2Id IN: productid and (CALENDAR_MONTH(CreatedDate) >=:month1 and CALENDAR_MONTH(CreatedDate) <=:month4  and CALENDAR_YEAR(CreatedDate) = :lastyear )and AOSI_Active__c=TRUE order by createddate]){
            if(AA1.AOSI_PM_Service1_Date__c==system.today()){
                allAsset.add(AA1);
            }
            if(AA1.AOSI_PM_Service2_Date__c==system.today()){
                allAsset.add(AA1);
            }
            if(AA1.AOSI_PM_Service3_Date__c==system.today()){
                allAsset.add(AA1);
            }
            if(AA1.AOSI_PM_Service4_Date__c==system.today()){
                allAsset.add(AA1);
            }
        }

        
        for(Asset AA11: PMService11=[Select id,ContactId,Product2Id,AOSI_PM_Service1_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c,
        AOSI_PM_Service4_Date__c from Asset where Product2Id IN: productid and (CALENDAR_MONTH(CreatedDate) >:month4 and CALENDAR_MONTH(CreatedDate) <=:month8  and CALENDAR_YEAR(CreatedDate) = :lastyear )and AOSI_Active__c=TRUE order by createddate]){
            if(AA11.AOSI_PM_Service1_Date__c==system.today()){
                allAsset.add(AA11);
            }
            if(AA11.AOSI_PM_Service2_Date__c==system.today()){
                allAsset.add(AA11);
            }
            if(AA11.AOSI_PM_Service3_Date__c==system.today()){
                allAsset.add(AA11);
            }
            if(AA11.AOSI_PM_Service4_Date__c==system.today()){
                allAsset.add(AA11);
            }
        }
        for(Asset AA111: PMService111=[Select id,ContactId,Product2Id,AOSI_PM_Service1_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c,
        AOSI_PM_Service4_Date__c from Asset where Product2Id IN: productid and (CALENDAR_MONTH(CreatedDate) >:month8 and CALENDAR_MONTH(CreatedDate) <=:month12  and CALENDAR_YEAR(CreatedDate) = :lastyear )and AOSI_Active__c=TRUE order by createddate]){
            if(AA111.AOSI_PM_Service1_Date__c==system.today()){
                allAsset.add(AA111);
            }
            if(AA111.AOSI_PM_Service2_Date__c==system.today()){
                allAsset.add(AA111);
            }
            if(AA111.AOSI_PM_Service3_Date__c==system.today()){
                allAsset.add(AA111);
            }
            if(AA111.AOSI_PM_Service4_Date__c==system.today()){
                allAsset.add(AA111);
            }
        }
         //list of asset  Pm service purchased this year
        for(Asset AA2: PMService2=[Select id,ContactId,Product2Id,AOSI_PM_Service1_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c,
        AOSI_PM_Service4_Date__c from Asset where  Product2Id IN: productid and (CALENDAR_MONTH(CreatedDate) >=:month1 and CALENDAR_MONTH(CreatedDate) <=:month4  and CALENDAR_YEAR(CreatedDate) = :currentyear )and AOSI_Active__c=TRUE order by createddate]){
            if(AA2.AOSI_PM_Service1_Date__c==system.today()){
                allAsset.add(AA2);
            }
            if(AA2.AOSI_PM_Service2_Date__c==system.today()){
                allAsset.add(AA2);
            }
            if(AA2.AOSI_PM_Service3_Date__c==system.today()){
                allAsset.add(AA2);
            }
            if(AA2.AOSI_PM_Service4_Date__c==system.today()){
                allAsset.add(AA2);
            }
        }
        for(Asset AA22: PMService22=[Select id,ContactId,Product2Id,AOSI_PM_Service1_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c,
        AOSI_PM_Service4_Date__c from Asset where  Product2Id IN: productid and (CALENDAR_MONTH(CreatedDate) >:month4 and CALENDAR_MONTH(CreatedDate) <=:month8  and CALENDAR_YEAR(CreatedDate) = :currentyear )and AOSI_Active__c=TRUE order by createddate]){
            if(AA22.AOSI_PM_Service1_Date__c==system.today()){
                allAsset.add(AA22);
            }
            if(AA22.AOSI_PM_Service2_Date__c==system.today()){
                allAsset.add(AA22);
            }
            if(AA22.AOSI_PM_Service3_Date__c==system.today()){
                allAsset.add(AA22);
            }
            if(AA22.AOSI_PM_Service4_Date__c==system.today()){
                allAsset.add(AA22);
            }
        }
        for(Asset AA222: PMService222=[Select id,ContactId,Product2Id,AOSI_PM_Service1_Date__c,AOSI_PM_Service2_Date__c,AOSI_PM_Service3_Date__c,
        AOSI_PM_Service4_Date__c from Asset where  Product2Id IN: productid and (CALENDAR_MONTH(CreatedDate) >:month8 and CALENDAR_MONTH(CreatedDate) <=:month12  and CALENDAR_YEAR(CreatedDate) = :currentyear )and AOSI_Active__c=TRUE order by createddate]){
            if(AA222.AOSI_PM_Service1_Date__c==system.today()){
                allAsset.add(AA222);
            }
            if(AA222.AOSI_PM_Service2_Date__c==system.today()){
                allAsset.add(AA222);
            }
            if(AA222.AOSI_PM_Service3_Date__c==system.today()){
                allAsset.add(AA222);
            }
            if(AA222.AOSI_PM_Service4_Date__c==system.today()){
                allAsset.add(AA222);
            }
        }
        system.debug('====allAsset'+allAsset.size());
         if(!allAsset.Isempty()){
            for (Asset a: allAsset){
            system.debug('==== '+a.AOSI_PM_Service1_Date__c);
                if(a.AOSI_PM_Service1_Date__c==system.today()){
                    Case c = new Case();
                    c.reason = 'PM Service';
                    c.contactid = a.ContactId;
                    c.AOSIProduct__c = a.Product2Id;
                    c.recordtypeid = CaseRecordtypeId;
                    c.assetid = a.Id;
                    c.AOSI_Warranty_Status_I__c = 'WR'; 
                    c.Status = 'Unregistered / Unallocated';
                    c.AOSI_PM_Service_Customer_Concern__c = 'PM Service 1';
                    CaseList.add(c);  
                }
                if(a.AOSI_PM_Service2_Date__c==system.today()){
                    Case c = new Case();
                    c.reason = 'PM Service';
                    c.contactid = a.ContactId;
                    c.AOSIProduct__c = a.Product2Id;
                    c.recordtypeid = CaseRecordtypeId;
                    c.assetid = a.Id;
                    c.AOSI_Warranty_Status_I__c = 'WR'; 
                    c.Status = 'Unregistered / Unallocated';
                    c.AOSI_PM_Service_Customer_Concern__c = 'PM Service 2';
                    CaseList.add(c);  
                }
                if(a.AOSI_PM_Service3_Date__c==system.today()){
                    Case c = new Case();
                    c.reason = 'PM Service';
                    c.contactid = a.ContactId;
                    c.AOSIProduct__c = a.Product2Id;
                    c.recordtypeid = CaseRecordtypeId;
                    c.assetid = a.Id;
                    c.AOSI_Warranty_Status_I__c = 'WR'; 
                    c.Status = 'Unregistered / Unallocated';
                    c.AOSI_PM_Service_Customer_Concern__c = 'PM Service 3';
                    CaseList.add(c);  
                }
                if(a.AOSI_PM_Service4_Date__c==system.today()){
                    Case c = new Case();
                    c.reason = 'PM Service';
                    c.contactid = a.ContactId;
                    c.AOSIProduct__c = a.Product2Id;
                    c.recordtypeid = CaseRecordtypeId;
                    c.assetid = a.Id;
                    c.AOSI_Warranty_Status_I__c = 'WR'; 
                    c.Status = 'Unregistered / Unallocated';
                    c.AOSI_PM_Service_Customer_Concern__c = 'PM Service 4';
                    CaseList.add(c);  
                }
                
            }
        }

        //code to insert Case
        system.debug('CCCCCCCCC'+CaseList);
        if(!CaseList.isempty()){
            try{
                    Database.insert(CaseList,false);
                }
            catch(Exception E){
                system.debug('-------E--------'+E);
            }
            system.debug('CCCCCCCCC after insert'+CaseList);
        }
    }
}