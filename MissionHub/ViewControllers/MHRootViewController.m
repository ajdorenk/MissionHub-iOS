//
//  MHRootViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHRootViewController.h"

@interface MHRootViewController ()

@end

@implementation MHRootViewController

@synthesize realStoryboard;
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
	
	if ([[MHAPI sharedInstance] accessToken] == nil) {
		
		self.topViewController = [self.realStoryboard instantiateViewControllerWithIdentifier:@"Login"];
		((MHLoginViewController *)self.topViewController).delegate = self;
		
	} else {
		
		[[MHAPI sharedInstance] getMeWithOptions:nil
									  successBlock:^(NSArray *result, MHRequestOptions *options) {
										  
										  NSLog(@"SUCCESS");
										  
									  } failBlock:^(NSError *error, MHRequestOptions *options) {
										  
										  NSLog(@"FAIL");
										  
									  }
		 ];
		
		self.topViewController = [self.realStoryboard instantiateViewControllerWithIdentifier:@"PeopleList"];
		
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

-(void)loggedInWithToken:(NSString *)token {
	NSLog(@"LOGGED IN WITH TOKEN: %@", token);
	[MHAPI sharedInstance].accessToken = token;
	
	self.topViewController = [self.realStoryboard instantiateViewControllerWithIdentifier:@"PeopleList"];
	[self.slidingViewController resetTopView];
	
}

-(void)loggedOut {
	
	[MHAPI sharedInstance].accessToken = nil;
	
	if (self.userInitiatedLogout) {
		
		self.topViewController = [self.realStoryboard instantiateViewControllerWithIdentifier:@"Login"];
		[self.slidingViewController resetTopView];
		
	}
	
	self.userInitiatedLogout = NO;
	
}

@end
