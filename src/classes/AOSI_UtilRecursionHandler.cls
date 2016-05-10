/*****************************************************************************************************************************************************
 * Class Name   : AOSI_UtilRecursionHandler 
 * Created By   : Pooja P Bhat
 * Created Date : 21-SEPTEMBER-2015
 * Description  : Helper class to handle recurion of trigger on after context 
******************************************************************************************************************************************************/
public class AOSI_UtilRecursionHandler {
    
    public static Boolean isCaseBeforeUpdateRecursive       =   false;
    public static Boolean isCaseAfterUpdateRecursive        =   false;
    
    public static Boolean isContractBeforeUpdateRecursive   =   false;
    public static Boolean isContractAfterUpdateRecursive    =   false;
    
    public static Boolean isIncomingSMSAfterUpdateRecursive =   false;
    
    public static Boolean isContactBeforeUpdateRecursive    =   false;
    
    //variable added by Keyur Modi for power of 1 calculation 
    public static Boolean isPowerOf1Recirsive               =   false;
       
}