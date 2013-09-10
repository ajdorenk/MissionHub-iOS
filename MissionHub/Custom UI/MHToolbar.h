//
//  MHToolbar.h
//  MissionHub
//
//  Created by Michael Harrison on 9/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MHToolbarStyleCreateInteraction,
	MHToolbarStyleCreatePerson,
	MHToolbarStyleLabel,
	MHToolbarStyleMore,
	MHToolbarStyleBack,
	MHToolbarStyleMenu,
	MHToolbarStyleSave,
	MHToolbarStyleDone,
	MHToolbarStyleCancel,
} MHToolbarStyle;

extern CGFloat const MHToolBarBarButtonMarginVertical;

@interface MHToolbar : UIToolbar

+ (UIBarButtonItem *)barButtonWithStyle:(MHToolbarStyle)style target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar;
+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar;

@end
