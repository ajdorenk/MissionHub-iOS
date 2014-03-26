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

@property (nonatomic, weak)   IBOutlet UILabel		*listName;
@property (nonatomic, weak)   IBOutlet UITableView	*tableViewList;
@property (nonatomic, weak)   IBOutlet UIView		*contentView;
@property (nonatomic, strong) MHToolbar				*toolbar;

@property (nonatomic, strong) NSMutableArray		*objectArray;
@property (nonatomic, strong) MHRequestOptions		*requestOptions;
@property (nonatomic, strong) ODRefreshControl		*refreshController;

@property (nonatomic, strong) NSMutableArray		*suggestionArray;
@property (nonatomic, strong) id					selectedObject;
@property (nonatomic, strong) NSMutableSet			*allStateSet;
@property (nonatomic, strong) NSMutableSet			*someStateSet;
@property (nonatomic, strong) NSMutableSet			*suggestionSet;

@property (nonatomic, assign) BOOL					isLoading;
@property (nonatomic, assign) BOOL					refreshIsLoading;
@property (nonatomic, assign) BOOL					pagingIsLoading;
@property (nonatomic, assign) BOOL					hasLoadedAllPages;

- (void)updateSelectedObject:(id)selectedObject;

- (void)addObject:(id)object toSet:(NSMutableSet *)set;
- (void)removeObject:(id)object fromSet:(NSMutableSet *)set;
- (void)object:(id)object didChangeStateAtIndexPath:(NSIndexPath *)indexPath;
- (void)changeStateOfObject:(id)object fromState:(MHGenericCellState)fromState toState:(MHGenericCellState)toState;

- (void)willAddToSuggestionArray:(NSInteger)numberOfObjects;
- (void)willRemoveFromSuggestionArray:(NSInteger)numberOfObjects;

- (void)updateBarLayoutWithParentFrame:(CGRect)parentFrame;
- (void)updateLayoutWithParentFrame:(CGRect)parentFrame;

- (MHGenericListObjectState)stateForObject:(id)object;
- (MHGenericListObjectState)stateFromCellState:(MHGenericCellState)cellState;
- (MHGenericCellState)cellStateForObject:(id)object;
- (MHGenericCellState)nextCellStateAfterState:(MHGenericCellState)state;

- (void)applyButton:(id)sender;
- (void)backToMenu:(id)sender;
- (void)runApplyButtonCodeOnDelegateWithButton:(id)sender;
- (void)dismiss;

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;

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
@synthesize allStateSet				= _allStateSet;
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
	self.allStateSet		= [NSMutableSet set];
	self.someStateSet		= [NSMutableSet set];
	self.suggestionArray	= [NSMutableArray array];
	self.requestOptions		= nil;
	
	self.multipleSelection	= NO;
	self.showSuggestions	= YES;
	self.showHeaders		= YES;
	
	self.showApplyButton	= NO;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.refreshController = [[ODRefreshControl alloc] initInScrollView:self.tableViewList];
    [self.refreshController addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    self.tableViewList.layer.borderWidth	= 1.0;
    self.tableViewList.layer.borderColor	= [[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] CGColor];
	self.tableViewList.separatorColor		= [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
	
	if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
		
		[self setAutomaticallyAdjustsScrollViewInsets:NO];
		
	}

}

- (void)viewWillAppear:(BOOL)animated {
	
	self.listName.text	= ( self.listTitle ? self.listTitle : @"" );
	
	CGRect frame			= self.view.frame;
	
	[self updateBarLayoutWithParentFrame:frame];
	[self updateLayoutWithParentFrame:frame];
	
}

- (void)updateBarLayoutWithParentFrame:(CGRect)parentFrame {
	
	if (self.navigationController) {
		
		self.navigationItem.leftBarButtonItem		= [MHToolbar barButtonWithStyle:MHToolbarStyleBack target:self selector:@selector(backToMenu:) forBar:self.navigationController.navigationBar];
		
		if (self.showApplyButton) {
			
			self.navigationItem.rightBarButtonItem	= [MHToolbar barButtonWithStyle:MHToolbarStyleApply target:self selector:@selector(applyButton:) forBar:self.toolbar];
			
		}
		
	} else {
		
		CGFloat toolbarHeight	= 64;
		
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			
			toolbarHeight	= 44;
			
		}
		
		if (!self.toolbar) {
			
			self.toolbar		= [[MHToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(parentFrame), toolbarHeight)];
			[self.view addSubview:self.toolbar];
			
		} else {
			
			self.toolbar.frame	= CGRectMake(0, 0, CGRectGetWidth(parentFrame), toolbarHeight);
			
		}
		
		if (self.showApplyButton) {
			
			self.toolbar.items	= @[[MHToolbar barButtonWithStyle:MHToolbarStyleCancel target:self selector:@selector(backToMenu:) forBar:self.toolbar],
									[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
									[MHToolbar barButtonWithStyle:MHToolbarStyleApply target:self selector:@selector(applyButton:) forBar:self.toolbar]];
			
		} else {
			
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

- (MHGenericListObjectState)stateForObject:(id)object {
	
	MHGenericCellState state	= [self cellStateForObject:object];
	
	return [self stateFromCellState:state];
	
}

- (MHGenericListObjectState)stateFromCellState:(MHGenericCellState)cellState {
	
	MHGenericListObjectState state	= MHGenericListObjectStateSelectedNone;
	
	switch (cellState) {
			
		case MHGenericCellStateAll:
			
			state	= MHGenericListObjectStateSelectedAll;
			
			break;
			
		case MHGenericCellStateSome:
			
			state	= MHGenericListObjectStateSelectedSome;
			
			break;
			
		case MHGenericCellStateNone:
			
			state	= MHGenericListObjectStateSelectedNone;
			
			break;
			
		default:
			break;
	}
	
	return state;
	
}

- (MHGenericCellState)nextCellStateAfterState:(MHGenericCellState)state {
	
	MHGenericCellState toState	= MHGenericCellStateAll;
	
	switch (state) {
			
		case MHBlankCheckboxStateAll:
			
			toState	= MHGenericCellStateNone;
			
			break;
			
		case MHBlankCheckboxStateSome:
		case MHBlankCheckboxStateNone:
			
			toState	= MHGenericCellStateAll;
			
			break;
			
		default:
			break;
			
	}
	
	return toState;
	
}

- (MHGenericCellState)cellStateForObject:(id)object {
	
	__block MHGenericCellState state	= MHGenericCellStateNone;
	
	if (self.multipleSelection) {
		
		[self.allStateSet enumerateObjectsUsingBlock:^(id selectedObject, BOOL *stop) {
			
			if ([selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
				*stop	= [selectedObject isEqualToString:object];
			} else if ([selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
				*stop	= [selectedObject isEqualToModel:object];
			} else {
				*stop = [selectedObject isEqual:object];
			}
			
			if (*stop) {
				state	= MHGenericCellStateAll;
			}
			
		}];
		
		if (state == MHGenericListObjectStateSelectedNone) {
			
			[self.someStateSet enumerateObjectsUsingBlock:^(id selectedObject, BOOL *stop) {
				
				if ([selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
					*stop	= [selectedObject isEqualToString:object];
				} else if ([selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
					*stop	= [selectedObject isEqualToModel:object];
				} else {
					*stop = [selectedObject isEqual:object];
				}
				
				if (*stop) {
					state	= MHGenericCellStateSome;
				}
				
			}];
			
		}
		
	} else {
		
		BOOL selected	= NO;
		
		if ([self.selectedObject isKindOfClass:[NSString class]] && [object isKindOfClass:[NSString class]]) {
			selected	= [self.selectedObject isEqualToString:object];
		} else if ([self.selectedObject isKindOfClass:[MHModel class]] && [object isKindOfClass:[MHModel class]]) {
			selected	= [self.selectedObject isEqualToModel:object];
		} else {
			selected	= [self.selectedObject isEqual:object];
		}
		
		if (selected) {
			state		= MHGenericCellStateAll;
		}
		
	}
	
	return state;
	
}

- (void)refresh {
	
	[self.refreshController beginRefreshing];
	[self dropViewDidBeginRefreshing:self.refreshController];
	
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl {
	
	if (self.requestOptions) {
	
		self.hasLoadedAllPages = NO;
		self.refreshIsLoading = YES;
		[self.tableViewList reloadData];
		
		[self.requestOptions resetPaging];
		
		__weak __typeof(&*self)weakSelf = self;
		[[MHAPI sharedInstance] getResultWithOptions:self.requestOptions
										successBlock:^(NSArray *result, MHRequestOptions *options) {
											
											weakSelf.refreshIsLoading = NO;
											if (options.limit > 0) {
												weakSelf.hasLoadedAllPages = ( [result count] < options.limit ? YES : NO );
											} else {
												weakSelf.hasLoadedAllPages = YES;
											}
											
											
											weakSelf.objectArray =  [NSMutableArray arrayWithArray:result];
											[weakSelf.tableViewList reloadData];
											[weakSelf.refreshController endRefreshing];
											
											
										}
										   failBlock:^(NSError *error, MHRequestOptions *options) {
											   
											   NSString *errorMessage = [NSString stringWithFormat:@"Failed to refresh results due to: \"%@\". Try again by pulling down on the list. If the problem continues please contact support@missionhub.com", error.localizedDescription];
											   NSError *presentingError = [NSError errorWithDomain:error.domain
																							  code:error.code
																						  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
											   
											   [MHErrorHandler presentError:presentingError];
											   weakSelf.refreshIsLoading = NO;
											   [weakSelf.tableViewList reloadData];
											   [weakSelf.refreshController endRefreshing];
											   
										   }];
		
	} else {
		
		[self.tableViewList reloadData];
		[self.refreshController endRefreshing];
		
	}
	
}

- (void)setSuggestions:(NSSet *)suggestionSet andSelections:(NSSet *)selectedSet {
	
	self.multipleSelection		= YES;
	self.suggestionSet			= [NSMutableSet setWithSet:suggestionSet];
	self.allStateSet			= [NSMutableSet setWithSet:selectedSet];
	self.someStateSet			= [NSMutableSet set];
	self.selectedObject			= nil;
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	__weak __typeof(&*self)weakSelf = self;
	[self.suggestionSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[weakSelf.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[weakSelf.suggestionSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	[self.allStateSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[weakSelf.allStateSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[weakSelf.allStateSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	NSMutableSet *combinedSet	= [NSMutableSet setWithSet:self.suggestionSet];
	[combinedSet addObjectsFromArray:[self.allStateSet allObjects]];
	
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
	
	self.multipleSelection	= NO;
	self.suggestionSet		= [NSMutableSet setWithSet:suggestionsSet];
	self.allStateSet		= [NSMutableSet set];
	self.someStateSet		= [NSMutableSet set];
	self.suggestionArray	= [NSMutableArray arrayWithArray:[suggestionsSet allObjects]];
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	__weak __typeof(&*self)weakSelf = self;
	[self.suggestionSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[weakSelf.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[weakSelf.suggestionSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
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

- (void)setObjectsWithStateAllState:(NSArray *)allState someState:(NSArray *)someState {
	
	self.multipleSelection		= YES;
	self.allStateSet			= [NSMutableSet setWithArray:allState];
	self.someStateSet			= [NSMutableSet setWithArray:someState];
	self.suggestionSet			= [NSMutableSet set];
	self.suggestionArray		= [NSMutableArray array];
	self.selectedObject			= nil;
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	__weak __typeof(&*self)weakSelf = self;
	[self.allStateSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[weakSelf.allStateSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[weakSelf.allStateSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
	//NSSet only allows unique entries but there could be 2 different models that hold the same data, this will remove those duplicates
	[self.someStateSet enumerateObjectsUsingBlock:^(id suggestionObject, BOOL *stop) {
		
		if ([suggestionObject isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)suggestionObject valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[weakSelf.someStateSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] > 1) {
				
				for (NSInteger resultCounter = 1; resultCounter < [filteredArray count]; resultCounter++) {
					
					[weakSelf.someStateSet removeObject:[filteredArray objectAtIndex:resultCounter]];
					
				}
				
			}
			
		}
		
	}];
	
}

- (void)changeStateOfObject:(id)object fromState:(MHGenericCellState)fromState toState:(MHGenericCellState)toState {
	
	if (!object) {
		return;
	}
	
	NSMutableSet *currentSet		= nil;
	NSMutableSet *newSet			= nil;
	
	switch (fromState) {
			
		case MHGenericCellStateAll:
			currentSet	= self.allStateSet;
			break;
			
		case MHGenericCellStateSome:
			currentSet	= self.someStateSet;
			break;
			
		default:
			break;
	}
	
	if (currentSet) {
		
		[self removeObject:object fromSet:currentSet];
		
	}
	
	switch (toState) {
			
		case MHGenericCellStateAll:
			newSet	= self.allStateSet;
			break;
			
		case MHGenericCellStateSome:
			newSet	= self.someStateSet;
			break;
			
		default:
			break;
	}
	
	if (newSet) {
		
		[self addObject:object toSet:newSet];
		
	}
	
}

- (void)addObject:(id)object toSet:(NSMutableSet *)set {
	
	if (object && set) {
		
		if ([object isKindOfClass:[MHModel class]]) {
			
			//find all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)object valueForKey:@"remoteID"]];
			NSArray *filteredArray = [self.suggestionArray filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self willAddToSuggestionArray:1];
				[self.suggestionArray addObject:object];
				
			}
			
			predicate		= [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)object valueForKey:@"remoteID"]];
			filteredArray	= [[set allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[set addObject:object];
				
			}
			
		} else {
			
			//duplicate if same object
			if (![self.suggestionSet member:object] || ![set member:object]) {
				
				[self willAddToSuggestionArray:1];
				[self.suggestionArray addObject:object];
				
			}
			
			[set addObject:object];
			
		}
		
	}
	
}

- (void)removeObject:(id)object fromSet:(NSMutableSet *)set {
	
	if (object && set) {
	
		//remove from selectionSet
		if ([object isKindOfClass:[MHModel class]]) {
			
			//remove all repeats if remote ID is the same
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)object valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[set allObjects] filteredArrayUsingPredicate:predicate];
			
			for (NSInteger resultCounter = 0; resultCounter < [filteredArray count]; resultCounter++) {
				
				[set removeObject:[filteredArray objectAtIndex:resultCounter]];
				
			}
			
		} else {
			
			[set removeObject:object];
			
		}
		
		//remove from the suggestion array unless it is a suggestion (suggestion array is an array of sugestions and selections
		if ([object isKindOfClass:[MHModel class]]) {
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remoteID == %@", [(MHModel *)object valueForKey:@"remoteID"]];
			NSArray *filteredArray = [[self.suggestionSet allObjects] filteredArrayUsingPredicate:predicate];
			
			if ([filteredArray count] == 0) {
				
				[self willRemoveFromSuggestionArray:1];
				[self.suggestionArray removeObject:object];
				
			}
			
		} else {
			
			//if this object is a suggested object then keep it in the suggestion array and just deselect it
			if (![self.suggestionSet member:object]) {
				
				[self willRemoveFromSuggestionArray:1];
				[self.suggestionArray removeObject:object];
				
			}
			
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
			
			if (![self.suggestionSet member:self.selectedObject] && ![self.allStateSet member:self.selectedObject]) {
				
				[self.suggestionArray insertObject:self.selectedObject atIndex:0];
				numberOfObjectsAddedToSuggestionArray++;
				
			}
			
		}
		
	}
	
	if (numberOfObjectsAddedToSuggestionArray > 0) {
		
		[self willAddToSuggestionArray:numberOfObjectsAddedToSuggestionArray];
		
	} else if (numberOfObjectsAddedToSuggestionArray < 0) {
		
		[self willRemoveFromSuggestionArray:labs(numberOfObjectsAddedToSuggestionArray)];
		
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

- (void)applyButton:(id)sender {
	
	if ([self.selectionDelegate respondsToSelector:@selector(list:didTapApplyButton:)]) {
		
		[self performSelectorOnMainThread:@selector(runApplyButtonCodeOnDelegateWithButton:) withObject:sender waitUntilDone:YES];
		
	}
	
	[self dismiss];
	
}

- (void)backToMenu:(id)sender {
    
	[self dismiss];
	
}

- (void)runApplyButtonCodeOnDelegateWithButton:(id)sender {
	
	if ([self.selectionDelegate respondsToSelector:@selector(list:didTapApplyButton:)]) {
		
		[self.selectionDelegate list:self didTapApplyButton:sender];
		
	}
	
}

- (void)dismiss {
	
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < [self.objectArray count]) {
		
		static NSString *CellIdentifier = @"MHGenericCell";
		MHGenericCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if (cell == nil) {
			cell = [[MHGenericCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		id object		= nil;
		
		cell.cellDelegate = self;
		
		if (self.showSuggestions && indexPath.section == 0) {
			
			object		= [self.suggestionArray objectAtIndex:indexPath.row];
			
		} else if ((self.showSuggestions && indexPath.section == 1) || (!self.showSuggestions && indexPath.section == 0)) {
			
			object		= [self.objectArray objectAtIndex:indexPath.row];
			
		}
		
		if ([object isKindOfClass:[NSString class]]) {
			[cell populateWithTitle:object forObject:object andState:[self cellStateForObject:object] atIndexPath:indexPath];
		} else if ([object isKindOfClass:[MHModel class]]) {
			[cell populateWithTitle:[(MHModel *)object displayString] forObject:object andState:[self cellStateForObject:object] atIndexPath:indexPath];
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

- (void)cell:(MHGenericCell *)cell didChangeStateForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	
	[self object:object didChangeStateAtIndexPath:indexPath];
	
}

- (void)object:(id)object didChangeStateAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.multipleSelection) {
		
		MHGenericCellState fromState	= [self cellStateForObject:object];
		MHGenericCellState toState		= [self nextCellStateAfterState:fromState];
		
		[self changeStateOfObject:object fromState:fromState toState:toState];
		
		if ([self.selectionDelegate respondsToSelector:@selector(list:didChangeObjectStateFrom:toState:forObject:atIndexPath:)]) {
			
			[self.selectionDelegate list:self didChangeObjectStateFrom:[self stateFromCellState:fromState] toState:[self stateFromCellState:toState] forObject:object atIndexPath:indexPath];
			
		}
		
	} else {
		
		[self updateSelectedObject:object];
		
		if ([self.selectionDelegate respondsToSelector:@selector(list:didSelectObject:atIndexPath:)]) {
			
			[self.selectionDelegate list:self didSelectObject:object atIndexPath:indexPath];
			
		}
		
	}
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[self.tableViewList deselectRowAtIndexPath:indexPath animated:YES];
	
	id object		= nil;
	
	if (self.showSuggestions && indexPath.section == 0) {
		
		object		= [self.suggestionArray objectAtIndex:indexPath.row];
		
	} else {
		
		if (indexPath.row < self.objectArray.count) {
			object	= [self.objectArray objectAtIndex:indexPath.row];
		}
		
	}
	
	if (object) {
		
		[self object:object didChangeStateAtIndexPath:indexPath];
		
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
													[weakSelf.objectArray addObjectsFromArray:result];
													[weakSelf.tableViewList reloadData];
													
												}
												   failBlock:^(NSError *error, MHRequestOptions *options) {
													   
													   NSString *errorMessage = [NSString stringWithFormat:@"Failed to retreive more results due to: \"%@\". Try again by scrolling up and scrolling back down. If the problem continues please contact support@missionhub.com", error.localizedDescription];
													   NSError *presentingError = [NSError errorWithDomain:error.domain
																									  code:error.code
																								  userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(errorMessage, nil)}];
													   
													   [MHErrorHandler presentError:presentingError];
													   
													   weakSelf.pagingIsLoading = NO;
													   [weakSelf.tableViewList reloadData];
													   
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
	
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
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
