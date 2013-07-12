//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHProfileViewController.h"
#import "MHParallaxTopViewController.h"
//#import "MHNewInteractionViewController.h"
//#import "MHCustomNavigationBar.h"


@interface MHProfileViewController ()

@property (nonatomic, strong) NSArray *allViewControllers;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) IBOutlet SDSegmentedControl *switchViewControllers;

@end


@implementation MHProfileViewController

@synthesize toolbar, table;
@synthesize _person;
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
    
    [self.switchViewControllers addTarget:self action:@selector(controlSegmentSwitch:) forControlEvents:UIControlEventValueChanged];

}

-(void)setPerson:(MHPerson *)person {
	
	if (person) {
		
		self._person = person;
		
		
		
	}
	
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

 - (IBAction)addLabelActivity:(id)sender {
 NSLog(@"add Person Action");
 }

 - (IBAction)newInteractionActivity:(id)sender {
 NSLog(@"Interaction Action");
     MHNewInteractionViewController *newInteraction = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNewInteractionViewController"];
     [self.navigationController pushViewController:newInteraction animated:YES];
     
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
    
    [self.switchViewControllers setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
	
	self.person = [MHAPI sharedInstance].currentUser;
    
}


- (IBAction)controlSegmentSwitch:(SDSegmentedControl *)segmentedControl{
    NSLog(@"Clicked");

    if (segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"switched");

        
    }
    else{
    
    }
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
