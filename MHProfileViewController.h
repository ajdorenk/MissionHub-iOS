//
//  MHProfileViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6ParallaxController.h"

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *backMenuButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addTagButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addLabelButton;
//@property (nonatomic, strong) IBOutlet UINavigationBar *custnavbar;

- (IBAction)backToMenu:(id)sender;
- (IBAction)addTagActivity:(id)sender;
- (IBAction)addLabelActivity:(id)sender;

@end
