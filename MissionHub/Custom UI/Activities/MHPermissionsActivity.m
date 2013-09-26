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

NSString * const MHActivityTypePermissions	= @"com.missionhub.mhactivity.type.permissions";

@interface MHPermissionsActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToChangePermissionLevel;

@end

@implementation MHPermissionsActivity

@synthesize peopleToChangePermissionLevel	= _peopleToChangePermissionLevel;

- (id)init {
	
    self = [super initWithTitle:@"Permission"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Permissions_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		self.peopleToChangePermissionLevel	= [NSMutableArray array];
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypePermissions;
	
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
	
	[self.peopleToChangePermissionLevel removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[weakSelf.peopleToChangePermissionLevel addObject:object];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	MHGenericListViewController *permissionLevelList	= [self.activityViewController.presentingController.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
	
	permissionLevelList.selectionDelegate	= self;
	permissionLevelList.multipleSelection	= NO;
	permissionLevelList.showHeaders			= NO;
	permissionLevelList.showSuggestions		= NO;
	permissionLevelList.listTitle			= @"Permission Levels";
	[permissionLevelList setDataArray:@[[MHPermissionLevel admin], [MHPermissionLevel user], [MHPermissionLevel noPermissions]]];
	
	[self.activityViewController.presentingController presentViewController:permissionLevelList animated:YES completion:nil];
	
}

- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self.activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	if ([object isKindOfClass:[MHPermissionLevel class]]) {
		
		__block MHPermissionLevel *permissionLevel	= (MHPermissionLevel *)object;
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] bulkChangePermissionLevel:permissionLevel forPeople:self.peopleToChangePermissionLevel withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																	andMessage:[NSString stringWithFormat:@"%d people now are: %@?", weakSelf.peopleToChangePermissionLevel.count, permissionLevel.name]];
			[successAlertView addButtonWithTitle:@"Ok"
											type:SIAlertViewButtonTypeDestructive
										 handler:^(SIAlertView *alertView) {
											 
										 }];
			
			successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
			successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
			
			[successAlertView show];
			
			[weakSelf activityDidFinish:YES];
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			NSString *message				= [NSString stringWithFormat:@"Changing permissions for %d people failed because: %@. If the problem persists please contact support@mission.com", weakSelf.peopleToChangePermissionLevel.count, [error localizedDescription]];
			NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
															 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
			
			[MHErrorHandler presentError:presentationError];
			
			[weakSelf activityDidFinish:NO];
			
		}];
		
	}
	
}

@end
