//
//  NSMutableArray+removeDuplicatesForKey.m
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "NSMutableArray+removeDuplicatesForKey.h"

@implementation NSMutableArray (removeDuplicatesForKey)

-(NSMutableArray *)arrayWithDuplicatesRemovedForKey:(NSString *)key {
	
	__block NSMutableArray *arrayWithOutDuplicates = [NSMutableArray array];
	__block NSMutableSet *lookup = [[NSMutableSet alloc] init];
	
	@try {
		
		//
		// filter the data set in one pass
		//
		
		[self enumerateObjectsUsingBlock:^(id currentObject, NSUInteger index, BOOL *stop) {
			
			id identifer = [currentObject valueForKey:key];
			NSNumber *remoteID = [NSNumber numberWithInteger:-1];
			
			if ([identifer isKindOfClass:[NSNumber class]]) {
				remoteID = identifer;
			}
			
			if (![lookup findWithRemoteID:remoteID]) {
				
				[arrayWithOutDuplicates addObject:currentObject];
				[lookup addObject:currentObject];
				
			}
			
		}];
		
	}
	@catch (NSException *exception) {
		
		arrayWithOutDuplicates = self;
		
	}
	@finally {
		//nothing to do
	}
	
	
	return arrayWithOutDuplicates;
	
}

@end
