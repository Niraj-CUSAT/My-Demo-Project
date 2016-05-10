public class StoreimagesController {
    
     //Getting all store images of current album
     @AuraEnabled
     public static list<ISP_Store_Image__c> allStoreImages(Id parentId){
     
        list<ISP_Store_Image__c> imageList =  new list<ISP_Store_Image__c>();
        return [select id,Attchment_ID__c,status__c,Description__c ,createddate from ISP_Store_Image__c where Store_Album__c =: parentId order by createddate desc];
        
     }
    
    @AuraEnabled
    public static list<ISP_Store_Image__c>  saveStoreImage(Id parentId, String fileName, String base64Data, String contentType,String description) { 

        ISP_Store_Image__c image = new ISP_Store_Image__c( Store_Album__c =  parentId, Description__c = description);
        insert image;
        
        //Inserting Attachment
        if(image != null){ 
            base64Data   = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment a  = new Attachment();
            a.parentId    = image.id;
            a.Body        = EncodingUtil.base64Decode(base64Data);
            a.Name        = fileName;
            a.ContentType = contentType;
            insert a;
        }
        submitForApproval(image.id);
        return allStoreImages(parentId);
        
    }

  /*  @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = :fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        
        update a;
    }*/
    
    // Method to sumbmit a record for Approval 
    public static void submitForApproval(Id localId) {
        // Create an approval request for the account
   
        Approval.ProcessSubmitRequest req1 =
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(localId);
       
        // Submit the approval request for the account
   
        Approval.ProcessResult result = Approval.process(req1);
       
        // Verify the result
   
        System.assert(result.isSuccess());
       
        System.assertEquals(
            'Pending', result.getInstanceStatus(),
            'Instance Status'+result.getInstanceStatus());       

    }
    
    
    @AuraEnabled
    public static list<ISP_Store_Image__c>  updateStoreImage(Id parentId, Id recId, Id attId, String fileName, String base64Data, String contentType, String description) { 

        ISP_Store_Image__c image = new ISP_Store_Image__c( Store_Album__c =  parentId, Id = recId, Description__c = description);
        update image;
        
        //Inserting Attachment
        if(image != null){ 
            
            base64Data   = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            Attachment a  = new Attachment();
            a.parentId    = image.id;
            a.Body        = EncodingUtil.base64Decode(base64Data);
            a.Name        = fileName;
            a.ContentType = contentType;
            insert a;
            
            try{
                Attachment attToDelete  = new Attachment(Id = attId);
                delete attToDelete ;
            }catch(Exception e){
            
            }
        }
        submitForApproval(image.id);
        return allStoreImages(parentId);
        
    }
}