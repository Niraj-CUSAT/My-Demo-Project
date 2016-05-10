global class LOC_TBN_BatchForAccountGeoLocationUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts 
{
	public decimal dblLongitude = null;    
    public  decimal dblLatitude = null;
    /*
        @MethodName: start 
        @param : BC
        @Description : Batch start method
    */
    global Iterable<sObject> start(Database.BatchableContext BC)
    {
    	list<Account> lstAccount = new list<Account>(); 
        if(!Test.isRunningTest())
        {
        	lstAccount = [select Name, LOC_Longitude_x__c,LOC_Latitude_x__c,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
                                      FROM Account WHERE  LOC_Longitude_x__c = null and LOC_Latitude_x__c = null limit 50000];      
       		
       }
       else
       	lstAccount = [select Name, LOC_Longitude_x__c,LOC_Latitude_x__c,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
                                      FROM Account limit 1];
		system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ lstAccount @@@@@@@@@@@@'+lstAccount);
        return lstAccount;
                
      
      
    }
    /*
        @ClassName: TBN_BatchForAssetImport 
        @param : None
        @Description : Constructor
    */    
    global LOC_TBN_BatchForAccountGeoLocationUpdate()
    { 
    }
    /*
        @MethodName: Execute 
        @param : scope
        @Description : Batch execute method
    */
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        system.debug('######################### execute');
        List<Account> accns = new List<Account>();
        
        for(Account objAccount : scope)
        {
            accns.add(objAccount);
        }
        updateGeolocationFields(accns); 
    }
    /*
        @MethodName: updateGeolocationFields 
        @param : scope
        @Description : It updates the geolocation fields
    */
    global void updateGeolocationFields(list<Account> lstAccount) 
    {
        system.debug('########################## updateGeolocationFields'+ lstAccount);
        list<Account> lstAccountsToUpdate = new list<Account>();
        map<Account,string> mapAccountToAddress = new map<Account,string>();
        try
        {
            // Call to method that returns the address value    
            mapAccountToAddress = prepareAddressToBeLocated(lstAccount);
            
            for(Account objAccount :mapAccountToAddress.keyset())
            {
                
                String strAddressToLocate = mapAccountToAddress.get(objAccount);
                dblLongitude = null;    
                dblLatitude = null;
                if(Test.isRunningTest())
                    strAddressToLocate = 'India';
                if(strAddressToLocate != null && strAddressToLocate != '')
                {
                    strAddressToLocate = EncodingUtil.urlEncode(strAddressToLocate, 'UTF-8');
                    String strResponse = fetchLocationFromGoogleMaps(strAddressToLocate);
                   
                    system.debug('%%%%%%%%%%%%%%%%%%%%% strResponse'+strResponse);
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
                        objAccount.LOC_Latitude_x__c = dblLatitude;
                        objAccount.LOC_Longitude_x__c = dblLongitude;
                        lstAccountsToUpdate.add(objAccount);
                    }
                }
            }
            update lstAccountsToUpdate;
            system.debug('################ lstAccountsToUpdate :'+lstAccountsToUpdate);
        }
        catch(Exception e)
        {
            system.debug('Exception =================='+e.getMessage());
        }
    }
    /* Start - Method to Fetch address from google map */
    public   String fetchLocationFromGoogleMaps(String strAddressToLocate)
    {
        try
        {
            system.debug('@@@@@@@@@@@@@@@@@@@@@@ fetchLocationFromGoogleMaps');
            // Do a http call to fetch location from goolge map
            Http objHTTP = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + strAddressToLocate + '&sensor=false');
            req.setMethod('GET');
            req.setTimeout(60000);
            HttpResponse res;
            if(!Test.isRunningTest())
            res = objHTTP.send(req);
            system.debug('###############$$$$$$$$$$$ res.getBody()'+res.getBody());
            // Returns the response result
            if(res != null && res.getBody() != null)
                return res.getBody();
            else 
                return null;
        }
        catch(Exception e)
        {
            system.debug('Exception =================='+e.getMessage());
            return null;
        }
    }
    /* End - Method to Fetch address from google map */
    /* Start - Method to returns the address */
    public map<Account,string> prepareAddressToBeLocated(list<Account> lstAccount)
    {
       system.debug('^^^^^^^^^^^^^^^^^^^^^^^^ prepareAddressToBeLocated');
       // For selected object type is Account
        map<Account,string> mapAccountToAccAdd = new map<Account,string>();
          
            for(Account objAccount : lstAccount)
            {
                String strAddressToLocate = '';
                
                if (objAccount.ShippingStreet != null && objAccount.ShippingStreet != '')
                    strAddressToLocate += objAccount.ShippingStreet +',';
                if (objAccount.ShippingCity != null && objAccount.ShippingCity != '')
                    strAddressToLocate += objAccount.ShippingCity +',';
                if (objAccount.ShippingState != null && objAccount.ShippingState != '')
                    strAddressToLocate += objAccount.ShippingState +',';
                if (objAccount.ShippingPostalCode != null && objAccount.ShippingPostalCode != '')
                    strAddressToLocate += objAccount.ShippingPostalCode +',';
                if (objAccount.ShippingCountry != null && objAccount.ShippingCountry != '')
                    strAddressToLocate += objAccount.ShippingCountry;
                mapAccountToAccAdd.put(objAccount,strAddressToLocate);
                system.debug('######################### strAddressToLocate '+strAddressToLocate);
            }
        system.debug('################### mapAccountToAccAdd'+mapAccountToAccAdd);
        return mapAccountToAccAdd;
    }
     /* Start - Method to Parse the response received from Google map */
    public void parseLocationResponseFromGoogleMaps(String strResponse)
    {
        system.debug('########################## parseLocationResponseFromGoogleMaps');
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
		system.debug('########################## dblLatitude'+dblLatitude);
		system.debug('########################## dblLongitude'+dblLongitude);
    }
     global void finish(Database.BatchableContext BC)
    {
        
    }
    

 // Test Method 
     @isTest()
    static void Test_TBN_BatchForGeolocationAccount()
    {
        Test.startTest();
      //  RecordType objRD = new RecordType
        Account objAccount = new Account();
        objAccount.Name = 'CHRIS NISWANDEE';
        objAccount.ShippingState = 'TN';
        objAccount.ShippingCity = 'TUCSON';
        objAccount.ShippingStreet = '795 E DRAGRAM';
        objAccount.ShippingPostalCode = '85705';
        objAccount.ShippingCountry = 'USA';
        objAccount.LOC_Latitude_x__c = null ;
        objAccount.LOC_Longitude_x__c = null; 
        insert objAccount; 
        system.debug('@@@@@@@@@@22'+ [select Name, LOC_Longitude_x__c,LOC_Latitude_x__c,ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity 
                                      FROM Account WHERE  LOC_Longitude_x__c = null and LOC_Latitude_x__c = null limit 50000]);
        LOC_TBN_BatchForAccountGeoLocationUpdate  objBatch = new LOC_TBN_BatchForAccountGeoLocationUpdate();
        Database.executeBatch(objBatch);
        Test.stopTest();
    }
}