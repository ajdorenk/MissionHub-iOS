//
//  MHPerson+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson+Helper.h"

@implementation MHPerson (Helper)

-(NSString *)valueForSortField:(MHPersonSortFields)sortField {
	
	NSString *value = @"";
	
	switch (sortField) {
		case MHPersonSortFieldFirstName:
			value = self.first_name;
			break;
		case MHPersonSortFieldFollowupStatus:
			value = [self followupStatus];
			break;
		case MHPersonSortFieldGender:
			value = self.gender;
			break;
		case MHPersonSortFieldLastName:
			value = self.last_name;
			break;
		case MHPersonSortFieldPermission:
			value = [self permissionName];
			break;
		case MHPersonSortFieldPrimaryEmail:
			value = [self primaryEmail];
			break;
		case MHPersonSortFieldPrimaryPhone:
			value = [self primaryPhone];
			break;
			
		default:
			break;
	}
	
	return value;
	
}

+(NSString *)fieldNameForSortField:(MHPersonSortFields)sortField {
	
	NSString *value = @"";
	
	switch (sortField) {
		case MHPersonSortFieldFirstName:
			value = @"First Name";
			break;
		case MHPersonSortFieldFollowupStatus:
			value = @"Status";
			break;
		case MHPersonSortFieldGender:
			value = @"Gender";
			break;
		case MHPersonSortFieldLastName:
			value = @"Last Name";
			break;
		case MHPersonSortFieldPermission:
			value = @"Permission";
			break;
		case MHPersonSortFieldPrimaryEmail:
			value = @"Email";
			break;
		case MHPersonSortFieldPrimaryPhone:
			value = @"Phone";
			break;
			
		default:
			break;
	}
	
	return value;
	
}

-(NSString *)displayString {
	
	return [self fullName];
	
}

-(NSString *)fullName {
	
	if (self.last_name) {
		return [self.first_name stringByAppendingFormat:@" %@", self.last_name];
	} else {
		return self.first_name;
	}
	
}

-(NSString *)primaryEmail {
	
	__block NSString *returnString = @"";
	
	[self.emailAddresses enumerateObjectsUsingBlock:^(MHEmailAddress *emailAddress, BOOL *stop) {
		
		if ([[emailAddress primary] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
			returnString = [emailAddress email];
		}
		
	}];
	
	return returnString;
}

-(NSString *)primaryPhone {
	
	__block NSString *returnString = @"";
	
	[self.phoneNumbers enumerateObjectsUsingBlock:^(MHPhoneNumber *phoneNumber, BOOL *stop) {
		
		if ([[phoneNumber primary] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
			returnString = [phoneNumber number];
		}
		
	}];
	
	return returnString;
}

-(NSString *)followupStatus {
	
	return ( [self.permissionLevel followup_status] ? [self.permissionLevel followup_status] : @"");
	
}

-(NSString *)permissionName {
	
	if (self.permissionLevel) {
		
		if (self.permissionLevel.permission) {
			
			return ( [[self.permissionLevel permission] name] ? [[self.permissionLevel permission] name] : @"");
			
		}
		
		if (self.permissionLevel.permission_id) {
			
			switch ([[self.permissionLevel permission_id] integerValue]) {
				case 1:
					return @"Admin";
				case 2:
					return @"No Permission";
				case 4:
					return @"User";
					
				default:
					return @"";
			}
			
		}
		
	}
	
	return @"";
	//return ( [[self.permissionLevel permission] name] ? [[self.permissionLevel permission] name] : @"");
	
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
