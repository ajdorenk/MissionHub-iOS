//
//  MHDeleteActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHDeleteActivity.h"
#import "MHActivityViewController.h"

@implementation MHDeleteActivity

- (id)init
{
    self = [super initWithTitle:@"Delete"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Trash_48"]
                    actionBlock:nil];
    
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        
    };
    
    return self;
}

@end
