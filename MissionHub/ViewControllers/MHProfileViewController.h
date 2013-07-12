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
#import "MHAPI.h"
#import "MHPerson+Helper.h"

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (retain, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) MHPerson *_person;


//@property (nonatomic, strong) IBOutlet SDSegmentedControl *menu;


- (IBAction)controlSegmentSwitch:(SDSegmentedControl *)segmentedControl;



@end
