/**
* @author Kevin Winn
* @description Class to assist with deserializing the pageViewDetail object from GTM
*/ 
public class PageViewDetail 
{
	public String uri {get;set;} 
	public Location pageLocation {get;set;} 
	public String referrer {get;set;} 
	public String title {get;set;} 
	public String url_x {get;set;} 
	public String contentType {get;set;} 
	public String characterSet {get;set;} 
	public String t_name {get;set;} 
	public String t_clientId {get;set;} 
	public String t_gbraid {get;set;} 
	public Integer t_gbt {get;set;} 
	public String t_gclid {get;set;} 
	public String t_gclsrc {get;set;} 
	public String t_gcn {get;set;} 
	public String t_gid {get;set;} 
	public Integer t_gt {get;set;} 
	public Integer t_apiVersion {get;set;} 
	public String t_clientVersion {get;set;} 
	public String t_cookieDomain {get;set;} 
	public Boolean t_javaEnabled {get;set;} 
	public String t_language {get;set;} 
	public String t_screenColors {get;set;} 
	public String t_screenResolution {get;set;} 
	public String t_storedClientId {get;set;} 
	public String t_trackingId {get;set;} 
	public String t_viewportSize {get;set;} 
	public List<Cooky> cookies {get;set;} 

	public PageViewDetail(JSONParser parser) 
	{
		while (parser.nextToken() != System.JSONToken.END_OBJECT) 
		{
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
			{
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
				{
					if (text == 'uri') 
					{
						uri = parser.getText();
					} 
					else if (text == 'location') 
					{
						pageLocation = Location.parse(parser);
					} 
					else if (text == 'referrer') 
					{
						referrer = parser.getText();
					} 
					else if (text == 'title') 
					{
						title = parser.getText();
					} 
					else if (text == 'url') 
					{
						url_x = parser.getText();
					} 
					else if (text == 'contentType') 
					{
						contentType = parser.getText();
					} 
					else if (text == 'characterSet') 
					{
						characterSet = parser.getText();
					} 
					else if (text == 't_name') 
					{
						t_name = parser.getText();
					} 
					else if (text == 't_clientId') 
					{
						t_clientId = parser.getText();
					} 
					else if (text == 't_gbraid') 
					{
						t_gbraid = parser.getText();
					} 
					else if (text == 't_gbt') 
					{
						t_gbt = parser.getIntegerValue();
					} 
					else if (text == 't_gclid') 
					{
						t_gclid = parser.getText();
					} 
					else if (text == 't_gclsrc') 
					{
						t_gclsrc = parser.getText();
					} 
					else if (text == 't_gcn') 
					{
						t_gcn = parser.getText();
					} 
					else if (text == 't_gid') 
					{
						t_gid = parser.getText();
					} 
					else if (text == 't_gt') 
					{
						t_gt = parser.getIntegerValue();
					} 
					else if (text == 't_apiVersion') 
					{
						t_apiVersion = parser.getIntegerValue();
					} 
					else if (text == 't_clientVersion') 
					{
						t_clientVersion = parser.getText();
					} 
					else if (text == 't_cookieDomain') 
					{
						t_cookieDomain = parser.getText();
					} 
					else if (text == 't_javaEnabled') 
					{
						t_javaEnabled = parser.getBooleanValue();
					} 
					else if (text == 't_language') 
					{
						t_language = parser.getText();
					} 
					else if (text == 't_screenColors') 
					{
						t_screenColors = parser.getText();
					} 
					else if (text == 't_screenResolution') 
					{
						t_screenResolution = parser.getText();
					} 
					else if (text == 't_storedClientId') 
					{
						t_storedClientId = parser.getText();
					} 
					else if (text == 't_trackingId') 
					{
						t_trackingId = parser.getText();
					} 
					else if (text == 't_viewportSize') 
					{
						t_viewportSize = parser.getText();
					} 
					else if (text == 'cookies') 
					{
						cookies = Cooky.parse(parser);
					} 
					else 
					{
						System.debug(LoggingLevel.WARN, 'PageViewDetail consuming unrecognized property: '+text);
						ConsumeObject.consume(parser);
					}
				}
			}
		}
	}

	/**
	* @description Static method to create in instance of PageViewDetail
	* @param p System.JSONParser the parser containing the page view details
	* @return PageViewDetail
	*/ 
	public static PageViewDetail parse(System.JSONParser p)
	{
		Integer counter = 0;
		List<PageViewDetail> results = new List<PageViewDetail>();
		if (p.getCurrentToken() == null) { p.nextToken(); }
        while (p.nextToken() != System.JSONToken.END_ARRAY && counter < 1) 
		{
            results.add(new PageViewDetail(p));
			counter = 1;
        }
		return results[0];
	}
}