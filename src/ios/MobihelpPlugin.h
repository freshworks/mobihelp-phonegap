//
//  MobihelpPlugin.h
//  FreshdeskSDK
//
//  Copyright (c) 2014 Freshdesk. All rights reserved.
//

#import <Cordova/CDV.h>
#import "Mobihelp.h"

@interface MobihelpPlugin:CDVPlugin

-(void)init :(CDVInvokedUrlCommand*)command;

-(void)addCustomData:(CDVInvokedUrlCommand*)command;
-(void)clearBreadCrumbs:(CDVInvokedUrlCommand*)command;
-(void)clearCustomData:(CDVInvokedUrlCommand*)command;
-(void)clearUserData:(CDVInvokedUrlCommand*)command;

-(void)getUnreadCount:(CDVInvokedUrlCommand*)command;
-(void)getUnreadCountAsync:(CDVInvokedUrlCommand*)command;
-(void)leaveBreadCrumb:(CDVInvokedUrlCommand*)command;
-(void)setUserEmail:(CDVInvokedUrlCommand*)command;
-(void)setUserFullName:(CDVInvokedUrlCommand*)command;


-(void)showAppRateDialog:(CDVInvokedUrlCommand*)command;
-(void)showConversations:(CDVInvokedUrlCommand*)command;
-(void)showFeedback:(CDVInvokedUrlCommand*)command;
-(void)showSolutions:(CDVInvokedUrlCommand*)command;
-(void)showSupport:(CDVInvokedUrlCommand*)command;

@end