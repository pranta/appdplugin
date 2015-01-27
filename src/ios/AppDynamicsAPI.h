#import <Cordova/CDV.h>

@interface AppDynamicsAPI : CDVPlugin

- (void)reportMetricWithName:(CDVInvokedUrlCommand*)command;

- (void)startTimerWithName:(CDVInvokedUrlCommand*)command;
- (void)stopTimerWithName:(CDVInvokedUrlCommand*)command;

- (void)beginCall:(CDVInvokedUrlCommand*)command;
- (void)endCall:(CDVInvokedUrlCommand*)command;

- (void)consoleLog:(CDVInvokedUrlCommand*)command;

@end
