//
//  MHModel.m
//  MissionHub
//
//  Created by Michael Harrison on 6/16/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHModel.h"

@implementation MHModel

+(NSEntityDescription *)entity {
	
	return [[[AppDelegate managedObjectModel] entitiesByName] objectForKey:NSStringFromClass([self class])];
	
}

+(NSFetchRequest *)fetchRequestForEntity {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self entity]];
	
	return fetchRequest;
}

@end
