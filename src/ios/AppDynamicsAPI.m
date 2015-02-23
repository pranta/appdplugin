#import "AppDynamicsAPI.h"
#import "AppDCache.h"
#import <Cordova/CDV.h>
#import <ADEUMInstrumentation/ADEUMInstrumentation.h>
#import <ADEUMInstrumentation/ADEumHTTPRequestTracker.h>

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
    
    // Use UUID for key
    NSString *key = [[NSUUID alloc] init].UUIDString;
	
	NSLog(@"beginCall with key %@", key);
	// get cache
	NSMutableDictionary *cache = [AppDCache sharedCache];
	
	SEL sel = NSSelectorFromString(selName);
	
	if(name != nil && [name length] > 0 && selName != nil && [selName length] > 0) {
		id tracker = [ADEumInstrumentation beginCall:name selector:sel];
		// save tracker in cache
		cache[key] = tracker;
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
    
    if(key != nil && [key length] > 0) {
        id tracker = cache[key];
        if(tracker != nil) {
            [ADEumInstrumentation endCall:tracker];
            // clear cache
            [cache removeObjectForKey:key];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)leaveBreadcrumb:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* crumb = [command.arguments objectAtIndex:0];
	NSLog(@"leaveBreadcrumb %@", crumb);
	
	if(crumb != nil && [crumb length] > 0) {
		[ADEumInstrumentation leaveBreadcrumb:crumb];
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)beginHttpRequest:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString* url = [command.arguments objectAtIndex:0];
	NSLog(@"beginHttpRequest %@", url);
    
    // use UUID for key
    NSString *key = [[NSUUID alloc]init].UUIDString;
	
	// get cache
	NSMutableDictionary *cache = [AppDCache sharedCache];
	NSURL *nsurl = [[NSURL alloc] initWithString:url]; // new url from string
	
	if(url != nil && [url length] > 0 && nsurl != nil) {
		ADEumHTTPRequestTracker *tracker = [ADEumHTTPRequestTracker requestTrackerWithURL:nsurl];
		cache[key] = tracker;
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:key];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)reportDone:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult = nil;
	NSString *key = [command.arguments objectAtIndex:0];
	NSNumber *status = [command.arguments objectAtIndex:1];
	NSDictionary *headers = [command.arguments objectAtIndex:2];
	//NSLog(@"reportDone %@", [headers description]);
	
	// Hack to get round bug CORE-39486
	NSMutableDictionary *headersfixed = [[NSMutableDictionary alloc] init];
	NSString *val = nil;
	NSString *newkey = nil;
	for(NSString *key in headers) {
		val = headers[key];
		if([key hasPrefix:@"adrum"]) {
			newkey = key.uppercaseString;
		} else {
			newkey = key;
		}
		headersfixed[newkey] = val;
	}
	NSLog(@"FIXED headers %@", [headersfixed description]);
	
	// get cache
	NSMutableDictionary *cache = [AppDCache sharedCache];
	if(key != nil && [key length] > 0) {
		ADEumHTTPRequestTracker *tracker = cache[key];
		if(tracker != nil) {
			[cache removeObjectForKey:key];
			tracker.statusCode = status;
			tracker.allHeaderFields = headersfixed;
			[tracker reportDone];
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		} else {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		}
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