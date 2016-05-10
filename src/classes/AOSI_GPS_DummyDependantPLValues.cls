/*
Created By: Dheeraj Gangulli
Created Date: 20/04/2016
Last Modified By: Dheeraj Gangulli
Last Modified Date: 20/04/2014
Description: This class is used to get the depenendant picklist values
    Method Name: GetDependentOptions
    Param: Object name, Controlling field Name, Controlling field Name
*/
public class AOSI_GPS_DummyDependantPLValues{

    public  static Map<String,List<String>> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        
        System.debug('Method is calling');
        
        Map<String,List<String>> objResults = new Map<String,List<String>>(); //it stores the result        
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe(); //get the string to sobject global map
        
        Schema.SObjectType pType = objGlobalMap.get(pObjName); //get the type being dealt with
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap(); //stores the details of all the fields like length
           
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues(); //get the controling picklist values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues(); //get the dependent picklist values
        
        //iterate through the values and get the ones valid for the controlling field name
        PickListUtils.Bitset objBitSet = new PickListUtils.Bitset();
        
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){            
            
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex]; //get the pointer to the entry
            String pControllingLabel = ctrl_entry.getLabel();  //get the label
            
            objResults.put(pControllingLabel,new List<String>()); //create the entry with the label
        }
        
        //check the dependent values
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){  
                      
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry);   
            System.debug('Depending picklist values are'+pEntryStructure);             
            PickListUtils.PicklistDetails objDepPLE = (PickListUtils.PicklistDetails)JSON.deserialize(pEntryStructure, PickListUtils.PicklistDetails.class);
            System.debug('objDepPLE values are'+objDepPLE);
            //iterate through the controlling values
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){    
                if (objBitSet.fitBit(objDepPLE.validFor,pControllingIndex)){                    
                    
                    String pControllingLabel = ctrl_ple[pControllingIndex].getLabel(); //get the label
                    objResults.get(pControllingLabel).add(objDepPLE.label);
                }
            }
        } 
        System.debug('Result is'+objResults.get('Service'));
        for(String s: objResults.get('Service')){
        System.debug(s);
        }
        return objResults;
    }
}