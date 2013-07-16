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
#import "UIImageView+AFNetworking.h"


#define HEADER_HEIGHT 32.0f
#define ROW_HEIGHT 61.0f


@interface MHPeopleListViewController ()

-(void)setTextFieldLeftView;
@property (nonatomic, strong) MHNewInteractionViewController		*_createInteractionViewController;
@property (nonatomic, strong) MHCreatePersonViewController          *_createPersonViewController;

-(MHNewInteractionViewController *)createInteractionViewController;
-(MHCreatePersonViewController *)createPersonViewController;

@end


@implementation MHPeopleListViewController

@synthesize peopleSearchBar;
@synthesize peopleArray				= _peopleArray;
@synthesize searchResultArray		= _searchResultArray;
@synthesize requestOptions			= _requestOptions;
@synthesize searchRequestOptions	= _searchRequestOptions;
@synthesize refreshController		= _refreshController;
@synthesize isLoading				= _isLoading;
@synthesize refreshIsLoading		= _refreshIsLoading;
@synthesize pagingIsLoading			= _pagingIsLoading;
@synthesize hasLoadedAllPages		= _hasLoadedAllPages;
@synthesize searchIsLoading			= _searchIsLoading;
@synthesize searchPagingIsLoading	= _searchPagingIsLoading;
@synthesize searchHasLoadedAllPages	= _searchHasLoadedAllPages;
@synthesize secondaryFieldName		= _secondaryFieldName;
@synthesize fieldButton;
@synthesize sortField				= _sortField;
@synthesize header					= _header;
@synthesize _profileViewController;
@synthesize _fieldSelectorViewController;

-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.peopleArray = [NSMutableArray array];
	self.searchResultArray = [NSMutableArray array];
	self.requestOptions = [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
	self.searchRequestOptions = [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
	
	self.secondaryFieldName = MHPersonSortFieldPermission;
	
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
	[genderButton setTitle:[MHPerson fieldNameForSortField:self.secondaryFieldName] forState:UIControlStateNormal];
    [genderButton addTarget:self action:@selector(chooseGender:) forControlEvents:UIControlEventTouchDown];
    
    [sectionHeader addSubview:genderButton];
	
	self.fieldButton = genderButton;
    
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

-(MHProfileViewController *)profileViewController {
	
	if (self._profileViewController == nil) {
		
		self._profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileViewController"];
		
	}
	
	return self._profileViewController;
	
}

-(MHGenericListViewController *)fieldSelectorViewController {
	
	if (self._fieldSelectorViewController == nil) {
		
		self._fieldSelectorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		self._fieldSelectorViewController.selectionDelegate = self;
		self._fieldSelectorViewController.objectArray = [NSMutableArray arrayWithArray:@[
														 [MHPerson fieldNameForSortField:MHPersonSortFieldGender],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldFollowupStatus],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPermission],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPrimaryPhone],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPrimaryEmail]
														 ]];
		
	}
	
	return self._fieldSelectorViewController;
	
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

    /*id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    
    [barButtonAppearanceInSearchBar setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Button_Save_72.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   [barButtonAppearanceInSearchBar setTitleTextAttributes:@{
                                      UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20],
                                 UITextAttributeTextColor : [UIColor blackColor]
     } forState:UIControlStateNormal];
    [barButtonAppearanceInSearchBar setTitle:@""];*/
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
    
    UIImage* interactionImage = [UIImage imageNamed:@"NewInteraction_Icon.png"];
    UIButton *addInteraction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 34)];
    [addInteraction setImage:interactionImage forState:UIControlStateNormal];
    [addInteraction addTarget:self action:@selector(addInteractionActivity:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addInteractionButton = [[UIBarButtonItem alloc] initWithCustomView:addInteraction];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addInteractionButton, addPersonButton, nil]];
    

    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 34, 34)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;

}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
		case 0:
			self.sortField = MHRequestOptionsOrderPeopleGender;
			self.secondaryFieldName = MHPersonSortFieldGender;
			break;
		case 1:
			self.sortField = MHRequestOptionsOrderPeopleFollowupStatus;
			self.secondaryFieldName = MHPersonSortFieldFollowupStatus;
			break;
		case 2:
			self.sortField = MHRequestOptionsOrderPeoplePermission;
			self.secondaryFieldName = MHPersonSortFieldPermission;
			break;
		case 3:
			self.sortField = MHRequestOptionsOrderPeoplePrimaryPhone;
			self.secondaryFieldName = MHPersonSortFieldPrimaryPhone;
			break;
		case 4:
			self.sortField = MHRequestOptionsOrderPeoplePrimaryEmail;
			self.secondaryFieldName = MHPersonSortFieldPrimaryEmail;
			break;
			
		default:
			break;
	}
	
	[self.fieldButton setTitle:[MHPerson fieldNameForSortField:self.secondaryFieldName] forState:UIControlStateNormal];
	[self dismissViewControllerAnimated:YES completion:nil];
	[self.tableView reloadData];
	
}

-(MHNewInteractionViewController *)createInteractionViewController {
	
	if (self._createInteractionViewController == nil) {
		
		self._createInteractionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNewInteractionViewController"];
		
	}
	
	return self._createInteractionViewController;
	
}


-(MHCreatePersonViewController *)createPersonViewController {
	
	if (self._createPersonViewController == nil) {
		
		self._createPersonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHCreatePersonViewController"];
		
	}
	
	return self._createPersonViewController;
	
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	
	if ([searchString length] > 2) {
		
		[self.searchRequestOptions updateFilter:MHRequestOptionsFilterPeopleNameOrEmailLike withValue:searchString];
		self.searchHasLoadedAllPages = NO;
		self.searchIsLoading = YES;
		
		[[MHAPI sharedInstance] getResultWithOptions:self.searchRequestOptions
										successBlock:^(NSArray *result, MHRequestOptions *options) {
											
											self.searchIsLoading = NO;
											if (options.limit > 0) {
												self.searchHasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
											} else {
												self.searchHasLoadedAllPages = YES;
											}
											
											
											if ([result count] == 0) {
												[self.searchResultArray removeAllObjects];
											} else {
												self.searchResultArray =  [NSMutableArray arrayWithArray:result];
											}
											
											[self.searchDisplayController.searchResultsTableView reloadData];
											
											
										}
										   failBlock:^(NSError *error, MHRequestOptions *options) {
											   
											   NSString *errorMessage = [NSString stringWithFormat:@"Failed to get search results due to: \"%@\". Try again by tapping cancel and starting again. If the problem continues please contact support@missionhub.com", error.localizedDescription];
											   NSError *presentingError = [NSError errorWithDomain:error.domain
																							  code:error.code
																						  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
											   
											   [MHErrorHandler presentError:presentingError];
											   self.searchIsLoading = NO;
											   [self.searchDisplayController.searchResultsTableView reloadData];
											   
										   }];
	}

	return NO;
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
	
	[self.searchResultArray removeAllObjects];
	self.searchRequestOptions		= [self.requestOptions copy];
	self.searchIsLoading			= NO;
	self.searchHasLoadedAllPages	= NO;
	self.searchRequestOptions.offset = 0;
	self.searchRequestOptions.limit = 0;
	
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	
	[self.tableView reloadData];
	
}

-(void)refresh {
	
	[self.refreshController beginRefreshing];
	[self dropViewDidBeginRefreshing:self.refreshController];
	
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
	self.hasLoadedAllPages = NO;
	self.refreshIsLoading = YES;
	[self.tableView reloadData];
	
	[self.requestOptions resetPaging];
	
    [[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
									successBlock:^(NSArray *result, MHRequestOptions *options) {
		
										self.refreshIsLoading = NO;
										if (options.limit > 0) {
											self.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
										} else {
											self.hasLoadedAllPages = YES;
										}
									 
									 
										self.peopleArray =  [NSMutableArray arrayWithArray:result];
										[self.tableView reloadData];
										[self.refreshController endRefreshing];
									 
									 
	}
									   failBlock:^(NSError *error, MHRequestOptions *options) {
										
											NSString *errorMessage = [NSString stringWithFormat:@"Failed to refresh results due to: \"%@\". Try again by pulling down on the list. If the problem continues please contact support@missionhub.com", error.localizedDescription];
											NSError *presentingError = [NSError errorWithDomain:error.domain
																						   code:error.code
																					   userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
											
											[MHErrorHandler presentError:presentingError];
											self.refreshIsLoading = NO;
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
	self.refreshIsLoading = NO;
	self.searchIsLoading = NO;
	self.pagingIsLoading = NO;
	self.searchPagingIsLoading = NO;
	self.searchHasLoadedAllPages = NO;
	[self.searchResultArray removeAllObjects];
	
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
    
    [self.navigationController pushViewController:[self createPersonViewController] animated:YES];

}

-(IBAction)addInteractionActivity:(id)sender {
    NSLog(@"Label Action");
    	[self.navigationController pushViewController:[self createInteractionViewController] animated:YES];
 //   [self.createInteractionViewController removeToolbar];

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
    [self presentViewController:[self fieldSelectorViewController] animated:YES completion:Nil];
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
	
	// Return the number of rows in the section.
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		
		return [self.searchResultArray count] + 1;
		
	} else {
		
		return [self.peopleArray count] + 1;
		
	}

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"%f : %f", self.tableView.contentSize.width, self.tableView.contentSize.height);
	//NSLog(@"%f : %f", self.tableView.contentOffset.x, self.tableView.contentOffset.y);
	//NSLog(@"%f : %f", self.tableView.frame.size.width, self.tableView.frame.size.height);
	//NSLog(@"%f, %f, %f, %f, %f", self.searchDisplayController.searchBar.frame.size.height, ROW_HEIGHT, HEADER_HEIGHT,  self.tableView.frame.size.height, self.tableView.contentSize.height);
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		
		static NSString *CellIdentifier = @"MHCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
		
		if (indexPath.row < [self.searchResultArray count]) {
		
			MHPerson *person = [self.searchResultArray objectAtIndex:indexPath.row];
			//Display person in the table cell
			
			if (person.picture == nil) {
				
				cell.imageView.image = [UIImage imageNamed:@"MHPersonCell_Placeholder.png"];
				
			} else {
				
				[cell.imageView setImageWithURL:[NSURL URLWithString:person.picture]
									placeholderImage:[UIImage imageNamed:@"MHPersonCell_Placeholder.png"]];
			}
			
			cell.textLabel.text = [person fullName];
			cell.detailTextLabel.text = [person primaryEmail];
			
		} else {
			
			cell.imageView.image = nil;
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.detailTextLabel.text = @"";
			
			if (self.searchHasLoadedAllPages) {
				
				cell.textLabel.text = @"All results have been loaded";
				
			} else {
				
				if (self.refreshController.refreshing) {
					
					cell.textLabel.text = @"";
					
				} else {
					
					cell.textLabel.text = @"Loading...";
					
				}
				
			}
			
		}
		
		return cell;
		
	} else {
	
		if (indexPath.row < [self.peopleArray count]) {
			
			static NSString *CellIdentifier = @"MHPersonCell";
			MHPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
			// Configure the cell...
				if (cell == nil) {
					cell = [[MHPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				}
			
			MHPerson *person = [self.peopleArray objectAtIndex:indexPath.row];
				//Display person in the table cell
			
			cell.cellDelegate = self;
			[cell populateWithPerson:person forField:self.secondaryFieldName atIndexPath:indexPath];
		
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
				
				if (self.refreshController.refreshing) {
					
					[cell hideFinishedMessage];
					[cell stopLoading];
					
				} else {
					
					[cell startLoading];
					
				}
				
			}
			
			return cell;
		}
		
	}
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	} else {
		return self.header;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 0;
	} else {
		return HEADER_HEIGHT;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	// UITableView only moves in one direction, y axis
	NSInteger currentOffset = scrollView.contentOffset.y;
	NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
	
	// Change 10.0 to adjust the distance from bottom
	if (maximumOffset - currentOffset > 0.0 && maximumOffset - currentOffset <= 5.0f * ROW_HEIGHT) {
		
		if ([scrollView isEqual:self.tableView] && !self.hasLoadedAllPages && !self.pagingIsLoading) {
				
			[self.requestOptions configureForNextPageRequest];
			
			self.pagingIsLoading = YES;
			
			[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
											successBlock:^(NSArray *result, MHRequestOptions *options) {
												
												//remove loading cell if it has been displayed
												self.pagingIsLoading = NO;
												
												if (options.limit > 0) {
													self.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
												} else {
													self.hasLoadedAllPages = YES;
												}
												
												
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
												   
												   self.pagingIsLoading = NO;
												   [self.tableView reloadData];
												   
											   }];
				
		}
		
		if ([scrollView isEqual:self.searchDisplayController.searchResultsTableView] && !self.searchHasLoadedAllPages && !self.searchPagingIsLoading) {
			
			[self.searchRequestOptions configureForNextPageRequest];
			
			self.searchPagingIsLoading = YES;
			
			[[MHAPI sharedInstance] getResultWithOptions:self.searchRequestOptions
											successBlock:^(NSArray *result, MHRequestOptions *options) {
												
												//remove loading cell if it has been displayed
												self.searchPagingIsLoading = NO;
												
												if (options.limit > 0) {
													self.searchHasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
												} else {
													self.searchHasLoadedAllPages = YES;
												}
												
												
												//update array with results
												if ([result count] == 0) {
													[self.searchResultArray removeAllObjects];
												} else {
													self.searchResultArray =  [NSMutableArray arrayWithArray:result];
												}
												[self.searchDisplayController.searchResultsTableView reloadData];
												
											}
											   failBlock:^(NSError *error, MHRequestOptions *options) {
												   
												   NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
												   NSError *presentingError = [NSError errorWithDomain:error.domain
																								  code:error.code
																							  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
												   
												   [MHErrorHandler presentError:presentingError];
												   
												   self.searchPagingIsLoading = NO;
												   [self.searchDisplayController.searchResultsTableView reloadData];
												   
											   }];
			
		}
		
	}
	
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	if (tableView == self.tableView && !self.hasLoadedAllPages && !self.pagingIsLoading) {
		
		if (indexPath.row + 5 >= [self.peopleArray count]) {
			
			[self.requestOptions configureForNextPageRequest];

			self.pagingIsLoading = YES;
			
			[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
											successBlock:^(NSArray *result, MHRequestOptions *options) {
											 
											 //remove loading cell if it has been displayed
											 self.pagingIsLoading = NO;
											 
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
													
													self.pagingIsLoading = NO;
													[self.tableView reloadData];
												
											}];
			
		}
		
	}
	
	if (tableView == self.searchDisplayController.searchResultsTableView && !self.searchHasLoadedAllPages && !self.searchPagingIsLoading) {
		
		if (indexPath.row + 5 >= [self.searchResultArray count]) {
			
			[self.searchRequestOptions configureForNextPageRequest];
			
			self.searchPagingIsLoading = YES;
			
			[[MHAPI sharedInstance] getResultWithOptions:self.searchRequestOptions
											successBlock:^(NSArray *result, MHRequestOptions *options) {
												
												//remove loading cell if it has been displayed
												self.searchPagingIsLoading = NO;
												
												self.searchHasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
												
												//update array with results
												if ([result count] == 0) {
													[self.searchResultArray removeAllObjects];
												} else {
													self.searchResultArray =  [NSMutableArray arrayWithArray:result];
												}
												[self.searchDisplayController.searchResultsTableView reloadData];
												
											}
											   failBlock:^(NSError *error, MHRequestOptions *options) {
												   
												   NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
												   NSError *presentingError = [NSError errorWithDomain:error.domain
																								  code:error.code
																							  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
												   
												   [MHErrorHandler presentError:presentingError];
												   
												   self.searchPagingIsLoading = NO;
												   [self.searchDisplayController.searchResultsTableView reloadData];
												   
											   }];
			
		}
		
	}
	*/ 
	
}
 
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHPerson *person;
	
	if (self.searchDisplayController.searchResultsTableView == tableView) {
		
		person = [self.searchResultArray objectAtIndex:indexPath.row];
		
	} else {
		
		person = [self.peopleArray objectAtIndex:indexPath.row];
		
	}
	
	[[self profileViewController] setPerson:person];
	
	[self.navigationController pushViewController:[self profileViewController] animated:YES];
    
}

-(void)cell:(MHPersonCell *)cell didSelectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath {
	
#warning implement cell selection
	
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
    
