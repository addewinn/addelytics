/**
* @author Kevin Winn
* @description Apex class used to parse Cookies in the data layer from GTM
*/ 
public class Cooky 
{
	public String name {get;set;} 
	public String value {get;set;} 
	public Cooky(JSONParser parser)
	{
		while (parser.nextToken() != System.JSONToken.END_OBJECT) 
		{
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
			{
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
				{
					if (text == 'name') 
					{
						name = parser.getText();
					} 
					else if (text == 'value') 
					{
						value = parser.getText();
					} 
					else 
					{
						System.debug(LoggingLevel.WARN, 'Cookies consuming unrecognized property: '+text);
						consumeObject.consume(parser);
					}
				}
			}
		}
	}

	/**
	* @description Static method to parse cookies and return an array of Cooky's
	* @param p System.JSONParser containing the cooky array from the data layer
	* @return List<Cooky> 
	*/ 
	public static List<Cooky> parse(System.JSONParser p)
	{	
		List<Cooky> results = new List<Cooky>();
		if(p.getCurrentToken() != null){ p.nextToken(); }
		while(p.nextToken() != System.JSONToken.END_ARRAY)
		{
			results.add(new Cooky(p));
		}
		return results;
	}
}