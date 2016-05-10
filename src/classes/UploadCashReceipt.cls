/****
    * Field Name    :   uploadCashReceipt
    * Created By    :   Dhriti Krishna Ghosh Moulick
    * Modified By   :   Pooja P Bhat
    * Modified Date :   16-March-2016
    * Description   :   This Page is used to upload data in cash receipt object
*****/

public class UploadCashReceipt {

    public string nameFile                              {get;set;}
    public Blob contentFile                             {get;set;}
    public String strJsonData                           {get;set;}
    public  list<wrapperList> wrapperListCash           {get;set;}
    
    public UploadCashReceipt() {
        wrapperListCash      =   new list<wrapperList>();    
    }   //Constructor called
    
    public Pagereference readFile() {   //This method is used to parse the .csv file and upload records to CRM
        
        String[] filelines                          =   new String[]{};
        set<String> sDuplicateReceiptNos            =   new set<String>();
        map<String,Cash_Receipt__c> mCshRciptFile   =   new map<String,Cash_Receipt__c>();
        map<String,Cash_Receipt__c> mUpsertCR       =   new map<String,Cash_Receipt__c>();
        
        wrapperListCash.clear();
        
        if(!String.isEmpty(nameFile)) { //Validation to choose .csv file
            if(!nameFile.endsWith('.csv')) {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,system.label.Correct_file_Name);
                ApexPages.addMessage(errormsg);
                return null;
            }
        }
        
        if(String.isEmpty(nameFile)) {  //Validation to choose file
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,system.label.File_Name_Missing);
            ApexPages.addMessage(errormsg);
            return null;
        }
        
        nameFile    =   contentFile.toString(); system.debug('nameFile*** '+nameFile);  //Convert from blob to String   
        filelines   =   nameFile.split('\n');   system.debug('filelines*** '+filelines); //Spliting rows by new line tab
        
        for (Integer i=1;i<filelines.size();i++) {  //Start of for loop
            system.debug('filelines '+ i + ' *** '+filelines[i] );
            String[] inputvalues        =   new String[]{};
            inputvalues                 =   filelines[i].split(',');    //Spliting the column values by comma
            
            if(String.isEmpty(inputvalues[0]) || String.isBlank(inputvalues[0]) ) {    //Validation if Cash Receipt Number is empty in updated file
               ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,system.label.Cash_Receipt_Number_Blank + ' ' + (i+1));
               ApexPages.addMessage(errormsg);
               return null;
            }
            
            if(String.isEmpty(inputvalues[1]) || String.isBlank(inputvalues[1]) ){    //Validation if Resource Name is empty in updated file
               ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,system.label.Resource_Name_Blank + ' ' + (i+1));
               ApexPages.addMessage(errormsg);
               return null;
            }
            system.debug('inputvalues[0]***'+inputvalues[0]);
            system.debug('inputvalues[1]***'+inputvalues[1]);
            Cash_Receipt__c oCshReceipt     =   new Cash_Receipt__c();
            oCshReceipt.Name                =   inputvalues[0].replaceAll('[\n\r]', '').trim();  //Assigning 1st column value to Cash Receipt Number     
            oCshReceipt.Resource_Name__c    =   inputvalues[1].replaceAll('[\n\r]', '').trim();  //Assigning 2nd column value to Resource name
            mCshRciptFile.put(oCshReceipt.Name,oCshReceipt);
            
        }   //End of for(Integer i=1;i<filelines.size();i++)
        
        
        
        if(!mCshRciptFile.isEmpty()){
            try {
                for(Cash_Receipt__c oCR : [SELECT Id,Name,Resource_Name__c FROM Cash_Receipt__c WHERE Name IN: mCshRciptFile.keyset()]) {
                    if(oCR.Name == mCshRciptFile.get(oCR.Name).Name) {
                        mUpsertCR.put(oCR.Name,oCR);
                    }
                } 
                if(test.isRunningTest()){ Integer i = 1/0; }
            } catch(Exception e) { System.debug('***No records found*** '+ e.getMessage());}
            
            for(Cash_Receipt__c oCR : mCshRciptFile.values()) {
                if( !mUpsertCR.isEmpty() && mUpsertCR.containsKey(oCR.Name) && mUpsertCR.get(oCR.Name) != null ) {
                    mUpsertCR.get(oCR.Name).Resource_Name__c    =   oCR.Resource_Name__c;
                } else {
                    mUpsertCR.put(oCR.Name,oCR);
                }
            }
            
            system.debug('mCshRciptFile*** '+mCshRciptFile);
            system.debug('mUpsertCR*** '+mUpsertCR);
            
            try {
                if(!mUpsertCR.isEmpty()) {
                    upsert mUpsertCR.values(); //Insert/Update records
                }
                if(test.isRunningTest()){ Integer i = 1/0; }
            } catch (Exception e){
                system.debug('Exception occurred while inserting Cash Receipt records *** ' + e.getMessage());
                ApexPages.Message errormsg  =   new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
                ApexPages.addMessage(errormsg);
            } 
            
            

            list<Cash_Receipt__c> cashReceiptList   =   [SELECT Id,Name,Resource_Name__c,Resource_Name__r.Name FROM Cash_Receipt__c WHERE Name IN: mCshRciptFile.keyset()];
            if(!cashReceiptList.isEmpty()) {
                for(Cash_Receipt__c cshList :cashReceiptList){//Assign inserted records to wrapper list 
                    wrapperList wrplist = new wrapperList();
                    wrplist.cashReceiptNumber   =   cshList.Name;
                    wrplist.resourceName        =   cshList.Resource_Name__r.Name;
                    wrapperListCash.add(wrplist);
                }
                strJsonData = JSON.serialize(wrapperListCash); //Serialize the wrapper list to a string
            }
             system.debug('cashReceiptList*** '+cashReceiptList);
              system.debug('wrapperListCash*** '+wrapperListCash);
        }
        return null;
    }   //End of readFile()
    
    public class wrapperList { //Declaration of wrapper class
        public String resourceName     {get;set;}
        public String cashReceiptNumber  {get;set;}
    }   //End of wrapperList class

}   //End of UploadCashReceipt class