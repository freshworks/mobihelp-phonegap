# Mobihelp Plugin for Phonegap

This plugin integrates Freshdesk's SDK (Mobihelp) into a Phonegap/Cordova project. 
For platform specific details please refer to the [Developer Documentation](http://developer.freshdesk.com/mobihelp/)

Platforms supported :
* Android
* iOS

### Integrating the Plugin : 

1. Add required platforms to your phonegap project 
```
phonegap platform add android
phonegap platform add ios
```

2. Add the mobihelp plugin to your project.
```
phonegap plugin add https://github.com/freshdesk/mobihelp-phonegap.git
```


### Initializing the plugin

_Mobihelp.init_ needs to be called from _ondeviceready_ event listenter to make sure the SDK is initialized before use.

```javascript
document.addEventListener("deviceready", function(){
    //Initialize Mobihelp
     window.Mobihelp.init({
        appKey      : "sample-1-21aa74fbb63313e3bde3d48eb57a6d9e",
        appSecret   : "your_app_secret",
        domain      : "yourdomain.freshdesk.com"
    });
});
 ```
 
 The following optional parameters can be passed to the init Object 
 -  androidAppStoreUrl
 -  autoReplyEnabled ( default : false ) 
 -  enhancedPrivacyModeEnabled ( default : false ) 
 -  feedbackType ( default : window.Mobihelp.FeedbackTypes.NAME_AND_EMAIL_REQUIRED )
 -  iosAppStoreId
 -  iosThemeName ( default : window.Mobihelp.iosThemeNames.FDLightTheme )
 -  launchCountForReviewPrompt ( default : 0 )
 -  prefetchSolutions ( default : true )
 
 Once initialized you can call mobihelp APIs using the window.Mobihelp object. 
 
 ```javascript 
//After initializing mobihelp 
showSupport = function() { 
    window.Mobihelp.showSupport();
};
document.getElementById("launch_support").onclick = showSupport;


//in index.html
<button id="launch_support"> LaunchSupport </button>
 ```

### Mobihelp APIs
* Mobihelp.showSupport()
    - Launch Support page with Solutions and Conversations
* Mobihelp.showConversations()
    - Show Inbox of conversations
* Mobihelp.showFeedback()
    - Launch a feedback screen
* Mobihelp.showSolutions()
    - Launch only solutions
* Mobihelp.getUnreadCount(callback)
    - Fetch cached count of unread messages from agents. 
* Mobihelp.getUnreadCountAsync(callback)
    - Fetch count of unread messages from agents. 
* Mobihelp.setUserEmail(userEmail)
    - Update user email 
* Mobihelp.setUserFullName(userName)
    - Update user name
* Mobihelp.clearUserData()
    - Clear user data when users logs off your app. 
* Mobihelp.addCustomData(key,value[,isSensitive])
    - Add / Update Custom data value 
* Mobihelp.clearCustomData()
    - Clear all previously added Custom Data values
* Mobihelp.leaveBreadCrumb(breadCrumbStr)
    - Drop a breabcrumb for tracking application activity
* Mobihelp.clearBreadCrumbs()
    - Clear all previously collected breadcrumbs.

You can pass in a optional callback function to an API as the first parameter, which gets called when native API is completed. 
Eg. 
```javascript
window.Mobihelp.getUnreadCount(function(success,val) {
    //success indicates whether the API call was successful
    //val contains the no of unread messages
});
```

#### Caveats

##### Android : 
* Needs appcompat-v7 : 18+
* Needs support-v4 : 19+
* MinSdkVersion must be atleast 10 (in config.xml)

##### iOS
* Needs iOS 7 and above

