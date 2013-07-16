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
        
        [self setImage:[UIImage imageNamed:@"CheckboxEmpty.png"]forState:UIControlStateNormal];
        
        [self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)checkBoxClicked {
	
    if (self.isChecked){
		
        self.isChecked = NO;
        [self setImage:[UIImage imageNamed:@"CheckboxEmpty.png" ] forState:UIControlStateNormal];
		
    } else {
		
        self.isChecked = YES;
        [self setImage:[UIImage imageNamed:@"checkbox.png"]forState:UIControlStateNormal];
		
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
