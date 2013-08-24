//
//  MHInteraction+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteraction+Helper.h"
#import "MHAPI.h"
#import "NSSet+MHSearchForRemoteID.h"

@implementation MHInteraction (Helper)

-(void)setDefaults {
	
	//turn this into defaults
	[self addInitiatorsObject:[MHAPI sharedInstance].currentUser];
	self.type			= [[[MHAPI sharedInstance].currentUser.currentOrganization interactionTypes] findWithRemoteID:@1]; //comment interaction type has id=1
	self.comment		= @"";
	self.privacy_setting = [MHInteraction stringForPrivacySetting:MHInteractionPrivacySettingEveryone];
	self.timestamp		= [NSDate date];
	self.created_at		= [NSDate date];
	self.updated_at		= [NSDate date];
	self.creator		= [MHAPI sharedInstance].currentUser;
	self.updater		= [MHAPI sharedInstance].currentUser;
	
}

-(BOOL)validateForServerCreate:(NSError **)error {
	
	NSMutableString *errorMessage = [NSMutableString string];
	
	if (![self.remoteID isEqualToNumber:@0]) {
		
		if (error != NULL) {
		
			[errorMessage appendString:@"Interaction Already Exists"];
			*error = [NSError errorWithDomain:@"MHInteraction.errorDomain"
										 code:1
									 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
			
		}
		
		return NO;
		
	}
	
	if ([self.initiators count] == 0) {
		[errorMessage appendString:@"Initiator Missing. "];
	}
	
	if (!self.receiver) {
		[errorMessage appendString:@"Receiver Missing. "];
	}
	
	if ([self.privacy_setting length] == 0) {
		[errorMessage appendString:@"Privacy Setting Missing. "];
	}
	
	if (!self.comment) {
		[errorMessage appendString:@"Comment Missing. "];
	}
	
	/*
	if (!self.timestamp) {
		[errorMessage appendString:@"Timestamp Missing. "];
	}
	
	if (!self.created_at) {
		[errorMessage appendString:@"Created At Date Missing. "];
	}
	
	if (!self.updated_at) {
		[errorMessage appendString:@"Updated At Date Missing. "];
	}
	
	if (!self.creator) {
		[errorMessage appendString:@"Creator Missing. "];
	}
	
	if (!self.updater) {
		[errorMessage appendString:@"Update Missing. "];
	}
	*/
	
	if ([errorMessage length] > 0) {
		
		if (error != NULL) {
		
			*error = [NSError errorWithDomain:@"MHInteraction.errorDomain"
										code:2
									userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}];
			
		}
		
		return NO;
		
	}
	
	return YES;
	
}

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
		
		NSSet *arrayOfObjects = (NSSet *)relationshipObject;
		NSMutableArray *arrayOfIds = [NSMutableArray array];
		
		[arrayOfObjects enumerateObjectsUsingBlock:^(id object, BOOL *stop) {
			
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

+(NSString *)stringForPrivacySetting:(MHInteractionPrivacySettings)privacySetting {
	
	NSString *returnString = @"";
	
	switch (privacySetting) {
		case MHInteractionPrivacySettingAdmins:
			returnString = @"admins";
			break;
		case MHInteractionPrivacySettingEveryone:
			returnString = @"everyone";
			break;
		case MHInteractionPrivacySettingMe:
			returnString = @"me";
			break;
		case MHInteractionPrivacySettingOrganization:
			returnString = @"organization";
			break;
		case MHInteractionPrivacySettingParent:
			returnString = @"parent";
			break;
			
		default:
			break;
	}
	
	return returnString;
	
}

@end
