//
//  MHConfig.m
//  MissionHub
//
//  Created by Michael Harrison on 10/28/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHConfig.h"

@implementation MHConfig

@synthesize inDevelopmentMode		= _inDevelopmentMode;
@synthesize inTestMode				= _inTestMode;
@synthesize inReleaseMode			= _inReleaseMode;

@synthesize baseUrl					= _baseUrl;
@synthesize apiUrl					= _apiUrl;
@synthesize surveyUrl				= _surveyUrl;

@synthesize apiKeyErrbit			= _apiKeyErrbit;
@synthesize apiKeyGoogleAnalytics	= _apiKeyGoogleAnalytics;
@synthesize apiKeyNewRelic			= _apiKeyNewRelic;

+ (MHConfig *)sharedInstance {
	
	static MHConfig *sharedInstance;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		sharedInstance					= [[MHConfig alloc] init];
		
	});
	
	return sharedInstance;
	
}

- (id)init {
	
    self = [super init];
    
	if (self) {
        
		//read config file
		NSString *configFilePath		= [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
		NSDictionary *configDictionary	= [NSDictionary dictionaryWithContentsOfFile:configFilePath];
		
		//set mode
		_inDevelopmentMode				= YES;
		_inTestMode						= NO;
		_inReleaseMode					= NO;
		
		if ([[configDictionary valueForKey:@"development_mode"] boolValue]) {
			_inDevelopmentMode			= YES;
			_inTestMode					= NO;
			_inReleaseMode				= NO;
		}
		
		if ([[configDictionary valueForKey:@"test_mode"] boolValue]) {
			_inDevelopmentMode			= NO;
			_inTestMode					= YES;
			_inReleaseMode				= NO;
		}
		
		if ([[configDictionary valueForKey:@"release_mode"] boolValue]) {
			_inDevelopmentMode			= NO;
			_inTestMode					= NO;
			_inReleaseMode				= YES;
		}
		
		//set urls base on mode
		NSString *baseUrlString		= @"";
		NSString *shortUrlString	= @"";
		
		if (_inDevelopmentMode) {
			
			baseUrlString			= ( [configDictionary valueForKey:@"development_url"] ? [configDictionary valueForKey:@"development_url"] : @"" );
			shortUrlString			= ( [configDictionary valueForKey:@"development_short_url"] ? [configDictionary valueForKey:@"development_short_url"] : @"" );
			
		}
		
		if (_inTestMode) {
			
			baseUrlString			= ( [configDictionary valueForKey:@"staging_url"] ? [configDictionary valueForKey:@"staging_url"] : @"" );
			shortUrlString			= ( [configDictionary valueForKey:@"staging_short_url"] ? [configDictionary valueForKey:@"staging_short_url"] : @"" );
			
		}
		
		if (_inReleaseMode) {
			
			baseUrlString			= ( [configDictionary valueForKey:@"production_url"] ? [configDictionary valueForKey:@"production_url"] : @"" );
			shortUrlString			= ( [configDictionary valueForKey:@"production_short_url"] ? [configDictionary valueForKey:@"production_short_url"] : @"" );
			
		}
		
		NSString *apiPathString		= ( [configDictionary valueForKey:@"api_path"] ? [configDictionary valueForKey:@"api_path"] : @"" );
		NSString *surveyPathString	= ( [configDictionary valueForKey:@"survey_path"] ? [configDictionary valueForKey:@"survey_path"] : @"" );
		
		_baseUrl					= [NSURL URLWithString:baseUrlString];
		_apiUrl						= [NSURL URLWithString:apiPathString relativeToURL:_baseUrl];
		_surveyUrl					= [NSURL URLWithString:surveyPathString relativeToURL:[NSURL URLWithString:shortUrlString]];
		
		//set api keys
		_apiKeyErrbit				= ( [configDictionary valueForKey:@"errbit_api_key"] ? [configDictionary valueForKey:@"errbit_api_key"] : @"" );
		_apiKeyGoogleAnalytics		= ( [configDictionary valueForKey:@"google_analytics_api_key"] ? [configDictionary valueForKey:@"google_analytics_api_key"] : @"" );
		_apiKeyNewRelic				= ( [configDictionary valueForKey:@"newrelic_api_key"] ? [configDictionary valueForKey:@"newrelic_api_key"] : @"" );
		
    }
	
    return self;
}

@end
