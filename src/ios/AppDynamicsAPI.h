#import <Cordova/CDV.h>

@interface AppDynamicsAPI : CDVPlugin

- (void)reportMetricWithName:(CDVInvokedUrlCommand*)command;

@end
