//
//  MHAddress+Helper.m
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAddress+Helper.h"

@implementation MHAddress (Helper)

- (NSString *)cityLine {
	
	NSMutableArray *returnArray	= [NSMutableArray array];
	
	if (self.city) {
		[returnArray addObject:self.city];
	}
	
	if (self.state) {
		[returnArray addObject:self.state];
	}
	
	if (self.zip) {
		[returnArray addObject:self.zip];
	}
	
	return [returnArray componentsJoinedByString:@" "];
	
}

-(NSString *)displayString {
	
	NSString *returnString = @"";
	
	if (self.address1) {
		returnString = [returnString stringByAppendingFormat:@"%@\n", self.address1];
	}
	
	if (self.address2) {
		returnString = [returnString stringByAppendingFormat:@"%@\n", self.address2];
	}
	
	if (self.city) {
		returnString = [returnString stringByAppendingFormat:@"%@ ", self.city];
	}
	
	if (self.state) {
		returnString = [returnString stringByAppendingFormat:@"%@ ", self.state];
	}
	
	if (self.zip) {
		returnString = [returnString stringByAppendingFormat:@"%@ ", self.zip];
	}
	
	if ([returnString length] > 0 && [[returnString substringFromIndex:[returnString length] - 1] isEqualToString:@" "]) {
		returnString = [[returnString substringToIndex:[returnString length] - 1] stringByAppendingString:@"\n"];
	}
	
	if (self.country) {
		returnString = [returnString stringByAppendingFormat:@"%@", self.country];
	}
	
	if ([returnString length] > 0 && [[returnString substringFromIndex:[returnString length] - 1] isEqualToString:@"\n"]) {
		returnString = [returnString substringToIndex:[returnString length] - 1];
	}
	
	return returnString;
	
}

@end
