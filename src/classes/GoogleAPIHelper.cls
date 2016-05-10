/*#########################################################################
# File..................: GoogleAPIHelper
# API Version...........: 20
# Created by............: Ravindra S Bist
# Created Date..........: 11-Aug-2011
# Last Modified by......: Ravindra S Bist
# Last Modified Date....: 
# Last Modified by......: Vkumar(Trekbin)
# Last Modified Date....: 17-Sep-2013
# Description...........: This helper class contain various method use to call google  api.
                        
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
public class GoogleAPIHelper {
	
	public static boolean isTriggerFired{get;set;}
    
   /* Wrapper class to hold latitude and longitude */   
    public class GeoCode{
        //variable to hold the latitude
        public String latitude;
        //variable to hold the longitude
        public String longitude;
    }
    
    /* Wrapper class to hold latitude and longitude */
    public class GeoCodeData{
        //wrapper class to  hold  the latitude and longitude
        public GeoCode geoCode;
        // variable to hold the website response success
        public Boolean success;
        // variable to hold the website response status
        public String status;
    }
    
     /* Wrapper class to hold duration and distance between two  address */
    public class DistanceMatrixData{
        //variable to hold the  duration between  two address  
        public String duration;
        //variable to hold the distance  between two address
        public String distance;
        // variable to hold the distance  between two address
        public Double distanceValue;
        // variable to hold the website response success
        public Boolean success;
         // variable to hold the website response status
        public String status;
    }
    
    /* This method compute travel distance and time between a number of points using the Google Maps API */
    public static DistanceMatrixData googleDistanceMatrixAPICall(String source,String target){
        
        DistanceMatrixData distanceObj = new DistanceMatrixData();
        UrlSigner urlProvider = new UrlSigner(GoogleAPI__c.getInstance('URLSigning').Value__c); 
         
         /** Create Http object  **/ 
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest();
        
        /** Create google url from custom setting  **/ 
         // String encoded = EncodingUtil.urlEncode(GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+' origins='+source+'&destinations='+target+'&units=imperial&sensor=false', 'UTF-8');
        //// req.setEndpoint(GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+' origins='+source+'&destinations='+target+'&units=imperial&sensor=false');
          //  req.setEndpoint(encoded);
          //String url =GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+'origins='+ EncodingUtil.urlEncode(source,'UTF-8')+'&destinations='+EncodingUtil.urlEncode(target,'UTF-8')+'&units=imperial&sensor=false';
          String url=GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+urlProvider.signRequest(GoogleAPI__c.getInstance('GoogleMapDistanceSecondPart').Value__c,'origins='+source+'&destinations='+target+'&client='+GoogleAPI__c.getInstance('clientID').Value__c+'&units=imperial&sensor=false') ;
          req.setEndpoint(url);
          req.setMethod('GET');
          String resStr;
        
          /** If method is called from test case then return the static response  **/ 
        if(!Test.isRunningTest()){
            HttpResponse res = httpObj.send(req);
            resStr = res.getBody();
        }
        else{
            
            String testResp = '<?xml version="1.0" encoding="UTF-8"?><DistanceMatrixResponse><status>OK</status> <origin_address>Vancouver, BC, Canada</origin_address><origin_address>Seattle, État de Washington, États-Unis</origin_address> <destination_address>San Francisco, Californie, États-Unis</destination_address>  <destination_address>Victoria, BC, Canada</destination_address>  <row>   <element><status>OK</status><duration><value>340110</value> <text>3 jours 22 heures</text>    </duration>    <distance>     <value>1734542</value>     <text>1 735 km</text>    </distance>   </element>    </row> </DistanceMatrixResponse> ';
            resStr = testResp;
        }
         System.debug('*******'+resStr);
         /** Parse the response xml from google api**/ 
        XMLDom dom = new XMLDom(resStr);
      
        XMLDom.Element point = dom.getElementByTagName('duration');
        XMLDom.Element point1 = dom.getElementByTagName('distance');
        distanceObj.status = dom.getElementByTagName('DistanceMatrixResponse').getValue('status');
       
           /** Setting the value in wrapper class  variable**/ 
        if(point != null){
            //pointStr = point.getValue('lat');
            
           distanceObj.duration =point.getValue('text');
           distanceObj.distance = point1.getValue('text');
           distanceObj.distanceValue =(point1.getValue('value')!=null?Double.valueOf(point1.getValue('value')):0);
           distanceObj.success = true;
        }
        return distanceObj;
    }
    
    /* This method is use to hit google api and pass the address to google api. In return google returns  response xml containing latitude and longitude */
     public static GeoCodeData GeoCodeIntegration(String address){
        UrlSigner urlProvider = new UrlSigner(GoogleAPI__c.getInstance('URLSigning').Value__c); 
         
        GeoCodeData geoCodeData = new GeoCodeData();
        geoCodeData.geoCode = new GeoCode();
        
        /** Create Http object  **/ 
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest();
        /** Create google url from custom setting  **/ 
      // String url =GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+'origins='+ EncodingUtil.urlEncode(source,'UTF-8')+'&destinations='+EncodingUtil.urlEncode(target,'UTF-8')+'&units=imperial&sensor=false';
       //// String url =GoogleAPI__c.getInstance('GeocodingAPI').Value__c+''+ EncodingUtil.urlEncode(address,'UTF-8')+'&sensor=false';
        // req.setEndpoint(GoogleAPI__c.getInstance('GeocodingAPI').Value__c+''+address+'&sensor=false');
       String url=GoogleAPI__c.getInstance('GeocodingAPI').Value__c+urlProvider.signRequest(GoogleAPI__c.getInstance('GeocodingAPISecondPart').Value__c,'address='+EncodingUtil.urlEncode(address,'UTF-8')+'&client='+GoogleAPI__c.getInstance('clientID').Value__c+'&sensor=false') ;
     
        req.setEndpoint(url);
        req.setMethod('GET');
        String resStr;
        
          /** If method is called from test case then return the static response  **/ 
        if(!Test.isRunningTest()){
            HttpResponse res = httpObj.send(req);
            resStr = res.getBody();
        }
        else{
            
            String testResp = '<?xml version="1.0" encoding="UTF-8"?><GeocodeResponse><status>OK</status><result><type>establishment</type><formatted_address>Fortis Hospital, B-22, Sector 62, NOIDA, Uttar Pradesh 201301, India</formatted_address><address_component><long_name>Fortis Hospital</long_name><short_name>Fortis Hospital</short_name><type>establishment</type></address_component><address_component><long_name>B-22</long_name><short_name>B-22</short_name><type>street_number</type></address_component><address_component><long_name>Sector 62</long_name><short_name>Sector 62</short_name><type>neighborhood</type><type>political</type></address_component><address_component><long_name>New Okhla Industrial Development Area</long_name><short_name>NOIDA</short_name><type>locality</type><type>political</type></address_component><address_component><long_name>Gautam Buddha Nagar</long_name><short_name>Gautam Buddha Nagar</short_name><type>administrative_area_level_2</type><type>political</type></address_component><address_component><long_name>Uttar Pradesh</long_name><short_name>U.P.</short_name><type>administrative_area_level_1</type><type>political</type></address_component><address_component><long_name>India</long_name><short_name>IN</short_name><type>country</type><type>political</type></address_component><address_component><long_name>201301</long_name><short_name>201301</short_name><type>postal_code</type></address_component><geometry><location><lat>28.6188880</lat><lng>77.3724585</lng></location><location_type>APPROXIMATE</location_type><viewport><southwest><lat>28.6090928</lat><lng>77.3564511</lng></southwest><northeast><lat>28.6286823</lat><lng>77.3884659</lng></northeast></viewport><bounds><southwest><lat>28.6182054</lat><lng>77.3717465</lng></southwest><northeast><lat>28.6194324</lat><lng>77.3734351</lng></northeast></bounds></geometry><partial_match>true</partial_match></result></GeocodeResponse>';
            resStr = testResp;
        }
      
        /** Parse the response xml from google api**/ 
        XMLDom dom = new XMLDom(resStr);
        XMLDom.Element point = dom.getElementByTagName('location');
        geoCodeData.status = dom.getElementByTagName('GeocodeResponse').getValue('status');
       
        /** Setting the value in wrapper class  variable**/ 
        if(point != null){
            
            geocodeData.geoCode.latitude = point.getValue('lat');
            geocodeData.geoCode.longitude = point.getValue('lng');
            geocodeData.success = true;
        }
      
        return geocodeData;
      } 
    /** This method process the  record  passed through trigger, It fetches calls the google api and update the accound object **/
    
     public void processAccountData(Map<Id,Account> newAccountMap,Map<Id,Account> oldAccountMap,Boolean isInsert){
  
         Map<Id,String> accountIdMap = new Map<Id,String>();
        //if new account record is inserted 
        if(isInsert){
            
            //Iterating all the  new account object
            for(Account obj:newAccountMap.values()){
             
                    //fetching Shipping address  from  the account object
                    String address=(obj.ShippingStreet!=null?obj.ShippingStreet.trim()+',':'')+(obj.ShippingCity!=null?obj.ShippingCity.trim()+',':'')+(obj.ShippingState!=null?obj.ShippingState.trim()+',':'')+(obj.ShippingPostalCode!=null?obj.ShippingPostalCode.trim()+',':'')+(obj.ShippingCountry!=null?obj.ShippingCountry.trim()+',':'');
                         
                    //Replacing the white space in address  with + sign
                     address=address.trim();
                     address= address.replaceAll(' ','+');
                     
                     //If address is not null then  add the object in Map
                     if(obj.ShippingStreet!=null ||obj.ShippingCity!=null || obj.ShippingState!=null ||obj.ShippingPostalCode!=null || obj.ShippingCountry!=null){
                    
                        accountIdMap.put(obj.id,address);
                         
                    }
             
                
            }
        }else{
            
            //If account record  is updated
            for(Account updatedAccountObj:newAccountMap.values()){
                     
                         //fetching the old value  of account record
                         Account oldAccount = oldAccountMap.get(updatedAccountObj.id);
                         //if address is modified then call the google api
                         if((updatedAccountObj.ShippingStreet != oldAccount.ShippingStreet)||(updatedAccountObj.ShippingCity != oldAccount.ShippingCity) ||(updatedAccountObj.ShippingState != oldAccount.ShippingState) ||(updatedAccountObj.ShippingPostalCode != oldAccount.ShippingPostalCode) ||(updatedAccountObj.ShippingCountry != oldAccount.ShippingCountry)){
                                     //fetching Shipping address  from  the account object
                                    String address=(updatedAccountObj.ShippingStreet!=null?updatedAccountObj.ShippingStreet.trim()+',':'')+(updatedAccountObj.ShippingCity!=null?updatedAccountObj.ShippingCity.trim()+',':'')+(updatedAccountObj.ShippingState!=null?updatedAccountObj.ShippingState.trim()+',':'')+(updatedAccountObj.ShippingPostalCode!=null?updatedAccountObj.ShippingPostalCode.trim()+',':'')+(updatedAccountObj.ShippingCountry!=null?updatedAccountObj.ShippingCountry.trim()+',':'');
                                    
                                     //Replacing the white space in address  with + sign
                                    address=address.trim();
                                    address=address.replaceAll(' ','+');
                            
                                    //If address is not null then  add the object in Map
                                     if(updatedAccountObj.ShippingStreet!=null ||updatedAccountObj.ShippingCity!=null || updatedAccountObj.ShippingPostalCode!=null ||updatedAccountObj.ShippingState!=null || updatedAccountObj.ShippingCountry!=null){
                                            accountIdMap.put(updatedAccountObj.id,address);
                                      
                                     }
                         }
                }
            
        }
        
        if(accountIdMap.size() >0){
            updateGeoCodeInAccount(accountIdMap);           
        }
        
    }
    
     /** This method is use to get GeoCode and update it in Account object.
     * Use the future annotation to identify methods that are executed asynchronously.
     * No more than 10 method calls per Apex invocation
     *
     **/ 
    @future(callout=true)
    public static void updateGeoCodeInAccount(Map<ID,String> accIdMap){
        
        List<Account> updatedAccoutList = new List<Account>();
        //Iterating through  list of Account Map for which call out need to be  made
        for(String id:accIdMap.keySet()){
            
            Account accObj=new Account(Id=id);
            //Fetching GeoCode of the Account Address  
            GeoCodeData geoCodeData=GeoCodeIntegration(accIdMap.get(id));
            
            if(geoCodeData!=null && geocodeData.geoCode!=null && geocodeData.geoCode.longitude!=null && geocodeData.geoCode.latitude!=null){
                 
                //Setting GeoCode value in account object
                accObj.Geocode_Longitude__c=Double.valueof(geocodeData.geoCode.longitude);
                accObj.Geocode_Latitude__c=Double.valueof(geocodeData.geoCode.latitude);
                 
                updatedAccoutList.add(accObj);
            }
        }
        //updating the  account object list
        if(updatedAccoutList.size() > 0)
        update updatedAccoutList;
        isTriggerFired = true;
    }

    /** This method fetch all the account located near the account and based on brand and service
    *   This method is use to seach account of service provider type.
    *   If no option is selected in VF page then search will be open with longitude and latitude conditions
    **/
    public List<Account> findTopNAccount(String longitude,String latitude,List<String> brand,List<String> service,String grade,String resultLimit){
        
        String sqlToExecute='select id, name,phone,fax, Industry, Brands_Serviced__c,QSP_Miles_1__c, QSP_Miles_2__c,Services__c, ShippingStreet,ShippingCity,QSP_Co_Grade_Level__c,Customer_Notes__c,ShippingPostalCode,ShippingState,ShippingCountry,Geocode_Longitude__c,Geocode_Latitude__c  from Account where RecordType.DeveloperName =\''+GoogleAPI__c.getInstance('QSP_Account_RecordType').Value__c+'\' and Account_Status__c=\'Active\' and Exclude_from_lookup__c=false ';
        List<Account> accList = new List<Account>();
        FindNearbyUtil con = new FindNearbyUtil(); 
        String brandStr,serviceStr;
         double radius=100;
        //Calculate the search radius around the check-in coordinates
        con.calculateSearchRadius(Double.valueOf(longitude),Double.valueOf(latitude), Double.valueOf(100));
        
        //if brand value is not selected  then remove brand  from  search
        if(brand!=null && brand.size() >0){
              brandStr=convetStringFromList(brand);
              sqlToExecute=sqlToExecute+'and Brands_Serviced__c INCLUDES ('+ brandStr +')';
        } 
        //if service value is not selected  then remove  service from search
        if(service!=null && service.size() >0){
              serviceStr=convetStringFromList(service);
              sqlToExecute=sqlToExecute+ ' and Services__c INCLUDES ('+serviceStr+')';
        } 
        if(grade!=null){
             sqlToExecute=sqlToExecute+ '  and QSP_Co_Grade_Level__c=\''+grade+'\'';
             
             
        } 
        String sqlToExecuteFinal=sqlToExecute+'and  Geocode_Latitude__c <='+ con.latMax+' and Geocode_Latitude__c >='+con.latMin+' and Geocode_Longitude__c <='+con.lonMax+' and Geocode_Longitude__c >='+con.lonMin;
       // sqlToExecute=sqlToExecute+'and  Geocode_Latitude__c <='+ con.latMax+' and Geocode_Latitude__c >='+con.latMin+' and Geocode_Longitude__c <='+con.lonMax+' and Geocode_Longitude__c >='+con.lonMin;
        // adding limit to the results
       //  sqlToExecute=sqlToExecute+' limit '+Integer.valueOf(resultLimit);
        accList= Database.query(sqlToExecuteFinal);
        System.debug('-----------accList-------------------'+accList);
        
      //  List<Account> sortedList=getSortedAccount(accList,longitude,latitude,Integer.valueOf(resultLimit));
        
       
            while(accList!=null && accList.size() < 9){
                radius =radius+100;
                //Calculate the search radius around the check-in coordinates
                con.calculateSearchRadius(Double.valueOf(longitude),Double.valueOf(latitude), radius);
                sqlToExecuteFinal=sqlToExecute+'and  Geocode_Latitude__c <='+ con.latMax+' and Geocode_Latitude__c >='+con.latMin+' and Geocode_Longitude__c <='+con.lonMax+' and Geocode_Longitude__c >='+con.lonMin;
                accList= Database.query(sqlToExecuteFinal);
                break;
            }
       
        List<Account> sortedList=getSortedAccount(accList,longitude,latitude,Integer.valueOf(resultLimit)); 
        return sortedList;
                                     
         
    } 
    /** This method  is use to convert list of string to comma seperated string
    *  @param : List of string
    *  @return : Comma sepereated string
    **/
    public String convetStringFromList(List<String> strList){
        
        String csvString;
        integer i=0;
        //Iterating through the list 
        for(String str:strList){
            if(i==0){
                //for first item
                csvString='\''+str+'\'';
            }else{
                csvString=csvString+','+'\''+str+'\'';
                 
            }
            i++;
        }
        
        return csvString;
    }
    
    /** This method fetch all the account located near the account and based on brand and service
    *   This method is use to seach of distributor account type.
    *   If no option is selected in VF page then search will be open with longitude and latitude conditions
    **/
    public List<Account> findTopNAccount(String longitude,String latitude,String market,String distributorServices,String distributorLevel, String resultLimit){
        try
        {
	        String sqlToExecute='select id, name,phone,fax,Industry,Brands_Serviced__c,ShippingStreet,ShippingCity,Distributor_Level__c,ShippingPostalCode,ShippingState,ShippingCountry,Services__c, Geocode_Longitude__c, Geocode_Latitude__c  from Account where  RecordType.DeveloperName =\''+GoogleAPI__c.getInstance('Distributor_Account_RecordType').Value__c+'\' and Account_Status__c=\'Active\' and Exclude_from_lookup__c=false ';
	        List<Account> accList = new List<Account>();
	        FindNearbyUtil con = new FindNearbyUtil(); 
	        // Set used for filtering the Distributor based on only 3 Industry values
	        Set<String> setIndustries = new Set<String>{'Retail', 'Wholesale', 'Aftermarket'};
	        String brandStr,serviceStr;
	        double radius=100;
	 
	        
	        //Calculate the search radius around the check-in coordinates
	        con.calculateSearchRadius(Double.valueOf(longitude),Double.valueOf(latitude), Double.valueOf(100));
	         
	        //if Market__c value is not selected  then remove  Market__c from search
	        if(market!=null){
	              
	              sqlToExecute=sqlToExecute+'and Market__c=\''+market+'\'';
	              
	        } 
	        //if distributorServices value is not selected  then remove  distributorServices  from search
	        if(distributorServices!=null ){
	               
	              sqlToExecute=sqlToExecute+ ' and Distributor_Services__c=\''+distributorServices+'\'';
	        } 
	        //if distributorLevel value is not selected  then remove  distributorLevel  from search
	        if(distributorLevel!=null){
	             sqlToExecute=sqlToExecute+ '  and Distributor_Level__c=\''+distributorLevel+'\'';
	             
	        }
	        /*if(brand != null){
	        	sqlToExecute=sqlToExecute+ ' and Brands_Serviced__c=\''+brand+'\'';
	        }*/
	         
	        sqlToExecute=sqlToExecute+' '+ ' '+ 'and' +' '+ 'Industry IN '+ ':' + ' '+'setIndustries' +' ' + 'and  Geocode_Latitude__c <='+ con.latMax+' and'+' ' +' Geocode_Latitude__c >='+con.latMin+' and Geocode_Longitude__c <='+con.lonMax+' and Geocode_Longitude__c >='+con.lonMin ;
	        // adding limit to the results
	        //sqlToExecute=sqlToExecute+' limit '+Integer.valueOf(resultLimit);
	        accList= Database.query(sqlToExecute);
	       
	        if(accList!=null && accList.size() >= 9){
	             
	        }else{
	            System.debug('Going inside while  loop ============');
	            while(accList!=null && accList.size() < 9){
	                radius =radius+100;
	                //Calculate the search radius around the check-in coordinates
	                con.calculateSearchRadius(Double.valueOf(longitude),Double.valueOf(latitude), radius);
	                sqlToExecute=sqlToExecute+'and  Geocode_Latitude__c <='+ con.latMax+' and Geocode_Latitude__c >='+con.latMin+' and Geocode_Longitude__c <='+con.lonMax+' and Geocode_Longitude__c >='+con.lonMin+ ' '+ 'and' +' '+ 'Industry IN '+ ':' +' '+ 'setIndustries';
	                accList= Database.query(sqlToExecute);
	                break;
	            }
	        }
	        List<Account> sortedList=getSortedAccount(accList,longitude,latitude,Integer.valueOf(resultLimit));                                                                                                                              
	        return sortedList;
	    } 
	 	catch(Exception ex)
	 	{
	 		System.debug('-----------------------Exception--------'+ex.getMessage()+' '+ex.getLineNumber());
	 		return null;
	 	}
    }
    
    public List<Account> getSortedAccount(List<Account> accList,String longitude,String latitude,Integer limitValue){
        
        List<Account> sortedAccList = new List<Account>();
        List<double> sortDistance = new List<double>();
        Map<double,Account> accMap = new Map<double,Account>();
        double distance=0;
        Integer counter=0;
        
        for(Account accObj:accList){
             
            distance =  distance(Double.valueOf(longitude),Double.valueOf(latitude),Double.valueOf(accObj.Geocode_Longitude__c),Double.valueOf(accObj.Geocode_Latitude__c),'N');
            while(accMap.containsKey(distance)){
                distance=distance+0.0001;
            }
            sortDistance.add(distance);
            accMap.put(distance,accObj);
         }
        sortDistance.sort();
        for(double dist:sortDistance){
            if(9 > counter){
                if(accMap.containsKey(dist)){
                    counter++;
                    sortedAccList.add(accMap.get(dist));
                    
                }
            
            }else{
                break;
            }
            
        }
        
        
        return  sortedAccList;
        
    }
    
    public double distance(double lat1, double lon1, double lat2, double lon2, String unit) {
  double theta = lon1 - lon2;
  double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
  dist = Math.acos(dist);
  dist = rad2deg(dist);
  dist = dist * 60 * 1.1515;
  if (unit == 'K') {
    dist = dist * 1.609344;
  } else if (unit == 'N') {
        dist = dist * 0.8684;
    }
  return (dist);

}

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::  This function converts decimal degrees to radians             :*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public double deg2rad(double deg) {
  return (deg * (3.14159266) / 180.0);

}

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*::  This function converts radians to decimal degrees             :*/
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
public double rad2deg(double rad) {
  return (rad * 180.0 / (3.14159266));

}
      
 
}