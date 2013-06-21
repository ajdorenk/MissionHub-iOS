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
	
	return [[[[MHStorage sharedInstance] managedObjectModel] entitiesByName] objectForKey:NSStringFromClass([self class])];
	
}

+(NSFetchRequest *)fetchRequestForEntity {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[self entity]];
	
	return fetchRequest;
}

+(id)newObject:(NSDictionary *)attributes {
	
	return [self newObject:attributes inContext:nil];
	
}

+(id)newObject:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
	
	NSManagedObjectContext *contextForCreation = context ? context : [[MHStorage sharedInstance] managedObjectContext];
	id newObject = [[self alloc] initWithEntity:[self entity] insertIntoManagedObjectContext:contextForCreation];
	
	if (attributes != nil) {
		
		for (id key in attributes) {
		
			[newObject setValue:[attributes valueForKey:key] forKey:key];
		
		}
		
	}
	
	return newObject;
}

@end
