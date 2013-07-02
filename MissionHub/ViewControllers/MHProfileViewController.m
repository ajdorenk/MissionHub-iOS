//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileViewController.h"
#import "MHParallaxTopViewController.h"
//#import "MHCustomNavigationBar.h"


@interface MHProfileViewController ()

@end

@implementation MHProfileViewController

//@synthesize addLabelButton, addTagButton, backMenuButton;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    UIImage* labelImage = [UIImage imageNamed:@"NewInteraction_Icon.png"];
    UIButton *newLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, labelImage.size.width, labelImage.size.height)];
    [newLabel setImage:labelImage forState:UIControlStateNormal];
    [newLabel addTarget:self action:@selector(addLabelActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addLabelButton = [[UIBarButtonItem alloc] initWithCustomView:newLabel];
    
    UIImage* tagImage = [UIImage imageNamed:@"topbarTag_button.png"];
    UIButton *newTag = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tagImage.size.width, tagImage.size.height)];
    [newTag setImage:tagImage forState:UIControlStateNormal];
    [newTag addTarget:self action:@selector(addTagActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addTagButton = [[UIBarButtonItem alloc] initWithCustomView:newTag];
    
    UIImage* otherOptionImage = [UIImage imageNamed:@"topbarOtherOptions_button.png"];
    UIButton *otherOptions = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, otherOptionImage.size.width, otherOptionImage.size.height)];
    [otherOptions setImage:otherOptionImage forState:UIControlStateNormal];
    [otherOptions addTarget:self action:@selector(addTagActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *otherOptionsButton = [[UIBarButtonItem alloc] initWithCustomView:otherOptions];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:otherOptionsButton, addTagButton, addLabelButton, nil]];
    
    
    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, menuImage.size.width, menuImage.size.height)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMenu:(id)sender {
 
 [self dismissViewControllerAnimated:NO completion:Nil];
 //[self.slidingViewController anchorTopViewTo:ECRight];
 
 }
 - (IBAction)addTagActivity:(id)sender {
 NSLog(@"add Person Action");
 }
 - (IBAction)addLabelActivity:(id)sender {
 NSLog(@"Label Action");
 }
 
 

-(void) awakeFromNib
{
    MHParallaxTopViewController * topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ParallaxedViewController"];
    UITableViewController * tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    UITableViewController * segmentedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segmentedViewController"];
    
    
    [self setupWithTopViewController:topViewController height:150 tableViewController:tableViewController segmentedViewController:segmentedViewController];
    
    [((MHParallaxTopViewController *)self.topViewController).menu setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)handleTapGesture:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Yup" message:@"You pressed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}



////////////////////////////////////////////////////////////////////////
#pragma mark - TapGesture Delegate
////////////////////////////////////////////////////////////////////////

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint tapPoint = [touch locationInView:self.view];
    if ([((MHParallaxTopViewController *)self.topViewController).menu hitTest:tapPoint withEvent:nil]) {
        return YES;
    }
    return NO;
}


@end
