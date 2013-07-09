//
//  MHNewInteractionViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/9/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//


#import "MHNewInteractionViewController.h"

@interface MHNewInteractionViewController ()

@end

@implementation MHNewInteractionViewController

@synthesize initiator, interaction, receiver, visibility, dateTime, comment;


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
    
    
    UIImage* saveImage = [UIImage imageNamed:@"topbarOtherOptions_button.png"];//Wrong image
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [save setImage:saveImage forState:UIControlStateNormal];
    [save addTarget:self action:@selector(addTagActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveButton, nil]];
    
    
    UIImage *uncheckedBox = [UIImage imageNamed:@"Searchbar_background.png"];
    [initiator setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [initiator setTintColor:[UIColor clearColor]];
    [initiator setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [initiator setBackgroundColor:[UIColor clearColor]];    
    [initiator.layer setBorderWidth:1.0];
    [initiator.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1] CGColor]];
    

    
    [interaction setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [interaction setTintColor:[UIColor clearColor]];
    [interaction setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [interaction setBackgroundColor:[UIColor clearColor]];
    [interaction.layer setBorderWidth:1.0];
    [interaction.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    [receiver setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [receiver setTintColor:[UIColor clearColor]];
    [receiver setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [receiver setBackgroundColor:[UIColor clearColor]];
    [receiver.layer setBorderWidth:1.0];
    [receiver.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    [visibility setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [visibility setTintColor:[UIColor clearColor]];
    [visibility setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [visibility setBackgroundColor:[UIColor clearColor]];
    [visibility.layer setBorderWidth:1.0];
    [visibility.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    [dateTime setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [dateTime setTintColor:[UIColor clearColor]];
    [dateTime setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    [dateTime setBackgroundColor:[UIColor clearColor]];
    [dateTime.layer setBorderWidth:1.0];
    [dateTime.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 300, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];

    [self.view addSubview:label];
    
    comment.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    comment.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    comment.layer.borderWidth= 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backToMenu:(id)sender {
    NSLog(@"works");
    [self.navigationController popViewControllerAnimated:YES];
}



@end
