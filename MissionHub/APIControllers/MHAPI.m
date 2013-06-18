//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"

@implementation MHAPI

@synthesize accessToken;

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
		
		NSString *pathToConfigFile = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
		NSDictionary *configDictionary = [NSDictionary dictionaryWithContentsOfFile:pathToConfigFile];
		
		NSLog(@"%@", configDictionary);
		
    }
    return self;
}

@end
