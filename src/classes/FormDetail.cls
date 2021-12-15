/**
* @author Kevin Winn
* @description contains methods to parse the formDetails event from the GTM data layer
*/ 
public class FormDetail
{
	public Integer contactFormId {get;set;} 
	public String pluginVersion {get;set;} 
	public String contactFormLocale {get;set;} 
	public String unitTag {get;set;} 
	public Integer containerPostId {get;set;} 
	public String status {get;set;} 
	public List<FormInput> inputs {get;set;} 
	public FormApiResponse apiResponse {get;set;} 
	public FormDetail(JSONParser parser)
	{
		while (parser.nextToken() != System.JSONToken.END_OBJECT) 
		{
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
			{
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
				{
					if (text == 'contactFormId' || text == 'contact_form_id') 
					{
						contactFormId = parser.getIntegerValue();
					} 
					else if (text == 'pluginVersion') 
					{
						pluginVersion = parser.getText();
					} 
					else if (text == 'contactFormLocale') 
					{
						contactFormLocale = parser.getText();
					} 
					else if (text == 'unitTag') 
					{
						unitTag = parser.getText();
					} 
					else if (text == 'containerPostId') 
					{
						containerPostId = parser.getIntegerValue();
					} 
					else if (text == 'status') 
					{
						status = parser.getText();
					} 
					else if (text == 'inputs') 
					{
						inputs = parseFormInputs(parser);
					} 
					else if (text == 'apiResponse') 
					{
						apiResponse = new FormApiResponse(parser);
					} 
					else 
					{
						System.debug(LoggingLevel.WARN, 'FormDetail consuming unrecognized property: '+text);
						ConsumeObject.consume(parser);
					}
				}
			}
		}
	}


	/**
	* @author Kevin Winn
	* @description inner class to parse the inputs from a form
	*/ 
	public class FormInput
	{
		public string name { get; set;}
		public String value {get;set;} 
		public FormInput(JSONParser parser)
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if(text == 'name')
						{
							name = parser.getText();
						}
						else if(text == 'value')
						{
							value = parser.getText();
						}else{
							break;
						}
					}
				}
			}
		}
	}

	/**
	* @author Kevin WInn
	* @description inner class to parse the apiResponse object from the form details object
	*/ 
	public class FormApiResponse
	{
		public Integer contactFormId {get;set;} 
		public String status {get;set;} 
		public String message {get;set;} 
		public String postedDataHash {get;set;} 
		public String into_x {get;set;} 
		public List<InvalidField> invalidFields {get;set;} 
		public FormApiResponse(JSONParser parser)
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'contact_form_id') 
						{
							contactFormId = parser.getIntegerValue();
						} 
						else if (text == 'status') 
						{
							status = parser.getText();
						} 
						else if (text == 'message') {
							message = parser.getText();
						} 
						else if (text == 'posted_data_hash') {
							postedDataHash = parser.getText();
						} 
						else if (text == 'into') {
							into_x = parser.getText();
						} 
						else if (text == 'invalid_fields') {
							invalidFields = parseInvalidFields(parser);
						} 
						else 
						{
							System.debug(LoggingLevel.WARN, 'ApiResponse consuming unrecognized property: '+text);
							ConsumeObject.consume(parser);
						}
					}
				}
			}
		}
	}

	/**
	* @author Kevin Winn
	* @description inner class to parse invalid fields from the formDetail object
	*/ 
	public class InvalidField
	{
		public String into_x {get;set;}
		public String message {get;set;} 
		public String idref {get;set;} 
		public String errorId {get;set;} 
		public InvalidField(JSONParser parser)
		{
			while (parser.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) 
					{
						if (text == 'into') 
						{
							into_x = parser.getText();
						} 
						else if (text == 'message') 
						{
							message = parser.getText();
						} 
						else if (text == 'idref') {
							idref = null != String.valueOf(parser.readValueAs(Object.class)) ? String.valueOf(parser.readValueAs(Object.class)) : '';
						} else if (text == 'error_id') 
						{
							errorId = parser.getText();
						} 
						else 
						{
							System.debug(LoggingLevel.WARN, 'InvalidField consuming unrecognized property: '+text);
							ConsumeObject.consume(parser);
						}
					}
				}
			}
		}
	}

	/**
	* @description static method to create an instance of FormDetail
	* @param p System.JSONParser the parser containing the form details from the data layer
	* @return FormDetail
	*/ 
	public static FormDetail parse(System.JSONParser p)
	{
		List<FormDetail> results = new List<FormDetail>();
		if(p.getCurrentToken() == null){ p.nextToken();}
		while(p.nextToken() != System.JSONToken.END_ARRAY && results.size() < 1)
		{
			while(p.nextToken() != System.JSONToken.END_OBJECT) 
			{
				if (p.getCurrentToken() == System.JSONToken.FIELD_NAME) 
				{
					String text = p.getText();
					if(text != 'details')
					{	
						break;
					} 
					else
					{
						results.add(new FormDetail(p));
						break;
					}
						
				}			
			}
		}
		return results[0];
	}

	/**
	* @description helper method to create an array of FormInput 
	* @param p System.JSONParser the parser containing the form inputs
	* @return List<FormInput>
	*/ 
	private static List<FormInput> parseFormInputs(System.JSONParser p)
	{
		List<FormInput> results = new List<FormInput>();
		if(p.getCurrentToken() == null){ p.nextToken(); }
		while (p.nextToken() != System.JSONToken.END_ARRAY)
		{
			results.add(new FormInput(p));
		}
		return results;
	}

	/**
	* @description helper method to create an arra of InvalidField
	* @param p System.JSONParser the parser containing the invalid fields
	* @return List<InvalidField>
	*/ 
	private static List<InvalidField> parseInvalidFields(System.JSONParser p)
	{
		List<InvalidField> results = new List<InvalidField>();
		if(p.getCurrentToken() == null){ p.nextToken();}
		while(p.nextToken() != System.JSONToken.END_ARRAY)
		{
			results.add(new InvalidField(p));
		}
		return results;
	}
}