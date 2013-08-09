//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"
#import "AFHTTPClient.h"
#import "MHRequestOperation.h"
#import "MHPerson+Helper.h"

NSString *const MHAPIErrorDomain = @"com.missionhub.errorDomain.API";
NSString *const MHAPIRequestNameMe = @"com.missionhub.API.requestName.me";
NSString *const MHAPIRequestNameCurrentOrganization = @"com.missionhub.API.requestName.currentOrganization";
NSString *const MHAPIRequestNameInitialPeopleList = @"com.missionhub.API.requestName.initialPeopleList";

typedef enum {
	MHAPIErrorCouldNotRetrieveCurrentUser,
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

@synthesize surveyURL;
@synthesize accessToken;

@synthesize currentUser;
@synthesize currentOrganization;
@synthesize _anonymous;
@synthesize initialPeopleList;
@synthesize currentOrganizationIsFinished;
@synthesize initialPeopleListIsFinished;
@synthesize errorForInitialRequests;

+ (MHAPI *)sharedInstance {
	
	static MHAPI *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		NSString *configFilePath		= [[NSBundle mainBundle] pathForResource:@"config_dev" ofType:@"plist"];
		NSDictionary *configDictionary	= [NSDictionary dictionaryWithContentsOfFile:configFilePath];
		
		NSString *baseUrlString			= ( [configDictionary valueForKey:@"api_url"] ? [configDictionary valueForKey:@"api_url"] : @"" );
		NSString *surveyUrlString		= ( [configDictionary valueForKey:@"survey_url"] ? [configDictionary valueForKey:@"survey_url"] : @"" );
		
		NSURL *baseURL					= [NSURL URLWithString:baseUrlString];
		NSURL *surveyURL				= [NSURL URLWithString:surveyUrlString];
		
		sharedInstance					= [[MHAPI alloc] initWithBaseURL:baseURL andSurveyURL:surveyURL];
		
	});
	
	return sharedInstance;
		
}

- (id)initWithBaseURL:(NSURL *)url andSurveyURL:(NSURL *)surveyUrl {
	
    self = [super initWithBaseURL:url];
	
    if (self) {
        // Custom initialization
		
		self.surveyURL					= surveyUrl;
		self.accessToken				= @"CAADULZADslC0BALRH2Sk20bELjdMtQSl943Le7wwofpVzyF1DwZBgcQzkspboiOmZCNc3bZCugwMdE8QKtFqpOzcetJfcj5OEfwZCJIuE09RYnncz9DMFAbNLJuZCo0yjZCRZA9iYOoLLynI6jlXsXSYicPqZC9renHvdoaZABwz18FwZDZD";
		
    }
    return self;
}

- (MHPerson *)anonymous {
	
	return [MHPerson newObjectFromFields:@{
			@"id": @0,
			@"first_name": @"Anonymous"
			}];
	
}

- (NSMutableURLRequest *)requestWithOptions:(MHRequestOptions *)options {
	
	return [self requestWithMethod:[options method]
							  path:[options path]
						parameters:[options parameters]];
	
}

- (void)getResultWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= (options ? options : [[MHRequestOptions alloc] init]);
	requestOptions.successBlock			= successBlock;
	requestOptions.failBlock			= failBlock;
	
	NSMutableURLRequest *request		= [self requestWithOptions:requestOptions];
    MHRequestOperation *operation		= [MHRequestOperation operationWithRequest:request options:requestOptions andDelegate:self];
    [self enqueueHTTPRequestOperation:operation];
	
	
}

-(void)getMeWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForMeRequest];
	
	NSError *error;
	NSString *urlString = [self stringForMeRequestWith:requestOptions error:&error];
	NSLog(@"%@", urlString);
	if (error) {
		[MHErrorHandler presentError:error];
		return;
	}
	
	MHRequestOperation *request			= [[MHRequestOperation alloc] initWithURL:[NSURL URLWithString:urlString]];
	request.requestName			= MHAPIRequestNameMe;
	request.delegate			= self;
	request.options				= requestOptions;
	request.successBlock		= successBlock;
	request.failBlock			= failBlock;
	
	[self.queue addOperation:request];
}

-(void)getOrganizationWithRemoteID:(NSNumber *)remoteID successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= [[[MHRequestOptions alloc] init] configureForOrganizationRequestWithRemoteID:remoteID];
	
	NSError *error;
	NSString *urlString = [self stringForShowRequestWith:requestOptions error:&error];
	NSLog(@"%@", urlString);
	if (error) {
		[MHErrorHandler presentError:error];
		return;
	}
	
	MHRequestOperation *request			= [[MHRequestOperation alloc] initWithURL:[NSURL URLWithString:urlString]];
	request.delegate			= self;
	request.options				= requestOptions;
	request.successBlock		= successBlock;
	request.failBlock			= failBlock;
	
	[self.queue addOperation:request];
}

-(void)getCurrentOrganizationWith:(MHUser *)user successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= [[[MHRequestOptions alloc] init] configureForOrganizationRequestWithRemoteID:user.primary_organization_id];
	self.currentOrganizationIsFinished = NO;
	
	NSError *error;
	NSString *urlString = [self stringForShowRequestWith:requestOptions error:&error];
	NSLog(@"%@", urlString);
	if (error) {
		[MHErrorHandler presentError:error];
		return;
	}
	
	MHRequestOperation *request			= [[MHRequestOperation alloc] initWithURL:[NSURL URLWithString:urlString]];
	request.requestName			= MHAPIRequestNameCurrentOrganization;
	request.delegate			= self;
	request.options				= requestOptions;
	request.successBlock		= successBlock;
	request.failBlock			= failBlock;
	
	[self.queue addOperation:request];
	
}

-(void)getPeopleListWith:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions;
	NSString *requestName;
	
	if (options) {
		requestOptions = options;
	} else {
		requestOptions = [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
		requestName = MHAPIRequestNameInitialPeopleList;
		self.initialPeopleListIsFinished = NO;
	}
	
	NSError *error;
	NSString *urlString = [self stringForIndexRequestWith:requestOptions error:&error];
	NSLog(@"%@", urlString);
	if (error) {
		[MHErrorHandler presentError:error];
		return;
	}
	
	MHRequestOperation *request			= [[MHRequestOperation alloc] initWithURL:[NSURL URLWithString:urlString]];
	
	if (requestName) {
		request.requestName			= requestName;
	}
	
	request.delegate			= self;
	request.options				= requestOptions;
	request.successBlock		= successBlock;
	request.failBlock			= failBlock;
	
	[self.queue addOperation:request];
	
}

-(void)getProfileForRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForProfileRequestWithRemoteID:remoteID];
	
	NSError *error;
	NSString *urlString = [self stringForShowRequestWith:requestOptions error:&error];
	NSLog(@"%@", urlString);
	if (error) {
		[MHErrorHandler presentError:error];
		return;
	}
	
	MHRequestOperation *request			= [[MHRequestOperation alloc] initWithURL:[NSURL URLWithString:urlString]];
	request.delegate			= self;
	request.options				= requestOptions;
	request.successBlock		= successBlock;
	request.failBlock			= failBlock;
	
	[self.queue addOperation:request];
	
}

-(void)getInteractionsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForInteractionRequestForPersonWithRemoteID:remoteID];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

-(void)createInteraction:(MHInteraction *)interaction withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	__block MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForCreateInteractionRequest];
	NSError *error;
	
	NSDictionary *postDictionary	= [interaction jsonObject];
	//[requestOptions addPostParam:[requestOptions stringInSingluarFormatForEndpoint] withValue:postDictionary];
	//requestOptions.postData		= [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
	requestOptions.jsonString		= [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error] encoding:NSUTF8StringEncoding];
	/*
	AFHTTPClient *apiClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.apiUrl]];
	[apiClient setDefaultHeader:@"Accept" value:@"application/json"];
	apiClient.parameterEncoding = AFJSONParameterEncoding;
	[apiClient postPath:[NSString stringWithFormat:@"/apis/v3/%@?facebook_token=%@", [requestOptions stringForEndpoint], self.accessToken]
			 parameters:postDictionary
				success:^(AFHTTPRequestOperation *operation, id responseObject) {
					NSLog(@"%@", responseObject);
				}
				failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					[MHErrorHandler presentError:error];
				}];
	*/
	NSLog(@"%@", requestOptions.jsonString);
	
	//handles error here (instead of handleError:forRequest:) because the request has not yet been created
	if (error) {
		
		if (failBlock) {
			failBlock(error, requestOptions);
		} else {
			[MHErrorHandler presentError:error];
		}
		
	} else {
		
		[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
		
	}
	
}
/*
{
	"interaction"=> {
		"comment"=>"This is an interaction creation test. 3.",
		"created_at"=>"2013-08-07T17:55:02-04:00",
		"created_by_id"=>"2033631",
		"initiator_ids"=>["2033631"],
		"interaction_type_id"=>"1",
		"privacy_setting"=>"everyone",
		"receiver_id"=>"2594597",
		"timestamp"=>"2013-08-07T17:55:02-04:00",
		"updated_at"=>"2013-08-07T17:55:02-04:00",
		"updated_by_id"=>"2033631"
	},
	"facebook_token"=>"CAADULZADslC0BALRH2Sk20bELjdMtQSl943Le7wwofpVzyF1DwZBgcQzkspboiOmZCNc3bZCugwMdE8QKtFqpOzcetJfcj5OEfwZCJIuE09RYnncz9DMFAbNLJuZCo0yjZCRZA9iYOoLLynI6jlXsXSYicPqZC9renHvdoaZABwz18FwZDZD"
}
 */

-(NSURL *)urlForSurveyWith:(NSNumber *)remoteID {
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"/%@", remoteID] relativeToURL:self.surveyURL];
	
	return url;
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
	
	if ([options hasOrderField] && [options hasOrderDirection]) {
		
		[params setValue:[options stringForOrders] forKey:@"order"];
		
	}
	
	[self addAccessTokenToParams:params withError:error];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:[params urlEncodedString]];
	
	if ([options hasFilters]) {
		
		urlString = [urlString stringByAppendingString:[options stringForFilters]];
		
	}
	
	return urlString;
}

-(NSString *)stringForCreateRequestWith:(MHRequestOptions *)options error:(NSError **)error {
	
	NSString *urlString	= [self stringForBaseUrlWith:options error:error];
	NSMutableDictionary	*params	= [[NSMutableDictionary alloc] init];
	
	if (*error) {
		return nil;
	}
	
	urlString = [urlString stringByAppendingString:@"?"];
	
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

-(void)requestDidFinish:(MHRequestOperation *)request {
	
	NSError *error;
	__block NSMutableArray *modelArray = [NSMutableArray array];
	__block NSString *nameOfClassForEndpoint = [request.options classNameForEndpoint];
	NSDictionary *result = nil;
	
	//try parsing, creating and filling model objects. These use key value coding to set values in the model objects which means if the field names in the response json change then it will throw an exception. We want to catch that.
	//@try {

		if (request.responseStatusCode > 201) {
			
			[self requestDidFail:request];
			return;
			
		}
		
		//parse response and put into result dictionary
		result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
		
		//if there was a parsing error stop updating model and notify calling method of the error through the fail block
		if (error) {
			
			if (request.failBlock) {
				request.failBlock(error, request.options);
			} else {
				//if no fail block show the error anyway
				[MHErrorHandler presentError:error];
			}
			
			return;
			
		}
		
		
		//if the root of the response is the singular form of the endpoint's name then the root will hold one object matching the type of the endpoint. So we put that object into a model object and put it in the model array.
		if ([[[result allKeys] objectAtIndex:0] isEqualToString:[request.options stringInSingluarFormatForEndpoint]]) {

			NSDictionary *responseObject = [result objectForKey:[request.options stringInSingluarFormatForEndpoint]];
			
			id modelObject = [MHModel newObjectForClass:nameOfClassForEndpoint fromFields:responseObject];
			
			[modelArray addObject:modelObject];
			
		} else if ([[[result allKeys] objectAtIndex:0] isEqualToString:[request.options stringForEndpoint]]) {
			
			__block NSArray *arrayOfResponseObjects = [result objectForKey:[request.options stringForEndpoint]];
			
			//if changed you need to also change in the request options MHRequestOptions configureForInitialContactAssignmentsPageRequestWithAssignedToID:
			if ([request.options.requestName isEqualToString:@"contactAssignmentFilter"]) {
				
				[arrayOfResponseObjects enumerateObjectsUsingBlock:^(id responseObject, NSUInteger index, BOOL *stop) {
					
					id modelObject = [MHModel newObjectForClass:[request.options classNameFromEndpoint:MHRequestOptionsEndpointPeople]
													 fromFields:[responseObject objectForKey:[request.options stringFromInclude:MHRequestOptionsIncludeConactAssignmentsPerson]]];
					
					[modelArray addObject:modelObject];
					
				}];
				
			} else {
			
				[arrayOfResponseObjects enumerateObjectsUsingBlock:^(id responseObject, NSUInteger index, BOOL *stop) {
					
					id modelObject = [MHModel newObjectForClass:nameOfClassForEndpoint fromFields:responseObject];
					
					[modelArray addObject:modelObject];
					
				}];
				
			}
			
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
			
			return;
			
		}
	
		//deal with result
		if ([request.requestName isEqualToString:MHAPIRequestNameMe]) {
			
			self.currentUser = [modelArray objectAtIndex:0];
			self.errorForInitialRequests = nil;
			
			[self getCurrentOrganizationWith:self.currentUser.user successBlock:request.successBlock failBlock:request.failBlock];
			[self getPeopleListWith:nil successBlock:request.successBlock failBlock:request.failBlock];
			
		} else if ([request.requestName isEqualToString:MHAPIRequestNameCurrentOrganization]) {
			
			self.currentUser.currentOrganization	= [modelArray objectAtIndex:0];
			self.currentOrganization				= self.currentUser.currentOrganization;
			self.currentOrganizationIsFinished		= YES;
			
			if (self.initialPeopleListIsFinished) {
				
				if (self.errorForInitialRequests) {
					
					NSArray *returnArray = @[self.currentUser, self.errorForInitialRequests];
					
					//call success block if it exists so that the calling method can access the result
					if (request.successBlock) {
						request.successBlock(returnArray, request.options);
					}
					
				} else {
					
					NSArray *returnArray = @[self.currentUser, self.initialPeopleList];
					
					//call success block if it exists so that the calling method can access the result
					if (request.successBlock) {
						request.successBlock(returnArray, request.options);
					}
					
				}
				
			}
			
		} else if ([request.requestName isEqualToString:MHAPIRequestNameInitialPeopleList]) {
			
			self.initialPeopleList = modelArray;
			self.initialPeopleListIsFinished = YES;
			
			if (self.currentOrganizationIsFinished) {
				
				if (!self.errorForInitialRequests) {
				
					NSArray *returnArray = @[self.currentUser, self.initialPeopleList];
					
					//call success block if it exists so that the calling method can access the result
					if (request.successBlock) {
						request.successBlock(returnArray, request.options);
					}
					
				}
				
			}
			
		} else {
			
			//call success block if it exists so that the calling method can access the result
			if (request.successBlock) {
				request.successBlock(modelArray, request.options);
			}
			
		}
		
		
	/*
	}
	@catch (NSException *exception) {
		
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorMalformedResponse
								userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com", @"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com")}];
		
	 [self handleError:error forRequest:request];
	 return;
		
		
	}
	@finally {
		//nothing to clean up with ARC. YAY!
		return;
	}
	*/
	
}
/*
{
	"interaction"=> {
		"initiator_ids"=>[2033631],
		"updated_by_id"=>2033631,
		"created_by_id"=>2033631,
		"privacy_setting"=>"everyone",
		"updated_at"=>"2013-08-07T16:00:37-04:00",
		"timestamp"=>"2013-08-07T16:00:37-04:00",
		"comment"=>"This is an interaction creation test. 1",
		"created_at"=>"2013-08-07T16:00:37-04:00",
		"receiver_id"=>2594597,
		"interaction_type_id"=>1
	},
	"facebook_token"=>"CAADULZADslC0BALRH2Sk20bELjdMtQSl943Le7wwofpVzyF1DwZBgcQzkspboiOmZCNc3bZCugwMdE8QKtFqpOzcetJfcj5OEfwZCJIuE09RYnncz9DMFAbNLJuZCo0yjZCRZA9iYOoLLynI6jlXsXSYicPqZC9renHvdoaZABwz18FwZDZD"
}

{
	{
		"interaction" : {
			"initiator_ids" : {
				2033631
				{,
					"updated_by_id" : 2033631,
					"created_by_id" : 2033631,
					"privacy_setting" : "everyone",
					"updated_at" : "2013-08-07T16:00:37-04:00",
					"timestamp" : "2013-08-07T16:00:37-04:00",
					"comment" : "This is an interaction creation test. 1",
					"created_at" : "2013-08-07T16:00:37-04:00",
					"receiver_id" : 2594597,
					"interaction_type_id" : 1
				}
			}
			=>nil}
	},
	"facebook_token"=>"CAADULZADslC0BALRH2Sk20bELjdMtQSl943Le7wwofpVzyF1DwZBgcQzkspboiOmZCNc3bZCugwMdE8QKtFqpOzcetJfcj5OEfwZCJIuE09RYnncz9DMFAbNLJuZCo0yjZCRZA9iYOoLLynI6jlXsXSYicPqZC9renHvdoaZABwz18FwZDZD"
}

{"interaction" : {"initiator_ids" : [2033631],"updated_by_id" : 2033631,"created_by_id" : 2033631,"privacy_setting" : "everyone","updated_at" : "2013-08-07T16:00:37-04:00","timestamp" : "2013-08-07T16:00:37-04:00","comment" : "This is an interaction creation test. 1","created_at" : "2013-08-07T16:00:37-04:00","receiver_id" : 2594597,"interaction_type_id" : 1}}
*/
-(void)requestDidFail:(MHRequestOperation *)request {
	
	NSError *error, *responseError;
	NSInteger errorCode	= request.responseStatusCode;
	NSString *errorMessage = @"";
	
	//parse errors and put into NSError object
	@try {
		
		if (request.responseStatusCode == 400 || request.responseStatusCode == 401 || request.responseStatusCode == 404 || request.responseStatusCode == 422 || request.responseStatusCode == 500) {
		
			switch (request.responseStatusCode) {
				case 400:
					errorMessage = [errorMessage stringByAppendingString:@"Bad Request: "];
				case 401:
					errorMessage = [errorMessage stringByAppendingString:@"Unauthorized Request: "];
				case 404:
					errorMessage = [errorMessage stringByAppendingString:@"The requested resource could not be found."];
					break;
				case 422:
					errorMessage = [errorMessage stringByAppendingString:@"Unprocessable Entity: "];
					break;
				case 500:
					errorMessage = [errorMessage stringByAppendingString:@"Server Error: The server encountered an unexpected condition which prevented it from fulfilling the request. Please report what happened to support@missionhub.com"];
					break;
					
				default:
					break;
			}
			
			if (request.responseStatusCode == 400 || request.responseStatusCode == 401 || request.responseStatusCode == 422) {
				
				NSString *responseErrorString;
				
				//parse response and put into result dictionary
				NSDictionary *result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
				
				//if there was a parsing error stop updating model and notify calling method of the error through the fail block
				if (error) {
					
					responseError = [NSError errorWithDomain:MHAPIErrorDomain
												code:MHAPIErrorMalformedResponse
											userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response did not contain a readable error message. Please contact support@missionhub.com", nil)}];
					
					[self handleError:responseError forRequest:request];
					return;
					
				}
				
				//if the root of the response is the singular form of the endpoint's name then the root will hold one object matching the type of the endpoint. So we put that object into a model object and put it in the model array.
				if ([[[result allKeys] objectAtIndex:0] isEqualToString:@"errors"]) {
					
					responseErrorString	= [[result objectForKey:@"errors"] objectAtIndex:0];
					
					if ([[[result allKeys] objectAtIndex:1] isEqualToString:@"code"]) {
						
						id code = [[result objectForKey:@"code"] objectAtIndex:1];
						
						if ([code isEqualToString:@"invalid_facebook_token"]) {
							
							errorCode = MHAPIErrorAccessTokenError;
							
						}
						
					}
				
				}
				
				if (responseErrorString) {
					
					errorMessage = [errorMessage stringByAppendingFormat:@" %@", responseErrorString];
					
				}
				
			}
			
			responseError = [NSError errorWithDomain:MHAPIErrorDomain
												code:errorCode
											userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
			
			[self handleError:responseError forRequest:request];
			return;
			
		} else {
	
			//if there is a connection error and the request has dealt with the error then return that error
			if (request.error) {
				
				responseError = request.error;
			
			//otherwise parse the error
			} else {
					
				responseError = [NSError errorWithDomain:MHAPIErrorDomain
											code:MHAPIErrorMalformedResponse
										userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response did not contain a valid error. Please contact support@missionhub.com", @"Response did not contain a valid error. Please contact support@missionhub.com")}];
				
				[self handleError:responseError forRequest:request];
				return;
					
			}
			
		}
		
		
		
	}
	@catch (NSException *exception) {
		
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorMalformedResponse
								userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com", @"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com")}];

		[self handleError:responseError forRequest:request];
		return;
		
		
	}
	@finally {
		//nothing to clean up with ARC. YAY!
	}
	
	[self handleError:responseError forRequest:request];
	return;
	
}

-(void)handleError:(NSError *)error forRequest:(MHRequestOperation *)request {
	
	if ([request.requestName isEqualToString:MHAPIRequestNameMe]) {
		
		NSString *errorMessage = [NSString stringWithFormat:@"Initial Load Failed due to error: %@ Please try reloading the initial data. Please contact support@missionhub.com if the problem continues.", [error localizedDescription]];
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorCouldNotRetrieveCurrentUser
								userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage,nil)}];
		
		//call fail block if it exists so that the calling method can access the result
		if (request.failBlock) {
			request.failBlock(error, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:self.errorForInitialRequests];
		}
		
	} else if ([request.requestName isEqualToString:MHAPIRequestNameCurrentOrganization]) {
		
		NSString *errorMessage = [NSString stringWithFormat:@"Initial Load Failed due to error: %@ Please try reloading the initial data. Please contact support@missionhub.com if the problem continues.", [error localizedDescription]];
		
		self.currentOrganizationIsFinished = YES;
		
		self.errorForInitialRequests = [NSError errorWithDomain:MHAPIErrorDomain
														   code:MHAPIErrorCouldNotRetrieveCurrentUser
													   userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage,nil)}];
		
		//call fail block if it exists so that the calling method can access the result
		if (request.failBlock) {
			request.failBlock(self.errorForInitialRequests, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:self.errorForInitialRequests];
		}
		
		if (self.initialPeopleListIsFinished) {
			
			self.errorForInitialRequests = nil;
			
		}
		
		
	} else if ([request.requestName isEqualToString:MHAPIRequestNameInitialPeopleList]) {
		
		self.initialPeopleListIsFinished = YES;
		
		if (self.currentOrganizationIsFinished) {
			
			if (self.errorForInitialRequests) {
				
				self.errorForInitialRequests = nil;
				
			} else {
			
				NSString *errorMessage = [NSString stringWithFormat:@"Initial Load could not retreive your contacts due to error: %@ Please try reloading the contact list but pulling down on the list. Please contact support@missionhub.com if the problem continues.", [error localizedDescription]];
				
				self.errorForInitialRequests = [NSError errorWithDomain:MHAPIErrorDomain
																   code:MHAPIErrorCouldNotRetrieveCurrentUser
															   userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage,nil)}];
				
				NSArray *returnArray = @[self.currentUser, self.errorForInitialRequests];
					
				//call success block if it exists so that the calling method can access the result
				if (request.successBlock) {
					request.successBlock(returnArray, request.options);
				}
				
			}
			
		} else {
			
			NSString *errorMessage = [NSString stringWithFormat:@"Initial Load could not retreive your contacts due to error: %@ Please try reloading the contact list but pulling down on the list. Please contact support@missionhub.com if the problem continues.", [error localizedDescription]];
			
			self.errorForInitialRequests = [NSError errorWithDomain:MHAPIErrorDomain
															   code:MHAPIErrorCouldNotRetrieveCurrentUser
														   userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage,nil)}];
			
		}
		
	} else {
		
		//call fail block if it exists so that the calling method can access the result
		if (request.failBlock) {
			request.failBlock(error, request.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:error];
		}
		
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
	
	if ([options stringForEndpoint]) {
		
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
