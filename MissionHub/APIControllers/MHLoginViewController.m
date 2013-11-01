//
//  MHLoginViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/10/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHLoginViewController.h"
#import "Facebook.h"
#import "FBLoginView.h"
#import "MHAPI.h"
#import "MHErrorHandler.h"

#define LOGIN_BUTTON_WIDTH 180.0f
#define LOGIN_BUTTON_HEIGHT 60.0f

NSString *const FBSessionStateChangedNotification	= @"com.missionhub:FBSessionStateChangedNotification";
NSString *const MHLoginViewControllerLogout			= @"com.missionhub.notification.logout";
NSString *const MHLoginErrorDomain					= @"com.missionhub.errorDomain.login";

typedef enum {
	MHLoginErrorUnknownError,
	MHLoginErrorFBError,
	MHLoginErrorUserCancelledLoginError,
	MHLoginErrorSessionError
} MHLoginErrors;

@interface MHLoginViewController () <FBLoginViewDelegate, MHLoginViewControllerDelegate>

@property (nonatomic, strong)				UIImageView							*logoImageView;
@property (nonatomic, strong)				FBLoginView							*loginButtonView;
@property (nonatomic, strong)				UIButton							*missionhubRefreshButton;
@property (nonatomic, weak)					IBOutlet UIActivityIndicatorView	*loadingIndicator;
@property (nonatomic, assign)				BOOL								hasRequestedMe;
@property (nonatomic, weak) IBOutlet		UIToolbar * toolbar;

- (void)handleAppLink:(FBAccessTokenData *)appLinkToken;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)loggedInWithToken:(NSString *)token;
- (void)refreshMissionHubData:(id)sender;

- (void)beginLoading;
- (void)endLoading;

@end

@implementation MHLoginViewController

@synthesize loginDelegate		= _loginDelegate;
@synthesize logoImageView		= _logoImageView;
@synthesize loginButtonView		= _loginButtonView;
@synthesize loadingIndicator	= _loadingIndicator;
@synthesize loggedIn			= _loggedIn;
@synthesize hasRequestedMe		= _hasRequestedMe;
@synthesize missionhubRefreshButton	= _missionhubRefreshButton;
@synthesize toolbar				= _toolbar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        // Custom initialization
		
		//this is just here to trick the linker into keeping FBLoginView as it is only used by the storyboard file which isn't considered during compilation and so FBLoginView is optimised away.
		[FBLoginView class];
    }
	
    return self;
}

-(void)awakeFromNib {
	
	self.loggedIn			= NO;
	self.hasRequestedMe		= NO;
	
	self.loginButtonView	= [[FBLoginView alloc] initWithReadPermissions:@[@"user_birthday",@"email",@"user_interests",@"user_location",@"user_education_history"]];
	
	//NSLog(@"%f, %f, %f, %f", CGRectGetMidX(self.view.frame) - (LOGIN_BUTTON_WIDTH / 2),
	//	  CGRectGetMidY(self.view.frame) - (LOGIN_BUTTON_HEIGHT / 2),
	//	  LOGIN_BUTTON_WIDTH,
	//	  LOGIN_BUTTON_HEIGHT);
	
	self.loginButtonView.delegate	= self;
	self.loginButtonView.frame		= CGRectMake(CGRectGetMidX(self.view.frame) - (LOGIN_BUTTON_WIDTH / 2),
											 CGRectGetMidY(self.view.frame),
											 LOGIN_BUTTON_WIDTH,
											 LOGIN_BUTTON_HEIGHT);
	
	[self.view addSubview:self.loginButtonView];
	
	[self.loginButtonView sizeToFit];
	
	self.loginButtonView.frame		= CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.loginButtonView.frame) / 2),
										 CGRectGetMidY(self.view.frame),
										 self.loginButtonView.frame.size.width,
										 self.loginButtonView.frame.size.height);
	
	self.missionhubRefreshButton	= [UIButton buttonWithType:UIButtonTypeCustom];
	self.missionhubRefreshButton.frame = self.loginButtonView.frame;
	[self.missionhubRefreshButton setImage:[UIImage imageNamed:@"MH_Mobile_Button_Refresh_86.png"] forState:UIControlStateNormal];
	[self.missionhubRefreshButton setImage:[UIImage imageNamed:@"MH_Mobile_Button_Refresh_Pressed_86.png"] forState:UIControlStateHighlighted];
	[self.missionhubRefreshButton addTarget:self action:@selector(refreshMissionHubData:) forControlEvents:UIControlEventTouchUpInside];
	self.missionhubRefreshButton.hidden = YES;
	
	[self.view addSubview:self.missionhubRefreshButton];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view.
	
	if ([[MHAPI sharedInstance] accessToken]) {
		
		[self loggedInWithToken:[[MHAPI sharedInstance] accessToken]];
		
	} else {
		
		[self endLoading];
		
	}
	
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loading Methods methods

- (void)logout {
	
	[[MHAPI sharedInstance] logout];
	[FBSession.activeSession closeAndClearTokenInformation];

}

- (void)beginLoading {
	
	self.loginButtonView.userInteractionEnabled = NO;
	self.loginButtonView.hidden = YES;
	self.missionhubRefreshButton.hidden = YES;
	[self.loadingIndicator startAnimating];
	
}

- (void)endLoading {
	
	self.loginButtonView.userInteractionEnabled = YES;
	self.loginButtonView.hidden = NO;
	self.missionhubRefreshButton.hidden = YES;
	[self.loadingIndicator stopAnimating];
	
}

#pragma mark - FB App switching methods

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
	
    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
	__weak __typeof(&*self)weakSelf = self;
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        if (call.accessTokenData) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
				
				[weakSelf loggedInWithToken:call.accessTokenData.accessToken];
				
            }
            else {
                [weakSelf handleAppLink:call.accessTokenData];
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
	__weak __typeof(&*self)weakSelf = self;
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  [weakSelf loginView:nil handleError:error];
                              } else {
								  [weakSelf loggedInWithToken:session.accessTokenData.accessToken];
							  }
                          }];
	
}

#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
	[self loggedInWithToken:[FBSession activeSession].accessTokenData.accessToken];
	
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
        [self handleError:error];
    }
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
	
    NSString *alertMessage, *alertTitle;
	MHLoginErrors code;
    
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
		code = MHLoginErrorFBError;
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures as mentioned. You can inspect
        // the error for more context but this sample generically notifies the user.
		code = MHLoginErrorSessionError;
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
		code = MHLoginErrorUserCancelledLoginError;
		//alertMessage = @"Login Cancelled.";
    } else {
        // For simplicity, this sample treats other errors blindly, but you should
        // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
		code = MHLoginErrorUnknownError;
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
		
		NSError *error = [NSError errorWithDomain:MHLoginErrorDomain
											 code:code
										 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(alertMessage, nil),
													@"title": alertTitle}];
		
		[MHErrorHandler presentError:error];
    }
	
}

-(void)refreshMissionHubData:(id)sender {
	
	[self loggedInWithToken:[MHAPI sharedInstance].accessToken];
	
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
	
	[self endLoading];
    
	if ([self.loginDelegate respondsToSelector:@selector(finishedLogout)]) {
		
		[self.loginDelegate finishedLogout];
		
	}
	
	self.loggedIn = NO;
	
}

-(void)loggedInWithToken:(NSString *)token {
	
	if (self.loggedIn == NO) {
		
		
		[self beginLoading];
		
		NSLog(@"LOGGED IN WITH TOKEN: %@", token);
		[MHAPI sharedInstance].accessToken = token;
		
		if (self.hasRequestedMe == NO) {
		
			if ([MHAPI sharedInstance].currentUser && [MHAPI sharedInstance].initialPeopleList) {
				
				[self endLoading];
				
				if ([self.loginDelegate respondsToSelector:@selector(finishedLoginWithCurrentUser:peopleList:requestOptions:)]) {
					
					[self.loginDelegate finishedLoginWithCurrentUser:[MHAPI sharedInstance].currentUser  peopleList:[MHAPI sharedInstance].initialPeopleList requestOptions:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]];
					
				}
				
			} else {
				
				self.hasRequestedMe = YES;
			
				__weak __typeof(&*self)weakSelf = self;
				[[MHAPI sharedInstance] getMeWithSuccessBlock:^(NSArray *result, MHRequestOptions *options) {
					
					[weakSelf endLoading];
					
					NSArray *peopleList = nil;
					id  resultObject = [result objectAtIndex:1];
					
					if ([resultObject isKindOfClass:[NSError class]]) {
						
						[weakSelf handleError:resultObject];
						
					} else if ([resultObject isKindOfClass:[NSArray class]]) {
						
						peopleList = resultObject;
						
					}
					
					if ([weakSelf.loginDelegate respondsToSelector:@selector(finishedLoginWithCurrentUser:peopleList:requestOptions:)]) {
						
						[weakSelf.loginDelegate finishedLoginWithCurrentUser:[MHAPI sharedInstance].currentUser  peopleList:peopleList requestOptions:[[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]];
						
					}
					
					weakSelf.hasRequestedMe = NO;
					weakSelf.loggedIn		= YES;
					
				} failBlock:^(NSError *error, MHRequestOptions *options) {
					
					[weakSelf endLoading];
					
					[weakSelf handleError:error];
					
					weakSelf.hasRequestedMe = NO;
					
				}];
				
			}
			
		}
		
		
	}
	
}

-(void)handleError:(NSError *)error {
	
	//do stuff to configure the UI when an error happens i.e. fb error clears fb session and shows fb button, mh error shows mh reload button
	
	if ([error.domain isEqualToString:MHAPIErrorDomain]) {
		
		self.missionhubRefreshButton.hidden = NO;
		self.loginButtonView.hidden = YES;
		
	} else {
		
		self.missionhubRefreshButton.hidden = YES;
		self.loginButtonView.hidden = NO;
		
	}
	
	[MHErrorHandler presentError:error];
	
}

#pragma mark - orientation methods

- (BOOL)shouldAutorotate {
	
    return YES;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	
    return YES;
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	
	
	self.logoImageView.frame	= CGRectMake(0.5 * (CGRectGetWidth(frame) - CGRectGetWidth(self.logoImageView.frame)), CGRectGetMinY(self.logoImageView.frame), CGRectGetWidth(self.logoImageView.frame), CGRectGetHeight(self.logoImageView.frame));
	
}

@end
