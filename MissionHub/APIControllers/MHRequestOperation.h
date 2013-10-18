//
//  MHRequest.h
//  MissionHub
//
//  Created by Michael Harrison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@protocol MHRequestOperationDelegate;

@interface MHRequestOperation : AFJSONRequestOperation

@property (nonatomic, weak)		id<MHRequestOperationDelegate> delegate;
@property (nonatomic, strong)	NSString *requestName;
@property (nonatomic, strong)	MHRequestOptions *options;
@property (nonatomic, strong)	id jsonObject;
@property (nonatomic, readonly) NSUInteger responseStatusCode;
@property (nonatomic, strong)	void (^successBlock)(NSArray *results, MHRequestOptions *options);
@property (nonatomic, strong)	void (^failBlock)(NSError *error, MHRequestOptions *options);

+ (id)operationWithRequest:(NSMutableURLRequest *)request options:(MHRequestOptions *)options andDelegate:(id<MHRequestOperationDelegate>)delegate;

@end

@protocol MHRequestOperationDelegate <NSObject>

@required
- (void)operationDidFinish:(MHRequestOperation *)operation;
- (void)operationDidFail:(MHRequestOperation *)operation;

@end