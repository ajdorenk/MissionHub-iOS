//
//  MHParallaxTopViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSegmentedControl.h"

@interface MHParallaxTopViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet SDSegmentedControl *menu;

- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight;


@end
