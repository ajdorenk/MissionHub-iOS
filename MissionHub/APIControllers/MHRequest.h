//
//  MHRequest.h
//  MissionHub
//
//  Created by Michael Harrison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "MHAPI.h"


@interface MHRequest : ASIFormDataRequest {
	
	MHRequestOptions	*_options;
	void (^_successBlock)(NSArray *results, MHRequestOptions *options);
	void (^_failBlock)(NSError *error, MHRequestOptions *options);
	
}

@property (nonatomic, strong) MHRequestOptions *options;
@property (nonatomic, strong) void (^successBlock)(NSArray *results, MHRequestOptions *options);
@property (nonatomic, strong) void (^failBlock)(NSError *error, MHRequestOptions *options);

@end
