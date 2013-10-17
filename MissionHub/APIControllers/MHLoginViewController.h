//
//  MHLoginViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPerson+Helper.h"
#import	"MHRequestOptions.h"

extern NSString *const MHLoginViewControllerLogout;

@protocol MHLoginViewControllerDelegate;

@interface MHLoginViewController : UIViewController

@property (nonatomic, weak)				id<MHLoginViewControllerDelegate>	loginDelegate;
@property (nonatomic, assign)			BOOL								loggedIn;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)handleDidBecomeActive;
- (void)handleWillTerminate;

- (void)logout;

@end

@protocol MHLoginViewControllerDelegate <NSObject>
@optional

-(void)finishedLoginWithCurrentUser:(MHPerson *)currentUser peopleList:(NSArray *)peopleList requestOptions:(MHRequestOptions *)options;
-(void)finishedLogout;

@end
