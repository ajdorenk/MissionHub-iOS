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
#import "MHErrorHandler.h"
#import "MHAllObjects.h"

NSString * const MHActivityTypeText	= @"com.missionhub.mhactivity.type.text";

@interface MHTextActivity ()

@property (nonatomic, strong) NSMutableArray *recipients;

@end

@implementation MHTextActivity

@synthesize recipients	= _recipients;

- (id)init {
	
    self = [super initWithTitle:@"Text"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Text_48"]];
    
    
    if (self) {
		
		self.recipients	= [NSMutableArray array];
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeText;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	if ([MFMessageComposeViewController canSendText]) {
		
		__block BOOL hasPeopleOrPhoneNumber = NO;
		[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			
			if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHPhoneNumber class]] || [object isKindOfClass:[MHAllObjects class]]) {
				
				hasPeopleOrPhoneNumber	= YES;
				*stop					= YES;
				
			}
			
		}];
		
		return hasPeopleOrPhoneNumber;
		
	}
	
	return NO;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[self.recipients removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
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
			
			[weakSelf.recipients addObject:phoneNumberString];
			
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
	
	BOOL completed	= NO;
	
	switch (result) {
		case MessageComposeResultCancelled: {
			completed	= NO;
			
			break;
		} case MessageComposeResultFailed: {
			completed	= NO;
			
			NSError *error = [NSError errorWithDomain:MHActivityTypeText
												 code:1
											 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Text Failed to Send.", nil)}];
			
			[MHErrorHandler presentError:error];
			
			break;
		} case MessageComposeResultSent: {
			completed	= YES;
			
			break;
			
		} default:{
			break;
		}
	}
	
	[self activityDidFinish:completed];
	
}

@end
