//
//  MHCheckbox.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/17/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHCheckbox.h"

@implementation MHCheckbox

@synthesize checkboxDelegate = _checkboxDelegate;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
		[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_UnChecked_48_padded.png"]forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_48_padded.png"]forState:UIControlStateSelected];
		[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_PartiallyChecked_48_padded.png"]forState:UIControlStateHighlighted];
		
        [self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_UnChecked_48_padded.png"]forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_48_padded.png"]forState:UIControlStateSelected];
		[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_PartiallyChecked_48_padded.png"]forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
		
    }
    return self;
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_UnChecked_48_padded.png"]forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_48_padded.png"]forState:UIControlStateSelected];
	[self setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_PartiallyChecked_48_padded.png"]forState:UIControlStateHighlighted];
	
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_UnChecked_48_padded.png"]forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_48_padded.png"]forState:UIControlStateSelected];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_PartiallyChecked_48_padded.png"]forState:UIControlStateHighlighted];
	
	[self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
	
	
}

- (void)checkBoxClicked {
	
    if (self.selected){
		
		self.selected	= NO;
		
    } else {
		
		self.selected	= YES;
		
    }
	
	if ([self.checkboxDelegate respondsToSelector:@selector(checkbox:didChangeValue:)]) {
		
		[self.checkboxDelegate checkbox:self didChangeValue:self.selected];
		
	}
	
}

/*-(void)dealloc{
    [super dealloc];
}
 */
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
