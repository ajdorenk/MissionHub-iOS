//
//  MHMenuViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MHPerson+Helper.h"
#import "MHGenericListViewController.h"

@interface MHMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MHGenericListViewControllerDelegate>

@property (nonatomic, retain) MHOrganization *currentOrganization;

@end
