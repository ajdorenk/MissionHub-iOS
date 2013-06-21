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

@class MHRequest;

@interface MHAPI : NSObject

@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *apiUrl;
@property (nonatomic, strong) NSString *accessToken;

+(MHAPI *)sharedInstance;

-(NSString *)stringForIndexRequestWith:(MHRequestOptions *)options error:(NSError **)error;

-(void)requestDidFinish:(MHRequest *)request;
-(void)requestDidFail:(MHRequest *)request;

@end
