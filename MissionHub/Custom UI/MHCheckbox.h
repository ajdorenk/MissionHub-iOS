//
//  MHCheckbox.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/17/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHCheckboxDelegate;

@interface MHCheckbox : UIButton

@property (nonatomic, weak) id<MHCheckboxDelegate> checkboxDelegate;

-(void)checkBoxClicked;

@end

@protocol MHCheckboxDelegate <NSObject>
@optional
-(void)checkbox:(MHCheckbox *)checkbox didChangeValue:(BOOL)checked;

@end