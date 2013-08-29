//
//  MHInteractionCellHeader.m
//  MissionHub
//
//  Created by Michael Harrison on 8/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteractionCellHeader.h"

CGFloat const MHInteractionCellHeaderHeight				= 60.0;
CGFloat const MHInteractionCellMargin					= 10.0;
NSString * const MHInteractionCellBackgroundImageName	= @"MH_Mobile_Title_Gradient_120.png";


NSString * const MHInteractionCellTitleFont				= @"ArialMT";
CGFloat const MHInteractionCellTitleFontSize			= 18.0;
NSString * const MHInteractionCellDateFont				= @"ArialMT";
CGFloat const MHInteractionCellDateFontSize				= 12.0;

@implementation MHInteractionCellHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithInteraction:(MHInteraction *)interaction forTableView:(UITableView *)tableview {
	
	self = [self initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableview.frame), MHInteractionCellHeaderHeight)];
	
	if (self) {
		
		self.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.000];
		
		CGSize titleSize = [interaction.title sizeWithFont:[UIFont fontWithName:MHInteractionCellTitleFont size:MHInteractionCellTitleFontSize] constrainedToSize:CGSizeMake(CGRectGetWidth(tableview.frame) - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		UILabel *titleLabel			= [[UILabel alloc] initWithFrame:CGRectMake(MHInteractionCellMargin, MHInteractionCellMargin, titleSize.width, titleSize.height)];
		titleLabel.font				= [UIFont fontWithName:MHInteractionCellTitleFont size:MHInteractionCellTitleFontSize];
		titleLabel.textColor		= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
		titleLabel.lineBreakMode	= LINE_BREAK_WORD_WRAP;
		titleLabel.numberOfLines	= 0;
		titleLabel.text				= interaction.title;
		
		CGSize dateSize = [interaction.timestampString sizeWithFont:[UIFont fontWithName:MHInteractionCellDateFont size:MHInteractionCellDateFontSize] constrainedToSize:CGSizeMake(CGRectGetWidth(tableview.frame) - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		UILabel *dateLabel			= [[UILabel alloc] initWithFrame:CGRectMake(MHInteractionCellMargin, CGRectGetHeight(titleLabel.frame) + MHInteractionCellMargin * 0.5, dateSize.width, dateSize.height)];
		dateLabel.font				= [UIFont fontWithName:MHInteractionCellDateFont size:MHInteractionCellDateFontSize];
		dateLabel.textColor			= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
		dateLabel.lineBreakMode		= LINE_BREAK_WORD_WRAP;
		dateLabel.numberOfLines		= 0;
		dateLabel.text				= interaction.timestampString;
		
		[self addSubview:titleLabel];
		[self addSubview:dateLabel];
		
	}
	
	return self;
	
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
