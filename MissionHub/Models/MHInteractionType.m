//
//  MHInteractionType.m
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"
#import "MHInteractionType.h"
#import "MHOrganization.h"
#import "MHInteraction.h"


@implementation MHInteractionType

@dynamic created_at;
@dynamic i18n;
@dynamic icon;
@dynamic name;
@dynamic remoteID;
@dynamic updated_at;
@dynamic interactions;

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"organization_id"]) {
		
		self.organization = [[MHAPI sharedInstance] currentOrganization];
		
	}
	
}

@end
