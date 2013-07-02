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

@interface MHMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(id)setCurrentUser:(MHPerson *)currentUser;

@end
