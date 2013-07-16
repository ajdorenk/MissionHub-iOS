//
//  MHProfileViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M6ParallaxController.h"
#import "MHProfileHeaderViewController.h"
#import "MHProfileInfoViewController.h"
#import "MHProfileInteractionsViewController.h"
#import "MHProfileMenuViewController.h"
#import "MHNewInteractionViewController.h"
#import "MHAPI.h"
#import "MHPerson+Helper.h"
#import "MHProfileProtocol.h"
#import "MHGenericListViewController.h"
#import "MHProfileSurveysViewController.h"

@interface MHProfileViewController : M6ParallaxController <UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource, MHProfileMenuDelegate, MHProfileProtocol, MHGenericListViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIToolbar* toolbar;
@property (retain, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) UIImageView *actionBar;

-(void)refreshProfile;

@end
