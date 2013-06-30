//
//  MHUser.h
//  MissionHub
//
//  Created by Michael Harrison on 6/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHPerson;

@interface MHUser : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * primary_organization_id;
@property (nonatomic, retain) MHPerson *person;

@end
