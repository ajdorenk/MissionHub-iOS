//
//  MHAllObjects.m
//  MissionHub
//
//  Created by Michael Harrison on 11/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAllObjects.h"

@interface MHAllObjects ()

@property (nonatomic, strong) NSDate *lastSync;

@end

@implementation MHAllObjects

@synthesize requestOptions	= _requestOptions;
@synthesize lastSync		= _lastSync;

- (void)setRequestOptions:(MHRequestOptions *)requestOptions {
	
	[self willChangeValueForKey:@"requestOptions"];
	_requestOptions	= [requestOptions copy];
	[self didChangeValueForKey:@"requestOptions"];
	
	_requestOptions.offset	= 0;
	_requestOptions.limit	= 0;
	
	self.lastSync			= nil;
	
}

@end
