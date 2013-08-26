//
//  MHProfileSurveysViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHProfileProtocol.h"

@interface MHProfileSurveysViewController : UITableViewController <MHProfileProtocol>

@property (nonatomic, strong) MHPerson *_person;

@end
