//
//  MHLoginViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLoginViewController.h"

#define LOGIN_BUTTON_WIDTH 180.0f
#define LOGIN_BUTTON_HEIGHT 60.0f


NSString *const FBSessionStateChangedNotification = @"org.cru.missionhub:FBSessionStateChangedNotification";

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

-(void)awakeFromNib {
	
	FBLoginView *fbLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"user_birthday",@"email",@"user_interests",@"user_location",@"user_education_history"]];
	
	//NSLog(@"%f, %f, %f, %f", CGRectGetMidX(self.view.frame) - (LOGIN_BUTTON_WIDTH / 2),
	//	  CGRectGetMidY(self.view.frame) - (LOGIN_BUTTON_HEIGHT / 2),
	//	  LOGIN_BUTTON_WIDTH,
	//	  LOGIN_BUTTON_HEIGHT);
	
	fbLoginView.delegate	= self;
	fbLoginView.frame		= CGRectMake(CGRectGetMidX(self.view.frame) - (LOGIN_BUTTON_WIDTH / 2),
											 CGRectGetMidY(self.view.frame) - (LOGIN_BUTTON_HEIGHT / 2),
											 LOGIN_BUTTON_WIDTH,
											 LOGIN_BUTTON_HEIGHT);
	
	[self.view addSubview:fbLoginView];
	
	[fbLoginView sizeToFit];
	
	fbLoginView.frame		= CGRectMake(CGRectGetMidX(self.view.frame) - (fbLoginView.frame.size.width / 2),
										 CGRectGetMidY(self.view.frame) - (fbLoginView.frame.size.height / 2),
										 fbLoginView.frame.size.width,
										 fbLoginView.frame.size.height);
	
	fbLoginView.alpha = 0.5;
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FB App switching methods

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
	
    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        if (call.accessTokenData) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            }
            else {
                [self handleAppLink:call.accessTokenData];
            }
        }
    }];
}

- (void)handleDidBecomeActive {
	
	[FBSession.activeSession handleDidBecomeActive];
	
}

- (void)handleWillTerminate {
	
	[FBSession.activeSession close];
	
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
	
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:@[@"user_birthday",@"email",@"offline_access",@"user_interests",@"user_location",@"user_education_history"]
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
	
    [FBSession setActiveSession:appLinkSession];
	
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  [self loginView:nil handleError:error];
                              }
                          }];
	
}

#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
	if ([self.delegate respondsToSelector:@selector(loggedInWithToken:)]) {
		
		[self.delegate loggedInWithToken:[FBSession activeSession].accessTokenData.accessToken];
		
	}
	
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
	
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
	
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
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
