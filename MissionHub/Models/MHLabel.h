//
//  MHLabel.h
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHOrganization, MHPerson;

@interface MHLabel : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * i18n;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *organizations;
@property (nonatomic, retain) NSSet *people;
@end

@interface MHLabel (CoreDataGeneratedAccessors)

- (void)addOrganizationsObject:(MHOrganization *)value;
- (void)removeOrganizationsObject:(MHOrganization *)value;
- (void)addOrganizations:(NSSet *)values;
- (void)removeOrganizations:(NSSet *)values;

- (void)addPeopleObject:(MHPerson *)value;
- (void)removePeopleObject:(MHPerson *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

@end
