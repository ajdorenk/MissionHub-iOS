//
//  MHProfileMenuViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileMenuViewController.h"

@interface MHProfileMenuViewController ()



@end

@implementation MHProfileMenuViewController

@synthesize menuDelegate		= _menuDelegate;
@synthesize segmentedControl	= _segmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.000];
    }
    return self;
}

- (void)awakeFromNib {
	
	[super awakeFromNib];
	
	[UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1.000];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	[self updateLayout];
	
}

- (IBAction)menuDidChangeSelection:(id)sender {
	
	if ([self.menuDelegate respondsToSelector:@selector(menuDidChangeSelection:)]) {
		
		[self.menuDelegate menuDidChangeSelection:self.segmentedControl.selectedSegmentIndex];
		
	}
	
}

- (void)setMenuSelection:(NSInteger)selection {
	
	[self.segmentedControl setSelectedSegmentIndex:selection];
	
}

- (NSInteger)menuSelection {
	
	return self.segmentedControl.selectedSegmentIndex;
	
}

- (void)updateLayout {
	
	self.segmentedControl.frame = CGRectMake(0,
											 0,
											 CGRectGetWidth(self.view.frame),
											 CGRectGetHeight(self.view.frame));
	
	//self.segmentedControl.center = self.view.center;
	
}

#pragma mark - orientation methods

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

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
