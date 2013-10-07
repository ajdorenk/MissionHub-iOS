//
//  MHAssignActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHAssignActivity.h"
#import "MHActivityViewController.h"
#import "MHAPI.h"
#import "MHPerson+Helper.h"
#import "SIAlertView.h"

NSString * const MHActivityTypeAssign	= @"com.missionhub.mhactivity.type.assign";

@interface MHAssignActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToAssign;

@end

@implementation MHAssignActivity

@synthesize peopleToAssign	= _peopleToAssign;

- (id)init
{
    self = [super initWithTitle:@"Assign"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Assign_48"]];
    
    
    if (self) {
    
		self.peopleToAssign = [NSMutableArray array];
		
	}
    
    return self;
}

- (NSString *)activityType {
	
	return MHActivityTypeAssign;
	
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
	
	[super prepareWithActivityItems:activityItems];
	
	[self.peopleToAssign removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[weakSelf.peopleToAssign addObject:object];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	MHGenericListViewController *permissionLevelList	= [self.activityViewController.presentingController.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
	
	permissionLevelList.selectionDelegate	= self;
	permissionLevelList.multipleSelection	= NO;
	permissionLevelList.showHeaders			= NO;
	permissionLevelList.showSuggestions		= NO;
	permissionLevelList.listTitle			= @"Admins & Users";
	
	NSMutableArray *peopleYouCanAssignTo	= [NSMutableArray arrayWithArray:[[MHAPI sharedInstance].currentOrganization.users allObjects]];
	[peopleYouCanAssignTo addObjectsFromArray:[[MHAPI sharedInstance].currentOrganization.admins allObjects]];
	[peopleYouCanAssignTo sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
	
	[permissionLevelList setDataArray:peopleYouCanAssignTo];
	
	[self.activityViewController.presentingController presentViewController:permissionLevelList animated:YES completion:nil];
	
}

- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self.activityViewController.presentingController dismissViewControllerAnimated:YES completion:nil];
	
	if ([object isKindOfClass:[MHPerson class]]) {
		
		__block MHPerson *person	= (MHPerson *)object;
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] bulkAssignPeople:self.peopleToAssign toPerson:person withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																	andMessage:[NSString stringWithFormat:@"%d people are now assigned to: %@", weakSelf.peopleToAssign.count, person.fullName]];
			[successAlertView addButtonWithTitle:@"Ok"
											type:SIAlertViewButtonTypeDestructive
										 handler:^(SIAlertView *alertView) {
											 
										 }];
			
			successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
			successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
			
			[successAlertView show];
			
			[weakSelf activityDidFinish:YES];
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			NSString *message				= [NSString stringWithFormat:@"Assigning %d people to %@ failed because: %@. If the problem persists please contact support@mission.com", weakSelf.peopleToAssign.count, person.fullName, [error localizedDescription]];
			NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
															 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
			
			[MHErrorHandler presentError:presentationError];
			
			[weakSelf activityDidFinish:NO];
			
		}];
		
	}
	
}


@end
