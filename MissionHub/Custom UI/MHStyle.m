//
//  MHStyle.m
//  MissionHub
//
//  Created by Michael Harrison on 9/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHStyle.h"

@implementation MHStyle

+ (void)applyStyles {
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		UIImage *navBackground =[[UIImage imageNamed:@"topbar_background.png"]
								 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		[[UINavigationBar appearance] setBackgroundImage:navBackground forBarMetrics:UIBarMetricsDefault];
		[[UINavigationBar appearance] setBackgroundImage:navBackground forBarMetrics:UIBarMetricsLandscapePhone];
		
	});
	
}

@end
