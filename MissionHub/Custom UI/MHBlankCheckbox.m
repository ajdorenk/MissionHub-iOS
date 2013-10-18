//
//  MHBlankCheckbox.m
//  MissionHub
//
//  Created by Michael Harrison on 8/3/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHBlankCheckbox.h"

@interface MHBlankCheckbox ()

@property (nonatomic, strong) UIImageView *checkmarkImageView;

- (void)configure;
- (void)checkBoxClicked;

@end

@implementation MHBlankCheckbox

@synthesize state	= _state;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
		[self configure];
		
    }
	
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)configure {
	
//	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//	
//	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]forState:UIControlStateHighlighted];
//	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]forState:UIControlStateHighlighted];
	
	self.checkmarkImageView			= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]];
	self.checkmarkImageView.frame	= self.bounds;
	[self addSubview:self.checkmarkImageView];
	
	self.state			= MHBlankCheckboxStateNone;
	
	self.exclusiveTouch	= NO;
	
	[self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)setState:(MHBlankCheckboxState)state {
	
	[self willChangeValueForKey:@"state"];
	_state	= state;
	[self didChangeValueForKey:@"state"];
	
	switch (state) {
		
		case MHBlankCheckboxStateAll:
			
			self.checkmarkImageView.image	= [UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"];
			
//			[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"] forState:UIControlStateNormal];
//			[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"] forState:UIControlStateSelected];
			
//			[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"]forState:UIControlStateNormal];
//			[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"]forState:UIControlStateSelected];
			
			break;
			
		case MHBlankCheckboxStateSome:
			
			self.checkmarkImageView.image	= [UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_Dash.png"];
			
//			[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_Dash.png"] forState:UIControlStateNormal];
//			[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_Dash.png"] forState:UIControlStateSelected];
			
//			[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_Dash.png"]forState:UIControlStateNormal];
//			[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_Dash.png"]forState:UIControlStateSelected];
			
			break;
			
		case MHBlankCheckboxStateNone:
			
			self.checkmarkImageView.image	= [UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"];
			
//			[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"] forState:UIControlStateNormal];
//			[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"] forState:UIControlStateSelected];
			
//			[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]forState:UIControlStateNormal];
//			[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]forState:UIControlStateSelected];
			
			break;
			
		default:
			break;
			
	}
	
	//self.selected = ( self.selected ? NO : YES );
	
}

- (void)checkBoxClicked {
	
	if ([self.checkboxDelegate respondsToSelector:@selector(checkboxDidGetTapped:)]) {
		
		[self.checkboxDelegate checkboxDidGetTapped:self];
		
	}
	
}

@end
