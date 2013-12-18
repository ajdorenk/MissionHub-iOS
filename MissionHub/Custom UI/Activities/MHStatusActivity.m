//
//  MHStatusActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 11/23/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHStatusActivity.h"
#import "MHActivityViewController.h"
#import "MHAPI.h"
#import "MHOrganizationalPermission+Helper.h"
#import "MHPermissionLevel+Helper.h"
#import "SIAlertView.h"
#import "MHAllObjects.h"
#import "DejalActivityView.h"

NSString * const MHActivityTypeStatus	= @"com.missionhub.mhactivity.type.status";

@interface MHStatusActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToChangeStatus;
@property (nonatomic, strong, readonly) MHGenericListViewController *statusViewController;

- (void)displayViewController;

@end

@implementation MHStatusActivity

@synthesize peopleToChangeStatus	= _peopleToChangeStatus;
@synthesize statusViewController	= _statusViewController;

- (id)init {
	
    self = [super initWithTitle:@"Status"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Status_48"]];
    
    
    if (self) {
		
		self.peopleToChangeStatus	= [NSMutableArray array];
		
	}
    
    return self;
}

- (MHGenericListViewController *)statusViewController {
	
	if (!_statusViewController) {
		
		[self willChangeValueForKey:@"statusViewController"];
		_statusViewController	= [self.activityViewController.presentingController.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"statusViewController"];
		
		_statusViewController.selectionDelegate	= self;
		_statusViewController.multipleSelection	= NO;
		_statusViewController.showHeaders		= NO;
		_statusViewController.showSuggestions	= NO;
		_statusViewController.listTitle			= @"Status";
		[_statusViewController setDataArray:[MHOrganizationalPermission arrayOfFollowupStatusesForDisplay]];
		
	}
	
	return _statusViewController;
	
}

- (NSString *)activityType {
	
	return MHActivityTypeStatus;
	
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	
	__block BOOL hasPeople = NO;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHAllObjects class]]) {
			
			hasPeople	= YES;
			*stop		= YES;
			
		}
		
	}];
	
	return hasPeople;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[self.peopleToChangeStatus removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[weakSelf.peopleToChangeStatus addObject:object];
			
		} else if ([object isKindOfClass:[MHAllObjects class]]) {
			
			[weakSelf.peopleToChangeStatus removeAllObjects];
			[weakSelf.peopleToChangeStatus addObject:object];
			*stop	= YES;
			
		}
		
	}];
	
}

- (void)performActivity {
	
	__weak typeof(self)weakSelf = self;
	[self returnPeopleFromArray:self.peopleToChangeStatus withCompletionBlock:^(NSArray *peopleList) {
		
		weakSelf.peopleToChangeStatus = [peopleList mutableCopy];
		[weakSelf displayViewController];
		
	}];
	
}

- (void)displayViewController {
	
	if (self.peopleToChangeStatus.count == 1) {
		
		MHPerson *person			= self.peopleToChangeStatus[0];
		NSString *status			= person.permissionLevel.status;
		
		[self.statusViewController setSuggestions:nil andSelectionObject:status];
		
	} else {
		
		__block NSString *status	= nil;
		
		[self.peopleToChangeStatus enumerateObjectsUsingBlock:^(MHPerson *person, NSUInteger index, BOOL *stop) {
			
			if (status) {
				
				if (![person.permissionLevel.status isEqualToString:status]) {
					
					status	= nil;
					*stop	= YES;
					
				}
				
			} else {
				
				status		= person.permissionLevel.status;
				
			}
			
		}];
		
		if (status) {
			
			[self.statusViewController setSuggestions:nil andSelectionObject:status];
			
		}
		
	}
	
	[self.activityViewController.presentingController presentViewController:self.statusViewController animated:YES completion:nil];
	
}

- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self.activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	if ([object isKindOfClass:[NSString class]]) {
		
		__block NSString *status = (NSString *)object;
		NSString *statusCode	= [MHOrganizationalPermission statusFromStatusForDisplay:status];
		
		[DejalBezelActivityView activityViewForView:self.activityViewController.parentViewController.view withLabel:@"Applying Status..."].showNetworkActivityIndicator	= YES;
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] bulkChangeStatus:statusCode forPeople:self.peopleToChangeStatus withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			[DejalBezelActivityView removeViewAnimated:YES];
			
			SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																	andMessage:[NSString stringWithFormat:@"%d people now have the status: %@", weakSelf.peopleToChangeStatus.count, status]];
			[successAlertView addButtonWithTitle:@"Ok"
											type:SIAlertViewButtonTypeDestructive
										 handler:^(SIAlertView *alertView) {
											 
										 }];
			
			successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
			successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
			
			[successAlertView show];
			
			[weakSelf activityDidFinish:YES];
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {

			[DejalBezelActivityView removeViewAnimated:YES];
			
			NSString *message				= [NSString stringWithFormat:@"Changing status for %d people failed because: %@ If the problem persists please contact support@mission.com", weakSelf.peopleToChangeStatus.count, [error localizedDescription]];
			NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
															 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
			
			[MHErrorHandler presentError:presentationError];
			
			[weakSelf activityDidFinish:NO];
			
		}];
		
	}
	
}

@end