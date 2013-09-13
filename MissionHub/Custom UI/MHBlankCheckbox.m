//
//  MHBlankCheckbox.m
//  MissionHub
//
//  Created by Michael Harrison on 8/3/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHBlankCheckbox.h"

@interface MHBlankCheckbox ()

- (void)configure;

@end

@implementation MHBlankCheckbox

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
	
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"]forState:UIControlStateSelected];
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"]forState:UIControlStateHighlighted];
	
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark.png"]forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"]forState:UIControlStateSelected];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark.png"]forState:UIControlStateHighlighted];
	
	self.exclusiveTouch = NO;
	
}

@end
