/**
* @author Kevin Winn
* @description Aura Controller for Google Tag Manager integration
*/ 
public with sharing class GoogleTagManagerController  
{
	/**
	* @description Creates a GoogleTagManager__c record from the window.dataLayer object
	* @param dataLayer The raw window.dataLayer object
	*/
	@AuraEnabled
	public static GoogleTagManager__c postDataLayer(String dataLayer)
	{
		System.debug(LoggingLevel.INFO,UserInfo.getUserName());
		GoogleTagManager__c gtm = new GoogleTagManager__c(DataLayer__c = cleanString(dataLayer));
		gtm = GoogleTagManager.parse((List<Object>) JSON.deserializeUntyped(cleanString(dataLayer)),gtm);
		try
		{
			Database.insert(gtm,true);
		}
		catch(Exception ex)
        {
            throw new AuraHandledException('Something went wrong...' + '\n' + 
                                            'Message: ' + ex.getMessage() + '\n' + 
                                            'Type: ' + ex.getTypeName() + '\n' +
                                            'Cause: ' + ex.getCause() + '\n' + 
                                            'Trace: ' + ex.getStackTraceString());
        }
		return gtm;
	}

	/**
	* @description escapes single quotes, ecma scripts, html, java, unicode, and xml that may be in data layer
	* @param dataLayer The raw window.dataLayer object
	* @return String
	*/ 
	private static String cleanString(String dataLayer)
	{
		String clean = String.escapeSingleQuotes(dataLayer);
		clean.escapeEcmaScript();
		clean.escapeHtml3();
		clean.escapeHtml4();
		clean.escapeJava();
		clean.escapeUnicode();
		clean.escapeXml();
		return clean;
	}
}