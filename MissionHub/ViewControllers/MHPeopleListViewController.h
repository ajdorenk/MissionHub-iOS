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
#import "ODRefreshControl.h"
#import "MHRequestOptions.h"

@interface MHPeopleListViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate> {

	NSMutableArray *_peopleArray;
	NSMutableDictionary *_loadingRequestDictionary;
	MHRequestOptions *_requestOptions;
	ODRefreshControl *_refreshController;
	BOOL _isLoading;
	BOOL _hasLoadedAllPages;
	UIView *_header;
	
}


/*@property (nonatomic, strong) IBOutlet UIBarButtonItem *backMenuButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addPersonButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addLabelButton;

*/

@property (nonatomic, strong) IBOutlet UISearchBar *peopleSearchBar;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableDictionary *loadingRequestDictionary;
@property (nonatomic, strong) MHRequestOptions *requestOptions;
@property (nonatomic, strong) ODRefreshControl *refreshController;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasLoadedAllPages;
@property (nonatomic, strong) UIView *header;

- (IBAction)revealMenu:(id)sender;
-(void)refresh;
-(void)setDataFromRequestOptions:(MHRequestOptions *)options;
-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options;

@end



