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
#import "MHErrorHandler.h"

NSString * const MHActivityTypeEmail	= @"com.missionhub.mhactivity.type.email";

@interface MHEmailActivity ()

@property (nonatomic, strong) NSMutableArray *recipients;

@end

@implementation MHEmailActivity

@synthesize recipients	= _recipients;

- (id)init {
	
    self = [super initWithTitle:@"Email"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Email_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		self.recipients	= [NSMutableArray array];
		
	}
    
    return self;
	
}

- (NSString *)activityType {
	
	return MHActivityTypeEmail;
	
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

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	self.activityItems	= activityItems;
	
	[self.recipients removeAllObjects];
	
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
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
			
			[self.recipients addObject:emailString];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
	mailComposeViewController.mailComposeDelegate = self;
	
	[mailComposeViewController setToRecipients:self.recipients];
	
	[self.activityViewController.presentingController presentViewController:mailComposeViewController animated:YES completion:nil];
	
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	
	[self.activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	BOOL completed	= NO;
	
	switch (result) {
		case MFMailComposeResultCancelled:
			completed	= NO;
			
			break;
		case MFMailComposeResultFailed:
			completed	= NO;
			
			[MHErrorHandler presentError:error];
			
			break;
		case MFMailComposeResultSaved:
			completed	= YES;
			
			break;
		case MFMailComposeResultSent:
			completed	= YES;
			
			break;
			
		default:
			break;
	}
	
	[self activityDidFinish:completed];
	
}

@end
