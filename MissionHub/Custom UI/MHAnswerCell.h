//
//  MHAnswerCell.h
//  MissionHub
//
//  Created by Michael Harrison on 8/30/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAnswer.h"

@interface MHAnswerCell : UITableViewCell

@property (nonatomic, strong) MHAnswer *answer;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UILabel *answerLabel;

+ (CGFloat)heightForCellWithAnswer:(MHAnswer *)answer;

@end
