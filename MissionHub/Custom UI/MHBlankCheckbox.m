//
//  MHBlankCheckbox.m
//  MissionHub
//
//  Created by Michael Harrison on 8/3/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHBlankCheckbox.h"

@implementation MHBlankCheckbox

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
		
		[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark_24.png"]forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateSelected];
		[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateHighlighted];
		
        [self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark_24.png"]forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateSelected];
		[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateHighlighted];
		
		self.exclusiveTouch = NO;
		
    }
    return self;
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark_24.png"]forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateSelected];
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateHighlighted];
	
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_No_Checkmark_24.png"]forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateSelected];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_No_Box_Checkmark_24.png"]forState:UIControlStateHighlighted];
	
	self.exclusiveTouch = NO;
	
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
