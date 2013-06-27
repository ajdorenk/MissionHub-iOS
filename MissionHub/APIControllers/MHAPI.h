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

@class MHRequest, MHPerson, MHOrganization;

@interface MHAPI : NSObject {
	
	NSOperationQueue *_queue;
	NSString *_baseUrl;
	NSString *_apiUrl;
	NSString *_accessToken;
	
	MHPerson *_currentUser;
	MHOrganization *_currentOrganization;
	
}

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) MHPerson *currentUser;
@property (nonatomic, strong) MHOrganization *currentOrganization;

+(MHAPI *)sharedInstance;

-(void)getMeWithOptions:(MHRequestOptions *)options successBlock:(void (^)(NSArray *result, MHRequestOptions *options))successBlock failBlock:(void (^)(NSError *error, MHRequestOptions *options))failBlock;

-(NSString *)stringForMeRequestWith:(MHRequestOptions *)options error:(NSError **)error;
-(NSString *)stringForIndexRequestWith:(MHRequestOptions *)options error:(NSError **)error;

-(void)requestDidFinish:(MHRequest *)request;
-(void)requestDidFail:(MHRequest *)request;

@end
