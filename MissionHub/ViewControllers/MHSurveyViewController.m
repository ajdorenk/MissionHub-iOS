//
//  MHSurveyViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHSurveyViewController.h"
#import "MHMenuToolbar.h"
#import "MHAPI.h"
#import "MHToolbar.h"

@interface MHSurveyViewController () {
	
	MHSurvey *_survey;
	BOOL		_isVisible;
	
}

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, strong) MHSurvey *survey;
@property (nonatomic, strong) IBOutlet UIToolbar *topToolbar;
@property (nonatomic, strong) UILabel *toolbarTitle;
@property (nonatomic, strong) IBOutlet UIView *messageView;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, assign) NSInteger numberOfAssetsLoading;

@end

@implementation MHSurveyViewController

@synthesize isVisible = _isVisible;
@synthesize survey = _survey;
@synthesize numberOfAssetsLoading;
@synthesize topToolbar;
@synthesize toolbarTitle;
//@synthesize backMenu;
@synthesize surveyWebView;
@synthesize messageView;
@synthesize messageLabel;
@synthesize loadingIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib {

	[super awakeFromNib];
	
}

-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	

	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;
	
	if (![self.slidingViewController.underLeftViewController isKindOfClass:[MHMenuViewController class]]) {
		self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MHMenuViewController"];
	}
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated	{
	
	[super viewDidAppear:animated];
	
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

-(void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
	
	self.isVisible = NO;
	
}

- (IBAction)revealMenu:(id)sender {
	
	[self.slidingViewController anchorTopViewTo:ECRight];
    
	
}

-(id)displaySurvey:(MHSurvey *)surveyToDisplay {
	
	self.survey = surveyToDisplay;
	
	if (self.survey.remoteID > 0 && self.isVisible) {
		
		NSURLRequest *surveyRequest = [[MHAPI sharedInstance] requestForSurveyWith:self.survey.remoteID];
		
		NSLog(@"%@", [surveyRequest.URL absoluteString]);
		
		[self.surveyWebView loadRequest:surveyRequest];
		
	}
	
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	if (self.numberOfAssetsLoading == 0) {
		
		self.messageLabel.hidden = NO;
		self.messageLabel.hidden = YES;
		[self.loadingIndicator startAnimating];
		[self.view bringSubviewToFront:self.messageView];
		
	}
	
	self.numberOfAssetsLoading++;
	
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
	
	NSLog(@"%@", webView.request);
	
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
	
	self.numberOfAssetsLoading--;
	
	if (self.numberOfAssetsLoading && self.messageView.hidden == NO) {
	
		self.messageView.hidden = YES;
		self.messageLabel.hidden = YES;
		[self.loadingIndicator stopAnimating];
		[self.view bringSubviewToFront:self.surveyWebView];
		
	}
	
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	self.numberOfAssetsLoading--;
	
	if (self.numberOfAssetsLoading) {
		
		if (self.messageView.hidden) {
			self.messageView.hidden = NO;
		}
		
		self.messageLabel.hidden = NO;
		[self.loadingIndicator stopAnimating];
		[self.view bringSubviewToFront:self.messageView];
	
	}

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
	
	if ([self.topToolbar.items count] > 0) {
		
		NSMutableArray *itemArray = [NSMutableArray arrayWithArray:self.topToolbar.items];
		[itemArray replaceObjectAtIndex:0 withObject:[MHToolbar barButtonWithStyle:MHToolbarStyleMenu target:self selector:@selector(revealMenu:) forBar:self.topToolbar]];
		[self.topToolbar setItems:itemArray animated:NO];
		
	}
	
}

@end
