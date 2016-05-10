/*#########################################################################
# File..................: AssetHelper
# API Version...........: 20
# Created by............: Vikram Middha
# Created Date..........: 22-Sep-2011
# Last Modified by......: Vikram Middha
# Last Modified Date....: 
# Description...........: This is a helper class for Asset Triggers.
                        
# Copyright (c) 2000-2010. Astadia, Inc. All Rights Reserved.
#
# Created by the Astadia, Inc. Modification must retain the above copyright notice.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any commercial purpose, without fee, and without a written
# agreement from Astadia, Inc., is hereby forbidden. Any modification to source
# code, must include this paragraph and copyright.
#
# Permission is not granted to anyone to use this software for commercial uses.
#
# Contact address: 2839 Paces Ferry Road, Suite 350, Atlanta, GA 30339
# Company URL : http://www.astadia.com
###########################################################################*/ 
public class AssetHelper {

    public static Boolean processedAssetInsert = false;
    public static Boolean processedAssetUpdate = false;
    public static Boolean replacementUnitProcessing = false;
    public static Map<Asset,Contact> toBeCreatedAJMapAfterTrigger = new Map<Asset,Contact>();
    public static Map<AssetContactJunction__c,Asset> assetAJMapAfterTrigger = new Map<AssetContactJunction__c,Asset>();
    
    public Boolean getProcessedAssetInsert(){
        return processedAssetInsert;
    }
    public void setProcessedAssetInsert(Boolean val){
        processedAssetInsert = val;
    }
    
    public Boolean getReplacementUnitProcessing (){
        return replacementUnitProcessing ;
    }
    public void setReplacementUnitProcessing (Boolean val){
        replacementUnitProcessing = val;
    }
    
    public Boolean getProcessedAssetUpdate(){
        return processedAssetUpdate;
    }
    public void setProcessedAssetUpdate(Boolean val){
        processedAssetUpdate = val;
    }
    
    public AssetHelper(){
        
    }
    
    public void updateReplacementUnit(Map<Id,Asset> assetMap){
        
        Set<Id> replacementUnitSet = new Set<Id>();
        List<Asset> toBeUpdatedAsset = new List<Asset>();
        List<AssetContactJunction__c> acToBeInsertedList = new List<AssetContactJunction__c>();
        List<AssetContactJunction__c> acToBeDeletedList = new List<AssetContactJunction__c>();
        Map<Id,AssetContactJunction__c> registeredOwnerMap ;
        List<AssetContactJunction__c> delRegOwnList = new List<AssetContactJunction__c>();
        Map<Id,AssetContactJunction__c> registeredOwnerMapForDelete = new Map<Id,AssetContactJunction__c>() ;
        
        for(Id id: assetMap.keySet()){
            replacementUnitSet.add(assetMap.get(id).replacement__c);
        }
        
        system.debug('---- replacementUnitSet ----'+replacementUnitSet);
        
        Map<Id,Asset> repAssetMap = new Map<Id,Asset>([select id,Registered_Owner__c,Install_Street__c,Install_City__c,Install_Country__c
                                        ,Install_Postal_Code__c,Install_State__c,InstallDate,Installation_Type__c,Physical_Location__c,Telephone__c
                                        ,Professionally_Installed__c,Email__c,Labor_Warranty_Expiration__c,Parts_Warranty_Expiration__c,Tank_Warranty_Expiration__c
                                         from Asset where Id IN :replacementUnitSet]);
        system.debug('---- repAssetMap ----'+repAssetMap);
                                         
        registeredOwnerMap = new Map<Id,AssetContactJunction__c>([select Asset__c,Contact__c from AssetContactJunction__c where Asset__c IN :
                                    assetMap.keySet() and Contact__r.Contact_Type__c = 'Asset Owner']); 
        
        system.debug('---- registeredOwnerMap ----'+registeredOwnerMap);
       
        delRegOwnList = [select Asset__c,Contact__c from AssetContactJunction__c where Asset__c IN :
                                    replacementUnitSet and Contact__r.Contact_Type__c = 'Asset Owner'];
        
        system.debug('---- delRegOwnList ----'+delRegOwnList);
                                    
        if(delRegOwnList.size() >0){
            for(AssetContactJunction__c ac : delRegOwnList){
                registeredOwnerMapForDelete.put(ac.Asset__c,ac);
            }
        }                               
                                            
        Map<Id,Id> assetContactMap = new Map<Id,Id>();
        
        if(registeredOwnerMap.keySet().size() >0){
            for(AssetContactJunction__c ac : registeredOwnerMap.values()){
                assetContactMap.put(ac.Asset__c,ac.Contact__c);
                registeredOwnerMapForDelete.put(ac.Asset__c,ac);
            }                                                    
        }
        System.debug('=======assetContactMap==='+assetContactMap);                                   
        for(Asset a: assetMap.values()){
            Asset updAsset = repAssetMap.get(a.replacement__c);
            if(updAsset != null){
                updAsset.Registered_Owner__c = a.Registered_Owner__c;
                updAsset.Install_Street__c = a.Install_Street__c;
                updAsset.Install_City__c = a.Install_City__c;
                updAsset.Install_Country__c = a.Install_Country__c;
                updAsset.Install_Postal_Code__c = a.Install_Postal_Code__c;
                updAsset.Install_State__c = a.Install_State__c;
                updAsset.InstallDate = a.InstallDate;
                updAsset.Installation_Type__c = a.Installation_Type__c;
                updAsset.Physical_Location__c = a.Physical_Location__c;
                updAsset.Professionally_Installed__c = a.Professionally_Installed__c;
                updAsset.Labor_Warranty_Expiration__c = a.Labor_Warranty_Expiration__c;
                updAsset.Parts_Warranty_Expiration__c = a.Parts_Warranty_Expiration__c;
                updAsset.Tank_Warranty_Expiration__c = a.Tank_Warranty_Expiration__c;
                updAsset.Email__c = a.Email__c;
                updAsset.Telephone__c = a.Telephone__c;
                toBeUpdatedAsset.add(updAsset);
                System.debug('=======assetContactMap.get(a.Id)==='+assetContactMap.get(a.Id));
                if(assetContactMap.get(a.Id) != null){
                    AssetContactJunction__c ac = new AssetContactJunction__c();
                    ac.Asset__c = updAsset.Id;
                    ac.Contact__c = assetContactMap.get(a.Id);
                    acToBeInsertedList.add(ac);
                    System.debug('=======registeredOwnerMapForDelete==='+registeredOwnerMapForDelete);
                    System.debug('=======updAsset.Id==='+updAsset.Id);
                    if(registeredOwnerMapForDelete.get(updAsset.Id) != null)
                        acToBeDeletedList.add(registeredOwnerMapForDelete.get(updAsset.Id));
                }
                System.debug('=======acToBeDeletedList==='+acToBeDeletedList);
            }
        }   
        if(acToBeDeletedList.size() >0)
            delete acToBeDeletedList;                            
        if(toBeUpdatedAsset.size() >0)
            update toBeUpdatedAsset;
        if(acToBeInsertedList.size()>0)
            insert acToBeInsertedList;  
    }
    
    public static void ownerRegistration(List<Asset> assetList, Set<Id> assetIdSet, Set<String> assetEmailSet){
        
        List<AssetContactJunction__c> toBeDeletedAJ = new List<AssetContactJunction__c>();                      
        List<Contact> toBeUpdateContacts = new List<Contact>();
        List<Contact> toBeCreatedContacts = new List<Contact>();
        List<AssetContactJunction__c> toBeCreatedAJList = new List<AssetContactJunction__c>();
        Map<AssetContactJunction__c,Contact> toBeCreatedAJMap = new Map<AssetContactJunction__c,Contact>();
        Map<Id,Contact> assetContactMap = new Map<Id,Contact>();
        Map<Id,AssetContactJunction__c> assetAJMap = new Map<Id,AssetContactJunction__c>();
        
        List<AssetContactJunction__c> ajList = new List<AssetContactJunction__c>();
         
        if(assetIdSet.size() >0){
            ajList = [Select a.Contact__r.Id,a.Contact__r.Email,Contact__r.FirstName,Contact__r.LastName,a.Asset__c,  a.Contact__r.Phone 
                                    From AssetContactJunction__c a where Asset__r.Id IN :assetIdSet and Contact__r.Contact_Type__c = 'Asset Owner'];
        }                       
        
        List<Contact> ownerContactList = new List<Contact>();
        
        if(assetEmailSet.size() >0){
            ownerContactList=[select Id,Phone,Email,FirstName,LastName,MailingStreet,MailingState,MailingPostalCode,MailingCountry,MailingCity 
                                            from Contact 
                                            where Contact_Type__c = 'Asset Owner' and Email IN :assetEmailSet];
        }                                   
                                            
        Map<String,Contact> emailContactMap = new Map<String,Contact>();
        
        if(ownerContactList.size() >0){
            for(Contact c: ownerContactList){
                emailContactMap.put(c.Email,c);
            }
        }                                   
        
        if(ajList.size() >0){
            for(AssetContactJunction__c aj : ajLIst){
                assetContactMap.put(aj.Asset__c,aj.Contact__r);
                assetAJMap.put(aj.Asset__c,aj);
            }
        }
                
        for(Asset a : assetList){
            Boolean contactFound = false;
            if(assetContactMap.get(a.Id) != null){
                if(a.Registered_Owner__c == null && a.Telephone__c == null && a.Email__c == null){
                    toBeDeletedAJ.add(assetAJMap.get(a.Id));
                }else{
                    if(a.Registered_Owner__c == null){
                        a.addError('Contact Last Name cannot be Blank.');
                        continue;
                    }
                    
                    if(ContactHelper.processAssetOwnerUpdate){  // Added By GOVIND THATHERA - 6/12/2014 - Don't update Contact it this Asset trigger is triggered by a Contact record itself
                        Contact ownerContact = assetContactMap.get(a.Id);
                        ownerContact.MailingStreet = a.Install_Street__c;
                        ownerContact.MailingState = a.Install_State__c;
                        ownerContact.MailingPostalCode = a.Install_Postal_Code__c;
                        ownerContact.MailingCountry = a.Install_Country__c;
                        ownerContact.MailingCity = a.Install_City__c;
                        ownerContact.FirstName = getFirstLastName(a.Registered_Owner__c,0);
                        ownerContact.Phone = a.Telephone__c;
                        ownerContact.LastName = getFirstLastName(a.Registered_Owner__c,1);
                        ownerContact.Email = a.Email__c;
                        toBeUpdateContacts.add(ownerContact);
                    }
                }
            }else{
                if(a.Email__c != null){
                    if(emailContactMap.get(a.Email__c) != null){
                        contactFound = true;
                        Contact ownerContact = emailContactMap.get(a.Email__c);
                        AssetContactJunction__c aj = new AssetContactJunction__c();
                        aj.Contact__c = ownerContact.Id;
                        if(a.Id != null){
                            aj.Asset__c = a.Id;
                            toBeCreatedAJList.add(aj);
                        }else{
                            toBeCreatedAJMapAfterTrigger.put(a,ownerContact);
                        }
                        ownerContact.MailingStreet = a.Install_Street__c;
                        ownerContact.MailingState = a.Install_State__c;
                        ownerContact.MailingPostalCode = a.Install_Postal_Code__c;
                        ownerContact.MailingCountry = a.Install_Country__c;
                        ownerContact.MailingCity = a.Install_City__c;
                        toBeUpdateContacts.add(ownerContact);
                        a.Registered_Owner__c = ownerContact.FirstName + ' ' + ownerContact.LastName;
                        a.Telephone__c = ownerContact.Phone;
                    }
                }
                if(contactFound == false && a.Registered_Owner__c != null){
                    Contact newContact = new Contact();
                    newContact.FirstName = getFirstLastName(a.Registered_Owner__c,0);
                    newContact.LastName = getFirstLastName(a.Registered_Owner__c,1);
                    newContact.Phone = a.Telephone__c;
                    newContact.Email = a.Email__c;
                    newContact.Contact_Type__c = 'Asset Owner';
                    newContact.MailingStreet = a.Install_Street__c;
                    newContact.MailingState = a.Install_State__c;
                    newContact.MailingPostalCode = a.Install_Postal_Code__c;
                    newContact.MailingCountry = a.Install_Country__c;
                    newContact.MailingCity = a.Install_City__c;
                    AssetContactJunction__c aj = new AssetContactJunction__c();
                    if(a.Id != null){
                        aj.Asset__c = a.Id;
                        toBeCreatedAJMap.put(aj,newContact);
                    }else{
                        toBeCreatedAJMapAfterTrigger.put(a,newContact);
                        
                    }
                    //toBeCreatedAJList.add(aj);
                    
                }
            }
        }
        
        if(toBeDeletedAJ.size() > 0){
            Database.delete(toBeDeletedAJ,false);
        }
        if(toBeUpdateContacts.size() > 0){
            Database.update(toBeUpdateContacts,false);
        }
        if(toBeCreatedContacts.size() > 0){
            Database.insert(toBeCreatedContacts,false);
        }       
        if(toBeCreatedAJList.size() > 0){
            Database.insert(toBeCreatedAJList,false);
        }
        if(toBeCreatedAJMap.keySet().size() > 0){
            toBeCreatedAJList.clear();
            Database.insert(toBeCreatedAJMap.values(),false);
            for(AssetContactJunction__c aj : toBeCreatedAJMap.keySet()){
                aj.Contact__c = toBeCreatedAJMap.get(aj).Id;
                toBeCreatedAJList.add(aj);
            }
            if(toBeCreatedAJList.size() > 0){
                Database.insert(toBeCreatedAJList,false);
            }
        }               
    }
    
    private static String getFirstLastName(String name, Integer i){
        if(name == null){
            return null;
        }
        Integer index = name.lastIndexOf(' ');
        if(i==0){
            if(index == -1)
                return null;
            else    
                return name.substring(0, index);            
        }else{
            if(index == -1)
                return name;
            else    
                return name.substring(index, name.length());
        }
    }
    
    public static void processAJRecordsFromBeforeTrigger(Map<String,Id> assetSNMap){
        
        List<AssetContactJunction__c> toBeCreatedAJList = new List<AssetContactJunction__c>();
        System.debug('====toBeCreatedAJMapAfterTrigger1===' + toBeCreatedAJMapAfterTrigger);
        if(toBeCreatedAJMapAfterTrigger.keySet().size() > 0){
            if(toBeCreatedAJMapAfterTrigger.values().get(0).Id == null){
                Database.insert(toBeCreatedAJMapAfterTrigger.values(),false);
            }
            System.debug('====toBeCreatedAJMapAfterTrigger2===' + toBeCreatedAJMapAfterTrigger);
            for(Asset a : toBeCreatedAJMapAfterTrigger.keySet()){
                AssetContactJunction__c aj = new AssetContactJunction__c();
                if(toBeCreatedAJMapAfterTrigger.get(a) != null)
                    aj.Contact__c = toBeCreatedAJMapAfterTrigger.get(a).Id;
                aj.Asset__c = assetSNMap.get(a.SerialNumber);
                toBeCreatedAJList.add(aj);
                System.debug('====toBeCreatedAJList===' + toBeCreatedAJList);
            }
            if(toBeCreatedAJList.size() > 0){
                Database.insert(toBeCreatedAJList,false);
            }
        }   
    }
    
    static testMethod void trAssetInsertUpdateTest() 
    {   
        Account accObj = new Account();
        
        accObj.Name='Testing123';
        accObj.BillingCity='Gurgaon';
        accObj.BillingStreet='Sector 30';
        accObj.BillingState='Haryana';
        accObj.BillingPostalCode='122001';
        accObj.BillingCountry='India';
        
        insert accObj;
        
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.Phone = '999999989';
        con.Contact_Type__c = 'Asset Owner';
        con.Email = 'test@gmail.com';
        con.Serial_Number_from_Web_Site_Registration__c = '1233456788765';
        con.LeadSource = 'Web';
        insert con;
        
        Asset objReplacement = new Asset();
        objReplacement.Name = '1233456788765';
        objReplacement.AccountId = accObj.Id;
        
        insert objReplacement;
        
        AssetHelper.processedAssetInsert = false;
        AssetHelper.processedAssetUpdate = false;
        Asset obj1 = new Asset();
        obj1.Name = '1233456788765';
        obj1.AccountId = accObj.Id;
        obj1.Replacement__c = objReplacement.Id; 
        obj1.Registered_Owner__c = 'Test Name';
        obj1.Email__c = 'test@gmail.com';
        //obj.ContactId = con.Id;
        insert obj1;
          
        AssetContactJunction__c objAssetContact = new AssetContactJunction__c(); 
        objAssetContact.Asset__c = obj1.Id;
        objAssetContact.Contact__c = con.Id;
        insert objAssetContact;
        
          
        AssetHelper.processedAssetInsert = false;
        AssetHelper.processedAssetUpdate = false;
        Asset obj = new Asset();
        obj.Name = '1233456788765';
        obj.AccountId = accObj.Id;
        obj.Replacement__c = obj1.Id; 
        obj.Registered_Owner__c = 'Test Name';
        obj.Email__c = 'test@gmail.com';
        //obj.ContactId = con.Id;
        insert obj;
        
        
        //obj.Name = '1234566576543';
        AssetHelper.processedAssetInsert = false;
        AssetHelper.processedAssetUpdate = false;
        
        obj.Replacement__c = objReplacement.Id;
        obj.Registered_Owner__c = 'New Owner'; //objReplacement.Id;
        update obj;
        
    
    }
    
}