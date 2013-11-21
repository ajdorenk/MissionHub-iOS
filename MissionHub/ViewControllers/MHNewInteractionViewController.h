//
//  MHNewInteractionViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/9/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHGenericListViewController.h"
#import "MHInteraction.h"

@protocol MHCreateInteractionDelegate;

@interface MHNewInteractionViewController : UIViewController <UITextViewDelegate, MHGenericListViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<MHCreateInteractionDelegate>	createInteractionDelegate;
@property (nonatomic, weak) UIPopoverController				*currentPopoverController;
@property (nonatomic, strong) MHInteraction					*interaction;

-(void)updateWithInteraction:(MHInteraction *)interaction andSelections:(NSArray *)selections;
-(void)saveInteraction;
-(void)setSelections:(NSArray *)selections;

@end


@protocol MHCreateInteractionDelegate <NSObject>

@optional
- (void)controller:(MHNewInteractionViewController *)controller didCreateInteraction:(MHInteraction *)interaction;

@end