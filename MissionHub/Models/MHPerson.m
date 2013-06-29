//
//  Models.m
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson.h"
#import "MHOrganization.h"
#import "MHLabel.h"
#import "MHInteraction.h"
#import "MHPermissionLevel.h"
#import "MHSurvey.h"

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
		
	} else if ([fieldName isEqualToString:@"leaders"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = [MHPerson newObjectFromFields:object];
			
			[self addLeadersObject:newObject];
			[self addPeopleObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"surveys"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHSurvey *newObject = [MHSurvey newObjectFromFields:object];
			
			[self addSurveysObject:newObject];
			
		}];
		
	}
	
}

@end
