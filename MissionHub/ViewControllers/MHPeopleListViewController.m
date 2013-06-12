//
//  MHPeopleListViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPeopleListViewController.h"

#import <Foundation/Foundation.h>
#import "MHSublabel.h"


@interface Person : NSObject

@property (nonatomic, strong) NSString *name; // name of Person
@property (nonatomic, strong) NSString *gender; // Person gender
@property (nonatomic, strong) NSString *imageFile; // image filename of Person

@end


@implementation Person

@synthesize name;
@synthesize gender;
@synthesize imageFile;

@end





@interface MHPeopleListViewController ()

@end

@implementation MHPeopleListViewController{
    NSArray *persons;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;
	
	if (![self.slidingViewController.underLeftViewController isKindOfClass:[MHMenuViewController class]]) {
		self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
	}
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    Person *person1 = [Person new];
    person1.name = @"Ann Anderson";
    person1.gender = @"Female";
    person1.imageFile = @"anderson-ann.jpg";

    Person *person2 = [Person new];
    person2.name = @"George Frank";
    person2.gender = @"Male";
    person2.imageFile = @"anderson-ann.jpg";
    
    persons = [NSArray arrayWithObjects:person1, person2, nil];
    
   /* self.Sublabel = [[MHSublabel alloc] initWithFrame:CGRectMake(100.0, 100.0, 50.0, 50.0)];
    self.Sublabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.Sublabel];
*/


}

- (IBAction)revealMenu:(id)sender {
	
	[self.slidingViewController anchorTopViewTo:ECRight];
	
}

/*@synthesize Sublabel;
*/




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Display person in the table cell
    Person *person = [persons objectAtIndex:indexPath.row];
    UIImageView *personImageView = (UIImageView *)[cell viewWithTag:100];
    personImageView.image = [UIImage imageNamed:person.imageFile];
    
    UILabel *personNameLabel = (UILabel *)[cell viewWithTag:101];
    personNameLabel.text = person.name;
    
    UILabel *personGenderLabel = (UILabel *)[cell viewWithTag:102];
    personGenderLabel.text = person.gender;
    
    UIImageView *nameBackgroundView = (UIImageView *)[cell viewWithTag:103];
    nameBackgroundView.layer.borderColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0].CGColor;
    nameBackgroundView.layer.borderWidth = 1.0;
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(indexPath.row==0){
            [self performSegueWithIdentifier:@"MHSublabel" sender:self];
        }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
