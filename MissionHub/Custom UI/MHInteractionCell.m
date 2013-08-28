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
static CGFloat const MHInteractionCellCommentFontSize		= 14;
static NSString * const MHInteractionCellUpdatedFont		= @"ArialMT";
static CGFloat const MHInteractionCellUpdatedFontSize		= 12;
static NSString * const MHInteractionCellUpdatedAtFont		= @"Arial-BoldMT";
static CGFloat const MHInteractionCellUpdatedAtFontSize		= 12;
static CGFloat const MHInteractionCellMargin				= 20.0f;

@interface MHInteractionCell ()

- (void)configure;

@end

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
    
    self.descriptionLabel				= [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.font			= [UIFont fontWithName:MHInteractionCellDescriptionFont size:MHInteractionCellDescriptionFontSize];
    self.descriptionLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.descriptionLabel.numberOfLines = 0;
	
    self.descriptionLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
	
	self.commentLabel				= [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.commentLabel.font			= [UIFont fontWithName:MHInteractionCellCommentFont size:MHInteractionCellCommentFontSize];
    self.commentLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.commentLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.commentLabel.numberOfLines = 0;
	
    self.commentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
	
	self.updatedLabel				= [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.updatedLabel.font			= [UIFont fontWithName:MHInteractionCellUpdatedFont size:MHInteractionCellUpdatedFontSize];
    self.updatedLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.updatedLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.updatedLabel.textAlignment	= UITextAlignmentRight;
    self.updatedLabel.numberOfLines = 0;
	
    self.updatedLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
	
    [self.contentView addSubview:self.descriptionLabel];
	[self.contentView addSubview:self.commentLabel];
	[self.contentView addSubview:self.updatedLabel];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)populateWithInteraction:(MHInteraction *)interaction {
    
	self.interaction = interaction;
	
}

- (void)setInteraction:(MHInteraction *)interaction {
	
    [self willChangeValueForKey:@"interaction"];
    _interaction = interaction;
    [self didChangeValueForKey:@"interaction"];
	
	__block NSString *initiator		= [self.interaction initiatorsNames];
	__block NSString *receiver		= [self.interaction receiverName];
	__block NSString *description	= [self.interaction displayString];
	
//	initiator		= @"Olivia Olson";
//	receiver		= @"Kristen King";
//	description		= @"Olivia Olson prayed to receive Christ with Kristen King.";
    
	if (description.length > 0) {
	
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
		
	} else {
		
		self.descriptionLabel.text = @"";
		
	}
	
	self.commentLabel.text			= self.interaction.comment;
//	self.commentLabel.text			= @"This is a comment";
	
	//__block NSString *updater		= [self.interaction.updater fullName];
	__block NSString *updatedDate	= [self.interaction updatedAtString];
	__block NSString *updated		= [self.interaction updatedString];
	
//	updatedDate	= @"06 Sep 2011";
//	updated		= @"Last updated by Kristen King on 06 Sep 2011";
	
	if (updated.length > 0) {
		
		[self.updatedLabel setText:updated afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
			
			NSRange updatedDateRange	= [updated rangeOfString:updatedDate];
			
			CTFontRef boldFont		= CTFontCreateWithName((__bridge CFStringRef)MHInteractionCellUpdatedAtFont, MHInteractionCellUpdatedAtFontSize, NULL);
			
			if (boldFont) {
				
				[mutableAttributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:updatedDateRange];
				[mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:updatedDateRange];
				
				CFRelease(boldFont);
				
			}
			
			return mutableAttributedString;
			
		}];
		
	} else {
		
		self.updatedLabel.text = @"";
		
	}
	
}

+ (CGFloat)heightForCellWithInteraction:(MHInteraction *)interaction {
	
	NSString *description	= [interaction displayString];
	NSString *updatedString	= [interaction updatedString];
	NSString *commentString = interaction.comment;
	
//	description	= @"Olivia Olson prayed to receive Christ with Kristen King.";
//	updatedString	= @"Last updated by Kristen King on 06 Sep 2011";
//	commentString = @"This is a comment";
	
    CGFloat height = MHInteractionCellMargin;
	
	if (description.length > 0) {
		
		height += ceilf([description sizeWithFont:[UIFont fontWithName:MHInteractionCellNameFont size:MHInteractionCellNameFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
		height += 0.5 * MHInteractionCellMargin;
		
	}
	
	if (commentString.length > 0) {
		
		height += ceilf([commentString sizeWithFont:[UIFont fontWithName:MHInteractionCellCommentFont size:MHInteractionCellCommentFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
		height += 0.5 * MHInteractionCellMargin;
		
	}
	
	if (updatedString.length > 0) {
		
		height += ceilf([updatedString sizeWithFont:[UIFont fontWithName:MHInteractionCellUpdatedAtFont size:MHInteractionCellUpdatedAtFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
		height += MHInteractionCellMargin;
		
	}
	
	if (height == MHInteractionCellMargin) {
		
		height = 0;
		
	}
	
    return height;
	
    return height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    
	[super layoutSubviews];
	
    self.textLabel.hidden			= YES;
    self.detailTextLabel.hidden		= YES;
	
	NSString *description	= [self.interaction displayString];
	NSString *updatedString	= [self.interaction updatedString];
	NSString *commentString = self.interaction.comment;
	
//	description	= @"Olivia Olson prayed to receive Christ with Kristen King.";
//	updatedString	= @"Last updated by Kristen King on 06 Sep 2011";
//	commentString = @"This is a comment";
	
	CGSize descriptionSize = [description sizeWithFont:[UIFont fontWithName:MHInteractionCellNameFont size:MHInteractionCellNameFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	CGSize commentSize = [commentString sizeWithFont:[UIFont fontWithName:MHInteractionCellCommentFont size:MHInteractionCellCommentFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	CGSize updatedSize = [updatedString sizeWithFont:[UIFont fontWithName:MHInteractionCellUpdatedAtFont size:MHInteractionCellUpdatedAtFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHInteractionCellMargin), CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
	
	
	self.descriptionLabel.frame		= CGRectMake(MHInteractionCellMargin, MHInteractionCellMargin, descriptionSize.width, descriptionSize.height);
	
	if (((NSString *)self.commentLabel.text).length > 0) {
		
		self.commentLabel.hidden	= NO;
		self.commentLabel.frame		= CGRectMake(MHInteractionCellMargin, CGRectGetMaxY(self.descriptionLabel.frame) + 0.5 *MHInteractionCellMargin, commentSize.width, commentSize.height);
		self.updatedLabel.frame		= CGRectMake(320.0 - updatedSize.width - MHInteractionCellMargin, CGRectGetMaxY(self.commentLabel.frame) + 0.5 * MHInteractionCellMargin, updatedSize.width, updatedSize.height);
		
	} else {
		
		self.commentLabel.hidden	= YES;
		self.updatedLabel.frame		= CGRectMake(MHInteractionCellMargin, CGRectGetMaxY(self.descriptionLabel.frame) + 0.5 * MHInteractionCellMargin, updatedSize.width, updatedSize.height);
		
	}
	
}


@end

#pragma clang diagnostic pop

