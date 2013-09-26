//
//  MHDeleteActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHDeleteActivity.h"
#import "MHActivityViewController.h"
#import "MHAPI.h"
#import "MHErrorHandler.h"
#import "MHPerson+Helper.h"
#import "SIAlertView.h"

NSString * const MHActivityTypeDelete	= @"com.missionhub.mhactivity.type.delete";

@interface MHDeleteActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToDelete;

@end

@implementation MHDeleteActivity

@synthesize peopleToDelete = _peopleToDelete;

- (id)init {
	
    self = [super initWithTitle:@"Delete"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Trash_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		self.peopleToDelete	= [NSMutableArray array];
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeDelete;
	
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
	
	[self.peopleToDelete removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[weakSelf.peopleToDelete addObject:object];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Warning"
													 andMessage:[NSString stringWithFormat:@"Are you sure you want to delete %d people?", self.peopleToDelete.count]];
	
	__weak __typeof(&*self)weakSelf = self;
	[alertView addButtonWithTitle:@"Yes"
							 type:SIAlertViewButtonTypeDestructive
						  handler:^(SIAlertView *alertView) {
							  
							  [[MHAPI sharedInstance] bulkDeletePeople:weakSelf.peopleToDelete withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
								  
								  SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																				   andMessage:[NSString stringWithFormat:@"%d people were successfully deleted?", weakSelf.peopleToDelete.count]];
								  [successAlertView addButtonWithTitle:@"Ok"
														   type:SIAlertViewButtonTypeDestructive
														handler:^(SIAlertView *alertView) {
															
														}];
								  
								  successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
								  successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
								  
								  [successAlertView show];
								  
								  [weakSelf activityDidFinish:YES];
								  
							  } failBlock:^(NSError *error, MHRequestOptions *options) {
								  
								  NSString *message				= [NSString stringWithFormat:@"Deleting %d people failed because: %@. If the problem persists please contact support@mission.com", weakSelf.peopleToDelete.count, [error localizedDescription]];
								  NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
																				   code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
								  
								  [MHErrorHandler presentError:presentationError];
								  
								  [weakSelf activityDidFinish:NO];
								  
							  }];
							  
						  }];
	
	[alertView addButtonWithTitle:@"No"
							 type:SIAlertViewButtonTypeCancel
						  handler:^(SIAlertView *alertView) {
							  
							  [weakSelf activityDidFinish:NO];
							  
						  }];
	
	alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
	alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
	
	[alertView show];
	
}

@end
