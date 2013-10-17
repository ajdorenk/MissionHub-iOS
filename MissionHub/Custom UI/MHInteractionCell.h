//
//  MHInteractionCell.h
//  MissionHub
//
//  Created by Amarisa Robison on 7/2/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHInteraction+Helper.h"

@interface MHInteractionCell : UITableViewCell

@property (nonatomic, strong) MHInteraction *interaction;

- (void)populateWithInteraction:(MHInteraction *)interaction;

+ (CGFloat)heightForCellWithInteraction:(MHInteraction *)interaction andWidth:(CGFloat)width;

@end
