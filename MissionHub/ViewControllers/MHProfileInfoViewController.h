//
//  MHProfileInfoViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MHProfileProtocol.h"
#import "MHPerson+Helper.h"

@interface MHProfileInfoViewController : UITableViewController <MHProfileProtocol, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) MHPerson *person;

@end
