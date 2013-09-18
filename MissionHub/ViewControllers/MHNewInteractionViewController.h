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

@interface MHNewInteractionViewController : UIViewController <UITextFieldDelegate, MHGenericListViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) MHInteraction					*interaction;

-(void)updateWithInteraction:(MHInteraction *)interaction andSelections:(NSArray *)selections;
-(void)saveInteraction;
-(void)setSelections:(NSArray *)selections;

@end
