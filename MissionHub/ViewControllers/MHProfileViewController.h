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
#import "MHGenericListViewController.h"

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, MHProfileProtocol, MHProfileMenuDelegate, MHGenericListViewControllerDelegate>

@property (nonatomic, strong) MHPerson							*person;

- (void)refresh;

@end
