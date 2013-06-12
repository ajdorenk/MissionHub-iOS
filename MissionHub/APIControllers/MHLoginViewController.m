//
//  MHLoginViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLoginViewController.h"

@interface MHLoginViewController ()

@end

@implementation MHLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		//this is just here to trick the linker into keeping FBLoginView as it is only used by the storyboard file which isn't considered during compilation and so FBLoginView is optimised away.
		[FBLoginView class];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
}

- (void)viewDidUnload {
    [self setFBLoginView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
	if ([self.delegate respondsToSelector:@selector(loggedInWithToken:)]) {
		
		[self.delegate loggedInWithToken:[FBSession activeSession].accessTokenData.accessToken];
		
	}
	
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
	
    NSString *alertMessage, *alertTitle;
    
    // Facebook SDK * error handling *
    // Error handling is an important part of providing a good user experience.
    // Since this sample uses the FBLoginView, this delegate will respond to
    // login failures, or other failures that have closed the session (such
    // as a token becoming invalid). Please see the [- postOpenGraphAction:]
    // and [- requestPermissionAndPost] on `SCViewController` for further
    // error handling on other operations.
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
	
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
	if ([self.delegate respondsToSelector:@selector(loggedInWithToken:)]) {
		
		[self.delegate loggedOut];
		
	}
	
}

@end
