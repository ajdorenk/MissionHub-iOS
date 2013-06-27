//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

//
//  MHProfileViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/24/13.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (IBAction)backToMenu:(id)sender {
 
 [self dismissViewControllerAnimated:NO completion:Nil];
 //[self.slidingViewController anchorTopViewTo:ECRight];
 
 }
 - (IBAction)addTagActivity:(id)sender {
 NSLog(@"add Person Action");
 }
 - (IBAction)addLabelActivity:(id)sender {
 NSLog(@"Label Action");
 }
 
 */

-(void) awakeFromNib
{
    MHParallaxTopViewController * topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ParallaxedViewController"];
    UITableViewController * tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTableViewController"];
    
    [self setupWithTopViewController:topViewController height:150 tableViewController:tableViewController];
    
    [((MHParallaxTopViewController *)self.topViewController).menu setUserInteractionEnabled:YES];
    
    
    /*UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];*/
    
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
