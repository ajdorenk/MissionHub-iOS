//
//  MHOrganization.m
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganization.h"
#import "MHLabel.h"
#import "MHPerson.h"
#import "MHInteractionType.h"
#import "MHPermissionLevel.h"
#import "MHSurvey.h"


@implementation MHOrganization

@dynamic ancestry;
@dynamic created_at;
@dynamic name;
@dynamic remoteID;
@dynamic show_sub_orgs;
@dynamic status;
@dynamic terminology;
@dynamic updated_at;
@dynamic admins;
@dynamic labels;
@dynamic people;
@dynamic leaders;
@dynamic surveys;

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
