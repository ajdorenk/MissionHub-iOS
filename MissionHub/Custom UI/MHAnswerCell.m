//
//  MHAnswerCell.m
//  MissionHub
//
//  Created by Michael Harrison on 8/30/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAnswerCell.h"
#import "MHAPI.h"
#import "MHQuestion.h"
#import "NSSet+MHSearchForRemoteID.h"

static NSString * const MHAnswerCellQuestionFont		= @"Arial-BoldMT";
static CGFloat const MHAnswerCellQuestionFontSize		= 14;
static NSString * const MHAnswerCellAnswerFont			= @"ArialMT";
static CGFloat const MHAnswerCellAnswerFontSize			= 14;
static CGFloat const MHAnswerCellMargin					= 20.0f;

@interface MHAnswerCell ()

- (void)configure;

@end

@implementation MHAnswerCell

@synthesize answer			= _answer;
@synthesize answerLabel		= _answerLabel;
@synthesize questionLabel	= _questionLabel;

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
    
    self.questionLabel				= [[UILabel alloc] initWithFrame:CGRectZero];
    self.questionLabel.font			= [UIFont fontWithName:MHAnswerCellQuestionFont size:MHAnswerCellQuestionFontSize];
    self.questionLabel.textColor	= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
    self.questionLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    self.questionLabel.numberOfLines = 0;
	
	self.answerLabel				= [[UILabel alloc] initWithFrame:CGRectZero];
    self.answerLabel.font			= [UIFont fontWithName:MHAnswerCellAnswerFont size:MHAnswerCellAnswerFontSize];
    self.answerLabel.textColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
    self.answerLabel.lineBreakMode = LINE_BREAK_WORD_WRAP;
    self.answerLabel.numberOfLines = 0;
	
	[self.contentView addSubview:self.questionLabel];
	[self.contentView addSubview:self.answerLabel];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setAnswer:(MHAnswer *)answer {
	
    [self willChangeValueForKey:@"answer"];
    _answer = answer;
    [self didChangeValueForKey:@"answer"];
	
	NSString *questionString	= @"Unknown Question";
	MHSurvey *survey			= (MHSurvey *)[[MHAPI sharedInstance].currentOrganization.surveys findWithRemoteID:answer.answerSheet.survey_id];
	MHQuestion *question		= nil;
	
	if (survey) {
		
		question				= (MHQuestion *)[survey.questions findWithRemoteID:self.answer.question_id];
		
		if (question) {
			
			questionString		= question.label;
			
		}
		
	}
    
	self.questionLabel.text		= questionString;
	self.answerLabel.text		= (self.answer.value ? self.answer.value : @"");
	
}

+ (CGFloat)heightForCellWithAnswer:(MHAnswer *)answer {
	
	NSString *questionString	= @"Unknown Question";
	MHSurvey *survey			= (MHSurvey *)[[MHAPI sharedInstance].currentOrganization.surveys findWithRemoteID:answer.answerSheet.survey_id];
	MHQuestion *question		= nil;
	
	if (survey) {
		
		question				= (MHQuestion *)[survey.questions findWithRemoteID:answer.question_id];
		
		if (question) {
			
			questionString		= question.label;
			
		}
		
	}
	
    CGFloat height = 0.5 * MHAnswerCellMargin;
	
	if (questionString.length > 0) {
		
		height += ceilf([questionString sizeWithFont:[UIFont fontWithName:MHAnswerCellQuestionFont size:MHAnswerCellQuestionFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAnswerCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height);
		height += 0.5 * MHAnswerCellMargin;
		
	}
	
	if (answer.value.length > 0) {
		
		height += ceilf([answer.value sizeWithFont:[UIFont fontWithName:MHAnswerCellAnswerFont size:MHAnswerCellAnswerFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAnswerCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP].height);
		height += 0.5 * MHAnswerCellMargin;
		
	}
	
	if (height == 0.5 * MHAnswerCellMargin) {
		
		height = 0;
		
	}
	
    return height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    
	[super layoutSubviews];
	
    self.textLabel.hidden			= YES;
    self.detailTextLabel.hidden		= YES;
	
	NSString *questionString	= @"Unknown Question";
	MHSurvey *survey			= (MHSurvey *)[[MHAPI sharedInstance].currentOrganization.surveys findWithRemoteID:self.answer.answerSheet.survey_id];
	MHQuestion *question		= nil;
	
	if (survey) {
		
		question				= (MHQuestion *)[survey.questions findWithRemoteID:self.answer.question_id];
		
		if (question) {
			
			questionString		= question.label;
			
		}
		
	}
	
	if (questionString.length > 0) {
		
		CGSize questionSize = [questionString sizeWithFont:[UIFont fontWithName:MHAnswerCellQuestionFont size:MHAnswerCellQuestionFontSize] constrainedToSize:CGSizeMake(320.0f - (1.5 * MHAnswerCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		self.questionLabel.frame	= CGRectMake(MHAnswerCellMargin, 0.5 * MHAnswerCellMargin, questionSize.width, questionSize.height);
		self.questionLabel.hidden	= NO;
		
	} else {
		
		self.questionLabel.hidden	= YES;
		self.questionLabel.frame	= CGRectZero;
		
	}
	
	if (self.answer.value.length > 0) {
		
		CGSize answerSize			= [self.answer.value sizeWithFont:[UIFont fontWithName:MHAnswerCellAnswerFont size:MHAnswerCellAnswerFontSize] constrainedToSize:CGSizeMake(320.0f - (2 * MHAnswerCellMargin), CGFLOAT_MAX) lineBreakMode:LINE_BREAK_WORD_WRAP];
		
		self.answerLabel.frame		= CGRectMake(1.5 * MHAnswerCellMargin, CGRectGetMaxY(self.questionLabel.frame) + 0.25 * MHAnswerCellMargin, answerSize.width, answerSize.height);
		self.answerLabel.hidden	= NO;
		
	} else {
		
		self.answerLabel.hidden	= YES;
		self.answerLabel.frame		= CGRectMake(CGRectGetMinX(self.questionLabel.frame), CGRectGetMaxY(self.questionLabel.frame), 0, 0);
		
	}
	
}


@end

