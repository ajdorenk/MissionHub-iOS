//
//  MHRequest.m
//  MissionHub
//
//  Created by Michael Harrison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRequest.h"

@implementation MHRequest

- (id)initWithURL:(NSURL *)newURL {
	
	self = [super initWithURL:newURL];
	
	if (self) {
		
		self.delegate			= [MHAPI sharedInstance];
		self.didFinishSelector	= @selector(requestDidFinish:);
		self.didFailSelector	= @selector(requestDidFail:);
		[self addRequestHeader:@"HTTP_ACCEPT" value:@"application/json"];
		
	}
	
	return self;
	
}

@end
