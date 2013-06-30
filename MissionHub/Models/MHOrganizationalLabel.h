//
//  MHOrganizationalLabel.h
//  MissionHub
//
//  Created by Michael Harrison on 6/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHPerson, MHLabel;

@interface MHOrganizationalLabel : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * added_by_id;
@property (nonatomic, retain) NSNumber * label_id;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSDate * removed_date;
@property (nonatomic, retain) MHLabel *label;
@property (nonatomic, retain) MHPerson *person;

@end
