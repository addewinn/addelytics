({
	onInit: function (component,event,helper) {
		const cookiename = '__SFGTM';
		let dLayer = component.get('v.dataLayer');
		if(dLayer){
			let commitLayer = component.get('c.postDataLayer');
			commitLayer.setParams({
				dataLayer : JSON.stringify(dLayer)
			});
			commitLayer.setCallback(this,function(response){
			let state = response.getState();
			if(state === "SUCCESS" || state === "DRAFT"){
				console.log('data layer posted to Salesforce: ' + response.getState());
				let cooky = helper.getCookieValue(cookiename);
				if(cooky !== null){
					
				}else{
					helper.setCookieValue(cookiename,response.getReturnValue().Id);
				}
			} else if(state === "ERROR"){
				console.log(JSON.stringify(response.getError()));
			} else if(state === "INCOMPLETE"){
				console.log('Response incomplete.  Please try again.  If the issue persists please check your internet connection.');
			} else{
				console.log('An unknown error occurred: ' + response.getState());
			}
		});
		$A.enqueueAction(commitLayer);
		}
	},
	getCookieValue : function(cookiename){
		let name = cookiename;
		let result = document.cookie.match("(^|[^;]+)\\s*" + name + "\\s*=\\s*([^;]+)");
		return result;
	},
	setCookieValue : function(cookiename,gtmId){
		let name = cookiename + '=' + gtmId + '; path=/; ';
		let age = (60*60*24*365);
		let expires = 'max-age= ' + age + '; domain=dynotrader.online; SameSite=lax; Secure;';
		document.cookie = name + expires;
	}
})