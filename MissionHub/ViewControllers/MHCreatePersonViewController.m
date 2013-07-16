//
//  MHCreatePersonViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/15/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHCreatePersonViewController.h"

@interface MHCreatePersonViewController ()

@end

@implementation MHCreatePersonViewController

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

    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    
    
    UIImage* saveImage = [UIImage imageNamed:@"MH_Mobile_Button_Save_72.png"];
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [save setImage:saveImage forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveInteractionActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveButton, nil]];
    
    
    
    CGRect frame = self.maleFemaleControl.frame;
    frame.size.height = 26;
    [self.maleFemaleControl setFrame:frame];

    self.firstName.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.firstName.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.firstName.layer.borderWidth= 1.0f;
    
    self.lastName.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.lastName.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.lastName.layer.borderWidth= 1.0f;

    self.email.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.email.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.email.layer.borderWidth= 1.0f;

    self.phone.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.phone.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.phone.layer.borderWidth= 1.0f;
    
    self.address1.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.address1.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.address1.layer.borderWidth= 1.0f;

    self.address2.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.address2.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.address2.layer.borderWidth= 1.0f;

    self.city.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.city.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.city.layer.borderWidth= 1.0f;

    self.zip.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    self.zip.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    self.zip.layer.borderWidth= 1.0f;

}


-(IBAction)saveInteractionActivity:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backToMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
