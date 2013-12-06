//
//  MHAllObjects.m
//  MissionHub
//
//  Created by Michael Harrison on 11/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAllObjects.h"
#import "MHAPI.h"

@interface MHAllObjects ()

@property (nonatomic, strong) NSDate *lastSync;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, strong) NSMutableArray *peopleList;

//- (void)sync;

@end

@implementation MHAllObjects

@synthesize requestOptions	= _requestOptions;
//@synthesize lastSync		= _lastSync;
//@synthesize isDownloading	= _isDownloading;
//@synthesize peopleList		= _peopleList;

- (void)setRequestOptions:(MHRequestOptions *)requestOptions {
	
	[self willChangeValueForKey:@"requestOptions"];
	_requestOptions	= [requestOptions copy];
	[self didChangeValueForKey:@"requestOptions"];
	
	_requestOptions.offset	= 0;
	_requestOptions.limit	= 0;
	
//	self.lastSync			= nil;
//	
//	[self sync];
	
}

//- (void)sync {
//	
//	
//	
//}

- (void)getPeopleListWithSuccessBlock:(void (^)(NSArray *peopleList))successBlock failBlock:(void (^)(NSError *error))failBlock {
	
//	//if the list of people has been downloaded in the last 5 seconds just return the list else sync the latest changes
//	if (self.lastSync && [self.lastSync timeIntervalSinceNow] > -5) {
//		
//		successBlock(self.peopleList);
//		
//	} else {
//		
//		if (self.lastSync) {
//			
//			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//			[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//			NSString *iOSDateString = [dateFormatter stringFromDate:self.lastSync];
//			NSString *rubyDateString = [NSString stringWithFormat:@"%@:%@", [iOSDateString substringToIndex:22], [iOSDateString substringFromIndex:22]];
//			[self.requestOptions addPostParam:@"since" withValue:rubyDateString];
//			
//		}
		
		[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
										successBlock:^(NSArray *result, MHRequestOptions *options) {
											
//											[self.peopleList addObjectsFromArray:result];
											
											successBlock(self.peopleList);
											
										} failBlock:^(NSError *error, MHRequestOptions *options) {
											
											failBlock(error);
											
										}];
		
//	}
	
}

@end
