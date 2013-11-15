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

- (void)setDefaultsForNewObject;

+ (NSDateFormatter *)dateFormatter;
+ (NSString *)stringForPrivacySetting:(MHInteractionPrivacySettings)privacySetting;
- (NSString *)title;
- (NSString *)initiatorsNames;
- (NSString *)receiverName;
- (NSString *)updatedString;
- (NSString *)updatedAtString;
- (NSString *)timestampString;

@end
