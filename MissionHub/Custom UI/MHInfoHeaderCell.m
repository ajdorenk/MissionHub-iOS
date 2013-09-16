//
//  MHInfoHeaderCell.m
//  MissionHub
//
//  Created by Michael Harrison on 9/16/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInfoHeaderCell.h"

@interface MHInfoHeaderCell ()

@property (nonatomic, strong) CAGradientLayer *gradient;

- (void)configure;

@end

@implementation MHInfoHeaderCell

@synthesize gradient	= _gradient;
@synthesize text		= _text;

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
	
	UIView *background					= [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
	self.gradient						= [CAGradientLayer layer];
	self.gradient.frame					= CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
	self.gradient.colors				= [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1.000] CGColor], nil];
	[background.layer addSublayer:self.gradient];
	
	self.backgroundView					= background;
	
	self.textLabel.font			= [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
	self.textLabel.textColor	= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
	
}

- (void)setText:(NSString *)text {
	
	[self willChangeValueForKey:@"text"];
	_text	= text;
	[self didChangeValueForKey:@"text"];
	
	self.textLabel.text	= text;
	
}

- (void)layoutSubviews {
	
	self.gradient.frame	= CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
	self.textLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
	
}

@end
