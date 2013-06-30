//
//  Models.m
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson.h"
#import "MHOrganization.h"
#import "MHOrganizationalLabel.h"
#import "MHInteraction.h"
#import "MHOrganizationalPermission.h"
#import "MHSurvey.h"
#import "MHAddress.h"
#import "MHEmailAddress.h"
#import "MHPhoneNumber.h"
#import "MHUser.h"

@implementation MHPerson

@dynamic birth_date;
@dynamic campus;
@dynamic created_at;
@dynamic date_became_christian;
@dynamic fb_uid;
@dynamic first_name;
@dynamic gender;
@dynamic graduation_date;
@dynamic last_name;
@dynamic major;
@dynamic minor;
@dynamic picture;
@dynamic remoteID;
@dynamic updated_at;
@dynamic user_id;
@dynamic year_in_school;
@dynamic assignedConacts;
@dynamic assignedLeader;
@dynamic initiatedInteractions;
@dynamic labels;
@dynamic organization;
@dynamic permissionLevel;
@dynamic receivedInteractions;
@dynamic surveys;
@dynamic createdInteractions;
@dynamic updatedInteractions;
@dynamic leaderInOrganization;
@dynamic addresses;
@dynamic emailAddresses;
@dynamic phoneNumbers;
@dynamic user;

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"interactions"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHInteraction *newObject = [MHInteraction newObjectFromFields:object];
			
			[self addReceivedInteractionsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"organizational_permission"]) {
		
		MHOrganizationalPermission *newObject = [MHOrganizationalPermission newObjectFromFields:relationshipObject];
			
		self.permissionLevel = newObject;
		
	} else if ([fieldName isEqualToString:@"organizational_labels"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHOrganizationalLabel *newObject = [MHOrganizationalLabel newObjectFromFields:object];
			
			[self addLabelsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"email_addresses"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHEmailAddress *newObject = [MHEmailAddress newObjectFromFields:object];
			
			[self addEmailAddressesObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"phone_numbers"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPhoneNumber *newObject = [MHPhoneNumber newObjectFromFields:object];
			
			[self addPhoneNumbersObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"addresses"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHAddress *newObject = [MHAddress newObjectFromFields:object];
			
			[self addAddressesObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"user"]) {
		
		MHUser *newObject = [MHUser newObjectFromFields:relationshipObject];
			
		self.user = newObject;
		
	}
	
}

@end
