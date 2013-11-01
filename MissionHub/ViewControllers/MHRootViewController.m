//
//  MHRootViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRootViewController.h"
#import "MHPeopleListViewController.h"
#import "MHGoogleAnalyticsTracker.h"

NSString * const MHGoogleAnalyticsTrackerLoginScreenName				= @"Login";
NSString * const MHGoogleAnalyticsTrackerLoginLoggedInAction			= @"logged_in";
NSString * const MHGoogleAnalyticsTrackerLoginLoggedInOrganizationLabel	= @"organization";

@interface MHRootViewController ()

@property (nonatomic, assign) BOOL	userInitiatedLogout;
@property (nonatomic, assign) BOOL	showLoginOnViewDidAppear;

- (void)logout;

@end

@implementation MHRootViewController

@synthesize loginViewController				= _loginViewController;
@synthesize peopleNavigationViewController	= _peopleNavigationViewController;
@synthesize userInitiatedLogout				= _userInitiatedLogout;
@synthesize showLoginOnViewDidAppear		= _showLoginOnViewDidAppear;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.userInitiatedLogout = NO;
    }
    return self;
}

- (void)awakeFromNib {
	
	self.userInitiatedLogout = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:MHLoginViewControllerLogout object:nil];
	
	self.peopleNavigationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNavigationViewController"];
	
	self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHLoginViewController"];
	self.loginViewController.loginDelegate = self;
	self.loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
	self.loginViewController.modalTransitionStyle	= UIModalTransitionStyleCoverVertical;
	
	MHAppDelegate *appdelegate		= (MHAppDelegate *)[[UIApplication sharedApplication] delegate];
	appdelegate.loginViewController	= self.loginViewController;
	
	self.showLoginOnViewDidAppear = YES;
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	if (self.showLoginOnViewDidAppear) {
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerLoginScreenName];
		[self presentViewController:self.loginViewController animated:NO completion:nil];
		self.showLoginOnViewDidAppear = NO;
		
	}
	
}

- (void)logout {
	
	self.userInitiatedLogout = YES;
	[self.loginViewController logout];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	
	return YES;
}

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MHLoginViewControllerDelegate methods

- (void)finishedLoginWithCurrentUser:(MHPerson *)currentUser peopleList:(NSArray *)peopleList requestOptions:(MHRequestOptions *)options {
	
	[[self peopleNavigationViewController] setDataArray:peopleList forRequestOptions:options];
	self.topViewController = self.peopleNavigationViewController;
	
	__weak __typeof(&*self)weakSelf = self;
	[self dismissViewControllerAnimated:YES completion:^{
		
		[weakSelf resetTopView];
		
	}];
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerLoginScreenName
															  category:MHGoogleAnalyticsCategoryBackgroundProcess
																action:MHGoogleAnalyticsTrackerLoginLoggedInAction
																 label:MHGoogleAnalyticsTrackerLoginLoggedInOrganizationLabel
																 value:nil];
	
}

- (void)finishedLogout {
	
	if (self.userInitiatedLogout) {
		
		[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerLoginScreenName];
		[self presentViewController:self.loginViewController animated:YES completion:nil];
		
	}
	
	self.userInitiatedLogout = NO;
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

@end
