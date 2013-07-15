//
//  MHProfileTableViewContollerProtocol.h
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHPerson+Helper.h"

@protocol MHProfileProtocol <NSObject>
@required
-(void)setPerson:(MHPerson *)person;

@end
