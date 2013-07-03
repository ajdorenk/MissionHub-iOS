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

@synthesize loginViewController;
@synthesize userInitiatedLogout;
@synthesize showLoginOnViewDidAppear;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.userInitiatedLogout = NO;
    }
    return self;
}

-(void)awakeFromNib {
	
	self.userInitiatedLogout = NO;
	
	self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
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
		
		[self presentViewController:self.loginViewController animated:NO completion:nil];
		self.showLoginOnViewDidAppear = NO;
		
	}
	
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
	
	MHPeopleListViewController *peopleList = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleList"];
	
	self.topViewController = peopleList;
	[self.slidingViewController resetTopView];
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
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
