//
//  MHInteraction+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteraction+Helper.h"

@implementation MHInteraction (Helper)

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

-(void)addRelationshipObject:(id)relationshipObject forFieldName:(NSString *)fieldName toJsonObject:(NSMutableDictionary *)jsonObject {
	
	if ([fieldName isEqualToString:@"initiators"]) {
		
		NSArray *arrayOfObjects = relationshipObject;
		NSMutableArray *arrayOfIds = [NSMutableArray array];
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			MHPerson *newObject = (MHPerson *)object;
			
			[arrayOfIds addObject:newObject.remoteID];
			
		}];
		
		[jsonObject setObject:arrayOfIds forKey:@"initiator_ids"];
		
	} else if ([fieldName isEqualToString:@"type"]) {
		
		MHInteractionType *newObject = (MHInteractionType *)relationshipObject;
		
		if (newObject) {
			[jsonObject setObject:newObject.remoteID forKey:@"interaction_type_id"];
		}
		
	} else if ([fieldName isEqualToString:@"receiver"]) {
		
		MHPerson *newObject = (MHPerson *)relationshipObject;
		
		if (newObject) {
			[jsonObject setObject:newObject.remoteID forKey:@"receiver_id"];
		}
		
	} else if ([fieldName isEqualToString:@"creator"]) {
		
		MHPerson *newObject = (MHPerson *)relationshipObject;
		
		if (newObject) {
			[jsonObject setObject:newObject.remoteID forKey:@"created_by_id"];
		}
		
	} else if ([fieldName isEqualToString:@"updater"]) {
		
		MHPerson *newObject = (MHPerson *)relationshipObject;
		
		if (newObject) {
			[jsonObject setObject:newObject.remoteID forKey:@"updated_by_id"];
		}
		
	}
	
}

@end
