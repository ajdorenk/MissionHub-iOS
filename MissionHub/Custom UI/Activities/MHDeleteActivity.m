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
	
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[self.peopleToDelete addObject:object];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Warning"
													 andMessage:[NSString stringWithFormat:@"Are you sure you want to delete these %d people?", self.peopleToDelete.count]];
	
	[alertView addButtonWithTitle:@"Yes"
							 type:SIAlertViewButtonTypeDestructive
						  handler:^(SIAlertView *alertView) {
							  
							  [[MHAPI sharedInstance] bulkDeletePeople:self.peopleToDelete withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
								  
								  SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Success"
																				   andMessage:[NSString stringWithFormat:@"%d people were successfully deleted?", self.peopleToDelete.count]];
								  [alertView addButtonWithTitle:@"Ok"
														   type:SIAlertViewButtonTypeDestructive
														handler:^(SIAlertView *alertView) {
															
															[self activityDidFinish:YES];
															
														}];
								  
							  } failBlock:^(NSError *error, MHRequestOptions *options) {
								  
								  NSString *message				= [NSString stringWithFormat:@"Deleting these %d people failed because: %@. If the problem persists please contact support@mission.com", self.peopleToDelete.count, [error localizedDescription]];
								  NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
																				   code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
								  
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
