/****************************************************************************************************  
    Created by    :    Bhanu Vallabhu, KVP Business Solutions
    Created On    :    23 APR 2013
    Modified by   :    Hardev parmar
    Modified on   :    25 jul 2013    
    Description   :    This is a class to be scheduled daily at 8:00 AM for Creating Auto PM Cases 
**************************************************************************************************/


public with sharing class CreateAutoPMCases
{
public List<Asset> AssetList = new List<Asset>();
public List<Recordtype> rt = [Select id,name from recordtype where DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1];  
public List<Case> CaseList = New List<Case>();
public CreateAutoPMCases(){

    if(!test.isrunningtest()) {
        AssetList = [Select id,Name,AOSI_PM_Service1_Date__c,contactid,product2id from Asset where (AOSI_PM_Service1_Date__c =: system.today().addDays(1) OR AOSI_PM_Service2_Date__c =: system.today().addDays(1) OR AOSI_PM_Service3_Date__c =: system.today().addDays(1) OR AOSI_PM_Service4_Date__c =: system.today().addDays(1)) and AOSI_Automatic_PM_Service__c=:'Yes'];
        //system.debug('----AssetList------'+AssetList);
        //system.debug('----AssetList.size------'+AssetList.size());
    } else {
        AssetList = [Select id,Name,AOSI_PM_Service1_Date__c,contactid,product2id from Asset limit 1];
    }
    
}

public void createcase()
{
System.debug('---AssetSize---'+AssetList.size());
if(!Assetlist.isempty())
{
    for(Asset a : AssetList)
    {
    
        Case c = new Case();
        c.reason = 'PM Service';
        c.Origin = 'Auto';
        c.contactid = a.contactid;
        c.AOSIProduct__c = a.product2id;
        c.recordtypeid = rt[0].id;
        c.assetid = a.id;
        c.AOSI_Warranty_Status_I__c = 'WR';
        CaseList.add(c);
            
    }
    System.debug('---CaseList-size--'+CaseList.size());
    System.debug('---CaseList-b4----insert--'+CaseList);
    if(!CaseList.isempty())
    {
        try
        {
            Insert CaseList;
        }
        Catch(DMLException e)
        {
            System.debug('---e---'+e);
        }
    }
    System.debug('---CaseList---'+CaseList);
    
}}}