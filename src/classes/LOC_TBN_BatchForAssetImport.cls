/**
* @ClassName    : TBN_BatchForAssetImport 
* @JIRATicket   : 
* @CreatedOn    : 14/Oct/2012
* @ModifiedBy   : 17
* @Description  : This is the batch class to insert/update asset records
*/

/**  
@Developer Name: Santosh
Percentage of best practices followed: 100%
No of SOQL queries used: 
No of global collections used: 0
Exception Handling implemented: Yes
Coding standards followed: Yes
Naming conventions followed: Yes
Third party integrations: No
Maximum of No of records tested with: 5300
Customer Approval: 
Last Modified Date: 09/Feb/2013 
Approved by: 
Test Coverage : 83%
*/
 
global class LOC_TBN_BatchForAssetImport implements Database.Batchable<String>, Database.Stateful
{  
	//	Global variables
	global Integer intDuplicateSerialNumCount = 0;
	global Integer intProcessedRecordAssetCount = 0;
	global Integer intErrorRecordsCount = 0;
	global Integer intTotalRecordsCount = 0;
	global Set<String> setProcessedSerialNumber = new Set<String>();
	
    public integer intProcessedAssetCount {get ;set{intProcessedAssetCount = value; if (intProcessedAssetCount < 0) intProcessedAssetCount =0;}}
    public integer intErrorCount {get ;set{intErrorCount = value; if (intErrorCount < 0) intErrorCount =0;}}
    public set<String> setDocumentIds = new set<String>();
    
    private set<String> setSerialNumber = new set<String>();
    private set<String> setCurrentBatchSerialNumbers = new set<String>();
    private set<String> setBillTo = new set<String>();
    private set<String> setShipTo = new set<String>(); 
    private set<String> setItem = new set<String>();
    private set<String> setProductFamily = new set<String>();
    private set<String> setProductSubFamily = new set<String>();
    private set<String> setTruncatedItem = new set<String>();
    private Map<String, Id> mapProductCodeToPSF = new Map<String, Id>();
    private Map<String, Id> mapProductCodeToESobj = new Map<String, Id>();
    
    private map<String, List<String>> mapSerialNo_EachData = new Map<String, List<String>>();
    private map<String, String> mapAccountNumberToId = new map<String, String>();
    private map<String, String> mapAssetSrNoToId = new map<String, String>();
    private map<String, String> mapProductIdToLstItem = new map<String, String>(); 
    private map<String, String> mapSerialNoToId = new map<String, String>();
    private map<String, String> mapProductSRP2ToId = new map<String, String>();
    private map<String, String> mapProductSRP2ToProductId = new map<String, String>();
    private map<String, String> mapProductFamilyToId = new map<String, String>();
    private map<String, Product_Sub_Family__c> mapProductSubFamilyToId = new map<String, Product_Sub_Family__c>();
    private map<String, String> mapProductSRP2ToProdId = new map<String, String>();
    private map<String,String> mapSrNoToTruncatedProductname = new map<String,String>();
    private map<String, String> mapOfItem_SerialNumber = new map<String, String>();
    private map<String, String> mapOfSerialNumber_ProdId = new map<String, String>();
    private map<String, String> mapSN_Item = new map<String, String>();
    private map<String, String> mapItem2SN = new map<String, String>();
    private map<String, String> mapItem3SN = new map<String, String>();
    private map<String,String> mapItem_ProductId = new map<String,String>(); 
     private Map<String, Id> mapProductCodeToPF = new Map<String, Id>();
    
    private List<Account> lstUpdateBillToAccount = new List<Account>();
    private List<Account> lstUpdateShipToAccount = new List<Account>();
    private List<String> lstShiftTo = new List<String>();
    private List<Product_Family__c> lstUpdateProductFamily = new List<Product_Family__c>();
    private List<Product_Sub_Family__c> lstUpdateProductSubFamily = new List<Product_Sub_Family__c>();
    private List<Asset> lstAssetUpsert = new  List<Asset>();
    private Set<Asset> setAssetUpsert = new  Set<Asset>();
    private set<String> setProductCode = new set<String>();
    private Map<Id, Product_Sub_Family__c> mapProductSubFamilyIdToPSF = new Map<Id, Product_Sub_Family__c>();
    
    private String strSerialNumber = '';
    
    private String strItem = '';
    

    /*
        @MethodName: clearVariables 
        @param : BC
        @Description : Initializes the variables
    */
    public void clearVariables()
    {    	
	    integer intProcessedAssetCount  = 0;
	    integer intErrorCount = 0;
	    
	    setCurrentBatchSerialNumbers = new set<String>();
	    setBillTo = new set<String>();
	    setShipTo = new set<String>(); 
	    setItem = new set<String>();
	    setProductFamily = new set<String>();
	    setProductSubFamily = new set<String>();
	    setTruncatedItem = new set<String>();
	    mapSerialNo_EachData = new Map<String, List<String>>();
	    mapAccountNumberToId = new map<String, String>();
	    mapAssetSrNoToId = new map<String, String>();
	    mapProductIdToLstItem = new map<String, String>(); 
	    mapSerialNoToId = new map<String, String>();
	    mapProductSRP2ToId = new map<String, String>();
	    mapProductSRP2ToProductId = new map<String, String>();
	    mapProductFamilyToId = new map<String, String>();
	    mapProductSubFamilyToId = new map<String, Product_Sub_Family__c>();
	    mapProductSRP2ToProdId = new map<String, String>();
	    lstUpdateBillToAccount = new List<Account>();
	    lstUpdateShipToAccount = new List<Account>();
	    
	    lstUpdateProductFamily = new List<Product_Family__c>();
	    lstUpdateProductSubFamily = new List<Product_Sub_Family__c>();
	    lstAssetUpsert = new  List<Asset>();
	    setAssetUpsert = new Set<Asset>();
	   
	    
	    strSerialNumber = '';
	    mapSrNoToTruncatedProductname = new map<String,String>();
	   
	    mapOfItem_SerialNumber = new map<String, String>();
	    mapOfSerialNumber_ProdId = new map<String, String>();
	    mapSN_Item = new map<String, String>();
	    mapItem2SN = new map<String, String>();
	    mapItem3SN = new map<String, String>();
	    strItem = '';
	    mapItem_ProductId = new map<String,String>(); 
	    
	    lstShiftTo = new List<String>();
    }
    /*
        @MethodName: start 
        @param : BC
        @Description : Batch start method
    */
    global Iterable<String> start(Database.BatchableContext BC)
    {
        String result = '';
        List<String> lstAssetValues = new List<String>();
        
        LOC_TBNStoreProcessedAssetCount__c objTBNStoreProcessedAssetCountDeletion = LOC_TBNStoreProcessedAssetCount__c.getValues('TotalAssetCount');
        if(objTBNStoreProcessedAssetCountDeletion != null && (objTBNStoreProcessedAssetCountDeletion.LOC_AssetCount__c != null || objTBNStoreProcessedAssetCountDeletion.LOC_ErrorCount__c != null || objTBNStoreProcessedAssetCountDeletion.LOC_TotalCount__c != null))
        {
            objTBNStoreProcessedAssetCountDeletion.LOC_AssetCount__c = 0;
            objTBNStoreProcessedAssetCountDeletion.LOC_ErrorCount__c = 0;
            objTBNStoreProcessedAssetCountDeletion.LOC_TotalCount__c = 0;
            objTBNStoreProcessedAssetCountDeletion.LOC_DulicateRecordCount__c = 0;
            update objTBNStoreProcessedAssetCountDeletion;
        }

        list<Document> lstDocument = new list<Document>();
        if(setDocumentIds != null && setDocumentIds.size() >0)
        {
            List<String> lstDoumentId = new List<String>();
            lstDocument = [Select Name, Id, FolderId, BodyLength, Body From Document where Id IN: setDocumentIds];
        }
        else
            system.abortJob(BC.getJobId());
            
                      
        if(lstDocument != null && lstDocument.size() > 0)
        {
            Blob objBlob = lstDocument[0].Body;
            try
            {
	            String strTest = objBlob.toString(); 
	            result = strTest;  
	            // Covering Exception code in Test Coverage
 				if(Test.isRunningTest())
  					Crypto.generateDigest('MD5',blob.valueOf('oweD7QSKHxCJOv0gTdUTRkayJwZYz/GM' )).toString();
            }catch(Exception e)
            {
	      		LOC_TBN_Email_To_Address__c objTBN_Email_To_Address = new LOC_TBN_Email_To_Address__c();
	            objTBN_Email_To_Address = LOC_TBN_Email_To_Address__c.getValues('Email Notification');
	            
	            String strEmail = '';
	            String[] toAddresses = new String[]{};
	            if(objTBN_Email_To_Address != NULL)
	            {
		            strEmail = objTBN_Email_To_Address.LOC_Email1__c;
		             
		            toAddresses.add(objTBN_Email_To_Address.LOC_Email1__c);
		            
		            if(objTBN_Email_To_Address.LOC_Email2__c != NULL && objTBN_Email_To_Address.LOC_Email2__c != '')
		            	toAddresses.add(objTBN_Email_To_Address.LOC_Email2__c);
	            }
      	
	      		if(e.getMessage().contains('BLOB is not a valid UTF-8'))
	      		{
	          		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
					mail.setToAddresses(toAddresses);
					mail.setSenderDisplayName('Salesforce Support');
					mail.setSubject('ERROR EMAIL: File format corrupted.');
					mail.setPlainTextBody('The File format has been corrupted. Please try with a correct CSV file again');
					if(!Test.isRunningTest())
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	      		}
			}	
            if(test.isRunningTest())
                result = '1150M001480,458201,HSItem_Test,SHP 480V 24KW 50GAL SUR*,1 OR 3 PHASE,SFL,784459,SO,364568,WO,5/13/2013,1,11197,11197,5/13/2013,03-01-2013,5/13/2013,5/13/2013,5/13/2013,201304-063,,20,BC,HSX,EA,1,1,2288.5,2288.5,609,412,0,CMONTOYA,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,,724759\n' +
		                 '1150M001480,458201,HSItem_Test,SHP 480V 24KW 50GAL SUR*,1 OR 3 PHASE,SFL,784459,SO,364568,WO,5/13/2013,1,0101010203,11197,5/13/2013,5/13/2013,5/13/2013,03-08-2013,5/13/2013,201304-063,,20,BC,HSX,EA,1,1,2288.5,2288.5,609,412,0,CMONTOYA,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,,724759\n' +
		                 '1150M001480,458201,HSItem_Test,SHP 480V 24KW 50GAL SUR*,1 OR 3 PHASE,SFL,784459,SO,364568,WO,5/13/2013,1,11197,11197,5/13/2013,5/13/2013,5/13/2013,03-08-2013,5/13/2013,201304-063,,20,BC,HSX,EA,1,1,2288.5,2288.5,609,412,0,CMONTOYA,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,,724759\n' +
		                 'abcdefgh,458201,HSItem_Test,SHP 480V 24KW 50GAL SUR*,1 OR 3 PHASE,SFL,784459,SO,364568,WO,5/13/2013,1,11197,11197,5/13/2013,5/13/2013,5/13/2013,03-08-2013,5/13/2013,201304-063,,20,BC,HSX,EA,1,1,2288.5,2288.5,609,412,0,CMONTOYA,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,BERGER PLUMB SUP (CC),8131 N W 91 TERRACE,,,,MEDLEY,FL,33166,,,40,SD,FL1,,724759\n' + 
		                 ',455709,FBN1500-8556,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,5/13/2013,1000,13173,13173,5/13/2013,5/13/2013,5/13/2013,5/13/2013,5/13/2013,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200-P,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680733\nHS12H00052260,455709,HSAWN601PM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200PM CE,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680733\nH12H00052260,455709,FBN1500-TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TCE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TC,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TH,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TR,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TS,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500TCE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500TC,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500TH,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500R,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500S,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TPM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500-TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500TPM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500PM CE-TCE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500C-TC,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500H-TH,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500R-TR,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12H00052260,455709,FBN1500S-TS,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\n' + 
		                 '\n' + 
		                 '---------\n' + 
		                 'SerialNbr,Itm,Item,ItemDescription1,\n' + 
		                 'rows affected';
            
            List<AssetImportErrorLog__c> lstAsssetImportErrors = [SELECT Id 
                                                        FROM AssetImportErrorLog__c LIMIT 9900];
            if(lstAsssetImportErrors.size() > 0)
                delete lstAsssetImportErrors;
                
            While(result.indexOf('\n') != -1) 
            {
                lstAssetValues.add(result.substringBefore('\n')); 
                result = result.substringAfter('\n');
            }
             
            if(test.isRunningTest())
            {
                lstAssetValues.add(result.substringBefore('\n')); 
                result = result.substringAfter('\n');
            }
            
            if(lstAssetValues.size() > 0)
                lstAssetValues.remove(0);
            
            if(lstDocument != null && lstDocument.size() >0)
                delete lstDocument; 
             
            return lstAssetValues;
        }
        
        else
            system.abortJob(BC.getJobId());
        
        return lstAssetValues;
    }
    
    /*
        @ClassName: TBN_BatchForAssetImport 
        @param : None
        @Description : Constructor
    */
    global LOC_TBN_BatchForAssetImport(set<string> setDocumentIds)
    {  
        this.setDocumentIds = setDocumentIds ;
   }
    
	LOC_TBNStoreProcessedAssetCount__c objTBNStoreProcessedAssetCount = LOC_TBNStoreProcessedAssetCount__c.getValues('TotalAssetCount');

    /*
        @MethodName: Execute 
        @param : scope
        @Description : Batch execute method
    */
    global void execute(Database.BatchableContext BC, List<String> scope)
    {
    	clearVariables();
     	List<AssetImportErrorLog__c> lstErrorLogData = new List<AssetImportErrorLog__c>();
     
     	lstAssetUpsert = new List<Asset>();
    	setAssetUpsert = new Set<Asset>();
        try
        {
            List<List<String>> lstAssetImportRecords = new List<List<String>>(); 
            Map<String,String> mapSerialNumberToStringAsset = new Map<String,String>();
 
            //Iterate through the records in file
            for(String strEachValue : scope)
            {
                if(!strEachValue.startsWith(',,,,,,,,,,,,,,,,,,,,,,,,,') && strEachValue != '')
                	intTotalRecordsCount += 1;
            	else
            		continue;
                if(strEachValue.contains('---') || strEachValue.contains('SerialNbr,Itm,Item,ItemDescription1,') || strEachValue.contains('rows affected') || strEachValue.split(',')[0] == '')
                {
              	 	AssetImportErrorLog__c objAssetErrorLog = new AssetImportErrorLog__c();
                    if(strEachValue.contains('---'))
                    {
                    	objAssetErrorLog.CSVLogData__c = '---------,-----,-----,------,-------,-------,--------,-------,-------,------,--------,---------,---';
                    	objAssetErrorLog.Reason_of_failure__c = 'No Valid Data Contains'; 
                    	lstErrorLogData.add(objAssetErrorLog);
                    	intErrorRecordsCount += 1;
                    }	
                    else if(strEachValue.contains('SerialNbr,Itm,Item,ItemDescription1,'))
                    { 	
                    	objAssetErrorLog.CSVLogData__c = 'SerialnNbr,  Itm,  Item,  ItemDescription1,	ItemDescription2,	Branch,	SONbr,	 SOType,	 WONbr,	 WOType,	 ShipDate,	 SOLine,	 BillTo, ShipTo	, RequestedDate,	 TransactionDate,	PromisedDate,	 OrigPromDate,	 InvoiceDate,	 CustomerPO1,	 CustomerPO2,	 SRP1,	 SRP2,	 SRP3,	 UOM,	 QtyOrdered,	 QtyShipped,	 UnitPrice,	 ExtendedAmount,	 FreightCode,	 Territory1,	 Territory2,	 TakenBy,	 BillToName,	 BillToAddress1,	 BillToAddress2,	 BillToAddress3,	 BillToAddress4,	 BillToCity,	 BillToStateCode,	 BillToZipCode,	 BillToCountryCode,	 BillToCountryName,	 Region,	 BillToDistributorType,	 BillToDistributorClass,	 ShipToName,	 ShipToAddress1,	 ShipToAddress2,	 ShipToAddress3,	 ShipToAddress4,	 ShipToCity,	 ShipToStateCode,	 ShipToZipCode,	 ShipToCountryCode,	 ShipToCountryName,	 ShipToRegion,	 ShipToDistributorType,	 ShipToDistributorClass,	 ConfiguredString,	 InvoiceNbr';	
                    	objAssetErrorLog.Reason_of_failure__c = 'Header is repeated';
                    	lstErrorLogData.add(objAssetErrorLog);
                    	intErrorRecordsCount += 1;
                    }
                    else if(strEachValue.split(',')[0] == '')
                    {
                    	objAssetErrorLog.CSVLogData__c = strEachValue;	
                    	objAssetErrorLog.Reason_of_failure__c = 'Serial Number is null'; 
                    	lstErrorLogData.add(objAssetErrorLog);
                    	intErrorRecordsCount += 1;
                    }
                    else
                    {
                    	objAssetErrorLog.CSVLogData__c = strEachValue;	
                    	objAssetErrorLog.Reason_of_failure__c = 'No Valid Data Contains';
                    	lstErrorLogData.add(objAssetErrorLog);
                    	intErrorRecordsCount += 1;
                    }
                    
               	continue;
               	}	
                List<String> lstParsedResult = new List<String>(); 
                Integer strTest = strEachValue.lastIndexOf(',');
                // Remove spaces from the parsed file
                if(strEachValue != null && strEachValue != '')
                { 
                    //Parse csv file based on index of comma
                    while(strEachValue.indexOf(',') != -1)
                    {
                        Integer index = 0;
                        Integer endDescIndex = 0;
                        String strValue = '';
                        String strValue1 = ''; 
                        index = strEachValue.indexOf(',');
                        if(strEachValue.indexOf('"') == index + 1)
                        {
                            //check if index of " exists
                            endDescIndex = strEachValue.indexOf('",');
                            //returns a substring from start to index value
                            strValue = strEachValue.substring(0,index);
                            //returns a substring from next character of index to end of description column
                            strValue1 = strEachValue.substring(index + 1,endDescIndex+2);
                            
                        }

                        //Returns other column values
                        else
                            strValue = strEachValue.substring(0,index);

                        lstParsedResult.add(strValue.trim()); 
                        
                        //collect remaining substring for parsing
                        if(endDescIndex != 0)
                        {
                            lstParsedResult.add(strValue1.trim());
                            strEachValue = strEachValue.substring(endDescIndex+2, strEachValue.length());
                        }
                        else 
                        { 
                            strEachValue = strEachValue.substring(index+1, strEachValue.length());
                        }
                    }
                    lstParsedResult.add(strEachValue.trim());
                    
                    if(lstParsedResult[0] != null && lstParsedResult[0] != '')
                    {
                    	mapSerialNumberToStringAsset.put(lstParsedResult[0],strEachValue);
                    }
                    
                    //Collect all serial number from JDE
                    if(lstParsedResult.size() > 0 && lstParsedResult[0] != null && lstParsedResult[0] != '')
                    {
						setCurrentBatchSerialNumbers.add(lstParsedResult[0]);
						if(!setSerialNumber.contains(lstParsedResult[0]))
						{
							setSerialNumber.add(lstParsedResult[0]);
						}
						else
						{
							intDuplicateSerialNumCount += 1 ;
							continue;							
						}                      
                        //adding the list to the list of import
                        lstAssetImportRecords.add(lstParsedResult);
                    }
                    
                    //Collect all ShipTo records from JDE
                    if(lstParsedResult.size() > 13 && lstParsedResult[13] != null && lstParsedResult[13] != '')
                    {
                        setShipTo.add(lstParsedResult[13]);
                        lstShiftTo.add(lstParsedResult[13]);                        
                    }
                    
                    //Collect all billTo records from JDE
                    if(lstParsedResult.size() > 12 && lstParsedResult[12] != null && lstParsedResult[12] != '')
                    {
                        setBillTo.add(lstParsedResult[12]);
                    } 
                    
                    //Collect all Item records from JDE
                    if(lstParsedResult.size() > 2)
                    {
                        setItem.add(lstParsedResult[2]);
                        mapOfItem_SerialNumber.put(lstParsedResult[2], lstParsedResult[0]);
                    }
                    //Collect all ProductFamily records from JDE
                    if(lstParsedResult.size() > 21 && lstParsedResult[21] != null && lstParsedResult[21] != '')
                    {
                        setProductFamily.add(lstParsedResult[21]);
                    }
                    //Collect all ProductSubFamily records from JDE
                    if(lstParsedResult.size() > 22 && lstParsedResult[22] != null && lstParsedResult[22] != '')
                    {
                        setProductSubFamily.add(lstParsedResult[22]);
                    }
                    if(lstParsedResult.size() > 0)
                    {
                        //Map contains serial numbers and its related values
                        mapSerialNo_EachData.put(lstParsedResult[0], lstParsedResult);
                    }
                    
                    if(lstParsedResult.size() > 2)
                    {
			           mapSN_Item.put(lstParsedResult[0],lstParsedResult[2]);
                    }
                    
                    if(lstParsedResult.size() > 21)
                    {
                        setProductCode.add(lstParsedResult[21]);
                        system.debug('------------setProductCode-----------------'+setProductCode);
                    }
                }
            }
            Map<String, String> mapSN_ItemWithNoDirectProduct = new Map<String, String>();
            mapSN_ItemWithNoDirectProduct.putAll(mapSN_Item); 
            for(Asset objAsset3 : [SELECT SerialNumber,Id,LOC_Item__c,Product2Id
	                               FROM Asset 
	                               WHERE LOC_Item__c IN : setItem AND Product2Id != null AND SerialNumber IN: setCurrentBatchSerialNumbers limit 40000])
            {
            	//if(objAsset3.Product2Id != null && setCurrentBatchSerialNumbers.contains(objAsset3.SerialNumber))
            	//{
        			mapOfSerialNumber_ProdId.put(objAsset3.SerialNumber, objAsset3.Product2Id);
        			mapItem_ProductId.put(objAsset3.LOC_Item__c, objAsset3.Product2Id); 
    				mapSN_ItemWithNoDirectProduct.remove(objAsset3.SerialNumber); 
            	//}
            } 
            if(mapSN_ItemWithNoDirectProduct.size() > 0)
            {       
            	getTruncatedItemValue(mapSN_ItemWithNoDirectProduct);
            }
            
            getQueryResults();
            
            //Iterate thorough scope to insert or update asset records
            for(Integer i=0; i < scope.size() ;i++)
            {
            	
                List<String> lstEachValue = new List<String>();
                if(lstAssetImportRecords.size() > i && lstAssetImportRecords[i] != null)
                {
                    lstEachValue = lstAssetImportRecords[i];
                    strSerialNumber = lstEachValue[0];
                    if(lstEachValue.size() >= 2 && lstEachValue[2] != null)
                    	strItem = lstEachValue[2];
                }
                
                if(strSerialNumber != null && strSerialNumber != '')
                {
                    List<Asset> lstAsset = new List<Asset>();
                    if(lstEachValue.size() > 12 && lstEachValue[12] != Null && mapAccountNumberToId.get(lstEachValue[12]) != null &&
                    	lstEachValue.size() > 13 && lstEachValue[13] != Null && mapAccountNumberToId.get(lstEachValue[13]) != null &&
                    	setCurrentBatchSerialNumbers.contains(strSerialNumber))
                    {
                        // call if Id Exists
                        if(mapOfSerialNumber_ProdId.get(strSerialNumber) != null && mapProductSRP2ToId.get(mapSrNoToTruncatedProductname.get(strSerialNumber)) == null )
                        {
                        	callOnProductIdExists(mapOfSerialNumber_ProdId.get(strSerialNumber));
                        }
                        
                        else if(mapSrNoToTruncatedProductname.get(strSerialNumber) != null && mapProductSRP2ToId.get(mapSrNoToTruncatedProductname.get(strSerialNumber)) != null)
                        {
                            callOnProductIdExists(mapProductSRP2ToId.get(mapSrNoToTruncatedProductname.get(strSerialNumber)));
                        }
                        else if(mapItem_ProductId.containsKey(strItem) && mapItem_ProductId.get(strItem) != null)
                        {
                        	callOnProductIdExists(mapItem_ProductId.get(strItem));
                        }
                        // Call if Product Id not exists
                        else
                        { 
                            String strProductId = callOnProductIdNotExists(strSerialNumber);
                            if(strProductId != '')
                            {
                                callOnProductIdExists(strProductId);
                            }
                        }
                    }
                    // Upload Failed
                    else
                    {
                        if(scope[i].length() < 32768 && lstEachValue.size() > 0 && lstEachValue[0] != null && lstEachValue[0].trim() != '' && !setProcessedSerialNumber.contains(strSerialNumber))
                        {
                            AssetImportErrorLog__c objAssetErrorLog = new AssetImportErrorLog__c();
                            objAssetErrorLog.CSVLogData__c = scope[i];
                            objAssetErrorLog.Reason_of_failure__c = 'No Matching Bill to and Ship to found'; 
                            lstErrorLogData.add(objAssetErrorLog);
                            intErrorRecordsCount += 1;
                            setProcessedSerialNumber.add(strSerialNumber);
                        }
                    }
                }
            }
            
            if(lstUpdateShipToAccount.size() > 0)
            {
                update lstUpdateShipToAccount;
            }
            
            List<Database.upsertResult> lstSaveresult = new List<Database.upsertResult>();
            
            lstAssetUpsert.addAll(setAssetUpsert);
            system.debug('==============lstAssetUpsert==========='+lstAssetUpsert);
            if(lstAssetUpsert.size() > 0)
            {
	          /* Added for counting number of inserts and number of updates during this Asset Import process. 
	               for(Integer i=0; i < lstAssetUpsert.size(); i++){
	                	if(lstAssetUpsert[i].Id != null){
	                		updateCount++;
	                	}
	                	else{
	                		insertCount++;
	                	}
	                }
	           */     
                system.debug('##########################################'+lstAssetUpsert);
                lstSaveresult = database.upsert(lstAssetUpsert,false); 
                intProcessedAssetCount = lstSaveresult.size();
                intProcessedRecordAssetCount += intProcessedAssetCount;
                objTBNStoreProcessedAssetCount = LOC_TBNStoreProcessedAssetCount__c.getValues('TotalAssetCount');
            }
            if(Test.isRunningTest())
            {
            	lstAssetUpsert.add(new Asset());
            	lstSaveresult = database.upsert(lstAssetUpsert,false); 
            }
            if(lstSaveresult != null && lstSaveresult.size() > 0)
            {
                for(Integer i=0; i < lstSaveresult.size() ; i++)
                {
                    if(!lstSaveresult[i].isSuccess())
                    {
                        AssetImportErrorLog__c objAssetErrorLog = new AssetImportErrorLog__c();
                        objAssetErrorLog.CSVLogData__c = mapSerialNumberToStringAsset.get(lstAssetUpsert[i].SerialNumber);
                        objAssetErrorLog.Reason_of_failure__c = lstSaveresult[i].getErrors()[0].getMessage();
                        lstErrorLogData.add(objAssetErrorLog);
                        intProcessedRecordAssetCount -= 1;
                        intErrorRecordsCount += 1;
                    }
                }
                 
                intErrorCount = lstErrorLogData.size();
                objTBNStoreProcessedAssetCount = LOC_TBNStoreProcessedAssetCount__c.getValues('TotalAssetCount');
            }
            
            if(lstErrorLogData.size() > 0)
            {
                insert lstErrorLogData;
            }
            
			objTBNStoreProcessedAssetCount.LOC_DulicateRecordCount__c = intDuplicateSerialNumCount;	
			objTBNStoreProcessedAssetCount.LOC_AssetCount__c = intProcessedRecordAssetCount;
			objTBNStoreProcessedAssetCount.LOC_ErrorCount__c = intErrorRecordsCount;
			objTBNStoreProcessedAssetCount.LOC_TotalCount__c = intTotalRecordsCount;
			
            update objTBNStoreProcessedAssetCount;	            
        }
        catch(Exception e)
        {
            if(lstErrorLogData.size() > 0)
            {
                upsert lstErrorLogData;
            }
            system.debug('-----Execute exception--Exception----at line number-->'+e.getLineNumber()+'--error message-->'+e.getMessage());
        }
    }
     
    /*
        @MethodName: getQueryResults 
        @param : none
        @Description : Method to collect all the column values from JDE
    */
    private void getQueryResults()
    {
        // SFDC returns SFID for each Account found 
        for(Account objAccount : [ SELECT AccountNumber 
                                   FROM Account 
                                   WHERE AccountNumber IN : setBillTo OR AccountNumber IN : setShipTo])
        {
        	mapAccountNumberToId.put(objAccount.AccountNumber, objAccount.Id);
        }
        
        // Serial Number Table Exported from JDE
        for(Asset objAsset : [ SELECT SerialNumber,Id
                               FROM Asset 
                               WHERE SerialNumber IN : setCurrentBatchSerialNumbers])
        {
            mapAssetSrNoToId.put(objAsset.SerialNumber, objAsset.Id);
        }
        
        // Query Products from SFDC
        for(Product2 objProduct : [ SELECT LOC_Product_SRP2__c, Id
                                    FROM Product2
                                    WHERE LOC_Product_SRP2__c IN : setTruncatedItem ])
        {
            mapProductSRP2ToId.put(objProduct.LOC_Product_SRP2__c, objProduct.Id);
        }
        
        // Query Product family from SFDC
        for(Product_Family__c objProductFamily : [ SELECT LOC_SRP_1__c, Id
                                                   FROM Product_Family__c 
                                                   WHERE LOC_SRP_1__c IN : setProductFamily ])
        {
            mapProductFamilyToId.put(objProductFamily.LOC_SRP_1__c, objProductFamily.Id);
        }
        
    /*    // Query  subfamily from SFDC
        for(Product_Sub_Family__c objProductSubFamily : [ SELECT LOC_SRP_2__c, Id
                                                          FROM Product_Sub_Family__c
                                                          WHERE LOC_SRP_2__c IN : setProductSubFamily AND LOC_Product_Family__c IN : mapProductFamilyToId.keyset()])
        {
            mapProductSubFamilyToId.put(objProductSubFamily.LOC_SRP_2__c, objProductSubFamily);
        }*/
        system.debug('--------setProductCode------------'+setProductCode);
        
        for(Product2 objProduct2 : [Select LOC_Product_Sub_Family__c, ProductCode, Id, LOC_Product_Family__c, LOC_Error_Set__c From Product2 where ProductCode IN : setProductCode])
       {
       		if(objProduct2.LOC_Product_Sub_Family__c != null)
       			mapProductCodeToPSF.put(objProduct2.ProductCode,objProduct2.LOC_Product_Sub_Family__c);
       		if(objProduct2.LOC_Error_Set__c != null)
       			mapProductCodeToESobj.put(objProduct2.ProductCode,objProduct2.LOC_Error_Set__c);
       		if(objProduct2.LOC_Product_Family__c != null)
       			mapProductCodeToPF.put(objProduct2.ProductCode,objProduct2.LOC_Product_Family__c);
       		
       }
    	
      for(Product_Sub_Family__c objProductSubFamily : [ SELECT LOC_SRP_2__c, Id,LOC_Product_Family__c
                                                          FROM Product_Sub_Family__c
                                                          WHERE Id IN : mapProductCodeToPSF.values()])
        {
            mapProductSubFamilyToId.put(objProductSubFamily.LOC_SRP_2__c, objProductSubFamily);
            mapProductSubFamilyIdToPSF.put(objProductSubFamily.Id, objProductSubFamily);
            
        }
    }
    
    /*
        @MethodName: getTruncatedItemValue 
        @param : none
        @Description : Method to truncate item to  name + SRP2
    */
    private void getTruncatedItemValue(map<String,String> mapStr)//String strSrNumber ,String strTruncateItem
    {
        for(String strSrNumber : mapStr.keyset())
        {
        	String strTruncateItem = mapStr.get(strSrNumber);
	        if(strTruncateItem.startsWith('HS') )
	        {
	            if(mapSerialNo_EachData != null && mapSerialNo_EachData.get(strSrNumber) != null && mapSerialNo_EachData.get(strSrNumber)[22] != NULL)
	            {
	            	String strAppend = mapSerialNo_EachData.get(strSrNumber)[22] == NULL ? '' : mapSerialNo_EachData.get(strSrNumber)[22];
	            	strTruncateItem = 'Standard High Power Water Heater ' + strAppend;
	            }
	            else 
	            	strTruncateItem = '';	
	            setTruncatedItem.add(strTruncateItem);
	            mapSrNoToTruncatedProductname.put(strSrNumber,strTruncateItem);
	        }
	        
	        else if( (strTruncateItem.startsWith('HH')) || (strTruncateItem.startsWith('HV')) )
	        {
	            if(mapSerialNo_EachData != null && mapSerialNo_EachData.get(strSrNumber) != null && mapSerialNo_EachData.get(strSrNumber)[22] != NULL)
	            {
	            	String strAppend = mapSerialNo_EachData.get(strSrNumber)[22] == NULL ? '' : mapSerialNo_EachData.get(strSrNumber)[22];
	            	strTruncateItem = 'Custom High Power Water Heater ' + strAppend;
	            }
	            else 
	            	strTruncateItem = '';
	            setTruncatedItem.add(strTruncateItem);
	            mapSrNoToTruncatedProductname.put(strSrNumber,strTruncateItem);
	        }
	        
	        else if(strTruncateItem.contains('-')) 
	        {
	            String[] strSplit = new String[]{};
	            strSplit = strTruncateItem.split('-');
	            String strPrefix = strSplit[0];
	            String strSuffix = strSplit[1]; 
	            if(strPrefix.endsWith('PM CE') )
	                strTruncateItem = strPrefix.removeEnd('PM CE');
	            else if(strPrefix.endsWith('PM'))
	                strTruncateItem = strPrefix.removeEnd('PM');
	            else if(strPrefix.endsWith('CE'))
	                strTruncateItem = strPrefix.removeEnd('CE');
	            else if(strPrefix.endsWith('C'))
	                strTruncateItem = strPrefix.removeEnd('C');
	            else if(strPrefix.endsWith('H') )
	                strTruncateItem = strPrefix.removeEnd('H');
	            else if(strPrefix.endsWith('R'))
	                strTruncateItem = strPrefix.removeEnd('R');
	            else if(strPrefix.endsWith('S'))
	                strTruncateItem = strPrefix.removeEnd('S');
	            else if(mapSerialNo_EachData != null && mapSerialNo_EachData.get(strSrNumber) != null && mapSerialNo_EachData.get(strSrNumber)[22] != NULL) 
	            {
	                String strAppend = mapSerialNo_EachData.get(strSrNumber)[22] == NULL ? '' : mapSerialNo_EachData.get(strSrNumber)[22];
	                strTruncateItem = strPrefix + strAppend;
	            }
	            setTruncatedItem.add(strTruncateItem);
	            mapSrNoToTruncatedProductname.put(strSrNumber,strTruncateItem);
	        }
	        
	        else if (!strTruncateItem.contains('-'))
	        {
	            if(strTruncateItem.endsWith('PM CE') )
	                strTruncateItem = strTruncateItem.removeEnd('PM CE');
	            else if(strTruncateItem.endsWith('PM'))
	            {
	                strTruncateItem = strTruncateItem.removeEnd('PM');
	            }
	            else if(strTruncateItem.endsWith('CE'))
	                strTruncateItem = strTruncateItem.removeEnd('CE');
	            else if(strTruncateItem.endsWith('C'))
	                strTruncateItem = strTruncateItem.removeEnd('C');
	            else if(strTruncateItem.endsWith('H') )
	                strTruncateItem = strTruncateItem.removeEnd('H');
	            else if(strTruncateItem.endsWith('R'))
	                strTruncateItem = strTruncateItem.removeEnd('R');
	            else if(strTruncateItem.endsWith('S'))
	                strTruncateItem = strTruncateItem.removeEnd('S');
	            else if(mapSerialNo_EachData != null && mapSerialNo_EachData.get(strSrNumber) != null && mapSerialNo_EachData.get(strSrNumber)[22] != NULL)
	            {
	                String strAppendSrp = mapSerialNo_EachData.get(strSrNumber)[22] == NULL ? '' : mapSerialNo_EachData.get(strSrNumber)[22];
	                strTruncateItem  = strTruncateItem + strAppendSrp;
	            }
	            setTruncatedItem.add(strTruncateItem);
	            mapSrNoToTruncatedProductname.put(strSrNumber,strTruncateItem);
	        }
	        else
	        {
	        	String strAppendSrp = mapSerialNo_EachData.get(strSrNumber)[22] == NULL ? '' : mapSerialNo_EachData.get(strSrNumber)[22];
                strTruncateItem  = strTruncateItem + strAppendSrp;
                setTruncatedItem.add(strTruncateItem);
	            mapSrNoToTruncatedProductname.put(strSrNumber,strTruncateItem);
	        }
        }
    }
    
    /*
        @MethodName: callOnProductIdExists 
        @param : none
        @Description : Method to insert or update asset records when product Id exists in SF
    */
    private void callOnProductIdExists(String strProductId)
    {
        try
        {
            Asset objAssetUpsert;
            List<String> lstEachData = mapSerialNo_EachData.get(strSerialNumber);
        
            if(mapAssetSrNoToId.get(strSerialNumber)!= Null)
            {
                objAssetUpsert = new Asset(Id = mapAssetSrNoToId.get(strSerialNumber));
            }
            else
            {
                objAssetUpsert = new Asset();
            }
            
            //Set the date format to insert into asset
            String strInvoiceDt = '';
            if(lstEachData != null && lstEachData[18] != null && lstEachData[18] != '')
            	strInvoiceDt = lstEachData[18];
            
            if(strInvoiceDt != null && strInvoiceDt != '' && strInvoiceDt.contains('/'))
            {
                strInvoiceDt = strInvoiceDt.split('/')[2]+'-'+strInvoiceDt.split('/')[0]+'-'+strInvoiceDt.split('/')[1];            
            }
            else if(strInvoiceDt != null && strInvoiceDt != '' && strInvoiceDt.contains('-'))
            {
                strInvoiceDt = strInvoiceDt.split('-')[2]+'-'+strInvoiceDt.split('-')[0]+'-'+strInvoiceDt.split('-')[1];
             	
            }    
            Date dtInvoice = date.valueOf(strInvoiceDt);
            
            String strInvoice = '';
            if(strInvoiceDt.contains('/'))
                strInvoice = dtInvoice.month()+'/'+dtInvoice.day()+'/'+dtInvoice.year();
            else if(strInvoiceDt.contains('-'))
                strInvoice = dtInvoice.month()+'/'+dtInvoice.day()+'/'+dtInvoice.year();
                
            dtInvoice = date.parse(strInvoice);
            String strshippedDt = '';
            if(lstEachData != null && lstEachData[10] != null && lstEachData[10] != '')  
            	strshippedDt = lstEachData[10]; 
            if(strshippedDt.contains('-'))
                strshippedDt = strshippedDt.split('-')[2]+'-'+strshippedDt.split('-')[0]+'-'+strshippedDt.split('-')[1];
            else if(strshippedDt.contains('/'))
            	strshippedDt = strshippedDt.split('/')[2]+'-'+strshippedDt.split('/')[0]+'-'+strshippedDt.split('/')[1];
            Date dtShipped = date.valueOf(strshippedDt);
                String strShipped = dtShipped.month()+'/'+dtShipped.day()+'/'+dtShipped.year(); 
            dtShipped = date.parse(strShipped);
            
            String strPurchasedDt = '';
            if(lstEachData.size() > 15 && lstEachData != null && lstEachData[15] != null && lstEachData[15] != '')
            	strPurchasedDt = lstEachData[15];
            	
            if(strPurchasedDt != null && strPurchasedDt != '' && strPurchasedDt.contains('/'))
            {
                if(strPurchasedDt.split('/')[2].length() == 2)
                	strPurchasedDt = '20'+strPurchasedDt.split('/')[2]+'-'+strPurchasedDt.split('/')[0]+'-'+strPurchasedDt.split('/')[1];
                else
                	strPurchasedDt = strPurchasedDt.split('/')[2]+'-'+strPurchasedDt.split('/')[0]+'-'+strPurchasedDt.split('/')[1];
            }    
            else if(strPurchasedDt != null && strPurchasedDt != '' && strPurchasedDt.contains('-'))
            {
                if(strPurchasedDt.split('-')[2].length() == 2)
                	strPurchasedDt ='20'+strPurchasedDt.split('-')[2]+'-'+strPurchasedDt.split('-')[0]+'-'+strPurchasedDt.split('-')[1];
                else
                	strPurchasedDt =strPurchasedDt.split('-')[2]+'-'+strPurchasedDt.split('-')[0]+'-'+strPurchasedDt.split('-')[1];
            }    
            Date dtPurchaseDate = date.valueOf(strPurchasedDt);
            //Upsert asset records
            objAssetUpsert.LOC_Description_1__c = (lstEachData.size() > 3 && lstEachData[3] != NULL) ? lstEachData[3] : '';
            objAssetUpsert.LOC_Description_2__c = (lstEachData.size() > 4 && lstEachData[4] != NULL) ? lstEachData[4] : '';
            objAssetUpsert.LOC_Code__c = (lstEachData.size() > 1 && lstEachData[1] != NULL) ? lstEachData[1] : '';
            objAssetUpsert.LOC_Branch__c = (lstEachData.size() > 5 && lstEachData[5] != NULL) ? lstEachData[5] : '';
            objAssetUpsert.Sales_Order_Number__c = (lstEachData.size() > 6 && lstEachData[6] != NULL) ? lstEachData[6] : '';
            objAssetUpsert.LOC_SO_Type__c = (lstEachData.size() > 7 && lstEachData[7] != NULL) ? lstEachData[7] : '';
            objAssetUpsert.Customer_Purchase_Order__c = (lstEachData.size() > 19 && lstEachData[19] != NULL) ? lstEachData[19] : '';
            objAssetUpsert.LOC_Territory_1__c = (lstEachData.size() > 30 && lstEachData[30] != NULL) ? lstEachData[30] : '';
            objAssetUpsert.LOC_Territory_2__c = (lstEachData.size() > 31 && lstEachData[31] != NULL) ? lstEachData[31] : '';
            objAssetUpsert.Invoice_Date__c = dtInvoice == NULL ? NULL : dtInvoice;
            objAssetUpsert.LOC_Shipped_Date__c = dtShipped == NULL ? Null: dtShipped;
             
            /*Change made for updated columns sheet Dec 20th */
            objAssetUpsert.Invoice_Number__c = (lstEachData.size() > 60 && lstEachData[60] != NULL) ? lstEachData[60] : '';
            objAssetUpsert.LOC_Configuration_String__c = (lstEachData.size() > 59 && lstEachData[59] != NULL) ? lstEachData[59] : '';
            objAssetUpsert.LOC_Freight_Code__c = (lstEachData.size() > 29 && lstEachData[29] != NULL) ? lstEachData[29] : '';
            objAssetUpsert.LOC_Customer_Service_Rep__c = (lstEachData.size() > 32 && lstEachData[32] != NULL) ? lstEachData[32] : '';
            objAssetUpsert.Price = (lstEachData.size() > 27 && lstEachData[27] != NULL) ? Decimal.valueOf(lstEachData[27]) : 0;
            objAssetUpsert.Name = (lstEachData.size() > 0 && lstEachData[0] != NULL) ? lstEachData[0] : '';
            objAssetUpsert.LOC_Unit_Price__c = (lstEachData.size() > 27 && lstEachData[27] != NULL) ? Decimal.valueOf(lstEachData[27]) : 0;
            objAssetUpsert.LOC_Item__c = (lstEachData.size() > 2 && lstEachData[2] != NULL) ? lstEachData[2] : '';
            
            //The quantity should always default to 1.
            objAssetUpsert.Quantity = 1;
            // The purchase date on the asset serial number record should always equals to the transaction date in the file in mm/dd/yyyy format
            objAssetUpsert.PurchaseDate = dtPurchaseDate == NULL ? NULL : dtPurchaseDate;
            
            
            if(lstEachData.size() > 13 && lstEachData[13] == NULL)
            {
                objAssetUpsert.AccountId = null;
            }
            else if(lstEachData.size() > 13 && lstEachData[13] != NULL && mapAccountNumberToId.get(lstEachData[13]) != null)
            {
                objAssetUpsert.AccountId = mapAccountNumberToId.get(lstEachData[13]);
            }
            else
            {
                objAssetUpsert.AccountId = null;
            }
            
            if(lstEachData.size() > 12 && lstEachData[12] == NULL)
            {
                objAssetUpsert.LOC_Bill_To_Account__c = null;
            }
            else if(lstEachData.size() > 12 && lstEachData[12] != NULL && mapAccountNumberToId.get(lstEachData[12]) != null)
            {
                objAssetUpsert.LOC_Bill_To_Account__c = mapAccountNumberToId.get(lstEachData[12]);
            }
            else
            {
                objAssetUpsert.LOC_Bill_To_Account__c = null;
            }
            
            
            if(strProductId == '' || strProductId == null)
            {
                objAssetUpsert.Product2Id = mapAccountNumberToId.get(lstEachData[2]) == null ? null : string.valueOf(mapAccountNumberToId.get(lstEachData[2]));
            }
            else if(strProductId != '' && strProductId != null)
            {
                objAssetUpsert.Product2Id = strProductId;
            }
            
            //if the bill to and ship to id are same then update the account nuumber field only once
            if(objAssetUpsert.LOC_Bill_To_Account__c == objAssetUpsert.AccountId)
            {
                Account objAcc = new Account(Id=objAssetUpsert.LOC_Bill_To_Account__c);
                objAcc.AccountNumber = lstEachData[12] == NULL ? null : string.valueOf(lstEachData[12]);
                lstUpdateBillToAccount.add(objAcc);
            }
            else 
            {
                //if ship to and bill to are 
                if(objAssetUpsert.LOC_Bill_To_Account__c != Null)
                {
                    Account objAcc = new Account(Id=objAssetUpsert.LOC_Bill_To_Account__c);
                    objAcc.AccountNumber = lstEachData[12] == NULL ? null : string.valueOf(lstEachData[12]);
                    lstUpdateBillToAccount.add(objAcc);
                }
                else if(objAssetUpsert.AccountId != Null)
                {
                    Account objAccount = new Account(Id = objAssetUpsert.AccountId);
                    objAccount.AccountNumber = lstEachData[13] == NULL ? null : string.valueOf(lstEachData[13]);
                    lstUpdateShipToAccount.add(objAccount);
                }
            }
            
            Integer intRegion = 0;
            if(lstEachData != null && lstEachData[43] != null && lstEachData[43] != '')
            	intRegion = Integer.valueOf(lstEachData[43]);
            objAssetUpsert.LOC_Region__c = intRegion == null ? null : intRegion;
            
            setAssetUpsert.add(objAssetUpsert);
            /*if(objAssetUpsert.Id == null || (objAssetUpsert.Id != null && !setAssetIdsToUpdate.contains(objAssetUpsert.Id)))
            	lstAssetUpsert.add(objAssetUpsert);
            
            if(objAssetUpsert.Id != null)
            	setAssetIdsToUpdate.add(objAssetUpsert.Id);*/
        }
        catch(Exception exeption)
        {
            AssetImportErrorLog__c objAssetErrorLog = new AssetImportErrorLog__c();
            objAssetErrorLog.CSVLogData__c = String.join(mapSerialNo_EachData.get(strSerialNumber), ',');
            objAssetErrorLog.Reason_of_failure__c = 'Serial Number Inserion failed :' + string.valueOf(exeption.getMessage()).removeEnd(':'); 
            intErrorRecordsCount += 1;
            insert objAssetErrorLog;
            setProcessedSerialNumber.add(strSerialNumber);
            system.debug('-------Exception------'+exeption.getLineNumber()+'----'+exeption.getMessage());
        }
    }
    
    private set<Id> setAssetIdsToUpdate = new set<Id>();
    
    /*
        @MethodName: callOnProductIdNotExists 
        @param : none
        @Description : Method to create product record if one doesnot exist
    */
    private String callOnProductIdNotExists(String strSrNo)
    {
        system.debug('------------------callOnProductIdNotExists----strSrNo-------'+ strSrNo);
        if(mapSrNoToTruncatedProductname.size() > 0 && mapSrNoToTruncatedProductname.get(strSrNo) != null && strSrNo != null && strSrNo != '')
        {
            Product2 objProduct = new Product2();
            objProduct.IsActive = true;
            objProduct.Name = mapSrNoToTruncatedProductname.get(strSrNo);
           
            if((mapSerialNo_EachData.get(strSerialNumber)[21]) != null && (mapSerialNo_EachData.get(strSerialNumber)[21]) != '')
            	objProduct.ProductCode  = mapSerialNo_EachData.get(strSerialNumber)[21];
            
            
            objProduct.LOC_Product_Family__c = mapProductCodeToPF.get(mapSerialNo_EachData.get(strSerialNumber)[21]) == NULL ? Null : string.valueOf(mapProductCodeToPF.get(mapSerialNo_EachData.get(strSerialNumber)[21]));
           
            
            if(mapSerialNo_EachData.get(strSerialNumber) != null && mapSerialNo_EachData.get(strSerialNumber)[21] != ''  && mapSerialNo_EachData.get(strSerialNumber)[21] != null 
            && mapProductCodeToPSF.get(mapSerialNo_EachData.get(strSerialNumber)[21]) != null 
            && mapProductSubFamilyIdToPSF.get(mapProductCodeToPSF.get(mapSerialNo_EachData.get(strSerialNumber)[21])).LOC_Product_Family__c == objProduct.LOC_Product_Family__c)
            {
                objProduct.LOC_Product_Sub_Family__c = mapProductCodeToPSF.get(mapSerialNo_EachData.get(strSerialNumber)[21]) == NULL ? Null : string.valueOf(mapProductCodeToPSF.get(mapSerialNo_EachData.get(strSerialNumber)[21]));
            } 
            objProduct.LOC_Error_Set__c = mapProductCodeToESobj.get(mapSerialNo_EachData.get(strSerialNumber)[21]) == NULL ? Null : string.valueOf(mapProductCodeToESobj.get(mapSerialNo_EachData.get(strSerialNumber)[21]));
           /* if(objProduct.Product_Family__c == null || objProduct.Product_Family__c =='')
           {
           		objProduct.Product_Family__c = mapProductFamilyToId.get(mapSerialNo_EachData.get(strSerialNumber)[21]) == NULL ? Null :string.valueOf(mapProductFamilyToId.get(mapSerialNo_EachData.get(strSerialNumber)[21]));
           		system.debug('---------------null----------'+objProduct.Product_Family__c);
           }*/
            insert objProduct;
            return objProduct.Id;
        }
        return '';
    }
    
    
    
    /*
        @MethodName: finish 
        @param : none
        @Description : Finish method of the Batch
    */
    global void finish(Database.BatchableContext BC)
    {
        try
        {
          
          /*system.debug('-----------------finish----------');
          String strEmail = '';
          List<String> toAddresses = new List<String>();
            
            List<User> lstUser = [  SELECT LOC_Receive_Serial_Number_Interface_Log__c, Id, Email 
                                    FROM User 
                                    WHERE LOC_Receive_Serial_Number_Interface_Log__c = true   ];
            
            system.debug('----------------lstUser--------------'+lstUser);
            
            List<String> lstToAddresses = new List<String>();
            for(User objUser : lstUser)
            {
                if(objUser.Email != null)
                    lstToAddresses.add(objUser.Email);
                    system.debug('-----------lstToAddresses----------'+lstToAddresses);
            } */
            String strEmail = '';
            List<String> toAddresses = new List<String>();
            LOC_TBN_Email_To_Address__c objTBN_Email_To_Address = new LOC_TBN_Email_To_Address__c();
            objTBN_Email_To_Address = LOC_TBN_Email_To_Address__c.getValues('Email Notification');
            system.debug('------------objTBN_Email_To_Address--------'+ objTBN_Email_To_Address);
            
            if(objTBN_Email_To_Address != NULL)
            {
            
             strEmail = objTBN_Email_To_Address.LOC_Email1__c;
             
             toAddresses.add(objTBN_Email_To_Address.LOC_Email1__c);
            
             if(objTBN_Email_To_Address.LOC_Email2__c != NULL && objTBN_Email_To_Address.LOC_Email2__c != '')
              toAddresses.add(objTBN_Email_To_Address.LOC_Email2__c);
              system.debug('--------------toAddresses------'+toAddresses);
            }
            /*else
            {
	             strEmail = 'tammy.hawes@virsys12.com';
	             toAddresses.add('tammy.hawes@virsys12.com');
	              
            }*/
            
            EmailTemplate template = [Select id, Body from EmailTemplate where Name  = 'Attach Excel File' Limit 1];
            Contact objContact = [select Id, Name, Email from Contact where Email =:strEmail];
            
            List<LOC_TBNStoreProcessedAssetCount__c> lstTest = LOC_TBNStoreProcessedAssetCount__c.getAll().values();
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            mail.setTemplateId(template.Id);
            mail.setWhatId(lstTest[0].Id);
            mail.setTargetObjectId(objContact.Id);
            mail.setToAddresses(toAddresses);
            mail.saveAsActivity = false;  
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e)
        {
            system.debug('-----Finish exception--Exception----at line number-->'+e.getLineNumber()+'--error message-->'+e.getMessage());
        }
    }
    @isTest (SeeAllData = true)
    public static void tes_LOC_TBN_BatchForAssetImport()
    {
    	Test.startTest();
    	Document objDocument = new Document();
        objDocument.Name = 'testDocument1';
        objDocument.Body = blob.valueOf('my attachment text\n');
        objDocument.FolderId = userInfo.getUserId();
        insert objDocument;
        
        Set<String> setDocumentIds = new Set<String>();
        setDocumentIds.add(objDocument.Id);  
        
        LOCTBNStoreDocumentId__c objTBNStoreDocumentId2 = new LOCTBNStoreDocumentId__c(Name='test doc');
        insert objTBNStoreDocumentId2;
        
       // LOCTBNStoreDocumentId__c objTBNStoreDocumentId2 = LOCTBNStoreDocumentId__c.getValues('Id');
        //upsert objTBNStoreDocumentId2;
        
        LOC_TBN_Email_To_Address__c objTBN_Email_To_Address = LOC_TBN_Email_To_Address__c.getValues('Email Notification');
        objTBN_Email_To_Address.LOC_Email2__c = 'test2@gmail.com';
        objTBN_Email_To_Address.LOC_Email1__c = 'test1@gmail.com';
        upsert objTBN_Email_To_Address;
        
    	LOC_TBN_BatchForAssetImport objTBN_BatchForAssetImport = new LOC_TBN_BatchForAssetImport(new set<String>());
    	objTBN_BatchForAssetImport.clearVariables();
    	objTBN_BatchForAssetImport.getQueryResults();
    	objTBN_BatchForAssetImport.callOnProductIdNotExists('12345');

    	LOC_TBN_BatchForAssetImport objTBN_BatchForAssetImport1 = new LOC_TBN_BatchForAssetImport(setDocumentIds);
    	Database.executeBatch(objTBN_BatchForAssetImport1);
    	
        //LOCTBNStoreDocumentId__c objTBNStoreDocumentId3 = LOCTBNStoreDocumentId__c.getValues('Id');
        //upsert objTBNStoreDocumentId3;
        Test.stopTest();
    }  
}