//
//  MHRootViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "MHLoginViewController.h"
#import "MHAPI.h"

@interface MHRootViewController : ECSlidingViewController <MHLoginDelegate>

@property (nonatomic, strong) UIStoryboard			*realStoryboard;
@property (nonatomic, strong) MHLoginViewController *loginViewController;
@property (nonatomic, assign) BOOL					userInitiatedLogout;

@end
