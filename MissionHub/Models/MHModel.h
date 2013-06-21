//
//  MHModel.h
//  MissionHub
//
//  Created by Michael Harrison on 6/16/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MHStorage.h"

@interface MHModel : NSManagedObject

+(NSEntityDescription *)entity;

@end
