//
//  MHPermissionLevel+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 8/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPermissionLevel.h"

typedef enum {
	MHPermissionLevelRemoteIdAdmin			= 1,
	MHPermissionLevelRemoteIdUser			= 4,
	MHPermissionLevelRemoteIdNoPermissions	= 2
} MHPermissionLevelRemoteIds;

@interface MHPermissionLevel (Helper)

+ (instancetype)admin;
+ (instancetype)user;
+ (instancetype)noPermissions;

+ (MHPermissionLevel *)permissionLevelWithRemoteID:(MHPermissionLevelRemoteIds)remoteID;

@end
