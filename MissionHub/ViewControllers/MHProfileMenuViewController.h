//
//  MHProfileMenuViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHSegmentedControl.h"

@protocol MHProfileMenuDelegate <NSObject>
@optional
-(void)menuDidChangeSelection:(NSInteger)selection;

@end

@interface MHProfileMenuViewController : UIViewController

@property (nonatomic, weak) id<MHProfileMenuDelegate> menuDelegate;
@property (nonatomic, weak) IBOutlet MHSegmentedControl *segmentedControl;

- (IBAction)menuDidChangeSelection:(id)sender;
- (void)setMenuSelection:(NSInteger)selection;
- (NSInteger)menuSelection;

@end
