//
//  MHTextField.m
//  MissionHub
//
//  Created by Michael Harrison on 7/31/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHTextField.h"

@implementation MHTextField

@synthesize textInset			= _textInset;
@synthesize editingTextInset	= _editingTextInset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.textInset			= UIEdgeInsetsMake(10, 10, 10, 10);
		self.editingTextInset	= UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.textInset			= UIEdgeInsetsMake(10, 10, 10, 10);
	self.editingTextInset	= UIEdgeInsetsMake(10, 10, 10, 10);
	
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	
	return UIEdgeInsetsInsetRect(bounds, self.textInset);
	
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	
	return UIEdgeInsetsInsetRect(bounds, self.editingTextInset);
	
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
