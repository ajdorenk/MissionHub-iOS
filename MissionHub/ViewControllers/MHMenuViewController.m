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
#import "MHLoginViewController.h"
#import "MHIntroductionViewController.h"
#import "MHGoogleAnalyticsTracker.h"
#import "ABNotifier.h"
#import "MHLocationManager.h"


NSString *const MHMenuErrorDomain												= @"com.missionhub.errorDomain.menu";

NSString *const MHGoogleAnalyticsTrackerMenuScreenName							= @"Menu";
NSString *const MHGoogleAnalyticsTrackerChangeOrganizationScreenName			= @"Change Organization";
NSString *const MHGoogleAnalyticsTrackerChangeOrganizationOrganizationCellTap	= @"organization";
NSString *const MHGoogleAnalyticsTrackerMenuAllContactsCellTap					= @"all_contacts";
NSString *const MHGoogleAnalyticsTrackerMenuSurveyCellTap						= @"survey";
NSString *const MHGoogleAnalyticsTrackerMenuLabelCellTap						= @"label";
NSString *const MHGoogleAnalyticsTrackerMenuContactAssignmentCellTap			= @"contact_assignment";
NSString *const MHGoogleAnalyticsTrackerMenuHelpCellTap							= @"help";
NSString *const MHGoogleAnalyticsTrackerMenuChangeOrganizationCellTap			= @"change_organization";
NSString *const MHGoogleAnalyticsTrackerMenuLogoutCellTap						= @"logout";


typedef enum {
	MHMenuErrorMenuLoading,
	MHMenuErrorChangeOrganizationFailed
} MHMenuError;

@interface MHMenuViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) MHNavigationViewController *peopleNavigationViewController;
@property (nonatomic, strong, readonly) MHSurveyViewController *surveyViewController;
@property (nonatomic, strong, readonly) MHGenericListViewController *organizationViewController;
@property (nonatomic, strong) NSArray *menuHeaders;
@property (nonatomic, strong) NSMutableArray *menuItems;

- (void)updateMenuArrays;
- (void)help;
- (void)changeOrganization;
- (void)logout;

@end

@implementation MHMenuViewController

@synthesize currentOrganization				= _currentOrganization;

@synthesize tableView						= _tableView;
@synthesize peopleNavigationViewController	= _peopleNavigationViewController;
@synthesize surveyViewController			= _surveyViewController;
@synthesize organizationViewController		= _organizationViewController;
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
		
		_organizationViewController.selectionDelegate	= self;
		_organizationViewController.multipleSelection	= NO;
		_organizationViewController.showSuggestions		= NO;
		_organizationViewController.showHeaders			= NO;
		_organizationViewController.listTitle			= @"Organization(s)";
		NSArray *sortedArray							= [MHAPI sharedInstance].currentUser.allOrganizations.allObjects;
		sortedArray										= [sortedArray sortedArrayUsingDescriptors:@[
																									 [NSSortDescriptor
																									  sortDescriptorWithKey:@"name"
																									  ascending:YES
																									  selector:@selector(caseInsensitiveCompare:)]
																									 ]];
		[_organizationViewController setDataArray:sortedArray];
		[_organizationViewController setSuggestions:nil andSelectionObject:self.currentOrganization];
		
	}
	
	return _organizationViewController;
	
}

- (void)help {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MHIntroductionViewControllerShow object:self];
	
}

-(void)changeOrganization {
	
	NSArray *sortedArray							= [MHAPI sharedInstance].currentUser.allOrganizations.allObjects;
	sortedArray										= [sortedArray sortedArrayUsingDescriptors:@[
																								 [NSSortDescriptor
																								  sortDescriptorWithKey:@"name"
																								  ascending:YES
																								  selector:@selector(caseInsensitiveCompare:)]
																								 ]];
	[self.organizationViewController setDataArray:sortedArray];
	[self.organizationViewController setSuggestions:nil andSelectionObject:self.currentOrganization];
	[self presentViewController:self.organizationViewController animated:YES completion:nil];
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerChangeOrganizationScreenName];
	
}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	//change org
	if ([object isKindOfClass:[MHOrganization class]]) {
		
		self.tableView.contentOffset	= CGPointZero;
		
		__block MHOrganization *oldOrganization	= self.currentOrganization;
		
		self.currentOrganization		= nil;
		
		MHOrganization *organization	= (MHOrganization *)object;
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerChangeOrganizationScreenName
																  category:MHGoogleAnalyticsCategoryCell
																	action:MHGoogleAnalyticsActionTap
																	 label:MHGoogleAnalyticsTrackerChangeOrganizationOrganizationCellTap
																	 value:nil];
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] getOrganizationWithRemoteID:organization.remoteID successBlock:^(NSArray *result, MHRequestOptions *options) {
			
			MHOrganization *organization = [result objectAtIndex:0];
			
			[[MHAPI sharedInstance].initialPeopleList removeAllObjects];
			[MHAPI sharedInstance].currentOrganization				= organization;
			[MHAPI sharedInstance].currentUser.currentOrganization	= organization; //depreciated, use [MHAPI sharedInstance].currentOrganization instead
			
			[ABNotifier setEnvironmentValue:[[MHAPI sharedInstance].currentOrganization.remoteID stringValue] forKey:@"organization_id"];
			
			[weakSelf.tableView reloadData];
			
			[[MHAPI sharedInstance] getPeopleListWith:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest] successBlock:^(NSArray *result, MHRequestOptions *options) {
				
				NSArray *peopleList	= ( result ? result : @[] );
				
				[[MHAPI sharedInstance].initialPeopleList addObjectsFromArray:peopleList];
				[weakSelf.peopleNavigationViewController setDataArray:[MHAPI sharedInstance].initialPeopleList forRequestOptions:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]];
				
				[weakSelf.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
					CGRect frame = weakSelf.slidingViewController.topViewController.view.frame;
					weakSelf.slidingViewController.topViewController = weakSelf.peopleNavigationViewController;
					weakSelf.slidingViewController.topViewController.view.frame = frame;
					[weakSelf.slidingViewController resetTopView];
				}];
				
			} failBlock:^(NSError *error, MHRequestOptions *options) {
				
				[weakSelf.peopleNavigationViewController setDataFromRequestOptions:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]];
				
				[weakSelf.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
					CGRect frame = weakSelf.slidingViewController.topViewController.view.frame;
					weakSelf.slidingViewController.topViewController = weakSelf.peopleNavigationViewController;
					weakSelf.slidingViewController.topViewController.view.frame = frame;
					[weakSelf.slidingViewController resetTopView];
				}];
				
			}];
			
		} failBlock:^(NSError *error, MHRequestOptions *options) {
			
			NSString *errorMessage		= [NSString stringWithFormat:@"Changing Organization failed because: %@ If the problem continues contact support@missionhub.com", [error localizedDescription]];
			NSError *presentingError = [NSError errorWithDomain:MHMenuErrorDomain
												 code:MHMenuErrorChangeOrganizationFailed
											 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)}];
			
			[MHErrorHandler presentError:presentingError];
			
			weakSelf.currentOrganization	= oldOrganization;
			
		}];
		
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

-(void)logout {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MHLoginViewControllerLogout object:self];
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        // Custom initialization
    }
	
    return self;
}

- (void)awakeFromNib {
	
	self.currentOrganization	= nil;
	
	if ([MHAPI sharedInstance].currentOrganization) {
		
		self.currentOrganization	= [MHAPI sharedInstance].currentOrganization;
		
	}
	
	[[MHAPI sharedInstance] addObserver:self forKeyPath:@"currentOrganization" options:NSKeyValueObservingOptionNew context:nil];
	
}

- (void)viewDidLoad {

	[super viewDidLoad];
	
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	self.slidingViewController.underLeftWidthLayout = ECFullWidth;
	
	self.tableView.frame	= self.view.bounds;
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		
		self.tableView.frame	= self.view.bounds;
		
	} else {
		
		CGRect frame			= self.view.bounds;
		frame.origin.y			= 20.0;
		frame.size.height		-= 20.0;
		self.tableView.frame	= frame;
		
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName];
	
}

- (void)setCurrentOrganization:(MHOrganization *)currentOrganization {
    
    // Sets 1 mile (1600 meter) geofence around organization
    if (currentOrganization.name) {
        NSRange range = [currentOrganization.name rangeOfString:@"at"];
        if (range.location == NSNotFound) {
            // If an "at" doesn't exist in the organization name, then the organization is likely
            // a conference and its location is not easily "googlable"
        } else {
            // In this case, an "at" exists in the name. Thus, we guess that this organization
            // is a typical University/College, so we strip the "Cru at" or "Greek at" etc. from
            // the beginning of the name and assume everything after is the proper organization name
            NSString *strippedName = [currentOrganization.name substringFromIndex:(NSMaxRange(range)+1)];
            
            // Next we call the Google Places API with the name of the organization in order to
            // get the latitude and longitude coordinates of the school/campus/university/etc.
            NSString *googleAPIKey = @"AIzaSyCzhdjvYfJVvi3tFCV2btS5oZb0cuzwadk";
            NSString *unescapedUrlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@", strippedName, googleAPIKey];
            NSString *escapedUrlString = [unescapedUrlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
            NSURL *url = [NSURL URLWithString:escapedUrlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data, NSError *connectionError)
             {
                 if (data.length > 0 && connectionError == nil)
                 {
                     NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:0
                                                                                error:NULL];
                     // Finally, we set up a 1 mile (1600 meter) geofence around the campus lat/long coordinates
                     MHLocationManager *lm = [MHLocationManager sharedManager];
                     [lm addGeofenceAtLatitude:[responseJSON[@"results"][0][@"geometry"][@"location"][@"lat"] doubleValue] longitude:[responseJSON[@"results"][0][@"geometry"][@"location"][@"lng"] doubleValue] withRadius:1600 andIdentifier:strippedName];
                 }
             }];
            
        }
    }
	
	[_currentOrganization removeObserver:self forKeyPath:@"admins"];
	[_currentOrganization removeObserver:self forKeyPath:@"countOfAdmins"];
	[_currentOrganization removeObserver:self forKeyPath:@"users"];
	[_currentOrganization removeObserver:self forKeyPath:@"countOfUsers"];
	
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	if ([keyPath isEqualToString:@"admins"] || [keyPath isEqualToString:@"users"] || [keyPath isEqualToString:@"countOfAdmins"] || [keyPath isEqualToString:@"countOfUsers"]) {
		
		[self updateMenuArrays];
		
	} else if ([keyPath isEqualToString:@"currentOrganization"]) {
		
		self.tableView.contentOffset	= CGPointZero;
		self.currentOrganization		= [MHAPI sharedInstance].currentOrganization;
		
	}
	
}

- (void)updateMenuArrays {
	
	if (_currentOrganization) {
	
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
		
	} else {
		
		self.menuHeaders	= @[@"", @"LABELS", @"CONTACT ASSIGNMENTS", @"SURVEYS", @"SETTINGS"];
		self.menuItems		= [NSMutableArray arrayWithArray:@[@[@"ALL CONTACTS"],@[@"Loading..."],@[@"Loading..."],@[@"Loading..."],@[@"HELP", @"CHANGE ORGANIZATION", @"LOG OUT"]]];
		
	}
	
	[self.tableView reloadData];
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [[self.menuItems objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	//create cell
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	
	//configure cell
	cell.textLabel.textColor    = [UIColor colorWithRed:(192.0/255.0) green:(192.0/255.0) blue:(192.0/255.0) alpha:1.0];
	cell.textLabel.font         = [UIFont fontWithName:@"Arial-BoldMT" size:14.0];
	cell.selectionStyle			= UITableViewCellSelectionStyleGray;
	cell.backgroundColor		= [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (self.currentOrganization) {
	
		//filters
		if (indexPath.section >= 0 && indexPath.section < 4) {
			
			UIViewController *newTopViewController;
			id objectForIndex = [[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
			
			//surveys
			if (indexPath.section == 3) {
				
				if ([objectForIndex isKindOfClass:[MHSurvey class]]) {
					
					MHSurvey *survey		= (MHSurvey *)objectForIndex;
					newTopViewController	= [self surveyViewController];
					[(MHSurveyViewController *)newTopViewController displaySurvey:survey];
					
					[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																			  category:MHGoogleAnalyticsCategoryCell
																				action:MHGoogleAnalyticsActionTap
																				 label:MHGoogleAnalyticsTrackerMenuSurveyCellTap
																				 value:nil];
					
				}
				
			} else {
				
				newTopViewController = [self peopleNavigationViewController];
				MHRequestOptions *requestOptions = [[MHRequestOptions alloc] init];
				
				//All Contacts
				if (indexPath.section == 0) {
					
					[requestOptions configureForInitialPeoplePageRequest];
					
					[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																			  category:MHGoogleAnalyticsCategoryCell
																				action:MHGoogleAnalyticsActionTap
																				 label:MHGoogleAnalyticsTrackerMenuAllContactsCellTap
																				 value:nil];
					
				//Labels
				} else if (indexPath.section == 1) {
					
					[requestOptions configureForInitialPeoplePageRequest];
					
					if ([objectForIndex isKindOfClass:[MHLabel class]]) {
						
						MHLabel *label	= (MHLabel *)objectForIndex;
						[requestOptions addFilter:MHRequestOptionsFilterPeopleLabels withValue:[label.remoteID stringValue]];
						
						[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																				  category:MHGoogleAnalyticsCategoryCell
																					action:MHGoogleAnalyticsActionTap
																					 label:MHGoogleAnalyticsTrackerMenuLabelCellTap
																					 value:nil];
						
					}
					
				//contact assignments
				} else if (indexPath.section == 2) {
					
					[requestOptions configureForInitialPeoplePageRequest];
					
					if ([objectForIndex isKindOfClass:[MHPerson class]]) {
						
						MHPerson *person = (MHPerson *)objectForIndex;
						[requestOptions configureForInitialPeoplePageRequestWithAssignedToID:
						 person.remoteID];
						
						[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																				  category:MHGoogleAnalyticsCategoryCell
																					action:MHGoogleAnalyticsActionTap
																					 label:MHGoogleAnalyticsTrackerMenuContactAssignmentCellTap
																					 value:nil];
						
					}
					
				}
				
				[(MHNavigationViewController *)newTopViewController setDataFromRequestOptions:requestOptions];
				
			}
			
			if (newTopViewController) {
				
				__weak __typeof(&*self)weakSelf = self;
				[weakSelf.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
					CGRect frame = weakSelf.slidingViewController.topViewController.view.frame;
					weakSelf.slidingViewController.topViewController = newTopViewController;
					weakSelf.slidingViewController.topViewController.view.frame = frame;
					[weakSelf.slidingViewController resetTopView];
				}];
				
			}
			
		}
		
	} else {
		
		NSError *error = [NSError errorWithDomain:MHMenuErrorDomain
											 code:MHMenuErrorMenuLoading
										 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Menu is still Loading from change of Organization. Please wait for loading to complete before tapping items.", nil)}];
		
		[MHErrorHandler presentError:error];
		
	}
	
	//settings
	if (indexPath.section == 4) {
		
		if (indexPath.row == 0) {
		
			[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																	  category:MHGoogleAnalyticsCategoryCell
																		action:MHGoogleAnalyticsActionTap
																		 label:MHGoogleAnalyticsTrackerMenuHelpCellTap
																		 value:nil];
			[self help];
			
		} else if (indexPath.row == 1) {
			
			[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																	  category:MHGoogleAnalyticsCategoryCell
																		action:MHGoogleAnalyticsActionTap
																		 label:MHGoogleAnalyticsTrackerMenuChangeOrganizationCellTap
																		 value:nil];
			[self changeOrganization];
			
		} else if (indexPath.row == 2) {
			
			[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerMenuScreenName
																	  category:MHGoogleAnalyticsCategoryCell
																		action:MHGoogleAnalyticsActionTap
																		 label:MHGoogleAnalyticsTrackerMenuLogoutCellTap
																		 value:nil];
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
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		
		self.tableView.frame	= self.view.bounds;
		
	} else {
		
		CGRect frame			= self.view.bounds;
		frame.origin.y			= 20.0;
		frame.size.height		-= 20.0;
		self.tableView.frame	= frame;
		
	}
	
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[MHAPI sharedInstance] removeObserver:self forKeyPath:@"currentOrganization"];
	
}

@end
