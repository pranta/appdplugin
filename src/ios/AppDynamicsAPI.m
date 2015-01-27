#import "AppDynamicsAPI.h"
#import "AppDCache.h"
#import <Cordova/CDV.h>
#import <ADEUMInstrumentation/ADEUMInstrumentation.h>

@implementation AppDynamicsAPI

- (void)reportMetricWithName:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* name = [command.arguments objectAtIndex:0];
	NSInteger value = [[command.arguments objectAtIndex:1] integerValue];
	
	NSLog(@"Metric %@", name);
	
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
	
	NSLog(@"Start timer %@", name);
	
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
	
	NSLog(@"Stop timer %@", name);
	
	if(name != nil && [name length] > 0) {
		[ADEumInstrumentation stopTimerWithName:name];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)beginCall:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* name = [command.arguments objectAtIndex:0];
	NSString* selName = [command.arguments objectAtIndex:1];
	
	// make key out of names
	NSMutableString *key = [[NSMutableString alloc] init];
	[key appendString:name];
	[key appendString:selName];
	NSLog(@"beginCall with key %@", key);
	// get cache
	NSMutableDictionary *cache = [AppDCache sharedCache];
	
	SEL sel = NSSelectorFromString(selName);
	
	if(name != nil && [name length] > 0 && selName != nil && [selName length] > 0) {
		id tracker = [ADEumInstrumentation beginCall:name selector:sel];
		// save tracker in cache
		cache[key] = tracker;
		NSLog(@"get tracker");
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:key];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)endCall:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* key = [command.arguments objectAtIndex:0];
	NSLog(@"endCall %@", key);
	
	// get the cache
	NSMutableDictionary *cache = [AppDCache sharedCache];
	id tracker = cache[key];
	
	if(tracker != nil) {
		[ADEumInstrumentation endCall:tracker];
		// clear cache
		[cache removeObjectForKey:key];
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
		NSLog(@"Log >>> %@", msg);
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end