//
//  MHAppDelegate.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAppDelegate.h"
#import "MHStorage.h"
#import "MHConfig.h"
#import "ABNotifier.h"

@implementation MHAppDelegate

@synthesize loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[ABNotifier startNotifierWithAPIKey:[MHConfig sharedInstance].apiKeyErrbit
						environmentName:ABNotifierAutomaticEnvironment
								 useSSL:YES
							   delegate:nil];
	
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
	
	if (self.loginViewController) {
		
		// Facebook SDK * login flow *
		// Attempt to handle URLs to complete any auth (e.g., SSO) flow.
		return [self.loginViewController application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
		
	} else {
		
		return NO;
		
	}
	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if (self.loginViewController) {
		
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		[self.loginViewController handleDidBecomeActive];
			
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	
	if (self.loginViewController) {
	
		// Saves changes in the application's managed object context before the application terminates.
		[[MHStorage sharedInstance] saveContext];
		[self.loginViewController handleWillTerminate];
			
	}
}

@end
