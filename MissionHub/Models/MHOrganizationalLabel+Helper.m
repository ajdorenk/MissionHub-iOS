//
//  MHOrganizationalLabel+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganizationalLabel+Helper.h"

@implementation MHOrganizationalLabel (Helper)

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"label"]) {
		
		MHLabel *newObject = [MHLabel newObjectFromFields:relationshipObject];
		
		self.label = newObject;
		
	}
	
}

@end
