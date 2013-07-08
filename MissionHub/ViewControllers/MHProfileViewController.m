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

@property (nonatomic, strong) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) IBOutlet SDSegmentedControl *switchViewControllers;

@end


@implementation MHProfileViewController

//@synthesize addLabelButton, addTagButton, backMenuButton;
@synthesize switchViewControllers;
//@synthesize menu;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UITableViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController1"];
    
    // Create the penalty view controller
    UITableViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController2"];
    
    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:vc1, vc2, nil];
    
    // Ensure a view controller is loaded
    self.switchViewControllers.selectedSegmentIndex = 0;
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.switchViewControllers.selectedSegmentIndex]];
    
   
    UIImage* newInteractionImage = [UIImage imageNamed:@"NewInteraction_Icon.png"];
    UIButton *newInteraction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [newInteraction setImage:newInteractionImage forState:UIControlStateNormal];
    [newInteraction addTarget:self action:@selector(newInteractionActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newInteractionButton = [[UIBarButtonItem alloc] initWithCustomView:newInteraction];
    
    UIImage* labelImage = [UIImage imageNamed:@"topbarTag_button.png"];
    UIButton *newLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [newLabel setImage:labelImage forState:UIControlStateNormal];
    [newLabel addTarget:self action:@selector(addLabelActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addLabelButton = [[UIBarButtonItem alloc] initWithCustomView:newLabel];
    
    UIImage* otherOptionImage = [UIImage imageNamed:@"topbarOtherOptions_button.png"];
    UIButton *otherOptions = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [otherOptions setImage:otherOptionImage forState:UIControlStateNormal];
    [otherOptions addTarget:self action:@selector(addTagActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *otherOptionsButton = [[UIBarButtonItem alloc] initWithCustomView:otherOptions];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:otherOptionsButton, addLabelButton, newInteractionButton, nil]];
    
    
    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    
    [self.toolbar setTranslucent:YES];

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
 - (IBAction)addLabelActivity:(id)sender {
 NSLog(@"add Person Action");
 }
 - (IBAction)newInteractionActivity:(id)sender {
 NSLog(@"Label Action");
 }
 
 

-(void) awakeFromNib
{
    MHParallaxTopViewController * topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ParallaxedViewController"];
    UITableViewController * tableViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController1"];
    UITableViewController * tableViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController2"];
    UITableViewController * segmentedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segmentedViewController"];
    
    if (self.switchViewControllers.selectedSegmentIndex == 0) {
        [self setupWithTopViewController:topViewController height:150 tableViewController:tableViewController1 segmentedViewController:segmentedViewController];
    }
    else{
        
        [self setupWithTopViewController:topViewController height:150 tableViewController:tableViewController2 segmentedViewController:segmentedViewController];
    }
    
    [((MHParallaxTopViewController *)self.topViewController).menu setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)cycleFromViewController:(UIViewController *)oldVC
             toViewController:(UIViewController*)newVC{
    if (newVC == oldVC) return;
    
    if (newVC) {
        newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        

            
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
        
        
        } else {
            
            [self addChildViewController:newVC];
            
            // Add the new view controller view to the ciew hierarchy
            [self.view addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    NSUInteger index = sender.selectedSegmentIndex;
    NSLog(@"This is changing");
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
    }
    
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
