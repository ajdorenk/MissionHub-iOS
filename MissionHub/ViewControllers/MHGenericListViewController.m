//
//  MHGenericListViewController.m
//  MissionHub
//
//  Created by Amarisa Robison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import "MHGenericListViewController.h"
#import "MHPeopleListViewController.h"
#import "MHGenericCell.h"
#import "MHLoadingCell.h"
#import "MHPerson+Helper.h"

#define ROW_HEIGHT 28.0f


@interface MHGenericListViewController ()

@end

@implementation MHGenericListViewController

@synthesize listName;
@synthesize tableViewList;

@synthesize selectionDelegate       = _selectionDelegate;
@synthesize objectArray				= _objectArray;
@synthesize requestOptions			= _requestOptions;
@synthesize refreshController		= _refreshController;
@synthesize isLoading				= _isLoading;
@synthesize refreshIsLoading		= _refreshIsLoading;
@synthesize pagingIsLoading			= _pagingIsLoading;
@synthesize hasLoadedAllPages		= _hasLoadedAllPages;
@synthesize suggestionArray			= _suggestionArray;
@synthesize selectedObject			= _selectedObject;
@synthesize selectedSet				= _selectedSet;
@synthesize multipleSelection		= _multipleSelection;

- (void)awakeFromNib {
	
    [super awakeFromNib];
	
    self.objectArray		= [NSMutableArray array];
	self.requestOptions		= nil;
	self.multipleSelection	= NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.refreshController = [[ODRefreshControl alloc] initInScrollView:self.tableViewList];
    [self.refreshController addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    UIImage* menuImage = [UIImage imageNamed:@"BackMenu_Icon.png"];
    UIButton *backMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backMenu setImage:menuImage forState:UIControlStateNormal];
    [backMenu addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backMenuButton = [[UIBarButtonItem alloc] initWithCustomView:backMenu];
    
    self.navigationItem.leftBarButtonItem = backMenuButton;
    self.tableViewList.layer.borderWidth = 1.0;
    self.tableViewList.layer.borderColor = [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];

    //self.tableViewList.separatorColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    
//TODO: need to uncomment to add a toolbar for when the navigator bar does not show, (i.e. when adding a label and when choosing what secondary information to show in contact list, for which there is currently no way to go back without making a selection). Also means there needs to be a method to hide the toolbar when the navigation bar does show, i.e. when creating a new interaction and choosing the initiator, interaction, receiver, and visibilty.
	
    /*UIToolbar *toolbar = [[UIToolbar alloc] init];
    self.genericToolbar = toolbar;
    self.genericToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    NSMutableArray *toolbarButtons = [[NSMutableArray alloc] init];
    [toolbarButtons addObject:backMenuButton];
    [self.genericToolbar setItems:toolbarButtons animated:NO];
    [self.view addSubview:self.genericToolbar];
*/
}

-(BOOL)isSelected:(id)object {
	
	__block BOOL selected = NO;
	
	if (self.multipleSelection) {
		
		[self.selectedSet enumerateObjectsUsingBlock:^(id selectedObject, BOOL *stop) {
			
			if ([selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
				selected	= [selectedObject isEqualToString:object];
			} else if ([selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
				selected	= [selectedObject isEqualToModel:object];
			}
			
			*stop		= selected;
			
		}];
		
	} else {
		
		if ([self.selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
			selected = [self.selectedObject isEqualToString:object];
		} else if ([self.selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
			selected = [self.selectedObject isEqualToModel:object];
		}
		
	}
	
	return selected;
	
}

-(void)refresh {
	
	[self.refreshController beginRefreshing];
	[self dropViewDidBeginRefreshing:self.refreshController];
	
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
	
	if (self.requestOptions) {
	
		self.hasLoadedAllPages = NO;
		self.refreshIsLoading = YES;
		[self.tableViewList reloadData];
		
		[self.requestOptions resetPaging];
		
		[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
										successBlock:^(NSArray *result, MHRequestOptions *options) {
											
											self.refreshIsLoading = NO;
											if (options.limit > 0) {
												self.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
											} else {
												self.hasLoadedAllPages = YES;
											}
											
											
											self.objectArray =  [NSMutableArray arrayWithArray:result];
											[self.tableViewList reloadData];
											[self.refreshController endRefreshing];
											
											
										}
										   failBlock:^(NSError *error, MHRequestOptions *options) {
											   
											   NSString *errorMessage = [NSString stringWithFormat:@"Failed to refresh results due to: \"%@\". Try again by pulling down on the list. If the problem continues please contact support@missionhub.com", error.localizedDescription];
											   NSError *presentingError = [NSError errorWithDomain:error.domain
																							  code:error.code
																						  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
											   
											   [MHErrorHandler presentError:presentingError];
											   self.refreshIsLoading = NO;
											   [self.tableViewList reloadData];
											   [self.refreshController endRefreshing];
											   
										   }];
		
	}
	
}

-(void)setSuggestions:(NSArray *)suggestionsArray andSelections:(NSSet *)selectedSet {
	
	self.suggestionArray	= [NSMutableArray arrayWithArray:[selectedSet allObjects]];
	[self.suggestionArray addObjectsFromArray:suggestionsArray];
	self.selectedSet		= [NSMutableSet setWithSet:selectedSet];
	
}

-(void)setSuggestions:(NSArray *)suggestionsArray andSelectionObject:(id)selectedObject {
	
	self.suggestionArray	= [NSMutableArray arrayWithArray:selectedObject];
	[self.suggestionArray addObjectsFromArray:suggestionsArray];
	self.selectedObject		= selectedObject;
	
}

-(void)setDataFromRequestOptions:(MHRequestOptions *)options {
	
	[self setDataArray:nil forRequestOptions:options];
	
}

-(void)setDataArray:(NSArray *)dataArray {
    
	[self setDataArray:dataArray forRequestOptions:nil];
    
}

-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options {
	
	self.requestOptions		= options;
	self.isLoading			= NO;
	self.refreshIsLoading	= NO;
	self.pagingIsLoading	= NO;
	
	if (dataArray == nil) {
		
		[self.objectArray removeAllObjects];
		
		self.hasLoadedAllPages = NO;
		[self refresh];
		
	} else {
		
		self.objectArray = [NSMutableArray arrayWithArray:dataArray];
		
		if (self.requestOptions) {
			
			self.hasLoadedAllPages = ( [self.objectArray count] < self.requestOptions.limit ? YES : NO );
			
		}
		
	}
	
	[self.tableViewList reloadData];
	
}

-(void)setListTitle:(NSString *)title {
//    self.listTitle = title;
    self.listName.text = title;
    NSLog(@"%@",title);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
	// Return the number of sections.
	if (self.multipleSelection) {
		return 2;
	} else {
		return 1;
	}
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	if (self.multipleSelection && section == 0) {
		
		return [self.suggestionArray count];
		
	} else if ((self.multipleSelection && section == 1) || (!self.multipleSelection)) {
		
		if (self.requestOptions) {
			
			return [self.objectArray count] + 1;
			
		} else {
			
			return [self.objectArray count];
			
		}
		
	} else {
		
		return 0;
		
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row < [self.objectArray count]) {
		
		static NSString *CellIdentifier = @"MHGenericCell";
		MHGenericCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHGenericCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		id object		= nil;
		BOOL selected	= NO;
		
		if (self.multipleSelection && indexPath.section == 0) {
			
			object		= [self.suggestionArray objectAtIndex:indexPath.row];
			selected	= YES;
			
		} else if ((self.multipleSelection && indexPath.section == 1) || (!self.multipleSelection)) {
			
			object		= [self.objectArray objectAtIndex:indexPath.row];
			selected	= [self isSelected:object];
			
		}
		
		if ([object isKindOfClass:[NSString class]]) {
			[cell populateWithString:object andSelected:selected];
		} else if ([object isKindOfClass:[MHModel class]]) {
			[cell populateWithString:[(MHModel *)object displayString] andSelected:selected];
		}
		
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



- (IBAction)backToMenu:(id)sender {
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.objectArray objectAtIndex:indexPath.row];
	
	if (self.multipleSelection) {
		
		if ([self isSelected:object]) {
			
			[self.selectedSet removeObject:object];
			[self.suggestionArray removeObject:object];
			
			if ([self.selectionDelegate respondsToSelector:@selector(list:didDeselectObject:atIndexPath:)]) {
				[self.selectionDelegate list:self didDeselectObject:object atIndexPath:indexPath];
			}
			
		} else {
			
			[self.selectedSet addObject:object];
			[self.suggestionArray addObject:object];
			
			if ([self.selectionDelegate respondsToSelector:@selector(list:didSelectObject:atIndexPath:)]) {
				[self.selectionDelegate list:self didSelectObject:object atIndexPath:indexPath];
			}
			
		}
		
	} else {
    
		[self.suggestionArray removeObject:self.selectedObject];
		self.selectedObject = object;
		[self.suggestionArray addObject:self.selectedObject];
		
		if ([self.selectionDelegate respondsToSelector:@selector(list:didSelectObject:atIndexPath:)]) {
			[self.selectionDelegate list:self didSelectObject:object atIndexPath:indexPath];
		}
		
	}
	
	[self.tableViewList deselectRowAtIndexPath:indexPath animated:YES];
	[self.tableViewList reloadData];
    
}

#pragma mark - Scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (self.requestOptions) {
	
		// UITableView only moves in one direction, y axis
		NSInteger currentOffset = scrollView.contentOffset.y;
		NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
		
		// Change 10.0 to adjust the distance from bottom
		if (maximumOffset - currentOffset > 0.0 && maximumOffset - currentOffset <= 5.0f * ROW_HEIGHT) {
			
			if ([scrollView isEqual:self.tableViewList] && !self.hasLoadedAllPages && !self.pagingIsLoading) {
				
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
													[self.objectArray addObjectsFromArray:result];
													[self.tableViewList reloadData];
													
												}
												   failBlock:^(NSError *error, MHRequestOptions *options) {
													   
													   NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
													   NSError *presentingError = [NSError errorWithDomain:error.domain
																									  code:error.code
																								  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
													   
													   [MHErrorHandler presentError:presentingError];
													   
													   self.pagingIsLoading = NO;
													   [self.tableViewList reloadData];
													   
												   }];
				
			}
			
		}
		
	}
	
}


@end
