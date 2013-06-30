//
//  MHPermissionLevel.h
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHOrganizationalPermission;

@interface MHPermissionLevel : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * i18n;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *appliedPermissions;
@end

@interface MHPermissionLevel (CoreDataGeneratedAccessors)

- (void)addAppliedPermissionsObject:(MHOrganizationalPermission *)value;
- (void)removeAppliedPermissionsObject:(MHOrganizationalPermission *)value;
- (void)addAppliedPermissions:(NSSet *)values;
- (void)removeAppliedPermissions:(NSSet *)values;

@end
