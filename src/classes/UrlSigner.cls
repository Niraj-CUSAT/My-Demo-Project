/*#########################################################################
# File..................: UrlSigner
# API Version...........: 20
# Created by............: Ravindra S Bist
# Created Date..........: 07-Sep-2011
# Last Modified by......: Ravindra S Bist
# Last Modified Date....: 
# Description...........:  This class implement URL signing using server-side code.
                        
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
public class UrlSigner {
	
	 // Note: Generally, you should store your private key someplace safe
  // and read them into your code

  private String keyString {set;get;}
  
  // The URL shown in these examples must be already
  // URL-encoded. In practice, you will likely have code
  // which assembles your URL from user or web service input
  // and plugs those values into its parameters.
  private  String urlString {set;get;}

  // This variable stores the binary key, which is computed from the string (Base64) key
  private  Blob key{set;get;}
  
  
  public UrlSigner(String keyStringtemp) {
    // Convert the key from 'web safe' base 64 to binary
    keyStringtemp = keyStringtemp.replace('-', '+');
    keyStringtemp = keyStringtemp.replace('_', '/');
    System.debug('Key: ' + keyStringtemp);
    this.key =  EncodingUtil.base64Decode(keyStringtemp);
    System.debug('Key=============================='+key.toString());
  }
 
  public String signRequest(String path, String query) {
    
    // Retrieve the proper URL components to sign
    String resource = path + query;
     
    // Get an HMAC-SHA1 signing key from the raw key bytes
    String algorithmName = 'HmacSHA1'; //’RSA’;
    
	Blob input = Blob.valueOf(resource);
	
	//Blob key = Blob.valueOf(secretkey);
	
	Blob signing =Crypto.generateMac(algorithmName, input, key); 
 	 
    // base 64 encode the binary signature
    //String signature = EncodingUtil.urlEncode(EncodingUtil.base64Encode(signing), 'UTF-8');
     String signature =EncodingUtil.base64Encode(signing);
    // convert the signature to 'web safe' base 64
    signature = signature.replace('+', '-');
    signature = signature.replace('/', '_');
      
    return resource + '&signature=' + signature;
  }
  
   public static testMethod void testValidDecryption() {

        String source='sector 14+Gurgaon+Haryana+India';
        String target='sector 30+Gurgaon+Haryana+India';
        String secUrl='origins='+source+'&destinations='+target+'&units=imperial&sensor=false&client='+GoogleAPI__c.getInstance('clientID').Value__c;
        String url=GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+secUrl;
        UrlSigner signer = new UrlSigner(GoogleAPI__c.getInstance('URLSigning').Value__c);
        //String request = signer.signRequest(GoogleAPI__c.getInstance('GoogleMapDistance').Value__c,secUrl);
        //String request = signer.signRequest('http://maps.googleapis.com/maps/api/staticmap?','center=sector30+Gurgaon+Haryana+India&client='+GoogleAPI__c.getInstance('clientID').Value__c+'&sensor=false');
      //  String request = signer.signRequest('http://maps.googleapis.com','/maps/api/geocode/xml?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&client='+GoogleAPI__c.getInstance('clientID').Value__c+'&sensor=false');
         String request = signer.signRequest(GoogleAPI__c.getInstance('GoogleMapDistanceSecondPart').Value__c,'origins=dlf+phase+3+Gurgaon+Haryana+India&destinations=dlf+phase+4+Gurgaon+Haryana+India&client='+GoogleAPI__c.getInstance('clientID').Value__c+'&sensor=false');
         System.debug('request================'+GoogleAPI__c.getInstance('GoogleMapDistance').Value__c+request);
         
          String url1=GoogleAPI__c.getInstance('GeocodingAPI').Value__c+signer.signRequest(GoogleAPI__c.getInstance('GeocodingAPISecondPart').Value__c,'address=dlf+phase+3+Gurgaon+Haryana+India&client='+GoogleAPI__c.getInstance('clientID').Value__c+'&sensor=false') ;
   		  System.debug('url================'+url1);
    
    }

}