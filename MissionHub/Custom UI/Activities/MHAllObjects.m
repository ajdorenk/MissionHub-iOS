//
//  MHAllObjects.m
//  MissionHub
//
//  Created by Michael Harrison on 11/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAllObjects.h"
#import "MHAPI.h"
#import "NSSet+MHSearchForRemoteID.h"

@interface MHAllObjects ()

@property (nonatomic, strong) MHRequestOptions *requestOptions;
@property (nonatomic, strong) NSSet *deselectedPeople;

@end

@implementation MHAllObjects

- (instancetype)initWithRequestOptions:(MHRequestOptions *)requestOptions andDeselectedPeople:(NSArray *)deselectedPeople {
	
	self = [super init];
    
	if (self) {
        
		self.requestOptions		= ( requestOptions ? requestOptions : [[MHRequestOptions alloc] init] );
		self.deselectedPeople	= [NSSet setWithArray:( deselectedPeople ? deselectedPeople : @[] )];
		
    }
	
    return self;
	
}

- (void)setRequestOptions:(MHRequestOptions *)requestOptions {
	
	[self willChangeValueForKey:@"requestOptions"];
	_requestOptions	= [requestOptions copy];
	[self didChangeValueForKey:@"requestOptions"];
	
	_requestOptions.offset	= 0;
	_requestOptions.limit	= 0;
	
}

- (void)getPeopleListWithSuccessBlock:(void (^)(NSArray *peopleList))successBlock failBlock:(void (^)(NSError *error))failBlock {
	
	[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
									successBlock:^(NSArray *result, MHRequestOptions *options) {
										
										__block NSMutableArray *people	= [NSMutableArray array];
										
										[result enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
											
											if ([object isKindOfClass:[MHPerson class]]) {
												
												MHPerson *person	= (MHPerson *)object;
												
												if (![self.deselectedPeople findWithRemoteID:person.remoteID]) {
												
													[people addObject:person];
													
												}
												
											}
											
										}];
										
										successBlock(people);
										
									} failBlock:^(NSError *error, MHRequestOptions *options) {
										
										failBlock(error);
										
									}];
	
}

@end
