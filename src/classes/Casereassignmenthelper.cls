/*
created by: Bhanu vallabhu, KVP business solutions, Created On: 11 Sep 14;
Description: helper class to change owner to RCC in case of color panel cases for AOS india recordtype 
*/

public without sharing class Casereassignmenthelper {
	//Casereassignmenthelper(){}
	@future 
	public static void changeowner(set<id> panelids){
				list<Case> currentcases = [select id,casenumber,ownerid,AOSI_Region__c,reason,status from case where ID IN: panelids];
				map<String,Id> rccusermap = new map<String,Id>();
				list<Case> panelcases = new list<Case>();
				for(user us : [Select u.UserRole.DeveloperName, u.UserRoleId, u.IsActive, u.Id From User u where u.UserRole.DeveloperName like 'Regional_Call_Coordinator%']){
					rccusermap.put(us.UserRole.DeveloperName, us.Id);
				}
				for(case cs : currentcases){
					if((cs.Reason.equalsIgnorecase('Color Panel (Free)') || cs.Reason.equalsIgnorecase('Color Panel (Chargeable)')) ){
						case panelcase = new case(Id=cs.Id);
						if( cs.AOSI_Region__c.equalsIgnorecase('North') && rccusermap.containskey('Regional_Call_Coordinator_North')){
									panelcase.ownerid = rccusermap.get('Regional_Call_Coordinator_North');
						}
						else if( cs.AOSI_Region__c.equalsIgnorecase('South') && rccusermap.containskey('Regional_Call_Coordinator_South')){
										panelcase.ownerid = rccusermap.get('Regional_Call_Coordinator_South');
						}
						else if( cs.AOSI_Region__c.equalsIgnorecase('East') && rccusermap.containskey('Regional_Call_Coordinator_East')){
								panelcase.ownerid = rccusermap.get('Regional_Call_Coordinator_East');
						}
						else if( cs.AOSI_Region__c.equalsIgnorecase('West') && rccusermap.containskey('Regional_Call_Coordinator_West')){
									panelcase.ownerid = rccusermap.get('Regional_Call_Coordinator_West');
						}
						panelcases.add(panelcase);
				}
			}
			if(!panelcases.isempty()){
					database.Update(panelcases);
			}
		}

}