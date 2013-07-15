//
//  MHInitiatorCell.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//
#import "MHPerson+Helper.h"
#import <UIKit/UIKit.h>

@interface MHInitiatorCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;

-(void)populateWithInitiator:(MHPerson *)person;

@end
