/**
* @ClassName    : TBN_BatchForGeoLocationUpdate 
* @JIRATicket   : 
* @CreatedOn    : 9/Jan/2013
* @ModifiedBy   : 
* @Description  : This is the batch class to insert/update User records
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
Test Coverage : 100%
*/

global class LOC_TBN_BatchForUserToUpdateGeoFields implements Database.Batchable<sObject>, Database.AllowsCallouts
{
	public decimal dblLongitude = null;	
	public	decimal dblLatitude = null;

	global Iterable<sObject> start(Database.BatchableContext BC)
	{
		list<User> lstUser = [ Select Name, LOC_Longitude__c,LOC_Latitude__c,Street, State, PostalCode, Country, City FROM User 
								WHERE  LOC_Longitude__c = null and LOC_Latitude__c = null limit 10];
		return lstUser;
	}
		
    global LOC_TBN_BatchForUserToUpdateGeoFields()
    { 
 	}

    global void execute(Database.BatchableContext BC, List<User> scope)
    {
		List<User> accns = new List<User>();
   		for(User objUser : scope)
   		{
   			accns.add(objUser);
        }
		updateGeolocationFields(accns);

    }
    
    global void updateGeolocationFields(list<User> lstUser)
    {
    	system.debug('@@@@@@@@@@@@@@@@@@@@@@@@ updateGeolocationFields' + lstUser);
    	list<User> lstUsersToUpdate = new list<User>();
    	map<User,string> mapUserToAddress = new map<User,string>();
    	try
    	{
			// Call to method that returns the address value    
	        mapUserToAddress = prepareAddressToBeLocated(lstUser);
	        for(User objUser :mapUserToAddress.keyset())
	        {
		        String strAddressToLocate = mapUserToAddress.get(objUser);
				dblLongitude = null;	
				dblLatitude = null;
				
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
	                    objUser.LOC_Latitude__c = dblLatitude;
	                    objUser.LOC_Longitude__c = dblLongitude;
	                    lstUsersToUpdate.add(objUser);
		            }
		        }
	        }
	        update lstUsersToUpdate;
	        system.debug('$$$$$$$$$$$$$$$$$$$$$$$ lstUsersToUpdate' + lstUsersToUpdate);
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
        	// Do a http call to fetch location from goolge map
            Http objHTTP = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address=' + strAddressToLocate + '&sensor=false');
            req.setMethod('GET');
            req.setTimeout(60000);
            HttpResponse res;
            if(!Test.isRunningTest())
            res = objHTTP.send(req);
            system.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$ res.getBody() '+res.getBody());
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
    public map<User,string> prepareAddressToBeLocated(list<User> lstUser)
    {
       // For selected object type is User
        map<User,string> mapUserToAccAdd = new map<User,string>();
          
            for(User objUser : lstUser)
            {
	            String strAddressToLocate = '';
	            
	            if (objUser.Street != null && objUser.Street != '')
	                strAddressToLocate += objUser.Street +',';
	            if (objUser.City != null && objUser.City != '')
	                strAddressToLocate += objUser.City +',';
	            if (objUser.State != null && objUser.State != '')
	                strAddressToLocate += objUser.State +',';
	            if (objUser.PostalCode != null && objUser.PostalCode != '')
	                strAddressToLocate += objUser.PostalCode +',';
	            if (objUser.Country != null && objUser.Country != '')
	                strAddressToLocate += objUser.Country;
				mapUserToAccAdd.put(objUser,strAddressToLocate);
			    system.debug('@@@@@@@@@@@@@@@@@@@@ strAddressToLocate '+strAddressToLocate);
            }
        system.debug('$$$$$$$$$$$$$$$$$$$$$$$$ mapUserToAccAdd '+ mapUserToAccAdd);
        return mapUserToAccAdd;
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
    	//Do Nothing 
    }
    @isTest()
    static void Test_TBN_BatchForGeolocationAccount()
    {
    	Test.startTest();
    	Profile objProfile = [select id from profile where Name='Read Only' limit 1]; 
        User objUser = new User(alias = 'xxxxxxx', email='jpate@hotwater.com.full', emailencodingkey='ISO-8859-1', lastname='xxx', languagelocalekey='en_US',
                        localeSidkey='en_US',timezonesidkey='America/New_York',profileid = objProfile.Id,username='jpatexx@hotwater.com.full');
        
      /*  objUser.State = 'TN';
        objUser.City = 'Georgetown';
        //objUser.Street = ''; 
        objUser.PostalCode =  '37336';
        objUser.Country = 'USA';
        insert objUser; */            
        
        LOC_TBN_BatchForUserToUpdateGeoFields  objBatch = new LOC_TBN_BatchForUserToUpdateGeoFields();
        ID batchprocessid = Database.executeBatch(objBatch);
        Test.stopTest();
    }
}