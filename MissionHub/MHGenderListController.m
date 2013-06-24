//
//  MHGenderListController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGenderListController.h"
#import "MHPeopleListViewController.h"  

@interface MHGenderListController ()

@end

@implementation MHGenderListController

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


- (IBAction)maleChosen:(id)sender {
    // configure the new view controller explicitly here.
    [self dismissViewControllerAnimated:NO completion:Nil];

}
- (IBAction)femaleChosen:(id)sender {
    [self dismissViewControllerAnimated:NO completion:Nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
