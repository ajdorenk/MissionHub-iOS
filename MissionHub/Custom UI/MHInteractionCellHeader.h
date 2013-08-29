//
//  MHInteractionCellHeader.h
//  MissionHub
//
//  Created by Michael Harrison on 8/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHInteraction+Helper.h"

extern CGFloat const MHInteractionCellHeaderHeight;
extern NSString * const MHInteractionCellBackgroundImageName;

@interface MHInteractionCellHeader : UIView

- (instancetype)initWithInteraction:(MHInteraction *)interaction forTableView:(UITableView *)tableview;

@end
