//
//  MHInteractionCell.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/2/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHInteractionCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static NSString * const MHInteractionCellDescriptionFont	= @"ArialMT";
static CGFloat const MHInteractionCellDescriptionFontSize	= 14;
static NSString * const MHInteractionCellNameFont			= @"Arial-BoldMT";
static CGFloat const MHInteractionCellNameFontSize			= 14;
static NSString * const MHInteractionCellCommentFont		= @"Arial-ItalicMT";
static CGFloat const MHInteractionCellCommentFontSize		= 12;
static NSString * const MHInteractionCellUpdatedFont		= @"ArialMT";
static CGFloat const MHInteractionCellUpdatedFontSize		= 12;
static NSString * const MHInteractionCellUpdatedAtFont		= @"Arial-BoldMT";
static CGFloat const MHInteractionCellUpdatedAtFontSize		= 12;
static CGFloat const MHInteractionCellMargin				= 20.0f;

@implementation MHInteractionCell

@synthesize interaction		= _interaction;
@synthesize descriptionLabel= _descriptionLabel;
@synthesize commentLabel	= _commentLabel;
@synthesize updatedLabel	= _updatedLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.font = [UIFont fontWithName:MHInteractionCellDescriptionFont size:MHInteractionCellDescriptionFontSize];
    self.descriptionLabel.textColor = [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.descriptionLabel.numberOfLines = 0;
	
    self.descriptionLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
	
    [self.contentView addSubview:self.descriptionLabel];
    
    return self;
	
}


- (void)awakeFromNib {
	
	[super awakeFromNib];

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.font = [UIFont fontWithName:MHInteractionCellDescriptionFont size:MHInteractionCellDescriptionFontSize];
    self.descriptionLabel.textColor = [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.descriptionLabel.numberOfLines = 0;
	
    self.descriptionLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
	
	//TODO: comment
	
	//TODO: updated
	
    [self.contentView addSubview:self.descriptionLabel];
	
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)populateWithInteraction:(MHInteraction *)interaction {
    
}

- (void)setInteraction:(MHInteraction *)interaction {
	
    [self willChangeValueForKey:@"interaction"];
    _interaction = [interaction copy];
    [self didChangeValueForKey:@"interaction"];
	
	__block NSString *initiator		= [self.interaction initiatorsNames];
	__block NSString *receiver		= [self.interaction receiverName];
	__block NSString *description	= [self.interaction displayString];
    
    [self.descriptionLabel setText:description afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
		
        NSRange initiatorRange	=  [description rangeOfString:initiator];
		NSRange receiverRange	= [description rangeOfString:receiver];
		
        CTFontRef boldFont		= CTFontCreateWithName((__bridge CFStringRef)MHInteractionCellNameFont, MHInteractionCellNameFontSize, NULL);
		
		UIColor *boldColor		= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
		
        if (boldFont) {
			
            [mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:initiatorRange];
            [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:initiatorRange];
			
			[mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:initiatorRange];
			[mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[boldColor CGColor] range:initiatorRange];
			
			[mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:receiverRange];
            [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:receiverRange];
			
			[mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:receiverRange];
			[mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[boldColor CGColor] range:receiverRange];
			
            CFRelease(boldFont);
			
        }
		
        return mutableAttributedString;
		
    }];
	
	self.commentLabel.text		= self.interaction.comment;
	
	//__block NSString *updater		= [self.interaction.updater fullName];
	__block NSString *updatedDate	= [self.interaction updatedAtString];
	__block NSString *updated		= [self.interaction updatedString];
	
	[self.updatedLabel setText:updated afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
		
		NSRange updatedDateRange	= [updated rangeOfString:updatedDate];
		
        CTFontRef boldFont		= CTFontCreateWithName((__bridge CFStringRef)MHInteractionCellUpdatedAtFont, MHInteractionCellUpdatedAtFontSize, NULL);
		//TODO: updated with correct color
		UIColor *boldColor		= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
		
        if (boldFont) {
			
            [mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:updatedDateRange];
            [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:updatedDateRange];
			
			[mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:updatedDateRange];
			[mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[boldColor CGColor] range:updatedDateRange];
			
            CFRelease(boldFont);
			
        }
		
        return mutableAttributedString;
		
    }];
	
}

+ (CGFloat)heightForCellWithInteraction:(MHInteraction *)interaction {
	
	NSString *description	= [interaction displayString];
	NSString *updatedString	= [interaction updatedString];
	NSString *commentString = interaction.comment;
	
    CGFloat height = MHInteractionCellMargin;
    height += ceilf([description sizeWithFont:[UIFont fontWithName:MHInteractionCellNameFont size:MHInteractionCellNameFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
	height += MHInteractionCellMargin;
	
	if (interaction.comment.length > 0) {
		height += ceilf([commentString sizeWithFont:[UIFont fontWithName:MHInteractionCellCommentFont size:MHInteractionCellCommentFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
		height += MHInteractionCellMargin;
	}
	
	height += ceilf([updatedString sizeWithFont:[UIFont fontWithName:MHInteractionCellUpdatedAtFont size:MHInteractionCellUpdatedAtFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
	height += MHInteractionCellMargin;
	
    return height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    
	[super layoutSubviews];
	
    self.textLabel.hidden			= YES;
    self.detailTextLabel.hidden		= YES;
	
    self.descriptionLabel.frame		= CGRectMake(MHInteractionCellMargin, MHInteractionCellMargin, CGRectGetWidth(self.descriptionLabel.frame), CGRectGetHeight(self.descriptionLabel.frame));
	
	if (self.interaction.comment.length > 0) {
		
		self.commentLabel.hidden	= NO;
		self.commentLabel.frame		= CGRectMake(MHInteractionCellMargin, CGRectGetMaxY(self.descriptionLabel.frame) + MHInteractionCellMargin, CGRectGetWidth(self.commentLabel.frame), CGRectGetHeight(self.commentLabel.frame));
		self.updatedLabel.frame		= CGRectMake(MHInteractionCellMargin, CGRectGetMaxY(self.commentLabel.frame) + MHInteractionCellMargin, CGRectGetWidth(self.updatedLabel.frame), CGRectGetHeight(self.updatedLabel.frame));
		
	} else {
		
		self.commentLabel.hidden	= YES;
		self.updatedLabel.frame		= CGRectMake(MHInteractionCellMargin, CGRectGetMaxY(self.descriptionLabel.frame) + MHInteractionCellMargin, CGRectGetWidth(self.updatedLabel.frame), CGRectGetHeight(self.updatedLabel.frame));
		
	}
	
}


@end
