//
//  MHGenericCell.m
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGenericCell.h"

CGFloat const MHGenericCellMarginHorizontal	= 5.0;

@implementation MHGenericCell

@synthesize label, checkmark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.checkmark.checkboxDelegate = self;
		
    }
    return self;
}

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.checkmark.checkboxDelegate = self;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	
}

-(void)populateWithTitle:(NSString *)text forObject:(id)object andSelected:(BOOL)selected atIndexPath:(NSIndexPath *)indexPath {
	
	self.label.text	= text;
	self.object		= object;
	self.indexPath	= indexPath;
	
	[self.checkmark setSelected:selected];
	
}

-(void)checkbox:(MHCheckbox *)checkbox didChangeValue:(BOOL)checked {
	
	if (checked) {
		
		if ([self.cellDelegate respondsToSelector:@selector(cell:didSelectPerson:atIndexPath:)]) {
			
			[self.cellDelegate cell:self didSelectPerson:self.object atIndexPath:self.indexPath];
			
		}
		
	} else {
		
		if ([self.cellDelegate respondsToSelector:@selector(cell:didDeselectPerson:atIndexPath:)]) {
			
			[self.cellDelegate cell:self didDeselectPerson:self.object atIndexPath:self.indexPath];
			
		}
		
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
