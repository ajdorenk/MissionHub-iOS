//
//  MHArchiveActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHArchiveActivity.h"
#import "MHActivityViewController.h"
#import "MHAPI.h"
#import "MHErrorHandler.h"
#import "MHPerson+Helper.h"
#import "SIAlertView.h"

NSString * const MHActivityTypeArchive	= @"com.missionhub.mhactivity.type.archive";

@interface MHArchiveActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToArchive;

@end

@implementation MHArchiveActivity

@synthesize peopleToArchive = _peopleToArchive;

- (id)init {
	
    self = [super initWithTitle:@"Archive"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Archive_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		self.peopleToArchive	= [NSMutableArray array];
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeArchive;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	__block BOOL hasPeople = NO;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			hasPeople	= YES;
			*stop		= YES;
			
		}
		
	}];
	
	return hasPeople;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	self.activityItems	= activityItems;
	
	[self.peopleToArchive removeAllObjects];
	
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[self.peopleToArchive addObject:object];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Warning"
													 andMessage:[NSString stringWithFormat:@"Are you sure you want to archive %d people?", self.peopleToArchive.count]];
	
	[alertView addButtonWithTitle:@"Yes"
							 type:SIAlertViewButtonTypeDestructive
						  handler:^(SIAlertView *alertView) {
							  
							  [[MHAPI sharedInstance] bulkArchivePeople:self.peopleToArchive withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
								  
								  SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																				   andMessage:[NSString stringWithFormat:@"%d people were successfully archived?", self.peopleToArchive.count]];
								  [successAlertView addButtonWithTitle:@"Ok"
														   type:SIAlertViewButtonTypeDestructive
														handler:^(SIAlertView *alertView) {
															
															[self activityDidFinish:YES];
															
														}];
								  
								  successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
								  successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
								  
								  [successAlertView show];
								  
							  } failBlock:^(NSError *error, MHRequestOptions *options) {
								  
								  NSString *message				= [NSString stringWithFormat:@"Archiving %d people failed because: %@. If the problem persists please contact support@mission.com", self.peopleToArchive.count, [error localizedDescription]];
								  NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
																				   code: [error code]
																			   userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
								  
								  [MHErrorHandler presentError:presentationError];
								  
								  [self activityDidFinish:NO];
								  
							  }];
							  
						  }];
	
	[alertView addButtonWithTitle:@"No"
							 type:SIAlertViewButtonTypeCancel
						  handler:^(SIAlertView *alertView) {
							  
							  [self activityDidFinish:NO];
							  
						  }];
	
	alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
	alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
	
	[alertView show];
	
}

@end
