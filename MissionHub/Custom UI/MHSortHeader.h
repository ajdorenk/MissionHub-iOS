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

typedef enum {
	MHSortHeaderCheckboxStateAll,
	MHSortHeaderCheckboxStatePartial,
	MHSortHeaderCheckboxStateNone
} MHSortHeaderCheckboxState;

extern CGFloat const MHSortHeaderHeight;

@protocol MHSortHeaderDelegate;

@interface MHSortHeader : UIView

@property (nonatomic, assign) MHSortHeaderCheckboxState checkboxState;

+ (instancetype)headerWithTableView:(UITableView *)tableView sortField:(MHPersonSortFields)sortField delegate:(id<MHSortHeaderDelegate>)delegate;
- (void)updateInterfaceWithSortField:(MHPersonSortFields)sortField;

@end

@protocol MHSortHeaderDelegate <NSObject>

@optional
- (void)allButtonPressedWithNewState:(MHSortHeaderCheckboxState)state;
- (void)sortDirectionDidChangeTo:(MHRequestOptionsOrderDirections)direction;
- (void)fieldButtonPressed;

@end
