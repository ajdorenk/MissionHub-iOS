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
#import "MHAllObjects.h"

NSString * const MHActivityTypeEmail	= @"com.missionhub.mhactivity.type.email";

@interface MHEmailActivity ()

@property (nonatomic, strong) NSMutableArray *recipients;

@end

@implementation MHEmailActivity

@synthesize recipients	= _recipients;

- (id)init {
	
    self = [super initWithTitle:@"Email"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Email_48"]];
    
    
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
			
			if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHEmailAddress class]] || [object isKindOfClass:[MHAllObjects class]]) {
				
				hasPeopleOrEmail	= YES;
				*stop				= YES;
				
			}
			
		}];
		
		return hasPeopleOrEmail;
		
	}
	
	return NO;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[self.recipients removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
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
			
			[weakSelf.recipients addObject:emailString];
			
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
