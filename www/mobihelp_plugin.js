//
//  mobihelp_plugin.js
//  FreshdeskSDK
//
//  Copyright (c) 2014 Freshdesk. All rights reserved.
//


// ------------------------------------------------------------------------------------
// --------------------------------UTILITY FUNCTIONS-----------------------------------
// ------------------------------------------------------------------------------------

//Function acceps a functioName as parameter and returns a closure which calls the native function of that name
//The first argument is ALWAYS the Class Name.
var createWrapperForNativeFunction = function(functionName)  {	
	return function() {	
		//arguments is an Arguments object. So we convert it to array for passing it to cordova.exec
		var argumentsArray = Array.prototype.slice.call(arguments || []); 
		var success,failure;

		// if user has provided callback
		//   remove callback from arguments and assign it to userCallback
		// else 
		//   have a dummy callback
		// set the callback function to be called on succes and failure			
		var userCallback;
		if (typeof argumentsArray[0] == 'function')
			userCallback = argumentsArray.splice(0,1)[0]; //remove first param and store it in userCallback
		else 
			userCallback = function() {}
		success = function(e) { userCallback(true,e);  }
		failure = function(e) { userCallback(false,e); }
				
		//Call corresponding native function
		return cordova.exec(success,failure,"MobihelpPlugin",functionName,argumentsArray);
	}
}


var createEnum = function(constants) {	
	var Enum = {};
	constants.forEach(function(constant) {
		Enum[constant] = constant;
	})
	return Enum;
}
// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------



var Mobihelp = {}	


//Add Wrapper functions to Mobihelp
var functionList = [
	"logToDevice",
	"addCustomData",
	"clearBreadCrumbs",
	"clearCustomData",
	"clearUserData",
	"getUnreadCount",
	"getUnreadCountAsync",
	"leaveBreadCrumb",
	"setUserEmail",
	"setUserFullName",
	"showAppRateDialog",
	"showConversations",
	"showFeedback",
	"showSolutions",
	"showSupport"
];
functionList.forEach(function(funcName) {
	Mobihelp[funcName] = createWrapperForNativeFunction(funcName);
});

//Init function is defined separately because it accepts parameters as an object as opposed to the other 
//functions which accept parameters as an array
Mobihelp.init = function(args) {	
	args = args || {};

	//Assign Default Values
	var configDefaults = {
		autoReplyEnabled 			: false,
		enhancedPrivacyModeEnabled 	: false,
		feedbackType 				: Mobihelp.FeedbackType.NAME_AND_EMAIL_REQUIRED,
		launchCountForReviewPrompt 	: 0,
		prefetchSolutions 			: true,

		//platform specific params
		androidAppStoreUrl 			: "",
		iosAppStoreId				: "",
		iosThemeName				: Mobihelp.iosThemeNames.FDLightTheme
	};
	for (k in configDefaults) 
		args[k] = args[k] || configDefaults[k];
	
	//Call Native function
	createWrapperForNativeFunction("init")(args);
}




//Enums
Mobihelp.FeedbackType = createEnum([
	"ANONYMOUS",
	"NAME_AND_EMAIL_REQUIRED",
	"NAME_REQUIRED"
]);
Mobihelp.MobihelpCallbackStatus = createEnum([
	"STATUS_INVALID_APP",
	"STATUS_NO_NETWORK_CONNECTION",
	"STATUS_NO_TICKETS_CREATED",
	"STATUS_SUCCESS",
	"STATUS_UNKNOWN"
]);
Mobihelp.iosThemeNames = createEnum([
	"FDLightTheme",
	"FDDarkTheme"
]);

module.exports = Mobihelp;
	