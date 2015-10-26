//
//  AppDynamicsAPI.h
//  HybridApp
//
//  Created by Steve Waterworth on 13/10/2015.
//
//

#import <Cordova/CDVPlugin.h>

@interface AppDynamicsAPI : CDVPlugin

- (void)reportMetricWithName:(CDVInvokedUrlCommand*)command;
- (void)leaveBreadcrumb:(CDVInvokedUrlCommand*)command;
- (void)setUserData:(CDVInvokedUrlCommand*)command;

- (void)startTimerWithName:(CDVInvokedUrlCommand*)command;
- (void)stopTimerWithName:(CDVInvokedUrlCommand*)command;

- (void)beginCall:(CDVInvokedUrlCommand*)command;
- (void)endCall:(CDVInvokedUrlCommand*)command;

- (void)beginHttpRequest:(CDVInvokedUrlCommand*)command;
- (void)reportDone:(CDVInvokedUrlCommand*)command;
- (void)getCorrelationHeaders:(CDVInvokedUrlCommand*)command;

@end
