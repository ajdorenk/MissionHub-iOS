//
//  MHIntroductionViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 11/4/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHIntroductionViewController.h"
#import "MYBlurIntroductionView.h"
#import "MHWelcomePanel.h"
#import "MHIntroductionPanel.h"

NSString * const MHIntroductionViewControllerShow		= @"com.missionhub.notification.introductionviewcontroller.show";
NSString * const MHIntroductionViewControllerFinished	= @"com.missionhub.notification.introductionviewcontroller.finished";

@interface MHIntroductionViewController () <MYIntroductionDelegate>

@property (nonatomic, strong) MYBlurIntroductionView *introductionView;
@property (nonatomic, strong) UIView *footerView;

- (void)configure;

@end

@implementation MHIntroductionViewController

@synthesize introductionView	= _introductionView;
@synthesize footerView			= _footerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) {
        
		// Custom initialization
		[self configure];
		
    }
	
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[self configure];
	
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[self.introductionView changeToPanelAtIndex:0];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[UIView animateWithDuration:0.3 animations:^{
		
		self.footerView.alpha	= 1.0;
		
	}];
	
}

- (void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
	
	self.footerView.alpha	= 0.0;
	
}

- (void)configure {
    
	CGRect frame			= self.view.bounds;
	NSString *deviceName	= @"iPhone";
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		deviceName	= @"iPad";
	}
	
    //Create custom panel with events
	MHWelcomePanel *welcomePanel	= [[MHWelcomePanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"WelcomePanel_%@", deviceName]];
	MHIntroductionPanel *panel1 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel1_%@", deviceName]];
	MHIntroductionPanel *panel2 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel2_%@", deviceName]];
	MHIntroductionPanel *panel3 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel3_%@", deviceName]];
	MHIntroductionPanel *panel4 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel4_%@", deviceName]];
	MHIntroductionPanel *panel5 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel5_%@", deviceName]];
    
    //Add panels to an array
    NSArray *panels = @[welcomePanel, panel1, panel2, panel3, panel4, panel5];
    
    //Create the introduction view and set its delegate
    self.introductionView = [[MYBlurIntroductionView alloc] initWithFrame:frame];
    self.introductionView.delegate = self;
    self.introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Default-blur"];
    
    //Build the introduction with desired panels
    [self.introductionView buildIntroductionWithPanels:panels];
    
	self.footerView	= [[UIView alloc] initWithFrame:CGRectMake(0,
																   CGRectGetMinY(self.introductionView.PageControl.frame),
																   CGRectGetWidth(self.introductionView.frame),
																   CGRectGetMaxY(self.introductionView.frame) - CGRectGetMinY(self.introductionView.PageControl.frame))];
	self.footerView.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	self.footerView.backgroundColor		= [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
	self.footerView.alpha				= 0.0;
	[self.introductionView insertSubview:self.footerView belowSubview:self.introductionView.PageControl];
	
	//Add the introduction to the view
	[self.view addSubview:self.introductionView];
	
}

- (void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
	
	[self dismissViewControllerAnimated:NO completion:^{
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MHIntroductionViewControllerFinished object:self];
		
	}];
	
}

- (NSUInteger)supportedInterfaceOrientations {
	
	return UIInterfaceOrientationMaskPortrait;
	
}

- (BOOL)shouldAutorotate {
	
	return NO;
}

@end
