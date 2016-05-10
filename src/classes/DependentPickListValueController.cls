public class DependentPickListValueController{
    public  DependentPickListValueController(){}
    public  static Map<String,String> GetDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        //get the type being dealt with
        Schema.SObjectType pType = objGlobalMap.get(pObjName);
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //get the control values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        //iterate through the values and get the ones valid for the controlling field name
        PickListUtils.Bitset objBitSet = new PickListUtils.Bitset();
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){            
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<String>());
        }
        
        //check the dependent values
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){            
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry); 
            //system.debug('pEntryStructure'+pEntryStructure);
            PickListUtils.PicklistDetails objDepPLE = (PickListUtils.PicklistDetails)JSON.deserialize(pEntryStructure, PickListUtils.PicklistDetails.class);
            //system.debug('objDepPLE'+objDepPLE.validFor);
            //iterate through the controlling values
           //system.debug('ctrl_ple'+ctrl_ple);

            //for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){    
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){        
                if (objBitSet.fitBit(objDepPLE.validFor,pControllingIndex)){                    
                    //get the label
                    
                    String pControllingLabel = ctrl_ple[pControllingIndex].getLabel();
                    objResults.get(pControllingLabel).add(objDepPLE.label);
                    system.debug('pControllingLabel'+pControllingLabel+' objDepPLE.validFor'+objDepPLE.validFor);
                }
                
            }
			
            
        }
        
        Map<String,String> objResults1=new Map<String,String>();
        for(String s:objResults.keySet())
        {
            List<String> vals=objResults.get(s);
            String csv='';
            for(String ss:vals)
            {
                csv=csv+ss+',';
            }
            if(csv.length()>0)
            {objResults1.put(s,csv.substring(0,csv.length()-1));}
            
        }
        
        return objResults1;
    }
}