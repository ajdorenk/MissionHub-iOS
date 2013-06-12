//
//  MHSublabel.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSublabel.h"

@implementation MHSublabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
    // Drawing code
    GCRect viewRect = CGRectMake(95, 0, 225, 31);
    UIView* myView = [[UIView alloc] initWithFrame:viewRect];
}*/


- (void)drawRect:(CGRect)rect {
    /* Set UIView Border */
    // Get the contextRef
    CGRect boundaryRect = self.bounds;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(contextRef);
    
    // Set the border width
    CGContextSetLineWidth(contextRef, 2.0);
    
    // Set the border color
    CGContextSetRGBStrokeColor(contextRef, 192.0, 0.0, 0.0, 1.0);
    
    //Move to top left corner
    CGContextMoveToPoint(contextRef, CGRectGetMinX(boundaryRect), CGRectGetMinY(boundaryRect));

    /*//Add top line from left to right
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(boundaryRect), CGRectGetMinY(boundaryRect));
 
    //Add right line from top to bottom
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(boundaryRect), CGRectGetMaxY(boundaryRect));
     */
     
    //Add left line from right to left
    CGContextAddLineToPoint(contextRef, CGRectGetMinX(boundaryRect), CGRectGetMaxY(boundaryRect));
    
    
    //Add bottom line from bottom to top
    CGContextMoveToPoint(contextRef, CGRectGetMinX(boundaryRect), CGRectGetMaxY(boundaryRect));
    CGContextAddLineToPoint(contextRef, CGRectGetMaxX(boundaryRect), CGRectGetMaxY(boundaryRect));
    
    
    CGContextClosePath(contextRef);
    CGContextFillPath(contextRef);
    
    
    
}


@end
