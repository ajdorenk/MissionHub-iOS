//
//  MHGoogleAnalyticsTracker.h
//  MissionHub
//
//  Created by Michael Harrison on 10/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MHGoogleAnalyticsCategoryUI;
extern NSString * const MHGoogleAnalyticsCategoryButton;
extern NSString * const MHGoogleAnalyticsCategoryCell;
extern NSString * const MHGoogleAnalyticsActionTap;
extern NSString * const MHGoogleAnalyticsActionSwipe;

@interface MHGoogleAnalyticsTracker : NSObject

+ (void)start;
+ (MHGoogleAnalyticsTracker *)sharedInstance;

- (instancetype)setScreenName:(NSString *)screenName;

- (void)sendScreenView;
- (void)sendEventWithLabel:(NSString *)label;
- (void)sendEventWithCategory:(NSString *)category label:(NSString *)label;
- (void)sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

- (void)sendScreenViewWithScreenName:(NSString *)screenName;
- (void)sendEventWithScreenName:(NSString *)screenName label:(NSString *)label;
- (void)sendEventWithScreenName:(NSString *)screenName category:(NSString *)category label:(NSString *)label;
- (void)sendEventWithScreenName:(NSString *)screenName category:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

@end
