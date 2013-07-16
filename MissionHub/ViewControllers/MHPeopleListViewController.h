//
//  MHPeopleListViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 6/6/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MHMenuViewController.h"
#import "MHProfileViewController.h"
#import "ODRefreshControl.h"
#import "MHRequestOptions.h"
#import "MHPersonCell.h"

@interface MHPeopleListViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MHPersonCellDelegate> {

	NSMutableArray *_peopleArray;
	NSMutableArray *_searchResultArray;
	MHRequestOptions *_requestOptions;
	MHRequestOptions *_searchRequestOptions;
	ODRefreshControl *_refreshController;
	
	BOOL _isLoading;
	BOOL _refreshIsLoading;
	BOOL _pagingIsLoading;
	BOOL _hasLoadedAllPages;
	BOOL _searchIsLoading;
	BOOL _searchHasLoadedAllPages;
	
	NSString *_secondaryFieldName;
	
	//caching ui
	UIView *_header;
	UIView *_activityBar;
	
	
}


/*@property (nonatomic, strong) IBOutlet UIBarButtonItem *backMenuButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addPersonButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addLabelButton;

*/

@property (nonatomic, strong) IBOutlet UISearchBar *peopleSearchBar;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
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
@property (nonatomic, strong) NSString *secondaryFieldName;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) IBOutlet UIView *activityBar;
@property (nonatomic, strong) MHProfileViewController *_profileViewController;

-(IBAction)revealMenu:(id)sender;
-(void)refresh;
-(void)setDataFromRequestOptions:(MHRequestOptions *)options;
-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options;
-(MHProfileViewController *)profileViewController;

@end



