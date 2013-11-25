//
//  MHOrganizationalPermission+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganizationalPermission.h"

extern NSString * const MHOrganizationalPermissionStatusUncontacted;
extern NSString * const MHOrganizationalPermissionStatusAttemptedContact;
extern NSString * const MHOrganizationalPermissionStatusContacted;
extern NSString * const MHOrganizationalPermissionStatusDoNotContact;
extern NSString * const MHOrganizationalPermissionStatusCompleted;

@interface MHOrganizationalPermission (Helper)

- (NSArray *)followupStatuses;

@end
