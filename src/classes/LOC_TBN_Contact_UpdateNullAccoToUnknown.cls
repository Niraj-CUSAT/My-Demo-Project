/*
     * Name       : TBN_Contact_UpdateNullAccountstoUnknown 
     * Description: Trigger handler class for Contact trigger and performs the following functionality
                        - Updates the Contact's Account to 'LOC Unknown'/'AOS Unknown'/'AOSmith India Unknown' based on the user company(AOSmith, AOSmith India, Lochinvar)
                        - Keeps the Contact's OwnerId in synchronization with the corresponding Account's OwnerId 
     *
     * Maintenance History:
     * 20/03/2013   - VK - 1.0 - Created
     * 06/06/2013   - VK - 1.1 - Updated(Reference : VIRSYGEN-40) : Added code to keep the Contact's OwnerId in synchronization with the corresponding Account's OwnerId
     * 26/02/2013   - VK - 1.2 - Updated(Reference : VSYSAOS - 33 ) : If an Contact inserted/Updated without an Account based on recordType of contact trigger assigns the Account
     * 28/02/2013   - VK - 1.3 - Updated(Reference : VSYSAOS - 34) :Updates the Contact's Account to 'LOC Unknown'/'AOS Unknown'/'AOSmith India Unknown' based on the user 
                                company(AOSmith, AOSmith India, Lochinvar)
                            
*/

public without sharing class LOC_TBN_Contact_UpdateNullAccoToUnknown 
{
    private static final String LOC_ACC_Name = 'LOC Unknown';
    private static final String AOS_ACC_Name = 'AOS Unknown';
    private static final String AOSINDIA_ACC_Name = 'AOS India Unknown'; 
    private Id topLevelRoleAOSId;
    private Id topLevelRoleAOSINDIAId;
    private Id topLevelRoleLOCId;
    public static boolean isTriggerFired = false;
    
    //Updates the Contact's Account to 'LOC Unknown'/'AOS Unknown'/'AOSmith India Unknown' based on the user company(AOSmith, AOSmith India, Lochinvar)
    public void onBeforeUpdateInsert(list<Contact> lstContacts)
    {
        // Retrive the Accounts required 
        topLevelRoleAOSId = topLevelRoleLOCId = topLevelRoleAOSINDIAId = null; 
        List<Account> lstLOCAcc = [Select Id, Name, OwnerId From Account Where Name =: LOC_ACC_Name limit 1];
        List<Account> lstAOSAcc = [Select Id, Name, OwnerId From Account Where Name =: AOS_ACC_Name limit 1];
        List<Account> lstAOSINDIAAcc = [Select Id, Name, OwnerId From Account Where Name =: AOSINDIA_ACC_Name limit 1];      
        
        Set<Id> setAOSmithRoleIds = getRoleSubordinateIds('AO Smith');
        setAOSmithRoleIds.add(topLevelRoleAOSId);        
        
        Set<Id> setAOSmithIndiaRoleIds = getRoleSubordinateIds('AO Smith India Manager');
        setAOSmithIndiaRoleIds.add(topLevelRoleAOSINDIAId);        
        
        Set<Id> setLochinvarRoleIds = getRoleSubordinateIds('All Data - LOC');
        setLochinvarRoleIds.add(topLevelRoleLOCId);        
        
        Id currentUserRoleId = UserInfo.getUserRoleId();
        
        // Traverse the list of contact and checks for contacts without an Account and assigns the respective Account based on the logged in user role
        for(Contact objCon : lstContacts)
        { 
            if(objCon.AccountId == null)
            {
                if(setAOSmithRoleIds.contains(currentUserRoleId) && !lstAOSAcc.ISEmpty())
                {
                    objCon.AccountId = lstAOSAcc[0].Id;
                    objCon.OwnerId = lstAOSAcc[0].OwnerId;                    
                }
                else if(setAOSmithIndiaRoleIds.contains(currentUserRoleId) && !lstAOSAcc.ISEmpty())
                {
                    objCon.AccountId = lstAOSINDIAAcc[0].Id;
                    objCon.OwnerId = lstAOSINDIAAcc[0].OwnerId;                    
                }
                else if(setLochinvarRoleIds.contains(currentUserRoleId) && !lstAOSAcc.ISEmpty())
                {
                    objCon.AccountId = lstLOCAcc[0].Id;
                    objCon.OwnerId = lstLOCAcc[0].OwnerId;                    
                }
            }
        }
    }
    
    // Method to get the Role and the subordinates related to it.
    private  Set<ID> getRoleSubordinateIds(String strTopMostParentRoleName)
    {   
      /*if(!Test.isRunningTest())
      {*/
          String strQuery = 'Select Name, Id From UserRole where Name =: strTopMostParentRoleName  limit 1';
               
          List<UserRole> lstUserRole = Database.query(strQuery);
          // Adding the TopMost profile Id to the respective sets
          if(strTopMostParentRoleName == 'AO Smith')
          {
              topLevelRoleAOSId = lstUserRole[0].Id;
          }
          else if(strTopMostParentRoleName == 'AO Smith India Manager')
          {
              topLevelRoleAOSINDIAId = lstUserRole[0].Id;
          }
          else if(strTopMostParentRoleName == 'All Data - LOC') 
          {
              topLevelRoleLOCId = lstUserRole[0].Id;
          }
          // Method called to fetch all the subordinates
          Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{lstUserRole[0].Id});
          
         
          return allSubRoleIds;
      /*}
      else 
        return null;*/
    }
 
    // Method to get all the subordinates under a specific role
    private Set<ID> getAllSubRoleIds(Set<ID> roleIds)
    {
        Set<ID> currentRoleIds =  new Set<ID>();        
        
        // get all of the roles underneath the passed roles
        if(!Test.isRunningTest()){ 
            for(UserRole userRole :[select Id from UserRole where ParentRoleId 
                                    IN :roleIds AND ParentRoleID != null])
            { 
                currentRoleIds.add(userRole.Id);
            }
            
            // go fetch some more rolls!
            if(currentRoleIds.size() > 0)
            {
                currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
            }           
        }
        return currentRoleIds;
   }
      
      @isTest(SeeAllData=true) 
    static void Test_LOC_TBN_Contact_UpdateNullAccoToUnknown()
    {
        User objUserAOS = [Select Id, Username, UserRoleId, UserRole.Name From User where UserRole.Name ='AP and Warranty' and isActive = true limit 1];
        
        User objUserLOC = [Select Id, Username, UserRoleId, UserRole.Name From User where UserRole.Name ='AO Smith India Manager'  and isActive = true limit 1]; 
        
        Pin_Master__c objPin =  new Pin_Master__c();
        objPin.AOSI_Area__c = 'Test';
        objPin.AOSI_City__c = 'Test';
        objPin.AOSI_Country__c = 'Test';
        objPin.AOSI_Region__c = 'East';
        objPin.AOSI_State__c = 'Bihar';
        objPin.AOSI_Street__c = 'Test';
        objPin.AOSI_Type__c = 'Local';
        insert objPin;
        
        
        
        System.runAs(objUserAOS)
        {
            Contact objCon = new Contact(LastName ='Test AOSmith', Phone='7012456734');
            insert objCon;
            
        }
        System.runAs(objUserLOC)
        {
            Contact objCon = new Contact(LastName ='Test AOSmith Manager', Phone='9012456733', AOSI_Pin_Code__c = objPin.Id);
            insert objCon;
            
        }
        
    } 
}