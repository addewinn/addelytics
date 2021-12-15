/**
* @author Kevin Winn
* @description Class to define the Apex version of Location object.
*				see <a href="https://developer.mozilla.org/en-US/docs/Web/API/Location">MDN</a>
*/ 
public class Location 
{
	public AncestorOrigins ancestorOrigins {get;set;} 
	public String href {get;set;} 
	public String origin {get;set;} 
	public String protocol {get;set;} 
	public string host {get;set;} 
	public String hostname {get;set;} 
	public String port {get;set;} 
	public String pathname {get;set;} 
	public String search_x {get;set;} 
	public String hash {get;set;} 
	public Location(JSONParser parser)
	{
		while (parser.nextToken() != System.JSONToken.END_OBJECT) 
		{
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
			{
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
				{
					if (text == 'ancestorOrigins') 
					{
						ancestorOrigins = new AncestorOrigins(parser);
					} 
					else if (text == 'href') 
					{
						href = parser.getText();
					} 
					else if (text == 'origin') 
					{
						origin = parser.getText();
					} 
					else if (text == 'protocol') 
					{
						protocol = parser.getText();
					} 
					else if (text == 'host') 
					{
						host = parser.getText();
					} 
					else if (text == 'hostname') 
					{
						hostname = parser.getText();
					} 
					else if (text == 'port') 
					{
						port = parser.getText();
					} 
					else if (text == 'pathname') 
					{
						pathname = parser.getText();
					} 
					else if (text == 'search') 
					{
						search_x = parser.getText();
					} 
					else if (text == 'hash') {
						hash = parser.getText();
					} 
					else 
					{
						System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
						ConsumeObject.consume(parser);
					}
				}
			}
		}
	}

	/**
	* @description public static method to define an instance of Location
	* @param parser the JONParser that contains the Location data
	* @return Location
	*/ 
	public static Location parse(JSONParser parser)
	{
		return new Location(parser);
	}
}