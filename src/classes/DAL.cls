public without sharing class DAL{
	     
      public static RecordType getRecordTypeId(String developerName,String sobjectType) {      
             return [Select id,name,DeveloperName,SobjectType from RecordType where DeveloperName =:developerName and SobjectType =:sobjectType limit 1];
      }
      
      
}