//
//  MHOrganizationalPermission+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganizationalPermission+Helper.h"

@implementation MHOrganizationalPermission (Helper)

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"permission"]) {
		
		MHPermissionLevel *newObject = [MHPermissionLevel newObjectFromFields:relationshipObject];
		
		self.permission = newObject;
		
	}
	
}

@end
