//
//  MHPermissionsActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPermissionsActivity.h"
#import "MHActivityViewController.h"
#import "MHAPI.h"
#import "MHPermissionLevel+Helper.h"
#import "SIAlertView.h"
#import "NSSet+MHSearchForRemoteID.h"
#import "MHAllObjects.h"
#import "DejalActivityView.h"

NSString * const MHActivityTypePermissions	= @"com.missionhub.mhactivity.type.permissions";

@interface MHPermissionsActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToChangePermissionLevel;
@property (nonatomic, strong, readonly) MHGenericListViewController *permissionLevelViewController;

- (void)displayViewController;

@end

@implementation MHPermissionsActivity

@synthesize peopleToChangePermissionLevel	= _peopleToChangePermissionLevel;
@synthesize permissionLevelViewController	= _permissionLevelViewController;

- (id)init {
	
    self = [super initWithTitle:@"Permission"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Permissions_48"]];
    
    
    if (self) {
		
		self.peopleToChangePermissionLevel	= [NSMutableArray array];
		
	}
    
    return self;
}

- (MHGenericListViewController *)permissionLevelViewController {
	
	if (!_permissionLevelViewController) {
		
		[self willChangeValueForKey:@"permissionLevelViewController"];
		_permissionLevelViewController	= [self.activityViewController.presentingController.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"permissionLevelViewController"];
		
		_permissionLevelViewController.selectionDelegate	= self;
		_permissionLevelViewController.multipleSelection	= NO;
		_permissionLevelViewController.showHeaders			= NO;
		_permissionLevelViewController.showSuggestions		= NO;
		_permissionLevelViewController.listTitle			= @"Permission Levels";
		[_permissionLevelViewController setDataArray:@[[MHPermissionLevel admin], [MHPermissionLevel user], [MHPermissionLevel noPermissions]]];
		
	}
	
	return _permissionLevelViewController;
	
}

- (NSString *)activityType {
	
	return MHActivityTypePermissions;
	
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
	
	[self.peopleToChangePermissionLevel removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[weakSelf.peopleToChangePermissionLevel addObject:object];
			
		} else if ([object isKindOfClass:[MHAllObjects class]]) {
			
			[weakSelf.peopleToChangePermissionLevel removeAllObjects];
			[weakSelf.peopleToChangePermissionLevel addObject:object];
			*stop	= YES;
			
		}
		
	}];
	
}

- (void)performActivity {
	
	if (self.peopleToChangePermissionLevel.count) {
		
		if ([self.peopleToChangePermissionLevel[0] isKindOfClass:[MHAllObjects class]]) {
			
			[DejalBezelActivityView activityViewForView:self.activityViewController.parentViewController.view withLabel:@"Loading People..."].showNetworkActivityIndicator	= YES;
			
			MHAllObjects *allPeople	= self.peopleToChangePermissionLevel[0];
			
			__weak typeof(self)weakSelf = self;
			[allPeople getPeopleListWithSuccessBlock:^(NSArray *peopleList) {
				
				[weakSelf.peopleToChangePermissionLevel removeAllObjects];
				[weakSelf.peopleToChangePermissionLevel addObjectsFromArray:peopleList];
				
				[DejalBezelActivityView removeViewAnimated:YES];
				
				[self displayViewController];
				
			} failBlock:^(NSError *error) {
				
				[DejalBezelActivityView removeViewAnimated:YES];
				
				NSString *message				= [NSString stringWithFormat:@"We can't change permission for anyone on this list of people because we couldn't retrieve the rest of the list. If the problem persists please contact support@mission.com"];
				NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
																 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
				
				[MHErrorHandler presentError:presentationError];
				
				[weakSelf activityDidFinish:NO];
				
			}];
			
		} else {
			
			[self displayViewController];
			
		}
		
	}
	
	
	
}

- (void)displayViewController {
	
	if (self.peopleToChangePermissionLevel.count == 1) {
		
		MHPerson *person					= self.peopleToChangePermissionLevel[0];
		MHPermissionLevel *permissionLevel	= [MHPermissionLevel noPermissions];
		
		if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel user].remoteID]) {
			
			permissionLevel	= [MHPermissionLevel user];
			
		} else if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel admin].remoteID]) {
			
			permissionLevel	= [MHPermissionLevel admin];
			
		}
		
		[self.permissionLevelViewController setSuggestions:nil andSelectionObject:permissionLevel];
		
	} else {
		
		__block MHPermissionLevel *permissionLevel	= nil;
		
		[self.peopleToChangePermissionLevel enumerateObjectsUsingBlock:^(MHPerson *person, NSUInteger index, BOOL *stop) {
			
			if (permissionLevel) {
				
				if (![person.permissionLevel.permission_id isEqualToNumber:permissionLevel.remoteID]) {
					
					permissionLevel	= nil;
					*stop			= YES;
					
				}
				
			} else {
				
				if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel noPermissions].remoteID]) {
					
					permissionLevel	= [MHPermissionLevel noPermissions];
					
				} else if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel user].remoteID]) {
					
					permissionLevel	= [MHPermissionLevel user];
					
				} else if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel admin].remoteID]) {
					
					permissionLevel	= [MHPermissionLevel admin];
					
				}
				
			}
			
		}];
		
		if (permissionLevel) {
			
			[self.permissionLevelViewController setSuggestions:nil andSelectionObject:permissionLevel];
			
		}
		
	}
	
	[self.activityViewController.presentingController presentViewController:self.permissionLevelViewController animated:YES completion:nil];
	
}

- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self.activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	if ([object isKindOfClass:[MHPermissionLevel class]]) {
		
		[DejalBezelActivityView activityViewForView:self.activityViewController.parentViewController.view withLabel:@"Apply Permission Level..."].showNetworkActivityIndicator	= YES;
		
		__block MHPermissionLevel *permissionLevel        = (MHPermissionLevel *)object;
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] bulkChangePermissionLevel:permissionLevel forPeople:self.peopleToChangePermissionLevel withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			[weakSelf.peopleToChangePermissionLevel enumerateObjectsUsingBlock:^(MHPerson *person, NSUInteger index, BOOL *stop) {
				
				if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel admin].remoteID]) {
					
					MHPerson *personObjectInAdminSet        = (MHPerson *)[[MHAPI sharedInstance].currentOrganization.admins findWithRemoteID:person.remoteID];
					[[MHAPI sharedInstance].currentOrganization removeAdminsObject:personObjectInAdminSet];
					
				}
				
				if ([permissionLevel isEqualToModel:[MHPermissionLevel admin]]) {
					
					[[MHAPI sharedInstance].currentOrganization addAdminsObject:person];
					
				}
				
				if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel user].remoteID]) {
					
					MHPerson *personObjectInAdminSet        = (MHPerson *)[[MHAPI sharedInstance].currentOrganization.users findWithRemoteID:person.remoteID];
					[[MHAPI sharedInstance].currentOrganization removeUsersObject:personObjectInAdminSet];
					
				}
				
				if ([permissionLevel isEqualToModel:[MHPermissionLevel user]]) {
					
					[[MHAPI sharedInstance].currentOrganization addUsersObject:person];
					
				}
				
			}];
			
			[DejalBezelActivityView removeViewAnimated:YES];
			
			SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																	andMessage:[NSString stringWithFormat:@"%d people now are: %@", weakSelf.peopleToChangePermissionLevel.count, permissionLevel.name]];
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
			
			NSString *message                                = [NSString stringWithFormat:@"Changing permissions for %d people failed because: %@. If the problem persists please contact support@mission.com", weakSelf.peopleToChangePermissionLevel.count, [error localizedDescription]];
			NSError *presentationError        = [NSError errorWithDomain:MHAPIErrorDomain
																	code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
			
			[MHErrorHandler presentError:presentationError];
			
			[weakSelf activityDidFinish:NO];
			
		}];
		
	}
	
}

@end
