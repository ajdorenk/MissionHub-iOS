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
@synthesize loadingRequestDictionary = _loadingRequestDictionary;
@synthesize requestOptions = _requestOptions;
@synthesize refreshController = _refreshController;
@synthesize isLoading = _isLoading;
@synthesize hasLoadedAllPages = _hasLoadedAllPages;
@synthesize header = _header;

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.peopleArray = [NSMutableArray array];
	self.loadingRequestDictionary = [NSMutableDictionary dictionary];
	self.requestOptions = [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
	
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
    [genderButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderLabels.png"] forState:UIControlStateNormal];
	
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
    [allButton setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"] forState:UIControlStateNormal];
    
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

-(void)refresh {
	
	[self.refreshController beginRefreshing];
	[self dropViewDidBeginRefreshing:self.refreshController];
	
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
	[self.tableView reloadData];
	
    [[MHAPI sharedInstance] getPeopleListWith:self.requestOptions
								 successBlock:^(NSArray *result, MHRequestOptions *options) {
		
									 self.peopleArray =  [NSMutableArray arrayWithArray:result];
									 [self.tableView reloadData];
									 [self.refreshController endRefreshing];
									 
									 
	}
									failBlock:^(NSError *error, MHRequestOptions *options) {
										
										[MHErrorHandler presentError:error];
										[self.tableView reloadData];
										[self.refreshController endRefreshing];
		
	}];
}

-(void)setDataFromRequestOptions:(MHRequestOptions *)options {
	
	[self setDataArray:nil forRequestOptions:options];
	
}

-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options {
	
	self.requestOptions = (options ? options : [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]);
	self.isLoading = NO;
	
	if (dataArray == nil) {
		
		[self.peopleArray removeAllObjects];
		self.hasLoadedAllPages = NO;
		[self refresh];
		
	} else {
		
		self.peopleArray = [NSMutableArray arrayWithArray:dataArray];
		self.hasLoadedAllPages = ( [dataArray count] < options.limit ? YES : NO );
		
	}
	
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return [self.peopleArray count] + 1;

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
		
		if (self.hasLoadedAllPages) {
			
			[cell showFinishedMessage];
			
		} else {
			
			[cell startLoading];
			
		}
		
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
	
	
	if (!self.hasLoadedAllPages && !self.isLoading) {
		
		if (indexPath.row + 5 >= [self.peopleArray count]) {
			
			[self.requestOptions configureForNextPageRequest];

			self.isLoading = YES;
			
			[[MHAPI sharedInstance] getPeopleListWith:self.requestOptions
										 successBlock:^(NSArray *result, MHRequestOptions *options) {
											 
											 //remove loading cell if it has been displayed
											 self.isLoading = NO;
											 
											 self.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
											 
											 //update array with results
											 [self.peopleArray addObjectsFromArray:result];
											 [self.tableView reloadData];
											 
										 }
											failBlock:^(NSError *error, MHRequestOptions *options) {
												
												NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
												NSError *presentingError = [NSError errorWithDomain:error.domain
																							   code:error.code
																						   userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
												
												[MHErrorHandler presentError:presentingError];
												
												self.isLoading = NO;
												[self.tableView reloadData];
												
											}];
			
		}
		
	}
	
	
	
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
    
