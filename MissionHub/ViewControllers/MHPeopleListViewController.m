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
#import "MHPeopleSearchBar.h"
#import "MHToolbar.h"
#import "UIImageView+AFNetworking.h"


#define HEADER_HEIGHT 32.0f
#define ROW_HEIGHT 61.0f


@interface MHPeopleListViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *peopleSearchBar;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) NSMutableArray *selectedPeople;
@property (nonatomic, strong) MHRequestOptions *requestOptions;
@property (nonatomic, strong) MHRequestOptions *searchRequestOptions;
@property (nonatomic, strong) ODRefreshControl *refreshController;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL refreshIsLoading;
@property (nonatomic, assign) BOOL pagingIsLoading;
@property (nonatomic, assign) BOOL hasLoadedAllPages;
@property (nonatomic, assign) BOOL searchIsLoading;
@property (nonatomic, assign) BOOL searchPagingIsLoading;
@property (nonatomic, assign) BOOL searchHasLoadedAllPages;
@property (nonatomic, assign) MHPersonSortFields secondaryFieldName;
@property (nonatomic, assign) MHRequestOptionsOrderFields sortField;
@property (nonatomic, strong) MHSortHeader *header;
@property (nonatomic, strong, readonly) MHProfileViewController *profileViewController;
@property (nonatomic, strong, readonly) MHGenericListViewController *fieldSelectorViewController;
@property (nonatomic, strong, readonly) MHNewInteractionViewController *createInteractionViewController;
@property (nonatomic, strong, readonly) MHCreatePersonViewController *createPersonViewController;
@property (nonatomic, strong, readonly) UIPopoverController	*createPersonPopoverViewController;
@property (nonatomic, strong, readonly) MHActivityViewController *activityViewController;

- (BOOL)isSelected:(MHPerson *)person;

- (void)redoRequestWithPagingReset:(BOOL)resetPaging;
- (void)personRemoved:(NSNotification *)notification;

- (IBAction)revealMenu:(id)sender;
- (void)addPerson:(id)sender;
- (void)addInteraction:(id)sender;

- (void)setTextFieldLeftView;
- (void)updateBarButtons;

@end


@implementation MHPeopleListViewController

@synthesize peopleSearchBar						= _peopleSearchBar;
@synthesize peopleArray							= _peopleArray;
@synthesize searchResultArray					= _searchResultArray;
@synthesize requestOptions						= _requestOptions;
@synthesize searchRequestOptions				= _searchRequestOptions;
@synthesize refreshController					= _refreshController;
@synthesize isLoading							= _isLoading;
@synthesize refreshIsLoading					= _refreshIsLoading;
@synthesize pagingIsLoading						= _pagingIsLoading;
@synthesize hasLoadedAllPages					= _hasLoadedAllPages;
@synthesize searchIsLoading						= _searchIsLoading;
@synthesize searchPagingIsLoading				= _searchPagingIsLoading;
@synthesize searchHasLoadedAllPages				= _searchHasLoadedAllPages;
@synthesize secondaryFieldName					= _secondaryFieldName;
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
	self.header				= [MHSortHeader headerWithTableView:self.tableView sortField:self.secondaryFieldName delegate:self];
	
}

-(MHProfileViewController *)profileViewController {
	
	if (_profileViewController == nil) {
		
		[self willChangeValueForKey:@"profileViewController"];
		_profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHProfileViewController"];
		[self didChangeValueForKey:@"profileViewController"];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(personRemoved:)
													 name:MHProfileViewControllerNotificationPersonArchived
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(personRemoved:)
													 name:MHProfileViewControllerNotificationPersonArchived
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(personRemoved:)
													 name:MHProfileViewControllerNotificationPersonUpdated
												   object:nil];
		
	}
	
	return _profileViewController;
	
}

-(MHGenericListViewController *)fieldSelectorViewController {
	
	if (_fieldSelectorViewController == nil) {
		
		[self willChangeValueForKey:@"fieldSelectorViewController"];
		_fieldSelectorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MHGenericListViewController"];
		[self didChangeValueForKey:@"fieldSelectorViewController"];
		
		_fieldSelectorViewController.listTitle			= @"Fields";
		_fieldSelectorViewController.multipleSelection	= NO;
		_fieldSelectorViewController.showSuggestions	= NO;
		_fieldSelectorViewController.showHeaders		= NO;
		_fieldSelectorViewController.selectionDelegate	= self;
		[_fieldSelectorViewController setDataArray:[NSMutableArray arrayWithArray:@[
														 [MHPerson fieldNameForSortField:MHPersonSortFieldGender],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldFollowupStatus],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPermission],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPrimaryPhone],
														 [MHPerson fieldNameForSortField:MHPersonSortFieldPrimaryEmail]
														 ]]];
		[_fieldSelectorViewController setSuggestions:nil andSelectionObject:[MHPerson fieldNameForSortField:self.secondaryFieldName]];
		
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
		
		NSArray *activities							= [MHActivityViewController allActivities];
		NSArray *activityItems						= ( self.selectedPeople ? self.selectedPeople : @[]);
		
		[self willChangeValueForKey:@"activityViewController"];
		_activityViewController						= [[MHActivityViewController alloc] initWithViewController:self activityItems:activityItems activities:activities];
		[self didChangeValueForKey:@"activityViewController"];
		
		_activityViewController.delegate			= self;
		_activityViewController.animateFromView		= self.view;
		_activityViewController.animationPosition	= MHActivityViewControllerAnimationPositionBottom;
		_activityViewController.animationDirection	= MHActivityViewControllerAnimationDirectionUp;
		
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
    //UITextField *text = [[self.peopleSearchBar subviews] objectAtIndex:1];
    //[text setFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    [self.peopleSearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Searchbar_background.png"] forState:UIControlStateNormal];
	[self.activityViewController setModalInPopover:NO];
	
	[self updateBarButtons];
	
//TODO:The search bar cancel button is NOT currently customized. Not absolutely necessary but it would look nice for it to have a red or grey background instead of the blue, though I do not know how to implement that
	
    /*id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    
    [barButtonAppearanceInSearchBar setBackgroundImage:[UIImage imageNamed:@"MH_Mobile_Button_Save_72.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   [barButtonAppearanceInSearchBar setTitleTextAttributes:@{
                                      UITextAttributeFont : [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20],
                                 UITextAttributeTextColor : [UIColor blackColor]
     } forState:UIControlStateNormal];
    [barButtonAppearanceInSearchBar setTitle:@""];*/
	
	if (self.selectedPeople.count > 0) {
		
		[self.activityViewController presentFromRootViewController];
		
	}
	
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	[self.activityViewController dismissViewControllerAnimated:NO completion:nil];
	
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    //[self setTextFieldLeftView];
	
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
	
	[self.header updateInterfaceWithSortField:self.secondaryFieldName];
	[[self.requestOptions clearOrders] setOrderField:self.sortField orderDirection:self.requestOptions.orderDirection];
	[self refresh];
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	
	if ([searchString length] > 2) {
		
		[self.searchRequestOptions updateFilter:MHRequestOptionsFilterPeopleNameOrEmailLike withValue:searchString];
		self.searchHasLoadedAllPages = NO;
		self.searchIsLoading = YES;
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] getResultWithOptions:self.searchRequestOptions
										successBlock:^(NSArray *result, MHRequestOptions *options) {
											
											weakSelf.searchIsLoading = NO;
											if (options.limit > 0) {
												weakSelf.searchHasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
											} else {
												weakSelf.searchHasLoadedAllPages = YES;
											}
											
											
											if ([result count] == 0) {
												[weakSelf.searchResultArray removeAllObjects];
											} else {
												weakSelf.searchResultArray =  [NSMutableArray arrayWithArray:result];
											}
											
											[weakSelf.searchDisplayController.searchResultsTableView reloadData];
											
											
										}
										   failBlock:^(NSError *error, MHRequestOptions *options) {
											   
											   NSString *errorMessage = [NSString stringWithFormat:@"Failed to get search results due to: \"%@\". Try again by tapping cancel and starting again. If the problem continues please contact support@missionhub.com", error.localizedDescription];
											   NSError *presentingError = [NSError errorWithDomain:error.domain
																							  code:error.code
																						  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
											   
											   [MHErrorHandler presentError:presentingError];
											   weakSelf.searchIsLoading = NO;
											   [weakSelf.searchDisplayController.searchResultsTableView reloadData];
											   
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
	[self redoRequestWithPagingReset:YES];
	
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl {
	
	[self redoRequestWithPagingReset:YES];
	
}

- (void)personRemoved:(NSNotification *)notification {
	
	[self redoRequestWithPagingReset:NO];
	
}

- (void)redoRequestWithPagingReset:(BOOL)resetPaging {
	
	MHRequestOptions *options	= self.requestOptions;
	self.hasLoadedAllPages		= NO;
	self.refreshIsLoading		= YES;
	self.selectedPeople			= [NSMutableArray array];
	[self.activityViewController dismissViewControllerAnimated:YES completion:nil];
	[self.tableView reloadData];
	
	if (resetPaging) {
		
		[options resetPaging];
		
	} else {
		
		options			= [self.requestOptions copy];
		options.limit	+= options.offset;
		options.offset	= 0;
		
	}
	
	__weak __typeof(&*self)weakSelf = self;
    [[MHAPI sharedInstance] getResultWithOptions:options
									successBlock:^(NSArray *result, MHRequestOptions *options) {
										
										weakSelf.refreshIsLoading = NO;
										if (options.limit > 0) {
											weakSelf.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
										} else {
											weakSelf.hasLoadedAllPages = YES;
										}
										
										
										weakSelf.peopleArray =  [NSMutableArray arrayWithArray:result];
										[weakSelf.tableView reloadData];
										[weakSelf.refreshController endRefreshing];
										
										
									}
									   failBlock:^(NSError *error, MHRequestOptions *options) {
										   
										   NSString *errorMessage = [NSString stringWithFormat:@"Failed to refresh results due to: \"%@\". Try again by pulling down on the list. If the problem continues please contact support@missionhub.com", error.localizedDescription];
										   NSError *presentingError = [NSError errorWithDomain:error.domain
																						  code:error.code
																					  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
										   
										   [MHErrorHandler presentError:presentingError];
										   weakSelf.refreshIsLoading = NO;
										   [weakSelf.tableView reloadData];
										   [weakSelf.refreshController endRefreshing];
										   
									   }];
	
}

-(void)setDataFromRequestOptions:(MHRequestOptions *)options {
	
	[self setDataArray:nil forRequestOptions:options];
	
}

-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options {
	
	self.requestOptions				= (options ? options : [[[MHRequestOptions alloc] init] configureForInitialPeoplePageRequest]);
	self.isLoading					= NO;
	self.refreshIsLoading			= NO;
	self.searchIsLoading			= NO;
	self.pagingIsLoading			= NO;
	self.searchPagingIsLoading		= NO;
	self.searchHasLoadedAllPages	= NO;
	[self.searchResultArray removeAllObjects];
	self.tableView.contentOffset	= CGPointZero;
	
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
	
	MHPerson *newPerson						= [MHPerson newObjectFromFields:nil];
	self.createPersonViewController.person	= newPerson;
    
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

-(void)fieldButtonPressed {
	
    [self presentViewController:[self fieldSelectorViewController] animated:YES completion:Nil];
    
}

-(void)sortDirectionDidChangeTo:(MHRequestOptionsOrderDirections)direction {
	
	if (direction == MHRequestOptionsOrderDirectionNone) {
		
		[self.requestOptions clearOrders];
		
	} else {
		
		[[self.requestOptions clearOrders] setOrderField:self.sortField orderDirection:direction];
		
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
				
				cell.imageView.image = [UIImage imageNamed:@"MH_Mobile_PersonCell_Placeholder.png"];
				
			} else {
				
				[cell.imageView setImageWithURL:[NSURL URLWithString:person.picture]
									placeholderImage:[UIImage imageNamed:@"MH_Mobile_PersonCell_Placeholder.png"]];
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
		return MHSortHeaderHeight;
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
			
			__weak __typeof(&*self)weakSelf = self;
			[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
											successBlock:^(NSArray *result, MHRequestOptions *options) {
												
												//remove loading cell if it has been displayed
												weakSelf.pagingIsLoading = NO;
												
												if (options.limit > 0) {
													weakSelf.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
												} else {
													weakSelf.hasLoadedAllPages = YES;
												}
												
												
												//update array with results
												[weakSelf.peopleArray addObjectsFromArray:result];
												[weakSelf.tableView reloadData];
												
											}
											   failBlock:^(NSError *error, MHRequestOptions *options) {
												   
												   NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
												   NSError *presentingError = [NSError errorWithDomain:error.domain
																								  code:error.code
																							  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
												   
												   [MHErrorHandler presentError:presentingError];
												   
												   weakSelf.pagingIsLoading = NO;
												   [weakSelf.tableView reloadData];
												   
											   }];
				
		}
		
		if ([scrollView isEqual:self.searchDisplayController.searchResultsTableView] && !self.searchHasLoadedAllPages && !self.searchPagingIsLoading) {
			
			[self.searchRequestOptions configureForNextPageRequest];
			
			self.searchPagingIsLoading = YES;
			
			__weak __typeof(&*self)weakSelf = self;
			[[MHAPI sharedInstance] getResultWithOptions:self.searchRequestOptions
											successBlock:^(NSArray *result, MHRequestOptions *options) {
												
												//remove loading cell if it has been displayed
												weakSelf.searchPagingIsLoading = NO;
												
												if (options.limit > 0) {
													weakSelf.searchHasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
												} else {
													weakSelf.searchHasLoadedAllPages = YES;
												}
												
												
												//update array with results
												if ([result count] == 0) {
													[weakSelf.searchResultArray removeAllObjects];
												} else {
													weakSelf.searchResultArray =  [NSMutableArray arrayWithArray:result];
												}
												[weakSelf.searchDisplayController.searchResultsTableView reloadData];
												
											}
											   failBlock:^(NSError *error, MHRequestOptions *options) {
												   
												   NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
												   NSError *presentingError = [NSError errorWithDomain:error.domain
																								  code:error.code
																							  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
												   
												   [MHErrorHandler presentError:presentingError];
												   
												   weakSelf.searchPagingIsLoading = NO;
												   [weakSelf.searchDisplayController.searchResultsTableView reloadData];
												   
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
		
		if (indexPath.row < self.peopleArray.count) {
			
			person = [self.peopleArray objectAtIndex:indexPath.row];
			
		}
		
	}
	
	[self.profileViewController setPerson:person];
	
	[self.navigationController pushViewController:self.profileViewController animated:YES];
    
}

-(void)cell:(MHPersonCell *)cell didSelectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath {
	
	if (person) {
		
		[self.selectedPeople addObject:person];
		self.activityViewController.activityItems	= self.selectedPeople;
		
	}
	
	if ([self.selectedPeople count] == 1) {
		
		//launch activity view controller
		[self.activityViewController presentFromRootViewController];
		
	}
	
}

-(void)cell:(MHPersonCell *)cell didDeselectPerson:(MHPerson *)person atIndexPath:(NSIndexPath *)indexPath {
	
	if (person) {
		
		[self.selectedPeople removeObject:person];
		self.activityViewController.activityItems	= self.selectedPeople;
		
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

#pragma mark - MHActivityViewControllerDelegate

- (void)activityDidFinish:(NSString *)activityType completed:(BOOL)completed {
	
	
	if (completed) {
		
		//remove activity view controller
		[self.activityViewController dismissViewControllerAnimated:YES completion:nil];
		[self.selectedPeople removeAllObjects];
		
	}
	
	if ([activityType isEqualToString:MHActivityTypeArchive] ||
		[activityType isEqualToString:MHActivityTypeAssign] ||
		[activityType isEqualToString:MHActivityTypeDelete] ||
		[activityType isEqualToString:MHActivityTypeLabel] ||
		[activityType isEqualToString:MHActivityTypePermissions]) {

		[self refresh];
		
	} else if ([activityType isEqualToString:MHActivityTypeEmail] ||
			   [activityType isEqualToString:MHActivityTypeText]) {
		
		[self.tableView reloadData];
		
	} else {
		
		[self.tableView reloadData];
		
	}
	
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
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self updateBarButtons];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}

@end
    
