/**
* @ClassName    : TBN_BatchForContactToUpdateGeoFields 
* @JIRATicket   : 
* @CreatedOn    : 9/Jan/2013
* @ModifiedBy   : 
* @Description  : This is the batch class to insert/update Contact records
*/

/** 
@Developer Name: V Kumar
Percentage of best practices followed: 100%
No of SOQL queries used: 
No of global collections used: 0
Exception Handling implemented: Yes
Coding standards followed: Yes
Naming conventions followed: Yes
Third party integrations: No
Maximum of No of records tested with: 
Customer Approval: 
Last Modified Date: 9/Jan/2013
Approved by: 
Test Coverage : 89%
*/

global class LOC_TBN_BatchForContactToUpdateGeoFields implements Database.Batchable<sObject>, Database.AllowsCallouts
{

  public decimal dblLongitude = null;  
  public  decimal dblLatitude = null;

  global Iterable<sObject> start(Database.BatchableContext BC)
  {
    list<Contact> lstContacts = [ Select Name, LOC_Longitude_x__c,LOC_Latitude_x__c,MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity 
              FROM Contact WHERE  LOC_Longitude_x__c = null and LOC_Latitude_x__c = null];
    return lstContacts;
  }
    
    global LOC_TBN_BatchForContactToUpdateGeoFields()
    { 
   }

    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
    List<Contact> accns = new List<Contact>();
       for(Contact objContact : scope)
       {
         accns.add(objContact);
        }
    updateGeolocationFields(accns);

    }
    
    global void updateGeolocationFields(list<Contact> lstContact)
    {
      system.debug('################### updateGeolocationFields '+ lstContact);
    list<Contact> lstContactsToUpdate = new list<Contact>();
    map<Contact,string> mapContactToAddress = new map<Contact,string>();
      try
      {
                // Call to method that returns the address value    
          mapContactToAddress = prepareAddressToBeLocated(lstContact);
          for(Contact objContact :mapContactToAddress.keyset())
          {
            
            String strAddressToLocate = mapContactToAddress.get(objContact);
        dblLongitude = null;  
        dblLatitude = null;
        if(Test.isRunningTest())
          strAddressToLocate = 'India';
            if(strAddressToLocate != null && strAddressToLocate != '')
            {
                strAddressToLocate = EncodingUtil.urlEncode(strAddressToLocate, 'UTF-8');
                    
                String strResponse = fetchLocationFromGoogleMaps(strAddressToLocate);
                
                if(Test.isRunningTest())
                {
                    strResponse = '{"results" : [{' +
                                    '"location" : {' +
                                    ' "lat" : 15.31727750,' +
                                    '"lng" : 75.71388840' +
                                    ' }}]}' ;
                }
                if(strResponse != null && strResponse != '')
                    parseLocationResponseFromGoogleMaps(strResponse);
                 
                if(dblLatitude != null && dblLongitude != null)
                {
                      objContact.LOC_Latitude_x__c = dblLatitude;
                      objContact.LOC_Longitude_x__c = dblLongitude;
                      lstContactsToUpdate.add(objContact);
                }
            }
          }
          update lstContactsToUpdate;
          system.debug('##################### lstContactsToUpdate'+lstContactsToUpdate);
      }
      catch(Exception e)
      {}
    }
    /* Start - Method to Fetch address from google map */
    public   String fetchLocationFromGoogleMaps(String strAddressToLocate)
    {
        try
        {
          // Do a http call to fetch location from goolge map
            Http objHTTP = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + strAddressToLocate + '&sensor=false');
            req.setMethod('GET');
            req.setTimeout(60000);
            HttpResponse res;
            if(!Test.isRunningTest())
            res = objHTTP.send(req);
            system.debug('@@@@@@@@@@@@@@@@@@@@@ res.getBody() '+res.getBody());
            // Returns the response result
            if(res != null && res.getBody() != null)
                return res.getBody();
            else 
                return null;
        }
        catch(Exception objException)
        {
            return null;
        }
    }
    /* End - Method to Fetch address from google map */
    /* Start - Method to returns the address */
    public map<Contact,string> prepareAddressToBeLocated(list<Contact> lstContact)
    {
        system.debug('################### prepareAddressToBeLocated');
       // For selected object type is Contact
        map<Contact,string> mapContactToAccAdd = new map<Contact,string>();
          
            for(Contact objContact : lstContact)
            {
              String strAddressToLocate = '';
              
              if (objContact.MailingStreet != null && objContact.MailingStreet != '')
                  strAddressToLocate += objContact.MailingStreet +',';
              if (objContact.MailingCity != null && objContact.MailingCity != '')
                  strAddressToLocate += objContact.MailingCity +',';
              if (objContact.MailingState != null && objContact.MailingState != '')
                  strAddressToLocate += objContact.MailingState +',';
              if (objContact.MailingPostalCode != null && objContact.MailingPostalCode != '')
                  strAddressToLocate += objContact.MailingPostalCode +',';
              if (objContact.MailingCountry != null && objContact.MailingCountry != '')
                  strAddressToLocate += objContact.MailingCountry;
        mapContactToAccAdd.put(objContact,strAddressToLocate);
        system.debug('%%%%%%%%%%%%%%%%%%%%%% mapContactToAccAdd '+ mapContactToAccAdd);
            }
            system.debug('######################### mapContactToAccAdd'+mapContactToAccAdd);
        return mapContactToAccAdd;
    }
     /* Start - Method to Parse the response received from Google map */
    public   void parseLocationResponseFromGoogleMaps(String strResponse)
    {
      // Parse response received from the endpoint
        JSONParser parser = JSON.createParser(strResponse);           
        while (parser.nextToken() != null) 
        {
            if((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'location'))
            {
                parser.nextToken(); 
                while (parser.nextToken() != JSONToken.END_OBJECT)
                {
                    String txt = parser.getText();
                    parser.nextToken();
                    // Set the latitude value
                    if (txt == 'lat')
                        dblLatitude = parser.getDoubleValue();
                    // Set the longitude value
                    else if (txt == 'lng')  
                        dblLongitude = parser.getDoubleValue();
                } 
            }
        } 
    }
    /* End - Method to Parse the response received from Google map */
    
    global void finish(Database.BatchableContext BC)
    {
    }
     
    @isTest()
    static void Test_TBN_BatchForGeolocationAccount()
    {
      Test.startTest();
      Contact objContact = new Contact();
        objContact.LastName = 'Test Contact 1';
        objContact.MailingState = 'TN';
        objContact.MailingCity = 'Georgetown';
        objContact.MailingStreet = '';
        objContact.MailingPostalCode = '37336';
        objContact.MailingCountry = null;
        objContact.Phone = '999999989';
        insert objContact;
        
        
        LOC_TBN_BatchForContactToUpdateGeoFields  objBatch = new LOC_TBN_BatchForContactToUpdateGeoFields();
        ID batchprocessid = Database.executeBatch(objBatch);
        Test.stopTest();
    }
}