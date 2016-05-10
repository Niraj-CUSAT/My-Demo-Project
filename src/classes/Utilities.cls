public with sharing class Utilities {

     
      
    
    /*** Record Type ID Utilities ***/
    
    // RecordTypeFor() returns the Id for any valid record type name it is given
    public static Id RecordTypeFor(String devName){
        return RecordTypeFor('*',devName);
    }
    
    public static Id RecordTypeFor(String sobjectName, String devName){
        
        if( masterRTlist.get(sobjectName + devName) != Null ) { 
            System.debug('@@@@ record type lookup: saved a query.');
            return masterRTlist.get(sobjectName + devName); 
        } else {
        Map<String,Id> rtMap = new Map<String,Id>();
        String sObjectFilter;
        
        if(sObjectName != null) { sObjectFilter = sObjectName; }
        
        for(RecordType rt : [ SELECT Id, developerName, sObjectType FROM RecordType ]){
            rtMap.put(rt.developerName,rt.Id);
            masterRTlist.put(rt.sObjectType + rt.DeveloperName,rt.id);
            masterRTlist.put('*' + rt.DeveloperName,rt.id);  // add the generic ('*') Sobject to the lookup list as well.
        }
        
        
        return rtMap.get(devName);
        }
    }
    
   // masterRTlist is a persistant variable used by RecordTypeFor()
    public static Map<String,Id> masterRTlist = new Map<String,Id>();

}