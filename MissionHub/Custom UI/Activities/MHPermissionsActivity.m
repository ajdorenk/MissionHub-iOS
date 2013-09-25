//
//  MHPermissionsActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPermissionsActivity.h"
#import "MHActivityViewController.h"

@implementation MHPermissionsActivity

- (id)init
{
    self = [super initWithTitle:@"Permission"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Permissions_48"]
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

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	return YES;
	
}

@end
