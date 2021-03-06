//
//  MHSurveyViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSurveyViewController.h"
#import "MHAPI.h"
#import "MHToolbar.h"
#import "MHGoogleAnalyticsTracker.h"

NSString * const MHGoogleAnalyticsTrackerSurveyScreenName	= @"Survey";

@interface MHSurveyViewController ()

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) MHSurvey *survey;
@property (nonatomic, strong) UILabel *toolbarTitle;
@property (nonatomic, assign) NSInteger numberOfAssetsLoading;
@property (nonatomic, assign) NSInteger numberOfFailedAssests;
//@property (nonatomic, weak) IBOutlet UIBarButtonItem *backMenu;
@property (nonatomic, weak) IBOutlet UIWebView *surveyWebView;
@property (nonatomic, weak) IBOutlet UIView *messageView;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) IBOutlet UIToolbar *topToolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *titleItem;

- (IBAction)revealMenu:(id)sender;

- (void)updateLayout;

@end

@implementation MHSurveyViewController

@synthesize isVisible			= _isVisible;
@synthesize survey				= _survey;
@synthesize numberOfAssetsLoading	= _numberOfAssetsLoading;
@synthesize topToolbar			= _topToolbar;
@synthesize toolbarTitle		= _toolbarTitle;
//@synthesize backMenu;
@synthesize surveyWebView		= _surveyWebView;
@synthesize messageView			= _messageView;
@synthesize messageLabel		= _messageLabel;
@synthesize loadingIndicator	= _loadingIndicator;
@synthesize titleItem			= _titleItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
        // Custom initialization
    }
    
	return self;
}

- (void)awakeFromNib {

	[super awakeFromNib];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;
	
	self.topToolbar.layer.shadowColor	= [UIColor blackColor].CGColor;
	self.topToolbar.layer.shadowRadius	= 1.0f;
	self.topToolbar.layer.shadowOpacity	= 0.75f;
	self.topToolbar.layer.shadowOffset	= CGSizeMake(0.0, 1.0);
	
	if (![self.slidingViewController.underLeftViewController isKindOfClass:[MHMenuViewController class]]) {
		self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MHMenuViewController"];
	}
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	
  
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
}

- (void)viewDidAppear:(BOOL)animated	{
	
	[super viewDidAppear:animated];
	
	[self updateLayout];
	
	self.isVisible = YES;
	
	if (self.survey.title) {
		
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			
			UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 25)];
			labelForTitle.textAlignment = NSTextAlignmentCenter;
			labelForTitle.font = [UIFont systemFontOfSize:14.0];
			labelForTitle.textColor = [UIColor blackColor];
			labelForTitle.backgroundColor = [UIColor clearColor];
			labelForTitle.adjustsFontSizeToFitWidth = NO;
			labelForTitle.text = self.survey.title;
			self.toolbarTitle = labelForTitle;
			
			UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView: labelForTitle];
			
			if (self.topToolbar.items.count > 2) {
				
				NSMutableArray *itemArray = [NSMutableArray arrayWithArray:self.topToolbar.items];
				[itemArray replaceObjectAtIndex:2 withObject:titleItem];
				[self.topToolbar setItems:itemArray animated:NO];
				
			}
			
		} else {
			
			self.titleItem.title	= self.survey.title;
			
		}
		
	}
	
	[self displaySurvey:self.survey];
	
	[[[MHGoogleAnalyticsTracker sharedInstance] setScreenName:MHGoogleAnalyticsTrackerSurveyScreenName] sendScreenView];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
	
	self.isVisible = NO;
	
}

- (void)updateLayout {
	
	CGRect frame			= self.view.frame;
	CGFloat toolbarHeight	= 64.0;
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		
		toolbarHeight		= 44.0;
		
	}
	
	self.topToolbar.frame			= CGRectMake(0,
												 0,
												 CGRectGetWidth(frame),
												 toolbarHeight);
	
	if ([self.topToolbar.items count] > 1) {
		
		NSMutableArray *itemArray	= [NSMutableArray arrayWithArray:self.topToolbar.items];
		[itemArray replaceObjectAtIndex:0 withObject:[MHToolbar barButtonWithStyle:MHToolbarStyleMenu target:self selector:@selector(revealMenu:) forBar:self.topToolbar]];
		[itemArray replaceObjectAtIndex:itemArray.count - 1 withObject:[MHToolbar barButtonWithStyle:MHToolbarStyleStartAgain target:self selector:@selector(reload:) forBar:self.topToolbar]];
		[self.topToolbar setItems:itemArray animated:NO];
		
	}
	
	self.surveyWebView.frame	= CGRectMake(CGRectGetMinX(self.surveyWebView.frame),
											 CGRectGetMaxY(self.topToolbar.frame),
											 CGRectGetWidth(frame),
											 CGRectGetHeight(frame) - CGRectGetHeight(self.topToolbar.frame));
	
	self.messageView.frame		= CGRectMake(CGRectGetMinX(self.messageView.frame),
											 CGRectGetMaxY(self.topToolbar.frame),
											 CGRectGetWidth(frame),
											 CGRectGetHeight(frame) - CGRectGetHeight(self.topToolbar.frame));
	
}

- (IBAction)revealMenu:(id)sender {
	
	[self.slidingViewController anchorTopViewTo:ECRight];
    
	
}

- (IBAction)reload:(id)sender {
	
	[self displaySurvey:self.survey];
	
}

- (id)displaySurvey:(MHSurvey *)surveyToDisplay {
	
	self.survey = surveyToDisplay;
	
	if (self.survey.remoteID > 0 && self.isVisible) {
		
		NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* facebookCookies = cookies.cookies;
        for (NSHTTPCookie* cookie in facebookCookies) {
            [cookies deleteCookie:cookie];
        }
		
		[[NSURLCache sharedURLCache] removeCachedResponseForRequest:self.surveyWebView.request];
		[[NSURLCache sharedURLCache] removeAllCachedResponses];
		
		NSURLRequest *surveyRequest	= [[MHAPI sharedInstance] requestForSurveyWith:self.survey.remoteID];
		
		NSLog(@"%@", [surveyRequest.URL absoluteString]);
		
		[self.surveyWebView stopLoading];
		[self.surveyWebView loadRequest:surveyRequest];
		
		self.messageView.hidden			= NO;
		self.messageLabel.hidden		= YES;
		self.loadingIndicator.hidden	= NO;
		[self.loadingIndicator startAnimating];
		[self.view bringSubviewToFront:self.messageView];
		
		self.numberOfFailedAssests		= 0;
		self.numberOfAssetsLoading		= 0;
		
	}
	
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	self.numberOfAssetsLoading++;
	
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
	
	self.numberOfFailedAssests	= 0;
	
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
	
	self.numberOfAssetsLoading--;

	self.messageView.hidden = YES;
	
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	self.numberOfAssetsLoading--;
	self.numberOfFailedAssests++;

	self.messageView.hidden = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
	
	[self updateLayout];
	
}

@end
