/**
* @author The ancestorOrigins read-only property of the Location interface is a static DOMStringList containing, in reverse order, 
*			the origins of all ancestor browsing contexts of the document associated with the given Location object.
*			see <a href="https://developer.mozilla.org/en-US/docs/Web/API/Location/ancestorOrigins">MDN</a>
* @description 
*/ 
public class AncestorOrigins 
{
	public String value {get;set;} 
	public AncestorOrigins(JSONParser parser)
	{
		while (parser.nextToken() != System.JSONToken.END_OBJECT) 
		{
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
			{
				value = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
				{
					{
						System.debug(LoggingLevel.WARN, 'PagePostTerms consuming unrecognized property: '+parser.getText());
						ConsumeObject.consume(parser);
					}
				}
			}
		}
	}

	/**
	* @description static method to create an instance of AncestorOrigins
	* @param parser JSONParser containing the data
	* @return AncestorOrigins
	*/ 
	public static AncestorOrigins parse(JSONParser parser)
	{
		return new AncestorOrigins(parser);
	}
}