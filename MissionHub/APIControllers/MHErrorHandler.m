//
//  MHErrorHandler.m
//  MissionHub
//
//  Created by Michael Harrison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHErrorHandler.h"

@implementation MHErrorHandler

+(void)presentError:(NSError *)error {
	
	NSLog(@"Error (%d) in Domain (%@): %@", [error code], [error domain], [error localizedDescription]);
	
}

@end
