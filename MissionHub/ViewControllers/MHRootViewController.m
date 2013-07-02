//
//  MHRootViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRootViewController.h"
#import "MHPeopleListViewController.h"

@interface MHRootViewController ()

@end

@implementation MHRootViewController

@synthesize realStoryboard;
@synthesize loginViewController;
@synthesize userInitiatedLogout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.userInitiatedLogout = NO;
    }
    return self;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.userInitiatedLogout = NO;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		
		self.realStoryboard = [UIStoryboard storyboardWithName:@"MissionHub_iPhone" bundle:nil];
		
	} else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		self.realStoryboard = [UIStoryboard storyboardWithName:@"MissionHub_iPad" bundle:nil];
		
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	self.loginViewController = [self.realStoryboard instantiateViewControllerWithIdentifier:@"Login"];
	self.loginViewController.loginDelegate = self;
	self.loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
	self.loginViewController.modalTransitionStyle	= UIModalTransitionStyleCoverVertical;
	
	[self presentViewController:self.loginViewController animated:NO completion:nil];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MHLoginDelegate methods

-(void)finishedLoginWithCurrentUser:(MHPerson *)currentUser {
	
	__block MHPeopleListViewController *peopleList = [self.realStoryboard instantiateViewControllerWithIdentifier:@"PeopleList"];
	__block MHMenuViewController *menuList = [self.realStoryboard instantiateViewControllerWithIdentifier:@"Menu"];
	
	//[peopleList setCurrentUser:currentUser];
	[menuList setCurrentUser:currentUser];
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		self.topViewController = peopleList;
		[self.slidingViewController resetTopView];
		
	}];
	
}

-(void)finishedLogout {
	
	if (self.userInitiatedLogout) {
		
		[self dismissViewControllerAnimated:YES completion:^{
			
			[self presentViewController:self.loginViewController animated:YES completion:nil];
			
		}];
		
	}
	
	self.userInitiatedLogout = NO;
	
}

@end
