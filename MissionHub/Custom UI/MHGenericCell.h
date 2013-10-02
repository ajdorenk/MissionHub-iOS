//
//  MHGenericCell.h
//  MissionHub
//
//  Created by Michael Harrison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHBlankCheckbox.h"

@protocol MHGenericCellDelegate;

typedef enum {
	
	MHGenericCellStateAll,
	MHGenericCellStateSome,
	MHGenericCellStateNone
	
} MHGenericCellState;

@interface MHGenericCell : UITableViewCell <MHBlankCheckboxDelegate>

@property (nonatomic, weak) id<MHGenericCellDelegate>	cellDelegate;
@property (nonatomic, strong) NSIndexPath				*indexPath;
@property (nonatomic, strong) id						object;
@property (nonatomic, assign) MHGenericCellState		state;
@property (nonatomic, weak) IBOutlet UILabel			*label;
@property (nonatomic, weak) IBOutlet MHBlankCheckbox	*checkmark;

- (void)populateWithTitle:(NSString *)text forObject:(id)object andState:(MHGenericCellState)state atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MHGenericCellDelegate <NSObject>
@optional
- (void)cell:(MHGenericCell *)cell didChangeStateForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end
