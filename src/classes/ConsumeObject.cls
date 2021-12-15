/**
* @author Kevin Winn
* @description contains method to consume parser when unknown keys are encountered.
*				used to reduce heap during processing.
*/ 
public class ConsumeObject  
{
	public ConsumeObject(System.JSONParser parser) 
	{
		Integer depth = 0;
		do 
		{
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || curr == System.JSONToken.START_ARRAY) 
			{
				depth++;
			} 
			else if (curr == System.JSONToken.END_OBJECT || curr == System.JSONToken.END_ARRAY) 
			{
				depth--;
			}
		} 
		while (depth > 0 && parser.nextToken() != null);
	}

	/**
	* @description static method to consume an instance of System.JSONParser
	* @param parser the parser to consume
	*/ 
	public static void consume(System.JSONParser parser)
	{
		new ConsumeObject(parser);
	}
}