//
//  MHCustomNavigationBar.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHCustomNavigationBar.h"

@implementation MHCustomNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}







/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    UIImage *backgroundImage = [UIImage imageNamed:@"topbar_background.png"];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
