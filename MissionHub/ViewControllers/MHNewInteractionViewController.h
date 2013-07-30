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
{
	MHInteraction	*_interaction;
	
	NSMutableArray	*_interactionTypeArray;
	NSMutableArray	*_visibilityArray;
	
    CGRect			_originalCommentFrame;
}

@property (nonatomic, strong) UIBarButtonItem				*doneButton;
@property (nonatomic, strong) UIBarButtonItem				*saveButton;

@property (nonatomic, strong) MHInteraction					*interaction;

@property (nonatomic, strong) NSMutableArray				*interactionTypeArray;
@property (nonatomic, strong) NSMutableArray				*visibilityArray;

@property (nonatomic, strong) IBOutlet UIButton				*initiator;
@property (nonatomic, strong) IBOutlet UIButton				*interactionType;
@property (nonatomic, strong) IBOutlet UIImageView			*interactionTypeIcon;
@property (nonatomic, strong) IBOutlet UIButton				*receiver;
@property (nonatomic, strong) IBOutlet UIButton				*visibility;
@property (nonatomic, strong) IBOutlet UIButton				*dateTime;
@property (nonatomic, strong) IBOutlet UITextField			*comment;
@property (nonatomic, assign) CGRect						originalCommentFrame;
@property (nonatomic, strong) IBOutlet UIDatePicker			*datePicker;

@property (nonatomic, strong) MHGenericListViewController	*_initiatorsList;
@property (nonatomic, strong) UIPickerView					*_interactionTypePicker;
@property (nonatomic, strong) MHGenericListViewController	*_receiversList;
@property (nonatomic, strong) UIPickerView					*_visibilityPicker;
@property (nonatomic, strong) UIDatePicker					*_timestampPicker;


-(void)updateWithInteraction:(MHInteraction *)interaction;
-(void)saveInteraction;

@end
