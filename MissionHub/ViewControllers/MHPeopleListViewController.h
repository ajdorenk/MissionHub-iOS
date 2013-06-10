//
//  MHPeopleListViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MHMenuViewController.h"

@interface MHPeopleListViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>

- (IBAction)revealMenu:(id)sender;

@end
