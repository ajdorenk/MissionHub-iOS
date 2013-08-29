//
//  MHHeaderCell.m
//  MissionHub
//
//  Created by Michael Harrison on 8/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHHeaderCell.h"

CGFloat const MHHeaderCellHeight					= 60.0;
CGFloat const MHHeaderCellMargin					= 10.0;
NSString * const MHHeaderCellBackgroundImageName	= @"MH_Mobile_Title_Gradient_120.png";

NSString * const MHHeaderCellTitleFont				= @"ArialMT";
CGFloat const MHHeaderCellTitleFontSize				= 18.0;
NSString * const MHHeaderCellDateFont				= @"ArialMT";
CGFloat const MHHeaderCellDateFontSize				= 12.0;

@implementation MHHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
	if (self) {
		
		UIView *background					= [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), MHHeaderCellHeight)];
		CAGradientLayer *gradient			= [CAGradientLayer layer];
        gradient.frame						= CGRectMake(0, 0, CGRectGetWidth(self.frame), MHHeaderCellHeight);
        gradient.colors						= [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1.000] CGColor], nil];
        [background.layer addSublayer:gradient];
		
		self.backgroundView					= background;
		
		self.textLabel.font					= [UIFont fontWithName:MHHeaderCellTitleFont size:MHHeaderCellTitleFontSize];
		self.textLabel.textColor			= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
		self.textLabel.lineBreakMode		= LINE_BREAK_WORD_WRAP;
		self.textLabel.numberOfLines		= 0;
		
		self.detailTextLabel.font			= [UIFont fontWithName:MHHeaderCellDateFont size:MHHeaderCellDateFontSize];
		self.detailTextLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
		self.detailTextLabel.lineBreakMode	= LINE_BREAK_WORD_WRAP;
		self.detailTextLabel.numberOfLines	= 0;
		
    }
	
    return self;
}

- (void)configureCellWithTitle:(NSString *)title andDate:(NSString *)date forTableview:(UITableView *)tableview {
	
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:MHHeaderCellBackgroundImageName]];
	
	CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:MHHeaderCellTitleFont size:MHHeaderCellTitleFontSize] constrainedToSize:CGSizeMake(CGRectGetWidth(tableview.frame) - (2 * MHHeaderCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
	
	self.textLabel.frame				= CGRectMake(MHHeaderCellMargin, MHHeaderCellMargin, titleSize.width, titleSize.height);
	self.textLabel.font					= [UIFont fontWithName:MHHeaderCellTitleFont size:MHHeaderCellTitleFontSize];
	self.textLabel.textColor			= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
	self.textLabel.lineBreakMode		= LINE_BREAK_WORD_WRAP;
	self.textLabel.numberOfLines		= 0;
	self.textLabel.text					= title;
	
	CGSize dateSize = [date sizeWithFont:[UIFont fontWithName:MHHeaderCellDateFont size:MHHeaderCellDateFontSize] constrainedToSize:CGSizeMake(CGRectGetWidth(tableview.frame) - (2 * MHHeaderCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
	
	self.detailTextLabel.frame			= CGRectMake(MHHeaderCellMargin, CGRectGetHeight(self.textLabel.frame) + MHHeaderCellMargin * 0.5, dateSize.width, dateSize.height);
	self.detailTextLabel.font			= [UIFont fontWithName:MHHeaderCellDateFont size:MHHeaderCellDateFontSize];
	self.detailTextLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	self.detailTextLabel.lineBreakMode	= LINE_BREAK_WORD_WRAP;
	self.detailTextLabel.numberOfLines	= 0;
	self.detailTextLabel.text			= date;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
