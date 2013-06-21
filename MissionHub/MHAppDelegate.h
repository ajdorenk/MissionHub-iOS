//
//  MHAppDelegate.h
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHLoginViewController.h"

#define AppDelegate (MHAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface MHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MHLoginViewController *loginViewController;

@end
