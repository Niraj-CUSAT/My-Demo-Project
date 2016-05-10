/***************************************************************************
Created By :tanay.barman@kvpcorp.com
Created Date : Jun 15, 2015

Description : This class supports the following 
operations, related to  Document upload to AWS s3:

1. Policy generate for AWS .
2. Generate The HMAC-SHA256 hash of the security policy.  

********************************************/

global with sharing class AWS_Upload {
    
    public AWS_Upload(ApexPages.StandardController controller) {
   
    }
      
    public  Document__c newDocument{get;set;}
    Public  static AWS_Keys__c awsKeySet{get;set;}
    public static Id candidateid{get;set;}
    public string ForRedirect{get;set;}  
    public static string appParentId{get;set;}
    public string Content_Type {get;set;}  
    Public String acessType{get;set;}
    public AWS_Upload(){
        newDocument = new Document__c();
        awsKeySet= AWS_Keys__c.getInstance('kvpupload');
        appParentId = ApexPages.currentPage().getParameters().get('parentIdForRedirect');
        if(ApexPages.currentPage().getParameters().get('id')!=null)
        {
        candidateid = ApexPages.currentPage().getParameters().get('id');
        }
        ForRedirect = URL.getSalesforceBaseUrl().toExternalForm()+'/'+'apex/AWS_SucessRedirectPage?parentIdForRedirect='+appParentId+'&cid='+candidateid;
        Content_Type ='multipart/form-data';
        acessType ='private';
        system.debug('awsKeySet'+awsKeySet); 
        system.debug('policy'+policy);
        system.debug('candidateid'+candidateid);
    }
    
    
    Datetime expire = system.now().addDays(1);
    String formattedexpire = expire.formatGmt('yyyy-MM-dd')+'T'+ expire.formatGmt('HH:mm:ss')+'.'+expire.formatGMT('SSS')+'Z';           
    
    string policy { get {return 
        '{ "expiration": "'+formattedexpire+'","conditions": [ {"bucket": "'+
        awsKeySet.Bucket_Name__c+'" } ,{ "acl": "'+acessType+'" },'+
        '{"content-type":"'+Content_Type+'"},'+
        '{"success_action_redirect": "'+ForRedirect+'"},' +
        '["starts-with", "$key", ""] ]}';   } } 
    
    public String getPolicy() {
        return EncodingUtil.base64Encode(Blob.valueOf(policy));
    }
    
    public String getSignedPolicy() {    
        return make_sig(EncodingUtil.base64Encode(Blob.valueOf(policy)));        
    }
    
    
    //method that will sign
    private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(awsKeySet.AWS_Secret_Key__c)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    @RemoteAction
    public static Document__c createNewDocument(String appID, String uploadedFilename,string bucketName,String candidate_id){
        system.debug('appID'+appID);
        system.debug('uploadedFilename'+uploadedFilename);
        system.debug('bucketName'+bucketName);
        system.debug('candidateiddddd'+candidate_id);
        //System.debug('ApexPages.rameters() currentPage().getPa'+ApexPages.currentPage().getParameters().get('cid')); 
        Document__c newDocument = new Document__c();
        newDocument.Application__c = appID;
        newDocument.Document_Name__c = uploadedFilename;
        newDocument.Document_URL__c =  getFileURL(uploadedFilename);
        newDocument.Status__c ='Uploaded';
        newDocument.Candidate__c=candidate_id;
        
        insert  newDocument;
        
        return newDocument;  
        
    }
    //method that will sign
    private static String make_sign(string canonicalBuffer) {  
        awsKeySet= AWS_Keys__c.getInstance('kvpupload');
        String macUrl ;
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(awsKeySet.AWS_Secret_Key__c)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    webservice static String getFileURL(String file)
    {
        awsKeySet= AWS_Keys__c.getInstance('kvpupload');
        String bucketname=awsKeySet.Bucket_Name__c;
        //get the filename in urlencoded format
        String filename = EncodingUtil.urlEncode(file, 'UTF-8');
        System.debug('redirectToS3Key filename: ' + file);
        Datetime now = DateTime.now();
        //Link expiry time  : 3 minutes
        Datetime expireson = now.AddSeconds(180);
        Long Lexpires = expireson.getTime()/1000;
        System.debug('key: ' + awsKeySet.AWS_AccessKey_Id__c);
        System.debug('secret: ' + awsKeySet.AWS_Secret_Key__c);
        //String codedFilename=  EncodingUtil.urlEncode(filename,'UTF-8');
        // System.debug('codedFilename: '+codedFilename); 
        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucketname+'/'+filename;
        System.debug('redirectToS3Key stringstosign: ' + stringtosign);
        String signed = make_sign(stringtosign);
        System.debug('signed: ' + signed);
        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        System.debug('codedsigned: ' + codedsigned);
        String url = 'http://'+bucketname+'.s3.amazonaws.com/'+filename+'?AWSAccessKeyId='+awsKeySet.AWS_AccessKey_Id__c+'&Expires='+Lexpires+'&Signature='+signed;
        System.debug('url: ' + url);
        return url;
        
    }   
    
}