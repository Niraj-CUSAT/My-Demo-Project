//Test class for TBN_AccountHandler
@isTest

private class Test_TBN_AccountTrigger {

static testmethod void TBN_AccountTest(){
    Account objParentAccount = new Account(Name = 'Parent Account');
    
    insert objParentAccount;
    
    Account objAccount = new Account(Name = 'Child account', ParentId = objParentAccount.Id,
    LOC_Manufacturers_Rep__c = false);

    insert objAccount;
    
    objParentAccount.LOC_Manufacturers_Rep__c = true;
    update objParentAccount;
    
    system.assertEquals(objParentAccount.LOC_Manufacturers_Rep__c, true);
    system.assertEquals(objAccount.ParentId, objParentAccount.Id);
    
      }
     }