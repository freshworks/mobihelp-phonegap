//
//  MobihelpPlugin.m
//  FreshdeskSDK
//
//  Copyright (c) 2014 Freshdesk. All rights reserved.
//

#import <Cordova/CDV.h>

#import "MobihelpPlugin.h"
#import "Mobihelp.h"




//Implementation for the mobihelp iOS Plugin
@implementation MobihelpPlugin:CDVPlugin




//Utility methods
-(void) callbackToJavascriptWithResult:(CDVPluginResult*)result ForCommand:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

-(void) callbackToJavascriptWithoutResultForCommand :(CDVInvokedUrlCommand*)command {
    CDVPluginResult* emptyResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self callbackToJavascriptWithResult:emptyResult ForCommand:command];
}
-(void) callbackToJavascriptWithException :(NSException*)e ForCommand:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[e name]];
    [self callbackToJavascriptWithResult:result ForCommand:command];
}

-(void) logToDevice:(CDVInvokedUrlCommand*) command {
    NSArray* arguments = [command arguments];
    id toLog = [arguments objectAtIndex:0];
    NSLog(@"%@",toLog);
}
-(NSInteger)mapWithEnum :(NSString*)str {
    if ([str isEqualToString:@"FEEDBACK_TYPE_ANONYMOUS"]) {
        return FEEDBACK_TYPE_ANONYMOUS;
    } else if ([str isEqualToString:@"FEEDBACK_TYPE_NAME_AND_EMAIL_REQUIRED"]) {
        return FEEDBACK_TYPE_NAME_AND_EMAIL_REQUIRED;
    } else if ([str isEqualToString:@"FEEDBACK_TYPE_NAME_REQUIRED_AND_EMAIL_OPTIONAL"]) {
        return FEEDBACK_TYPE_NAME_REQUIRED_AND_EMAIL_OPTIONAL;
    } else {
        return -1;
    }
}




//Mobihelp methods
-(void)init :(CDVInvokedUrlCommand*)command {
    NSArray* arguments = [command arguments];
    NSDictionary* initParams = [arguments objectAtIndex:0];
    
    
    //Parse input
    NSString* domain = [initParams objectForKey:@"domain"];
    NSString* appKey = [initParams objectForKey:@"appKey"];
    NSString* appSecret = [initParams objectForKey:@"appSecret"];
    
    BOOL autoReplyEnabled = [[initParams objectForKey:@"autoReplyEnabled"] boolValue];
    BOOL enhancedPrivacyModeEnabled = [[initParams objectForKey:@"enhancedPrivacyModeEnabled"] boolValue];
    BOOL prefetchSolutions = [[initParams objectForKey:@"prefetchSolutions"] boolValue];
    NSString* feedbackType = [initParams objectForKey:@"feedbackType"];
    NSString* iosAppStoreId = [initParams objectForKey:@"iosAppStoreId"];
    NSString* iosThemeName = [initParams objectForKey:@"iosThemeName"];
    int launchCountForReviewPrompt = (int)[initParams objectForKey:@"launchCountForReviewPrompt"];

    
    //initialize
    MobihelpConfig *config = [[MobihelpConfig alloc] initWithDomain:domain withAppKey:appKey andAppSecret:appSecret];
    [[Mobihelp sharedInstance] initWithConfig:config];
    
    
    //config
    if(autoReplyEnabled) [config setEnableAutoReply:(BOOL)autoReplyEnabled];
    if(enhancedPrivacyModeEnabled) [config setEnableEnhancedPrivacy:(BOOL)enhancedPrivacyModeEnabled];
    if(prefetchSolutions) [config setPrefetchSolutions:(BOOL)prefetchSolutions];
    [config setFeedbackType: [self mapWithEnum:feedbackType]];
    [config setAppStoreId:iosAppStoreId];
    [config setThemeName:iosThemeName];
    [config setLaunchCountForAppReviewPrompt:launchCountForReviewPrompt];
}
-(void) addCustomData:(CDVInvokedUrlCommand*) command {
    NSArray* arguments = [command arguments];
    
    
    @try {
        
        
        if([arguments count]<1)
            [NSException raise: @"KeyNotFound" format:@"Key not provided for Custom Data"];
        if([arguments count]<2)
            [NSException raise: @"ValueNotFound" format:@"Value not provided for Custom Data"];
        
        NSString* key = [arguments objectAtIndex:0];
        NSString* value = [arguments objectAtIndex:1];
        bool sensitivity;
        if([arguments count]<3)
            sensitivity = false;
        else
            sensitivity = [[arguments objectAtIndex:2] boolValue];
        
        [[Mobihelp sharedInstance] addCustomDataForKey:key withValue:value andSensitivity:sensitivity];
        [self callbackToJavascriptWithoutResultForCommand:command];
    }
    @catch(NSException* e) {
        [self callbackToJavascriptWithException:e ForCommand:command];
    }
}
-(void) clearBreadCrumbs :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] clearBreadcrumbs];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) clearCustomData :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] clearCustomData];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) clearUserData :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] clearUserData];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) getUnreadCount :(CDVInvokedUrlCommand*)command {
    NSInteger unreadCount = [[Mobihelp sharedInstance] unreadCount];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)unreadCount];
    [self callbackToJavascriptWithResult:result ForCommand:command];
}
-(void) getUnreadCountAsync :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] unreadCountWithCompletion:^(NSInteger unreadCount) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:(int)unreadCount];
        [self callbackToJavascriptWithResult:result ForCommand:command];
    }];
}
-(void) leaveBreadCrumb :(CDVInvokedUrlCommand*)command {
    @try {
        NSString* crumbDetails = [command argumentAtIndex:0];
        [[Mobihelp sharedInstance] leaveBreadcrumb:crumbDetails];
        [self callbackToJavascriptWithoutResultForCommand:command];
    }
    @catch(NSException* e) {
        [self callbackToJavascriptWithException:e ForCommand:command];
    }
}
-(void) setUserEmail :(CDVInvokedUrlCommand*)command {
    @try {
        NSString* emailAddress = [command argumentAtIndex:0];
        [[Mobihelp sharedInstance] setEmailAddress:emailAddress];
        [self callbackToJavascriptWithoutResultForCommand:command];
    }
    @catch (NSException* e) {
        [self callbackToJavascriptWithException:e ForCommand:command];
    }
    
}
-(void) setUserFullName :(CDVInvokedUrlCommand*)command {
    @try {
        NSString* username = [command argumentAtIndex:0];
        [[Mobihelp sharedInstance] setUserName:username];
        [self callbackToJavascriptWithoutResultForCommand:command];
    }
    @catch (NSException* e) {
        [self callbackToJavascriptWithException :e ForCommand:command];
    }
}
-(void) showAppRateDialog :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] launchAppReviewRequest];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) showConversations :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] presentInbox:[self viewController]];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) showFeedback :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] presentFeedback:[self viewController]];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) showSolutions :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] presentSolutions:[self viewController]];
    [self callbackToJavascriptWithoutResultForCommand:command];
}
-(void) showSupport :(CDVInvokedUrlCommand*)command {
    [[Mobihelp sharedInstance] presentSupport:[self viewController]];
    [self callbackToJavascriptWithoutResultForCommand:command];
}




@end





