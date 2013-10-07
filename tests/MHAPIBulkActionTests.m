//
//  MHAPIBulkActionTests.m
//  MissionHub
//
//  Created by Michael Harrison on 10/4/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "Kiwi.h"
#import "MHAPI.h"

SPEC_BEGIN(MHAPIBulkActionSpec)

describe(@"MHAPIBulkAction", ^{
	
	__block MHAPI *api							= [MHAPI sharedInstance];
	__block NSError *initialError				= nil;
	__block MHPerson *currentUser				= nil;
	__block MHOrganization *currentOrganization	= nil;
	__block NSArray *peopleList					= nil;
	
	[api getMeWithSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
		
		id  resultObject = [result objectAtIndex:1];
		
		if ([resultObject isKindOfClass:[NSArray class]]) {
			
			peopleList = resultObject;
			
		}
		
		currentUser			= api.currentUser;
		currentOrganization	= api.currentOrganization;
		
	} failBlock:^(NSError *error, MHRequestOptions *options) {
		
		initialError	= error;
		
	}];
	
	context(@"bulk label actions", ^{
		
		it(@"should add labels to an array of people", ^{
			
			NSArray *addArray					= [currentOrganization.labels.allObjects objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
			NSArray *removeArray				= [currentOrganization.labels.allObjects objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 3)]];
			NSArray *peopleArray				= [peopleList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
			__block NSArray *bulkLabelResult	= nil;
			__block NSError *bulkLabelError		= nil;
			
			[api bulkChangeLabelsWithLabelsToAdd:addArray labelsToRemove:removeArray forPeople:peopleArray withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
				
				bulkLabelResult	= result;
				
			} failBlock:^(NSError *error, MHRequestOptions *options) {
				
				bulkLabelError	= error;
				NSLog(@"Bulk Label Request did fail because: %@", [error localizedDescription]);
				
			}];
			
			[[bulkLabelResult shouldEventually] beNonNil];
			
		});
		
	});
    
});

SPEC_END
