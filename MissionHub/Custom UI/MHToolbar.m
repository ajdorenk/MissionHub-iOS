//
//  MHToolbar.m
//  MissionHub
//
//  Created by Michael Harrison on 9/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHToolbar.h"

CGFloat const MHToolBarBarButtonMarginVertical		= 4.0;
static CGFloat const MHToolBarBarButtonFontSize		= 12;
static NSString * const MHToolBarBarButtonFont		= @"Arial-BoldMT";

@interface MHToolbar ()

+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar;
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
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		UIImage *background		= [[UIImage imageNamed:@"MH_Mobile_Topbar_Background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		[[UIToolbar appearance] setBackgroundImage:background forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
		
	});
	
	self.layer.shadowColor		= [[UIColor blackColor] CGColor];
    self.layer.shadowOffset		= CGSizeMake(0.0, 1.0);
	self.layer.shadowRadius		= 1.0;
    self.layer.shadowOpacity	= 0.75;
    self.layer.masksToBounds	= NO;
    self.layer.shouldRasterize	= YES;
	
}

+ (UIBarButtonItem *)barButtonWithStyle:(MHToolbarStyle)style target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar {
	
	NSString *imageName = @"";
	NSString *title		= @"";
	
	switch (style) {
			
		case MHToolbarStyleBack:
			
			imageName = @"MH_Mobile_Icon_LeftArrow.png";
			break;
			
		case MHToolbarStyleCreateInteraction:
			
			imageName = @"MH_Mobile_Icon_NewInteraction.png";
			break;
			
		case MHToolbarStyleCreatePerson:
			
			imageName = @"MH_Mobile_Icon_AddContact.png";
			break;
			
		case MHToolbarStyleLabel:
			
			imageName = @"MH_Mobile_Icon_Labels.png";
			break;
			
		case MHToolbarStyleMenu:
			
			imageName = @"MH_Mobile_Icon_Menu.png";
			break;
			
		case MHToolbarStyleMore:
			
			imageName = @"MH_Mobile_Icon_DownArrow.png";
			break;
			
		case MHToolbarStyleCancel:
			
			title		= @"Cancel";
			imageName	= @"MH_Mobile_Menu_Button_Red_72.png";
			break;
			
		case MHToolbarStyleDone:
			
			//title		= @"Done";
			imageName	= @"MH_Mobile_Button_Done_72.png";
			break;
			
		case MHToolbarStyleSave:
			
			//title		= @"Save";
			imageName	= @"MH_Mobile_Button_Save_72.png";
			break;
			
		default:
			break;
	}

	UIImage *image = [UIImage imageNamed:imageName];

	return [MHToolbar barButtonWithTitle:title image:image target:target selector:selector forBar:navigationOrToolbar];

}

+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector forBar:(UIView *)navigationOrToolbar {
	
	NSString *buttonTitle	= ( title ? title : @"" );
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
	
	[button setTitle:buttonTitle forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.titleLabel.font	= [UIFont fontWithName:MHToolBarBarButtonFont size:MHToolBarBarButtonFontSize];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
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