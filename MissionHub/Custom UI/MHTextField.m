//
//  MHTextField.m
//  MissionHub
//
//  Created by Michael Harrison on 7/31/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHTextField.h"

@implementation MHTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
	
	return CGRectInset( bounds , 10 , 10 );
	
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
	
	return CGRectInset( bounds , 10 , 10 );
	
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
