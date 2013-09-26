//
//  MHActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHActivity.h"
#import "MHActivityViewController.h"

NSString * const MHActivityTypeDefault	= @"com.missionhub.mhactivity.type.default";

@implementation MHActivity

- (NSString *)activityType {
	
	return MHActivityTypeDefault;
	
}

- (void)activityDidFinish:(BOOL)completed {
	
	MHActivityViewController *activityViewController = (MHActivityViewController *)self.activityViewController;
	
	if ([activityViewController.delegate respondsToSelector:@selector(activityDidFinish:)]) {
		
		[activityViewController.delegate activityDidFinish:completed];
		
	}
	
}

@end
