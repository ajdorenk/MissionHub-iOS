//
//  MHInteractionCell.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/2/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "MHInteraction+Helper.h"

@interface MHInteractionCell : UITableViewCell

@property (nonatomic, strong) MHInteraction *interaction;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) TTTAttributedLabel *updatedLabel;

- (void)populateWithInteraction:(MHInteraction *)interaction;

+ (CGFloat)heightForCellWithInteraction:(MHInteraction *)interaction;

@end
