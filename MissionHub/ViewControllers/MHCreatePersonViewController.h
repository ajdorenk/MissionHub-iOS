//
//  MHCreatePersonViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"

@protocol MHCreatePersonDelegate;

@interface MHCreatePersonViewController : UIViewController <UITextFieldDelegate> {
	
	__weak id<MHCreatePersonDelegate> _createPersonDelegate;
	
	MHPerson		*_person;
	CGSize			_oldSize;
	CGRect			_originalContentFrame;
	CGPoint			_originalContentOffset;
	UITextField		*_activeTextField;
	
	UIBarButtonItem *_saveButton;
	UIBarButtonItem *_doneButton;
	
}

@property (nonatomic, weak) id<MHCreatePersonDelegate> createPersonDelegate;

@property (nonatomic, strong) MHPerson				*person;

@property (nonatomic, weak) IBOutlet UIScrollView	*scrollView;
@property (nonatomic, assign) CGSize				oldSize;
@property (nonatomic, assign) CGRect				originalContentFrame;
@property (nonatomic, assign) CGPoint				originalContentOffset;
@property (nonatomic, strong) UITextField			*activeTextField;


@property (nonatomic, weak) IBOutlet MHTextField	*firstName;
@property (nonatomic, weak) IBOutlet MHTextField	*lastName;
@property (nonatomic, weak) IBOutlet MHTextField	*email;
@property (nonatomic, weak) IBOutlet MHTextField	*phone;
@property (nonatomic, weak) IBOutlet MHTextField	*address1;
@property (nonatomic, weak) IBOutlet MHTextField	*address2;
@property (nonatomic, weak) IBOutlet MHTextField	*city;
@property (nonatomic, weak) IBOutlet MHTextField	*state;
@property (nonatomic, weak) IBOutlet MHTextField	*country;
@property (nonatomic, weak) IBOutlet MHTextField	*zip;
@property (nonatomic, weak) IBOutlet UISegmentedControl	*gender;
@property (nonatomic, weak) IBOutlet UISegmentedControl	*permissionLevel;

@property (nonatomic, strong) UIBarButtonItem		*saveButton;
@property (nonatomic, strong) UIBarButtonItem		*doneButton;

- (void)updateWithPerson:(MHPerson *)person;

@end

@protocol MHCreatePersonDelegate <NSObject>

@optional
- (void)controller:(MHCreatePersonViewController *)controller didCreatePerson:(MHPerson *)person;

@end
