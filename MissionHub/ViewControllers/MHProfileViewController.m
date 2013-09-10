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

CGFloat const MHProfileNavigationBarButtonMarginVertical = 5.0f;

@interface MHProfileViewController ()

@property (nonatomic, strong) NSArray										*allViewControllers;
@property (nonatomic, strong) UIViewController								*currentViewController;

@property (nonatomic, strong, readonly) MHNewInteractionViewController		*createInteractionViewController;
@property (nonatomic, strong, readonly) MHProfileHeaderViewController		*headerViewController;
@property (nonatomic, strong, readonly) MHProfileMenuViewController			*menuViewController;
@property (nonatomic, strong, readonly) MHProfileInfoViewController			*infoViewController;
@property (nonatomic, strong, readonly) MHProfileInteractionsViewController	*interactionsViewController;
@property (nonatomic, strong, readonly) MHGenericListViewController			*labelViewController;
@property (nonatomic, strong, readonly) MHProfileSurveysViewController		*surveysViewController;

- (void)backToMenu:(id)sender;
- (void)newInteractionActivity:(id)sender;
- (void)addLabelActivity:(id)sender;
- (void)otherOptionsActivity:(id)sender;

- (void)updateBarButtons;

@end


@implementation MHProfileViewController

@synthesize person							= _person;
@synthesize allViewControllers				= _allViewControllers;
@synthesize currentViewController			= _currentViewController;
@synthesize createInteractionViewController	= _createInteractionViewController;
@synthesize headerViewController			= _headerViewController;
@synthesize menuViewController				= _menuViewController;
@synthesize infoViewController				= _infoViewController;
@synthesize interactionsViewController		= _interactionsViewController;
@synthesize labelViewController				= _labelViewController;
@synthesize surveysViewController			= _surveysViewController;

#pragma mark - intialization methods

- (void) awakeFromNib
{
	// Add A and B view controllers to the array
    self.allViewControllers = @[[self infoViewController],[self interactionsViewController], [self surveysViewController]];
	
    [[self menuViewController] setMenuSelection:0];
	[[self menuViewController] setMenuDelegate:self];
	
	[self setupWithTopViewController:[self headerViewController]
							  height:150
				 tableViewController:(UITableViewController *)[self currentTableViewContoller]
			 segmentedViewController:[self menuViewController]];
	
	[self willChangeValueForKey:@"person"];
	_person = [MHAPI sharedInstance].currentUser;
	[self didChangeValueForKey:@"person"];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//[self updateBarButtons];

}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[self updateBarButtons];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[[self menuViewController] setMenuSelection:0];
}

#pragma mark - accessor methods

- (id<MHProfileProtocol>)currentTableViewContoller {
	
	return [self.allViewControllers objectAtIndex:[[self menuViewController] menuSelection]];
}

- (MHNewInteractionViewController *)createInteractionViewController {
	
	if (_createInteractionViewController == nil) {
		
		[self willChangeValueForKey:@"createInteractionViewController"];
		_createInteractionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNewInteractionViewController"];
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

- (MHGenericListViewController *)labelViewController {
	
	if (_labelViewController == nil) {
		
		[self willChangeValueForKey:@"labelViewController"];
		_labelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"labelViewController"];
		
	}
	
	return _labelViewController;
	
}

- (MHProfileSurveysViewController *)surveysViewController {
	
	if (_surveysViewController == nil) {
		
		[self willChangeValueForKey:@"surveysViewController"];
		_surveysViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileSurveysViewController"];
		[self didChangeValueForKey:@"surveysViewController"];
		
	}
	
	return _surveysViewController;
	
}

- (void)setPerson:(MHPerson *)person {
	
	if (person) {
		
		[self willChangeValueForKey:@"person"];
		_person = person;
		[self didChangeValueForKey:@"person"];
		[self refresh];
		
		[[MHAPI sharedInstance] getPersonWithSurveyAnswerSheetsForPersonWithRemoteID:person.remoteID
													withSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
														
														if ([[result objectAtIndex:0] isKindOfClass:[MHPerson class]]) {
															
															MHPerson *profilePerson = [result objectAtIndex:0];
															
															[_person addAnswerSheets:profilePerson.answerSheets];
															
														}
														
													} failBlock:^(NSError *error, MHRequestOptions *options) {
														
														[MHErrorHandler presentError:error];
														
													}];
		
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
														
														[self refresh];
			
		}
														   failBlock:^(NSError *error, MHRequestOptions *options) {
															   
															   [MHErrorHandler presentError:error];
			
		}];
		
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
	
	[[self createInteractionViewController] updateWithInteraction:newInteraction andSelections:selectionArray]; //create selected array
	[self.navigationController pushViewController:[self createInteractionViewController] animated:YES];
    
	
}

- (void)addLabelActivity:(id)sender {

	[self labelViewController].selectionDelegate = self;
	[self labelViewController].objectArray = [NSMutableArray arrayWithArray:[[MHAPI sharedInstance].currentUser.currentOrganization.labels allObjects]];
	[self presentViewController:[self labelViewController] animated:YES completion:nil];
	
}


//TODO:Need to add action bar when the otherOptions button is pressed

- (void)otherOptionsActivity:(id)sender {
	
	
	
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

#pragma mark - layout methods

- (void)refresh {
	
	[[self headerViewController] setPerson:self.person];
	[[self currentTableViewContoller] setPerson:self.person];
	
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
	
	[self updateBarButtons];
	
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
