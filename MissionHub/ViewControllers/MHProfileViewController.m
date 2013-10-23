//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileViewController.h"
#import "MHProfileSurveysViewController.h"
#import "MHProfileHeaderViewController.h"
#import "MHProfileInfoViewController.h"
#import "MHProfileInteractionsViewController.h"
#import "MHNewInteractionViewController.h"
#import "MHAPI.h"
#import "MHToolbar.h"

NSString *const MHProfileViewControllerNotificationPersonDeleted	= @"com.missionhub.MHProfileViewController.notification.personDeleted";
NSString *const MHProfileViewControllerNotificationPersonArchived	= @"com.missionhub.MHProfileViewController.notification.personArchived";
NSString *const MHProfileViewControllerNotificationPersonUpdated	= @"com.missionhub.MHProfileViewController.notification.personUpdated";
CGFloat const MHProfileNavigationBarButtonMarginVertical			= 5.0f;
CGFloat const MHProfileHeaderHeight									= 150.0f;

@interface MHProfileViewController ()

@property (nonatomic, strong) NSArray										*allViewControllers;
@property (nonatomic, strong) UIViewController								*currentViewController;

@property (nonatomic, strong, readonly) UIPopoverController					*createInteractionPopoverController;
@property (nonatomic, strong, readonly) MHNewInteractionViewController		*createInteractionViewController;
@property (nonatomic, strong, readonly) MHProfileHeaderViewController		*headerViewController;
@property (nonatomic, strong, readonly) MHProfileMenuViewController			*menuViewController;
@property (nonatomic, strong, readonly) MHProfileInfoViewController			*infoViewController;
@property (nonatomic, strong, readonly) MHProfileInteractionsViewController	*interactionsViewController;
@property (nonatomic, strong, readonly) MHLabelActivity						*labelActivity;
@property (nonatomic, strong, readonly) MHProfileSurveysViewController		*surveysViewController;
@property (nonatomic, strong, readonly) MHActivityViewController			*activityViewController;

- (void)refreshInfoForPerson:(MHPerson *)person onCompletion:(void (^)(void))completionBlock;
- (void)refreshSurveyAnswersForPerson:(MHPerson *)person;
- (void)refreshInteractionsForPerson:(MHPerson *)person;

- (void)backToMenu:(id)sender;
- (void)newInteractionActivity:(id)sender;
- (void)addLabelActivity:(id)sender;
- (void)otherOptionsActivity:(id)sender;

- (void)updateInterfaceWithPerson:(MHPerson *)person;
- (void)updateLayoutWithFrame:(CGRect)frame;
- (void)updateBarButtons;

@end


@implementation MHProfileViewController

@synthesize person							= _person;
@synthesize allViewControllers				= _allViewControllers;
@synthesize currentViewController			= _currentViewController;
@synthesize createInteractionPopoverController = _createInteractionPopoverController;
@synthesize createInteractionViewController	= _createInteractionViewController;
@synthesize headerViewController			= _headerViewController;
@synthesize menuViewController				= _menuViewController;
@synthesize infoViewController				= _infoViewController;
@synthesize interactionsViewController		= _interactionsViewController;
@synthesize labelActivity					= _labelActivity;
@synthesize surveysViewController			= _surveysViewController;
@synthesize activityViewController			= _activityViewController;

#pragma mark - intialization methods

- (void) awakeFromNib {
	
	// Add A and B view controllers to the array
    self.allViewControllers = @[self.infoViewController,self.interactionsViewController, self.surveysViewController];
	
    [self.menuViewController setMenuSelection:0];
	[self.menuViewController setMenuDelegate:self];
	
	[self setupWithTopViewController:self.headerViewController
							  height:MHProfileHeaderHeight
				 tableViewController:(UITableViewController *)self.currentTableViewContoller
			 segmentedViewController:self.menuViewController];
	
	self.person = [MHAPI sharedInstance].currentUser;
	
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[self updateBarButtons];
	[self updateLayoutWithFrame:self.view.frame];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[[self menuViewController] setMenuSelection:0];
	[self switchTableViewController:[self.allViewControllers objectAtIndex:0]];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	[self.activityViewController dismissViewControllerAnimated:NO completion:nil];
	
}

#pragma mark - accessor methods

- (id<MHProfileProtocol>)currentTableViewContoller {
	
	return [self.allViewControllers objectAtIndex:[[self menuViewController] menuSelection]];
}

- (MHNewInteractionViewController *)createInteractionViewController {
	
	if (_createInteractionViewController == nil) {
		
		UIStoryboard *storyboard	= [UIStoryboard storyboardWithName:@"MissionHub_iPhone" bundle:nil];
		
		[self willChangeValueForKey:@"createInteractionViewController"];
		_createInteractionViewController = [storyboard instantiateViewControllerWithIdentifier:@"MHNewInteractionViewController"];
		[self didChangeValueForKey:@"createInteractionViewController"];
		
	}
	
	return _createInteractionViewController;
	
}

- (MHProfileHeaderViewController *)headerViewController {
	
	if (_headerViewController == nil) {
		
		[self willChangeValueForKey:@"headerViewController"];
		_headerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileHeaderViewController"];
		[self didChangeValueForKey:@"headerViewController"];
		
	}
	
	return _headerViewController;
	
}

- (MHProfileMenuViewController *)menuViewController {
	
	if (_menuViewController == nil) {
		
		[self willChangeValueForKey:@"menuViewController"];
		_menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileMenuViewController"];
		[self didChangeValueForKey:@"menuViewController"];
		
	}
	
	return _menuViewController;
	
}

- (MHProfileInfoViewController *)infoViewController {
	
	if (_infoViewController == nil) {
		
		[self willChangeValueForKey:@"infoViewController"];
		_infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileInfoViewController"];
		[self didChangeValueForKey:@"infoViewController"];
		
	}
	
	return _infoViewController;
	
}

- (MHProfileInteractionsViewController *)interactionsViewController {
	
	if (_interactionsViewController == nil) {
		
		[self willChangeValueForKey:@"interactionsViewController"];
		_interactionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileInteractionsViewController"];
		[self didChangeValueForKey:@"interactionsViewController"];
		
	}
	
	return _interactionsViewController;
	
}

- (UIPopoverController *)createInteractionPopoverController {
	
	if (_createInteractionPopoverController == nil) {
		
		UINavigationController *navigationController	= [[UINavigationController alloc] initWithRootViewController:self.createInteractionViewController];
		
		[self willChangeValueForKey:@"createInteractionPopoverViewController"];
		_createInteractionPopoverController				= [[UIPopoverController alloc] initWithContentViewController:navigationController];
		[self didChangeValueForKey:@"createInteractionPopoverViewController"];
		
		_createInteractionPopoverController.delegate	= self;
		
	}
	
	return _createInteractionPopoverController;
	
}

- (void)presentCreateInteractionViewControllerInPopoverFromRect:(CGRect)rect withInteraction:(MHInteraction *)interaction andSelectedPeople:(NSArray *)selectedPeople {
	
	[self.createInteractionViewController updateWithInteraction:interaction andSelections:selectedPeople];
	self.createInteractionViewController.currentPopoverController = self.createInteractionPopoverController;
	
	[self.createInteractionPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}

- (MHLabelActivity *)labelActivity {
	
	if (_labelActivity == nil) {
		
		[self willChangeValueForKey:@"labelActivity"];
		_labelActivity = [[MHLabelActivity alloc] init];
		[self didChangeValueForKey:@"labelActivity"];
		_labelActivity.activityViewController	= self.activityViewController;
		
	}
	
	return _labelActivity;
	
}

- (MHProfileSurveysViewController *)surveysViewController {
	
	if (_surveysViewController == nil) {
		
		[self willChangeValueForKey:@"surveysViewController"];
		_surveysViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileSurveysViewController"];
		[self didChangeValueForKey:@"surveysViewController"];
		
	}
	
	return _surveysViewController;
	
}

- (MHActivityViewController *)activityViewController {
	
	if (_activityViewController == nil) {
		
		NSArray *activities							= [MHActivityViewController allActivities];
		NSArray *activityItems						= ( self.person ? @[self.person] : @[]);
		
		[self willChangeValueForKey:@"activityViewController"];
		_activityViewController						= [[MHActivityViewController alloc] initWithViewController:self activityItems:activityItems activities:activities];
		[self didChangeValueForKey:@"activityViewController"];
		
		_activityViewController.delegate			= self;
		_activityViewController.animateFromView		= (UIView *)self.navigationController.navigationBar;
		_activityViewController.animationPosition	= MHActivityViewControllerAnimationPositionBottom;
		_activityViewController.animationDirection	= MHActivityViewControllerAnimationDirectionDown;
		
	}
	
	return _activityViewController;
	
}

- (void)refresh {
	
	__weak __typeof(&*self)weakSelf = self;
	[self refreshInfoForPerson:self.person onCompletion:^{
		
		[weakSelf refreshInteractionsForPerson:weakSelf.person];
		
	}];
	
}

- (void)refreshInfoForPerson:(MHPerson *)person onCompletion:(void (^)(void))completionBlock {
	
	if (person.remoteID) {
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] getProfileForRemoteID:person.remoteID withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
			
			if ([[result objectAtIndex:0] isKindOfClass:[MHPerson class]]) {
				
				[weakSelf willChangeValueForKey:@"activityViewController"];
				_person = [result objectAtIndex:0];
				[weakSelf didChangeValueForKey:@"activityViewController"];
				[weakSelf updateInterfaceWithPerson:_person];
				
			}
			
			if (completionBlock) {
				
				completionBlock();
				
			}
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			NSString *errorMessage = [NSString stringWithFormat:@"Could not refresh %@\'s profile because: %@ If the problem continues please contact support@missionhub.com", weakSelf.person.fullName, error.localizedDescription];
			NSError *presentingError = [NSError errorWithDomain:error.domain
														   code:error.code
													   userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
			
			[MHErrorHandler presentError:presentingError];
			
			if (completionBlock) {
				
				completionBlock();
				
			}
			
		}];
		
	}
	
}

- (void)refreshSurveyAnswersForPerson:(MHPerson *)person {
	
	if (person.remoteID) {
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] getPersonWithSurveyAnswerSheetsForPersonWithRemoteID:person.remoteID
																withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
																	
																	if ([[result objectAtIndex:0] isKindOfClass:[MHPerson class]]) {
																		
																		MHPerson *profilePerson = [result objectAtIndex:0];
																		
																		[_person addAnswerSheets:profilePerson.answerSheets];
																		
																		[weakSelf updateInterfaceWithPerson:_person];
																		
																	}
																	
																} failBlock:^(NSError *error, MHRequestOptions *options) {
																	
																	NSString *errorMessage = [NSString stringWithFormat:@"Could not get Survey Answers for %@ because: %@ If the problem continues please contact support@missionhub.com", weakSelf.person.fullName, error.localizedDescription];
																	NSError *presentingError = [NSError errorWithDomain:error.domain
																												   code:error.code
																											   userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
																	
																	[MHErrorHandler presentError:presentingError];
																	
																}];
		
	}
	
}

- (void)refreshInteractionsForPerson:(MHPerson *)person {
	
	if (person.remoteID) {
	
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] getInteractionsForPersonWithRemoteID:person.remoteID
												withSuccessBlock:^(NSArray *resultArray, MHRequestOptions *options) {
													
													[[_person mutableSetValueForKey:@"createdInteractions"] removeAllObjects];
													[[_person mutableSetValueForKey:@"initiatedInteractions"] removeAllObjects];
													[[_person mutableSetValueForKey:@"receivedInteractions"] removeAllObjects];
													[[_person mutableSetValueForKey:@"updatedInteractions"] removeAllObjects];
													
													[resultArray enumerateObjectsUsingBlock:^(id resultObject, NSUInteger index, BOOL *stop) {
														
														if ([resultObject isKindOfClass:[MHInteraction class]]) {
															
															MHInteraction *interactionObject = (MHInteraction *)resultObject;
															
															if (interactionObject.receiver && [[interactionObject.receiver remoteID] isEqualToNumber:[_person remoteID]]) {
																
																[_person addReceivedInteractionsObject:interactionObject];
																
															}
															
															if (interactionObject.creator && [[interactionObject.creator remoteID] isEqualToNumber:[_person remoteID]]) {
																
																[_person addCreatedInteractionsObject:interactionObject];
																
															}
															
															if (interactionObject.initiators && [interactionObject.initiators findWithRemoteID:[_person remoteID]]) {
																
																[_person addInitiatedInteractionsObject:interactionObject];
																
															}
															
															if (interactionObject.updater && [[interactionObject.updater remoteID] isEqualToNumber:[_person remoteID]]) {
																
																[_person addUpdatedInteractionsObject:interactionObject];
																
															}
															
														}
														
													}];
													
													[weakSelf updateInterfaceWithPerson:_person];
													
												}
													   failBlock:^(NSError *error, MHRequestOptions *options) {
														   
														   NSString *errorMessage = [NSString stringWithFormat:@"Could not get Interactions for %@ because: %@ If the problem continues please contact support@missionhub.com", weakSelf.person.fullName, error.localizedDescription];
														   NSError *presentingError = [NSError errorWithDomain:error.domain
																										  code:error.code
																									  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
														   
														   [MHErrorHandler presentError:presentingError];
														   
													   }];
		
	}
	
}

- (void)setPerson:(MHPerson *)person {
	
	if (person) {
		
		[self willChangeValueForKey:@"person"];
		_person = person;
		[self didChangeValueForKey:@"person"];
		
		[self updateInterfaceWithPerson:_person];
		
		[self refreshSurveyAnswersForPerson:_person];
		[self refreshInteractionsForPerson:_person];
		
	}
	
}

#pragma mark - button selectors

- (void)backToMenu:(id)sender {
	
    [self.navigationController popViewControllerAnimated:YES];
	
}

- (void)newInteractionActivity:(id)sender {
	
	MHInteraction *newInteraction	= [MHInteraction newObjectFromFields:nil];
	newInteraction.receiver			= self.person;
	NSArray *selectionArray			= (self.person ? @[self.person] : @[]);
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		
		[self.createInteractionViewController updateWithInteraction:newInteraction andSelections:selectionArray];
		[self.navigationController pushViewController:self.createInteractionViewController animated:YES];
		
	} else {
		
		CGRect rect		= ((UIView *)sender).frame;
		rect.origin.y	= 0;
		
		[self presentCreateInteractionViewControllerInPopoverFromRect:rect withInteraction:newInteraction andSelectedPeople:selectionArray];
		
	}
	
}

- (void)addLabelActivity:(id)sender {

	[self.labelActivity prepareWithActivityItems:@[self.person]];
	[self.labelActivity performActivity];
	
}

- (void)otherOptionsActivity:(id)sender {
	
	if (self.activityViewController.parentViewController) {
		
		[self.activityViewController dismissViewControllerAnimated:YES completion:nil];
		
	} else {
		
		NSArray *activityItems						= ( self.person ? @[self.person] : @[]);
		
		self.activityViewController.activityItems	= activityItems;
		
		[self.activityViewController presentFromViewController:self];
		
	}
	
}

#pragma mark - delegate methods

- (void)menuDidChangeSelection:(NSInteger)selection {
	
	[self switchTableViewController:[self.allViewControllers objectAtIndex:selection]];
	[[self currentTableViewContoller] setPerson:self.person];
	
}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

- (void)willChangeHeightOfTopViewControllerFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
	
	[[self headerViewController] updateLayout];
	
}

#pragma mark - UIPopover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	
	
	
}

#pragma mark - MHActivityViewControllerDelegate

- (void)activityDidFinish:(NSString *)activityType completed:(BOOL)completed {
	
	if (completed) {
	
		if ([activityType isEqualToString:MHActivityTypeArchive] ) {
			
			[[NSNotificationCenter defaultCenter] postNotificationName:MHProfileViewControllerNotificationPersonArchived object:self];
			[self.navigationController popViewControllerAnimated:YES];
			
		} else if ([activityType isEqualToString:MHActivityTypeDelete] ) {
			
			[[NSNotificationCenter defaultCenter] postNotificationName:MHProfileViewControllerNotificationPersonDeleted object:self];
			[self.navigationController popViewControllerAnimated:YES];
			
		} else if ([activityType isEqualToString:MHActivityTypeAssign] ||
				   [activityType isEqualToString:MHActivityTypeLabel] ||
				   [activityType isEqualToString:MHActivityTypePermissions]) {
			
			[[NSNotificationCenter defaultCenter] postNotificationName:MHProfileViewControllerNotificationPersonUpdated object:self];
			[self refreshInfoForPerson:self.person onCompletion:nil];
			
		}
		
	}
	
}

#pragma mark - layout methods

- (void)updateInterfaceWithPerson:(MHPerson *)person {
	
	[[self headerViewController] setPerson:person];
	[[self currentTableViewContoller] setPerson:person];
	
}

- (void)updateLayoutWithFrame:(CGRect)frame {
	
	self.headerViewController.view.frame = CGRectMake(CGRectGetMinX(self.headerViewController.view.frame),
													  CGRectGetMinY(self.headerViewController.view.frame),
													  CGRectGetWidth(frame),
													  MHProfileHeaderHeight);
	[self.headerViewController updateLayout];
	
	self.menuViewController.view.frame	= CGRectMake(CGRectGetMinX(self.menuViewController.view.frame),
													 CGRectGetMinY(self.menuViewController.view.frame),
													 CGRectGetWidth(frame),
													 CGRectGetHeight(self.menuViewController.view.frame));
	[self.menuViewController updateLayout];
	
}

- (void)updateBarButtons {
	
	[self.navigationItem setRightBarButtonItems:@[
	 [MHToolbar barButtonWithStyle:MHToolbarStyleMore target:self selector:@selector(otherOptionsActivity:) forBar:self.navigationController.navigationBar],
	 [MHToolbar barButtonWithStyle:MHToolbarStyleLabel target:self selector:@selector(addLabelActivity:) forBar:self.navigationController.navigationBar],
	 [MHToolbar barButtonWithStyle:MHToolbarStyleCreateInteraction target:self selector:@selector(newInteractionActivity:) forBar:self.navigationController.navigationBar]
	 ]];
	
    self.navigationItem.leftBarButtonItem = [MHToolbar barButtonWithStyle:MHToolbarStyleBack target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
	
}

- (NSUInteger)supportedInterfaceOrientations {
	
    return UIInterfaceOrientationMaskAll;
	
}

- (BOOL)shouldAutorotate {
	
    return YES;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	
    return YES;
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self updateBarButtons];
	[self updateLayoutWithFrame:self.view.frame];
	
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
