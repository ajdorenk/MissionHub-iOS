//
//  MHOrganizationalPermission.h
//  MissionHub
//
//  Created by Michael Harrison on 6/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHPerson, MHPermissionLevel;

@interface MHOrganizationalPermission : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * permission_id;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * archive_date;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * followup_status;
@property (nonatomic, retain) MHPermissionLevel *permission;
@property (nonatomic, retain) MHPerson *person;

@end
