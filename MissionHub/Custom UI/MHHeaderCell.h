//
//  MHHeaderCell.h
//  MissionHub
//
//  Created by Michael Harrison on 8/29/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const MHHeaderCellHeight;
extern NSString * const MHHeaderCellBackgroundImageName;

@interface MHHeaderCell : UITableViewCell

- (void)configureCellWithTitle:(NSString *)title andDate:(NSString *)date forTableview:(UITableView *)tableview;

@end
