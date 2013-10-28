//
//  MHConfig.h
//  MissionHub
//
//  Created by Michael Harrison on 10/28/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHConfig : NSObject

@property (nonatomic, assign, readonly) BOOL		inDevelopmentMode;
@property (nonatomic, assign, readonly) BOOL		inTestMode;
@property (nonatomic, assign, readonly) BOOL		inReleaseMode;

@property (nonatomic, strong, readonly) NSURL		*baseUrl;
@property (nonatomic, strong, readonly) NSURL		*apiUrl;
@property (nonatomic, strong, readonly) NSURL		*surveyUrl;

@property (nonatomic, strong, readonly) NSString	*apiKeyErrbit;
@property (nonatomic, strong, readonly) NSString	*apiKeyGoogleAnalytics;
@property (nonatomic, strong, readonly) NSString	*apiKeyNewRelic;

+ (MHConfig *)sharedInstance;

@end
