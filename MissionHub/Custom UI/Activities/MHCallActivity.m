//
//  MHCallActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 11/22/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHCallActivity.h"
#import "MHActivityViewController.h"
#import "MHPerson+Helper.h"
#import "MHPhoneNumber.h"
#import "MHErrorHandler.h"

NSString * const MHActivityTypeCall	= @"com.missionhub.mhactivity.type.call";

@interface MHCallActivity ()

@property (nonatomic, strong)			NSString *phoneNumberString;
@property (nonatomic, strong, readonly) UIWebView *phoneCallWebview;

@end

@implementation MHCallActivity

@synthesize phoneCallWebview	= _phoneCallWebview;
@synthesize phoneNumberString	= _phoneNumberString;

- (id)init {
	
    self = [super initWithTitle:@"Call"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Call_48"]];
    
    
    if (self) {
		
		
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeCall;
	
}

- (UIWebView *)phoneCallWebview {
	
	if (!_phoneCallWebview) {
		
		[self willChangeValueForKey:@"phoneCallWebview"];
		_phoneCallWebview			= [[UIWebView alloc] initWithFrame:CGRectZero];
		[self didChangeValueForKey:@"phoneCallWebview"];
		
		_phoneCallWebview.hidden	= YES;
		
	}
	
	return _phoneCallWebview;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	__block BOOL hasNumberToCall	= NO;
	
	if (activityItems.count == 1 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]]) {
		
		[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			if ([object isKindOfClass:[MHPerson class]]) {
				
				MHPerson *person = (MHPerson *)object;
				if (person.primaryPhone.length > 0) {
					
					hasNumberToCall		= YES;
					*stop				= YES;
					
				}
				
			} else if ([object isKindOfClass:[MHPhoneNumber class]]) {
				
				hasNumberToCall		= YES;
				*stop				= YES;
				
			}
			
		}];
		
	}
	
	return hasNumberToCall;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			MHPerson *person			= (MHPerson *)object;
			
			if (person.primaryPhone) {
				
				self.phoneNumberString	= person.primaryPhone;
				*stop					= YES;
				
			}
			
		}
		
		if ([object isKindOfClass:[MHPhoneNumber class]]) {
			
			MHPhoneNumber *phoneNumber	= (MHPhoneNumber *)object;
			
			if (phoneNumber.number) {
				
				self.phoneNumberString	= phoneNumber.number;
				*stop					= YES;
				
			}
			
		}
		
	}];
	
}

- (void)performActivity {
	
	if (self.phoneNumberString) {
	
		NSString *cleanedString = [[self.phoneNumberString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
		NSString *phoneUrlString	= [NSString stringWithFormat:@"tel:%@", cleanedString];
		NSURL *url					= [NSURL URLWithString:phoneUrlString];
		NSURLRequest *request		= [NSURLRequest requestWithURL:url];
		
		[self.phoneCallWebview loadRequest:request];
		
		[self activityDidFinish:YES];
		
	} else {
		
		NSError *error = [NSError errorWithDomain:MHActivityTypeCall
											 code:1
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Could not make Call. There was something wrong with the Phone Number.", nil)}];
		
		[MHErrorHandler presentError:error];
		
		[self activityDidFinish:NO];
		
	}
	
}

@end
