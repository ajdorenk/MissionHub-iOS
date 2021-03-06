//
//  MHOrganization+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHOrganization.h"
#import "MHLabel.h"
#import "MHPerson.h"
#import "MHSurvey.h"
#import "MHInteractionType.h"
#import "MHPermissionLevel+Helper.h"

@interface MHOrganization (Helper)

- (MHPermissionLevel *)permissionLevelWithRemoteID:(MHPermissionLevelRemoteIds)remoteID;

@end
