//
//  MHInteraction+Helper.h
//  MissionHub
//
//  Created by Michael Harrison on 7/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteraction.h"
#import "MHPerson.h"
#import "MHInteractionType.h"

typedef enum {
	MHInteractionPrivacySettingEveryone,
	MHInteractionPrivacySettingParent,
	MHInteractionPrivacySettingOrganization,
	MHInteractionPrivacySettingAdmins,
	MHInteractionPrivacySettingMe,
} MHInteractionPrivacySettings;

@interface MHInteraction (Helper)

+(NSString *)stringForPrivacySetting:(MHInteractionPrivacySettings)privacySetting;

@end
