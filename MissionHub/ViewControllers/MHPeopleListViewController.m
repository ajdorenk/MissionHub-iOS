//
//  MHPeopleListViewController.m
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHPeopleListViewController.h"

#import "MHAPI.h"
#import "MHPersonCell.h"
#import "MHLoadingCell.h"
#import "MHMenuToolbar.h"   
#import "MHPeopleSearchBar.h" 
#import "MHGenderListController.h"

#define HEADER_HEIGHT 32.0f
#define ROW_HEIGHT 61.0f


@interface MHPeopleListViewController (Private)

-(void)setTextFieldLeftView;
-(void)populateCell:(MHPersonCell *)personCell withPerson:(MHPerson *)person;
@end

@implementation MHPeopleListViewController

@synthesize peopleSearchBar;
@synthesize peopleArray = _peopleArray;
@synthesize requestOptions = _requestOptions;
@synthesize refreshController = _refreshController;
@synthesize isLoading = _isLoading;
@synthesize hasLoadedAllPages = _hasLoadedAllPages;
@synthesize header = _header;

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.peopleArray = [NSMutableArray array];
	self.requestOptions = [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
	
	UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    sectionHeader.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
	
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 6.5, 20, 20.0)];
    headerLabel.textColor = [UIColor whiteColor];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textAlignment = NSTextAlignmentLeft;
	[sectionHeader addSubview:headerLabel];
	
	headerLabel.text = @"All";
    
    //Add genderButton
    UIButton *genderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [genderButton setFrame:CGRectMake(94, 5.0, 154.0, 22.0)];
    }
    else{
        [genderButton setFrame:CGRectMake(420, 5.0, 270.0, 22.0)];
    }
    //[button setTitle:@"Gender" forState:UIControlStateNormal];
    [genderButton setTintColor:[UIColor clearColor]];
    [genderButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderLabels.png"] forState:UIControlStateNormal];
	
    [genderButton setBackgroundColor:[UIColor clearColor]];
    [genderButton addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:genderButton];
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [sortButton setFrame:CGRectMake(261, 5.0, 55.0, 22.0)];
    }
    else{
        [sortButton setFrame:CGRectMake(700, 5.0, 55.0, 22.0)];
    }
    //[button setTitle:@"Sort" forState:UIControlStateNormal];
    [sortButton setTintColor:[UIColor clearColor]];
    [sortButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderSort.png"] forState:UIControlStateNormal];
    [sortButton setTitle:@"Sort: off" forState:UIControlStateNormal];
    [sortButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    
    
    [sortButton setBackgroundColor:[UIColor clearColor]];
    [sortButton addTarget:self action:@selector(sortOnOff:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:sortButton];
    
    
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *uncheckedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"];
    [allButton setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [allButton setTintColor:[UIColor clearColor]];
    [allButton setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    
    [allButton setBackgroundColor:[UIColor clearColor]];
    [allButton addTarget:self action:@selector(checkAllContacts:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:allButton];
	
	self.header = sectionHeader;
	
}

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
	
	self.refreshController = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.refreshController addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    UIImage* contactImage = [UIImage imageNamed:@"NewContact_Icon.png"];
    UIButton *newPerson = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 34)];
    [newPerson setImage:contactImage forState:UIControlStateNormal];
    [newPerson addTarget:self action:@selector(addPersonActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addPersonButton = [[UIBarButtonItem alloc] initWithCustomView:newPerson];
    
    UIImage* labelImage = [UIImage imageNamed:@"NewInteraction_Icon.png"];
    UIButton *newLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 34)];
    [newLabel setImage:labelImage forState:UIControlStateNormal];
    [newLabel addTarget:self action:@selector(addLabelActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addLabelButton = [[UIBarButtonItem alloc] initWithCustomView:newLabel];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addLabelButton, addPersonButton, nil]];
    

    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 34, 34)];
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

	
    MHPerson *person2 =[MHPerson newObjectFromFields:@{@"id":@1234,@"first_name":@"Bessie",
                        @"last_name":@"Steinberg",
                        @"gender":@"Female",
                        @"year_in_school":@"Fourth Year",
                        @"major":@" Philosophy",
                        @"minor":@"Computer Engineering",
                        @"birth_date":@"1992-06-07",
                        @"date_became_christian":@"2000-01-01",
                        @"graduation_date":@"2010-01-07",
                        @"user_id":@12345,
                        @"fb_uid":@123456,
                        @"updated_at":@"2012-11-19T19:29:30:06:00",
                        @"created_at":@"2002-11-28T00:00:00:06:00"
                        }];
    

    MHPerson *person3 =[MHPerson newObjectFromFields:@{@"id":@1234,@"first_name":@"Meagan",
                        @"last_name":@"Moran",
                        @"gender":@"Female",
                        @"year_in_school":@"Fourth Year",
                        @"major":@" Mechanical Engineering",
                        @"minor":@"Innovation",
                        @"birth_date":@"1992-06-07",
                        @"date_became_christian":@"2000-01-01",
                        @"graduation_date":@"2010-01-07",
                        @"user_id":@12345,
                        @"fb_uid":@123456,
                        @"updated_at":@"2012-11-19T19:29:30:06:00",
                        @"created_at":@"2002-11-28T00:00:00:06:00"
                        }];
    
    
  /*
    self.persons = [NSArray arrayWithObjects:person1, person2, person3, person4, person5, person6, person7, person8, person9, person10, nil];
    
	self.persons = @[];
    */
    
    self.peopleArray = [NSArray arrayWithObjects:person1, person2, person3, nil];
	
	/*
	[[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
																								  [UIColor blueColor],
																								  UITextAttributeTextColor,
																								  [UIColor darkGrayColor],
																								  UITextAttributeTextShadowColor,
																								  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
																								  UITextAttributeTextShadowOffset,
																								  nil]
																						forState:UIControlStateNormal];
	 */


}


- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
	self.isLoading = NO;
	[self.tableView reloadData];
	
    [[MHAPI sharedInstance] getPeopleListWith:self.requestOptions
								 successBlock:^(NSArray *result, MHRequestOptions *options) {
		
									 self.peopleArray =  [NSMutableArray arrayWithArray:result];
									 self.isLoading = NO;
									 [self.tableView reloadData];
									 [self.refreshController endRefreshing];
									 
									 
	}
									failBlock:^(NSError *error, MHRequestOptions *options) {
										
										[MHErrorHandler presentError:error];
										self.isLoading = NO;
										[self.tableView reloadData];
										[self.refreshController endRefreshing];
		
	}];
}

-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options {
	
	self.requestOptions = (options ? options : [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]);
	self.peopleArray = [NSMutableArray arrayWithArray:dataArray];
	self.isLoading = NO;
	self.hasLoadedAllPages = ( [dataArray count] < options.limit ? YES : NO );
	[self.tableView reloadData];
	
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

-(IBAction)checkAllContacts:(UIButton*)button {
    NSLog(@"Check all");
    button.selected = !button.selected;
    
    if (button.selected) {
        UIImage *checkedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Checked_24.png"];
        [button setFrame:CGRectMake(13.0, 5.0, 18, 19)];
        [button setBackgroundImage:checkedBox forState:UIControlStateNormal];
    }
    else{
         UIImage *uncheckedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"];
        [button setFrame:CGRectMake(13.0, 9.0, 15, 15)];
        [button setBackgroundImage:uncheckedBox forState:UIControlStateNormal];

    }
}

-(IBAction)chooseGender:(id)sender {
    NSLog(@"chooseGender");

    UIStoryboard *storyboard = self.storyboard;
    UIViewController *genders = [storyboard
                  instantiateViewControllerWithIdentifier:@"genderList"];
    [self presentViewController:genders animated:YES completion:Nil];
}

-(IBAction)sortOnOff:(UIButton *)button {
    NSLog(@"Toggle sort");
    button.selected = !button.selected;
    
    if (button.selected) {
        [button setTitle:@"Sort: on" forState:UIControlStateNormal];
    }
    else{
        [button setTitle:@"Sort: off" forState:UIControlStateNormal];
    }
        
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger loadingCellCount = 0;
	
	if (self.isLoading && ( (self.tableView.frame.size.height - self.searchDisplayController.searchBar.frame.size.height - HEADER_HEIGHT) < ([self.peopleArray count] * ROW_HEIGHT) )) {
		
		loadingCellCount = 1;
		
	}
	
    // Return the number of rows in the section.
    return [self.peopleArray count] + loadingCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"%f : %f", self.tableView.contentSize.width, self.tableView.contentSize.height);
	//NSLog(@"%f : %f", self.tableView.contentOffset.x, self.tableView.contentOffset.y);
	//NSLog(@"%f : %f", self.tableView.frame.size.width, self.tableView.frame.size.height);
	//NSLog(@"%f, %f, %f, %f, %f", self.searchDisplayController.searchBar.frame.size.height, ROW_HEIGHT, HEADER_HEIGHT,  self.tableView.frame.size.height, self.tableView.contentSize.height);
	
	if (indexPath.row < [self.peopleArray count]) {
		
        static NSString *CellIdentifier = @"MHPersonCell";
        MHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
		// Configure the cell...
			if (cell == nil) {
				cell = [[MHPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
		
		MHPerson *person = [self.peopleArray objectAtIndex:indexPath.row];
			//Display person in the table cell
		
		[cell populateWithPerson:person];
    
        return cell;
		
	} else {
		
		static NSString *CellIdentifier = @"MHLoadingCell";
        MHLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHLoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		[cell startLoading];
		
        return cell;
	}
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	/*if (!self.hasLoadedAllPages && !self.isLoading) {
		
		if (indexPath.row + 5 >= [self.peopleArray count]) {
			
			[self.requestOptions configureForNextPageRequest];
			self.isLoading = YES;
			[self.tableView reloadData];
			
			[[MHAPI sharedInstance] getPeopleListWith:self.requestOptions
										 successBlock:^(NSArray *result, MHRequestOptions *options) {
											 
											 [self.peopleArray addObjectsFromArray:result];
											 self.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
											 self.isLoading = NO;
											 [self.tableView reloadData];
											 
										 }
											failBlock:^(NSError *error, MHRequestOptions *options) {
												
												[MHErrorHandler presentError:error];
												self.isLoading = NO;
												[self.tableView reloadData];
												
											}];
			
		}
		
	}
	*/
	
	
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
    
