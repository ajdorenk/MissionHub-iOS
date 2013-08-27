//
//  MHInteractionType+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 8/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteractionType+Helper.h"

@implementation MHInteractionType (Helper)

-(NSMutableString *)displayTemplate {
	
	NSString *returnString = @"";
	
	if ([self.i18n isEqualToString:@"comment"]) {
		
		returnString = @"";
		
	} else if ([self.i18n isEqualToString:@"spiritual_conversation"]) {
		
		returnString = @"{{initiator}} initiated a spiritual conversation with {{receiver}}";
		
	} else if ([self.i18n isEqualToString:@"gospel_presentation"]) {
		
		returnString = @"{{initiator}} shared the gospel with {{receiver}}";
		
	} else if ([self.i18n isEqualToString:@"prayed_to_receive_christ"]) {
		
		returnString = @"{{initiator}} indicated a decision to receive Christ with {{receiver}}";
		
	} else if ([self.i18n isEqualToString:@"holy_spirit_presentation"]) {
		
		returnString = @"{{initiator}} shared a Holy Spirit presentation with {{receiver}}";
		
	} else if ([self.i18n isEqualToString:@"graduating_on_mission"]) {
		
		returnString = @"{{initiator}} helped {{receiver}} develop a plan for graduating on mission.";
		
	} else if ([self.i18n isEqualToString:@"faculty_on_mission"]) {
		
		returnString = @"{{initiator}} helped {{receiver}} develop a plan to be a faculty member on mission.";
		
	}
	
	return [returnString mutableCopy];
	
}

@end
