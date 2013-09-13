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
        [self applyDefaultStyle];

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
    UIImage *backgroundImage = [UIImage imageNamed:@"MH_Mobile_Topbar_Background.png"];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self applyDefaultStyle];
}


- (void)applyDefaultStyle {
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 3);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
}

@end
