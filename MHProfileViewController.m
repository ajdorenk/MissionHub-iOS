//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileViewController.h"

@interface MHProfileViewController ()

@end

@implementation MHProfileViewController

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

-(void) awakeFromNib
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ParallaxedViewController"];
    UITableViewController * tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    
    [self setupWithTopViewController:vc height:100 tableViewController:tvc];
}

@end
