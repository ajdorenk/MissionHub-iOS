//
//  MHIntroductionViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 11/4/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHIntroductionViewController.h"
#import "MYBlurIntroductionView.h"
#import "MHIntroductionPanel.h"

NSString * const MHIntroductionViewControllerShow		= @"com.missionhub.notification.introductionviewcontroller.show";
NSString * const MHIntroductionViewControllerFinished	= @"com.missionhub.notification.introductionviewcontroller.finished";

@interface MHIntroductionViewController () <MYIntroductionDelegate>

@property (nonatomic, strong) MYBlurIntroductionView *introductionView;

- (void)configure;

@end

@implementation MHIntroductionViewController

@synthesize introductionView	= _introductionView;

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

- (void)configure {
    
	CGRect frame			= self.view.bounds;
	NSString *deviceName	= @"iPhone";
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		deviceName	= @"iPad";
	}
	
    //Create custom panel with events
	MHIntroductionPanel *panel1 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel1_%@", deviceName]];
	MHIntroductionPanel *panel2 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel2_%@", deviceName]];
	MHIntroductionPanel *panel3 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel3_%@", deviceName]];
	MHIntroductionPanel *panel4 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel4_%@", deviceName]];
	MHIntroductionPanel *panel5 = [[MHIntroductionPanel alloc] initWithFrame:frame nibNamed:[NSString stringWithFormat:@"Panel5_%@", deviceName]];
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3, panel4, panel5];
    
    //Create the introduction view and set its delegate
    self.introductionView = [[MYBlurIntroductionView alloc] initWithFrame:frame];
    self.introductionView.delegate = self;
    self.introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Default-blur"];
    
    //Build the introduction with desired panels
    [self.introductionView buildIntroductionWithPanels:panels];
    
	UIView *footerView	= [[UIView alloc] initWithFrame:CGRectMake(0,
																   CGRectGetMinY(self.introductionView.PageControl.frame),
																   CGRectGetWidth(self.introductionView.frame),
																   CGRectGetMaxY(self.introductionView.frame) - CGRectGetMinY(self.introductionView.PageControl.frame))];
	footerView.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
	footerView.backgroundColor	= [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
	[self.introductionView insertSubview:footerView belowSubview:self.introductionView.PageControl];
	
	//Add the introduction to the view
	[self.view addSubview:self.introductionView];
	
}

- (void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MHIntroductionViewControllerFinished object:self];
	
}

@end
