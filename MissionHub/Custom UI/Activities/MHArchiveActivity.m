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
#import "MHAllObjects.h"

NSString * const MHActivityTypeArchive	= @"com.missionhub.mhactivity.type.archive";

@interface MHArchiveActivity ()

@property (nonatomic, strong) NSMutableArray *peopleToArchive;

@end

@implementation MHArchiveActivity

@synthesize peopleToArchive = _peopleToArchive;

- (id)init {
	
    self = [super initWithTitle:@"Archive"
                          image:[UIImage imageNamed:@"MH_Mobile_ActionIcon_Archive_48"]];
    
    
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
		
		if ([object isKindOfClass:[MHPerson class]] || [object isKindOfClass:[MHAllObjects class]]) {
			
			hasPeople	= YES;
			*stop		= YES;
			
		}
		
	}];
	
	return hasPeople;
	
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	
	[super prepareWithActivityItems:activityItems];
	
	[self.peopleToArchive removeAllObjects];
	
	__weak __typeof(&*self)weakSelf = self;
	[activityItems enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		if ([object isKindOfClass:[MHPerson class]]) {
			
			[weakSelf.peopleToArchive addObject:object];
			
		} else if ([object isKindOfClass:[MHAllObjects class]]) {
			
			[weakSelf.peopleToArchive removeAllObjects];
			[weakSelf.peopleToArchive addObject:object];
			*stop	= YES;
			
		}
		
	}];
	
}

- (void)performActivity {
	
	SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Warning"
													 andMessage:[NSString stringWithFormat:@"Are you sure you want to archive these people?"]];
	
	__weak __typeof(&*self)weakSelf = self;
	[alertView addButtonWithTitle:@"Yes"
							 type:SIAlertViewButtonTypeDestructive
						  handler:^(SIAlertView *alertView) {
							  
							  [weakSelf returnPeopleFromArray:weakSelf.peopleToArchive withCompletionBlock:^(NSArray *peopleList) {
								  
								  weakSelf.peopleToArchive	= [peopleList mutableCopy];
								  
								  [[MHAPI sharedInstance] bulkArchivePeople:weakSelf.peopleToArchive withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
									  
									  [weakSelf.peopleToArchive enumerateObjectsUsingBlock:^(MHPerson *person, NSUInteger index, BOOL *stop) {
										  
										  if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel admin].remoteID]) {
											  
											  MHPerson *personObjectInAdminSet	= (MHPerson *)[[MHAPI sharedInstance].currentOrganization.admins findWithRemoteID:person.remoteID];
											  [[MHAPI sharedInstance].currentOrganization removeAdminsObject:personObjectInAdminSet];
											  
										  }
										  
										  if ([person.permissionLevel.permission_id isEqualToNumber:[MHPermissionLevel user].remoteID]) {
											  
											  MHPerson *personObjectInAdminSet	= (MHPerson *)[[MHAPI sharedInstance].currentOrganization.users findWithRemoteID:person.remoteID];
											  [[MHAPI sharedInstance].currentOrganization removeUsersObject:personObjectInAdminSet];
											  
										  }
										  
									  }];
									  
									  SIAlertView *successAlertView = [[SIAlertView alloc] initWithTitle:@"Success"
																							  andMessage:[NSString stringWithFormat:@"%d people were successfully archived?", weakSelf.peopleToArchive.count]];
									  [successAlertView addButtonWithTitle:@"Ok"
																	  type:SIAlertViewButtonTypeDestructive
																   handler:^(SIAlertView *alertView) {
																	   
																   }];
									  
									  successAlertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
									  successAlertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
									  
									  [successAlertView show];
									  
									  [weakSelf activityDidFinish:YES];
									  
								  } failBlock:^(NSError *error, MHRequestOptions *options) {
									  
									  NSString *message				= [NSString stringWithFormat:@"Archiving %d people failed because: %@. If the problem persists please contact support@mission.com", weakSelf.peopleToArchive.count, [error localizedDescription]];
									  NSError *presentationError	= [NSError errorWithDomain:MHAPIErrorDomain
																					   code: [error code]
																				   userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
									  
									  [MHErrorHandler presentError:presentationError];
									  
									  [weakSelf activityDidFinish:NO];
									  
								  }];
								  
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
