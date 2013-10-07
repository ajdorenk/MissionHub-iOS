//
//  MHContactAssignment+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 10/7/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHContactAssignment+Helper.h"

@implementation MHContactAssignment (Helper)

-(id)valueForJsonObjectWithKey:(NSString *)key {
	
	if ([key isEqualToString:@"organization_id"]) {
		
		return nil;
		
	} else {
		
		return [super valueForJsonObjectWithKey:key];
		
	}
	
}

@end
