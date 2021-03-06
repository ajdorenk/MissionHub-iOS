//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"
#import "MHConfig.h"
#import "MHRequestOperation.h"
#import "MHPerson+Helper.h"
#import "MHOrganizationalPermission+Helper.h"

NSString *const MHAPIErrorDomain = @"com.missionhub.errorDomain.API";
NSString *const MHAPIRequestNameMe = @"com.missionhub.API.requestName.me";
NSString *const MHAPIRequestNameCurrentOrganization = @"com.missionhub.API.requestName.currentOrganization";
NSString *const MHAPIRequestNameInitialPeopleList = @"com.missionhub.API.requestName.initialPeopleList";
NSString *const MHAPIRequestNameContactAssignmentFilter = @"com.missionhub.API.requestName.contactAssignmentFilter";

typedef enum {
	MHAPIErrorCouldNotRetrieveCurrentUser,
	MHAPIErrorMissingDataInRequest,
	MHAPIErrorMissingUrl,
	MHAPIErrorMissingEndpoint,
	MHAPIErrorMissionAccessToken,
	MHAPIErrorMalformedResponse,
	MHAPIErrorServerError,
	MHAPIErrorAccessTokenError,
	MHAPIErrorAccessDenied,
	MHAPIErrorUserNotFound,
	MHAPIErrorUnknownError
} MHAPIErrors;

@interface MHAPI ()

@property (nonatomic, strong) NSURL				*surveyURL;
@property (nonatomic, assign) BOOL				currentOrganizationIsFinished;
@property (nonatomic, assign) BOOL				initialPeopleListIsFinished;
@property (nonatomic, strong) NSError			*errorForInitialRequests;

@end

@implementation MHAPI

@synthesize surveyURL						= _surveyURL;
@synthesize accessToken						= _accessToken;

@synthesize currentUser						= _currentUser;
@synthesize currentOrganization				= _currentOrganization;
@synthesize anonymous						= _anonymous;
@synthesize initialPeopleList				= _initialPeopleList;
@synthesize currentOrganizationIsFinished	= _currentOrganizationIsFinished;
@synthesize initialPeopleListIsFinished		= _initialPeopleListIsFinished;
@synthesize errorForInitialRequests			= _errorForInitialRequests;

+ (MHAPI *)sharedInstance {
	
	static MHAPI *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		sharedInstance					= [[MHAPI alloc] initWithAPIURL:[MHConfig sharedInstance].apiUrl andSurveyURL:[MHConfig sharedInstance].surveyUrl];
		
	});
	
	return sharedInstance;
		
}

- (id)initWithAPIURL:(NSURL *)url andSurveyURL:(NSURL *)surveyUrl {
	
    self = [super initWithBaseURL:url];
	
    if (self) {
        // Custom initialization
		
		self.surveyURL					= surveyUrl;
		self.parameterEncoding			= AFJSONParameterEncoding;
		
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
	
	NSMutableDictionary *parameters = options.parameters;
	parameters[@"facebook_token"]	= self.accessToken;
	
	if (self.currentOrganization && !parameters[@"organization_id"]) {
		parameters[@"organization_id"]	= self.currentOrganization.remoteID;
	}
	
	return [self requestWithMethod:options.method
							  path:options.path
						parameters:parameters];
	
}

- (void)getResultWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= (options ? options : [[MHRequestOptions alloc] init]);
	requestOptions.successBlock			= successBlock;
	requestOptions.failBlock			= failBlock;
	
	NSMutableURLRequest *request		= [self requestWithOptions:requestOptions];
    MHRequestOperation *operation		= [MHRequestOperation operationWithRequest:request options:requestOptions andDelegate:self];
	operation.requestName				= requestOptions.requestName;
	
    NSLog(@"%@", [[request URL] absoluteString]);
	
	[self enqueueHTTPRequestOperation:operation];
	
}

- (void)getMeWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= [[[MHRequestOptions alloc] init] configureForMeRequest];
	requestOptions.requestName			= MHAPIRequestNameMe;
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)getOrganizationWithRemoteID:(NSNumber *)remoteID successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= [[[MHRequestOptions alloc] init] configureForOrganizationRequestWithRemoteID:remoteID];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)getCurrentOrganizationWith:(MHUser *)user successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions	= [[[MHRequestOptions alloc] init] configureForOrganizationRequestWithRemoteID:user.primary_organization_id];
	requestOptions.requestName			= MHAPIRequestNameCurrentOrganization;
	self.currentOrganizationIsFinished	= NO;
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)logout {
	
	[self.operationQueue cancelAllOperations];
	
	self.accessToken					= nil;
	self.currentUser					= nil;
	self.currentOrganization			= nil;
	self.initialPeopleList				= nil;
	self.errorForInitialRequests		= nil;
	
}

- (void)getPeopleListWith:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions;
	
	if (options) {
		requestOptions = options;
	} else {
		requestOptions				= [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
		requestOptions.requestName	= MHAPIRequestNameInitialPeopleList;
		self.initialPeopleListIsFinished = NO;
	}
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)getProfileForRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForProfileRequestWithRemoteID:remoteID];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)getInteractionsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForInteractionRequestForPersonWithRemoteID:remoteID];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)getPersonWithSurveyAnswerSheetsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForSurveyAnswerSheetsRequestForPersonWithRemoteID:remoteID];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)createPerson:(MHPerson *)person withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForCreatePersonRequestWithPerson:person];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)createInteraction:(MHInteraction *)interaction withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForCreateInteractionRequestWithInteraction:interaction];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)bulkDeletePeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	if (people.count > 0) {
		
		MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForBulkDeleteRequestForPeople:people];
		
		[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
		
	} else {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No People to Delete.", nil)}];
		
		failBlock(error, requestOptions);
		
	}
	
}

- (void)bulkArchivePeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	if (people.count > 0) {
		
		MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForBulkArchiveRequestForPeople:people];
		
		[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
		
	} else {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No People to Archive.", nil)}];
		
		failBlock(error, requestOptions);
		
	}
	
}

- (void)bulkChangePermissionLevel:(MHPermissionLevel *)permissionLevel forPeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	if (!permissionLevel) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Missing Permission Level.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	if (people.count <= 0) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No People to change Permission Level for.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForBulkPermissionLevelRequestWithNewPermissionLevel:permissionLevel forPeople:people];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)bulkChangeStatus:(NSString *)status forPeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	if (![MHOrganizationalPermission isValidStatus:status]) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Invalid Status.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	if (people.count <= 0) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No People to change Status for.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForBulkStatusRequestWithNewStatus:status forPeople:people];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)bulkAssignPeople:(NSArray *)people toPerson:(MHPerson *)person withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	if (!person) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Missing Leader for Assignment.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	if (people.count <= 0) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No People to assign to leader.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForBulkAssignmentRequestWithLeader:person forPeople:people];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}

- (void)bulkChangeLabelsWithLabelsToAdd:(NSArray *)labelsToAdd labelsToRemove:(NSArray *)labelsToRemove forPeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock {
	
	if (people.count <= 0) {
		
		MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
		NSError *error = [NSError errorWithDomain:MHAPIErrorDomain
											 code:MHAPIErrorMissingDataInRequest
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"No People to apply labels to.", nil)}];
		
		failBlock(error, requestOptions);
		return;
		
	}
	
	MHRequestOptions *requestOptions = [[[MHRequestOptions alloc] init] configureForBulkLabelingRequestWithLabelsToAdd:labelsToAdd labelsToRemove:labelsToRemove forPeople:people];
	
	[self getResultWithOptions:requestOptions successBlock:successBlock failBlock:failBlock];
	
}


-(NSURLRequest *)requestForSurveyWith:(NSNumber *)remoteID {
	
	NSURL *url				= [NSURL URLWithString:[remoteID stringValue] relativeToURL:self.surveyURL];
	NSURLRequest *request	= [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
	
	return request;
}

- (void)operationDidFinish:(MHRequestOperation *)operation {
	
	NSError *error;
	__block NSMutableArray *modelArray			= [NSMutableArray array];
	__block NSString *nameOfClassForEndpoint	= [operation.options classNameForEndpoint];
	NSDictionary *result						= operation.jsonObject;
	
	//try parsing, creating and filling model objects. These use key value coding to set values in the model objects which means if the field names in the response json change then it will throw an exception. We want to catch that.
	@try {

		if (![operation hasAcceptableStatusCode]) {
			
			[self operationDidFail:operation];
			return;
			
		}
	
		NSString *keyForFirstObject				= [[result allKeys] objectAtIndex:0];
		NSString *endpointName					= [operation.options stringForEndpoint];
		NSString *endpointSingularName			= [operation.options stringInSingluarFormatForEndpoint];
		NSString *peopleEndpointName			= [operation.options stringFromEndpoint:MHRequestOptionsEndpointPeople];
		NSString *peopleEndpointSingularName	= [operation.options stringInSingluarFormatFromEndpoint:MHRequestOptionsEndpointPeople];
		NSString *nameOfClassForPeopleEndpoint	= [operation.options classNameFromEndpoint:MHRequestOptionsEndpointPeople];
		
		//if the root of the response is the singular form of the endpoint's name then the root will hold one object matching the type of the endpoint. So we put that object into a model object and put it in the model array.
		if ([keyForFirstObject isEqualToString:endpointSingularName] || [keyForFirstObject isEqualToString:peopleEndpointSingularName]) {

			if ([keyForFirstObject isEqualToString:peopleEndpointSingularName]) {
				
				endpointSingularName	= peopleEndpointSingularName;
				nameOfClassForEndpoint	= nameOfClassForPeopleEndpoint;
				
			}
			
			NSDictionary *responseObject = [result objectForKey:endpointSingularName];
			
			id modelObject = [MHModel newObjectForClass:nameOfClassForEndpoint fromFields:responseObject];
			
			[modelArray addObject:modelObject];
			
		} else if ([keyForFirstObject isEqualToString:endpointName] || [keyForFirstObject isEqualToString:peopleEndpointName]) {
			
			if ([keyForFirstObject isEqualToString:peopleEndpointSingularName]) {
				
				endpointName			= peopleEndpointName;
				nameOfClassForEndpoint	= nameOfClassForPeopleEndpoint;
				
			}
			
			__block NSArray *arrayOfResponseObjects = [result objectForKey:endpointName];
			
			//if changed you need to also change in the request options MHRequestOptions configureForInitialContactAssignmentsPageRequestWithAssignedToID:
			if ([operation.requestName isEqualToString:MHAPIRequestNameContactAssignmentFilter]) {
				
				[arrayOfResponseObjects enumerateObjectsUsingBlock:^(id responseObject, NSUInteger index, BOOL *stop) {
					
					id modelObject = [MHModel newObjectForClass:nameOfClassForPeopleEndpoint
													 fromFields:[responseObject objectForKey:[operation.options stringFromInclude:MHRequestOptionsIncludeConactAssignmentsPerson]]];
					
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
									userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has incorrect name for root element. Please contact support@missionhub.com", nil)}];
			
			if (operation.failBlock) {
				operation.failBlock(error, operation.options);
			} else {
				//if no fail block show the error anyway
				[MHErrorHandler presentError:error];
			}
			
			return;
			
		}
	
		//deal with result
		if ([operation.requestName isEqualToString:MHAPIRequestNameMe]) {
			
			self.currentUser				= [modelArray objectAtIndex:0];
			self.errorForInitialRequests	= nil;
			
			[self getCurrentOrganizationWith:self.currentUser.user successBlock:operation.successBlock failBlock:operation.failBlock];
			[self getPeopleListWith:nil successBlock:operation.successBlock failBlock:operation.failBlock];
			
		} else if ([operation.requestName isEqualToString:MHAPIRequestNameCurrentOrganization]) {
			
			self.currentOrganization				= [modelArray objectAtIndex:0];
			self.currentUser.currentOrganization	= self.currentOrganization; //depreciated, use self.currentOrganization instead. Keep this line for legacy calls.
			self.currentOrganizationIsFinished		= YES;
			
			if (self.initialPeopleListIsFinished) {
				
				if (self.errorForInitialRequests) {
					
					NSArray *returnArray = @[self.currentUser, self.errorForInitialRequests];
					
					//call success block if it exists so that the calling method can access the result
					if (operation.successBlock) {
						operation.successBlock(returnArray, operation.options);
					}
					
				} else {
					
					NSArray *returnArray = @[self.currentUser, self.initialPeopleList];
					
					//call success block if it exists so that the calling method can access the result
					if (operation.successBlock) {
						operation.successBlock(returnArray, operation.options);
					}
					
				}
				
			}
			
		} else if ([operation.requestName isEqualToString:MHAPIRequestNameInitialPeopleList]) {
			
			self.initialPeopleList = modelArray;
			self.initialPeopleListIsFinished = YES;
			
			if (self.currentOrganizationIsFinished) {
				
				if (!self.errorForInitialRequests) {
				
					NSArray *returnArray = @[self.currentUser, self.initialPeopleList];
					
					//call success block if it exists so that the calling method can access the result
					if (operation.successBlock) {
						operation.successBlock(returnArray, operation.options);
					}
					
				}
				
			}
			
		} else {
			
			//call success block if it exists so that the calling method can access the result
			if (operation.successBlock) {
				operation.successBlock(modelArray, operation.options);
			}
			
		}
		
		
	
	}
	@catch (NSException *exception) {
		
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorMalformedResponse
								userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com", @"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com")}];
		
	 [self handleError:error forOperation:operation];
	 return;
		
		
	}
	@finally {
		//nothing to clean up with ARC. YAY!
		return;
	}
	
	
}

- (void)operationDidFail:(MHRequestOperation *)operation {
	
	NSError *error, *responseError;
	NSInteger errorCode		= operation.responseStatusCode;
	NSString *errorMessage	= @"";
	
	//parse errors and put into NSError object
	@try {
		
		if (operation.responseStatusCode == 400 || operation.responseStatusCode == 401 || operation.responseStatusCode == 404 || operation.responseStatusCode == 422 || operation.responseStatusCode == 500) {
		
			switch (operation.responseStatusCode) {
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
			
			if (operation.responseStatusCode == 400 || operation.responseStatusCode == 401 || operation.responseStatusCode == 422) {
				
				NSString *responseErrorString;
				
				//parse response and put into result dictionary
				NSDictionary *result	= operation.jsonObject;
				NSArray *errorsArray	= result[@"errors"];
				NSString *code			= result[@"code"];
				
				//if the root of the response is the singular form of the endpoint's name then the root will hold one object matching the type of the endpoint. So we put that object into a model object and put it in the model array.
				if (errorsArray) {
					
					responseErrorString	= errorsArray[0];
					
					if (code) {
						
						if ([code isEqualToString:@"invalid_facebook_token"]) {
							
							errorCode = MHAPIErrorAccessTokenError;
							
						} else if ([code isEqualToString:@"user_not_found"]) {
							
							errorCode = MHAPIErrorUserNotFound;
							
						} else {
							
							errorCode = MHAPIErrorUnknownError;
							
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
			
			[self handleError:responseError forOperation:operation];
			return;
			
		} else {
	
			//if there is a connection error and the request has dealt with the error then return that error
			if (operation.error) {
				
				responseError = operation.error;
			
			//otherwise parse the error
			} else {
					
				responseError = [NSError errorWithDomain:MHAPIErrorDomain
											code:MHAPIErrorMalformedResponse
										userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response did not contain a valid error. Please contact support@missionhub.com", @"Response did not contain a valid error. Please contact support@missionhub.com")}];
				
				[self handleError:responseError forOperation:operation];
				return;
					
			}
			
		}
		
		
		
	}
	@catch (NSException *exception) {
		
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorMalformedResponse
								userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com", @"Response JSON object has unexpected format, unexpected field names or is corrupt/malformed. Please contact support@missionhub.com")}];

		[self handleError:responseError forOperation:operation];
		return;
		
		
	}
	@finally {
		//nothing to clean up with ARC. YAY!
	}
	
	[self handleError:responseError forOperation:operation];
	return;
	
}

-(void)handleError:(NSError *)error forOperation:(MHRequestOperation *)operation {
	
	if ([operation.requestName isEqualToString:MHAPIRequestNameMe]) {
		
		NSString *errorMessage = [NSString stringWithFormat:@"Initial Load Failed due to error: %@ Please try reloading the initial data. Please contact support@missionhub.com if the problem continues.", [error localizedDescription]];
		
		error = [NSError errorWithDomain:MHAPIErrorDomain
									code:MHAPIErrorCouldNotRetrieveCurrentUser
								userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage,nil)}];
		
		//call fail block if it exists so that the calling method can access the result
		if (operation.failBlock) {
			operation.failBlock(error, operation.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:self.errorForInitialRequests];
		}
		
	} else if ([operation.requestName isEqualToString:MHAPIRequestNameCurrentOrganization]) {
		
		NSString *errorMessage = [NSString stringWithFormat:@"Initial Load Failed due to error: %@ Please try reloading the initial data. Please contact support@missionhub.com if the problem continues.", [error localizedDescription]];
		
		self.currentOrganizationIsFinished = YES;
		
		self.errorForInitialRequests = [NSError errorWithDomain:MHAPIErrorDomain
														   code:MHAPIErrorCouldNotRetrieveCurrentUser
													   userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage,nil)}];
		
		//call fail block if it exists so that the calling method can access the result
		if (operation.failBlock) {
			operation.failBlock(self.errorForInitialRequests, operation.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:self.errorForInitialRequests];
		}
		
		if (self.initialPeopleListIsFinished) {
			
			self.errorForInitialRequests = nil;
			
		}
		
		
	} else if ([operation.requestName isEqualToString:MHAPIRequestNameInitialPeopleList]) {
		
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
				if (operation.successBlock) {
					operation.successBlock(returnArray, operation.options);
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
		if (operation.failBlock) {
			operation.failBlock(error, operation.options);
		} else {
			//if no fail block show the error anyway
			[MHErrorHandler presentError:error];
		}
		
	}
	
	
	
}

@end
