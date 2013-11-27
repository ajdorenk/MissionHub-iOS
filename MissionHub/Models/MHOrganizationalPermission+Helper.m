//
//  MHOrganizationalPermission+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganizationalPermission+Helper.h"
#import "TransformerKit.h"

NSString * const MHOrganizationalPermissionStatusUncontacted		= @"uncontacted";
NSString * const MHOrganizationalPermissionStatusAttemptedContact	= @"attempted_contact";
NSString * const MHOrganizationalPermissionStatusContacted			= @"contacted";
NSString * const MHOrganizationalPermissionStatusDoNotContact		= @"do_not_contact";
NSString * const MHOrganizationalPermissionStatusCompleted			= @"completed";

@implementation MHOrganizationalPermission (Helper)

+ (NSArray *)arrayOfFollowupStatuses {
	
	return @[
			 MHOrganizationalPermissionStatusUncontacted,
			 MHOrganizationalPermissionStatusAttemptedContact,
			 MHOrganizationalPermissionStatusContacted,
			 MHOrganizationalPermissionStatusDoNotContact,
			 MHOrganizationalPermissionStatusCompleted
			 ];
	
}

+ (NSArray *)arrayOfFollowupStatusesForDisplay {
	
	return @[
			 [MHOrganizationalPermission statusForDisplayFromStatus:MHOrganizationalPermissionStatusUncontacted],
			 [MHOrganizationalPermission statusForDisplayFromStatus:MHOrganizationalPermissionStatusAttemptedContact],
			 [MHOrganizationalPermission statusForDisplayFromStatus:MHOrganizationalPermissionStatusContacted],
			 [MHOrganizationalPermission statusForDisplayFromStatus:MHOrganizationalPermissionStatusDoNotContact],
			 [MHOrganizationalPermission statusForDisplayFromStatus:MHOrganizationalPermissionStatusCompleted]
			 ];
	
}

+ (NSString *)statusForDisplayFromStatus:(NSString *)status {
	
	//TODO: Convert to capitolized with spaces.
	NSString *spacedString	= [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	return [[NSValueTransformer valueTransformerForName:TTTCapitalizedStringTransformerName] transformedValue:spacedString];
	
}

+ (NSString *)statusFromStatusForDisplay:(NSString *)statusForDisplay {
	
	//TODO: convert status back to regular status (once convertion for readability actually happens).
	NSString *lowerCase	= [[NSValueTransformer valueTransformerForName:TTTLowercaseStringTransformerName] transformedValue:statusForDisplay];
	return [[NSValueTransformer valueTransformerForName:TTTSnakeCaseStringTransformerName] transformedValue:lowerCase];
	
}

+ (BOOL)isValidStatus:(NSString *)statusForValidation {
	
	__block BOOL valid	= NO;
	
	[[MHOrganizationalPermission arrayOfFollowupStatuses] enumerateObjectsUsingBlock:^(NSString *status, NSUInteger index, BOOL *stop) {
		
		if ([statusForValidation isEqualToString:status]) {
			
			valid	= YES;
			*stop	= YES;
			
		}
		
	}];
	
	return valid;
	
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
	
	return [MHOrganizationalPermission statusForDisplayFromStatus:self.status];
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"permission"]) {
		
		MHPermissionLevel *newObject = [MHPermissionLevel newObjectFromFields:relationshipObject];
		
		self.permission = newObject;
		
	}
	
}

@end
