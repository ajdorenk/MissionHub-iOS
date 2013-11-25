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

+ (NSArray *)arrayOfFollowupStatusesForDisplay {
	
	return @[
			 MHOrganizationalPermissionStatusUncontacted,
			 MHOrganizationalPermissionStatusAttemptedContact,
			 MHOrganizationalPermissionStatusContacted,
			 MHOrganizationalPermissionStatusDoNotContact,
			 MHOrganizationalPermissionStatusCompleted
			 ];
	
}

+ (NSString *)statusFromStatusForDisplay:(NSString *)statusForDisplay {
	
	//TODO: convert status back to regular status (once convertion for readability actually happens).
	return statusForDisplay;
	
}


- (NSString *)status {
	
	NSString *status	= MHOrganizationalPermissionStatusUncontacted;
	
	if ([self.followup_status isEqualToString:MHOrganizationalPermissionStatusAttemptedContact]) {
		
		status	= MHOrganizationalPermissionStatusAttemptedContact;
		
	} else if ([self.followup_status isEqualToString:MHOrganizationalPermissionStatusContacted]) {
		
		status	= MHOrganizationalPermissionStatusContacted;
		
	} else if ([self.followup_status isEqualToString:MHOrganizationalPermissionStatusCompleted]) {
		
		status	= MHOrganizationalPermissionStatusCompleted;
		
	} else if ([self.followup_status isEqualToString:MHOrganizationalPermissionStatusDoNotContact]) {
		
		status	= MHOrganizationalPermissionStatusDoNotContact;
		
	}
	
	return status;
	
}

- (NSString *)statusForDisplay {
	
	//TODO: Convert to capitolized with spaces.
	return [self status];
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"permission"]) {
		
		MHPermissionLevel *newObject = [MHPermissionLevel newObjectFromFields:relationshipObject];
		
		self.permission = newObject;
		
	}
	
}

@end
