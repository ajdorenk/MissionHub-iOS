//
//  MHCheckbox.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/17/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCheckbox : UIButton {
    BOOL isChecked;
}

@property (nonatomic,assign) BOOL isChecked;
-(IBAction) checkBoxClicked;

@end
