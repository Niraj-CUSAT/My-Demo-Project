/*
this class serves as a controller for custom lookup for customer
*/
public with sharing class LOC_contCustomLookupCustomer {

    public Contact Customer {get;set;} //current record
    public List<Contact> lstResults{get;set;} // search results
    public string SearchCustomer{get;set;} // search keyword  
    public string SearchEmail{get;set;}//search keyword for Email
    public string SearchPhone{get;set;}//search keyword for Phone
    public string ValueTextBox{get;set;}//to pass created record value in lookup
    public string ValueFormTag{get;set;} //form id
    public string Id{get;set;}// record id of created record
    public string Name{get;set;}   //record name of created record
     
    public LOC_contCustomLookupCustomer() {
        Customer = new Contact();        
        // get the current search string
        SearchCustomer = System.currentPageReference().getParameters().get('lksrch');
        runSearch();         
    }
     
    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }
     
    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        lstResults = performSearch(SearchCustomer);               
    } 
     
    // run the search and return the records found. 
    private List<Contact> performSearch(string aSearchCustomer) {
        
        if((aSearchCustomer!=null && aSearchCustomer!='' ) && aSearchCustomer.contains('*'))
            aSearchCustomer=aSearchCustomer.replace('*', '%');
        if((SearchEmail!=null && SearchEmail!='' ) && SearchEmail.contains('*'))
            SearchEmail=SearchEmail.replace('*', '%');
        if((SearchPhone!=null && SearchPhone!='' ) && SearchPhone.contains('*'))
            SearchPhone=SearchPhone.replace('*', '%');
        String soql = 'select id, Name, Email,Phone  from Contact';
        if((aSearchCustomer != '' && aSearchCustomer != null) || (SearchEmail != '' && SearchEmail != null) || (SearchPhone!=null && SearchPhone!=''))
            soql= soql + ' where ';
        if(aSearchCustomer != '' && aSearchCustomer != null)
          soql = soql +  'Name LIKE \'' + aSearchCustomer +'%\'';
        if(aSearchCustomer != '' && aSearchCustomer != null && SearchEmail != '' && SearchEmail != null)
            soql= soql + ' and';
        if(SearchEmail!=null && SearchEmail!='')
            soql=soql + ' Email LIKE \''+SearchEmail+'%\'';
        if((aSearchCustomer!=null && aSearchCustomer!='' && SearchPhone!=null && SearchPhone!='') || (SearchEmail!=null && SearchEmail!='' && SearchPhone!=null && SearchPhone!=''))
            soql=soql+' and ';
        if(SearchPhone!=null && SearchPhone!='')
            soql=soql+ ' Phone LIKE \''+SearchPhone+'%\'';
        soql = soql + ' limit 100';
        System.debug(soql);
        return database.query(soql); 
     
    }            
     
    // save the new customer
    public PageReference saveCustomer() {
        try{
            insert Customer;
            Id=Customer.Id;
            Name=Customer.FirstName+' '+Customer.LastName;
            ValueTextBox=System.currentPageReference().getParameters().get('txt');
            ValueFormTag=System.currentPageReference().getParameters().get('frm');
        }        
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        return null;        
    }
     
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
     
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
    public void dummy() {
      
    }
    

     static testMethod void TestLOC_contCustomLookupCustomer(){            
        
        Contact con = new Contact();
        con.FirstName='Test';
        con.LastName='Record';
        con.Email='test@record.com';
        con.Phone = '999999978';
        insert con;
        
        LOC_contCustomLookupCustomer iCustomer = new LOC_contCustomLookupCustomer();
        iCustomer.SearchCustomer='Test*';
        iCustomer.SearchEmail='test*';
        iCustomer.search();
        iCustomer.Customer.FirstName='Test';
        iCustomer.Customer.LastName='User';
        iCustomer.Customer.Email='test@email.com';      
        iCustomer.saveCustomer();
        iCustomer.getFormTag();
        iCustomer.getTextBox();
        
        iCustomer.SearchCustomer='';
        iCustomer.SearchEmail='test*';
        iCustomer.SearchPhone='1234*';
        iCustomer.search();
        iCustomer.Customer.FirstName='Test';
        iCustomer.Customer.LastName='User';
        iCustomer.Customer.Email='test@email.com';      
        iCustomer.saveCustomer();
        iCustomer.getFormTag();
        iCustomer.getTextBox();
        
    } 

}