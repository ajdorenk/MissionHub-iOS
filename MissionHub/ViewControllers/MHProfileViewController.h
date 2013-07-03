//
//  MHProfileViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6ParallaxController.h"

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate>

-(void)cycleFromViewController:(UIViewController *)oldVC
             toViewController:(UIViewController*)newVC;

@end
