/**
* @ClassName    : TBN_CaseInLine 
* @Description  : This class will fetch the alert messages that will be helpful to the Call Center agent, after the creation of a Case record and
                    the alert messages are shown in an Inline visualforce page in the Case detail page. 
*/
public with sharing class TBN_CaseInLine {
    /* Start : Class Variables */

    public Set<String> setAlertMessages{get; set;}
    public List<String> lstAlertMessages;
    public String strCaseId = '';
    public String strPageContent = '';
    public String strObjectType{get; set;}
    /* End : Class Variables */
    
    /**
      Method Name   : Constructor
      Description   : Does initialize the class variables and performs the actions needed on page load
    **/
    public TBN_CaseInLine(ApexPages.StandardController  con)  
    {
        strCaseId = con.getId();
        strObjectType = 'Account';
        setAlertMessages = new Set<String>();
        lstAlertMessages = new List<String>();
    }
    
    /**
      Method Name   : getAlertMessages
      Description   : Formulates the respective alert messages of a Case record.
    **/
    public void getAlertMessages()
    {
        //  Method Variables
        List<String> options = new List<String>();
        
        PageReference pr = page.TBN_AlertsForCaseDetail;
        pr.getParameters().put('recordId', strCaseId);
        pr.getParameters().put('objectType', ApexPages.currentPage().getParameters().get('SObject'));
        
        try{
            strPageContent = pr.getContent().toString();
        }
        catch(Exception e)
        {
            strPageContent = '<li>Exception: Unable to process the large data</li>';
        }
        //  Fetches the Data that is in between the '<li>' tags
        Matcher mchr = Pattern.compile('<li>(.+?)</li>').matcher(strPageContent);
        //  Takes each matched pattern and adds it to a list of String type 
        while(mchr.find()) 
        {
            options.add(mchr.group(1));
        } 
        if (!options.isEmpty()) 
        {
            lstAlertMessages.addall(options);
            setAlertMessages = new Set<String>();
            setAlertMessages.addAll(lstAlertMessages);
        }
    }
    
    /**
      Method Name   : testTBN_CaseInLine
      Description   : Test Method.
    **/
    public static testMethod void testTBN_CaseInLine()
    {
        Account objAccount = new Account(Name = 'Test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'Test Contact', Phone = '999999989');
        insert objContact;
        Product2 objProduct = new Product2(Name = '12356789');
        insert objProduct;
        Asset objAsset = new Asset(Name = '1362979791884', product2Id = objProduct.Id, AccountId = objAccount.Id);
        insert objAsset;
        Case objCase = new Case(AccountId = objAccount.Id, ContactId = objContact.Id, AssetId = objAsset.Id);
        insert objCase;
        ApexPages.StandardController objCon = new ApexPages.StandardController(objCase);
        TBN_CaseInLine objClass = new TBN_CaseInLine(objCon);
        objClass.getAlertMessages();
    }
}