//
//  MHOrganization.h
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHLabel, MHPerson, MHInteractionType, MHPermissionLevel, MHSurvey;

@interface MHOrganization : MHModel

@property (nonatomic, retain) NSString * ancestry;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSNumber * show_sub_orgs;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * terminology;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *admins;
@property (nonatomic, retain) NSSet *labels;
@property (nonatomic, retain) NSSet *people;
@property (nonatomic, retain) NSSet *leaders;
@property (nonatomic, retain) NSSet *surveys;
@end

@interface MHOrganization (CoreDataGeneratedAccessors)

- (void)addLabelsObject:(MHLabel *)value;
- (void)removeLabelsObject:(MHLabel *)value;
- (void)addLabels:(NSSet *)values;
- (void)removeLabels:(NSSet *)values;

- (void)addPeopleObject:(MHPerson *)value;
- (void)removePeopleObject:(MHPerson *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

- (void)addAdminsObject:(MHPerson *)value;
- (void)removeAdminsObject:(MHPerson *)value;
- (void)addAdmins:(NSSet *)values;
- (void)removeAdmins:(NSSet *)values;

- (void)addLeadersObject:(MHPerson *)value;
- (void)removeLeadersObject:(MHPerson *)value;
- (void)addLeaders:(NSSet *)values;
- (void)removeLeaders:(NSSet *)values;

- (void)addSurveysObject:(MHSurvey *)value;
- (void)removeSurveysObject:(MHSurvey *)value;
- (void)addSurveys:(NSSet *)values;
- (void)removeSurveys:(NSSet *)values;

@end
