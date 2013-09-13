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
#import "NSMutableArray+removeDuplicatesForKey.h"

CGFloat const MHGenericListViewControllerRowHeight					= 36.0f;
CGFloat const MHGenericListViewControllerHeaderHeight				= 21.0f;
CGFloat const MHGenericListViewControllerTableViewMarginHorizontal	= 30.0f;
CGFloat const MHGenericListViewControllerListLableHeight			= 21.0f;
CGFloat const MHGenericListViewControllerListLableMarginHorizontal	= MHGenericListViewControllerTableViewMarginHorizontal + 2;
CGFloat const MHGenericListViewControllerListLableMarginTop			= 0.5 * MHGenericListViewControllerTableViewMarginHorizontal;
CGFloat const MHGenericListViewControllerListLableMarginBottom		= 0.0f;

@interface MHGenericListViewController ()

@property (nonatomic, weak) IBOutlet UILabel		*listName;
@property (nonatomic, weak) IBOutlet UITableView	*tableViewList;
@property (nonatomic, weak) IBOutlet UIView			*contentView;
@property (nonatomic, strong) MHToolbar				*toolbar;

- (void)addSelection:(id)selectionObject;
- (void)removeSelection:(id)selectionObject;
- (void)updateSelectedObject:(id)selectedObject;

- (void)willAddToSuggestionArray:(NSInteger)numberOfObjects;
- (void)willRemoveFromSuggestionArray:(NSInteger)numberOfObjects;

- (void)updateBarLayoutWithParentFrame:(CGRect)parentFrame;
- (void)updateLayoutWithParentFrame:(CGRect)parentFrame;

@end

@implementation MHGenericListViewController

@synthesize listName				= _listName;
@synthesize tableViewList			= _tableViewList;
@synthesize contentView				= _contentView;
@synthesize toolbar					= _toolbar;

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
@synthesize suggestionSet			= _suggestionSet;
@synthesize multipleSelection		= _multipleSelection;
@synthesize showSuggestions			= _showSuggestions;
@synthesize showHeaders				= _showHeaders;
@synthesize listTitle				= _listTitle;

- (void)awakeFromNib {
	
    [super awakeFromNib];
	
	self.selectionDelegate	= nil;
	self.toolbar			= nil;
	
	self.isLoading			= NO;
	self.refreshIsLoading	= NO;
	self.pagingIsLoading	= NO;
	self.hasLoadedAllPages	= NO;
	
	self.selectedObject		= nil;
    self.objectArray		= [NSMutableArray array];
	self.suggestionSet		= [NSMutableSet set];
	self.selectedSet		= [NSMutableSet set];
	self.suggestionArray	= [NSMutableArray array];
	self.requestOptions		= nil;
	
	self.multipleSelection	= NO;
	self.showSuggestions	= YES;
	self.showHeaders		= YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.refreshController = [[ODRefreshControl alloc] initInScrollView:self.tableViewList];
    [self.refreshController addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    self.tableViewList.layer.borderWidth	= 1.0;
    self.tableViewList.layer.borderColor	= [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
	self.tableViewList.separatorColor		= [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];

}

- (void)viewWillAppear:(BOOL)animated {
	
	self.listName.text	= ( self.listTitle ? self.listTitle : @"" );
	
	[self updateBarLayoutWithParentFrame:self.view.frame];
	[self updateLayoutWithParentFrame:self.view.frame];
	
}

- (void)updateBarLayoutWithParentFrame:(CGRect)parentFrame {
	
	if (self.navigationController) {
		
		self.navigationItem.leftBarButtonItem = [MHToolbar barButtonWithStyle:MHToolbarStyleMenu target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
		
	} else {
		
		if (!self.toolbar) {
			
			self.toolbar		= [[MHToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(parentFrame), 44)];
			self.toolbar.alpha	= 0.5;
			self.toolbar.items	= @[[MHToolbar barButtonWithStyle:MHToolbarStyleCancel target:self selector:@selector(backToMenu:) forBar:self.toolbar]];
			[self.view addSubview:self.toolbar];
			
		} else {
			
			self.toolbar.frame	= CGRectMake(0, 0, CGRectGetWidth(parentFrame), 44);
			self.toolbar.items	= @[[MHToolbar barButtonWithStyle:MHToolbarStyleCancel target:self selector:@selector(backToMenu:) forBar:self.toolbar]];
			
		}
		
	}
	
}

- (void)updateLayoutWithParentFrame:(CGRect)parentFrame {
	
	UIView *bar						= (UIView *)( self.toolbar ? self.toolbar : self.navigationController.navigationBar );
	
	self.contentView.frame			= CGRectMake(0,
												 CGRectGetHeight(bar.frame),
												 CGRectGetWidth(parentFrame),
												 CGRectGetHeight(parentFrame) - CGRectGetHeight(bar.frame));
	
	self.listName.frame				= CGRectMake(MHGenericListViewControllerListLableMarginHorizontal,
												 MHGenericListViewControllerListLableMarginTop,
												 CGRectGetWidth(self.contentView.frame) - 2 * MHGenericListViewControllerListLableMarginHorizontal,
												 MHGenericListViewControllerListLableHeight);
	
	self.tableViewList.frame		= CGRectMake(MHGenericListViewControllerTableViewMarginHorizontal,
												 CGRectGetMaxY(self.listName.frame) + MHGenericListViewControllerListLableMarginBottom,
												 CGRectGetWidth(self.contentView.frame) - 2 * MHGenericListViewControllerTableViewMarginHorizontal,
												 CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(self.listName.frame) - MHGenericListViewControllerListLableMarginBottom);
	
}

- (BOOL)isSelected:(id)object {
	
	__block BOOL selected = NO;
	
	if (self.multipleSelection) {
		
		[self.selectedSet enumerateObjectsUsingBlock:^(id selectedObject, BOOL *stop) {
			
			if ([selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
				selected	= [selectedObject isEqualToString:object];
			} else if ([selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
				selected	= [selectedObject isEqualToModel:object];
			} else {
				selected = [selectedObject isEqual:object];
			}
			
			*stop		= selected;
			
		}];
		
	} else {
		
		if ([self.selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
			selected = [self.selectedObject isEqualToString:object];
		} else if ([self.selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
			selected = [self.selectedObject isEqualToModel:object];
		} else {
			selected = [self.selectedObject isEqual:object];
		}
		
	}
	
	return selected;
	
}

- (void)refresh {
	
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
		
	} else {
		
		[self.tableViewList reloadData];
		[self.refreshController endRefreshing];
		
	}
	
}

- (void)setSuggestions:(NSSet *)suggestionSet andSelections:(NSSet *)selectedSet {
	
	self.suggestionSet			= [NSMutableSet setWithSet:suggestionSet];
	self.selectedSet			= [NSMutableSet setWithSet:selectedSet];
	self.selectedObject			= nil;
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	[self.suggestionSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[self.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[self.suggestionSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	[self.selectedSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[self.selectedSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[self.selectedSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	NSMutableSet *combinedSet	= [NSMutableSet setWithSet:self.suggestionSet];
	[combinedSet addObjectsFromArray:[self.selectedSet allObjects]];
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	[combinedSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[combinedSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[combinedSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	self.suggestionArray		= [NSMutableArray arrayWithArray:[combinedSet allObjects]];
	
	[self.tableViewList reloadData];
	
}

- (void)setSuggestions:(NSSet *)suggestionsSet andSelectionObject:(id)selectedObject {
	
	self.suggestionSet		= [NSMutableSet setWithSet:suggestionsSet];
	self.selectedSet		= nil;
	self.suggestionArray	= [NSMutableArray arrayWithArray:[suggestionsSet allObjects]];
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	[self.suggestionSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[self.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[self.suggestionSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	if (selectedObject) {
		
		self.selectedObject = selectedObject;
		
		if ([selectedObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)selectedObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [self.suggestionArray filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self.suggestionArray insertObject:selectedObject atIndex:0];
				
			}
			
		} else {
			
			//duplicate if same object
			
			if (![self.suggestionSet member:selectedObject]) {
				
				[self.suggestionArray insertObject:selectedObject atIndex:0];
				
			}
			
		}
		
	}
	
	self.selectedObject		= selectedObject;
	
	[self.tableViewList reloadData];
	
}

//TODO: change add, insert and remove object calls to ones that match the id.
- (void)addSelection:(id)selectionObject {
	
	if (selectionObject) {
		
		if ([selectionObject isKindOfClass:[MHModel class]]) {
			
			//find all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)selectionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [self.suggestionArray filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self willAddToSuggestionArray:1];
				[self.suggestionArray addObject:selectionObject];
				
			}
			
			predicate		= [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)selectionObject valueForKey:@"remoteID"]];
			filteredArray	= [[self.selectedSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self.selectedSet addObject:selectionObject];
				
			}
			
		} else {
			
			//duplicate if same object
			if (![self.suggestionSet member:selectionObject] || ![self.selectedSet member:selectionObject]) {
				
				[self willAddToSuggestionArray:1];
				[self.suggestionArray addObject:selectionObject];
				
			}
			
			[self.selectedSet addObject:selectionObject];
			
		}
		
	}
	
}

- (void)removeSelection:(id)selectionObject {
	
	//remove from selectionSet
	if ([selectionObject isKindOfClass:[MHModel class]]) {
		
		//remove all repeats if remote ID is the same
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)selectionObject valueForKey:@"remoteID"]];
		NSArray *filteredArray = [[self.selectedSet allObjects] filteredArrayUsingPredicate:predicate];
		
		for (NSInteger resultCounter = 0; resultCounter < [filteredArray count]; resultCounter++) {
			
			[self.selectedSet removeObject:[filteredArray objectAtIndex:resultCounter]];
			
		}
		
	} else {
		
		[self.selectedSet removeObject:selectionObject];
		
	}
	
	//remove from the suggestion array unless it is a suggestion (suggestion array is an array of sugestions and selections
	if ([selectionObject isKindOfClass:[MHModel class]]) {
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)selectionObject valueForKey:@"remoteID"]];
		NSArray *filteredArray = [[self.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
		
		if ([filteredArray count] == 0) {
			
			[self willRemoveFromSuggestionArray:1];
			[self.suggestionArray removeObject:selectionObject];
			
		}
		
	} else {
		
		//if this object is a suggested object then keep it in the suggestion array and just deselect it
		if (![self.suggestionSet member:selectionObject]) {
			
			[self willRemoveFromSuggestionArray:1];
			[self.suggestionArray removeObject:selectionObject];
			
		}
		
	}
	
}

- (void)updateSelectedObject:(id)selectedObject {
	
	NSInteger numberOfObjectsAddedToSuggestionArray = 0;
	
	//check for duplicate
	
	if (self.selectedObject) {
		
		if ([self.selectedObject isKindOfClass:[MHModel class]]) {
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)self.selectedObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[self.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self.suggestionArray removeObject:self.selectedObject];
				numberOfObjectsAddedToSuggestionArray--;
				
			} else {
				
				[self.suggestionArray insertObject:self.selectedObject atIndex:0];
				numberOfObjectsAddedToSuggestionArray++;
				
			}
			
		} else {
			
			//duplicate if same object
			
			if ([self.suggestionSet member:self.selectedObject])  {
				
				[self.suggestionArray removeObject:self.selectedObject];
				numberOfObjectsAddedToSuggestionArray--;
				
			} else {
				
				[self.suggestionArray insertObject:self.selectedObject atIndex:0];
				numberOfObjectsAddedToSuggestionArray++;
				
			}
			
		}
		
	}
	
	
	self.selectedObject = selectedObject;
	
	
	if (self.selectedObject) {
		
		if ([self.selectedObject isKindOfClass:[MHModel class]]) {
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)self.selectedObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [self.suggestionArray filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self.suggestionArray insertObject:self.selectedObject atIndex:0];
				numberOfObjectsAddedToSuggestionArray++;
				
			}
			
		} else {
			
			if (![self.suggestionSet member:self.selectedObject] && ![self.selectedSet member:self.selectedObject]) {
				
				[self.suggestionArray insertObject:self.selectedObject atIndex:0];
				numberOfObjectsAddedToSuggestionArray++;
				
			}
			
		}
		
	}
	
	if (numberOfObjectsAddedToSuggestionArray > 0) {
		
		[self willAddToSuggestionArray:numberOfObjectsAddedToSuggestionArray];
		
	} else if (numberOfObjectsAddedToSuggestionArray < 0) {
		
		[self willRemoveFromSuggestionArray:abs(numberOfObjectsAddedToSuggestionArray)];
		
	}
	
}

- (void)setDataFromRequestOptions:(MHRequestOptions *)options {
	
	[self setDataArray:nil forRequestOptions:options];
	
}

- (void)setDataArray:(NSArray *)dataArray {
    
	[self setDataArray:dataArray forRequestOptions:nil];
    
}

- (void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options {
	
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

- (void)setListTitle:(NSString *)title {
	
	[self willChangeValueForKey:@"listTitle"];
	_listTitle	= title;
	[self didChangeValueForKey:@"listTitle"];
	
    self.listName.text = title;
	
}

- (IBAction)backToMenu:(id)sender {
    
	if (self.navigationController) {
	
		[self.navigationController popViewControllerAnimated:YES];
		
	} else {
		
		[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
		
	}
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	
	// Return the number of sections.
	if (self.showSuggestions) {
		
		return 2;
		
	} else {
		
		return 1;
		
	}
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	if (self.showSuggestions && section == 0) {
		
		return [self.suggestionArray count];
		
	} else if ((self.showSuggestions && section == 1) || (!self.showSuggestions && section == 0)) {
		
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
		
		cell.cellDelegate = self;
		
		if (self.showSuggestions && indexPath.section == 0) {
			
			object		= [self.suggestionArray objectAtIndex:indexPath.row];
			selected	= [self isSelected:object];;
			
		} else if ((self.showSuggestions && indexPath.section == 1) || (!self.showSuggestions && indexPath.section == 0)) {
			
			object		= [self.objectArray objectAtIndex:indexPath.row];
			selected	= [self isSelected:object];
			
		}
		
		if ([object isKindOfClass:[NSString class]]) {
			[cell populateWithTitle:object forObject:object andSelected:selected atIndexPath:indexPath];
		} else if ([object isKindOfClass:[MHModel class]]) {
			[cell populateWithTitle:[(MHModel *)object displayString] forObject:object andSelected:selected atIndexPath:indexPath];
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return MHGenericListViewControllerRowHeight;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	if (self.showHeaders) {
		
		return MHGenericListViewControllerHeaderHeight;
		
	} else {
		
		return 0;
		
	}
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView	*header			= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MHGenericListViewControllerHeaderHeight)];
	UILabel *headerLabel	= [[UILabel alloc] initWithFrame:CGRectInset(header.frame, 5, 0)];
	
	header.backgroundColor		= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	headerLabel.backgroundColor	= [UIColor colorWithRed:(128.0/255.0) green:(130.0/255.0) blue:(132.0/255.0) alpha:1.0];
	headerLabel.textColor		= [UIColor colorWithRed:(0.0/255.0) green:(0.0/255.0) blue:(0.0/255.0) alpha:1.0];
	headerLabel.font			= [UIFont fontWithName:@"HelveticaNeue" size:14.0];
	headerLabel.text			= @"";
	
	if (self.showHeaders) {
		
		if (self.showSuggestions && section == 0) {
			
			headerLabel.text		= @"Suggestions";
			
		} else if ((self.showSuggestions && section == 1) || (!self.showSuggestions && section == 0)) {
			
			headerLabel.text		= self.listTitle;
			
		} else {
			
			headerLabel.frame = CGRectZero;
			
		}
		
	} else {
		
		headerLabel.frame = CGRectZero;
		
	}
	
	[header addSubview:headerLabel];
	
	return header;
	
}

//if selection is initiated by the cell (ie a button on the cell) instead of by the cell being selected
//then that message should be passed on so the sam action can be taken
- (void)cell:(MHGenericCell *)cell didSelectPerson:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:self.tableViewList didSelectRowAtIndexPath:indexPath];
	
}

//if selection is initiated by the cell (ie a button on the cell) instead of by the cell being selected
//then that message should be passed on so the sam action can be taken
- (void)cell:(MHGenericCell *)cell didDeselectPerson:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:self.tableViewList didSelectRowAtIndexPath:indexPath];
	
}

- (void)willAddToSuggestionArray:(NSInteger)numberOfObjects {
	
	CGPoint currentContentOffset	= self.tableViewList.contentOffset;
	CGPoint scrollToContentOffset	= self.tableViewList.contentOffset;
	CGFloat heightOfSuggestions		= 0;
	heightOfSuggestions				+= ( self.showHeaders && self.showSuggestions ? MHGenericListViewControllerHeaderHeight : 0 );
	heightOfSuggestions				+= ( self.showSuggestions ? [self.suggestionArray count] * MHGenericListViewControllerRowHeight : 0 );
	
	//if the list is scrolled down past the suggestions section then correct for adding a row in suggestions
	if (currentContentOffset.y > heightOfSuggestions) {
		scrollToContentOffset.y = MIN(self.tableViewList.contentSize.height - self.tableViewList.frame.size.height, scrollToContentOffset.y + (MHGenericListViewControllerRowHeight * numberOfObjects));
	}
	
	self.tableViewList.contentOffset = scrollToContentOffset;
	
}

- (void)willRemoveFromSuggestionArray:(NSInteger)numberOfObjects {
	
	CGPoint currentContentOffset	= self.tableViewList.contentOffset;
	CGPoint scrollToContentOffset	= self.tableViewList.contentOffset;
	CGFloat heightOfSuggestions		= 0;
	heightOfSuggestions				+= ( self.showHeaders && self.showSuggestions ? MHGenericListViewControllerHeaderHeight : 0 );
	heightOfSuggestions				+= ( self.showSuggestions ? [self.suggestionArray count] * MHGenericListViewControllerRowHeight : 0 );
	
	//if the list is scrolled down past the suggestions section then correct for removing a row in suggestions
	if (currentContentOffset.y > heightOfSuggestions) {
		scrollToContentOffset.y = MAX(0, scrollToContentOffset.y - (MHGenericListViewControllerRowHeight * numberOfObjects));
	}
	
	self.tableViewList.contentOffset = scrollToContentOffset;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	[self.tableViewList deselectRowAtIndexPath:indexPath animated:YES];
	
	id object;
	
	if (self.showSuggestions && indexPath.section == 0) {
		object						= [self.suggestionArray objectAtIndex:indexPath.row];
	} else {
		object						= [self.objectArray objectAtIndex:indexPath.row];
	}
	
	if (object) {
		
		if (self.multipleSelection) {
			
			if ([self isSelected:object]) {
				
				[self removeSelection:object];
				
				if ([self.selectionDelegate respondsToSelector:@selector(list:didDeselectObject:atIndexPath:)]) {
					[self.selectionDelegate list:self didDeselectObject:object atIndexPath:indexPath];
				}
				
			} else {
				
				[self addSelection:object];
				
				if ([self.selectionDelegate respondsToSelector:@selector(list:didSelectObject:atIndexPath:)]) {
					[self.selectionDelegate list:self didSelectObject:object atIndexPath:indexPath];
				}
				
			}
			
		} else {
		
			[self updateSelectedObject:object];
			
			if ([self.selectionDelegate respondsToSelector:@selector(list:didSelectObject:atIndexPath:)]) {
				[self.selectionDelegate list:self didSelectObject:object atIndexPath:indexPath];
			}
			
		}
		
	}
	
	[self.tableViewList reloadData];
    
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (self.requestOptions) {
	
		// UITableView only moves in one direction, y axis
		NSInteger currentOffset = scrollView.contentOffset.y;
		NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
		CGFloat distanceToEndOfList = maximumOffset - currentOffset;
		CGFloat reloadDistance = (self.requestOptions.limit / 3) * MHGenericListViewControllerRowHeight;
		
		// Change 10.0 to adjust the distance from bottom
		if (distanceToEndOfList > 0.0 && distanceToEndOfList <= reloadDistance) {
			
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

#pragma mark - orientation methods

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
	
	CGRect frame;
	
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		
		frame	= CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
		
	} else {
		
		frame	= self.view.frame;
		
	}
	
	[self updateBarLayoutWithParentFrame:frame];
	[self updateLayoutWithParentFrame:frame];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
