//
//  MHTextActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHTextActivity.h"
#import "MHActivityViewController.h"
#import "MHPerson+Helper.h"
#import "MHPhoneNumber.h"

@interface MHTextActivity ()

@property (nonatomic, strong) NSMutableArray *recipients;

@end

@implementation MHTextActivity

@synthesize recipients	= _recipients;

- (id)init
{
    self = [super initWithTitle:@"Text"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Text_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		self.recipients	= [NSMutableArray array];
		
	}
    
    return self;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	if ([MFMessageComposeViewController canSendText]) {
		
		__block BOOL hasPeopleOrPhoneNumber = NO;
		[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHPhoneNumber class]]) {
				
				hasPeopleOrPhoneNumber	= YES;
				*stop					= YES;
				
			}
			
		}];
		
		return hasPeopleOrPhoneNumber;
		
	}
	
	return NO;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	self.activityItems	= activityItems;
	
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		MHPerson *person			= nil;
		MHPhoneNumber *phoneNumber	= nil;
		NSString *phoneNumberString	= @"";
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			person	= (MHPerson *)object;
			
			if (person.primaryPhone) {
				
				phoneNumberString	= person.primaryPhone;
				
			}
			
		}
		
		if ([object isKindOfClass:[MHPhoneNumber class]]) {
			
			phoneNumber	= (MHPhoneNumber *)object;
			
			if (phoneNumber.number) {
				
				phoneNumberString	= phoneNumber.number;
				
			}
			
		}
		
		if (phoneNumberString.length > 0) {
			
			[self.recipients addObject:phoneNumberString];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
	messageComposeViewController.messageComposeDelegate = self;
	
	messageComposeViewController.recipients	= self.recipients;
	
	[self.activityViewController.presentingController presentViewController:messageComposeViewController animated:YES completion:nil];
	
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
    [self.activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	[self activityDidFinish:result];
	
}

@end
