public class ISP_StoreAlbumTest {

    public ISP_StoreAlbumTest(ApexPages.StandardController controller) {
        
        listIndexNum= 0; 
        album       = new ISP_Store_Album__c();
        imgWrapList = new list<ImageWrapper>();
        albumId     = 'a2le0000000OziM';//Apexpages.currentPage().getParameters().get('id');
        album       = [select id, name  from ISP_Store_Album__c where id =:albumId];
        imageList   = [select id, attchment_Id__c,View_Attchment__c from ISP_Store_Image__c where Store_Album__c =: albumId order by createddate ]; 
        pictureId = imageList[listIndexNum].id;
        
        for(ISP_Store_Image__c img : imageList){
             ImageWrapper imgWrap =  new ImageWrapper();
             imgWrap.recId = img.id;
             imgWrap.attachment_id= img.attchment_Id__c;
             imgWrapList.add(imgWrap);
              
        }
    }

    
    public ISP_Store_Album__c album          {get;set;} 
    public String albumId                    {get;set;}
    public list<ISP_Store_Image__c> imageList{get;set;}
    public integer listIndexNum              {get;set;} 
    public String pictureId                  {get;set;} 
    
    public list<ImageWrapper> imgWrapList    {get;set;} 
    public ISP_StoreAlbumTest(){
        
    }
    
    public void toNavigate(){
    
        if(listIndexNum < imageList.size()){
            pictureId = imageList[listIndexNum].id;
        }
    }
    
     //Rejecting the record
    public void pictureApprove(){
    
        ProcessInstance pis = [select id, (select id,ActorId, ProcessInstanceId from Workitems) from processInstance 
                               where targetObjectId =:pictureId AND status = 'Pending'];
        if(pis.Workitems != null){
            approval.processWorkItemRequest req =  new Approval.ProcessworkItemRequest();
            req.setAction('Approve');
        }
    
    }
    
    //Rejecting the record
    public void pictureReject(){
        list<ISP_Store_Image__feed> imageFeed = [select id,(select id from feedComments) from ISP_Store_Image__feed where parentId =:pictureId];
            
            if(imageFeed[0].feedComments.size() > 0 ){ 
                ProcessInstance pis = [select id, (select id,ActorId, ProcessInstanceId from Workitems) from processInstance where targetObjectId =:pictureId AND status = 'Pending'];
                if(pis.Workitems != null){
                    approval.processWorkItemRequest req =  new Approval.ProcessworkItemRequest();
                    req.setAction('Reject');
                }
            }else{
                    Apexpages.AddMessage(new Apexpages.Message(Apexpages.severity.Error,'Feed comment is requied when rejecting the record'));
            }
    }
    
    
    public class ImageWrapper{
        public String recId{get;set;}
        public String attachment_id{get;set;}
    }
}//ISP_Store_Image__c