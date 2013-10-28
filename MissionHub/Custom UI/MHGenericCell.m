//
//  MHGenericCell.m
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGenericCell.h"

CGFloat const MHGenericCellMarginHorizontal	= 5.0;

@interface MHGenericCell ()

- (void)configure;
- (MHGenericCellState)stateFromCheckBoxState:(MHBlankCheckboxState)state;

@end

@implementation MHGenericCell

@synthesize state		= _state;
@synthesize label		= _label;
@synthesize checkmark	= _checkmark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
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
	
	self.backgroundColor			= [UIColor whiteColor];
	self.checkmark.checkboxDelegate = self;
	
}

- (void)populateWithTitle:(NSString *)text forObject:(id)object andState:(MHGenericCellState)state atIndexPath:(NSIndexPath *)indexPath {
	
	self.label.text	= text;
	self.object		= object;
	self.indexPath	= indexPath;
	self.state		= state;
	
}

- (MHGenericCellState)stateFromCheckBoxState:(MHBlankCheckboxState)state {
	
	switch (state) {
			
		case MHBlankCheckboxStateAll:
			
			return MHGenericCellStateAll;
			
			break;
			
		case MHBlankCheckboxStateSome:
			
			return MHGenericCellStateSome;
			
			break;
			
		case MHBlankCheckboxStateNone:
			
			return MHGenericCellStateNone;
			
			break;
			
		default:
			break;
	}
	
	return MHGenericCellStateNone;
	
}

- (MHGenericCellState)state {
	
	return [self stateFromCheckBoxState:self.checkmark.state];
	
}

- (void)setState:(MHGenericCellState)state {
	
	if (self.checkmark) {
		
		switch (state) {
				
			case MHGenericCellStateAll:
				
				self.checkmark.state	= MHBlankCheckboxStateAll;
				
				break;
				
			case MHGenericCellStateSome:
				
				self.checkmark.state	= MHBlankCheckboxStateSome;
				
				break;
				
			case MHGenericCellStateNone:
				
				self.checkmark.state	= MHBlankCheckboxStateNone;
				
				break;
				
			default:
				break;
		}
		
	}
	
}

- (void)checkboxDidGetTapped:(MHBlankCheckbox *)checkbox {
	
	if ([self.cellDelegate respondsToSelector:@selector(cell:didChangeStateForObject:atIndexPath:)]) {
		
		[self.cellDelegate cell:self didChangeStateForObject:self.object atIndexPath:self.indexPath];
		
	}
	
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	self.checkmark.frame	= CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.checkmark.frame) - MHGenericCellMarginHorizontal,
									 CGRectGetMinY(self.checkmark.frame),
									 CGRectGetWidth(self.checkmark.frame),
									 CGRectGetHeight(self.checkmark.frame));
	self.label.frame		= CGRectMake(CGRectGetMinX(self.label.frame),
									 CGRectGetMinY(self.label.frame),
									 CGRectGetWidth(self.frame) - CGRectGetMinX(self.label.frame) - 2 * MHGenericCellMarginHorizontal - CGRectGetWidth(self.checkmark.frame),
									 CGRectGetHeight(self.label.frame));
	
}

@end
