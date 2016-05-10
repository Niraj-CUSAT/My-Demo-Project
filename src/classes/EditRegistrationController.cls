public  class EditRegistrationController {
  
  Id selectedAssetId;
  Id ownerContactId;
  
  public Asset selectedAsset {get;set;}
  public Contact ownerContact {get;set;}
  public List<Contact> ownerContactList = new List<Contact>();  
  public String lastName {get;set;}
  
  
  public EditRegistrationController(){
    selectedAssetId = ApexPages.currentPage().getParameters().get('assetId');
    lastName = '';
    
    if(selectedAssetId != null){
      selectedAsset = [select Install_City__c,Install_Country__c,Install_Postal_Code__c,Install_State__c,
                Install_Street__c,Installation_Type__c,Registration_Method__c,Professionally_Installed__c
                ,Physical_Location__c,POP_Received__c,InstallDate from Asset where Id=:selectedAssetId];
    }  
    
    ownerContactId = ApexPages.currentPage().getParameters().get('ownerId');
    system.debug('-------------- First Constructor ------------- ');
    if(ownerContactId != null){
      system.debug('-------------- First If ------------- '+ownerContactId);
      ownerContactList = [select FirstName,LastName,Phone,Email from Contact where Id = :ownerContactId];
      system.debug('-------------- Second If ------------- ');
      if(ownerContactList.size() >0)
        ownerContact = ownerContactList.get(0);
      lastName = ownerContact.LastName;
    }
    else{
      if(!Test.isRunningTest()){      
      system.debug('-------------- Else Part ------------- ');
      ownerContact = new Contact();  
      }    
    }
    
    
  }
  
  public PageReference save(){
    
    try{
      system.debug('-------ownerContactId-------'+ownerContactId);      
      if(ownerContactId != null){
        
        if(ownerContact.FirstName == null && ownerContact.Phone == null && ownerContact.Email == null && lastName.length() == 0){
          delete [select id from AssetContactJunction__c where Contact__c =:ownerContactId and Asset__c =:selectedAsset.Id];
        }else{
          ownerContact.MailingStreet = selectedAsset.Install_Street__c;
          ownerContact.MailingState = selectedAsset.Install_State__c;
          ownerContact.MailingPostalCode = selectedAsset.Install_Postal_Code__c;
          ownerContact.MailingCountry = selectedAsset.Install_Country__c;
          ownerContact.MailingCity = selectedAsset.Install_City__c;
          ownerContact.LastName = lastName;
          update ownerContact;
        }
        selectedAsset.Registered_Owner__c = (ownerContact.FirstName!=null ? ownerContact.FirstName : '') + ' ' + lastName;
        selectedAsset.Email__c = ownerContact.Email;
        selectedAsset.Telephone__c = ownerContact.Phone;
      }
      else{
        String sosl = '';
        system.debug('***** ' + ownerContact);
        if(ownerContact != null)
        {
          if(ownerContact.Phone != null && ownerContact.Email != null){        
            sosl = 'Find {' + formatPhone(ownerContact.Phone) + ' and ' + ownerContact.Email + '} In All Fields Returning Contact(Id,Phone,Email,FirstName,LastName,MailingStreet,MailingState,MailingPostalCode,MailingCountry,MailingCity where Contact_Type__c = \'Asset Owner\')';
             
          }else if(ownerContact.Phone != null && ownerContact.Email == null){
            sosl = 'Find {' + formatPhone(ownerContact.Phone) + '} In All Fields Returning Contact(Id,Phone,Email,FirstName,LastName,MailingStreet,MailingState,MailingPostalCode,MailingCountry,MailingCity  where Contact_Type__c = \'Asset Owner\')';
          }else if(ownerContact.Phone == null && ownerContact.Email != null){
            sosl = 'Find {' + ownerContact.Email + '} In All Fields Returning Contact(Id,Phone,Email,FirstName,LastName,MailingStreet,MailingState,MailingPostalCode,MailingCountry,MailingCity  where Contact_Type__c = \'Asset Owner\')';
          } 
        }  
        System.debug('====sosl==='+sosl);
        if(sosl.length() >0){
          List<List<sObject>> soList = search.query(sosl);
          System.debug('====soslList==='+soList);
          List<Contact> contactList = (List<Contact>)soList.get(0);
          System.debug('====contactList==='+contactList);
          System.debug('====contactList 1==='+contactList.size());
          if(contactList.size() >0){
            Contact con = contactList.get(0);
            AssetContactJunction__c aj = new AssetContactJunction__c();
            aj.Contact__c = con.Id;
            aj.Asset__c = selectedAssetId;
            insert aj;
            con.MailingStreet = selectedAsset.Install_Street__c;
            con.MailingState = selectedAsset.Install_State__c;
            con.MailingPostalCode = selectedAsset.Install_Postal_Code__c;
            con.MailingCountry = selectedAsset.Install_Country__c;
            con.MailingCity = selectedAsset.Install_City__c;
            update con;
            selectedAsset.Registered_Owner__c = (con.FirstName!=null ? con.FirstName : '') + ' ' + con.LastName;
            selectedAsset.Email__c = con.Email;
            selectedAsset.Telephone__c = con.Phone;
          }else{
            if(lastName.length() >0){
              Contact newContact = new Contact();
              newContact.FirstName = ownerContact.FirstName;
              newContact.LastName = lastName;
              newContact.Phone = ownerContact.Phone;
              newContact.Email = ownerContact.Email;
              newContact.Contact_Type__c = 'Asset Owner';
              newContact.MailingStreet = selectedAsset.Install_Street__c;
              newContact.MailingState = selectedAsset.Install_State__c;
              newContact.MailingPostalCode = selectedAsset.Install_Postal_Code__c;
              newContact.MailingCountry = selectedAsset.Install_Country__c;
              newContact.MailingCity = selectedAsset.Install_City__c;
              insert newContact;
              AssetContactJunction__c aj = new AssetContactJunction__c();
              aj.Contact__c = newContact.Id;
              aj.Asset__c = selectedAssetId;
              insert aj;
              selectedAsset.Registered_Owner__c = (newContact.FirstName!=null ? newContact.FirstName : '') + ' ' + newContact.LastName;
              selectedAsset.Email__c = newContact.Email;
              selectedAsset.Telephone__c = newContact.Phone;
            }
          }
          
        }else{
            if(lastName.length() >0){
              Contact newContact = new Contact();
              newContact.FirstName = ownerContact.FirstName;
              newContact.LastName = lastName;
              newContact.Phone = ownerContact.Phone;
              newContact.Email = ownerContact.Email;
              newContact.Contact_Type__c = 'Asset Owner';
              newContact.MailingStreet = selectedAsset.Install_Street__c;
              newContact.MailingState = selectedAsset.Install_State__c;
              newContact.MailingPostalCode = selectedAsset.Install_Postal_Code__c;
              newContact.MailingCountry = selectedAsset.Install_Country__c;
              newContact.MailingCity = selectedAsset.Install_City__c;
              insert newContact;
              AssetContactJunction__c aj = new AssetContactJunction__c();
              aj.Contact__c = newContact.Id;
              aj.Asset__c = selectedAssetId;
              insert aj;
              selectedAsset.Registered_Owner__c = (newContact.FirstName!=null ? newContact.FirstName : '') + ' ' + newContact.LastName;
              selectedAsset.Email__c = newContact.Email;
              selectedAsset.Telephone__c = newContact.Phone;
            }
          }
         
        
      }
      update selectedAsset;
    }catch(Exception e){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception occured while saving the data. Cause :' +  e.getMessage()));
      return null;                     
    }
    
    PageReference pg = new PageReference('/apex/CustomerService?assetId='+selectedAssetId);
    return pg;
    
  } 
  
  

  
  public PageReference Cancel(){
    PageReference pg = new PageReference('/apex/CustomerService?assetId='+selectedAssetId);
    return pg;
  }
  
  @IsTest(seeAllData= false)
  public static void CancelTest()
  {
    EditRegistrationController controller = new EditRegistrationController();  
    controller.Cancel();
  }
  
  
  private String formatPhone(String ph){
    if(ph == null){
      return null;
    }
    
    return ph.replaceAll('\\(','').replaceAll('\\)','').replaceAll('-','').replaceAll(' ','');
  }

  @IsTest(seeAllData= false)
  public static void saveTest()
  {    
    EditRegistrationController controller = new EditRegistrationController();
    
    Contact contactobj = new Contact();
    
    contactobj.FirstName = 'TestFirstName';
    contactobj.LastName = 'TestLastName';
    contactobj.Email = 'blah@email.com';
    contactobj.Phone = '9231231234';
    
     insert contactobj;
      
    controller.ownerContactId = contactobj.Id;  
    controller.ownerContact = contactobj;
    controller.save();
  }
  
  @IsTest(seeAllData= false)  
  public static void saveTest2()
  {    
    EditRegistrationController controller = new EditRegistrationController();
    
    Contact contactobj = new Contact();
    

    controller.ownerContactId = null;
    controller.save();
  }
  
   @IsTest(seeAllData= false)  
   private static void formatPhoneTest()
   {
     EditRegistrationController controller = new EditRegistrationController();
     controller.formatPhone('1231231234');
   }
   
   @IsTest(seeAllData=false)
   private static void TestPage()
   {
      Test.startTest(); 
      Account accObj = new Account();
        
        accObj.Name='Testing123';
        accObj.BillingCity='Gurgaon';
        accObj.BillingStreet='Sector 30';
        accObj.BillingState='Haryana';
        accObj.BillingPostalCode='122001';
        accObj.BillingCountry='India';
        insert accObj;
        
        List<Contact> lstContact = new List<Contact>();
        Contact con = new Contact();
        con.FirstName = 'FirstName';
        con.LastName = 'LastName';
        con.Phone = '999999978';
        con.Contact_Type__c = 'Asset Owner';
        con.Email = 'test@gmail.com';
        con.AccountId = accObj.Id;
        lstContact.add(con);
        //insert con;   
        insert lstContact;   
     
     Asset objReplacement = new Asset();
        objReplacement.Name = '1233456788765';
        objReplacement.AccountId = accObj.Id;
        objReplacement.ContactId = con.Id;
        
        insert objReplacement;
        Test.stopTest();
     
      PageReference pageRef = Page.EditRegistration;
        Test.setCurrentPageReference(pageRef);
        
        system.debug('-------------- First Test ------------- ');
        pageRef.getParameters().put('assetId', objReplacement.id);  
        pageRef.getParameters().put('ownerId', con.id);
        
        EditRegistrationController controller = new EditRegistrationController();
        
        controller.save();         
        System.debug('***** Con:' + controller.ownerContact);
        controller.ownerContact = con;
        controller.ownerContactId = null;
        
        controller.save();
        
        controller.ownerContact.Email = null;
        controller.save();
        
        controller.ownerContact.Email = 'test@gmail.com';        
        controller.ownerContact.Phone = null;
        controller.save();
        
        controller.ownerContact.Phone = null;
        controller.ownerContact.Email = null;
        controller.ownerContact.LastName = 'test';
        controller.save(); 
   
   }        
}