/*#########################################################################
# File..................: Tr_Account_After_Insert_Update
# API Version...........: 20
# Created by............: Ravindra S Bist
# Created Date..........: 11-Aug-2011
# Last Modified by......: VKumar(Trekbin)
# Last Modified Date....: 17-Sep-2013
# Description...........: This Trigger get called on Account Insert and update.
                        
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
trigger Tr_Account_After_Insert_Update on Account (after insert, after update) {
	
	if(!(Test.isRunningTest() || Limits.getQueries() > 20))
	{
		//if(GoogleAPIHelper.isTriggerFired == true) return;
	
		/** Helper class contain all Geocode logic **/
		GoogleAPIHelper trgHelper = new GoogleAPIHelper();
	 
 		trgHelper.processAccountData(trigger.newMap,trigger.oldMap,trigger.isInsert);
	} 
	 
}