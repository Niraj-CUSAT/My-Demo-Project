/*************************************************************************************************
    Created by    :    Bhanu Vallabhu, KVP Business Solutions
    Created On    :    22 Feb 2013
    Modified by   :    
    Modified on   :
    Description   :    This class redirects to VF page - 'CaseEditNew' for Case Creation for AOS India Recordtype 
                       else to the standard new page
**************************************************************************************************/


public with sharing class caseRedirect {

private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String confirmationToken {get; set;}
public String accountID {get; set;}
public String contactID {get; set;}
public ID rectypeID;
public ID rectypeID2;
public String Assetid{get; set;}
public string familyid{get; set;}

public caseRedirect(ApexPages.StandardController controller) {

    this.controller = controller;

    retURL = ApexPages.currentPage().getParameters().get('retURL');
    rType = ApexPages.currentPage().getParameters().get('RecordType');
    rectypeID = [Select id,name from recordtype where  DeveloperName =:'AOSIndia' and SobjectType =:'Case' limit 1].id;
    rectypeID2 = [Select id,name from recordtype where  DeveloperName =:'AOSI' and SobjectType =:'Case' limit 1].id;
    cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
    ent = ApexPages.currentPage().getParameters().get('ent');
    confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
    saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
    accountID = ApexPages.currentPage().getParameters().get('def_account_id');
    contactID = ApexPages.currentPage().getParameters().get('def_contact_id');
    Assetid = ApexPages.currentPage().getParameters().get('def_asset_id');
    familyid = ApexPages.currentPage().getParameters().get('00N40000002LNA9');
}

public PageReference redirect() {

    PageReference returnURL;

    // Redirect if Record Type corresponds to custom VisualForce page

    IF(rType == rectypeID || rType == rectypeID2) {

        returnURL = new PageReference('/apex/CaseEditNew');

    }

    ELSE {

        returnURL = new PageReference('/500/e');

    }

    returnURL.getParameters().put('retURL', retURL);
    returnURL.getParameters().put('RecordType', rType);
    returnURL.getParameters().put('cancelURL', cancelURL);
    returnURL.getParameters().put('ent', ent);
    returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
    returnURL.getParameters().put('save_new_url', saveNewURL);
    returnURL.getParameters().put('nooverride', '1');

    IF (accountID != null){

        returnURL.getParameters().put('def_account_id', accountID);

    }

    IF (contactID != null){

        returnURL.getParameters().put('def_contact_id', contactID);

    }
    IF (Assetid  !=Null){

        returnURL.getParameters().put('def_asset_id', Assetid);

    }
     
    returnURL.setRedirect(true);
    return returnURL;

}

}