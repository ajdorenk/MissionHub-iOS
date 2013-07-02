//
//  MHLoginViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "FBLoginView.h"
#import "MHPerson+Helper.h"

extern NSString *const FBSessionStateChangedNotification;

@protocol MHLoginDelegate <NSObject>
@optional

-(void)finishedLoginWithCurrentUser:(MHPerson *)currentUser;
-(void)finishedLogout;

@end

@interface MHLoginViewController : UIViewController <FBLoginViewDelegate, MHLoginDelegate> {
	
	id<MHLoginDelegate>		_loginDelegate;
	FBLoginView				*_loginButtonView;
	UIActivityIndicatorView	*_loadingIndicator;
	
}

@property (nonatomic, retain)				id<MHLoginDelegate>		loginDelegate;
@property (nonatomic, retain)				FBLoginView				*loginButtonView;
@property (nonatomic, retain)				UIActivityIndicatorView	*loadingIndicator;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)handleDidBecomeActive;
- (void)handleWillTerminate;
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken;

-(void)loggedInWithToken:(NSString *)token;

@end
