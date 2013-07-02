//
//  MHPerson+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPerson.h"
#import "MHAddress.h"
#import "MHEmailAddress.h"
#import "MHInteraction.h"
#import "MHOrganization.h"
#import "MHOrganizationalLabel.h"
#import "MHOrganizationalPermission.h"
#import "MHPerson.h"
#import "MHPhoneNumber.h"
#import "MHSurvey.h"
#import "MHUser.h"

@interface MHPerson (Helper)

-(NSString *)fullName;

@end