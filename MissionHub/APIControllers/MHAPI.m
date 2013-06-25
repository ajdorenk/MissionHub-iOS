//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"
#import "MHRequest.h"

@interface MHAPI (PrivateMethods)

-(NSString *)stringForBaseUrlWith:(MHRequestOptions *)options error:(NSError **)error;
-(void)addAccessTokenToParams:(NSMutableDictionary *)params withError:(NSError **)error;

@end

@implementation MHAPI

@synthesize queue		= _queue;
@synthesize apiUrl		= _apiUrl;
@synthesize baseUrl		= _baseUrl;
@synthesize accessToken	= _accessToken;

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
		
		NSString *pathToConfigFile		= [[NSBundle mainBundle] pathForResource:@"config_lwi" ofType:@"plist"];
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
		
		self.queue = [[NSOperationQueue alloc] init];
		
    }
    return self;
}

-(void)fetchMeWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = (options ? options : [[MHRequestOptions alloc] init]);
	
	requestOptions.endpoint = MHRequestOptionsEndpointPeople;
	
	NSError *error;
	NSString *urlString = [self stringForMeRequestWith:requestOptions error:&error];
	NSLog(@"%@", urlString);
	if (error) {
		[MHErrorHandler presentError:error];
		return;
	}
	
	MHRequest *request			= [[MHRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	request.delegate			= self;
	request.options				= requestOptions;
	request.successBlock		= successBlock;
	request.failBlock			= failBlock;
	
	[self.queue addOperation:request];
}

-(NSString *)stringForMeRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString	= [self stringForBaseUrlWith:options error:error];
	NSMutableDictionary	*params	= [[NSMutableDictionary alloc] init];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:@"/me?"];
	
	if ([options hasIncludes]) {
		
		[params setValue:[options stringForIncludes] forKey:@"include"];
		
	}
	
	[self addAccessTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	return urlString;
}

-(NSString *)stringForShowRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString	= [self stringForBaseUrlWith:options error:error];
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
	
	[self addAccessTokenToParams:params withError:error];
	
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
	
	if ([options hasFilters]) {
		
		[urlString stringByAppendingString:[options stringForFilters]];
		
	}
	
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
	
	[self addAccessTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	return urlString;
}

-(NSString *)stringForCreateRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString	= [self stringForBaseUrlWith:options error:error];
	NSMutableDictionary	*params	= [[NSMutableDictionary alloc] init];
	
	if (*error) {
		return nil;
	}
	
	[self addAccessTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	return urlString;
}

-(NSString *)stringForUpdateRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	return [self stringForUpdateOrDeleteRequestWith:options error:error];
}

-(NSString *)stringForDeleteRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	return [self stringForUpdateOrDeleteRequestWith:options error:error];
}

-(NSString *)stringForUpdateOrDeleteRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString	= [self stringForBaseUrlWith:options error:error];
	NSMutableDictionary	*params	= [[NSMutableDictionary alloc] init];
	
	if (*error) {
		return nil;
	}
	
	if ([options hasRemoteID]) {
		
		urlString = [urlString stringByAppendingFormat:@"/%d?", options.remoteID];
		
	}
	
	[self addAccessTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	return urlString;
}

-(void)requestDidFinish:(MHRequest *)request {
	
#warning Need to implement general request finished selector
	
	NSMutableArray *resultArray = [NSMutableArray array];
	
	//parse response and put into result array
	
	//call success block if it exists so that the calling method can access the result
	if (request.successBlock) {
		request.successBlock(resultArray, request.options);
	}
	
}

-(void)requestDidFail:(MHRequest *)request {
	
#warning Need to implement general request failed selector
	
	NSError *error;
	
	//parse errors and put into NSError object
	
	//call fail block if it exists so that the calling method can access the result
	if (request.failBlock) {
		request.failBlock(error, request.options);
	}
	
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

-(void)addAccessTokenToParams:(NSMutableDictionary *)params withError:(NSError **)error {
	
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
