//
//  MHErrorHandler.m
//  MissionHub
//
//  Created by Michael Harrison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHErrorHandler.h"
#import "SIAlertView.h"

@implementation MHErrorHandler

+(void)presentError:(NSError *)error {
	
	NSLog(@"Error (%d) in Domain (%@): %@", [error code], [error domain], [error localizedDescription]);
	
	SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Warning" andMessage:[error localizedDescription]];
    [alertView addButtonWithTitle:@"Ok"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                              NSLog(@"Error Dismissed");
                          }];
	
	alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
	
	[alertView show];
	
}

@end
