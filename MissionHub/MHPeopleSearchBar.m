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


- (void)setFrame:(CGRect)frame {
    frame.size.height = 40;
    [super setFrame:frame];
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = searchTextField.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.height = 40;
    frame.size.width = 200;
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
}

- (void)stylizeSearchTextField {
    // Sets the background to a static black by removing the gradient view
    for (int i = [self.subviews count] - 1; i >= 0; i--) {
        UIView *subview = [self.subviews objectAtIndex:i];
        
        // This is the gradient behind the textfield
        if ([subview.description hasPrefix:@"<UISearchBarBackground"]) {
            [subview removeFromSuperview];
        }
    }
    
    // now change the search textfield itself
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.background = nil;
    searchTextField.text = @"";
    searchTextField.clearButtonMode = UITextFieldViewModeNever;
    searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    searchTextField.placeholder = @"";
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
