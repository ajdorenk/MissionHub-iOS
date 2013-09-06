//
//  MHActivityViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 9/5/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHActivityViewController.h"

@interface MHActivityViewController ()

@end

@implementation MHActivityViewController

+ (NSArray *)allActivities {
	
	MHLabelActivity *labelActivity				= [[MHLabelActivity alloc] init];
	MHAssignActivity *assignActivity			= [[MHAssignActivity alloc] init];
	MHPermissionsActivity *permissionsActivity	= [[MHPermissionsActivity alloc] init];
	MHDeleteActivity *deleteActivity			= [[MHDeleteActivity alloc] init];
	MHArchiveActivity *archiveActivity			= [[MHArchiveActivity alloc] init];
	MHEmailActivity *emailActivity				= [[MHEmailActivity alloc] init];
	MHTextActivity *textActivity				= [[MHTextActivity alloc] init];

	return @[ deleteActivity, archiveActivity, permissionsActivity, assignActivity, labelActivity, emailActivity, textActivity ];
	
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
