({	
	doInit: function (component, event, helper) {
		helper.onInit(component,event,helper);
		console.log(
			'Thanks for visiting my site!' + '\n' +
			'This site demonstrates how to integrate Salesforce using Lightning Out' + '\n' +
			'Start with the article Lightning Out for a guided path on how to implement this on your own site'
		);
	}
})