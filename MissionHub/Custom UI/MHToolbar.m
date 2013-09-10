//
//  MHToolbar.m
//  MissionHub
//
//  Created by Michael Harrison on 9/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHToolbar.h"

CGFloat const MHToolBarBarButtonMarginVertical = 4.0;

@interface MHToolbar ()

- (void)configure;

@end

@implementation MHToolbar

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
	
    if (self) {
		
        // Initialization code
		[self configure];
		
    }
	
    return self;
	
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	// Initialization code
	[self configure];
	
}

- (void)configure {
	
}

+ (UIBarButtonItem *)barButtonWithStyle:(MHToolbarStyle)style target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar {
	
	NSString *imageName = @"";
	
	switch (style) {
			
		case MHToolbarStyleBack:
			
			imageName = @"BackMenu_Icon.png";
			break;
			
		case MHToolbarStyleCreateInteraction:
			
			imageName = @"NewInteraction_Icon.png";
			break;
			
		case MHToolbarStyleCreatePerson:
			
			imageName = @"NewContact_Icon.png";
			break;
			
		case MHToolbarStyleLabel:
			
			imageName = @"topbarTag_button.png";
			break;
			
		case MHToolbarStyleMenu:
			
			imageName = @"MH_Mobile_Icon_Menu.png";
			break;
			
		case MHToolbarStyleMore:
			
			imageName = @"topbarOtherOptions_button.png";
			break;
			
		case MHToolbarStyleCancel:
			
			imageName = @"MH_Mobile_Button_Cancel_72.png";
			break;
			
		case MHToolbarStyleDone:
			
			imageName = @"MH_Mobile_Button_Done_72.png";
			break;
			
		case MHToolbarStyleSave:
			
			imageName = @"MH_Mobile_Button_Save_72.png";
			break;
			
		default:
			break;
	}

	UIImage *image = [UIImage imageNamed:imageName];

	return [MHToolbar barButtonWithImage:image target:target selector:selector forBar:navigationOrToolbar];

}

+ (UIBarButtonItem *)barButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar {
	
	UIImage *buttonImage	= ( image ? image : [[UIImage alloc] init] );
	CGRect frame			= CGRectZero;
	frame.size				= image.size;
	CGFloat barHeight		= ( CGRectGetHeight(navigationOrToolbar.frame) ? CGRectGetHeight(navigationOrToolbar.frame) : 32);
	
	if (frame.size.height >= barHeight - 2 * MHToolBarBarButtonMarginVertical) {
		
		CGFloat newHeight	= barHeight - 2 * MHToolBarBarButtonMarginVertical;
		CGFloat ratio		= newHeight / CGRectGetHeight(frame);
		
		frame.size			= CGSizeMake( ratio * CGRectGetWidth(frame) , newHeight);
		
	}
	
    UIButton *button		= [[UIButton alloc] initWithFrame:frame];
	
    [button setImage:buttonImage forState:UIControlStateNormal];
	
	if (target && selector) {
		
		[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
		
	}
	
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	return ( barButton ? barButton : [[UIBarButtonItem alloc] init]);
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
