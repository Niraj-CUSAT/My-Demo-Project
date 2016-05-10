public with sharing class CaseNewController
{
public List<SelectOption> countrieLst {get;set;}
public List<Product_Customer_Concern__c> concerns{get;set;}
public String s{get;set;}
public String selectedCountry{get;set;}
Case c{get;set;}

public CaseNewController(ApexPages.standardController controller)
{

c=(Case) controller.getRecord();
countrieLst = new List<SelectOption>();
countrieLst.add(new SelectOption('None','None'));
//processconcerens();
}

public PageReference save() {
system.debug('Case***'+c);
insert c;
return null;
}

public void processconcerens()
{
s='';
String sss=c.AOSIProduct__c;
//String sss='01te0000002hWU7';
List<Product_Customer_Concern__c> cc=Database.query('select Customer_Concern__r.Customer_Concern__c from Product_Customer_Concern__c where Product__c =:sss'); 
if(cc.size()>0)
{
for(Product_Customer_Concern__c c:cc)
{
s=s+' :: '+c.Customer_Concern__r.Customer_Concern__c;
countrieLst.add(new SelectOption((String)c.Customer_Concern__r.Customer_Concern__c,(String)c.Customer_Concern__r.Customer_Concern__c));
 
}
}
}    

}