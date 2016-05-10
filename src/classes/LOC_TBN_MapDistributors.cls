public with sharing class LOC_TBN_MapDistributors 
{
	/* Public get set variables and collection */
	public string googleMapstr{get;set;}
	public  string recId {get;set;}
	public static decimal currentLat{get;set;}
	public static decimal currentLong{get;set;}
	public  List<SelectOption> lstAccTypeOption {get;set;}
	public  List<SelectOption> lstRecordTypeOption {get;set;}
	public string  strAccType{get;set;}
	public boolean  hasLatLang{get;set;}
	public string  strRecordType{get;set;}
	public string strDistance{get;set;}
	public Account objAcc{get;set;}
	public string strAddressPhone{set;get;}
	
	public String strAccountName{get;set;}
	
	private static map<Id,decimal> mapAccIdToDist;
	private map<string,Id> mapRecTypeToId;
	
	public LOC_TBN_MapDistributors ()
	{
		googleMapstr='https://maps.googleapis.com/maps/api/js?v=3&sensor=false';
		recId = ApexPages.currentPage().getParameters().get('recId'); 
		hasLatLang = true;
		strAddressPhone = '';
		if(recId != null && recId != '')
    	{
    		objAcc = [Select Name,ShippingState,LOC_Longitude_x__c,LOC_Latitude_x__c, ShippingPostalCode,ShippingStreet,Phone, ShippingCountry, ShippingCity 
						From Account Where Id =:recId];
			currentLat = objAcc.LOC_Latitude_x__c;
			currentLong = objAcc.LOC_Longitude_x__c;
			
			strAccountName = String.escapeSingleQuotes(objAcc.Name);
			
			string accAddress ='';
			if (objAcc.ShippingStreet != null && objAcc.ShippingStreet != '')
				accAddress += objAcc.ShippingStreet +',';
            if (objAcc.ShippingCity != null  && objAcc.ShippingCity != '')
                accAddress += objAcc.ShippingCity +',';
            if (objAcc.ShippingState != null  && objAcc.ShippingState != '')
                accAddress += objAcc.ShippingState +',';
            if (objAcc.ShippingPostalCode != null  && objAcc.ShippingPostalCode != '')
                accAddress += objAcc.ShippingPostalCode +',';
            if (objAcc.ShippingCountry != null  && objAcc.ShippingCountry != '')
                accAddress += objAcc.ShippingCountry +',';
			
            if( accAddress.length() > 1 && accAddress.endsWith(','))
            {
            	accAddress = String.escapeSingleQuotes(accAddress);
            	accAddress = accAddress.substring(0,accAddress.length()-1);
            	
            }
            if(objAcc.Phone != null)	
            	accAddress += ' <br/> \' \n  +\' Phone: ' + objAcc.Phone ;
            strAddressPhone = accAddress;	
			if(currentLat == null && currentLong == null )
			{
				hasLatLang = false;
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Address could not be located . Update its lattitude and longitude field by clicking on "verify it" link '));
			}
    	}
    	else
    	{
    		hasLatLang = false;
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Valid ID in URL'));
    	}
    	
    	lstRecordTypeOption =  new list<SelectOption> ();
    	lstAccTypeOption = new List<SelectOption>();
		strRecordType = '';
		strAccType = '' ;
		strDistance ='';
		mapRecTypeToId = new  map<string,Id>();
		// Querying picklist value for Account Record type
		for(RecordType objRecordType : [select id, Name, SobjectType from RecordType where SobjectType = 'Account'  ])
		{
			mapRecTypeToId.put(objRecordType.Name,objRecordType.Id);
			lstRecordTypeOption.add(new SelectOption(objRecordType.Name,objRecordType.Name));
			If( strRecordType == '' )
				strRecordType = objRecordType.Name;
		}
		
		accountTypeSelectList();
	}
	//Method for calculating distance
	public static void   calculateDistance(decimal lat , decimal longt , list<Account> lstAccounts)
    {
    	mapAccIdToDist =  new map<Id,decimal>();
    	decimal R = 3958.7558657440545; // Radius of earth in Miles 
    	
    	for(Account acc: lstAccounts)
    	{
    		if( acc.LOC_Longitude_x__c != null &&  acc.LOC_Latitude_x__c != null )
    		{
			    decimal lat1 = lat;
		        decimal lat2 = acc.LOC_Latitude_x__c;
		        decimal lon1 = longt;
		        decimal lon2 = acc.LOC_Longitude_x__c;
	
		        decimal dLat = ((lat2-lat1)*22)/(180*7);
		        decimal dLon = ((lon2-lon1)*22)/(180*7);
		        lat1 = lat1*22/(180*7);
				lat2 = lat2*22/(180*7);
		        
		        decimal a = Math.sin(dLat/2) * Math.sin(dLat/2) +
		                Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
		        decimal c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
		                        
		        decimal milesdistance = R * c;
		        mapAccIdToDist.put(acc.Id ,milesdistance);
    		}
    	}
    	
    }
   
    //Method returning  distances
    public List<SelectOption> getDistances() 
    {
		list<SelectOption> lstDistance = new list<SelectOption>();
        lstDistance.add(new SelectOption('10', '10'));
        lstDistance.add(new SelectOption('25', '25'));
        lstDistance.add(new SelectOption('50', '50'));
        lstDistance.add(new SelectOption('100', '100'));
        lstDistance.add(new SelectOption('200', '200'));
		return lstDistance;
	}
    //Wrapper class to bind Account and its lattitude and longitude
	public class accLatLangWrapper   
    {
         public Id objAccId {get;set;}
         public String objName{get;set;}
         public Decimal lat {get;set;}
         public Decimal longt {get;set;}
         public String address{get;set;}
         public string strPhone{get;set;}
    } 
    
    //This remote method returns list of wrappper class
	@RemoteAction
    public static list<accLatLangWrapper> getAccountLocations(String recordId, string latitude,string longitude, String strDist,String accType , string accRecType)
    {
    	mapAccIdToDist =  new map<Id,decimal>();
    	list<accLatLangWrapper> lstWrapper =  new list<accLatLangWrapper>();
    	try
    	{
	    	list<Account> lstAccount = new list<Account>();
	    	String strQuery = '';
	    	
	    	// The below query is based on Billing Address.
	    	//strQuery ='Select Name, BillingState,Longitude_x__c,Latitude_x__c, BillingPostalCode,BillingStreet,' ;
	    	//strQuery += 'BillingCountry,Phone, BillingCity , RecordType.Name ,Type From Account where  Longitude_x__c != null and Latitude_x__c != null ';
	    	
	    	//As per the task- VIRSYGEN-18, requested to change ShippingAddress instead of BillingAddress.
	    	strQuery ='Select Name, ShippingState,LOC_Longitude_x__c,LOC_Latitude_x__c, ShippingPostalCode,ShippingStreet,' ;
	    	strQuery += 'ShippingCountry,Phone, ShippingCity , RecordType.Name ,Type From Account where  LOC_Longitude_x__c != null and LOC_Latitude_x__c != null ';
	    	
	    	if(accRecType != null && accRecType != '' )
	    		strQuery += ' and RecordType.Name = :accRecType ';
	    	
	    	if(accType!= null && accType != '' && accType != '--None--')
	    		strQuery += ' and Type like :accType ';
	    	
	    	strQuery += ' and Id != :recordId';	
	    	
	    	
			lstAccount= database.Query(strQuery);
			system.debug(lstAccount.size()+'***'+lstAccount);
			
			if(latitude != null && longitude != null && lstAccount.size() > 0 )
			{
		    	calculateDistance(decimal.valueOf(latitude),decimal.valueOf(longitude), lstAccount);
				
		        for(Account acc :lstAccount)
		        {
		        	if(mapAccIdToDist != null && mapAccIdToDist.size() > 0 && mapAccIdToDist.get(acc.Id) != null && mapAccIdToDist.get(acc.Id) <= Integer.valueOf(strDist ) )
		        	{
			        	accLatLangWrapper obj = new accLatLangWrapper();
			        	obj.lat =  acc.LOC_Latitude_x__c;
			        	obj.longt = acc.LOC_Longitude_x__c ;   
			        	obj.objAccId =   acc.Id; 
			        	obj.objName = String.escapeSingleQuotes(acc.Name);
			        	
			        	
			        	string accAddress ='';
						if (acc.ShippingStreet != null && acc.ShippingStreet != '')
							accAddress += acc.ShippingStreet +',';
			            if (acc.ShippingCity != null  && acc.ShippingCity != '')
			                accAddress += acc.ShippingCity +',';
			            if (acc.ShippingState != null  && acc.ShippingState != '')
			                accAddress += acc.ShippingState +',';
			            if (acc.ShippingPostalCode != null  && acc.ShippingPostalCode != '')
			                accAddress += acc.ShippingPostalCode +',';
			            if (acc.ShippingCountry != null  && acc.ShippingCountry != '')
			                accAddress += acc.ShippingCountry +',';
						
			            if( accAddress.length() > 1 && accAddress.endsWith(','))
			            {
			            	accAddress = String.escapeSingleQuotes(accAddress);
			            	accAddress = accAddress.substring(0,accAddress.length()-1);
			            }
	            		obj.address = accAddress; 
	            		if(acc.Phone != null)	
	            			obj.strPhone = ' Phone: ' + acc.Phone;
	            		else
	            			obj.strPhone = '';
			        	
			        	lstWrapper.add(obj);
		        	}
		        }
			}
			return lstWrapper;
    	}
    	catch(Exception e)
    	{
    		system.debug('Exception============'+e.getMessage());
    		return null;
    	}
    	 
    }
     //Returns list of select options for Zip Codes 
	public void accountTypeSelectList()
	{
		
		lstAccTypeOption = new List<SelectOption>();
		try
		{
			set<string> setSelectOptions = new set<string>();
			strAccType = '';
			
			if(mapRecTypeToId.get(strRecordType) != null)
			{
				list<string> listSelectOptions = LOC_TBN_PicklistDescriber.describe('Account',mapRecTypeToId.get(strRecordType), 'type');
				setSelectOptions.addAll(listSelectOptions);
				listSelectOptions = new list<string>();
				listSelectOptions.addAll(setSelectOptions);
				for(string str : listSelectOptions)
				{
					lstAccTypeOption.add(new SelectOption(str,str));
					system.debug('---lstAccTypeOption----'+lstAccTypeOption);
				}
				if(strAccType == '' )
				{
					strAccType = listSelectOptions[0];
					system.debug('---strAccType----'+strAccType);
				}
			}
			if(setSelectOptions.size() == 0 )
			{
				system.debug('-----size is zero----');
				lstAccTypeOption.add(new SelectOption('--None--','--None--'));
				strAccType = '--None--';
			}
		}
		catch(Exception e )
		{
			system.debug('Exception ==================='+e.getMessage());
		}
	}
    
    //Method called when clicking on "back" link
    public pageReference goBackToRecord()
    {
    	pagereference pr = new pagereference('/'+recId);
		return pr ;
    }
    @isTest()
	static void Test_TBN_MapDistributors()
	{
		test.startTest();
		
		RecordType objRecordType = [select id, Name, DeveloperName, SobjectType from RecordType where SobjectType='Account' AND Name=:'CSP' Limit 1];
		
		system.debug('=========='+objRecordType);
		
		Account objAccount = new Account();
		objAccount.Name = 'Test Account 1';
		objAccount.ShippingState = 'test';
		objAccount.ShippingCountry = 'test';
		objAccount.ShippingStreet ='test' ;
		objAccount.ShippingCity = 'test';
		objAccount.ShippingPostalCode = '678678';
		objAccount.RecordTypeId = objRecordType.Id;
		objAccount.Type = 'Test';
		insert objAccount;
		
		Account objAcc = new Account();
		objAcc.Name = 'Test Account 2';
		objAcc.ShippingState = 'Bangalore';
		objAcc.ShippingCountry = 'India';
		objAcc.RecordTypeId = objRecordType.Id;
		objAcc.ShippingState = 'test';
		objAcc.ShippingCountry = 'test';
		objAcc.ShippingStreet ='test' ;
		objAcc.ShippingCity = 'test';
		objAcc.ShippingPostalCode = '678678';
		objAcc.Type = 'Test';
		objAcc.LOC_Latitude_x__c = 12.9833;
		objAcc.LOC_Longitude_x__c = 77.5833;
		insert objAcc; 
		list<Account> lstAccount = new list<Account>();
		lstAccount.add(objAcc);
		
		ApexPages.currentPage().getParameters().put('recId',objAcc.Id);
		LOC_TBN_MapDistributors objMap = new LOC_TBN_MapDistributors(); 
		LOC_TBN_MapDistributors.getAccountLocations(objAccount.Id,'29.0167', '77.3833','5000','Test','Other');
		LOC_TBN_MapDistributors.calculateDistance(29.0167 , 77.3833 , lstAccount);
		objMap.getDistances();		
		
		ApexPages.currentPage().getParameters().put('recId','');
		LOC_TBN_MapDistributors objMap2 = new LOC_TBN_MapDistributors(); 
		
		ApexPages.currentPage().getParameters().put('recId',objAccount.Id);
		LOC_TBN_MapDistributors objMap3 = new LOC_TBN_MapDistributors(); 
		
		objMap.goBackToRecord();
		test.stopTest();
	}
}