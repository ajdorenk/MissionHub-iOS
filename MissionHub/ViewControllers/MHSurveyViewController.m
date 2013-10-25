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
		
		UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 25)];
		labelForTitle.textAlignment = NSTextAlignmentCenter;
		labelForTitle.font = [UIFont systemFontOfSize:14.0];
		labelForTitle.textColor = [UIColor blackColor];
		labelForTitle.backgroundColor = [UIColor clearColor];
		labelForTitle.adjustsFontSizeToFitWidth = NO;
		labelForTitle.text = self.survey.title;
		self.toolbarTitle = labelForTitle;
		
		UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView: labelForTitle];
		//UIBarButtonItem *flexibleSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		if ([self.topToolbar.items count] == 2) {
			
			NSMutableArray *itemArray = [NSMutableArray arrayWithArray:self.topToolbar.items];
			[itemArray replaceObjectAtIndex:1 withObject:titleItem];
			[self.topToolbar setItems:itemArray animated:NO];
			
			
		} else {
			
			[self.topToolbar setItems:[self.topToolbar.items arrayByAddingObjectsFromArray:@[titleItem]] animated:NO];
			
		}
		
	}
	
	[self displaySurvey:self.survey];
	
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
	
	if ([self.topToolbar.items count] > 0) {
		
		NSMutableArray *itemArray	= [NSMutableArray arrayWithArray:self.topToolbar.items];
		[itemArray replaceObjectAtIndex:0 withObject:[MHToolbar barButtonWithStyle:MHToolbarStyleMenu target:self selector:@selector(revealMenu:) forBar:self.topToolbar]];
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

- (id)displaySurvey:(MHSurvey *)surveyToDisplay {
	
	self.survey = surveyToDisplay;
	
	if (self.survey.remoteID > 0 && self.isVisible) {
		
		NSURLRequest *surveyRequest = [[MHAPI sharedInstance] requestForSurveyWith:self.survey.remoteID];
		
		NSLog(@"%@", [surveyRequest.URL absoluteString]);
		
		[self.surveyWebView stopLoading];
		[self.surveyWebView loadRequest:surveyRequest];
		
	}
	
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	//if (self.numberOfAssetsLoading == 0) {
		
		self.messageView.hidden			= NO;
		self.messageLabel.hidden		= YES;
		self.loadingIndicator.hidden	= NO;
		[self.loadingIndicator startAnimating];
		[self.view bringSubviewToFront:self.messageView];
		
	//}
	
	self.numberOfAssetsLoading++;
	NSLog(@"start: %d - %@", self.numberOfAssetsLoading, [request.URL absoluteString]);
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
	
	NSLog(@"%@", [webView.request.URL absoluteString]);
	self.numberOfFailedAssests	= 0;
	
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
	
	self.numberOfAssetsLoading--;
	NSLog(@"finish: %d", self.numberOfAssetsLoading);
//	if (!self.numberOfAssetsLoading) {
//	
//		self.messageView.hidden			= YES;
//		self.messageLabel.hidden		= YES;
//		self.loadingIndicator.hidden	= YES;
//		[self.loadingIndicator stopAnimating];
//		[self.view bringSubviewToFront:self.surveyWebView];
//		
//	}
	self.messageView.hidden = YES;
	
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	self.numberOfAssetsLoading--;
	self.numberOfFailedAssests++;
	NSLog(@"fail: %d", self.numberOfAssetsLoading);
//	if (self.numberOfAssetsLoading) {
//		
//		self.messageView.hidden = NO;
//		self.messageLabel.hidden = NO;
//		self.loadingIndicator.hidden	= YES;
//		[self.loadingIndicator stopAnimating];
//		[self.view bringSubviewToFront:self.messageView];
//	
//	} else {
//		
//		self.messageView.hidden = YES;
//		
//	}
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
