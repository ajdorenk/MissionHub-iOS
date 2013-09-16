//
//  MHInfoCell.m
//  MissionHub
//
//  Created by Michael Harrison on 7/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInfoCell.h"

@interface MHInfoCell ()

@property (nonatomic, strong) CAGradientLayer *gradient;

- (void)configure;

@end

@implementation MHInfoCell

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
	
	self.layer.backgroundColor		= [UIColor whiteColor].CGColor;
	self.layer.shouldRasterize		= YES;
    self.layer.rasterizationScale	= [[UIScreen mainScreen] scale];
    
	UIView *background				= [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
	background.backgroundColor		= [UIColor whiteColor];
	self.backgroundView				= background;
	
	self.textLabel.font			= [UIFont fontWithName:@"ArialMT" size:16.0];
	self.textLabel.textColor	= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	
}

- (void)setText:(NSString *)text {
	
	[self willChangeValueForKey:@"text"];
	_text	= text;
	[self didChangeValueForKey:@"text"];
	
	self.textLabel.text	= text;
	
}

@end
