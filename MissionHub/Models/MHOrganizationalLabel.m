//
//  MHOrganizationalLabel.m
//  MissionHub
//
//  Created by Michael Harrison on 6/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganizationalLabel.h"
#import "MHPerson.h"
#import "MHLabel.h"


@implementation MHOrganizationalLabel

@dynamic created_at;
@dynamic remoteID;
@dynamic updated_at;
@dynamic added_by_id;
@dynamic label_id;
@dynamic start_date;
@dynamic removed_date;
@dynamic label;
@dynamic person;

-(void)setRelationshipsObject:(id)relationshipObject forFieldName:(NSString *)fieldName {
	
	if ([fieldName isEqualToString:@"label"]) {
		
		MHLabel *newObject = [MHLabel newObjectFromFields:relationshipObject];
		
		self.label = newObject;
		
	}
	
}

@end
