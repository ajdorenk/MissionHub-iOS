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

@interface MHCreatePersonViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<MHCreatePersonDelegate>	createPersonDelegate;
@property (nonatomic, weak) UIPopoverController			*currentPopoverController;
@property (nonatomic, strong) MHPerson					*person;

@end

@protocol MHCreatePersonDelegate <NSObject>

@optional
- (void)controller:(MHCreatePersonViewController *)controller didCreatePerson:(MHPerson *)person;

@end
