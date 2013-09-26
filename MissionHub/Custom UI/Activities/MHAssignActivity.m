//
//  MHAssignActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAssignActivity.h"
#import "MHActivityViewController.h"

NSString * const MHActivityTypeAssign	= @"com.missionhub.mhactivity.type.assign";

@implementation MHAssignActivity

- (id)init
{
    self = [super initWithTitle:@"Assign"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Assign_48"]
                    actionBlock:nil];
    
    
    if (!self)
        return nil;
    
	//    __typeof(&*self) __weak weakSelf = self;
	//    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
	//        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
	//
	//    };
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeAssign;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	return YES;
	
}

@end
