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
@isTest(seeAllData=true)
private class TestCandidateConverter {

    static testMethod void myUnitTest() {
        City_Master__c cm=new City_Master__c();
    cm.AOSI_City__c='Bangalore';
    cm.District__c='Bangalore';
    cm.AOSI_Region__c='South';
    cm.AOSI_State__c='Karnataka';
    
    Candidate__c candidate=new Candidate__c();
    candidate.alternatenumber__c = '8904623622';
    //candidate.candidatecode__c='ASP001';
    candidate.candidateemail__c='rajesh.kumar@kvpcorp.com';
    candidate.currentaddrcity__c='Bangalore';
    candidate.currentaddrregion__c='South';
    candidate.currentaddrstate__c='Karnataka';
    candidate.currentaddrstreet__c='71';
    candidate.currentaddrzipcode__c='560091';

    candidate.dateofbirth__c=System.today();
    candidate.experience__c='Experienced - Other Industry';
    candidate.fathersname__c='Demo';
    candidate.firstname__c='First Name';
    candidate.lastname__c='Last NAme';
    candidate.mobilenumber__c='8904623622';
    candidate.Type__c='Co-ordinator';
    candidate.City_Master__c=cm.Id;
    insert candidate;
    List<Candidate__c> candidatelist=new List<Candidate__c>();
    candidatelist.add(candidate);
    CandidateConverter.convertCandidateToResource(candidatelist);
    
 
    }
}