//
//  MHActivityViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "REActivityViewController.h"
#import "MHActivities.h"

@protocol MHActivityViewControllerDelegate;

@interface MHActivityViewController : REActivityViewController

@property (nonatomic, weak) id<MHActivityViewControllerDelegate> delegate;

+ (NSArray *)allActivities;

@end

@protocol MHActivityViewControllerDelegate <NSObject>

@optional
- (void)activityDidFinish:(NSString *)activityType completed:(BOOL)completed;

@end