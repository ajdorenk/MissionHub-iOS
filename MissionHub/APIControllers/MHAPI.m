//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"

@interface MHAPI (PrivateMethods)

-(NSString *)stringForBaseUrlWith:(MHRequestOptions *)options error:(NSError **)error;
-(void)addFacebookTokenToParams:(NSMutableDictionary *)params withError:(NSError **)error;

@end

@implementation MHAPI

@synthesize apiUrl;
@synthesize baseUrl;
@synthesize accessToken;

+ (MHAPI *)sharedInstance
{
	static MHAPI *sharedInstance;
	
	@synchronized(self)
	{
		if (!sharedInstance)
			sharedInstance = [[MHAPI alloc] init];
		
		return sharedInstance;
	}
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		
		NSString *pathToConfigFile		= [[NSBundle mainBundle] pathForResource:@"conig" ofType:@"plist"];
		NSDictionary *configDictionary	= [NSDictionary dictionaryWithContentsOfFile:pathToConfigFile];
		
		self.baseUrl					= [configDictionary valueForKey:@"base_url"];
		self.apiUrl						= [configDictionary valueForKey:@"api_url"];
		self.accessToken				= @"CAADULZADslC0BALRH2Sk20bELjdMtQSl943Le7wwofpVzyF1DwZBgcQzkspboiOmZCNc3bZCugwMdE8QKtFqpOzcetJfcj5OEfwZCJIuE09RYnncz9DMFAbNLJuZCo0yjZCRZA9iYOoLLynI6jlXsXSYicPqZC9renHvdoaZABwz18FwZDZD";
		
		if (self.baseUrl == nil) {
				
			self.baseUrl = @"";
				
		}
			
		if (self.apiUrl == nil) {
				
			self.apiUrl = @"";
				
		}
		
    }
    return self;
}

-(NSString *)stringForShowRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	__block NSString *urlString	= [self stringForBaseUrlWith:options error:error];
	NSMutableDictionary	*params	= [[NSMutableDictionary alloc] init];
	
	if (*error) {
		return nil;
	}
	
	if ([options hasRemoteID]) {
		
		urlString = [urlString stringByAppendingFormat:@"/%d?", options.remoteID];
		
	}
	
	if ([options hasIncludes]) {
		
		[params setValue:[options stringForIncludes] forKey:@"include"];
		
	}
	
	[self addFacebookTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	return urlString;
}

-(NSString *)stringForIndexRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString			*urlString	= [self stringForBaseUrlWith:options error:error];
	NSMutableDictionary	*params		= [[NSMutableDictionary alloc] init];

	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:@"?"];
	
	if ([options hasIncludes]) {
			
		[params setValue:[options stringForIncludes] forKey:@"include"];
			
	}
	
	if ([options hasLimit]) {
		
		[params setValue:[options stringForLimit] forKey:@"limit"];
		
	}
	
	if ([options hasOffset]) {
		
		[params setValue:[options stringForOffset] forKey:@"offset"];
		
	}
	
	if ([options hasOrder]) {
		
		[params setValue:[options stringForOrder] forKey:@"order"];
		
	}
	
	[self addFacebookTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	return urlString;
}

-(void)requestDidFinish:(MHRequest *)request {
	
#warning Need to implement general request finished selector
	
}

-(void)requestDidFail:(MHRequest *)request {
	
#warning Need to implement general request failed selector
	
}

#pragma mark - Private Methods

-(NSString *)stringForBaseUrlWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString = [self apiUrl];
	
	if (urlString == nil || [urlString length] <= 0 ) {
		
		if (error) {
			*error = [NSError errorWithDomain:@"com.MissionHub.API"
										 code:1
									 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"API URL Missing", @"API URL Missing")}];
		}
		
		return nil;
	}
	
	if (options.endpoint) {
		
		urlString = [urlString stringByAppendingFormat:@"/%@", [options stringForEndpoint]];
		
	} else {
		
		if (error) {
			*error = [NSError errorWithDomain:@"com.MissionHub.API"
										 code:2
									 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"API Endpoint Missing", @"API Endpoint Missing")}];
		}
		
		return nil;
	}
	
	return urlString;
	
}

-(void)addFacebookTokenToParams:(NSMutableDictionary *)params withError:(NSError **)error {
	
	if ([self accessToken]) {
		
		[params setValue:self.accessToken forKey:@"facebook_token"];
		
	} else {
		
		if (error) {
			*error = [NSError errorWithDomain:@"com.MissionHub.API"
										 code:3
									 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"API token Missing. You must login to facebook first.", @"API token Missing. You must login to facebook first.")}];
		}
	
	}

	return;

}

@end
