//
//  MHInteractionType.h
//  MissionHub
//
//  Created by Michael Harrison on 7/30/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHInteraction, MHOrganization;

@interface MHInteractionType : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * i18n;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *interactions;
@property (nonatomic, retain) MHOrganization *organization;
@end

@interface MHInteractionType (CoreDataGeneratedAccessors)

- (void)addInteractionsObject:(MHInteraction *)value;
- (void)removeInteractionsObject:(MHInteraction *)value;
- (void)addInteractions:(NSSet *)values;
- (void)removeInteractions:(NSSet *)values;

@end
