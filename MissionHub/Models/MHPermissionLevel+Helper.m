//
//  MHPermissionLevel+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 8/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPermissionLevel+Helper.h"

@implementation MHPermissionLevel (Helper)

+ (instancetype)admin {
	
	static MHPermissionLevel *sharedInstanceAdmin;
	static dispatch_once_t onceTokenAdmin;
	
	dispatch_once(&onceTokenAdmin, ^{
		
		sharedInstanceAdmin				= [MHPermissionLevel newObjectFromFields:@{
										   @"id"		:	[NSNumber numberWithInt:MHPermissionLevelRemoteIdAdmin],
										   @"name"		:	@"Admin",
										   @"i18n"		:	@"admin",
										   @"created_at":	@"2011-06-29T03:27:53-03:00",
										   @"updated_at":	@"2011-06-29T03:27:53-03:00"
										   }];
		
	});
	
	return sharedInstanceAdmin;
	
}

+ (instancetype)user {
	
	static MHPermissionLevel *sharedInstanceUser;
	static dispatch_once_t onceTokenUser;
	
	dispatch_once(&onceTokenUser, ^{
		
		sharedInstanceUser				= [MHPermissionLevel newObjectFromFields:@{
										   @"id"		:	[NSNumber numberWithInt:MHPermissionLevelRemoteIdUser],
										   @"name"		:	@"User",
										   @"i18n"		:	@"user",
										   @"created_at":	@"2011-06-29T03:27:53-03:00",
										   @"updated_at":	@"2013-06-11T13:45:30-03:00"
										   }];
		
	});
	
	return sharedInstanceUser;
	
}

+ (instancetype)noPermissions {
	
	static MHPermissionLevel *sharedInstanceNoPermissions;
	static dispatch_once_t onceTokenNoPermissions;
	
	dispatch_once(&onceTokenNoPermissions, ^{
		
		sharedInstanceNoPermissions		= [MHPermissionLevel newObjectFromFields:@{
										   @"id"		:	[NSNumber numberWithInt:MHPermissionLevelRemoteIdNoPermissions],
										   @"name"		:	@"No Permissions",
										   @"i18n"		:	@"no_permissions",
										   @"created_at":	@"2011-06-29T03:27:53-03:00",
										   @"updated_at":	@"2013-06-11T13:45:30-03:00"
										   }];
		
	});
	
	return sharedInstanceNoPermissions;
	
}

+ (MHPermissionLevel *)permissionLevelWithRemoteID:(MHPermissionLevelRemoteIds)remoteID {
	
	MHPermissionLevel *permissionLevel = nil;
	
	switch (remoteID) {
		case MHPermissionLevelRemoteIdAdmin:
			permissionLevel = [MHPermissionLevel admin];
			break;
		case MHPermissionLevelRemoteIdUser:
			permissionLevel = [MHPermissionLevel user];
			break;
		case MHPermissionLevelRemoteIdNoPermissions:
			permissionLevel = [MHPermissionLevel noPermissions];
			break;
			
		default:
			break;
	}
	
	return permissionLevel;
	
}

@end
