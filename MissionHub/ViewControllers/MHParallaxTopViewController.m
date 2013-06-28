//
//  MHParallaxTopViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/27/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHParallaxTopViewController.h"
#import "MHProfileViewController.h"

@interface MHParallaxTopViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (strong, nonatomic) IBOutlet UIImageView *gradientImageView;
@end


@implementation MHParallaxTopViewController

@synthesize menu;

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
    self.imageView.image = [UIImage imageNamed:@"bg.jpg"];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)]];

//    NSArray *itemArray = [NSArray arrayWithObjects: @"Info", @"Interactions", nil];
//    SDSegmentedControl *segmentedControl = [[SDSegmentedControl alloc] initWithItems:itemArray];
//    segmentedControl.frame = CGRectMake(0, 100, 320, 50);
//    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
//    segmentedControl.selectedSegmentIndex = 1;
//    
//    [self.view addSubview:segmentedControl];
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
    NSLog(@"Works");
}

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[SDSegmentedControl class]]) {
        return YES;
    }
    return NO;
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentSwitch:(id)sender {
    
    if (self.menu.selectedSegmentIndex == 0) {
        NSLog(@"Clicked");
    }
    else{
        
    }
}


- (void)willChangeHeightFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight {
    
    M6ParallaxController *parallaxController = [self parallaxController];
    
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, (newHeight + self.menu.frame.size.height));
    
    if (newHeight >= parallaxController.topViewControllerStandartHeight) {
        
        [self.imageView setAlpha:1];
    //    float r = (parallaxController.topViewControllerStandartHeight * 1.25f) / newHeight;
        //[self.gradientImageView setAlpha:r*r];
        //self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, newHeight);
        
    } else {
        
        float r = newHeight / parallaxController.topViewControllerStandartHeight;
        [self.imageView setAlpha:r];
        
       // [self.gradientImageView setAlpha:r*r*r*r];

    }
    
}


@end
