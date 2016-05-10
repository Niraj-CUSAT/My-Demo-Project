/**
@ClassName      :   AOSI_GPS_CaseDetailController
@CreatedDate    :   17-03-2016
@Description    :   Display the all open cases on vf-page.
*/
public with sharing class AOSI_GPS_CaseDetailController 
{
    //Variable
    private List<Case> lstOpenCasesOnPage;
    
    /***** Constructor ******/
    public AOSI_GPS_CaseDetailController(){
        // Total no.of records of open cases
        lstOpenCasesOnPage = new List<Case>();
    }
    
    /**
    @MethodName     :   getListOfOpenCases
    @Param          :   None
    @Description    :   To Returning list of all open cases
    */
    public List<Case> getListOfOpenCases() 
    {
        lstOpenCasesOnPage = 	[Select Id, CaseNumber, Contact.Name, Serial_Number__c, CreatedDate, Origin, Status, AOSI_ASP_City__c, AOSI_Product_Vertical__c 
                                From Case 
                                Where Status =: 'Open' And Service_Engineer__r.Id = null
                                ]; 
        //And Contact.Pincode__c != null 
        // Returning list of all open cases on page for pagination.
        system.debug('+++++++++lstOpenCasesOnPage+++++++++++' + lstOpenCasesOnPage);
        return lstOpenCasesOnPage;
    }    
}
/***** End of class ******/