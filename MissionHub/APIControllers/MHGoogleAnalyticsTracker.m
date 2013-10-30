//
//  MHGoogleAnalyticsTracker.m
//  MissionHub
//
//  Created by Michael Harrison on 10/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGoogleAnalyticsTracker.h"
#import "MHConfig.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAITracker.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

NSString * const MHGoogleAnalyticsCategoryUI				= @"ui";
NSString * const MHGoogleAnalyticsCategoryBackgroundProcess	= @"background_process";
NSString * const MHGoogleAnalyticsCategoryButton			= @"button";
NSString * const MHGoogleAnalyticsCategoryCell				= @"cell";
NSString * const MHGoogleAnalyticsCategoryCheckbox			= @"checkbox";
NSString * const MHGoogleAnalyticsCategorySearchbar			= @"searchbar";
NSString * const MHGoogleAnalyticsCategoryList				= @"list";

NSString * const MHGoogleAnalyticsActionTap		= @"tap";
NSString * const MHGoogleAnalyticsActionSwipe	= @"swipe";

@interface MHGoogleAnalyticsTracker ()

@property (nonatomic, strong) id<GAITracker> tracker;

@end

@implementation MHGoogleAnalyticsTracker

@synthesize tracker = _tracker;

+ (void)start {
	
	[self sharedInstance];
	
}

+ (MHGoogleAnalyticsTracker *)sharedInstance {
	
	static MHGoogleAnalyticsTracker *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		sharedInstance					= [[MHGoogleAnalyticsTracker alloc] init];
		
	});
	
	return sharedInstance;
	
}

- (id)init {

    self = [super init];
    
	if (self) {
        
		[GAI sharedInstance].trackUncaughtExceptions = YES;
		
		if ([MHConfig sharedInstance].inDevelopmentMode) {
			[GAI sharedInstance].dryRun = YES;
			[[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
		}
		
		self.tracker = [[GAI sharedInstance] trackerWithTrackingId:[MHConfig sharedInstance].apiKeyGoogleAnalytics];
		
    }
	
    return self;
}

- (instancetype)setScreenName:(NSString *)screenName {
	
	NSString *name = ( screenName ? screenName : @"" );
	
	[self.tracker set:kGAIScreenName value:name];
	
	return self;
	
}

- (void)sendScreenView {

	[self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
	
}

- (void)sendEventWithLabel:(NSString *)label {
	
	[self sendEventWithCategory:nil action:nil label:label value:nil];
	
}

- (void)sendEventWithCategory:(NSString *)category label:(NSString *)label {
	
	[self sendEventWithCategory:category action:nil label:label value:nil];
	
}

- (void)sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
	
	NSString *categoryName	= ( category	? category		: MHGoogleAnalyticsCategoryButton );
	NSString *actionName	= ( action		? action		: MHGoogleAnalyticsActionTap );
	NSString *labelName		= ( label		? label			: @"" );
	NSNumber *number		= ( value		? value			: nil );
	
	[self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:categoryName		// Event category (required)
																action:actionName		// Event action (required)
																 label:labelName			// Event label
																 value:number] build]];
	
}

- (void)sendScreenViewWithScreenName:(NSString *)screenName {
	
	NSString *screen		= ( screenName	? screenName	: @"" );
	
	[self.tracker send:[[[GAIDictionaryBuilder createAppView] set:screen forKey:kGAIScreenName] build]];
	
}

- (void)sendEventWithScreenName:(NSString *)screenName label:(NSString *)label {
	
	[self sendEventWithScreenName:nil category:nil action:nil label:label value:nil];
	
}

- (void)sendEventWithScreenName:(NSString *)screenName category:(NSString *)category label:(NSString *)label {
	
	[self sendEventWithScreenName:screenName category:category action:nil label:label value:nil];
	
}

- (void)sendEventWithScreenName:(NSString *)screenName category:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
	
	NSString *screen		= ( screenName	? screenName	: @"" );
	NSString *categoryName	= ( category	? category		: MHGoogleAnalyticsCategoryButton );
	NSString *actionName	= ( action		? action		: MHGoogleAnalyticsActionTap );
	NSString *labelName		= ( label		? label			: @"" );
	NSNumber *number		= ( value		? value			: nil );
	
	[self.tracker send:[[[GAIDictionaryBuilder createEventWithCategory:categoryName		// Event category (required)
															   action:actionName		// Event action (required)
																label:labelName			// Event label
																 value:number]			// Event value
												set:screen forKey:kGAIScreenName]		// Screen Name Event was triggered on
												build]];
	
}

@end
