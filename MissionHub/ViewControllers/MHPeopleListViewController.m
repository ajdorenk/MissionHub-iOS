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


@interface MHPeopleListViewController (Private)
-(void)setTextFieldLeftView;
-(void)populateCell:(MHPersonCell *)personCell withPerson:(MHPerson *)person;
@end

@implementation MHPeopleListViewController

@synthesize persons = _persons;


-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    
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

    UIImage* contactImage = [UIImage imageNamed:@"NewContact_Icon.png"];
    UIButton *newPerson = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, contactImage.size.width, contactImage.size.height)];
    [newPerson setImage:contactImage forState:UIControlStateNormal];
    [newPerson addTarget:self action:@selector(addPersonActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addPersonButton = [[UIBarButtonItem alloc] initWithCustomView:newPerson];
    
    UIImage* labelImage = [UIImage imageNamed:@"NewInteraction_Icon.png"];
    UIButton *newLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, labelImage.size.width, labelImage.size.height)];
    [newLabel setImage:labelImage forState:UIControlStateNormal];
    [newLabel addTarget:self action:@selector(addLabelActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addLabelButton = [[UIBarButtonItem alloc] initWithCustomView:newLabel];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addLabelButton, addPersonButton, nil]];
    

    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, menuImage.size.width, menuImage.size.height)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;

	
	MHPerson *person1 =[MHPerson newObjectFromFields:@{@"id":@1234,@"first_name":@"John",
	 @"last_name":@"Doe",
	 @"gender":@"Male",
	 @"year_in_school":@"Second Year",
	 @"major":@" Philosophy",
	 @"minor":@"Computer Science",
	 @"birth_date":@"1982-07-07",
	 @"date_became_christian":@"2000-01-01",
	 @"graduation_date":@"2010-01-07",
	 @"user_id":@12345,
	 @"fb_uid":@123456,
	 @"updated_at":@"2012-11-19T19:29:30:06:00",
	 @"created_at":@"2002-11-28T00:00:00:06:00"
	 }];
	
    /*
	// Do any additional setup after loading the view.
    MHPerson *person1 =[MHPerson newObjectFromFields:@{@"id":@1234,@"first_name":@"John",
                        @"last_name":@"Doe",
                        @"gender":@"Male",
                        @"year_in_school":@"Second Year",
                        @"major":@"Philosophy",
                        @"minor":@"Computer Science",
                        @"birth_date":@"1982-07-07",
                        @"date_became_christian":@"2000-01-01",
                        @"graduation_date":@"2010-01-07",
                        @"user_id":@12345,
                        @"fb_uid":@123456,
                        @"updated_at":@"2012-11-19T19:29:30-06:00",
                        @"created_at":@"2002-11-28T00:00:00-06:00"
                        }];
    
    
    person1.first_name = @"Ann";
    person1.last_name = @"Anderson";
    person1.gender = @"Female";
    person1.picture = @"anderson-ann.jpg";

    MHPerson *person2 = [MHPerson new];
    person2.first_name = @"George Frank";
    person2.gender = @"Male";
    person2.picture = @"anderson-ann.jpg";

    
    MHPerson *person3 = [MHPerson new];
    person3.first_name = @"Lola Gates";
    person3.gender = @"Female";
    person3.picture = @"anderson-ann.jpg";
    
    MHPerson *person4 = [MHPerson new];
    person4.first_name = @"Michael Mason";
    person4.gender = @"Male";
    person4.picture = @"anderson-ann.jpg";
    
    MHPerson *person5 = [MHPerson new];
    person5.first_name = @"Amy Leslie";
    person5.gender = @"Female";
    person5.picture = @"anderson-ann.jpg";
    
    MHPerson *person6 = [MHPerson new];
    person6.first_name = @"Jessica Davis";
    person6.gender = @"Male";
    person6.picture = @"anderson-ann.jpg";
    
    MHPerson *person7 = [MHPerson new];
    person7.first_name = @"Sally Fields";
    person7.gender = @"Female";
    person7.picture = @"anderson-ann.jpg";
    
    MHPerson *person8 = [MHPerson new];
    person8.first_name = @"Katherine Budincich";
    person8.gender = @"Male";
    person8.picture = @"anderson-ann.jpg";
    
    MHPerson *person9 = [MHPerson new];
    person9.first_name = @"Leslie Marks";
    person9.gender = @"Female";
    person9.picture = @"anderson-ann.jpg";
    
    MHPerson *person10 = [MHPerson new];
    person10.first_name = @"Kate Middleton";
    person10.gender = @"Male";
    person10.picture = @"anderson-ann.jpg";
    
    self.persons = [NSArray arrayWithObjects:person1, person2, person3, person4, person5, person6, person7, person8, person9, person10, nil];
    
	self.persons = @[];
    */
    
    self.persons = [NSArray arrayWithObjects:person1, nil];


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
    UIViewController *genders = [storyboard
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
    
    MHPerson *person = [self.persons objectAtIndex:indexPath.row];
        //Display person in the table cell
    
    [cell populateWithPerson:person];
    
        return cell;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    sectionHeader.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
 
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61.0f;
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
            //[self performSegueWithIdentifier:@"MHSublabel" sender:self];
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
    
