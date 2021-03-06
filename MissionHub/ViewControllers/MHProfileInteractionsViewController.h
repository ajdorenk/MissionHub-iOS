//
//  MHInteractionViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHProfileProtocol.h"
#import "MHPerson+Helper.h"

@interface MHProfileInteractionsViewController : UITableViewController <MHProfileProtocol>

@property (nonatomic, strong) MHPerson *person;

@end
