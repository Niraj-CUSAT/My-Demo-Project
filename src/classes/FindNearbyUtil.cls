/*#########################################################################
# File..................: FindNearbyUtil
# API Version...........: 20
# Created by............: Ravindra S Bist
# Created Date..........: 11-Aug-2011
# Last Modified by......: Ravindra S Bist
# Last Modified Date....: 
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
public class FindNearbyUtil {
   
   // Variable to hold Maximum latitude
    public Double LatMax =0;
   // Variable to hold minimum latitude
    public Double LatMin =0;
   // Variable to hold Maximum longitude
    public Double LonMin =0;
  // Variable to hold minimum longitude
    public Double LonMax =0;
   
    /* This method calculate the maximum and minimum range of longitude and  latitude based on the starting longitude/latitude and distance  around it  */
	public void calculateSearchRadius(Double startLon, Double startLat, Double Distance)
	{
        Double LatDiff=0; 
        Double LonDiff=0;
        Double LatEnd,LonEnd,X,Y; 
        LatMax=0;
        LatMin=0;
        LonMin=0;
        LonMax=0;
        Double Answer =0; 
        
        try{
            //Fixed Latitude 
            while(Answer < Distance){
                LatDiff+=.001;
                latEnd = startLat+latDiff;
                X = 69.1 * (latEnd - startLat);
                Answer = Math.sqrt(X*X);
            }
            
            //Fixed Longitude
            Answer = 0; 
            while(Answer<Distance){
                LonDiff+=.001;
                lonEnd=LonDiff+startLon;
                Y = 69.1* (lonEnd-startLon)*Math.cos(startLat/57.3);
                Answer = Math.sqrt(Y*Y);
            }
            
            LatMin = startLat-latDiff;
            LatMax = startLat+latDiff;
            LonMin = startLon-LonDiff;
            LonMax = startLon+lonDiff;
        
        }catch(Exception e){
            latMax= 1;
            latMin = 2; 
            lonMin = 2;
            lonMax = 1; 
            LonEnd = 1;
            LatEnd = 2; 
        }
		
	}
	//Test case for testing purpose
	static testMethod void testUtil()
	{
		FindNearbyUtil util = new FindNearbyUtil();
		util.calculateSearchRadius(1,1,5);
		System.assertEquals(util.LatMax, 1.073);
		System.assertEquals(util.LatMin, 0.927);
		System.assertEquals(util.LonMax, 1.073);
		System.assertEquals(util.LonMin, 0.927);
	}
}