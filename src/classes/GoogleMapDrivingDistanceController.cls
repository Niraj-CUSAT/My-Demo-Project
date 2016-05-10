/*#########################################################################
# File..................: GoogleMapDrivingDistanceController
# API Version...........: 20
# Created by............: Ravindra S Bist
# Created Date..........: 16-Aug-2011
# Last Modified by......: Ravindra S Bist
# Last Modified Date....: 
# Last Modified by......: Vkumar
# Last Modified Date....: 11-Sep-2013
# Description...........: This contorller class is use to  render google map with  driving distance.
                        
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
public class GoogleMapDrivingDistanceController {
    
    //Hold Street name
    public String street {get;set;}
    //Hold city  name
    public String city {get;set;}
    //Hold State Name 
    public String state {get;set;}
    //Hold Country name
    public String country {get;set;}
    //Hold Zip Code Name
    public String zipCode {get;set;}
    //This variable hold the full address enter in input box
    public String fullAddress {get;set;}
    //This variable  hold the result value to be  shown  on the VF Page
    public String result{get;set;}
    //This variable hold the object instance of account
    //public Account accObj {get;set;}
    //  This variable is to enumerate the filters.
    public SPLookupFilters__c filtersObj {get;set;}
    //This variable hold the account id
    public String accountId{get;set;}
    //This variable hold the  contact id
    public String contactId{get;set;}
    //This variable hold the list of wrapper object
    public List<AccountDistanceData> accDistanceList {get;set;}
    //This variable hold the value of selected provider type 
    public String selectProviderType{get;set;}
    //This variable hold the  value  if distributor search  is done
    public Boolean distributorFlag{get;set;}
    //This variable  hold the  value if service provider search is done
    public Boolean serviceProviderFlag{get;set;}
    //This variable hold the value if control come from case  Action  flow
    public Boolean caseActionCallFlag{get;set;}
    //This variable hold the value if distributor seach is done and  try to click the  update case  button
    public Boolean disableFlag{get;set;}
    //This variable  hold the  source from which VF page  is called. Account, Contact,Case Action etc
    public String sourceOfCall{get;set;}
    //This variable is use  to hold the  case  Action id.
    public String caseActionId{get;set;}
    //This variable is use to  hold  the  geocode address
    public String geoCodeAddress{get;set;}
    //This  value is use to list of selected  account for  print and email
    public List<AccountDistanceData> listToPrint{get;set;}
    //This value is use to hold the email address from the  visual force page
    public String email {get;set;}
    public String msg {get;set;}
    public Boolean isLaunchedFromCaseAction {get;set;}
    
    /**
    *  This method is use on the Visual force page  load. It saves  the input parameter value in different variables
    *
    **/
    public void showGoogleMap(){
        
        //initialize  the variables
        //accObj = new Account();
        filtersObj = new SPLookupFilters__c();
        serviceProviderFlag=true;
        distributorFlag=false;
        selectProviderType='ServiceProvider';
         
        //setting src parameter value is variable 
        if(ApexPages.currentPage().getParameters().get('src')!=null){
            sourceOfCall=ApexPages.currentPage().getParameters().get('src');
        }
        //setting email parameter value is variable 
        if(ApexPages.currentPage().getParameters().get('email')!=null){
            email=ApexPages.currentPage().getParameters().get('email');
        } else{
            email='';
        }
        //setting caseActionId parameter value is variable if source is case action  object
        if(sourceOfCall=='Case'){
            if(ApexPages.currentPage().getParameters().get('caseActionId')!=null){
                caseActionId=ApexPages.currentPage().getParameters().get('caseActionId');
            }
            caseActionCallFlag=true;
            disableFlag=false;
        } 
        //setting account Id parameter value is variable 
        if(ApexPages.currentPage().getParameters().get('accId')!=null){
            accountId=ApexPages.currentPage().getParameters().get('accId');
        }
        //setting contact Id parameter value is variable 
        if(ApexPages.currentPage().getParameters().get('conId')!=null){
            contactId=ApexPages.currentPage().getParameters().get('conId');
        }
        //setting address parameter value is variable 
        if(ApexPages.currentPage().getParameters().get('street') != null && ApexPages.currentPage().getParameters().get('city') !=null
        && ApexPages.currentPage().getParameters().get('state') != null && ApexPages.currentPage().getParameters().get('country') !=null
        && ApexPages.currentPage().getParameters().get('zipCode') !=null){
        street=ApexPages.currentPage().getParameters().get('street');
        state=ApexPages.currentPage().getParameters().get('state');
        city=ApexPages.currentPage().getParameters().get('city');
        country=ApexPages.currentPage().getParameters().get('country');
        zipCode=ApexPages.currentPage().getParameters().get('zipCode');
                  
        fullAddress=street+' '+city+' '+state+' '+country+' '+zipCode;
        geoCodeAddress=street+', '+city+', '+state+', '+country+', '+zipCode;
        }
    }
    
        /*Constructor */    
        public GoogleMapDrivingDistanceController(){
        
        } 
    
    /*Method called when user selects any service provider as provider. It loads all the selected service provider which satisfy the input and
    * longitude,latitude limits.
    *
    */
    public PageReference SearchService(){
        
         system.debug('-------------Search------');
        //Intialze the variables
        disableFlag=false;
        accDistanceList= new List<AccountDistanceData>();
        
        //Setting the input address in variables
        fullAddress=street+' '+city+' '+state+' '+country+' '+zipCode;
        geoCodeAddress=street+', '+city+', '+state+', '+country+', '+zipCode;
        
        List<Account> accountList= new List<Account>();
        AccountDistanceData accDistanceObj;
        GoogleAPIHelper helper = new GoogleAPIHelper();
     
        //Fetching the  geocode of input address
        GoogleAPIHelper.GeoCodeData geoCodeObj= GoogleAPIHelper.GeoCodeIntegration(street+','+state+','+city+','+country+','+zipCode);
        system.debug('----------------geoCodeObj-------------'+geoCodeObj);
        //if google webservice  return success value
         system.debug('-------------geoCodeObj.success------'+geoCodeObj.success);
        if(geoCodeObj.success !=null && geoCodeObj.success){
                
            system.debug('--------in if--------------------');
            //Get the list of account based on criteria selected in search.
            accountList=helper.findTopNAccount(geoCodeObj.geoCode.longitude,geoCodeObj.geoCode.latitude,filtersObj.PL_BrandsServiced__c!=null?filtersObj.PL_BrandsServiced__c.split(';'):new List<String>(),filtersObj.PL_Services__c!=null?filtersObj.PL_Services__c.split(';'):new List<String>(),filtersObj.QSP_Co_Grade_Level__c,result);
            //if account found then  calculate the  driving distance and  duration
            system.debug('---------------accountList---------------'+accountList);
            if(accountList.size() >0){
                
                for(Account aObj:accountList){
                    
                        String  src=street+'+'+city+'+'+state+'+'+country+'+'+zipCode;
                        src=src.replaceAll(' ','+');
                        String target=aObj.ShippingStreet+'+'+aObj.ShippingCity +'+'+ aObj.ShippingState +'+'+ aObj.ShippingCountry +'+'+aObj.ShippingPostalCode;
                        target=target.replaceAll(' ','+');
                        //hit the google service to fetch the  driving distance and  duration
                        GoogleAPIHelper.DistanceMatrixData distanceObj= GoogleAPIHelper.googleDistanceMatrixAPICall(src,target);
                    
                        //setting the value fetched from google  web service in local  variables
                        accDistanceObj = new AccountDistanceData();
                        accDistanceObj.accutObj=aObj;
                        accDistanceObj.distance=distanceObj.distance;
                        accDistanceObj.duration=distanceObj.duration;
                        accDistanceObj.distanceValue=distanceObj.distanceValue;
                        accDistanceObj.address =aObj.ShippingStreet+' '+aObj.ShippingCity+' '+aObj.ShippingState+' '+aObj.ShippingCountry+' '+aObj.ShippingPostalCode;
                        accDistanceList.add(accDistanceObj);
                    
                }
                }else{
                        //If not account found then show the warning message on screen
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.warning,'No Service Provider/Distributor found.');
                        ApexPages.addMessage(myMsg);
                    }
                }
     
                // sorting the list of account based on distance
                accDistanceList=LinearSortList(accDistanceList,result);
        return null;
    } 
    /*Method called when user selects any distributor as provider. It loads all the selected distributor which satisfy the input and
    * longitude,latitude limits.
    *
    */
    public PageReference SearchDistributor() {
         
         //Intialze the variables
         disableFlag=true;
         accDistanceList= new List<AccountDistanceData>();
         //Setting the input address in variables
         fullAddress=street+' '+city+' '+state+' '+country+' '+zipCode;
         geoCodeAddress=street+', '+city+', '+state+', '+country+', '+zipCode;
        
        List<Account> accountList= new List<Account>();
        AccountDistanceData accDistanceObj;
        GoogleAPIHelper helper = new GoogleAPIHelper();
        fullAddress=street+' '+city+' '+state+' '+country+' '+zipCode;
        
        //Fetching the  geocode of input address
        GoogleAPIHelper.GeoCodeData geoCodeObj= GoogleAPIHelper.GeoCodeIntegration(street+','+state+','+city+','+country+','+zipCode);
        
        //if google webservice  return success value
        if(geoCodeObj.success !=null && geoCodeObj.success){
                    
            //Get the list of account based on criteria selected in search.
            accountList=helper.findTopNAccount(geoCodeObj.geoCode.longitude,geoCodeObj.geoCode.latitude,filtersObj.Market__c,filtersObj.Distributor_Services__c,filtersObj.Distributor_Level__c, result);
            //if account found then  calculate the  driving distance and  duration
            if(accountList.size() >0){
                    
                for(Account aObj:accountList){
                    
                    String  src=street+'+'+city+'+'+state+'+'+country+'+'+zipCode;
                    src=src.replaceAll(' ','+');
                    String target=aObj.ShippingStreet+'+'+aObj.ShippingCity +'+'+ aObj.ShippingState +'+'+ aObj.ShippingCountry +'+'+aObj.ShippingPostalCode;
                    target=target.replaceAll(' ','+');
                    
                     //hit the google service to fetch the  driving distance and  duration
                    GoogleAPIHelper.DistanceMatrixData distanceObj= GoogleAPIHelper.googleDistanceMatrixAPICall(src,target);
                
                    //setting the value fetched from google  web service in local  variables
                    accDistanceObj = new AccountDistanceData();
                    aObj.QSP_Co_Grade_Level__c=aObj.Distributor_Level__c;
                    accDistanceObj.accutObj=aObj;
                    accDistanceObj.distance=distanceObj.distance;
                    accDistanceObj.duration=distanceObj.duration;
                    accDistanceObj.distanceValue=distanceObj.distanceValue;
                    accDistanceObj.address =aObj.ShippingStreet+' '+aObj.ShippingCity+' '+aObj.ShippingState+' '+aObj.ShippingCountry+' '+aObj.ShippingPostalCode;
                    accDistanceList.add(accDistanceObj);
                    
            }
            }else{
                         
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.warning,'No Service Provider/Distributor found.');
                    ApexPages.addMessage(myMsg);
                }
            }
    
            // sorting the list of account based on distance  
            accDistanceList=LinearSortList(accDistanceList,result);
            return null;
        }
    /**
    * This  method is use to handle  the  logic to hit back button.
    * This  will transfer the  control back to the source page.
    **/
    public PageReference backToParent(){
        
        PageReference pref;
        
        //If source  page is case actoin then return  contal to Case Action  page
        if(sourceOfCall=='Case'){
             
            pref = new PageReference('/'+caseActionId);
        }else if(sourceOfCall=='Account' && ApexPages.currentPage().getParameters().get('id') != null){  //If source  page is Account then return  contal to Account   page
            pref = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
        }else if(sourceOfCall=='Account'){  //If source  page is Account then return  contal to Account   page
            pref = new PageReference('/'+accountId);
        }else if(sourceOfCall=='Contact'){ //If source  page is Contact then return  contal to Contact   page
            pref = new PageReference('/'+contactId);
        }else if(sourceOfCall=='console'){ //If source  page is console then return  to console   page
            pref = new PageReference('/apex/CustomerService?fromTab=true');
       }else{
            pref = new PageReference('/home/home.jsp'); //If source is home tab then return  to  home page
        }
        
        return pref;
    }
    /**
    * This  method is use to rerender the Visual force page  based on provider search (service  provider/ Distributor)
    **/
    public PageReference providerType() { 
        
        //accDistanceList= new List<AccountDistanceData>();
        //accDistanceList.clear();
        //If selection  is service provider  then show the servicer provider filters and hide the distributor filters
        if(selectProviderType=='ServiceProvider'){
            serviceProviderFlag=true;
            distributorFlag=false;
             
        }else{//If selection  is distributor  then show the distributor filters and hide the servicer provider filters
            serviceProviderFlag=false;
            distributorFlag=true;
        }
        return null;
    }
    /**
    * This  method is use to rerender the Preview Visual force page  based on selected provider (service  provider/ Distributor)
    **/
        public PageReference printPreview(){
        
         listToPrint = new List<AccountDistanceData>();
        //If account list return  by the search, then save the selected account based  on the check box selected in separate list
        if(accDistanceList!=null && accDistanceList.size() > 0){
            for(AccountDistanceData obj:accDistanceList){
                    //if checked box is selected then add in seprate list
                    if(obj.selectAccount){
                        listToPrint.add(obj);
                }
            }
        
            PageReference pref = new PageReference('/apex/SelectedAccountForPrint');
            pref.setRedirect(false);
             
            return pref;
            //return null;
        }else {
            //If not account is  selected  then give  a warning message in VF page
                ApexPages.Message selMsg = new ApexPages.Message(ApexPages.Severity.warning,'Please select atleast one Service Provider/Distributor.');
                ApexPages.addMessage(selMsg);
        }
        return null;
    }
        /**
        * This  method is use to send email based on selected provider (service  provider/ Distributor)
        **/
        public PageReference sendEmail(){
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.warning,'Please enter valid email address.');
        
         isLaunchedFromCaseAction = false;
        msg = '<b>Service Provider or Distributor near your address </b><br/><br/><b>Service Provider/Distributor </b><br/><br/>';
        if(ApexPages.currentPage().getParameters().get(' caseRefNumber ')!= null)
        {
            msg += '<b>' + 'Case Reference Number'+ '</b>' + ' '+ 'is'+' ' +ApexPages.currentPage().getParameters().get(' caseRefNumber ')+ '<br/>'+'<br/>';
            isLaunchedFromCaseAction = true;
        }
        listToPrint = new List<AccountDistanceData>();
        
        Integer charCode = 65;
            //If account list return  by the search, then save the selected account based  on the check box selected in separate list
        if(accDistanceList!=null && accDistanceList.size() > 0){
            //iterating through  the list of account
            for(AccountDistanceData obj:accDistanceList){
                    // creating the message to be send in email
                if(obj.selectAccount){
                    
                    String label = String.fromCharArray(new List <Integer> {charCode++});
                    msg += '<b>'+ label + '.</b> '+ obj.accutObj.Name + ' - ';
                    msg += obj.address + '<br/>';
                    if(obj.accutObj.phone!=null && obj.accutObj.phone.length() >0){
                        msg += ' Phone '+obj.accutObj.phone + '<br/>';
                    }
                    if(obj.accutObj.fax!=null && obj.accutObj.fax.length() >0){
                        msg += ' Fax '+obj.accutObj.fax + '<br/>';
                    }
                    
                    msg +='<br/>';
                }
            }
            //logic to validate the email address
                
            if(email!=null && email.trim().length() > 0){
                
                String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
                Pattern MyPattern = Pattern.compile(emailRegex);
                Id OrgWideEmailAddressId= [select Id from OrgWideEmailAddress where Address = 'help@hotwater.com' limit 1].Id;
                    
                    // Then instantiate a new Matcher object "MyMatcher"
                    Matcher MyMatcher = MyPattern.matcher(email);
                    //if email address  is not validated then give error message
                    if (!MyMatcher.matches()) {
                            ApexPages.addMessage(myMsg);
                    }else{
                            //if email address  is  valid then  send  email 
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses( new String []{email});
                                  
                            mail.setSaveAsActivity(false);
                            mail.setHtmlBody(msg);
                            mail.setUseSignature(false);
                            mail.setSubject('Nearby Service Provider or Distributor ');
                            if(OrgWideEmailAddressId != null)
                                mail.setOrgWideEmailAddressId(OrgWideEmailAddressId);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            ApexPages.Message updatedMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Email sent successfully.');
                            ApexPages.addMessage(updatedMsg);
                            
                            if(isLaunchedFromCaseAction && ApexPages.currentPage().getParameters().get('caseId') != null) {
                                
                                    String strRepalceOBoldChar = msg.replaceAll( '<b>', ' ');
                                    String strRepalceClBoldChar = strRepalceOBoldChar.replaceAll( '</b>', ' ');
                                    String strReplaceDblLineBreak = strRepalceClBoldChar.replaceAll('<br/><br/>', '\n');
                                    String strFinalMsg = strReplaceDblLineBreak.replaceAll( '<br/>', '\n');

                                    Task objTask = new Task(WhatId = ApexPages.currentPage().getParameters().get('caseId'), Subject = 'Email', Priority = 'Normal', Status = 'Not Started', Description = strFinalMsg, ActivityDate = date.today());    
                                    insert objTask;
                            }   
                        }
                    
                }else{
                        //If email address is  not valid then give error message
                        ApexPages.addMessage(myMsg);
                    }
                
            }else{
                    //if no service provider is selected  then user press email  button then give error message on VF page
                    ApexPages.Message selectMsg = new ApexPages.Message(ApexPages.Severity.warning,'Please select atleast one Service Provider/Distributor.');
                    ApexPages.addMessage(selectMsg);
            }
            return null;
    }
    
    public void showSelectedAccout(){
         
    }
    /**
    * This method  is used when user what to update the case action based on service provider selected
    **/
    public void updateCase(){
        
        integer counter=0;
        Case_Action__c caseActionObj = new Case_Action__c(id=caseActionId);
        
        //if distributor is selected  then give error message on the  screen
        if(selectProviderType=='Distributor'){
            ApexPages.Message distriMsg = new ApexPages.Message(ApexPages.Severity.warning,'Case Action can be updated with Service Provider only.');
            ApexPages.addMessage(distriMsg);
        }else{
            //if seach has return the account and search is based  on service  provider then
            if(accDistanceList!=null && accDistanceList.size() > 0){
                
                for(AccountDistanceData obj:accDistanceList){
                    //if checked box is checked then  set the account id
                    if(obj.selectAccount && counter==0){
                        caseActionObj.Service_Provider_1__c=obj.accutObj.id;
                        counter++;
                    }else if(obj.selectAccount && counter==1){
                        caseActionObj.Service_Provider_2__c=obj.accutObj.id;
                        counter++;
                    }else if(obj.selectAccount && counter==2){
                        caseActionObj.Service_Provider_3__c=obj.accutObj.id;
                        counter++;
                    }
                     
                }
                //update the case  action list and show the success message
                if(accDistanceList!=null){
                    update caseActionObj;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Case Action updated successfully.');
                    ApexPages.addMessage(myMsg);
                }
            }else{
                //if not service  provider is  selected then show the error message on screen
                    ApexPages.Message selectMsg = new ApexPages.Message(ApexPages.Severity.warning,'Please select atleast one Service Provider/Distributor.');
                    ApexPages.addMessage(selectMsg);
            }
        }
        
    }
    /**
    * Wrapper class to  hold the Account , distance, duration values 
    **/
    public class AccountDistanceData {
        //Account object
        public Account accutObj {get;set;}
        //Hold the  distance  value
        public String distance {get;set;}
        //Hold the distance  value
        public Double distanceValue {get;set;}
        //Hold the  duration value 
        public String duration {get;set;}
        //Hold the address
        public String address {get;set;}
        //Hold the value true if check box is  selected
        public Boolean selectAccount {get;set;}
        //Get URL for account record
        public String accutObjUrl{
            get{
                return URL.getSalesforceBaseUrl().toExternalForm() + '/' + accutObj.Id;
            }
            set;
        }
        
    }
    /**
    * The method is use  to sort the list based on shortest distance
    **/
    public static List<AccountDistanceData> LinearSortList(List<AccountDistanceData> addList,String resultTot){
        
        List<AccountDistanceData> accDisList = new List<AccountDistanceData>(); 
        AccountDistanceData obji,objj;
        //outer loop for the list
        for (integer i = 0; i < addList.size() - 1; i++){
        // inner loop for the list
            for (integer j = i + 1; j < addList.size(); j++){
                //if (comparer.Compare(addList[i], addList[j]) > 0)
                obji=addList.get(i);
                objj=addList.get(j);
                if(obji.distanceValue > objj.distanceValue){
                    AccountDistanceData temp = addList[i];
                    addList[i] = addList[j];
                    addList[j] = temp;
                }
            }
      }
          
         if(addList!=null && addList.size() >0){
            
            for(integer i=0;i< Integer.valueOf(resultTot);i++){
                if(addList.size() > i){
                
                    accDisList.add(addList[i]);
                }
            }
         }
        return accDisList;
    }
}