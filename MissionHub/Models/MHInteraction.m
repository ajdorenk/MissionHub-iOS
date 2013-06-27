//
//  MHInteraction.m
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteraction.h"
#import "MHPerson.h"
#import "MHInteractionType.h"


@implementation MHInteraction

@dynamic comment;
@dynamic created_at;
@dynamic deleted_at;
@dynamic privacy_setting;
@dynamic remoteID;
@dynamic timestamp;
@dynamic updated_at;
@dynamic initiators;
@dynamic receiver;
@dynamic type;
@dynamic creator;
@dynamic updater;

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"initiators"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = [MHPerson newObjectFromFields:object];
			
			[self addInitiatorsObject:newObject];
			
		}];
		
	} else if ([fieldName isEqualToString:@"interaction_type"]) {
		
		MHInteractionType *newObject = [MHInteractionType newObjectFromFields:relationshipObject];
		
		self.type = newObject;
		
	} else if ([fieldName isEqualToString:@"receiver"]) {
		
		MHPerson *newObject = [MHPerson newObjectFromFields:relationshipObject];
		
		self.receiver = newObject;
		
	} else if ([fieldName isEqualToString:@"creator"]) {
		
		MHPerson *newObject = [MHPerson newObjectFromFields:relationshipObject];
		
		self.creator = newObject;
		
	} else if ([fieldName isEqualToString:@"last_updater"]) {
		
		MHPerson *newObject = [MHPerson newObjectFromFields:relationshipObject];
		
		self.updater = newObject;
		
	}
	
}

@end
