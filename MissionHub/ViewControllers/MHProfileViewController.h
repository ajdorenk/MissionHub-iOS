//
//  MHProfileViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6ParallaxController.h"
#import "MHPerson+Helper.h"
#import "MHProfileProtocol.h"
#import "MHProfileMenuViewController.h"
#import "MHNewInteractionViewController.h"
#import "MHGenericListViewController.h"
#import "MHActivityViewController.h"

extern NSString *const MHProfileViewControllerNotificationPersonDeleted;
extern NSString *const MHProfileViewControllerNotificationPersonArchived;
extern NSString *const MHProfileViewControllerNotificationPersonUpdated;

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate, MHProfileProtocol, MHProfileMenuDelegate, MHGenericListViewControllerDelegate, MHCreateInteractionDelegate, MHActivityViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) MHPerson *person;

- (void)refresh;

@end
