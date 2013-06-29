//
//  MHPeopleSearchBar.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/18/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPeopleSearchBar.h"

@interface MHPeopleSearchBar(){
    UITextField *searchTextField;
}

@end

@implementation MHPeopleSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = searchTextField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = self.frame.size.height;
    frame.size.width = self.frame.size.width;
    searchTextField.frame = frame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (int i = [self.subviews count] - 1; i >= 0; i--) {
        UIView *subview = [self.subviews objectAtIndex:i];
        if ([subview.class isSubclassOfClass:[UITextField class]]){
            searchTextField = (UITextField *)subview;
        }
    } 
    /*for(id subview in [self subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:YES];
        }
    }*/
    
    //self.showsCancelButton = YES;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
