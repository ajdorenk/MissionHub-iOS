//
//  MHNewInteractionViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 7/9/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//


#import "MHNewInteractionViewController.h"
#import "MHInteraction.h"

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

-(void)awakeFromNib {
	
	[super awakeFromNib];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.datePicker setHidden:YES];
    
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
    
    
    UIImage *whiteButton = [UIImage imageNamed:@"Searchbar_background.png"];
    [initiator setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [initiator setTintColor:[UIColor clearColor]];
    [initiator setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [initiator setBackgroundColor:[UIColor clearColor]];    
    [initiator.layer setBorderWidth:1.0];
    [initiator.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1] CGColor]];
    

    
    [interaction setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [interaction setTintColor:[UIColor clearColor]];
    [interaction setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [interaction setBackgroundColor:[UIColor clearColor]];
    [interaction.layer setBorderWidth:1.0];
    [interaction.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    [receiver setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [receiver setTintColor:[UIColor clearColor]];
    [receiver setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [receiver setBackgroundColor:[UIColor clearColor]];
    [receiver.layer setBorderWidth:1.0];
    [receiver.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    [visibility setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [visibility setTintColor:[UIColor clearColor]];
    [visibility setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [visibility setBackgroundColor:[UIColor clearColor]];
    [visibility.layer setBorderWidth:1.0];
    [visibility.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    
    [dateTime setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [dateTime setTintColor:[UIColor clearColor]];
    [dateTime setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [dateTime setBackgroundColor:[UIColor clearColor]];
    [dateTime.layer setBorderWidth:1.0];
    [dateTime.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor]];
    [dateTime addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 300, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=[UIColor whiteColor];

    [self.view addSubview:label];
    
    comment.layer.backgroundColor = [[UIColor whiteColor]CGColor];
    comment.layer.borderColor=[[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]CGColor];
    comment.layer.borderWidth= 1.0f;
    
    [self.comment addTarget:self action:@selector(registerForKeyboardNotifications) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveInteractionActivity:(id)sender {
    NSLog(@"Save Interaction"); 
}

-(IBAction)showDatePicker:(UIButton *)saveButton{
    [self.datePicker setHidden:NO];
    //self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    [self.datePicker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor blackColor];
    
    UIImage* doneImage = [UIImage imageNamed:@"MH_Mobile_Button_Done_72.png"];
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [done setImage:doneImage forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneWithDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:done];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
    
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
   // [dateFormatter setDateStyle:NSDateFormatterLongStyle];
   // [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    dateFormatter.dateFormat = @"dd MMM yyyy                  HH:mm";
    
    [self.dateTime setTitle: [dateFormatter stringFromDate:[sender date]] forState: UIControlStateNormal];
    self.dateTime.titleLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:18.0];
    [self.dateTime setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];

    
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);

}

-(IBAction)doneWithDatePicker:(id)sender{
    NSLog(@"remove");
    [self.datePicker setHidden:YES];
    UIImage* saveImage = [UIImage imageNamed:@"MH_Mobile_Button_Save_72.png"];
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 35)];
    [save setImage:saveImage forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveInteractionActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:save];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:saveButton, nil]];

}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = self.activeField.frame.origin;
    origin.y -= self.scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-(aRect.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}



- (IBAction)backToMenu:(id)sender {
    NSLog(@"works");
    [self.navigationController popViewControllerAnimated:YES];
}



@end
