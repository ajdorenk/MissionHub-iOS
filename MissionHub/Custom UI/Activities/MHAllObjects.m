//
//  MHAllObjects.m
//  MissionHub
//
//  Created by Michael Harrison on 11/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAllObjects.h"
#import "MHAPI.h"

@interface MHAllObjects ()

@property (nonatomic, strong) NSDate *lastSync;
@property (nonatomic, assign) BOOL isDownloading;

- (void)sync;

@end

@implementation MHAllObjects

@synthesize requestOptions	= _requestOptions;
@synthesize lastSync		= _lastSync;
@synthesize isDownloading	= _isDownloading;

- (void)setRequestOptions:(MHRequestOptions *)requestOptions {
	
	[self willChangeValueForKey:@"requestOptions"];
	_requestOptions	= [requestOptions copy];
	[self didChangeValueForKey:@"requestOptions"];
	
	_requestOptions.offset	= 0;
	_requestOptions.limit	= 0;
	
	self.lastSync			= nil;
	
	[self sync];
	
}

- (void)sync {
	
	if (self.lastSync) {
		
		
		
	} else {
		
		
		
	}
	
}

- (void)getPeopleListWithSuccessBlock:(void (^)(NSArray *peopleList))successBlock failBlock:(void (^)(NSError *error))failBlock {
	
	
	
}

@end
