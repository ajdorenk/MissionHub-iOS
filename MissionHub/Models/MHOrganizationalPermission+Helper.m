//
//  MHOrganizationalPermission+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganizationalPermission+Helper.h"

NSString * const MHOrganizationalPermissionStatusUncontacted		= @"uncontacted";
NSString * const MHOrganizationalPermissionStatusAttemptedContact	= @"attempted_contact";
NSString * const MHOrganizationalPermissionStatusContacted			= @"contacted";
NSString * const MHOrganizationalPermissionStatusDoNotContact		= @"do_not_contact";
NSString * const MHOrganizationalPermissionStatusCompleted			= @"completed";

@implementation MHOrganizationalPermission (Helper)

- (NSArray *)followupStatuses {
	
	return @[
			 MHOrganizationalPermissionStatusUncontacted,
			 MHOrganizationalPermissionStatusAttemptedContact,
			 MHOrganizationalPermissionStatusContacted,
			 MHOrganizationalPermissionStatusDoNotContact,
			 MHOrganizationalPermissionStatusCompleted
			 ];
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"permission"]) {
		
		MHPermissionLevel *newObject = [MHPermissionLevel newObjectFromFields:relationshipObject];
		
		self.permission = newObject;
		
	}
	
}

@end
