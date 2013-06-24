//
//  MHPeopleListViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPeopleListViewController.h"

#import <Foundation/Foundation.h>
#import "MHPersonCell.h"
#import "MHMenuToolbar.h"   
#import "MHPeopleSearchBar.h" 
#import "MHGenderListController.h"  

@interface Person : NSObject

@property (nonatomic, strong) NSString *name; // name of Person
@property (nonatomic, strong) NSString *gender; // Person gender
@property (nonatomic, strong) NSString *profilePicturePath; // image filename of Person

@end


@implementation Person

@synthesize name;
@synthesize gender;
@synthesize profilePicturePath;

@end



/*@interface MHgenderListController ()

@end

@implementation MHgenderListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end

*/
@interface MHPeopleListViewController (Private)
-(void)setTextFieldLeftView;
@end

@implementation MHPeopleListViewController

@synthesize persons = _persons;


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
    
    [self.backMenuButton setBackgroundImage:[UIImage imageNamed:@"BackMenu_Icon.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.addPersonButton setBackgroundImage:[UIImage imageNamed:@"NewContact_Icon.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.addLabelButton setBackgroundImage:[UIImage imageNamed:@"NewInteraction_Icon.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.peopleListToolbar.layer.shadowOpacity = 0.3f;
    self.peopleListToolbar.layer.shadowRadius = 1.0f;
    self.peopleListToolbar.layer.shadowColor = [UIColor blackColor].CGColor;
    
    

    self.peopleSearchBar.layer.shadowOpacity = 0.3f;
    self.peopleSearchBar.layer.shadowRadius = 2.0f;
    self.peopleSearchBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.peopleSearchBar.placeholder = @"Search";
    UITextField *text = [[self.peopleSearchBar subviews] objectAtIndex:1];
    [text setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    [self.peopleSearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Searchbar_background.png"] forState:UIControlStateNormal];
    
    
	
}

- (void)viewDidLoad
{
    
    [self setTextFieldLeftView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    Person *person1 = [Person new];
    person1.name = @"Ann Anderson";
    person1.gender = @"Female";
    person1.profilePicturePath = @"anderson-ann.jpg";

    Person *person2 = [Person new];
    person2.name = @"George Frank";
    person2.gender = @"Male";
    person2.profilePicturePath = @"anderson-ann.jpg";

    
    Person *person3 = [Person new];
    person3.name = @"Lola Gates";
    person3.gender = @"Female";
    person3.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person4 = [Person new];
    person4.name = @"Michael Mason";
    person4.gender = @"Male";
    person4.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person5 = [Person new];
    person5.name = @"Amy Leslie";
    person5.gender = @"Female";
    person5.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person6 = [Person new];
    person6.name = @"Jessica Davis";
    person6.gender = @"Male";
    person6.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person7 = [Person new];
    person7.name = @"Sally Fields";
    person7.gender = @"Female";
    person7.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person8 = [Person new];
    person8.name = @"Katherine Budincich";
    person8.gender = @"Male";
    person8.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person9 = [Person new];
    person9.name = @"Leslie Marks";
    person9.gender = @"Female";
    person9.profilePicturePath = @"anderson-ann.jpg";
    
    Person *person10 = [Person new];
    person10.name = @"Kate Middleton";
    person10.gender = @"Male";
    person10.profilePicturePath = @"anderson-ann.jpg";
    
    self.persons = [NSArray arrayWithObjects:person1, person2, person3, person4, person5, person6, person7, person8, person9, person10, nil];
    
    


}

- (void)setTextFieldLeftView
{
    UITextField *searchField = nil;
    for (UIView *subview in self.peopleSearchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchField = (UITextField *)subview;
            break;
        }
    }
    
    if (searchField)
    {
        UIImage *image = [UIImage imageNamed:@"searchbar_image.png"];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        searchField.leftView = view;
    }
    
}


- (IBAction)revealMenu:(id)sender {
	
	[self.slidingViewController anchorTopViewTo:ECRight];
	
}

-(IBAction)addPersonActivity:(id)sender{
    NSLog(@"add Person Action");
}

-(IBAction)addLabelActivity:(id)sender {
    NSLog(@"Label Action");
}

-(IBAction)checkAllContacts:(id)sender {
    NSLog(@"Check all");
}

-(IBAction)chooseGender:(id)sender {
    NSLog(@"chooseGender");

    UIStoryboard *storyboard = self.storyboard;
    MHGenderListController *genders = [storyboard
                  instantiateViewControllerWithIdentifier:@"genderList"];
    [self presentViewController:genders animated:YES completion:Nil];
}

-(IBAction)sortOnOff:(id)sender {
    NSLog(@"Toggle sort");
}


/*@synthesize Sublabel;
*/




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"MyCell";
        MHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
        if (cell == nil) {
            cell = [[MHPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        //Display person in the table cell
        Person *person = [self.persons objectAtIndex:indexPath.row];
        cell.profilePicture.image = [UIImage imageNamed:person.profilePicturePath];
        cell.gender.text = person.gender;
        cell.name.text = person.name;
        
        return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    sectionHeader.backgroundColor = [UIColor grayColor];
 
 UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 6.5, 20, 20.0)];
    headerLabel.textColor = [UIColor whiteColor];
 headerLabel.backgroundColor = [UIColor clearColor];
 headerLabel.textAlignment = NSTextAlignmentLeft;
 [sectionHeader addSubview:headerLabel];
 
 headerLabel.text = @"All";
    
    //Add genderButton
    UIButton *genderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [genderButton setFrame:CGRectMake(94, 5.0, 154.0, 22.0)];
    //[button setTitle:@"Gender" forState:UIControlStateNormal];
    [genderButton setTintColor:[UIColor clearColor]];
    [genderButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderGender.png"] forState:UIControlStateNormal];

    [genderButton setBackgroundColor:[UIColor clearColor]];
    [genderButton addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:genderButton];
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sortButton setFrame:CGRectMake(266, 5.0, 50.0, 22.0)];
    //[button setTitle:@"Sort" forState:UIControlStateNormal];
    [sortButton setTintColor:[UIColor clearColor]];
    [sortButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderSort.png"] forState:UIControlStateNormal];
    
    [sortButton setBackgroundColor:[UIColor clearColor]];
    [sortButton addTarget:self action:@selector(sortOnOff:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:sortButton];
    
    
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [allButton setFrame:CGRectMake(13.0, 9.0, 14.0, 14.0)];
    //[button setTitle:@"Sort" forState:UIControlStateNormal];
    [allButton setTintColor:[UIColor clearColor]];
    [allButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderAll.png"] forState:UIControlStateNormal];
    
    [allButton setBackgroundColor:[UIColor clearColor]];
    [allButton addTarget:self action:@selector(checkAllContacts:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:allButton];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0;
}
 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
       *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(indexPath.row==0){
            [self performSegueWithIdentifier:@"MHSublabel" sender:self];
        }

    
}



//-(void)addPersonPressed:(id)sender
//{
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*-(void)roleTableViewCell:(MHLabelSelectorCell *)cell didTapIconWithRoleItem:(MHLabelSelectorCell *)roleItem {
	
	if ([self.selectedRoles hasRole:roleItem]) {
		
		[self.selectedRoles removeRole:roleItem];
		[cell setChecked:NO];
		
	} else {
		
		[self.selectedRoles addRole:roleItem];
		[cell setChecked:YES];
		
	}
	
	//[self.tableView reloadData];
	
}
*/


@end
