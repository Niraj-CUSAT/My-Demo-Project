/*****************************************************************************************************************************************************
 * Class Name   : DefineConstant 
 * Created By   : Pooja P Bhat
 * Created Date : 22-JUNE-2015
 * Modified By  : Rajesh Kumar
 * Modified Date: 16-OCTOBER-2015
 * Description  : Defines all the Constant values
******************************************************************************************************************************************************/
public class DefineConstant {

    //DEVELOPER NAME(RECORD TYPE)    
    public static String RECORD_TYPE_AOS_INDIA = 'AOSIndia';
    
    
    //CASE OBJECT CONSTANT VALUES
    public static String OBJECT_NAME_CASE                                   =   'Case';
    public static String CASE_OBJECT_DEVNAME_AOSIndia                       =   'AOSIndia';
    
    public static Integer TDS_INPUT_2000                                    =   2000;
    public static Integer HARDNESS_400                                      =   400;

    
    public static Integer COUNT_LIMIT_SALESQUERY                            =   6;
    
    public static String CASE_REASON_FREE_INSTALLATION                      =   'Free Installation';
    public static String CASE_REASON_CHARGEABLE_INSTALLATION                =   'Chargeable Installation';
    public static String CASE_REASON_SERVICE                                =   'Service';
    public static String CASE_REASON_PM_SERVICE                             =   'PM Service';
    public static String CASE_REASON_COLORPANEL_FREE                        =   'Color Panel (Free)';
    public static String CASE_REASON_COLORPANEL_CHARGEABLE                  =   'Color Panel (Chargeable)';
    public static String CASE_REASON_DEALER_STOCK                           =   'Dealer Stock';
    public static String CASE_REASON_WARRANTY_REG                           =   'Warranty Registration';
    public static String CASE_REASON_SALES_QUERY                            =   'Sales Query';
    public static String CASE_REASON_FIELD_TRIAL                            =   'Field Trial';
    public static String CASE_REASON_SYSTEM_TESTING                         =   'System Testing';
    public static String CASE_REASON_CONTRACT_REQUEST                       =   'Contract Request';
    public static String CASE_REASON_EXCHANGE_PICKUP                        =   'Exchange - Pickup';
    
    public static String CASE_STATUS_OPEN                                   =   'Open';
    public static String CASE_STATUS_CLOSED                                 =   'Closed';
    public static String CASE_STATUS_PARTIALLY_CLOSED                       =   'Partially Closed';
    public static String CASE_STATUS_ON_HOLD                                =   'On Hold';
    public static String CASE_STATUS_CANCELLED                              =   'Cancelled';
    public static String CASE_STATUS_UNREG_UNALLOCATED                      =   'Unregistered / Unallocated';
    public static String CASE_STATUS_CC_SSV                                 =   'CC-SSV';
    
    public static String CASE_TYPE_INSTALLATION                             =   'Installation';
    public static String CASE_TYPE_COMPLAINT_REG                            =   'Complaint Registration';
    
    public static String CASE_WARRANTY_STATUS_WR                            =   'WR';
    
    public static String CUST_CONCRN_OTHER                                  =   'Other';
    
    public static String REFUND_PROCESSING                                  =   'Refund Processing';
    public static String REPLACEMENT_PROCESSING                             =   'Replacement Processing';
    public static String PART_PENDNG_BRANCH                                 =   'Part Pending Branch';
    public static String PART_PENDNG_TECHNICIAN                             =   'Part Pending Technician';
    public static String UNDER_OBSERVTN                                     =   'Under Observation';
    
    //Asset Object Constant Values
    public static String ASSET_MEMBRANE_WRRTY_2YRS                          =   '2 Year';
    public static String ASSET_MEMBRANE_WRRTY_1YR                           =   '1 Year';
    public static String ASSET_MEMBRANE_WRRTY_NIL                           =   'NIL';
    public static String ASSET_STATUS_OUTOFWTY                              =   'Out Of Warranty';
    public static String IN_CONTRCT                                         =   'In Contract';
    public static String OUT_OF_CONTRCT                                     =   'Out of Contract';
    
    //Product Object Constant Values
    public static String PROD_MEMBRANE_WTY_2YRS                             =   'Membrane Wty 2 Years';
    public static String PROD_MEMBRANE_WTY_1YR                              =   'Membrane Wty 1 Year';
    public static String PROD_MEMBRANE_NO_WTY                               =   'Membrane No Wty';
    public static String PROD_VERTICAL_WT                                   =   'Water Treatment';
    public static String PROD_VERTICAL_WH                                   =   'Water Heater';
    
    //AOSI Contract Object Constant Values
    public static String OBJECT_NAME_CONTRACT                               =   'AOSI_Contract__c'; //Modification
    public static String CONTRACT_UNDERPROGRESS                             =   'Under Progress';
    public static String CONTRACT_AMC                                       =   'AMC';   
    public static String CONTRACT_ACMC                                      =   'ACMC';
    public static String CONTRACT_FLT                                       =   'FLT';
    public static String CONTRACT_STAT_ACTIVE                               =   'Active';
    public static String CONTRACT_STAT_INACTIVE                             =   'Inactive';
    public static String CONTRACT_STAT_TERMINATED                           =   'Terminated';
    
    //SMS Template Constant Values
    public static String SMS_SENT_BY_TRIGGER                                =   'SMS_SENT_BY_TRIGGER';
    public static String SMS_HAS_TO_BE_SENT                                 =   'SMS_HAS_TO_BE_SENT';
    
    public static String SMSTEMP_INSTALLATION                               =   'SMS on Case for Installation';
    public static String SMSTEMP_COLOR_PANEL_REG                            =   'SMS on Case for Color Panel Registration';
    public static String SMSTEMP_COMPLAINT_REG                              =   'SMS on Case for Complaint Registration';
    public static String SMSTEMP_FOR_WARRANTY_REG                           =   'SMS on Case for Warranty Registration';
    public static String SMSTEMP_FOR_OTP                                    =   'SMS to send OTP to the customer'; // Modification
    public static String SMSTEMP_FOR_OTP_INVALID_FORMAT                     =   'SMS to send message to the customer if message format is incorrect';//Modification // Modification
    public static String SMSTEMP_FOR_OTP_UNREGISTERED_NUMBER                =   'SMS to the customer with unregistered mobile number';
    public static String SMSTEMP_FOR_OTP_INVALID_CONTRACT_TYPE              =   'SMS to the customer with wrong contract type';
    public static String SMSTEMP_FOR_SERVICE_ENGINEER_DETAILS_TO_CUSTOMER   =   'SMS on Case for Service Engineer Details to Customer';
    public static String SMSTEMP_TO_INSTALLER_FOR_COMPLAINT                 =   'SMS on Case to Installer for Complaint';
    public static String SMSTEMP_TO_INSTALLER_FOR_INSTALLATION              =   'SMS on Case to Installer for Installation';
    public static String SMSTEMP_CASE_CLOSE_FOR_COLOR_PANEL                 =   'SMS on Case Close for Color Panel';
    public static String SMSTEMP_CASE_CLOSE_FOR_INSTALLATION                =   'SMS on Case Close for Installation';
    public static String SMSTEMP_CASE_CLOSE_FOR_COMPLAINT                   =   'SMS on Case Close for Complaint';
    public static String SMSTEMP_STATUS_CHANGED_TO_CANCELLED                =   'When call status is changed to Cancelled';
    public static String SMSTEMP_STATUS_CHANGED_TO_ONHOLD                   =   'When call status is changed to onHold';
    public static String SMSTEMP_TO_CUSTOMER_FOR_SERVICE_CHARGES            =   'SMS to customer for service charges';
    public static String SMSTEMP_ON_SALESQUERY_CASE_CREATION_NEW            =   'SMS On Case On Sales Query Case Creation New';
    public static String SMSTEMP_TO_INSTALLER_FOR_COLORPANEL_NEW            =   'SMS on Case to Installer for Colorpanel new';
    public static String SMSTEMP_ON_RESPOND_TIME_TO_CUSTOMER                =   'SMS on Respond time to customer';
    public static String SMSTEMP_ON_SALESQUERY_CASE_ASSIGNMNT_NEW           =   'SMS On Case On Sales Query Case Assignment New';
    public static String SMSTEMP_ON_SALESQUERY_CASE_CANCELLATION_NEW        =   'SMS On Case On Sales Query Case Cancellation New';
    public static String SMSTEMP_ON_SALESQUERY_CASE_CLOSE                   =   'SMS On Case On Sales Query Case Close New';
    public static String SMSTEMP_SURVEY_ON_CASE_CLOSE_AFTER_2_DAYS          =   'SMS Survey on Case After 2 Days of Closing';
    public static String SMSTEMP_FOR_TEMP_PASSWORD                          =   'SMS on forgot password'; // Modification
    //AMC Master Object Constant Value
    public static String AMC_STATUS_ACTIVE                                  =   'Active'; 
    public static String AMC_WH_AMC                                         =   'WH-AMC';
    public static String AMC_WT_AMC                                         =   'WT-AMC';
    public static String AMC_WT_ACMC                                        =   'WT-ACMC';
    public static String AMC_WT_FP                                          =   'WT-Filter Plan';
    public static String AMC_WT_VP                                          =   'WT-Visit Plan';
    public static String CONTRACT_TYPES                                     =   'AMC,ACMC,FLT';
    
    //Roles - DeveloperName
    public static String RCCNorth                                           =   'Regional_Call_Coordinator_North';
    public static String RCCSouth                                           =   'Regional_Call_Coordinator_South';
    public static String RCCEast                                            =   'Regional_Call_Coordinator_East';
    public static String RCCWest                                            =   'Regional_Call_Coordinator_West';
    
    //Regions
    public static String NORTH                                              =   'North'; 
    public static String SOUTH                                              =   'South'; 
    public static String EAST                                               =   'East'; 
    public static String WEST                                               =   'West'; 
    
    //Profile Name
    public static String PROFILE_ASPAOSI                                    =   'ASP AOSI';
    
    //SMS-MAGIC SENDER ID
    public static String SMS_SENDER_ID                                      =   'AOSSVC';
    
    //SMS-MAGIC Schedule SMS Object Constant Values
    public static String SMS_STATUS_SCHEDULE                                =   'Schedule'; 
    
    //TASK OBJECT CONSTANT VALUES
    public static String TASK_PRIORITY_NORMAL                               =   'Normal';
    public static String TASK_STATUS_COMPLETED                              =   'Completed';
    public static String TASK_STATUS_INPROGRESS                             =   'In Progress';
    public static String TASK_STATUS_NOTSTARTED                             =   'Not Started';
    
    public static String CONSTANT_TRUE                                      =   'True';
    public static String CONSTANT_FALSE                                     =   'False';
    
    public static String START                                              =   'START';
    public static String STOP                                               =   'STOP';
    public static String YES                                                =   'YES';
    public static String NO                                                 =   'NO';
    
    public static String SATISFIED                                          =   'Satisfied' ;
    public static String NOTSATISFIED                                       =   'Not Satisfied';
    
    public static String CS_DAILY_SMS_TIMING                                =   'Daily SMS Timing';
    public static String CS_SCHEDULESMS_NEXTDAY                             =   'ScheduleSMS NextDay';
    public static String CS_SCHEDULESMS_SAMEDAY                             =   'ScheduleSMS SameDay';
    public static String CS_CASE_REG_IN_BTW                                 =   'Case Registered In Between';
    public static String CS_START_SMS_NEXT_DAY                              =   'StartSMS Recieve Next Day';
    public static String CS_REPEAT_CALL_DURATION                            =   'Repeat Call Duration';
    
    public static String OBJECT_NAME_RESOURCE                               =   'Service_Engineer__c'; //Modification
    
}