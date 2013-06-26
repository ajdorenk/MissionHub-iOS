//
//  MHInteraction.h
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHPerson, MHInteractionType;

@interface MHInteraction : MHModel

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * deleted_at;
@property (nonatomic, retain) NSString * privacy_setting;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *initiators;
@property (nonatomic, retain) MHPerson *receiver;
@property (nonatomic, retain) MHInteractionType *type;
@end

@interface MHInteraction (CoreDataGeneratedAccessors)

- (void)addInitiatorsObject:(MHPerson *)value;
- (void)removeInitiatorsObject:(MHPerson *)value;
- (void)addInitiators:(NSSet *)values;
- (void)removeInitiators:(NSSet *)values;

@end
