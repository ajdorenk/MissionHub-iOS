//
//  MHSegmentedControl.m
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSegmentedControl.h"

@interface MHSegmentedControl ()

- (void)configure;

@end

@implementation MHSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self configure];
    }
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)configure {
	
    self.layer.shadowOpacity	= 0.4;
	self.borderColor			= [UIColor colorWithRed:0.824 green:0.824 blue:0.824 alpha:1.000];
	
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
