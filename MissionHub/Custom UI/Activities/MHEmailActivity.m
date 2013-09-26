//
//  MHEmailActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHEmailActivity.h"
#import "MHActivityViewController.h"
#import "MHPerson+Helper.h"
#import "MHEmailAddress.h"

@implementation MHEmailActivity

- (id)init
{
    self = [super initWithTitle:@"Email"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Email_48"]
                    actionBlock:nil];
    
    
    if (self) {
    
		__typeof(&*self) __weak weakSelf = self;
		self.actionBlock = ^(REActivity *activity, REActivityViewController *activityViewController) {
			
			MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
			mailComposeViewController.mailComposeDelegate = weakSelf;
			
			__block NSMutableArray *recipients	= [NSMutableArray array];
			[weakSelf.activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
				
				MHPerson *person				= nil;
				MHEmailAddress *emailAddress	= nil;
				NSString *emailString			= @"";
				
				if ([object isKindOfClass:[MHPerson class]]) {
					
					person	= (MHPerson *)object;
					
					if (person.primaryEmail) {
						
						emailString	= person.primaryEmail;
						
					}
					
				}
				
				if ([object isKindOfClass:[MHEmailAddress class]]) {
					
					emailAddress	= (MHEmailAddress *)object;
					
					if (emailAddress.email) {
						
						emailString	= emailAddress.email;
						
					}
					
				}
				
				if (emailString.length > 0) {
					
					[recipients addObject:emailString];
					
				}
				
			}];
			
			[mailComposeViewController setToRecipients:recipients];
			
			[activityViewController.presentingController presentViewController:mailComposeViewController animated:YES completion:nil];

		};
		
	}
    
    return self;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	if ([MFMailComposeViewController canSendMail]) {
		
		__block BOOL hasPeopleOrEmail = NO;
		[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHEmailAddress class]]) {
				
				hasPeopleOrEmail	= YES;
				*stop				= YES;
				
			}
			
		}];
		
		return hasPeopleOrEmail;
		
	}
	
	return NO;
	
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	
	MHActivityViewController *activityViewController = (MHActivityViewController *)self.activityViewController;
	
    [activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	if ([activityViewController.delegate respondsToSelector:@selector(activityDidFinish:)]) {
		
		[activityViewController.delegate activityDidFinish:result];
		
	}
	
}

@end
