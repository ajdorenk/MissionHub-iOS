//
//  MHLabelActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLabelActivity.h"
#import "MHActivityViewController.h"

NSString * const MHActivityTypeLabel	= @"com.missionhub.mhactivity.type.label";

@implementation MHLabelActivity

- (id)init
{
    self = [super initWithTitle:@"Label"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Label_48"]
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
	
	return MHActivityTypeLabel;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	return YES;
	
}

@end
