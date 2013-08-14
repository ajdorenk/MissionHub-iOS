//
//  MHAPI.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "MHRequestOperation.h"
#import "MHRequestOptions.h"
#import "NSDictionary+UrlEncodedString.h"
#import "MHErrorHandler.h"
#import "MHModel.h"

extern NSString *const MHAPIErrorDomain;

@class MHRequestOperation, MHPerson, MHOrganization;

@interface MHAPI : AFHTTPClient <MHRequestOperationDelegate>

@property (nonatomic, strong) NSURL				*surveyURL;
@property (nonatomic, strong) NSString			*accessToken;

@property (nonatomic, strong) MHPerson			*currentUser;
@property (nonatomic, strong) MHOrganization	*currentOrganization;
@property (nonatomic, strong) MHPerson			*_anonymous;
@property (nonatomic, strong) NSMutableArray	*initialPeopleList;
@property (nonatomic, assign) BOOL				currentOrganizationIsFinished;
@property (nonatomic, assign) BOOL				initialPeopleListIsFinished;
@property (nonatomic, strong) NSError			*errorForInitialRequests;


+ (MHAPI *)sharedInstance;
- (id)initWithBaseURL:(NSURL *)url andSurveyURL:(NSURL *)surveyURL;

//misc
- (MHPerson *)anonymous;
- (NSMutableURLRequest *)requestWithOptions:(MHRequestOptions *)options;
- (NSURLRequest *)requestForSurveyWith:(NSNumber *)remoteID;

//general request call
-(void)getResultWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

//initial calls after login
- (void)getMeWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getCurrentOrganizationWith:(MHUser *)user successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getPeopleListWith:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getOrganizationWithRemoteID:(NSNumber *)remoteID successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

- (void)getProfileForRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getInteractionsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

- (void)createPerson:(MHPerson *)person withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)createInteraction:(MHInteraction *)interaction withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

- (void)handleError:(NSError *)error forOperation:(MHRequestOperation *)operation;

@end
