//
//  MHDirectionsActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 11/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHDirectionsActivity.h"
#import "MHActivityViewController.h"
#import "MHPerson+Helper.h"
#import "MHAddress+Helper.h"
#import "MHErrorHandler.h"

NSString * const MHActivityTypeDirections	= @"com.missionhub.mhactivity.type.directions";

@interface MHDirectionsActivity ()

@property (nonatomic, strong)			NSString *addressString;

@end

@implementation MHDirectionsActivity

@synthesize addressString	= _addressString;

- (id)init {
	
    self = [super initWithTitle:@"Directions"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Directions_48"]];
    
    
    if (self) {
		
		
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeDirections;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	__block BOOL hasAddress	= NO;
	
	if (activityItems.count == 1) {
		
		[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			if ([object isKindOfClass:[MHPerson class]]) {
				
				MHPerson *person = (MHPerson *)object;
				if (person.addresses.count > 0) {
					
					hasAddress		= YES;
					*stop			= YES;
					
				}
				
			} else if ([object isKindOfClass:[MHAddress class]]) {
				
				hasAddress		= YES;
				*stop			= YES;
				
			}
			
		}];
		
	}
	
	return hasAddress;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			MHPerson *person		= (MHPerson *)object;
			
			if (person.addresses.allObjects[0]) {
				
				self.addressString	= ((MHAddress *)(person.addresses.allObjects[0])).displayString;
				*stop				= YES;
				
			}
			
		}
		
		if ([object isKindOfClass:[MHAddress class]]) {
			
			MHAddress *address		= (MHAddress *)object;
			
			if (address.displayString) {
				
				self.addressString	= address.displayString;
				*stop				= YES;
				
			}
			
		}
		
	}];
	
}

- (void)performActivity {
	
	if (self.addressString) {
		
		NSString *googleAddressString = [self.addressString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
		NSString *urlEncodedString	= [[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", googleAddressString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *addressURL = [NSURL URLWithString:urlEncodedString];
		
		[[UIApplication sharedApplication] openURL:addressURL];
		
		[self activityDidFinish:YES];
		
	} else {
		
		NSError *error = [NSError errorWithDomain:MHActivityTypeDirections
											 code:1
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Could not open directions. There was something wrong with the Address.", nil)}];
		
		[MHErrorHandler presentError:error];
		
		[self activityDidFinish:NO];
		
	}
	
}

@end