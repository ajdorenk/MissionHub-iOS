//
//  MHOrganization+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganization+Helper.h"

@implementation MHOrganization (Helper)

-(NSString *)displayString {
	
	if (self.name) {
		return self.name;
	} else {
		return @"";
	}
	
}

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"labels"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHLabel *newObject = [MHLabel newObjectFromFields:object];
			
			[self addLabelsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"admins"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = [MHPerson newObjectFromFields:object];
			
			[self addAdminsObject:newObject];
			[self addPeopleObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"users"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = [MHPerson newObjectFromFields:object];
			
			[self addUsersObject:newObject];
			[self addPeopleObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"surveys"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHSurvey *newObject = [MHSurvey newObjectFromFields:object];
			
			[self addSurveysObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"interaction_types"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHInteractionType *newObject = [MHInteractionType newObjectFromFields:object];
			
			[self addInteractionTypesObject:newObject];
			
		}];
		
	}
	
}

- (MHPermissionLevel *)permissionLevelWithRemoteID:(MHPermissionLevelRemoteIds)remoteID {
	
	return [MHPermissionLevel permissionLevelWithRemoteID:remoteID];
	
}

@end
