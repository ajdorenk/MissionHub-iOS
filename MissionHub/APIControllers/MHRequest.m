//
//  MHRequest.m
//  MissionHub
//
//  Created by Michael Harrison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRequest.h"

@implementation MHRequest

@synthesize options			= _options;
@synthesize successBlock	= _successBlock;
@synthesize failBlock		= _failBlock;

- (id)initWithURL:(NSURL *)newURL {
	
	self = [super initWithURL:newURL];
	
	if (self) {
		
		self.delegate			= [MHAPI sharedInstance];
		self.didFinishSelector	= @selector(requestDidFinish:);
		self.didFailSelector	= @selector(requestDidFail:);
		self.requestMethod		= @"GET";
		[self addRequestHeader:@"HTTP_ACCEPT" value:@"application/json"];
		self.options			= nil;
		self.successBlock		= nil;
		self.failBlock			= nil;
		
	}
	
	return self;
	
}

@end
