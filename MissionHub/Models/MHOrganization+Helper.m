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
	
	__weak __typeof(&*self)weakSelf = self;
	
	if ([fieldName isEqualToString:@"labels"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHLabel *newObject = [MHLabel newObjectFromFields:object];
			
			[weakSelf addLabelsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"admins"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = [MHPerson newObjectFromFields:object];
			
			[weakSelf addAdminsObject:newObject];
			[weakSelf addPeopleObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"users"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = [MHPerson newObjectFromFields:object];
			
			[weakSelf addUsersObject:newObject];
			[weakSelf addPeopleObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"surveys"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHSurvey *newObject = [MHSurvey newObjectFromFields:object];
			
			[weakSelf addSurveysObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"interaction_types"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHInteractionType *newObject = [MHInteractionType newObjectFromFields:object];
			
			[weakSelf addInteractionTypesObject:newObject];
			
		}];
		
	}
	
}

- (MHPermissionLevel *)permissionLevelWithRemoteID:(MHPermissionLevelRemoteIds)remoteID {
	
	return [MHPermissionLevel permissionLevelWithRemoteID:remoteID];
	
}

@end
