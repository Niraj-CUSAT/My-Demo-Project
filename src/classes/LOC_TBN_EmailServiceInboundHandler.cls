/**
* @ClassName    : TBN_EmailServiceInboundHandler 
* @JIRATicket   : 
* @CreatedOn    : 03/Dec/2012
* @ModifiedBy   : 
* @Description  : This is the controller for Inbound email Service
*/

/**
@Developer Name: Santosh
Percentage of best practices followed: 100%
No of SOQL queries used: 
No of global collections used: 2
Exception Handling implemented: Yes
Coding standards followed: Yes
Naming conventions followed: Yes
Third party integrations: No
Maximum of No of records tested with: 5300
Customer Approval: Yes
Last Modified Date: 09/Feb/2013
Approved by: 
Test Coverage : 88%

**/
global class LOC_TBN_EmailServiceInboundHandler implements Messaging.InboundEmailHandler  
{
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
      {
            try
            {
            	set<string> setDocumentIds = new set<string>();
                Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
                list<Document> lstDocuments = new list<Document>();
                Document objDocument = new Document();
                String strDocumentId = '';
                LOCTBNStoreDocumentId__c objTBNStoreDocumentId = LOCTBNStoreDocumentId__c.getValues('Id');
                
                system.debug('-----------objTBNStoreDocumentId----------'+objTBNStoreDocumentId);

                if(email.textAttachments == null && email.binaryAttachments != null)
                {
                	for(integer i = 0 ; i < email.binaryAttachments.size() ; i++)
	                {
	                   system.debug('===test1==='+email.binaryAttachments[i].filename);
	                   if(email.binaryAttachments[i].filename.endswith('.csv')  )
	                   {
		                    objDocument = new Document();
		                    objDocument.Name = email.binaryAttachments[i].filename;
		                    objDocument.Body = email.binaryAttachments[i].body;
		                    objDocument.FolderId = UserInfo.getUserId();
							lstDocuments.add(objDocument);
	                   }
	                }
                }
                
                else if(email.textAttachments != null)
	            { 
	                for(integer i = 0 ; i < email.textAttachments.size() ; i++)
	                {
	                   if(email.textAttachments[i].filename.endswith('.csv')  )
	                   {
	                    objDocument = new Document();
	                    objDocument.Name = email.textAttachments[i].filename;
	                    objDocument.Body = Blob.valueOf(email.textAttachments[i].body);
	                    objDocument.FolderId = UserInfo.getUserId();
	                    lstDocuments.add(objDocument);
	                   }
	                }
	            }
	            
	            if(lstDocuments!= null && lstDocuments.size() >0)
                	insert lstDocuments;
                	
                system.debug('-------------lstDocuments----'+lstDocuments);
                for(Document objDoc : lstDocuments)
                {
                	setDocumentIds.add(objDoc.Id);
                }
              
	            if(setDocumentIds.size() > 0 ) 
	            {
	            	if(!Test.isRunningTest())
                		Id batchInstanceId = Database.executeBatch(new LOC_TBN_BatchForAssetImport(setDocumentIds), 10);
                	return result;
	            }
	            else 
	            	return null;
            }
            catch(Exception e)
            {
                system.debug('=====Exception ======='+e.getLineNumber());
                return null;
            }
        }
        
  /*   @isTest(SeeAllData = true)
       public static void testMethods(){
    	Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        email.subject = 'test Subject 1';
        email.fromName = 'test test';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only.Phone:123456 Bye';
       
        Messaging.InboundEmail.Binaryattachment intBinaryAttch = new Messaging.InboundEmail.Binaryattachment();
        intBinaryAttch.body = Blob.valueOf('H12H00052260,455709,FBN1500-8556,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200-P,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nHS12H00052260,455709,HSAWN601PM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200PM CE,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nH12H00052260,455709,FBN1500-TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712');
        intBinaryAttch.fileName = 'myAttachment1.csv';
        Messaging.InboundEmail.Binaryattachment[] binaryAttach = new Messaging.InboundEmail.Binaryattachment[1];
        binaryAttach[0] = intBinaryAttch;   
        email.binaryAttachments = binaryAttach;
        
        LOC_TBN_EmailServiceInboundHandler objMyHandler = new LOC_TBN_EmailServiceInboundHandler();
        objMyHandler.handleInboundEmail(email, envelope); 
        
        Messaging.InboundEmail.TextAttachment inbTextAttchment1 = new Messaging.InboundEmail.TextAttachment();
        inbTextAttchment1.body = 'H12H00052260,455709,FBN1500-8556,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200-P,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nHS12H00052260,455709,HSAWN601PM,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712\nH12J00052207,400998,HVX0450200PM CE,"CHP,VRT,200 GAL,045KW,480V",,NASH,745375,SO,382460,WO,05-09-2012,1000,2471,2471,07-09-2012,27-07-2012,07-09-2012,07-09-2012,05-09-2012,116373,,70,GC,HVX,EA,1000,1000,81515000,815150,107,700,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,70,PD,PDS,,680722\nG12H20215771,442771,AWN601PM,"AW,NAT,601PM",,DET,747408,SO,378075,WO,05-09-2012,2000,2852,2852,07-09-2012,13-08-2012,07-09-2012,07-09-2012,05-09-2012,P100058368,,70,FM,AWN,EA,2000,2000,106760400,2135208,603,202,0,SALLY,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,20,PD,PDS,,680733\nH12H00052260,455709,FBN1500-TPM CE,"CREST,NATURAL,1500,150# RLV",,NASH,741643,SO,378835,WO,05-09-2012,1000,13173,13173,31-08-2012,26-06-2012,31-08-2012,24-08-2012,05-09-2012,2601551,,110,JR,FBN,EA,2000,2000,183315405,3666308,104,857,0,ABREWING,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,HORNERXPRESS-SOUTH FL,5755 POWERLINE ROAD,,,,FT LAUDERDALE,FL,33309,,,85,PD,PDS,,680712';
        inbTextAttchment1.fileName = 'myAttachment.csv';
        Messaging.InboundEmail.TextAttachment[] textAttachs1 = new Messaging.InboundEmail.TextAttachment[1];
        textAttachs1[0] = inbTextAttchment1;   
        email.textAttachments = textAttachs1;
        
        // setup controller object
         objMyHandler.handleInboundEmail(email, envelope); 
        
       }  */
}