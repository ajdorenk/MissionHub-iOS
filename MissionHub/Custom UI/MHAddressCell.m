//
//  MHAddressCell.m
//  MissionHub
//
//  Created by Michael Harrison on 8/30/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAddressCell.h"

static NSString * const MHAddressCellFont			= @"ArialMT";
static CGFloat const MHAddressCellFontSize			= 16;
static CGFloat const MHAddressCellMargin			= 10.0f;

@interface MHAddressCell ()

- (void)configure;

@end

@implementation MHAddressCell

@synthesize address			= _address;
@synthesize lineOneLabel	= _lineOneLabel;
@synthesize lineTwoLabel	= _lineTwoLabel;
@synthesize cityLabel		= _cityLabel;
@synthesize countryLabel	= _countryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self configure];
    
    return self;
	
}


- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)configure {
	
	self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
	self.lineOneLabel				= [[UILabel alloc] initWithFrame:CGRectZero];
    self.lineOneLabel.font			= [UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize];
    self.lineOneLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.lineOneLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    self.lineOneLabel.numberOfLines = 0;
	
	self.lineTwoLabel				= [[UILabel alloc] initWithFrame:CGRectZero];
    self.lineTwoLabel.font			= [UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize];
    self.lineTwoLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.lineTwoLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    self.lineTwoLabel.numberOfLines = 0;
	
	self.cityLabel					= [[UILabel alloc] initWithFrame:CGRectZero];
    self.cityLabel.font				= [UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize];
    self.cityLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.cityLabel.lineBreakMode	= LINE_BREAK_WORD_WRAP;
    self.cityLabel.numberOfLines	= 0;
	
	self.countryLabel				= [[UILabel alloc] initWithFrame:CGRectZero];
    self.countryLabel.font			= [UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize];
    self.countryLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.countryLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    self.countryLabel.numberOfLines = 0;
	
	[self.contentView addSubview:self.lineOneLabel];
	[self.contentView addSubview:self.lineTwoLabel];
	[self.contentView addSubview:self.cityLabel];
	[self.contentView addSubview:self.countryLabel];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setAddress:(MHAddress *)address {
	
    [self willChangeValueForKey:@"address"];
    _address = address;
    [self didChangeValueForKey:@"address"];
    
	self.lineOneLabel.text		= self.address.address1;
	self.lineTwoLabel.text		= self.address.address2;
	self.cityLabel.text			= self.address.cityLine;
	self.countryLabel.text		= self.address.country;
	
}

+ (CGFloat)heightForCellWithAddress:(MHAddress *)address {
	
    CGFloat height = MHAddressCellMargin;
	
	if (address.address1.length > 0) {
		
		height += ceilf([address.address1 sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height);
		
	}
	
	if (address.address2.length > 0) {
		
		height += ceilf([address.address2 sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height);
		
	}
	
	if (address.cityLine.length > 0) {
		
		height += ceilf([address.cityLine sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height);
		
	}
	
	if (address.country.length > 0) {
		
		height += ceilf([address.country sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height);
		
	}
	
	if (height == MHAddressCellMargin) {
		
		height = 0;
		
	} else {
		
		height += MHAddressCellMargin;
		
	}
	
    return height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    
	[super layoutSubviews];
	
    self.textLabel.hidden			= YES;
    self.detailTextLabel.hidden		= YES;
	
	if (self.address.address1.length > 0) {
		
		CGSize textSize = [self.address.address1 sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		self.lineOneLabel.frame		= CGRectMake(MHAddressCellMargin, MHAddressCellMargin, textSize.width, textSize.height);
		self.lineOneLabel.hidden	= NO;
		
	} else {
		
		self.lineOneLabel.hidden	= YES;
		self.lineOneLabel.frame		= CGRectZero;
		
	}
	
	if (self.address.address2.length > 0) {
		
		CGSize textSize = [self.address.address2 sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		self.lineTwoLabel.frame		= CGRectMake(MHAddressCellMargin, CGRectGetMaxY(self.lineOneLabel.frame), textSize.width, textSize.height);
		self.lineTwoLabel.hidden	= NO;
		
	} else {
		
		self.lineTwoLabel.hidden	= YES;
		self.lineTwoLabel.frame		= CGRectMake(CGRectGetMinX(self.lineOneLabel.frame), CGRectGetMaxY(self.lineOneLabel.frame), 0, 0);
		
	}
	
	if (self.address.cityLine.length > 0) {
		
		CGSize textSize = [self.address.cityLine sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		self.cityLabel.frame		= CGRectMake(MHAddressCellMargin, CGRectGetMaxY(self.lineTwoLabel.frame), textSize.width, textSize.height);
		self.cityLabel.hidden		= NO;
		
	} else {
		
		self.cityLabel.hidden		= YES;
		self.cityLabel.frame		= CGRectMake(CGRectGetMinX(self.lineTwoLabel.frame), CGRectGetMaxY(self.lineTwoLabel.frame), 0, 0);
		
	}
	
	if (self.address.country.length > 0) {
		
		CGSize textSize = [self.address.country sizeWithFont:[UIFont fontWithName:MHAddressCellFont size:MHAddressCellFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAddressCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		self.countryLabel.frame		= CGRectMake(MHAddressCellMargin, CGRectGetMaxY(self.cityLabel.frame), textSize.width, textSize.height);
		self.countryLabel.hidden	= NO;
		
	} else {
		
		self.countryLabel.hidden	= YES;
		self.countryLabel.frame		= CGRectMake(CGRectGetMinX(self.cityLabel.frame), CGRectGetMaxY(self.cityLabel.frame), 0, 0);
		
	}
	
}

@end
