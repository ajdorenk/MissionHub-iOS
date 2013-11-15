//
//  MHAPIChangeOrganizationTest.m
//  MissionHub
//
//  Created by Michael Harrison on 11/13/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "Kiwi.h"
#import "MHAPI.h"

SPEC_BEGIN(MHAPIChangeOrganizationSpec)

describe(@"MHAPIChangeOrganization", ^{
	
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
	
	context(@"Change to every organization", ^{
		
		it(@"should load every organization without crashing", ^{
			
			[[theBlock(^{
				
				for (NSInteger organizationCounter = 1; organizationCounter <= 100; organizationCounter++) {
					
					[[MHAPI sharedInstance] getOrganizationWithRemoteID:[NSNumber numberWithInteger:organizationCounter] successBlock:^(NSArray *result, MHRequestOptions *options) {
						
						MHOrganization *organization = [result objectAtIndex:0];
						
						[[MHAPI sharedInstance].initialPeopleList removeAllObjects];
						[MHAPI sharedInstance].currentOrganization	= organization;
						
						[[MHAPI sharedInstance] getPeopleListWith:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest] successBlock:^(NSArray *result, MHRequestOptions *options) {
							
							NSArray *peopleList	= ( result ? result : @[] );
							[[MHAPI sharedInstance].initialPeopleList addObjectsFromArray:peopleList];
							
						} failBlock:^(NSError *error, MHRequestOptions *options) {
							
							NSLog(@"Change Org %d failed: %@", organizationCounter, [error localizedDescription]);
							
						}];
						
					} failBlock:^(NSError *error, MHRequestOptions *options) {
						
						NSLog(@"Change Org %d failed: %@", organizationCounter, [error localizedDescription]);
						
					}];
					
				}
				
			}) shouldNot] raise];
			
		});
		
	});
    
});

SPEC_END
