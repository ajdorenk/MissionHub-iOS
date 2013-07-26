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
@synthesize isChecked;


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"]forState:UIControlStateNormal];
		[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_24.png"]forState:UIControlStateSelected];
		//[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_24.png"]forState:UIControlStateHighlighted];
        
        [self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
		
		self.isChecked = NO;
		
    }
    return self;
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"]forState:UIControlStateNormal];
	[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_24.png"]forState:UIControlStateSelected];
	//[self setImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_24.png"]forState:UIControlStateHighlighted];
	
	[self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
	
	self.isChecked = NO;
	
}

//TODO:The action bar still needs to be created and popup when the checkbox is clicked, (though I'm not entirely sure where to do that)
- (void)checkBoxClicked {
	
    if (self.isChecked){
		
        self.isChecked = NO;
		[self setSelected:NO];
		
    } else {
		
        self.isChecked = YES;
		[self setSelected:YES];
		
    }
	
	if ([self.checkboxDelegate respondsToSelector:@selector(checkbox:didChangeValue:)]) {
		
		[self.checkboxDelegate checkbox:self didChangeValue:self.isChecked];
		
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
