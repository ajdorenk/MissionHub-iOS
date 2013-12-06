//
//  MHAllObjects.h
//  MissionHub
//
//  Created by Michael Harrison on 11/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHRequestOptions.h"

@interface MHAllObjects : NSObject

@property (nonatomic, strong) MHRequestOptions *requestOptions;

- (void)getPeopleListWithSuccessBlock:(void (^)(NSArray *peopleList))successBlock failBlock:(void (^)(NSError *error))failBlock;

@end
