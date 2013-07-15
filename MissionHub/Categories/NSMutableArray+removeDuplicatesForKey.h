//
//  NSMutableArray+removeDuplicatesForKey.h
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (removeDuplicatesForKey)

-(NSMutableArray *)arrayWithDuplicatesRemovedForKey:(NSString *)key;

@end
