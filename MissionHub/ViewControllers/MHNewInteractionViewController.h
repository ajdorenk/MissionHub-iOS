//
//  MHNewInteractionViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/9/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHGenericListViewController.h"

@interface MHNewInteractionViewController : UIViewController <UITextFieldDelegate, MHGenericListViewControllerDelegate >
{
    CGRect originalCommentFrame;
}


@property (nonatomic, strong) IBOutlet UIButton *initiator;
@property (nonatomic, strong) IBOutlet UIButton *interaction;
@property (nonatomic, strong) IBOutlet UIButton *receiver;
@property (nonatomic, strong) IBOutlet UIButton *visibility;
@property (nonatomic, strong) IBOutlet UIButton *dateTime;
@property (nonatomic, strong) IBOutlet UITextField *comment;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UITextField *activeField;
@property (nonatomic, strong) UILabel *listLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImagePickerController* imagePickerController;
@property (nonatomic, strong) UIToolbar* pickerToolbar;
@property (nonatomic, strong) UIActionSheet* pickerViewDate;
@property (nonatomic, strong) MHInteraction* interactionObject;

@end
