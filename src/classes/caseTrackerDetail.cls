public with sharing class caseTrackerDetail{
    
    public static void Call_outbound(String caseNumber,String contactNumber){
        
        List<Case_Fields__c> lstCaseFileds = [SELECT name FROM Case_Fields__c];
        List<Sobject> lstCase= new List<Sobject>();
        List<string> lstStrCaseFields=new List<string>();
        Map<string,Case> mapCaseDetail= new Map<String,Case>();
        Boolean Start = true;
        string fieldTofetch = '';
        string strQuery='';
        
        system.debug('==lstCaseFileds=='+lstCaseFileds);
          
        if(!lstCaseFileds.isEmpty()) {                       
            for(Case_Fields__c eachField : lstCaseFileds){
                lstStrCaseFields.add(eachField.Name);
                if(Start){
                    fieldTofetch = eachField.Name;
                    Start = false;
                }
                else{               
                fieldTofetch = fieldTofetch + ',' + eachField.Name;
                }
           }
        }
        System.debug('==fieldTofetch=='+fieldTofetch);
        strQuery='SELECT '+fieldTofetch+' FROM Case WHERE CaseNumber='+'\''+caseNumber+'\''+' AND Contact_Phone__c='+'\''+contactNumber +'\'';
        system.debug('==strQuery=='+strQuery);
        
        try{
            lstCase=Database.query(strQuery);
            system.debug('==lstCase=='+lstCase);
        }catch(exception e)
        {
            System.debug('==error=='+e);
        }
        
        if(!lstCaseFileds.isEmpty()){
            /***********************XML******************************/
            // Start preparing the XML
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument(null, '1.0'); 
            w.writeStartElement(null, 'SFDCRequest', null); 
            
            for(String eachField: lstStrCaseFields){
                w.writeStartElement(null,eachField, null);
                system.debug('==w=='+w.getXmlString());
                for (Sobject eachCase: lstCase) {
                    w.writeCharacters(String.ValueOf(eachCase.get(eachfield))); 
                    system.debug('==w1=='+w.getXmlString());    
                }
                w.writeEndElement(); 
            }
           
            w.writeEndElement(); 
            w.writeEndDocument();
            system.debug('==w3=='+w.getXmlString());
            String xmlOutput = w.getXmlString();
            system.debug('==xmlOutput==');
        
            w.close();

            /*********************JSON****************************/
            String caseJSON = JSON.serializePretty(lstCase);  
            system.debug('==caseJSON=='+caseJSON);
        }
        
    }         
}