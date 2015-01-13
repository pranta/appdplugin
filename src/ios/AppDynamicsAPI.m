#import "AppDynamicsAPI.h"
#import <Cordova/CDV.h>
#import <ADEUMInstrumentation/ADEUMInstrumentation.h>

@implementation AppDynamicsAPI

- (void)reportMetricWithName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* name = [command.arguments objectAtIndex:0];
	NSInteger value = [[command.arguments objectAtIndex:1] integerValue];
	
	if(name != nil && [name length] > 0) {
		[ADEumInstrumentation reportMetricWithName:name value:value];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startTimerWithName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* name = [command.arguments objectAtIndex:0];
	
	if(name != nil && [name length] > 0) {
		[ADEumInstrumentation startTimerWithName:name];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopTimerWithName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* name = [command.arguments objectAtIndex:0];
	
	if(name != nil && [name length] > 0) {
		[ADEumInstrumentation stopTimerWithName:name];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)consoleLog:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* msg = [command.arguments objectAtIndex:0];
	
	if(msg != nil && [msg length] > 0) {
		NSLog(msg);
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end