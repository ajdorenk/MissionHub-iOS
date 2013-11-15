//
//  MHPerson+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson.h"
#import "MHAddress.h"
#import "MHAnswerSheet.h"
#import "MHEmailAddress.h"
#import "MHInteraction.h"
#import "MHOrganization.h"
#import "MHOrganizationalLabel.h"
#import "MHLabel.h"
#import "MHOrganizationalPermission.h"
#import "MHPermissionLevel.h"
#import "MHPerson.h"
#import "MHPhoneNumber.h"
#import "MHSurvey.h"
#import "MHUser.h"

typedef enum {
	MHPersonSortFieldFirstName,
	MHPersonSortFieldLastName,
	MHPersonSortFieldGender,
	MHPersonSortFieldFollowupStatus,
	MHPersonSortFieldPermission,
	MHPersonSortFieldPrimaryPhone,
	MHPersonSortFieldPrimaryEmail
} MHPersonSortFields;

@interface MHPerson (Helper)

- (void)setDefaultsForNewObject;

-(NSString *)valueForSortField:(MHPersonSortFields)sortField;
+(NSString *)fieldNameForSortField:(MHPersonSortFields)sortField;

-(NSString *)fullName;
-(NSString *)primaryEmail;
-(NSString *)primaryPhone;
-(NSString *)followupStatus;
-(NSString *)permissionName;

@end
