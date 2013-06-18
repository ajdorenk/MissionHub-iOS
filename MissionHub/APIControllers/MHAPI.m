//
//  MHAPI.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAPI.h"

@implementation MHAPI

@synthesize apiUrl;
@synthesize baseUrl;
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
		
		NSString *pathToConfigFile		= [[NSBundle mainBundle] pathForResource:@"conig" ofType:@"plist"];
		NSDictionary *configDictionary	= [NSDictionary dictionaryWithContentsOfFile:pathToConfigFile];
		
		self.baseUrl					= [configDictionary valueForKey:@"base_url"];
		self.apiUrl						= [configDictionary valueForKey:@"api_url"];
		self.accessToken				= @"CAADULZADslC0BALRH2Sk20bELjdMtQSl943Le7wwofpVzyF1DwZBgcQzkspboiOmZCNc3bZCugwMdE8QKtFqpOzcetJfcj5OEfwZCJIuE09RYnncz9DMFAbNLJuZCo0yjZCRZA9iYOoLLynI6jlXsXSYicPqZC9renHvdoaZABwz18FwZDZD";
		
		if (self.baseUrl == nil) {
				
			self.baseUrl = @"";
				
		}
			
		if (self.apiUrl == nil) {
				
			self.apiUrl = @"";
				
		}
		
    }
    return self;
}

@end
