//
//  MHSurvey.h
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHOrganization, MHPerson;

@interface MHSurvey : MHModel

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * is_frozen;
@property (nonatomic, retain) NSString * login_paragraph;
@property (nonatomic, retain) NSString * post_survey_message;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) MHOrganization *organization;
@property (nonatomic, retain) NSSet *people;
@end

@interface MHSurvey (CoreDataGeneratedAccessors)

- (void)addPeopleObject:(MHPerson *)value;
- (void)removePeopleObject:(MHPerson *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

@end
