//
//  MHPerson+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson+Helper.h"
#import "MHOrganizationalPermission+Helper.h"

@implementation MHPerson (Helper)

- (void)setDefaultsForNewObject {
	
	self.gender = @"Male";
	
}

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

-(BOOL)validateForServerCreate:(NSError **)error {
	
	NSMutableString *errorMessage = [NSMutableString string];
	
	if (![self.remoteID isEqualToNumber:@0]) {
		
		if (error != NULL) {
		
			[errorMessage appendString:@"Person Already Exists"];
			*error = [NSError errorWithDomain:@"MHPerson.errorDomain"
										 code:1
									 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
			
		}
		
		return NO;
		
	}
	
	if ([self.first_name length]) {
		
		return YES;
		
	} else {
		
		if (error != NULL) {
		
			[errorMessage appendString:@"First Name Missing "];
			*error = [NSError errorWithDomain:@"MHPerson.errorDomain"
										 code:2
									 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
			
		}
		
		return NO;
		
	}
	
}

-(NSString *)displayString {
	
	return self.fullName;
	
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
	
	if ([self.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel noPermissions].remoteID] &&
		self.permissionLevel.statusForDisplay) {
		
		return self.permissionLevel.statusForDisplay;
		
	} else {
		
		return @"";
		
	}
	
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
	
	__weak __typeof(&*self)weakSelf = self;
	
	if ([fieldName isEqualToString:@"interactions"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHInteraction *newObject = [MHInteraction newObjectFromFields:object];
			
			[weakSelf addReceivedInteractionsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"all_organization_and_children"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHOrganization *newObject = [MHOrganization newObjectFromFields:object];
			
			[weakSelf addAllOrganizationsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"all_organizational_permissions"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHOrganizationalPermission *newObject = [MHOrganizationalPermission newObjectFromFields:object];
			
			[weakSelf addAllOrganizationalPermissionsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"organizational_permission"]) {
		
		MHOrganizationalPermission *newObject = [MHOrganizationalPermission newObjectFromFields:relationshipObject];
		
		self.permissionLevel = newObject;
		
	} else if ([fieldName isEqualToString:@"organizational_labels"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHOrganizationalLabel *newObject = [MHOrganizationalLabel newObjectFromFields:object];
			
			[weakSelf addLabelsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"email_addresses"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHEmailAddress *newObject = [MHEmailAddress newObjectFromFields:object];
			
			[weakSelf addEmailAddressesObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"phone_numbers"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPhoneNumber *newObject = [MHPhoneNumber newObjectFromFields:object];
			
			[weakSelf addPhoneNumbersObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"addresses"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHAddress *newObject = [MHAddress newObjectFromFields:object];
			
			[weakSelf addAddressesObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"answer_sheets"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHAnswerSheet *newObject = [MHAnswerSheet newObjectFromFields:object];
			
			[weakSelf addAnswerSheetsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"user"]) {
		
		MHUser *newObject = [MHUser newObjectFromFields:relationshipObject];
		
		self.user = newObject;
		
	}
	
}

-(void)addRelationshipObject:(id)relationshipObject forFieldName:(NSString *)fieldName toJsonObject:(NSMutableDictionary *)jsonObject {
	
//	if ([fieldName isEqualToString:@"permissionLevel"]) {
//		
//		MHOrganizationalPermission *newObject = (MHOrganizationalPermission *)relationshipObject;
//		
//		//if there is an object that hasn't been created yet add it to the jsonObject
//		if (newObject && [newObject.remoteID isEqualToNumber:@0]) {
//			
//			[jsonObject setObject:newObject.remoteID forKey:@"permissions"];
//			
//		}
//		
//	} else if ([fieldName isEqualToString:@"labels"]) {
	if ([fieldName isEqualToString:@"labels"]) {
		
		NSSet *setOfObjects = (NSSet *)relationshipObject;
		__block NSMutableArray *arrayOfJsonObject = [NSMutableArray array];
		
		[setOfObjects enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
			
			MHOrganizationalLabel *newObject = (MHOrganizationalLabel *)object;
			
			//if there is an object that hasn't been created yet add it to the jsonObject
			if (newObject && [newObject.remoteID isEqualToNumber:@0]) {
				
				[arrayOfJsonObject addObject:[newObject jsonObject]];
				
			}
			
		}];
		
		if ([arrayOfJsonObject count] > 0) {
			
			[jsonObject setObject:arrayOfJsonObject forKey:@"organizational_labels"];
			
		}
		
	} else if ([fieldName isEqualToString:@"emailAddresses"]) {
		
		NSSet *setOfObjects = (NSSet *)relationshipObject;
		__block NSMutableArray *arrayOfJsonObject = [NSMutableArray array];
		
		[setOfObjects enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
			
			MHEmailAddress *newObject = (MHEmailAddress *)object;
			
			//if there is an object that hasn't been created yet add it to the jsonObject
			if (newObject && [newObject.remoteID isEqualToNumber:@0]) {
				
				[arrayOfJsonObject addObject:[newObject jsonObject]];
				
			}
			
		}];
		
		if ([arrayOfJsonObject count] > 0) {
			
			[jsonObject setObject:arrayOfJsonObject forKey:@"email_addresses"];
			
		}
		
	} else if ([fieldName isEqualToString:@"phoneNumbers"]) {
		
		NSSet *setOfObjects = (NSSet *)relationshipObject;
		__block NSMutableArray *arrayOfJsonObject = [NSMutableArray array];
		
		[setOfObjects enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
			
			MHPhoneNumber *newObject = (MHPhoneNumber *)object;
			
			//if there is an object that hasn't been created yet add it to the jsonObject
			if (newObject && [newObject.remoteID isEqualToNumber:@0]) {
				
				[arrayOfJsonObject addObject:[newObject jsonObject]];
				
			}
			
		}];
		
		if ([arrayOfJsonObject count] > 0) {
			
			[jsonObject setObject:arrayOfJsonObject forKey:@"phone_numbers"];
			
		}
		
	} else if ([fieldName isEqualToString:@"addresses"]) {
		
		NSSet *setOfObjects = (NSSet *)relationshipObject;
		__block NSMutableArray *arrayOfJsonObject = [NSMutableArray array];
		
		[setOfObjects enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
			
			MHAddress *newObject = (MHAddress *)object;
			
			//if there is an object that hasn't been created yet add it to the jsonObject
			if (newObject && [newObject.remoteID isEqualToNumber:@0]) {
				
				[arrayOfJsonObject addObject:[newObject jsonObject]];
				
			}
			
		}];
		
		if ([arrayOfJsonObject count] > 0) {
			
			[jsonObject setObject:arrayOfJsonObject forKey:@"addresses"];
			
		}
		
	}
	
}

-(id)valueForJsonObjectWithKey:(NSString *)key {
	
	id value = [super valueForJsonObjectWithKey:key];
	
	if ([key isEqualToString:@"fb_uid"] && [(NSNumber *)value isEqual:@0]) {
		value = nil;
	}
	
	if ([key isEqualToString:@"user_id"] && [(NSNumber *)value isEqual:@0]) {
		value = nil;
	}
	
	return value;
	
}

@end
