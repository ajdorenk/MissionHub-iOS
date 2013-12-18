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
#import "MHAllObjects.h"
#import "DejalActivityView.h"

NSString * const MHActivityTypeLabel	= @"com.missionhub.mhactivity.type.label";

@interface MHLabelActivity ()

@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableDictionary *labelStates;
@property (nonatomic, strong) NSMutableArray *labelsWithAllState;
@property (nonatomic, strong) NSMutableArray *labelsWithSomeState;
@property (nonatomic, strong) NSMutableArray *labelsWithNoneState;
@property (nonatomic, strong, readonly) MHGenericListViewController *labelViewController;

@end

@implementation MHLabelActivity

@synthesize labelViewController	= _labelViewController;

- (id)init {
	
    self = [super initWithTitle:@"Label"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Label_48"]];
    
    
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
		
		if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHAllObjects class]]) {
			
			hasPeople	= YES;
			*stop		= YES;
			
		}
		
	}];
	
	return hasPeople;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[self.people removeAllObjects];
	[self.labelStates removeAllObjects];
	[self.labelsWithAllState removeAllObjects];
	[self.labelsWithSomeState removeAllObjects];
	[self.labelsWithNoneState removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			__block MHPerson *person	= object;
			
			[weakSelf.people addObject:person];
			
			[person.labels enumerateObjectsUsingBlock:^(MHOrganizationalLabel *organizationalLabel, BOOL *stop) {
				
				NSMutableDictionary *labelState	= weakSelf.labelStates[organizationalLabel.label_id];
				
				if (labelState) {
					
					NSMutableArray *peopleWithLabel		= labelState[@"people"];
					
					[peopleWithLabel addObject:person];
					
				} else {
					
					NSMutableArray *peopleWithLabel		= [NSMutableArray arrayWithObject:person];
					
					labelState	= [NSMutableDictionary dictionaryWithDictionary:@{@"people": peopleWithLabel}];
					weakSelf.labelStates[organizationalLabel.label_id]		= labelState;
					
				}
				
			}];
			
		} else if ([object isKindOfClass:[MHAllObjects class]]) {
			
			[weakSelf.people removeAllObjects];
			[weakSelf.people addObject:object];
			*stop	= YES;
			
		}
		
	}];
	
}

- (void)performActivity {
	
	__weak typeof(self)weakSelf = self;
	[self returnPeopleFromArray:self.people withCompletionBlock:^(NSArray *peopleList) {
		
		weakSelf.people	= [peopleList mutableCopy];
		
		//run through all the labels in the organization
		[[MHAPI sharedInstance].currentOrganization.labels enumerateObjectsUsingBlock:^(MHLabel *label, BOOL *stop) {
			
			NSMutableDictionary *labelState	= weakSelf.labelStates[label.remoteID];
			
			if (labelState) {
				
				NSMutableArray *peopleWithLabel		= labelState[@"people"];
				
				if (peopleWithLabel.count == weakSelf.people.count) {
					
					labelState[@"beforeState"]	= [NSNumber numberWithInteger:MHGenericListObjectStateSelectedAll];
					labelState[@"afterState"]	= [NSNumber numberWithInteger:MHGenericListObjectStateSelectedAll];
					
					[weakSelf.labelsWithAllState addObject:label];
					
				} else if (peopleWithLabel.count == 0) {
					
					labelState[@"beforeState"]	= [NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone];
					labelState[@"afterState"]	= [NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone];
					
					[weakSelf.labelsWithNoneState addObject:label];
					
				} else {
					
					labelState[@"beforeState"]	= [NSNumber numberWithInteger:MHGenericListObjectStateSelectedSome];
					labelState[@"afterState"]	= [NSNumber numberWithInteger:MHGenericListObjectStateSelectedSome];
					
					[weakSelf.labelsWithSomeState addObject:label];
					
				}
				
				labelState[@"label"] = label;
				
				
			} else {
				
				NSMutableArray *peopleWithLabel		= [NSMutableArray array];
				
				labelState	= [NSMutableDictionary dictionaryWithDictionary:@{
																			  @"label":		label,
																			  @"people":		peopleWithLabel,
																			  @"beforeState": [NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone],
																			  @"afterState":	[NSNumber numberWithInteger:MHGenericListObjectStateSelectedNone]
																			  }];
				
				weakSelf.labelStates[label.remoteID]	= labelState;
				
				[weakSelf.labelsWithNoneState addObject:label];
				
			}
			
		}];
		
		NSArray *sortedLabelArray				= [MHAPI sharedInstance].currentOrganization.labels.allObjects;
		sortedLabelArray						= [sortedLabelArray sortedArrayUsingDescriptors:@[
																								  [NSSortDescriptor sortDescriptorWithKey:@"name"
																																ascending:YES
																																 selector:@selector(caseInsensitiveCompare:)]
																								  ]
												   ];
		[weakSelf.labelViewController setDataArray:sortedLabelArray];
		[weakSelf.labelViewController setObjectsWithStateAllState:weakSelf.labelsWithAllState someState:weakSelf.labelsWithSomeState];
		
		[weakSelf.activityViewController.presentingController presentViewController:weakSelf.labelViewController animated:YES completion:nil];
		
		[DejalBezelActivityView removeViewAnimated:YES];
		
	}];
	
}

- (MHGenericListViewController *)labelViewController {
	
	if (!_labelViewController) {
	
		[self willChangeValueForKey:@"labelViewController"];
		_labelViewController	= [self.activityViewController.presentingController.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"labelViewController"];
			
		_labelViewController.selectionDelegate	= self;
		_labelViewController.multipleSelection	= YES;
		_labelViewController.showHeaders		= NO;
		_labelViewController.showSuggestions	= NO;
		_labelViewController.showApplyButton	= YES;
		_labelViewController.listTitle			= @"Label(s)";
		
	}
	
	return _labelViewController;
	
}

- (void)list:(MHGenericListViewController *)viewController didChangeObjectStateFrom:(MHGenericListObjectState)fromState toState:(MHGenericListObjectState)toState forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	if ([object isKindOfClass:[MHLabel class]]) {
		
		MHLabel *label					= (MHLabel *)object;
		NSMutableDictionary *labelState	= self.labelStates[label.remoteID];
		
		labelState[@"afterState"]		= [NSNumber numberWithInteger:toState];
		
	}
	
}

- (void)list:(MHGenericListViewController *)viewController didTapApplyButton:(UIBarButtonItem *)applyButton {
	
	[DejalBezelActivityView activityViewForView:self.activityViewController.parentViewController.view withLabel:@"Labeling People..."].showNetworkActivityIndicator	= YES;
	
	__block NSMutableArray *labelsToAdd		= [NSMutableArray array];
	__block NSMutableArray *labelsToRemove	= [NSMutableArray array];
	
	[self.labelStates enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableDictionary *labelState, BOOL *stop) {
		
		MHLabel *label							= labelState[@"label"];
		MHGenericListObjectState beforeState	= [labelState[@"beforeState"] integerValue];
		MHGenericListObjectState afterState		= [labelState[@"afterState"] integerValue];
		
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
		
		[DejalBezelActivityView removeViewAnimated:YES];
		
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
		
		[DejalBezelActivityView removeViewAnimated:YES];
		
		NSString *message				= [NSString stringWithFormat:@"Updating labels for %d people failed because: %@. If the problem persists please contact support@mission.com", weakSelf.people.count, [error localizedDescription]];
		NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
														 code: [error code] userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
		
		[MHErrorHandler presentError:presentationError];
		
		[weakSelf activityDidFinish:NO];
		
	}];
	
}

@end
