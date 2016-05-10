/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_TBN_RecursionHelper {

    static testMethod void TBN_RecursionHelper() {
    	
        TBN_RecursionHelper objRecursion = new TBN_RecursionHelper();
        TBN_RecursionHelper.getisDelete();        
        TBN_RecursionHelper.setisDelete(true);
        TBN_RecursionHelper.getisinsertCaseComment();
        TBN_RecursionHelper.setisinsertCaseComment(true);
        TBN_RecursionHelper.getisInsert();
        TBN_RecursionHelper.setisInsert(true);        
       	TBN_RecursionHelper.setisAfterInsert(true);
        TBN_RecursionHelper.getisAfterInsert();
        TBN_RecursionHelper.getisBeforeUpdate();
        TBN_RecursionHelper.setisBeforeUpdate(true);
        TBN_RecursionHelper.getisAfterUpdate();
        TBN_RecursionHelper.setisAfterUpdate(true);
        
        
    }
}