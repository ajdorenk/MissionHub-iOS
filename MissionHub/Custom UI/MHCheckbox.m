//
//  MHCheckbox.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/17/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHCheckbox.h"

@implementation MHCheckbox
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

- (IBAction)checkBoxClicked{
    if(self.isChecked==NO){
        self.isChecked =YES;
        [self setImage:[UIImage imageNamed:@"checkbox.png" ] forState:UIControlStateNormal];
    }
    else{
        self.isChecked = NO;
        [self setImage:[UIImage imageNamed:@"CheckboxEmpty.png"]forState:UIControlStateNormal];
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
