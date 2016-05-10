/*************************************************************************************************
    Created by    :    Bhanu Vallabhu, KVP Business Solutions
    Created On    :    22 Feb 2013
    Modified by   :    
    Modified on   :
    Description   :    This class sets the recordtype to AOS India
**************************************************************************************************/



public class SetContactRecordType {
    public Contact con {get; set;}
    public id conid {get; set;}
    public SetContactRecordType(ApexPages.StandardController controller) {
    con = (Contact)controller.getrecord();
    con.RecordtypeID = [Select id,name from recordtype where DeveloperName =:'AOS_India' and SobjectType =:'Contact' limit 1].id;
    }
    
    public pagereference Returntocase()
    {
        try{
        insert con;
        conid = con.id;
        pagereference pr = new pagereference('/apex/CaseEditNew?urlid='+conid);
        Return pr;
        }
        Catch(Exception e){return Null;}
    }
    
    

}