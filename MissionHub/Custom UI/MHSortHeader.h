//
//  MHSortHeader.h
//  MissionHub
//
//  Created by Michael Harrison on 9/11/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPerson+Helper.h"
#import "MHRequestOptions.h"

extern CGFloat const MHSortHeaderHeight;

@protocol MHSortHeaderDelegate;

@interface MHSortHeader : UIView

+ (instancetype)headerWithTableView:(UITableView *)tableView sortField:(MHPersonSortFields)sortField delegate:(id<MHSortHeaderDelegate>)delegate;
- (void)updateInterfaceWithSortField:(MHPersonSortFields)sortField;

@end

@protocol MHSortHeaderDelegate <NSObject>

@optional
//- (void)allButtonPressed;
- (void)sortDirectionDidChangeTo:(MHRequestOptionsOrderDirections)direction;
- (void)fieldButtonPressed;

@end
