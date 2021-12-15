/**
* @author Kevin Winn
* @description handles the data layer submitted through lightning out apps for all events
*/ 
public with sharing class GoogleTagManager  
{
	/**
	* @description main method for parsing data layer.  Looks for known events and measurements fields
	*				and assigns values to the new GoogleTagManager__r record being prepared
	* @param objectList The untyped, deserialized object list that represents the data layer
	* @param gtm The GoogleTagManager__r record to assign values to
	* @return GoogleTagManager__c
	*/ 
	public static GoogleTagManager__c parse(List<Object> objectList,GoogleTagManager__c gtm)
	{
		for(Object obj : objectList)
		{
			Map<String,Object> objMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(obj));
			for(String s : objMap.keySet())
			{
				if(s == 'pageViewDetail')
				{
					PageViewDetail dt = PageViewDetail.parse(createJsonParser(objMap.get(s)));
					gtm = assignPageViewDetails(dt,gtm);
					objMap.remove(s);
					gtm.Event__c = 'Page View';
				}
				else if(s == 'formDetail')
				{	
					FormDetail dt = FormDetail.parse(createJsonParser(objMap.get(s)));
					gtm = assignFormDetails(dt,gtm);
					objMap.remove(s);
					gtm.Event__c = 'Contact Form Submit';
				}
				else
				{
					Map<String,Object> temp = new Map<String,Object>{s => objMap.get(s)};
					gtm = assignPluginDetails(temp,gtm);
					temp.clear();
					objMap.remove(s);
				}
			}
		}
		return gtm;
	}

	/**
	* @description Assigns deserialized PageViewDetail apex object to GoogleTagManager__c record
	* @param detail an instance of the PageViewDetail class
	* @param gtm the GoogleTagManager__c record to assign values to
	* @return GoogleTagManager__c
	*/ 
	private static GoogleTagManager__c assignPageViewDetails(PageViewDetail detail,GoogleTagManager__c gtm)
	{
		if(null != detail.pageLocation)
		{
			gtm = assignLocationDetails(detail.pageLocation,gtm);
		}
		if(null != detail.cookies && detail.cookies.size() > 0)
		{
			gtm = assignCookieDetails(detail.cookies,gtm);
		}
		gtm.CharacterSet__c = detail.characterSet;
		gtm.ContentType__c = detail.contentType;
		gtm.Referrer__c = detail.referrer;
		gtm.TrackerApiVersion__c = detail.t_apiVersion;
		gtm.TrackerClientId__c = detail.t_clientId;
		gtm.GtmDeviceId__c = detail.t_clientId.substringBefore('.');
		gtm.TrackerClientVersion__c = detail.t_clientVersion;
		gtm.TrackerCookieDomain__c = detail.t_cookieDomain;
		gtm.TrackerGbraid__c = detail.t_gbraid;
		gtm.TrackerGbt__c = detail.t_gbt;
		gtm.TrackerGclid__c = detail.t_gclid;
		gtm.TrackerGclsrc__c = detail.t_gclsrc;
		gtm.TrackerGcn__c = detail.t_gcn;
		gtm.TrackerGid__c = detail.t_gid;
		gtm.TrackerGt__c = String.valueOf(detail.t_gt);
		gtm.TrackerJavaEnabled__c = detail.t_javaEnabled;
		gtm.TrackerLanguage__c = detail.t_language;
		gtm.TrackerName__c = detail.t_name;
		gtm.TrackerScreenColors__c = detail.t_screenColors;
		gtm.TrackerScreenResolution__c = detail.t_screenResolution;
		gtm.TrackerStoredClientId__c = detail.t_storedClientId;
		gtm.TrackerTrackingId__c = detail.t_trackingId;
		gtm.TrackerViewportSize__c = detail.t_viewportSize;
		gtm.Title__c = detail.title;
		gtm.URI__c = detail.uri;
		gtm.URL__c = detail.url_x;
		return gtm;
	}

	/**
	* @description helper method for assigning page view details.  Takes in instance of the Location Apex object
	*				and assigns values to the GoogleTagManager__c record.
	* @param detail the Location Apex object defined in the PageViewDetail object
	* @param gtm The GoogleTagManager__c record to assign values to
	* @return GoogleTagManager__c
	*/ 
	private static GoogleTagManager__c assignLocationDetails(Location detail,GoogleTagManager__c gtm)
	{
		gtm.AncestorOrigins__c = null != detail.ancestorOrigins ? JSON.serialize(detail.ancestorOrigins) : null;
		gtm.Hash__c = null != detail.hash ? detail.hash : null;
		gtm.Host__c = detail.host;
		gtm.HostName__c = detail.hostname;
		gtm.Href__c = detail.href;
		gtm.Origin__c = detail.origin;
		gtm.PathName__c = detail.pathname;
		gtm.Port__c = detail.port;
		gtm.Protocol__c = detail.protocol;
		gtm.Search__c = detail.search_x;
		return gtm;
	}

	/**
	* @description helper method to populate Cookies field on GoogleTagManager__c record
	* @param cookies An array of Cooky instances extracted from the PageViewDetail Apex object
	* @param gtm The GoogleTagManager__c record to assign cookie values to
	* @return GoogleTagManager__c
	*/ 
	private static GoogleTagManager__c assignCookieDetails(List<Cooky> cookies,GoogleTagManager__c gtm)
	{
		String results = '';
		String carriageReturn = '\r\n';
		for(Cooky c : cookies)
		{
			results += String.valueOf('Name: ' + c.name + ' | Value: ' + c.value + carriageReturn);
		}
		gtm.cookies__c = results;
		return gtm;
	}

	/**
	* @description Helper method to populate all form fields on the GoogleTagManager__c record.
					called when the event is a form submit event.
	* @param detail The FormDetail Apex object
	* @param gtm The GoogleTagManager__c record to populate with details from the form
	* @return GoogleTagManager__c
	*/ 
	private static GoogleTagManager__c assignFormDetails(FormDetail detail,GoogleTagManager__c gtm)
	{
		gtm.FormResponseStatus__c = detail.apiResponse.status;
		gtm.FormPostedDataHash__c = detail.apiResponse.postedDataHash;
		gtm.FormResponseMessage__c = detail.apiResponse.message;
		gtm.FormInvalidFields__c = JSON.serialize(detail.apiResponse.invalidFields);
		gtm.FormInto__c = detail.apiResponse.into_x;
		gtm.FormContainerPostId__c = detail.containerPostId;
		gtm.FormContactFormLocale__c = detail.contactFormLocale;
		gtm.FormContactFormId__c = detail.contactFormId;
		gtm.FormUnitTag__c = detail.unitTag;
		gtm.FormStatus__c = detail.status;
		gtm.FormPluginVersion__c = detail.pluginVersion;
		gtm.FormInputs__c = defineFormInputs(detail.inputs);
		return gtm;
	}

	/**
	* @description helper method to build string for GoogleTagManager__c Form Inputs field
	* @param inputs an array of FormDetail.FormInput objects containing the field name and input value
	*		for each input on the form
	* @return String
	*/ 
	private static String defineFormInputs(List<FormDetail.FormInput> inputs)
	{
		string response = '';
		String carriageReturn = '\r\n';
		for(FormDetail.FormInput input : inputs)
		{
			response = response += (input.name + ' | ' + input.value) + carriageReturn;
		}
		return response;
	}

	/**
	* @description Method to assign plugin details from the Google Tag Manager for Wordpress plugin
	* @param objMap A map of keys and untypes objects from the datalayer
	* @param gtm The google tag manager record to populate with plugin details
	* @return GoogleTagManager__c
	*/ 
	private static GoogleTagManager__c assignPluginDetails(Map<String,Object> objMap, GoogleTagManager__c gtm)
	{
		for(String s : objMap.keySet())
		{
			if(s == POST_FORMAT)
			{
				gtm.PostFormat__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == POST_ID)
			{
				gtm.PostID__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == POST_COUNT_TOTAL)
			{
				gtm.PostCountTotal__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == POST_COUNT_ON_PAGE)
			{
				gtm.PostCountOnPage__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == POST_COUNT_ON_PAGE)
			{
				gtm.PostCountOnPage__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == DEVICE_MODEL)
			{
				gtm.DeviceModel__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == DEVICE_MANUFACTURER)
			{
				gtm.DeviceManufacturer__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == DEVICE_TYPE)
			{
				gtm.DeviceType__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == OS_VERSION)
			{
				gtm.OsVersion__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == OS_NAME)
			{
				gtm.OsName__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == BROWSER_ENGINE_NAME)
			{
				gtm.BrowserEngineName__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == BROWSER_ENGINE_VERSION)
			{
				gtm.BrowserEngineVersion__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == BROWSER_NAME)
			{
				gtm.BrowserName__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == BROWSER_VERSION)
			{
				gtm.BrowserVersion__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_TERMS)
			{
				gtm.PagePostTerms__c = JSON.serialize(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_DATE_DAY)
			{
				gtm.PagePostDateDay__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_DATE_MONTH)
			{
				gtm.PagePostDateMonth__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_DATE_YEAR)
			{
				gtm.PagePostDateYear__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_DATE)
			{
				gtm.PagePostDate__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_AUTHOR)
			{
				gtm.PagePostAuthor__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_AUTHOR_ID)
			{
				gtm.PagePostAuthorId__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_CATEGORY)
			{
				gtm.PageCategories__c = JSON.serialize(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_TYPE)
			{
				gtm.PagePostType__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_POST_TYPE_2)
			{
				gtm.PagePostType2__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == PAGE_TITLE)
			{
				gtm.PageTitle__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == VISITOR_ID)
			{
				gtm.VisitorId__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == VISITOR_USERNAME)
			{
				gtm.VisitorUsername__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == VISITOR_REGISTRATION_DATE)
			{
				gtm.VisitorRegistrationDateUnix__c = null != gtm.VisitorId__c ? Integer.valueOf(objMap.get(s)) : null;
				break;
			}
			else if(s == VISITOR_EMAIL)
			{
				gtm.VisitorEmail__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == VISITOR_TYPE)
			{
				gtm.VisitorType__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == VISITOR_LOGIN_STATE)
			{
				gtm.VisitorLoginState__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == SITE_NAME)
			{
				gtm.SiteName__c = String.valueOf(objMap.get(s));
				break;
			}
			else if(s == SITE_ID)
			{
				gtm.SiteId__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else if(s == VISITOR_DO_NOT_TRACK)
			{
				gtm.VisitorDoNotTrack__c = Integer.valueOf(objMap.get(s)) == 1 ? true : false;
				break;
			}
			else if(s == TIME_TO_SCROLL)
			{
				gtm.TimeToScroll__c = Integer.valueOf(objMap.get(s));
				break;
			}
			else{
				break;
			}
		}
		return gtm;
	}

	/**
	* @description helper method to create a JSON parser for an object
	* @param obj the unstructured object to serialize and create parser for
	* @return System.JSONParser
	*/ 
	private static System.JSONParser createJsonParser(Object obj)
	{
		String json = JSON.serialize(obj);
		return System.JSON.createParser(json);
	}

	private static final String POST_FORMAT = 'postFormat';
	private static final String POST_ID = 'postID';
	private static final String POST_COUNT_TOTAL = 'postCountTotal';
	private static final String POST_COUNT_ON_PAGE = 'postCountOnPage';
	private static final String DEVICE_MODEL = 'deviceModel';
	private static final String DEVICE_MANUFACTURER = 'deviceManufacturer';
	private static final String DEVICE_TYPE = 'deviceType';
	private static final String OS_VERSION = 'osVersion';
	private static final String OS_NAME = 'osName';
	private static final String BROWSER_ENGINE_VERSION = 'browserEngineVersion';
	private static final String BROWSER_ENGINE_NAME = 'browserEngineName';
	private static final String BROWSER_VERSION = 'browserVersion';
	private static final String BROWSER_NAME = 'browserName';
	private static final String PAGE_POST_TERMS = 'pagePostTerms';
	private static final String PAGE_POST_DATE_DAY = 'pagePostDateDay';
	private static final String PAGE_POST_DATE_MONTH = 'pagePostDateMonth';
	private static final String PAGE_POST_DATE_YEAR = 'pagePostDateYear';
	private static final String PAGE_POST_DATE = 'pagePostDate';
	private static final String PAGE_POST_AUTHOR = 'pagePostAuthor';
	private static final String PAGE_POST_AUTHOR_ID = 'pagePostAuthorID';
	private static final String PAGE_CATEGORY = 'pageCategory';
	private static final String PAGE_POST_TYPE = 'pagePostType';
	private static final String PAGE_POST_TYPE_2 = 'pagePostType2';
	private static final String PAGE_TITLE = 'pageTitle';
	private static final String VISITOR_ID = 'visitorId';
	private static final String VISITOR_USERNAME = 'visitorUsername';
	private static final String VISITOR_REGISTRATION_DATE = 'visitorRegistrationDate';
	private static final String VISITOR_EMAIL = 'visitorEmail';
	private static final String VISITOR_TYPE = 'visitorType';
	private static final String VISITOR_LOGIN_STATE = 'visitorLoginState';
	private static final String SITE_NAME = 'siteName';
	private static final String SITE_ID = 'siteID';
	private static final String VISITOR_DO_NOT_TRACK = 'visitorDoNotTrack';
	private static final String TIME_TO_SCROLL = 'timeToScroll';

}