//
//  MHRequest.m
//  MissionHub
//
//  Created by Michael Harrison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRequestOperation.h"
#import "MHAPI.h"

@implementation MHRequestOperation

@synthesize delegate			= _delegate;
@synthesize requestName			= _requestName;
@synthesize options				= _options;
@synthesize jsonObject			= _jsonObject;
@synthesize responseStatusCode;
@synthesize successBlock		= _successBlock;
@synthesize failBlock			= _failBlock;

+ (instancetype)operationWithRequest:(NSMutableURLRequest *)request options:(MHRequestOptions *)options andDelegate:(id<MHRequestOperationDelegate>)delegate {
	
	MHRequestOperation *selfRequestOperation = [(MHRequestOperation *)[self alloc] initWithRequest:request];
	
	selfRequestOperation.options		= options;
	selfRequestOperation.delegate		= delegate;
	selfRequestOperation.successBlock	= options.successBlock;
	selfRequestOperation.failBlock		= options.failBlock;
	
	[selfRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		MHRequestOperation *requestOperation	= (MHRequestOperation *)operation;
		
		if ([requestOperation.delegate respondsToSelector:@selector(operationDidFinish:)]) {
			
			requestOperation.jsonObject			= [requestOperation responseJSON];
			
			[delegate operationDidFinish:requestOperation];
			
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		MHRequestOperation *requestOperation	= (MHRequestOperation *)operation;
		
		if ([requestOperation.delegate respondsToSelector:@selector(operationDidFail:)]) {
			
			requestOperation.jsonObject			= [requestOperation responseJSON];
			
			[delegate operationDidFail:requestOperation];
			
		}
		
	}];
	
	return selfRequestOperation;
	
}

- (NSUInteger)responseStatusCode {
	
	if (!self.response) {
		
		return 404;
		
	}
	
    return ( [self.response isKindOfClass:[NSHTTPURLResponse class]] ? (NSUInteger)[self.response statusCode] : 200 );
	
}

@end
