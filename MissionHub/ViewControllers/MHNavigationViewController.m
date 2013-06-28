//
//  MHNavigationViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHNavigationViewController.h"

@interface MHNavigationViewController ()

@end

@implementation MHNavigationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
	if (![self.slidingViewController.underLeftViewController isKindOfClass:[MHMenuViewController class]]) {
		self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
	}
	
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    UIImage *navBackground =[[UIImage imageNamed:@"topbar_background.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:navBackground forBarMetrics:UIBarMetricsDefault];
}


@end
