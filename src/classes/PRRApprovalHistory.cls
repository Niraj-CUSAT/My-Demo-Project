/****Field Name: PRRApprovalHistory
    Created By:Dhriti Krishna Ghosh Moulick
    Modified By:
    Description:This apex class is used to display PRR Approval History records 
*****/
public  class PRRApprovalHistory {

    
    public List<PRR__c> prrApprovalHistory    {get;set;}
    public Integer size                       {get;set;} // 
    public Integer noOfRecords{get; set;}
    
    public Date startDate{get;set;}
    public Date endDate{get;set;}
     
        public ApexPages.StandardSetController setCon {
      get{
        if(setCon == null){ 
          size = 25; 
          setCon = new ApexPages.StandardSetController(prrApprovalHistory);//passing PRR Approval History record list to StandardSetController
          setCon.setPageSize(size); 
          noOfRecords = setCon.getResultSize();
        }
            return setCon;
            }set;
        }
        
        public PRRApprovalHistory(){  
            //startDate    =    System.today().toStartofMonth();
           // endDate      =    System.today().addMonths(1).toStartofMonth().addDays(-1);
            /*prrApprovalHistory = [Select Name,AOSI_PRR_Number__c,AOSI_Case__c,AOSI_Case__r.CaseNumber,Delivered_Date__c,GIN_Date__c,AOSI_Case__r.CreatedDate,                                        
                                (SELECT SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, OriginalActor.LastName,
                                 IsPending,IsDeleted, Id, CreatedDate,CreatedById,ElapsedTimeInDays,Comments, Actor.LastName FROM ProcessSteps  
                                 order by SystemModstamp desc )  FROM PRR__c WHERE CreatedDate >=:startDate AND CreatedDate <=:endDate ORDER BY Name LIMIT 50000];*/
            getAllPRR();
        }
        
        public PageReference filterDate() {
            setCon = null;
            getAllPRR();
            setCon.setPageNumber(1);
            return null;
        }

        
        public List<PRR__c> getAllPRR(){//Initialize setCon and return a list of PRR Approval History records
            if((startDate != null && endDate == null) ) {
                endDate    =   startDate.addMonths(1);   
            } else if(startDate == null && endDate != null) {
                startDate    =    endDate.addMonths(-1);   
            } else if(startDate != null && endDate != null && endDate < startDate) {
                endDate    =   startDate.addMonths(1); 
            } else if(startDate == null && endDate == null) {
                startDate    =    System.today().toStartofMonth();
                endDate      =    System.today().addMonths(1).toStartofMonth().addDays(-1);
            } 
            prrApprovalHistory = [Select Name,AOSI_PRR_Number__c,AOSI_Case__c,AOSI_Case__r.CaseNumber,Delivered_Date__c,GIN_Date__c,AOSI_Case__r.CreatedDate,                                        
                                (SELECT SystemModstamp, StepStatus, RemindersSent, ProcessInstanceId, OriginalActor.LastName,
                                 IsPending,IsDeleted, Id, CreatedDate,CreatedById,ElapsedTimeInDays,Comments, Actor.LastName FROM ProcessSteps  
                                 order by SystemModstamp desc )  FROM PRR__c WHERE CreatedDate >=:startDate AND CreatedDate <=:endDate ORDER BY Name LIMIT 50000];
              List<PRR__c> prrList = new List<PRR__c>();
              for(PRR__c a : (List<PRR__c>)setCon.getRecords())
                prrList.add(a);
              return prrList;
        }
    
        public pageReference refresh() {  // Method is used to refresh the page
      setCon = null;
      getAllPRR();
      setCon.setPageNumber(1);
      return null;
    }
    
    public Boolean hasNext {//Property to identify which records should display in next page
      get {
        return setCon.getHasNext();
      }
      set;
    }
    
    public Boolean hasPrevious {//Property to identify which records should display in previous page
      get {
        return setCon.getHasPrevious();
      }
      set;
    }
  
    public Integer pageNumber {//Property to display pageNumber in Page
      get {
        return setCon.getPageNumber();
      }
      set;
    }
    
    public void first() {//Method to display PRR Approval History first records which set in page size 
      setCon.first();
    }
    
    
    public void last() {//Method to display PRR Approval History last records 
      setCon.last();
    }
    
    public void previous() {//Method to display PRR Approval History  previous records which set in page size 
      setCon.previous();
    }
    
    public void next() {//Method to display PRR Approval History  next records which set in page size 
      setCon.next();
    }
    
    public pagereference Download(){  // Method is used to download VF page as Excel format
      PageReference exdownload = null;
      exdownload = Page.PRR_ApprovalHistory_Report_Export;
      exdownload.setRedirect(false);        
      return exdownload ;
    }
    
    public pagereference DownloadAll(){// Method is used to download VF page as Excel format
      PageReference exdownload = null;
      exdownload = Page.PRR_ApprovalHistory_Report_Export_All;
      exdownload.setRedirect(false);        
      return exdownload ;
    }
}