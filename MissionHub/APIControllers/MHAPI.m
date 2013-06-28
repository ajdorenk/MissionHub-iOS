//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"
#import "MHRequest.h"

static NSString *MHAPIErrorDomain = @"com.MissionHub.API";

typedef enum {
	MHAPIErrorMissingUrl,
	MHAPIErrorMissingEndpoint,
	MHAPIErrorMissionAccessToken,
	MHAPIErrorMalformedResponse,
	MHAPIErrorServerError,
	MHAPIErrorAccessTokenError,
	MHAPIErrorAccessDenied
} MHAPIErrors;

@interface MHAPI (PrivateMethods)

-(NSString *)stringForBaseUrlWith:(MHRequestOptions *)options error:(NSError **)error;
-(void)addAccessTokenToParams:(NSMutableDictionary *)params withError:(NSError **)error;

@end

@implementation MHAPI

@synthesize queue		= _queue;
@synthesize apiUrl		= _apiUrl;
@synthesize baseUrl		= _baseUrl;
@synthesize accessToken	= _accessToken;

@synthesize currentUser	= _currentUser;
@synthesize currentOrganization	= _currentOrganization;

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

-(void)getMeWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
	
	requestOptions.endpoint = MHRequestOptionsEndpointPeople;
	[requestOptions addIncludesForMeRequest];
	
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

-(void)getOrganizationWithRemoteID:(NSNumber *)remoteID successBlock:(void (^)(NSArray *, MHRequestOptions *))successBlock failBlock:(void (^)(NSError *, MHRequestOptions *))failBlock {
	
	MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
	
	requestOptions.endpoint = MHRequestOptionsEndpointOrganizations;
	requestOptions.remoteID = [remoteID integerValue];
	[requestOptions addIncludesForOrganizationRequest];
	
	NSError *error;
	NSString *urlString = [self stringForShowRequestWith:requestOptions error:&error];
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

-(void)getLabelsForCurrentOrganizationWithSuccessBlock:(void (^)(NSArray *, MHRequestOptions *))successBlock failBlock:(void (^)(NSError *, MHRequestOptions *))failBlock {
	
	MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
	
	requestOptions.endpoint = MHRequestOptionsEndpointLabels;
	
	NSError *error;
	NSString *urlString = [self stringForShowRequestWith:requestOptions error:&error];
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

-(void)getProfileForRemoteID:(NSNumber *)remoteID WithSuccessBlock:(void (^)(NSArray *, MHRequestOptions *))successBlock failBlock:(void (^)(NSError *, MHRequestOptions *))failBlock {
	
	MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
	
	requestOptions.endpoint = MHRequestOptionsEndpointPeople;
	requestOptions.remoteID = [remoteID integerValue];
	[requestOptions addIncludesForProfileRequest];
	
	NSError *error;
	NSString *urlString = [self stringForShowRequestWith:requestOptions error:&error];
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
	
	NSError *error;
	__block NSMutableArray *modelArray = [NSMutableArray array];
	__block NSString *nameOfClassForEndpoint = [NSString stringWithFormat:@"MH%@", [[request.options stringInSingluarFormatForEndpoint] capitalizedString]];
	
	//parse response and put into result dictionary
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
	
	//if there was a parsing error stop updating model and notify calling method of the error through the fail block
	if (error) {
		
		if (request.failBlock) {
			request.failBlock(error, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:error];
		}
		
	}
	
	//try creating and filling model objects. These use key value coding to set values in the model objects which means if the field names in the response json change then it will throw an exception. We want to catch that.
	@try {
	
		
		
		//if the root of the response is the singular form of the endpoint's name then the root will hold one object matching the type of the endpoint. So we put that object into a model object and put it in the model array.
		if ([[[result allKeys] objectAtIndex:0] isEqualToString:[request.options stringInSingluarFormatForEndpoint]]) {
			
			NSDictionary *responseObject = [result objectForKey:[request.options stringInSingluarFormatForEndpoint]];
			
			id modelObject = [MHModel newObjectForClass:nameOfClassForEndpoint fromFields:responseObject];
			
			[modelArray addObject:modelObject];
			
		} else if ([[[result allKeys] objectAtIndex:0] isEqualToString:[request.options stringForEndpoint]]) {
			
			__block NSArray *arrayOfResponseObjects = [result objectForKey:[request.options stringForEndpoint]];
			
			[arrayOfResponseObjects enumerateObjectsUsingBlock:^(id responseObject, NSUInteger index, BOOL *stop) {
				
				id modelObject = [MHModel newObjectForClass:nameOfClassForEndpoint fromFields:responseObject];
				
				[modelArray addObject:modelObject];
				
			}];
			
		} else {
			
			error = [NSError errorWithDomain:MHAPIErrorDomain
										code:MHAPIErrorMalformedResponse
									userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has incorrect name for root element. It should match the name of the endpoint. Please contact support@missionhub.com", @"Response JSON object has incorrect name for root element. It should match the name of the endpoint. Please contact support@missionhub.com")}];
			
			if (request.failBlock) {
				request.failBlock(error, request.options);
			} else {
				//if no fail block show the error anyway
				[MHErrorHandler presentError:error];
			}
			
		}
		
		
		
	}
	@catch (NSException *exception) {
		
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorMalformedResponse
								userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com", @"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com")}];
		
		if (request.failBlock) {
			request.failBlock(error, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:error];
		}
		
		
	}
	@finally {
		//nothing to clean up with ARC. YAY!
	}
	
	//call success block if it exists so that the calling method can access the result
	if (request.successBlock) {
		request.successBlock(modelArray, request.options);
	} else {
		//if no fail block show the error anyway
		[MHErrorHandler presentError:error];
	}
	
}

-(void)requestDidFail:(MHRequest *)request {
	
	NSError *error, *responseError;
	
	//parse response and put into result dictionary
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
	
	//if there was a parsing error stop updating model and notify calling method of the error through the fail block
	if (error) {
		
		if (request.failBlock) {
			request.failBlock(error, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:error];
		}
		
	}
	
	//parse errors and put into NSError object
	@try {
		
		
		
		//if the root of the response is the singular form of the endpoint's name then the root will hold one object matching the type of the endpoint. So we put that object into a model object and put it in the model array.
		if ([[[result allKeys] objectAtIndex:0] isEqualToString:@"errors"]) {
			
			NSInteger errorCode = MHAPIErrorServerError;
			id errorMessage		= [[result objectForKey:@"errors"] objectAtIndex:0];
			
			if ([[[result allKeys] objectAtIndex:1] isEqualToString:@"code"]) {
				
				id code = [[result objectForKey:@"code"] objectAtIndex:1];
				
				if ([code isEqualToString:@"invalid_facebook_token"]) {
					
					errorCode = MHAPIErrorAccessTokenError;
					
				} else if ([code isEqualToString:@"access_denied"]) {
					
					errorCode = MHAPIErrorAccessTokenError;
					
				}
				
				responseError = [NSError errorWithDomain:MHAPIErrorDomain
													code:errorCode
												userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
				
			}
			
		} else {
			
			error = [NSError errorWithDomain:MHAPIErrorDomain
										code:MHAPIErrorMalformedResponse
									userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response did not contain a valid error. Please contact support@missionhub.com", @"Response did not contain a valid error. Please contact support@missionhub.com")}];
			
			if (request.failBlock) {
				request.failBlock(error, request.options);
			} else {
				//if no fail block show the error anyway
				[MHErrorHandler presentError:error];
			}
			
		}
		
		
		
	}
	@catch (NSException *exception) {
		
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorMalformedResponse
								userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com", @"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com")}];
		
		if (request.failBlock) {
			request.failBlock(error, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:error];
		}
		
		
	}
	@finally {
		//nothing to clean up with ARC. YAY!
	}
	
	//call fail block if it exists so that the calling method can access the result
	if (request.failBlock) {
		request.failBlock(responseError, request.options);
	} else {
		//if no fail block show the error anyway
		[MHErrorHandler presentError:responseError];
	}
	
}

#pragma mark - Private Methods

-(NSString *)stringForBaseUrlWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString = [self apiUrl];
	
	if (urlString == nil || [urlString length] <= 0 ) {
		
		if (error) {
			*error = [NSError errorWithDomain:MHAPIErrorDomain
										 code:MHAPIErrorMissingUrl
									 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"API URL Missing", @"API URL Missing")}];
		}
		
		return nil;
	}
	
	if (options.endpoint) {
		
		urlString = [urlString stringByAppendingFormat:@"/%@", [options stringForEndpoint]];
		
	} else {
		
		if (error) {
			*error = [NSError errorWithDomain:MHAPIErrorDomain
										 code:MHAPIErrorMissingEndpoint
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
			*error = [NSError errorWithDomain:MHAPIErrorDomain
										 code:MHAPIErrorMissionAccessToken
									 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"API token Missing. You must login first.", @"API token Missing. You must login first.")}];
		}
	
	}

	return;

}

@end
