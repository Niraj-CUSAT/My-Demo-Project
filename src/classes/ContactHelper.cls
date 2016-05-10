public class ContactHelper {
  public static Boolean processAssetOwnerUpdate = true;
  
  /**
  *  Once new contact is generated from the web integration, we would like a trigger that will do the following:
  *  1.      Look up the associated asset record (based on the serial number entered by the customer) and populate the warranty 
  *      registration section of that asset.  Obviously, this will need to happen without activating the trigger which is currently 
  *      in place that generates a new contact record.  Essentially, this one will work in reverse of the typical scenario.
  *  2.      Create an AssetContactJunction record related to the new contact and the associated asset record.
  *
  **/
  public static void contactAfterUpdate(Set<Id> contIdSet,Set<String> assetSet,Map<Id,String> linkAsset,Map<String,Id> linkContact) {
          if(contIdSet!=null && contIdSet.size()>0) {
            
            system.debug('-- assetSet ---'+assetSet);
            system.debug('-- contIdSet ---'+contIdSet);
            
            List<Asset> assetLst = [Select Name ,Registered_Owner__c,Install_Street__c,Install_State__c,Install_Postal_Code__c,Install_Country__c,Install_City__c,Telephone__c,Email__c,Model_Number__c,InstallDate,Installation_Type__c,Professionally_Installed__c from Asset where Name IN :assetSet ] ;
            Map<Id,Contact> contactMap = new Map<Id,Contact>([Select Id,Name,MailingStreet , MailingState,MailingPostalCode,MailingCountry,MailingCity,FirstName,Phone,LastName,Email,OtherPhone,Model_Number_from_Web_Site_Registraiton__c,Serial_Number_from_Web_Site_Registration__c,Type_of_Installation__c,Date_of_Installation__c,Professional_Installation__c from Contact where ID IN :contIdSet]);
            
            List<Asset> updateAssets = new List<Asset>() ;
            List<AssetContactJunction__c> updateJunctionObj = new List<AssetContactJunction__c>() ;
            
            system.debug('-- assetLst ---'+assetLst);
            system.debug('-- contactMap ---'+contactMap);
            
            Map<String,Asset> assetMap = new Map<String,Asset>() ;
            for(Asset a : assetLst) {
              assetMap.put(a.Name,a);
            }
            
            system.debug('-- assetMap ---'+assetMap);
            
            
            
            for(Id cid: linkAsset.keySet()) {
              Contact cont = contactMap.get(cid) ;
              if(cont!=null) {
                Asset ast = assetMap.get(linkAsset.get(cid)) ;
                if(ast!=null) {
                  ast.Registered_Owner__c = cont.FirstName +' '+cont.LastName;
  
              ast.Install_Street__c = cont.MailingStreet ;
                          ast.Install_State__c = cont.MailingState ;
                          ast.Install_Postal_Code__c = cont.MailingPostalCode ;
                          ast.Install_Country__c = cont.MailingCountry ;
                          ast.Install_City__c = cont.MailingCity ;
                          
                          ast.InstallDate = cont.Date_of_Installation__c ;
                          ast.Professionally_Installed__c = cont.Professional_Installation__c ;
                          ast.Installation_Type__c = cont.Type_of_Installation__c ;
                          updateAssets.add(ast);
                          
                          AssetContactJunction__c juncObj = new AssetContactJunction__c();
                          juncObj.Asset__c = ast.Id ;
                          juncObj.Contact__c = cont.id ;
                          updateJunctionObj.add(juncObj) ;

                }
              }
              
            }
            if(updateAssets.size()>0) {   
              Database.insert(updateJunctionObj);   
              ContactHelper.processAssetOwnerUpdate = false; // Added By GOVIND THATHERA - 6/12/2014 - to stop redundant update of Contact from Asset.
              Database.SaveResult[] results = Database.update(updateAssets,false);
          
          System.debug('---results---'+results);
          
          if (results != null)
          {
            for(Integer i=0;i<results.size();i++)  
            {
              if (!results[i].isSuccess()) 
              {
                contactMap.get(updateAssets[i].Registered_Owner__c).addError('Error while updating Asset : '+updateAssets[i].Id + ' Description : ' + results[i].getErrors()[0].getMessage());              
              }
              
            }
            
          } 
            }
          }
    }
    
    //Method to test scenario where a case create via 'WEB' lead source is inserted 
    static testMethod void contactAfterScenario() {
      Account ac = new Account();
      ac.name = 'Test Account';
      insert ac;
  
     Asset objReplacement = new Asset();
        objReplacement.Name = '000000001';
        objReplacement.AccountId = ac.Id;
        insert objReplacement;
        
        Contact cont = new Contact() ;
      cont.FirstName = 'test' ;
      cont.LastName = 'contact' ;
      cont.AccountId = ac.Id ;
      cont.LeadSource = 'Web' ;
      cont.Serial_Number_from_Web_Site_Registration__c = '000000001' ;
      cont.Phone = '999999989';
      insert cont;
    }
}