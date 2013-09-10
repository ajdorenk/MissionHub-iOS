//
//  MHGenericListViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHAPI.h"
#import "MHErrorHandler.h"
#import "MHRequestOptions.h"
#import "ODRefreshControl.h"
#import "MHGenericCell.h"

@protocol MHGenericListViewControllerDelegate;

@interface MHGenericListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MHGenericCellDelegate>

@property (nonatomic, weak) IBOutlet UILabel							*listName;
@property (nonatomic, weak) IBOutlet UITableView						*tableViewList;
@property (nonatomic, weak) IBOutlet UIView								*contentView;

@property (nonatomic, weak) id<MHGenericListViewControllerDelegate>	selectionDelegate;
@property (nonatomic, strong) NSMutableArray							*objectArray;
@property (nonatomic, strong) MHRequestOptions							*requestOptions;
@property (nonatomic, strong) ODRefreshControl							*refreshController;

@property (nonatomic, assign) BOOL										isLoading;
@property (nonatomic, assign) BOOL										refreshIsLoading;
@property (nonatomic, assign) BOOL										pagingIsLoading;
@property (nonatomic, assign) BOOL										hasLoadedAllPages;

@property (nonatomic, strong) NSMutableArray							*suggestionArray;
@property (nonatomic, strong) id										selectedObject;
@property (nonatomic, strong) NSMutableSet								*selectedSet;
@property (nonatomic, strong) NSMutableSet								*suggestionSet;
@property (nonatomic, assign) BOOL										multipleSelection;
@property (nonatomic, assign) BOOL										showSuggestions;
@property (nonatomic, assign) BOOL										showHeaders;

-(void)setListTitle:(NSString *)title;
-(void)refresh;
-(BOOL)isSelected:(id)object;
-(void)setDataFromRequestOptions:(MHRequestOptions *)options;
-(void)setDataArray:(NSArray *)dataArray;
-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options;
-(void)setSuggestions:(NSSet *)suggestionsArray andSelections:(NSSet *)selectedSet;
-(void)setSuggestions:(NSSet *)suggestionsArray andSelectionObject:(id)selectedObject;

@end



@protocol MHGenericListViewControllerDelegate <NSObject>

@required
- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)list:(MHGenericListViewController *)viewController didDeselectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end