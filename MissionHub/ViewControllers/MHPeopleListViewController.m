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
#import "MHToolbar.h"
#import "UIImageView+AFNetworking.h"


#define HEADER_HEIGHT 32.0f
#define ROW_HEIGHT 61.0f


@interface MHPeopleListViewController ()

-(void)setTextFieldLeftView;

- (void)addPerson:(id)sender;
- (void)addInteraction:(id)sender;

- (void)updateBarButtons;

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
@synthesize sortField							= _sortField;
@synthesize header								= _header;
@synthesize profileViewController				= _profileViewController;
@synthesize fieldSelectorViewController			= _fieldSelectorViewController;
@synthesize createInteractionViewController		= _createInteractionViewController;
@synthesize createPersonViewController			= _createPersonViewController;
@synthesize createPersonPopoverViewController	= _createPersonPopoverViewController;
@synthesize activityViewController				= _activityViewController;


-(void)awakeFromNib {
	
	[super awakeFromNib];
	
	self.peopleArray		= [NSMutableArray array];
	self.searchResultArray	= [NSMutableArray array];
	self.selectedPeople		= [NSMutableArray array];
	self.requestOptions		= [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
	self.searchRequestOptions = [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest];
	
	self.sortField			= MHRequestOptionsOrderFieldPeopleFollowupStatus;
	self.secondaryFieldName = MHPersonSortFieldFollowupStatus;
	
	UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 22.0)];
    sectionHeader.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
	/*
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 6.5, 20, 20.0)];
    headerLabel.textColor = [UIColor whiteColor];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textAlignment = NSTextAlignmentLeft;
	[sectionHeader addSubview:headerLabel];
	
	headerLabel.text = @"All";
    */
    //Add sortFieldButton
    UIButton *sortFieldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [sortFieldButton setFrame:CGRectMake(94, 5.0, 154.0, 22.0)];
    }
    else{
        [sortFieldButton setFrame:CGRectMake(420, 5.0, 270.0, 22.0)];
    }
	
    [sortFieldButton setTintColor:[UIColor clearColor]];
    [sortFieldButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderLabels.png"] forState:UIControlStateNormal];
	
    [sortFieldButton setBackgroundColor:[UIColor clearColor]];
	[sortFieldButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
	[sortFieldButton setTitle:[MHPerson fieldNameForSortField:self.secondaryFieldName] forState:UIControlStateNormal];
    [sortFieldButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sortFieldButton addTarget:self action:@selector(chooseSortField:) forControlEvents:UIControlEventTouchUpInside];
    
    [sectionHeader addSubview:sortFieldButton];
	
	self.fieldButton = sortFieldButton;
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [sortButton setFrame:CGRectMake(257, 5.0, 59.0, 22.0)];
    }
    
    else{
        [sortButton setFrame:CGRectMake(700, 5.0, 55.0, 22.0)];
    }
    //[button setTitle:@"Sort" forState:UIControlStateNormal];
    [sortButton setTintColor:[UIColor clearColor]];
    [sortButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderSort.png"] forState:UIControlStateNormal];
    [sortButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sortButton setTitle:@"Sort: off" forState:UIControlStateNormal];
    [sortButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:130.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sortButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    
    
    [sortButton setBackgroundColor:[UIColor clearColor]];
    [sortButton addTarget:self action:@selector(sortOnOff:) forControlEvents:UIControlEventTouchUpInside];
    
    [sectionHeader addSubview:sortButton];
    
	
//TODO:Needs a checkbox and label "All" to check all contacts, (see "to do" comment above the checkAllContacts method)
    /*
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *uncheckedBox = [UIImage imageNamed:@"MH_Mobile_Checkbox_Unchecked_24.png"];
    [allButton setFrame:CGRectMake(13.0, 9.0, 15.0, 15.0)];
    [allButton setTintColor:[UIColor clearColor]];
    [allButton setBackgroundImage:uncheckedBox forState:UIControlStateNormal];
    
    [allButton setBackgroundColor:[UIColor clearColor]];
    [allButton addTarget:self action:@selector(checkAllContacts:) forControlEvents:UIControlEventTouchUpInside];
    
    [sectionHeader addSubview:allButton];
	*/
	self.header = sectionHeader;
	
}

-(MHProfileViewController *)profileViewController {
	
	if (_profileViewController == nil) {
		
		[self willChangeValueForKey:@"profileViewController"];
		_profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileViewController"];
		[self didChangeValueForKey:@"profileViewController"];
		
	}
	
	return _profileViewController;
	
}

-(MHGenericListViewController *)fieldSelectorViewController {
	
	if (_fieldSelectorViewController == nil) {
		
		[self willChangeValueForKey:@"fieldSelectorViewController"];
		_fieldSelectorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"fieldSelectorViewController"];
		
		_fieldSelectorViewController.selectionDelegate = self;
		_fieldSelectorViewController.objectArray = [NSMutableArray arrayWithArray:@[
														 [MHPerson fieldNameForSortField:MHPersonSortFieldGender],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldFollowupStatus],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPermission],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPrimaryPhone],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPrimaryEmail]
														 ]];
		
	}
	
	return _fieldSelectorViewController;
	
}

-(MHNewInteractionViewController *)createInteractionViewController {
	
	if (_createInteractionViewController == nil) {
		
		[self willChangeValueForKey:@"createInteractionViewController"];
		_createInteractionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHNewInteractionViewController"];
		[self didChangeValueForKey:@"createInteractionViewController"];
		
	}
	
	return _createInteractionViewController;
	
}


-(MHCreatePersonViewController *)createPersonViewController {
	
	if (_createPersonViewController == nil) {
		
		[self willChangeValueForKey:@"createPersonViewController"];
		_createPersonViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHCreatePersonViewController"];
		[self didChangeValueForKey:@"createPersonViewController"];
		
		_createPersonViewController.createPersonDelegate = self;
		
	}
	
	return _createPersonViewController;
	
}

- (UIPopoverController *)createPersonPopoverViewController {
	
	if (_createPersonPopoverViewController == nil) {
		
		[self willChangeValueForKey:@"createPersonPopoverViewController"];
		_createPersonPopoverViewController = [[UIPopoverController alloc] initWithContentViewController:[self createPersonViewController]];
		[self didChangeValueForKey:@"createPersonPopoverViewController"];
		
		_createPersonPopoverViewController.delegate = self;
		
	}
	
	return _createPersonPopoverViewController;
	
}

- (MHActivityViewController *)activityViewController {
	
	if (_activityViewController == nil) {
		
		NSArray *activities = [MHActivityViewController allActivities];
		
		[self willChangeValueForKey:@"activityViewController"];
		_activityViewController = [[MHActivityViewController alloc] initWithViewController:self activities:activities];
		[self didChangeValueForKey:@"activityViewController"];
		
	}
	
	return _activityViewController;
	
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
	
	[self updateBarButtons];
	
//TODO:The search bar cancel button is NOT currently customized. Not absolutely necessary but it would look nice for it to have a red or grey background instead of the blue, though I do not know how to implement that
	
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

}

-(void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.row) {
		case 0:
			self.sortField = MHRequestOptionsOrderFieldPeopleGender;
			self.secondaryFieldName = MHPersonSortFieldGender;
			break;
		case 1:
			self.sortField = MHRequestOptionsOrderFieldPeopleFollowupStatus;
			self.secondaryFieldName = MHPersonSortFieldFollowupStatus;
			break;
		case 2:
			self.sortField = MHRequestOptionsOrderFieldPeoplePermission;
			self.secondaryFieldName = MHPersonSortFieldPermission;
			break;
		case 3:
			self.sortField = MHRequestOptionsOrderFieldPeoplePrimaryPhone;
			self.secondaryFieldName = MHPersonSortFieldPrimaryPhone;
			break;
		case 4:
			self.sortField = MHRequestOptionsOrderFieldPeoplePrimaryEmail;
			self.secondaryFieldName = MHPersonSortFieldPrimaryEmail;
			break;
			
		default:
			break;
	}
	
	[self.fieldButton setTitle:[MHPerson fieldNameForSortField:self.secondaryFieldName] forState:UIControlStateNormal];
	[[self.requestOptions clearOrders] setOrderField:self.sortField orderDirection:self.requestOptions.orderDirection];
	[self refresh];
	[self dismissViewControllerAnimated:YES completion:nil];
	//[self.tableView reloadData];
	
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
	[self.searchRequestOptions clearOrders];
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
	self.hasLoadedAllPages	= NO;
	self.refreshIsLoading	= YES;
	self.selectedPeople		= [NSMutableArray array];
	[self.activityViewController dismissViewControllerAnimated:YES completion:nil];
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

- (void)addPerson:(id)sender {
	
	MHPerson *newPerson = [MHPerson newObjectFromFields:nil];
	[[self createPersonViewController] updateWithPerson:newPerson];
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		
		[self.navigationController pushViewController:[self createPersonViewController] animated:YES];
		
	} else {
		
		[[self createPersonPopoverViewController] presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		
	}
    

}

- (void)addInteraction:(id)sender {
	
	MHInteraction *newInteraction = [MHInteraction newObjectFromFields:nil];
	[newInteraction addInitiators:[NSSet setWithArray:self.selectedPeople]];
	
	[[self createInteractionViewController] updateWithInteraction:newInteraction andSelections:self.selectedPeople]; //create selected array
	[self.navigationController pushViewController:[self createInteractionViewController] animated:YES];

}


//TODO:Need to add functionality to check all contacts. Currently the function only changes the image of the checkbox in the secton header, though it should check all the contacts.
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

-(void)chooseSortField:(id)sender {
    NSLog(@"chooseSortField");
    [self presentViewController:[self fieldSelectorViewController] animated:YES completion:Nil];
    [[self fieldSelectorViewController] setListTitle:@""];
}

-(void)sortOnOff:(UIButton *)button {
    
    if ([button.titleLabel.text isEqualToString:@"Sort: off"]) {
        [button setTitle:@"Sort: asc" forState:UIControlStateNormal];
		[[self.requestOptions clearOrders] setOrderField:self.sortField orderDirection:MHRequestOptionsOrderDirectionAsc];
    } else if ([button.titleLabel.text isEqualToString:@"Sort: asc"]) {
        [button setTitle:@"Sort: desc" forState:UIControlStateNormal];
		[[self.requestOptions clearOrders] setOrderField:self.sortField orderDirection:MHRequestOptionsOrderDirectionDesc];
    } else if ([button.titleLabel.text isEqualToString:@"Sort: desc"]) {
        [button setTitle:@"Sort: off" forState:UIControlStateNormal];
		[self.requestOptions clearOrders];
    }
	
	[self refresh];
        
}

-(BOOL)isSelected:(MHPerson *)person {
	
	__block BOOL selected = NO;
	
	[self.selectedPeople enumerateObjectsUsingBlock:^(MHPerson *selectedPerson, NSUInteger index, BOOL *stop) {
		
		selected	= [selectedPerson isEqualToModel:person];
		*stop		= selected;
		
	}];
	
	return selected;
	
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
		
		cell.imageView.frame		= CGRectMake(40, 7, 45, 45);
		cell.imageView.contentMode	= UIViewContentModeScaleAspectFill;
		
		if (indexPath.row < [self.searchResultArray count]) {
		
			MHPerson *person = [self.searchResultArray objectAtIndex:indexPath.row];
			//Display person in the table cell
			
			if (person.picture == nil) {
				
				cell.imageView.image = [UIImage imageNamed:@"MHPersonCell_Placeholder.png"];
				
			} else {
				
				[cell.imageView setImageWithURL:[NSURL URLWithString:person.picture]
									placeholderImage:[UIImage imageNamed:@"MHPersonCell_Placeholder.png"]];
			}
			
			cell.textLabel.text			= [person fullName];
			cell.detailTextLabel.text	= [person primaryEmail];
			
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
			
			cell.cellDelegate	= self;
			[cell populateWithPerson:person forField:self.secondaryFieldName withSelection:[self isSelected:person] atIndexPath:indexPath];
		
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
	
	if (person) {
		
		[self.selectedPeople addObject:person];
		self.activityViewController.userInfo = @{ @"people": self.selectedPeople };
		
	}
	
	if ([self.selectedPeople count] == 1) {
		
		//launch activity view controller
		[self.activityViewController presentFromRootViewController];
		
	}
	
}

-(void)cell:(MHPersonCell *)cell didDeselectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath {
	
	if (person) {
		
		[self.selectedPeople removeObject:person];
		self.activityViewController.userInfo = @{ @"people": self.selectedPeople };
		
	}
	
	if ([self.selectedPeople count] == 0) {
		
		//remove activity view controller
		[self.activityViewController dismissViewControllerAnimated:YES completion:nil];
		
	}
	
}

#pragma mark - UIPopover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	
	
	
}

#pragma mark - MHCreatePersonDelegate

-(void)controller:(MHCreatePersonViewController *)controller didCreatePerson:(MHPerson *)person {
	
	[self refresh];
	
}

#pragma mark - layout methods

- (void)updateBarButtons {
	
	[self.navigationItem setRightBarButtonItems:@[
	 [MHToolbar barButtonWithStyle:MHToolbarStyleCreateInteraction target:self selector:@selector(addInteraction:) forBar:self.navigationController.navigationBar],
	 [MHToolbar barButtonWithStyle:MHToolbarStyleCreatePerson target:self selector:@selector(addPerson:) forBar:self.navigationController.navigationBar]
	 ]];
	
    self.navigationItem.leftBarButtonItem = [MHToolbar barButtonWithStyle:MHToolbarStyleMenu target:self selector:@selector(revealMenu:) forBar:self.navigationController.navigationBar];
	
}

- (NSUInteger)supportedInterfaceOrientations {
	
    return UIInterfaceOrientationMaskAll;
	
}

- (BOOL)shouldAutorotate {
	
    return YES;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	
    return YES;
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[self updateBarButtons];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
    
