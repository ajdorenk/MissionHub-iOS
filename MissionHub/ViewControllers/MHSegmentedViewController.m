//
//  MHSegmentedViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/1/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSegmentedViewController.h"
#import "M6ParallaxController.h"


@interface MHSegmentedViewController ()

@end

@implementation MHSegmentedViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.parallaxController.tableViewController.view touchesBegan:touches withEvent:event];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    [self.parallaxController.tableViewController.view touchesMoved:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesCancelled:touches withEvent:event];
    
    [self.parallaxController.tableViewController.view touchesMoved:touches withEvent:event];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    
    [self.parallaxController.tableViewController.view touchesMoved:touches withEvent:event];
    
}

@end
