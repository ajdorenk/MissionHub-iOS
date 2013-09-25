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

@implementation MHTextActivity

- (id)init
{
    self = [super initWithTitle:@"Text"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Text_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		__typeof(&*self) __weak weakSelf = self;
		self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
			
			MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
			messageComposeViewController.messageComposeDelegate = weakSelf;
			
			__block NSMutableArray *recipients	= [NSMutableArray array];
			[weakSelf.activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
				
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
					
					[recipients addObject:phoneNumberString];
					
				}
				
			}];
			
			messageComposeViewController.recipients	= recipients;
			
			[activityViewController.presentingController presentViewController:messageComposeViewController animated:YES completion:nil];
			
		};
		
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

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	
	MHActivityViewController *activityViewController = (MHActivityViewController *)self.activityViewController;
	
    [activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	if ([activityViewController.delegate respondsToSelector:@selector(activityDidFinish:)]) {
		
		[activityViewController.delegate activityDidFinish:result];
		
	}
	
}

@end
