//
//  MHLabel+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLabel+Helper.h"

@implementation MHLabel (Helper)

-(NSString *)displayString {
	
	if (self.name) {
		return self.name;
	} else {
		return @"";
	}
	
}

@end
