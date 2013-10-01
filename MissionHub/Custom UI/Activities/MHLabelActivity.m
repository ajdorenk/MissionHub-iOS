//
//  MHLabelActivity.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLabelActivity.h"
#import "MHActivityViewController.h"
#import "MHAPI.h"
#import "MHPerson+Helper.h"
#import "MHOrganizationalLabel+Helper.h"
#import "MHLabel+Helper.h"
#import "SIAlertView.h"

NSString * const MHActivityTypeLabel	= @"com.missionhub.mhactivity.type.label";

@interface MHLabelActivity ()

@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableDictionary *labelStates;
@property (nonatomic, strong) NSMutableArray *labelsWithAllState;
@property (nonatomic, strong) NSMutableArray *labelsWithSomeState;
@property (nonatomic, strong) NSMutableArray *labelsWithNoneState;


@end

@implementation MHLabelActivity

- (id)init {
	
    self = [super initWithTitle:@"Label"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Label_48"]
                    actionBlock:nil];
    
    
    if (self) {
		
		self.people					= [NSMutableArray array];
		self.labelStates			= [NSMutableDictionary dictionary];
		self.labelsWithAllState		= [NSMutableArray array];
		self.labelsWithSomeState	= [NSMutableArray array];
		self.labelsWithNoneState	= [NSMutableArray array];
		
	}
    
    return self;
	
}

- (NSString *)activityType {
	
	return MHActivityTypeLabel;
	
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
	
	[self.people removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			__block MHPerson *person	= object;
			
			[weakSelf.people addObject:person];
			
			[person.labels enumerateObjectsUsingBlock:^(MHOrganizationalLabel *organizationalLabel, BOOL *stop) {
				
				NSDictionary *labelState	= [weakSelf.labelStates objectForKey:organizationalLabel.label_id];
				
				if (labelState) {
					
					NSMutableArray *peopleWithLabel		= [labelState objectForKey:@"people"];
					
					[peopleWithLabel addObject:person];
					
				} else {
					
					NSMutableArray *peopleWithLabel		= [NSMutableArray arrayWithObject:person];
					
					labelState	= @{@"people": peopleWithLabel};
					[self.labelStates setObject:labelState forKey:organizationalLabel.label_id];
					
				}
				
			}];
			
		}
		
	}];
	
	//run through all the labels in the organization
	[[MHAPI sharedInstance].currentOrganization.labels enumerateObjectsUsingBlock:^(MHLabel *label, BOOL *stop) {
		
		NSDictionary *labelState	= [weakSelf.labelStates objectForKey:label.remoteID];
		
		if (labelState) {
			
			NSMutableArray *peopleWithLabel		= [labelState objectForKey:@"people"];
			
			if (peopleWithLabel.count == weakSelf.people.count) {
				
				[labelState setValue:[NSNumber numberWithInteger:MHGenericListObjectStateSelectedAll] forKey:@"beforeState"];
				[labelState setValue:[NSNumber numberWithInteger:MHGenericListObjectStateSelectedAll] forKey:@"afterState"];
				
				[weakSelf.labelsWithAllState addObject:label];
				
			} else if (peopleWithLabel.count == 0) {
				
				[labelState setValue:[NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone] forKey:@"beforeState"];
				[labelState setValue:[NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone] forKey:@"afterState"];
				
				[weakSelf.labelsWithNoneState addObject:label];
				
			} else {
				
				[labelState setValue:[NSNumber numberWithInteger:MHGenericListObjectStateSelectedSome] forKey:@"beforeState"];
				[labelState setValue:[NSNumber numberWithInteger:MHGenericListObjectStateSelectedSome] forKey:@"afterState"];
				
				[weakSelf.labelsWithSomeState addObject:label];
				
			}
			
			[labelState setValue:label forKey:@"label"];
			
			
		} else {
			
			NSMutableArray *peopleWithLabel		= [NSMutableArray array];
			
			labelState	= @{
							@"label":		label,
							@"people":		peopleWithLabel,
							@"beforeState": [NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone],
							@"afterState":	[NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone]
							};
			
			[self.labelStates setObject:labelState forKey:label.remoteID];
			
			[weakSelf.labelsWithNoneState addObject:label];
			
		}
		
	}];
	
}

- (void)performActivity {
	
	MHGenericListViewController *permissionLevelList	= [self.activityViewController.presentingController.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
	
	permissionLevelList.selectionDelegate	= self;
	permissionLevelList.multipleSelection	= YES;
	permissionLevelList.useThreeStateCell	= YES;
	permissionLevelList.showHeaders			= YES;
	permissionLevelList.showSuggestions		= NO;
	permissionLevelList.showApplyButton		= YES;
	permissionLevelList.listTitle			= @"Users";
	[permissionLevelList setDataArray:[[MHAPI sharedInstance].currentOrganization.labels allObjects]];
	[permissionLevelList setObjectsWithStateAllState:self.labelsWithAllState someState:self.labelsWithSomeState noneState:self.labelsWithNoneState];
	
	[self.activityViewController.presentingController presentViewController:permissionLevelList animated:YES completion:nil];
	
}

- (void)list:(MHGenericListViewController *)viewController didChangeState:(MHGenericListObjectState)state forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	if ([object isKindOfClass:[MHLabel class]]) {
		
		MHLabel *label = (MHLabel *)object;
		NSDictionary *labelState	= [self.labelStates objectForKey:label.remoteID];
		
		[labelState setValue:[NSNumber numberWithInteger:state] forKey:@"afterState"];
		
	}
	
}

- (void)list:(MHGenericListViewController *)viewController didTapApplyButton:(UIBarButtonItem *)applyButton {
	
	__block NSMutableArray *labelsToAdd		= [NSMutableArray array];
	__block NSMutableArray *labelsToRemove	= [NSMutableArray array];
	
	[self.labelStates enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *labelState, BOOL *stop) {
		
		MHLabel *label							= [labelState objectForKey:@"label"];
		MHGenericListObjectState beforeState	= [[labelState objectForKey:@"beforeState"] integerValue];
		MHGenericListObjectState afterState		= [[labelState objectForKey:@"afterState"] integerValue];
		
		if (beforeState == MHGenericListObjectStateSelectedSome && afterState == MHGenericListObjectStateSelectedAll) {
			
			if (label) {
				
				[labelsToAdd addObject:label];
				
			}
			
		} else if (beforeState == MHGenericListObjectStateSelectedSome && afterState == MHGenericListObjectStateSelectedNone) {
			
			if (label) {
				
				[labelsToRemove addObject:label];
				
			}
			
		} else if (beforeState == MHGenericListObjectStateSelectedAll && afterState == MHGenericListObjectStateSelectedNone) {
			
			if (label) {
				
				[labelsToRemove addObject:label];
				
			}
			
		} else if (beforeState == MHGenericListObjectStateSelectedNone && afterState == MHGenericListObjectStateSelectedAll) {
			
			if (label) {
				
				[labelsToAdd addObject:label];
				
			}
			
		}
		
	}];
	
	__weak __typeof(&*self)weakSelf = self;
	[[MHAPI sharedInstance] bulkChangeLabelsWithLabelsToAdd:labelsToAdd labelsToRemove:labelsToRemove forPeople:self.people withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
		
		SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																andMessage:[NSString stringWithFormat:@"%d people have had their labels updated!", weakSelf.people.count]];
		[successAlertView addButtonWithTitle:@"Ok"
										type:SIAlertViewButtonTypeDestructive
									 handler:^(SIAlertView *alertView) {
										 
									 }];
		
		successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
		successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
		
		[successAlertView show];
		
		[weakSelf activityDidFinish:YES];
		
		
	} failBlock:^(NSError *error, MHRequestOptions *options) {
		
		NSString *message				= [NSString stringWithFormat:@"Updating labels for %d people failed because: %@. If the problem persists please contact support@mission.com", weakSelf.people.count, [error localizedDescription]];
		NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
														 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
		
		[MHErrorHandler presentError:presentationError];
		
		[weakSelf activityDidFinish:NO];
		
	}];
	
}

@end
