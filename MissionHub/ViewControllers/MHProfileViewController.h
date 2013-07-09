//
//  MHProfileViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6ParallaxController.h"
#import "SDSegmentedControl.h"
#import "MHNewInteractionViewController.h"

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;


//@property (nonatomic, strong) IBOutlet SDSegmentedControl *menu;

//-(void)cycleFromViewController:(UIViewController *)oldVC toViewController:(UIViewController*)newVC;

- (IBAction)controlSegmentSwitch:(SDSegmentedControl *)segmentedControl;



@end
