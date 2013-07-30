//
//  MHOrganization.h
//  MissionHub
//
//  Created by Michael Harrison on 7/30/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHInteractionType, MHLabel, MHPerson, MHSurvey;

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
@property (nonatomic, retain) MHPerson *currentUser;
@property (nonatomic, retain) NSSet *labels;
@property (nonatomic, retain) NSSet *people;
@property (nonatomic, retain) NSSet *surveys;
@property (nonatomic, retain) NSSet *users;
@property (nonatomic, retain) NSSet *interactionTypes;
@end

@interface MHOrganization (CoreDataGeneratedAccessors)

- (void)addAdminsObject:(MHPerson *)value;
- (void)removeAdminsObject:(MHPerson *)value;
- (void)addAdmins:(NSSet *)values;
- (void)removeAdmins:(NSSet *)values;

- (void)addLabelsObject:(MHLabel *)value;
- (void)removeLabelsObject:(MHLabel *)value;
- (void)addLabels:(NSSet *)values;
- (void)removeLabels:(NSSet *)values;

- (void)addPeopleObject:(MHPerson *)value;
- (void)removePeopleObject:(MHPerson *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

- (void)addSurveysObject:(MHSurvey *)value;
- (void)removeSurveysObject:(MHSurvey *)value;
- (void)addSurveys:(NSSet *)values;
- (void)removeSurveys:(NSSet *)values;

- (void)addUsersObject:(MHPerson *)value;
- (void)removeUsersObject:(MHPerson *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

- (void)addInteractionTypesObject:(MHInteractionType *)value;
- (void)removeInteractionTypesObject:(MHInteractionType *)value;
- (void)addInteractionTypes:(NSSet *)values;
- (void)removeInteractionTypes:(NSSet *)values;

@end
