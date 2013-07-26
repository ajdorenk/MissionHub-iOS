//
//  MHAPI.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHRequestOptions.h"
#import "NSDictionary+UrlEncodedString.h"
#import "MHErrorHandler.h"
#import "MHModel.h"

extern NSString *const MHAPIErrorDomain;

@class MHRequest, MHPerson, MHOrganization;

@interface MHAPI : NSObject {
	
	NSOperationQueue *_queue;
	NSString *_baseUrl;
	NSString *_apiUrl;
	NSString *_surveyUrl;
	NSString *_accessToken;
	
	MHPerson *_currentUser;
	NSMutableArray *_initialPeopleList;
	BOOL _currentOrganizationIsFinished;
	BOOL _initialPeopleListIsFinished;
	NSError *_errorForInitialRequests;
	
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) NSString *surveyUrl;
@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) MHPerson *currentUser;
@property (nonatomic, strong) NSMutableArray *initialPeopleList;
@property (nonatomic, assign) BOOL currentOrganizationIsFinished;
@property (nonatomic, assign) BOOL initialPeopleListIsFinished;
@property (nonatomic, strong) NSError *errorForInitialRequests;


+(MHAPI *)sharedInstance;
-(id)initWithConfigFile:(NSString *)configFilePath;

//general request call
-(void)getResultWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

//initial calls after login
-(void)getMeWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
-(void)getCurrentOrganizationWith:(MHUser *)user successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
-(void)getPeopleListWith:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

-(void)getOrganizationWithRemoteID:(NSNumber *)remoteID successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
-(void)getLabelsForCurrentOrganizationWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

-(void)getProfileForRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
-(void)getInteractionsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

-(NSString *)stringForSurveyWith:(NSNumber *)remoteID error:(NSError **)error;
-(NSString *)stringForMeRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForShowRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForIndexRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForCreateRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForUpdateRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForDeleteRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForUpdateOrDeleteRequestWith:(MHRequestOptions *)options error:(NSError **)error;

-(void)requestDidFinish:(MHRequest *)request;
-(void)requestDidFail:(MHRequest *)request;

-(void)handleError:(NSError *)error forRequest:(MHRequest *)request;

@end
