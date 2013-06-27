//
//  NSSet+MHSearchForRemoteID.m
//  MissionHub
//
//  Created by Michael Harrison on 6/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "NSSet+MHSearchForRemoteID.h"

@implementation NSSet (MHSearchForRemoteID)

-(id)findWithRemoteID:(NSNumber *)remoteID {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", remoteID];
	NSArray *filteredArray = [[self allObjects] filteredArrayUsingPredicate:predicate];
	
	id firstFoundObject = nil;
	if ([filteredArray count] > 0) {
		firstFoundObject = [filteredArray objectAtIndex:0];
	}
	
	return firstFoundObject;
	
}

@end
