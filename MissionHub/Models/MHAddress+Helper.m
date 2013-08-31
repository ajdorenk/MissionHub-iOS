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
	
	NSMutableArray *returnArray	= [NSMutableArray array];
	NSMutableArray *addressArray= [NSMutableArray array];
	NSMutableArray *stateArray	= [NSMutableArray array];
	
	if (self.address1) {
		[addressArray addObject:self.address1];
	}
	
	if (self.address2) {
		[addressArray addObject:self.address2];
	}
	
	if (self.state) {
		[stateArray addObject:self.state];
	}
	
	if (self.zip) {
		[stateArray addObject:self.zip];
	}
	
	if (addressArray.count > 0) {
		[returnArray addObject:[addressArray componentsJoinedByString:@" "]];
	}
	
	if (self.city) {
		[returnArray addObject:self.city];
	}
	
	if (stateArray.count > 0) {
		[returnArray addObject:[stateArray componentsJoinedByString:@" "]];
	}
	
	if (self.country) {
		[returnArray addObject:self.country];
	}
	
	return [returnArray componentsJoinedByString:@", "];
	
}

@end
