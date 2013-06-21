//
//  MHLoginViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

extern NSString *const FBSessionStateChangedNotification;

@protocol MHLoginDelegate <NSObject>
@optional

-(void)loggedInWithToken:(NSString *)token;
-(void)loggedOut;

@end

@interface MHLoginViewController : UIViewController <FBLoginViewDelegate, MHLoginDelegate>

@property (nonatomic, retain)				id<MHLoginDelegate> delegate;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)handleDidBecomeActive;
- (void)handleWillTerminate;
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken;

@end
