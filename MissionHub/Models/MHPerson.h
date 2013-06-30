//
//  MHPerson.h
//  MissionHub
//
//  Created by Michael Harrison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MHModel.h"

@class MHOrganization, MHOrganizationalLabel, MHInteraction, MHOrganizationalPermission, MHSurvey, MHAddress, MHEmailAddress, MHPhoneNumber, MHUser;

@interface MHPerson : MHModel

@property (nonatomic, retain) NSDate * birth_date;
@property (nonatomic, retain) NSString * campus;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * date_became_christian;
@property (nonatomic, retain) NSNumber * fb_uid;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * graduation_date;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * minor;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * year_in_school;
@property (nonatomic, retain) NSSet *assignedConacts;
@property (nonatomic, retain) MHPerson *assignedLeader;
@property (nonatomic, retain) NSSet *initiatedInteractions;
@property (nonatomic, retain) NSSet *labels;
@property (nonatomic, retain) MHOrganization *organization;
@property (nonatomic, retain) MHOrganizationalPermission *permissionLevel;
@property (nonatomic, retain) NSSet *receivedInteractions;
@property (nonatomic, retain) NSSet *surveys;
@property (nonatomic, retain) NSSet *createdInteractions;
@property (nonatomic, retain) NSSet *updatedInteractions;
@property (nonatomic, retain) MHOrganization *leaderInOrganization;
@property (nonatomic, retain) NSSet *phoneNumbers;
@property (nonatomic, retain) NSSet *addresses;
@property (nonatomic, retain) NSSet *emailAddresses;
@property (nonatomic, retain) MHUser *user;
@end

@interface MHPerson (CoreDataGeneratedAccessors)

- (void)addAssignedConactsObject:(MHPerson *)value;
- (void)removeAssignedConactsObject:(MHPerson *)value;
- (void)addAssignedConacts:(NSSet *)values;
- (void)removeAssignedConacts:(NSSet *)values;

- (void)addInitiatedInteractionsObject:(MHInteraction *)value;
- (void)removeInitiatedInteractionsObject:(MHInteraction *)value;
- (void)addInitiatedInteractions:(NSSet *)values;
- (void)removeInitiatedInteractions:(NSSet *)values;

- (void)addLabelsObject:(MHOrganizationalLabel *)value;
- (void)removeLabelsObject:(MHOrganizationalLabel *)value;
- (void)addLabels:(NSSet *)values;
- (void)removeLabels:(NSSet *)values;

- (void)addReceivedInteractionsObject:(MHInteraction *)value;
- (void)removeReceivedInteractionsObject:(MHInteraction *)value;
- (void)addReceivedInteractions:(NSSet *)values;
- (void)removeReceivedInteractions:(NSSet *)values;

- (void)addSurveysObject:(MHSurvey *)value;
- (void)removeSurveysObject:(MHSurvey *)value;
- (void)addSurveys:(NSSet *)values;
- (void)removeSurveys:(NSSet *)values;

- (void)addCreatedInteractionsObject:(MHInteraction *)value;
- (void)removeCreatedInteractionsObject:(MHInteraction *)value;
- (void)addCreatedInteractions:(NSSet *)values;
- (void)removeCreatedInteractions:(NSSet *)values;

- (void)addUpdatedInteractionsObject:(MHInteraction *)value;
- (void)removeUpdatedInteractionsObject:(MHInteraction *)value;
- (void)addUpdatedInteractions:(NSSet *)values;
- (void)removeUpdatedInteractions:(NSSet *)values;

- (void)addAddressesObject:(MHAddress *)value;
- (void)removeAddressesObject:(MHAddress *)value;
- (void)addAddresses:(NSSet *)values;
- (void)removeAddresses:(NSSet *)values;

- (void)addEmailAddressesObject:(MHEmailAddress *)value;
- (void)removeEmailAddressesObject:(MHEmailAddress *)value;
- (void)addEmailAddresses:(NSSet *)values;
- (void)removeEmailAddresses:(NSSet *)values;

- (void)addPhoneNumbersObject:(MHPhoneNumber *)value;
- (void)removePhoneNumbersObject:(MHPhoneNumber *)value;
- (void)addPhoneNumbers:(NSSet *)values;
- (void)removePhoneNumbers:(NSSet *)values;

@end
