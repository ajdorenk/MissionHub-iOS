//
//  MHTextView.m
//  MissionHub
//
//  Created by Michael Harrison on 11/21/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHTextView.h"

@interface MHTextView ()

- (void)configure;

@end

@implementation MHTextView

@synthesize textInset			= _textInset;
@synthesize editingTextInset	= _editingTextInset;

- (id)initWithFrame:(CGRect)frame {
	
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
	
	self.editable		= YES;
	self.textAlignment	= UITextAlignmentLeft;
	
	self.textInset			= UIEdgeInsetsMake(10, 10, 0, 10);
	self.editingTextInset	= UIEdgeInsetsMake(10, 10, 0, 10);
	
}

- (void)setTextInset:(UIEdgeInsets)textInset {
	
	self.contentInset	= textInset;
	
}

- (void)setEditingTextInset:(UIEdgeInsets)editingTextInset {
	
	self.contentInset	= editingTextInset;
	
}

@end
