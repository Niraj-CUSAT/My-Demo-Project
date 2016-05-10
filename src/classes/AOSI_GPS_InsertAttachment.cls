@RestResource(urlMapping='/insertattachment/*')
global class AOSI_GPS_InsertAttachment {
@HttpPost
global static String insertattachment(String encodedImage,String docname,String contenttype){
RestRequest req = RestContext.request;
Id parent_Id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);   
Blob pic ;//Blob variable to capture decoded image
if(encodedImage!=null) {
pic=EncodingUtil.base64Decode(encodedImage);//Decode the base64 encoded image 
 }
Attachment a = new Attachment (ParentId = parent_Id,
Body = pic,
ContentType = contenttype,
Name = docname);
insert a;
return a.Id;
}    
}