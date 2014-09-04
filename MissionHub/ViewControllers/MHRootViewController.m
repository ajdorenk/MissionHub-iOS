//
//  MHRootViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRootViewController.h"
#import "MHIntroductionViewController.h"
#import "MHPeopleListViewController.h"
#import "MHGoogleAnalyticsTracker.h"
#import "ABNotifier.h"

NSString * const MHGoogleAnalyticsTrackerIntroductionScreenName			= @"Introduction Tutorial";
NSString * const MHGoogleAnalyticsTrackerLoginScreenName				= @"Login";
NSString * const MHGoogleAnalyticsTrackerLoginLoggedInAction			= @"logged_in";
NSString * const MHGoogleAnalyticsTrackerLoginLoggedInOrganizationLabel	= @"organization";

static NSString * const introductionHasBeenViewed						= @"introductionHasBeenViewed";

@interface MHRootViewController () <MHLoginViewControllerDelegate>

@property (nonatomic, strong, readonly) MHLoginViewController			*loginViewController;
@property (nonatomic, strong, readonly) MHNavigationViewController		*peopleNavigationViewController;
@property (nonatomic, strong, readonly) MHIntroductionViewController	*introductionViewController;
@property (nonatomic, assign) BOOL	userInitiatedLogout;
@property (nonatomic, assign) BOOL	showLoginOnViewDidAppear;

- (void)showLoginAnimated:(BOOL)animated;
- (void)showIntroductionAnimated:(BOOL)animated;
- (void)showIntroduction;
- (void)introductionFinished;
- (void)logout;

@end

@implementation MHRootViewController

@synthesize loginViewController				= _loginViewController;
@synthesize peopleNavigationViewController	= _peopleNavigationViewController;
@synthesize introductionViewController		= _introductionViewController;
@synthesize userInitiatedLogout				= _userInitiatedLogout;
@synthesize showLoginOnViewDidAppear		= _showLoginOnViewDidAppear;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
        // Custom initialization
		self.userInitiatedLogout = NO;
    }
    
	return self;
}

- (void)awakeFromNib {
	
	self.shouldAddPanGestureRecognizerToTopViewSnapshot	= YES;
	self.showLoginOnViewDidAppear		= YES;
	self.userInitiatedLogout			= NO;
	
	MHAppDelegate *appdelegate			= (MHAppDelegate *)[[UIApplication sharedApplication] delegate];
	appdelegate.loginViewController		= self.loginViewController;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIntroduction) name:MHIntroductionViewControllerShow object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introductionFinished) name:MHIntroductionViewControllerFinished object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:MHLoginViewControllerLogout object:nil];
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	if (self.showLoginOnViewDidAppear) {
		
		if ([[NSUserDefaults standardUserDefaults] boolForKey:introductionHasBeenViewed]) {
			
			[self showLoginAnimated:NO];
			
		} else {
			
			[self showIntroductionAnimated:NO];
			
		}
		
		self.showLoginOnViewDidAppear = NO;
		
	}
	
}

- (MHLoginViewController *)loginViewController {
	
	if (_loginViewController == nil) {
		
		_loginViewController							= [self.storyboard instantiateViewControllerWithIdentifier:@"MHLoginViewController"];
		_loginViewController.loginDelegate				= self;
		_loginViewController.modalPresentationStyle		= UIModalPresentationFullScreen;
		_loginViewController.modalTransitionStyle		= UIModalTransitionStyleCoverVertical;
		
	}
	
	return _loginViewController;
	
}

- (MHNavigationViewController *)peopleNavigationViewController {
	
	if (_peopleNavigationViewController == nil) {
		
		_peopleNavigationViewController					= [self.storyboard instantiateViewControllerWithIdentifier:@"MHNavigationViewController"];
		
	}
	
	return _peopleNavigationViewController;
	
}

- (MHIntroductionViewController *)introductionViewController {
	
	if (_introductionViewController == nil) {
		
		_introductionViewController							= [self.storyboard instantiateViewControllerWithIdentifier:@"MHIntroductionViewController"];
		_introductionViewController.modalPresentationStyle	= UIModalPresentationFullScreen;
		_introductionViewController.modalTransitionStyle	= UIModalTransitionStyleCoverVertical;
		
	}
	
	return _introductionViewController;
	
}

- (void)showLoginAnimated:(BOOL)animated {
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerLoginScreenName];
	[self presentViewController:self.loginViewController animated:animated completion:nil];
	
}

- (void)showIntroduction {
	
	[self showIntroductionAnimated:YES];
	
}

- (void)showIntroductionAnimated:(BOOL)animated {
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendScreenViewWithScreenName:MHGoogleAnalyticsTrackerIntroductionScreenName];
	[self presentViewController:self.introductionViewController animated:animated completion:nil];
	
}

- (void)introductionFinished {
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:introductionHasBeenViewed]) {
		
		[self.loginViewController dismissViewControllerAnimated:YES completion:nil];
		
	} else {
		
		[self showLoginAnimated:NO];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:introductionHasBeenViewed];
		
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
	[self.loginViewController dismissViewControllerAnimated:YES completion:^{
		
		[weakSelf resetTopView];
		
	}];
	
	[ABNotifier setEnvironmentValue:([currentUser.remoteID stringValue] ? [currentUser.remoteID stringValue] : @"" )
							 forKey:@"person_id"];
	[ABNotifier setEnvironmentValue:([currentUser.currentOrganization.remoteID stringValue] ? [currentUser.currentOrganization.remoteID stringValue] : @"")
							 forKey:@"organization_id"];
	
	[[MHGoogleAnalyticsTracker sharedInstance] sendEventWithScreenName:MHGoogleAnalyticsTrackerLoginScreenName
															  category:MHGoogleAnalyticsCategoryBackgroundProcess
																action:MHGoogleAnalyticsTrackerLoginLoggedInAction
																 label:MHGoogleAnalyticsTrackerLoginLoggedInOrganizationLabel
																 value:nil];
	
}

- (void)finishedLogout {
	
	if (self.userInitiatedLogout) {
		
		[self showLoginAnimated:YES];
		
	}
	
	self.userInitiatedLogout = NO;
	
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

@end
