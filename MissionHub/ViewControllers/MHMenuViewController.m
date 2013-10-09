//
//  MHMenuViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHMenuViewController.h"
#import "MHNavigationViewController.h"
#import "MHPeopleListViewController.h"
#import "MHSurveyViewController.h"
#import "MHAPI.h"
#import "MHLabel.h"
#import "MHPerson+Helper.h"
#import "MHSurvey.h"
#import "NSMutableArray+removeDuplicatesForKey.h"
#import "MHGenericListViewController.h"

@interface MHMenuViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) MHNavigationViewController *peopleNavigationViewController;
@property (nonatomic, strong, readonly) MHSurveyViewController *surveyViewController;
@property (nonatomic, strong, readonly) MHGenericListViewController *organizationViewController;
//@property (nonatomic, strong) MHPerson *user;
@property (nonatomic, strong) NSArray *menuHeaders;
@property (nonatomic, strong) NSMutableArray *menuItems;

- (void)updateMenuArrays;
- (void)changeOrganization;
- (void)logout;

@end

@implementation MHMenuViewController

@synthesize currentOrganization				= _currentOrganization;

@synthesize tableView						= _tableView;
@synthesize peopleNavigationViewController	= _peopleNavigationViewController;
@synthesize surveyViewController			= _surveyViewController;
@synthesize organizationViewController		= _organizationViewController;
//@synthesize user							= _user;
@synthesize menuHeaders						= _menuHeaders;
@synthesize menuItems						= _menuItems;

-(MHNavigationViewController *)peopleNavigationViewController {
	
	if (_peopleNavigationViewController == nil) {
		
		[self willChangeValueForKey:@"peopleNavigationViewController"];
		_peopleNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNavigationViewController"];
		[self didChangeValueForKey:@"peopleNavigationViewController"];
		
	}
	
	return _peopleNavigationViewController;
	
}

-(MHSurveyViewController *)surveyViewController {
	
	if (_surveyViewController == nil) {
		
		[self willChangeValueForKey:@"surveyViewController"];
		_surveyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHSurveyViewController"];
		[self didChangeValueForKey:@"surveyViewController"];
		
	}
	
	return _surveyViewController;
	
}

-(MHGenericListViewController *)organizationViewController {
	
	if (_organizationViewController == nil) {
		
		[self willChangeValueForKey:@"organizationViewController"];
		_organizationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"organizationViewController"];
		
	}
	
	return _organizationViewController;
	
}

-(void)changeOrganization {
	
	NSLog(@"change org");
//	self.organizationViewController.selectionDelegate = self;
//	self.organizationViewController.objectArray = [NSMutableArray arrayWithArray:[self.user.allOrganizations allObjects]];
//	[self presentViewController:self.organizationViewController animated:YES completion:nil];
	
}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

-(void)logout {
	
	NSLog(@"logout");
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
	
	self.menuHeaders	= @[@"", @"LABELS", @"CONTACT ASSIGNMENTS", @"SURVEYS", @"SETTINGS"];
	self.menuItems		= [NSMutableArray arrayWithArray:@[@[@"ALL CONTACTS"],@[@"Loading..."],@[@"Loading..."],@[@"Loading..."],@[@"CHANGE ORGANIZATION", @"LOG OUT"]]];
	
	if ([MHAPI sharedInstance].currentOrganization) {
		
		self.currentOrganization	= [MHAPI sharedInstance].currentOrganization;
		//[self setCurrentUser:[MHAPI sharedInstance].currentUser];
		
	}
	
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	self.slidingViewController.underLeftWidthLayout = ECFullWidth;
	
	self.tableView.frame	= self.view.bounds;
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	self.tableView.frame	= self.view.bounds;
	
}

-(void)setCurrentOrganization:(MHOrganization *)currentOrganization {
	
	[self willChangeValueForKey:@"currentOrganization"];
	_currentOrganization	= currentOrganization;
	[self didChangeValueForKey:@"currentOrganization"];
	
	[_currentOrganization addObserver:self
						   forKeyPath:@"admins"
							  options:NSKeyValueObservingOptionNew
							  context:nil];
	[_currentOrganization addObserver:self
						   forKeyPath:@"countOfAdmins"
							  options:NSKeyValueObservingOptionNew
							  context:nil];
	[_currentOrganization addObserver:self
						   forKeyPath:@"users"
							  options:NSKeyValueObservingOptionNew
							  context:nil];
	[_currentOrganization addObserver:self
						   forKeyPath:@"countOfUsers"
							  options:NSKeyValueObservingOptionNew
							  context:nil];
	
	[self updateMenuArrays];
	
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"admins"] || [keyPath isEqualToString:@"users"] || [keyPath isEqualToString:@"countOfAdmins"] || [keyPath isEqualToString:@"countOfUsers"]) {
		
		[self updateMenuArrays];
		
	}
	
}

- (void)updateMenuArrays {
	
	//setup labels array
	if (_currentOrganization.labels) {
		
		NSArray *labelArray = [_currentOrganization.labels.allObjects
							   sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
																						   ascending:YES
																							selector:@selector(caseInsensitiveCompare:)]]];
		
		[self.menuItems replaceObjectAtIndex:1 withObject:labelArray];
		
	} else {
		
		[self.menuItems replaceObjectAtIndex:1 withObject:@[]];
		
	}
	
	//setup contact assignments array
	NSArray *adminArray = @[];
	NSArray *userArray = @[];
	
	if (_currentOrganization.admins) {
		
		adminArray = _currentOrganization.admins.allObjects;
		
	}
	
	if (_currentOrganization.users) {
		
		userArray = _currentOrganization.users.allObjects;
		
	}
	
	NSMutableArray *contactAssignmentsArray = [NSMutableArray arrayWithArray:adminArray];
	[contactAssignmentsArray addObjectsFromArray:userArray];
	contactAssignmentsArray = [contactAssignmentsArray arrayWithDuplicatesRemovedForKey:@"remoteID"];
	
	[self.menuItems replaceObjectAtIndex:2 withObject:[contactAssignmentsArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]]];
	
	//setup survey array
	if (_currentOrganization.surveys) {
		
		NSArray *surveyArray = [_currentOrganization.surveys.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
		
		[self.menuItems replaceObjectAtIndex:3 withObject:surveyArray];
		
	} else {
		
		[self.menuItems replaceObjectAtIndex:3 withObject:@[]];
		
	}
	
}

//-(id)setCurrentUser:(MHPerson *)currentUser {
//	
//	self.user = currentUser;
//	
//	//setup labels array
//	if (currentUser.currentOrganization.labels) {
//		
//		NSArray *labelArray = [[currentUser.currentOrganization.labels allObjects]
//							   sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
//																						   ascending:YES
//																							selector:@selector(caseInsensitiveCompare:)]]];
//		
//		[self.menuItems replaceObjectAtIndex:1 withObject:labelArray];
//		
//	} else {
//		
//		[self.menuItems replaceObjectAtIndex:1 withObject:@[]];
//		
//	}
//	
//	//setup contact assignments array
//	NSArray *adminArray = @[];
//	NSArray *userArray = @[];
//	
//	if (currentUser.currentOrganization.admins) {
//		
//		adminArray = [currentUser.currentOrganization.admins allObjects];
//		
//	}
//	
//	if (currentUser.currentOrganization.users) {
//		
//		userArray = [currentUser.currentOrganization.users allObjects];
//		
//	}
//	
//	NSMutableArray *contactAssignmentsArray = [NSMutableArray arrayWithArray:adminArray];
//	[contactAssignmentsArray addObjectsFromArray:userArray];
//	contactAssignmentsArray = [contactAssignmentsArray arrayWithDuplicatesRemovedForKey:@"remoteID"];
//	
//	[self.menuItems replaceObjectAtIndex:2 withObject:[contactAssignmentsArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"first_name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]]];
//	
//	//setup survey array
//	if (currentUser.currentOrganization.surveys) {
//		
//		NSArray *surveyArray = [[currentUser.currentOrganization.surveys allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
//		
//		[self.menuItems replaceObjectAtIndex:3 withObject:surveyArray];
//		
//	} else {
//		
//		[self.menuItems replaceObjectAtIndex:3 withObject:@[]];
//		
//	}
//	
//	return self;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.menuHeaders count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
	
	header.backgroundColor	= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	header.text				= [self.menuHeaders objectAtIndex:section];
	header.textColor		= [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0];
	header.font				= [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	
	return header;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.menuItems objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//create cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	//configure cell
	cell.textLabel.textColor    = [UIColor colorWithRed:(192.0/255.0) green:(192.0/255.0) blue:(192.0/255.0) alpha:1.0];
	cell.textLabel.font         = [UIFont fontWithName:@"ArialRoundedMTBold" size:14.0];
	cell.selectionStyle			= UITableViewCellSelectionStyleGray;
	
	//set cell value
	id objectForCell = [[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	//grab the cell's text value based on the type of the object that was retreived
	if ([objectForCell isKindOfClass:[NSString class]]) {
		
		cell.textLabel.text = objectForCell;
		
	} else if ([objectForCell isKindOfClass:[MHLabel class]]) {
		
		cell.textLabel.text = ((MHLabel *)objectForCell).name;
		
	} else if ([objectForCell isKindOfClass:[MHPerson class]]) {
		
		cell.textLabel.text = [((MHPerson *)objectForCell) fullName];
		
	} else if ([objectForCell isKindOfClass:[MHSurvey class]]) {
		
		cell.textLabel.text = ((MHSurvey *)objectForCell).title;
		
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	//filters
	if (indexPath.section >= 0 && indexPath.section < 4) {
		
		UIViewController *newTopViewController;
		id objectForIndex = [[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		
		//surveys
		if (indexPath.section == 3) {
			
			if ([objectForIndex isKindOfClass:[MHSurvey class]]) {
				
				newTopViewController = [self surveyViewController];
				[(MHSurveyViewController *)newTopViewController displaySurvey:objectForIndex];
				
			}
			
		} else {
			
			newTopViewController = [self peopleNavigationViewController];
			MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
			
			//All Contacts
			if (indexPath.section == 0) {
				
				[requestOptions configureForInitialPeoplePageRequest];
				
			//Labels
			} else if (indexPath.section == 1) {
				
				[requestOptions configureForInitialPeoplePageRequest];
				if ([objectForIndex isKindOfClass:[MHLabel class]]) {
					[requestOptions addFilter:MHRequestOptionsFilterPeopleLabels withValue:[((MHLabel *)objectForIndex).remoteID stringValue]];
				}
				
			//contact assignments
			} else if (indexPath.section == 2) {
				
				[requestOptions configureForInitialPeoplePageRequest];
				if ([objectForIndex isKindOfClass:[MHPerson class]]) {
					[requestOptions configureForInitialPeoplePageRequestWithAssignedToID:
					 ((MHPerson *)objectForIndex).remoteID];
				}
				
			}
			
			[(MHNavigationViewController *)newTopViewController setDataFromRequestOptions:requestOptions];
			
		}
		
		if (newTopViewController) {
			
			[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
				CGRect frame = self.slidingViewController.topViewController.view.frame;
				self.slidingViewController.topViewController = newTopViewController;
				self.slidingViewController.topViewController.view.frame = frame;
				[self.slidingViewController resetTopView];
			}];
			
		}
		
	}
	
	//settings
	if (indexPath.section == 4) {
		
		if (indexPath.row == 0) {
			
			[self changeOrganization];
			
		} else if (indexPath.row == 1) {
			
			[self logout];
			
		}
		
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - orientation methods

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
	
	self.tableView.frame	= self.view.bounds;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
