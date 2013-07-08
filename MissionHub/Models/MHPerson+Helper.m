//
//  MHPerson+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson+Helper.h"

@implementation MHPerson (Helper)

-(NSString *)fullName {
	
	if (self.last_name) {
		return [self.first_name stringByAppendingFormat:@" %@", self.last_name];
	} else {
		return self.first_name;
	}
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"interactions"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHInteraction *newObject = [MHInteraction newObjectFromFields:object];
			
			[self addReceivedInteractionsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"all_organization_and_children"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHOrganization *newObject = [MHOrganization newObjectFromFields:object];
			
			[self addAllOrganizationsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"all_organizational_permissions"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHOrganizationalPermission *newObject = [MHOrganizationalPermission newObjectFromFields:object];
			
			[self addAllOrganizationalPermissionsObject:newObject];
			
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
