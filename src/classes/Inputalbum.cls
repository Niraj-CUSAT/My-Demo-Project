public class Inputalbum {

    public List<SelectOption> filesCountList {get; set;}  
    public String FileCount {get; set;}  
      
    public List<Attachment> allFileList {get; set;}  
    public String albumId{get;set;} 
    
    
    public ISP_Store_Album__c testref {get;set;}
    
    public list<ISP_Store_Album__c> albumlist {get;set;}
    public String albumname { get; set; }
    public String storeloc { get; set; }
    public date todate {get; set; }
    public date frmdate { get; set; }
    public List<ISP_Store_Image__c>  imageList { get; set; }
    
    public Attachment att{get;set;}
    
  /*  public Inputalbum(ApexPages.StandardController controller) {
    
        this.testref= (ISP_Store_Album__c)controller.getRecord();
        try{
        testref = [select id,Store_Location__c,To__c,From__c,Name from ISP_Store_Album__c Where Id =:testref.id];
        }catch(Exception e){
            testref = new ISP_Store_Album__c();
        }

    }*/

    
    
    
    
    public Inputalbum(){
      
       albumId = Apexpages.currentPage().getParameters().get('id');
        att    = new Attachment();
        //Initialize    
        filesCountList = new List<SelectOption>() ;  
        FileCount = '' ;  
        allFileList = new List<Attachment>() ;  
        
        //Adding values count list - you can change this according to your need  
        for(Integer i = 1 ; i < 11 ; i++)  
        filesCountList.add(new SelectOption(''+i , ''+i)) ;  
        albumlist  = new list<ISP_Store_Album__c>();
        albumlist  = [select id,Store_Location__c,To__c,From__c,Name from ISP_Store_Album__c];
        
        imageList  = new List<ISP_Store_Image__c>();
       //if(albumId!= null){
        imageList  = [select id, attchment_Id__c,View_Attchment__c,status__c from ISP_Store_Image__c where Store_Album__c =: albumId order by createddate ]; 
       //}    
    }
    
    
    public PageReference insertalb() {
        ISP_Store_Album__c insalbum = new ISP_Store_Album__c();
        insalbum.name=albumname ;
        insalbum.Store_Location__c=storeloc ;
        insalbum.To__c=todate ;
        insalbum.From__c=frmdate ;
        insert insalbum;
        pagereference ref = new pagereference('/apex/InputAlbum');
        ref.setredirect(true);
        return ref;
    }

    
     public Pagereference SaveAttachments()  
    {  
        String accId = System.currentPagereference().getParameters().get('id');  
        if(accId == null || accId == '')  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'No record is associated. Please pass record Id in parameter.'));  
        if(FileCount == null || FileCount == '')  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select how many files you want to upload.'));  
  
        List<Attachment> listToInsert = new List<Attachment>() ;  
          
        //Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);  
        for(Attachment a: allFileList)  
        {  
            if(a.name != '' && a.name != '' && a.body != null)  
                listToInsert.add(new Attachment(parentId = accId, name = a.name, body = a.body)) ;  
        }  
          
        //Inserting attachments  
        if(listToInsert.size() > 0)  
        {  
            insert listToInsert ;  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO, listToInsert.size() + ' file(s) are uploaded successfully'));  
            FileCount = '' ;  
        }  
        else  
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select at-least one file'));  
              
        return null;  
    }  
      
    public PageReference ChangeCount()  
    {  
        allFileList.clear() ;  
        //Adding multiple attachments instance  
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)  
            allFileList.add(new Attachment()) ;  
        return null ;  
    }  
 
    
    
    
}