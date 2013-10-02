//
//  MHBlankCheckbox.h
//  MissionHub
//
//  Created by Michael Harrison on 8/3/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCheckbox.h"

typedef enum {
	MHBlankCheckboxStateAll,
	MHBlankCheckboxStateSome,
	MHBlankCheckboxStateNone
} MHBlankCheckboxState;

@protocol MHBlankCheckboxDelegate;

@interface MHBlankCheckbox : UIButton

@property (nonatomic, weak) id<MHBlankCheckboxDelegate> checkboxDelegate;
@property (nonatomic, assign) MHBlankCheckboxState state;

@end

@protocol MHBlankCheckboxDelegate <NSObject>
@optional
-(void)checkboxDidGetTapped:(MHBlankCheckbox *)checkbox;

@end
