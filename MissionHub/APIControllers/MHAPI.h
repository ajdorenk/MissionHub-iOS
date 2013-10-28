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

@property (nonatomic, strong) NSString			*accessToken;
@property (nonatomic, strong) MHPerson			*currentUser;
@property (nonatomic, strong) MHOrganization	*currentOrganization;
@property (nonatomic, strong, readonly) MHPerson*anonymous;
@property (nonatomic, strong) NSMutableArray	*initialPeopleList;


+ (MHAPI *)sharedInstance;
- (id)initWithAPIURL:(NSURL *)url andSurveyURL:(NSURL *)surveyUrl;

//misc
- (NSMutableURLRequest *)requestWithOptions:(MHRequestOptions *)options;
- (NSURLRequest *)requestForSurveyWith:(NSNumber *)remoteID;

//general request call
-(void)getResultWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

//login/logout calls
- (void)getMeWithSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getCurrentOrganizationWith:(MHUser *)user successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getPeopleListWith:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getOrganizationWithRemoteID:(NSNumber *)remoteID successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)logout;

//profile calls
- (void)getProfileForRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getInteractionsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)getPersonWithSurveyAnswerSheetsForPersonWithRemoteID:(NSNumber *)remoteID withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

//create calls
- (void)createPerson:(MHPerson *)person withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)createInteraction:(MHInteraction *)interaction withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

//bulk calls
- (void)bulkDeletePeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)bulkArchivePeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)bulkChangePermissionLevel:(MHPermissionLevel *)permissionLevel forPeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)bulkAssignPeople:(NSArray *)people toPerson:(MHPerson *)person withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;
- (void)bulkChangeLabelsWithLabelsToAdd:(NSArray *)labelsToAdd labelsToRemove:(NSArray *)labelsToRemove forPeople:(NSArray *)people withSuccessBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

//error handling
- (void)handleError:(NSError *)error forOperation:(MHRequestOperation *)operation;

@end
