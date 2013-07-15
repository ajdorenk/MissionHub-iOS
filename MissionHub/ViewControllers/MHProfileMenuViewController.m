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

@synthesize menuDelegate;
@synthesize segmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)menuDidChangeSelection:(id)sender {
	
	if ([self.menuDelegate respondsToSelector:@selector(menuDidChangeSelection:)]) {
		
		[self.menuDelegate menuDidChangeSelection:self.segmentedControl.selectedSegmentIndex];
		
	}
	
}

-(void)setMenuSelection:(NSInteger)selection {
	
	[self.segmentedControl setSelectedSegmentIndex:selection];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
