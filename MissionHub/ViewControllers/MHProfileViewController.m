//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileViewController.h"
//#import "MHNewInteractionViewController.h"
//#import "MHCustomNavigationBar.h"


@interface MHProfileViewController ()

@property (nonatomic, strong) NSArray								*allViewControllers;
@property (nonatomic, strong) UIViewController						*currentViewController;
@property (nonatomic, strong) MHPerson								*_person;
@property (nonatomic, strong) NSMutableArray						*_interactionArray;

@property (nonatomic, strong) MHNewInteractionViewController		*_createInteractionViewController;
@property (nonatomic, strong) MHProfileHeaderViewController			*_headerViewController;
@property (nonatomic, strong) MHProfileMenuViewController			*_menuViewController;
@property (nonatomic, strong) MHProfileInfoViewController			*_infoViewController;
@property (nonatomic, strong) MHProfileInteractionsViewController	*_interactionsViewController;
@property (nonatomic, strong) MHGenericListViewController			*_labelViewController;
@property (nonatomic, strong) MHProfileSurveysViewController		*_surveysViewController;

-(MHNewInteractionViewController *)createInteractionViewController;
-(MHProfileHeaderViewController *)headerViewController;
-(MHProfileMenuViewController *)menuViewController;
-(MHProfileInfoViewController *)infoViewController;
-(MHProfileInteractionsViewController *)interactionsViewController;
-(MHProfileSurveysViewController *)surveysViewController;


@end


@implementation MHProfileViewController

@synthesize toolbar, table;
@synthesize _person;
//@synthesize addLabelButton, addTagButton, backMenuButton;
//@synthesize menu;
@synthesize _interactionArray;

@synthesize actionBar;

-(void) awakeFromNib
{
	// Add A and B view controllers to the array
    self.allViewControllers = @[[self infoViewController], [self interactionsViewController], [self surveysViewController]];
	
    [[self menuViewController] setMenuSelection:0];
	[[self menuViewController] setMenuDelegate:self];
	
	[self setupWithTopViewController:[self headerViewController]
							  height:150
				 tableViewController:[self infoViewController]
			 segmentedViewController:[self menuViewController]];
	
	self._person = [MHAPI sharedInstance].currentUser;
	self._interactionArray = [NSMutableArray array];
    
	self.actionBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"actionbar.png"]];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    UIImage* newInteractionImage = [UIImage imageNamed:@"NewInteraction_Icon.png"];
    UIButton *newInteraction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [newInteraction setImage:newInteractionImage forState:UIControlStateNormal];
    [newInteraction addTarget:self action:@selector(newInteractionActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newInteractionButton = [[UIBarButtonItem alloc] initWithCustomView:newInteraction];
    
    UIImage* labelImage = [UIImage imageNamed:@"topbarTag_button.png"];
    UIButton *newLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [newLabel setImage:labelImage forState:UIControlStateNormal];
    [newLabel addTarget:self action:@selector(addLabelActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addLabelButton = [[UIBarButtonItem alloc] initWithCustomView:newLabel];
    
    UIImage* otherOptionImage = [UIImage imageNamed:@"topbarOtherOptions_button.png"];
    UIButton *otherOptions = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [otherOptions setImage:otherOptionImage forState:UIControlStateNormal];
    [otherOptions addTarget:self action:@selector(addTagActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *otherOptionsButton = [[UIBarButtonItem alloc] initWithCustomView:otherOptions];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:otherOptionsButton, addLabelButton, newInteractionButton, nil]];
    
    
    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    
    [self.toolbar setTranslucent:YES];

}

-(id<MHProfileProtocol>)currentTableViewContoller {
	
	return [self.allViewControllers objectAtIndex:[[self menuViewController] menuSelection]];
}

-(MHNewInteractionViewController *)createInteractionViewController {
	
	if (self._createInteractionViewController == nil) {
		
		self._createInteractionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNewInteractionViewController"];
		
	}
	
	return self._createInteractionViewController;
	
}

-(MHProfileHeaderViewController *)headerViewController {
	
	if (self._headerViewController == nil) {
		
		self._headerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileHeaderViewController"];
		
	}
	
	return self._headerViewController;
	
}

-(MHProfileMenuViewController *)menuViewController {
	
	if (self._menuViewController == nil) {
		
		self._menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileMenuViewController"];
		
	}
	
	return self._menuViewController;
	
}

-(MHProfileInfoViewController *)infoViewController {
	
	if (self._infoViewController == nil) {
		
		self._infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileInfoViewController"];
		
	}
	
	return self._infoViewController;
	
}

-(MHProfileInteractionsViewController *)interactionsViewController {
	
	if (self._interactionsViewController == nil) {
		
		self._interactionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileInteractionsViewController"];
		
	}
	
	return self._interactionsViewController;
	
}

-(MHGenericListViewController *)labelViewController {
	
	if (self._labelViewController == nil) {
		
		self._labelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		
	}
	
	return self._labelViewController;
	
}

-(MHProfileSurveysViewController *)surveysViewController {
	
	if (self._surveysViewController == nil) {
		
		self._surveysViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileSurveysViewController"];
		
	}
	
	return self._surveysViewController;
	
}

-(void)setPerson:(MHPerson *)person {
	
	if (person) {
		
		self._person = person;
		[self refreshProfile];
		
		[[MHAPI sharedInstance] getInteractionsForPersonWithRemoteID:person.remoteID
													withSuccessBlock:^(NSArray *resultArray, MHRequestOptions *options) {
														
														[self._interactionArray removeAllObjects];
														[[self._person mutableSetValueForKey:@"createdInteractions"] removeAllObjects];
														[[self._person mutableSetValueForKey:@"initiatedInteractions"] removeAllObjects];
														[[self._person mutableSetValueForKey:@"receivedInteractions"] removeAllObjects];
														[[self._person mutableSetValueForKey:@"updatedInteractions"] removeAllObjects];
														
														[resultArray enumerateObjectsUsingBlock:^(id resultObject, NSUInteger index, BOOL *stop) {
															
															if ([resultObject isKindOfClass:[MHInteraction class]]) {
																
																MHInteraction *interactionObject = (MHInteraction *)resultObject;
																
																if (interactionObject.receiver && [[interactionObject.receiver remoteID] isEqualToNumber:[self._person remoteID]]) {
																	
																	[self._person addReceivedInteractionsObject:interactionObject];
																	
																}
																
																if (interactionObject.creator && [[interactionObject.creator remoteID] isEqualToNumber:[self._person remoteID]]) {
																	
																	[self._person addCreatedInteractionsObject:interactionObject];
																	
																}
																
																if (interactionObject.initiators && [interactionObject.initiators findWithRemoteID:[self._person remoteID]]) {
																	
																	[self._person addInitiatedInteractionsObject:interactionObject];
																	
																}
																
																if (interactionObject.updater && [[interactionObject.updater remoteID] isEqualToNumber:[self._person remoteID]]) {
																	
																	[self._person addUpdatedInteractionsObject:interactionObject];
																	
																}
																
																[self._interactionArray addObject:interactionObject];
																
															}
															
														}];
														
														[self refreshProfile];
			
		}
														   failBlock:^(NSError *error, MHRequestOptions *options) {
															   
															   [MHErrorHandler presentError:error];
			
		}];
		
	}
	
}

-(void)refreshProfile {
	
	[[self headerViewController] setPerson:self._person];
	//[[self currentTableViewContoller] setPerson:self._person];
	
}

-(void)willChangeHeightOfTopViewControllerFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
	
	[[self headerViewController] resetLabelListSize];
	
}

-(void)menuDidChangeSelection:(NSInteger)selection {
	
	[self switchTableViewController:[self.allViewControllers objectAtIndex:selection]];
	
}

- (IBAction)backToMenu:(id)sender {
	
    [self.navigationController popViewControllerAnimated:YES];
	
 }

- (IBAction)addLabelActivity:(id)sender {

	[self labelViewController].selectionDelegate = self;
	[self labelViewController].objectArray = [NSMutableArray arrayWithArray:[[MHAPI sharedInstance].currentUser.currentOrganization.labels allObjects]];
	[self presentViewController:[self labelViewController] animated:YES completion:nil];
	
}

-(IBAction)addTagActivity:(id)sender {
	
	if (![self.actionBar superview]) {
		
		self.actionBar.frame = CGRectMake(0, CGRectGetMinY(self.view.frame) - 118, CGRectGetWidth(self.view.frame), 118);
		[self.view addSubview:self.actionBar];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
		
		self.actionBar.frame		= CGRectMake(0, CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), 118);
		
		[UIView commitAnimations];
		
	} else {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
		
		self.actionBar.frame		= CGRectMake(0, CGRectGetMaxY(self.view.frame) - 118, CGRectGetWidth(self.view.frame), 118);
		
		[UIView commitAnimations];
		
		[self.actionBar removeFromSuperview];
		
	}
	
}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

- (IBAction)newInteractionActivity:(id)sender {
NSLog(@"Interaction Action");
	[self.navigationController pushViewController:[self createInteractionViewController] animated:YES];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
