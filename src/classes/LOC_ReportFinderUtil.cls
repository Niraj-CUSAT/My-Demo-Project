public with sharing class LOC_ReportFinderUtil {

  public LOC_ReportFinderUtil(){}
  
  public String findReportId(String reportName){
    
    try
    {
	    Sobject myReport = [select Id,Name From Report Where Name=:reportName];
	    
	    return myReport.Id;
    }
    catch(Exception e)
    {
    	system.debug('@@@@@@@@@@@@@@ '+e.getMessage()+e.getLineNumber());
    	return null;
    }
    
  }
  //
   //
     @isTest()
    static void Test_LOC_ReportFinderUtil()
    {    	
    	LOC_ReportFinderUtil objRFU = new LOC_ReportFinderUtil();
    	String test = objRFU.findReportId('Test report');
    }
}