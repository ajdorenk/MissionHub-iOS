//
//  MHAPI.h
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHAPI : NSObject

@property (nonatomic, strong) NSString *accessToken;

+ (MHAPI *)sharedInstance;

@end
