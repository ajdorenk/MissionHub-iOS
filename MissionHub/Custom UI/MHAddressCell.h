//
//  MHAddressCell.h
//  MissionHub
//
//  Created by Michael Harrison on 8/30/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAddress+Helper.h"

@interface MHAddressCell : UITableViewCell

@property (nonatomic, strong) MHAddress *address;
@property (nonatomic, strong) UILabel *lineOneLabel;
@property (nonatomic, strong) UILabel *lineTwoLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *countryLabel;

+ (CGFloat)heightForCellWithAddress:(MHAddress *)address;

@end
