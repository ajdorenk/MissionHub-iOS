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
#import "MHToolbar.h"

typedef enum {
	MHGenericListObjectStateSelectedAll,
	MHGenericListObjectStateSelectedSome,
	MHGenericListObjectStateSelectedNone
} MHGenericListObjectState;

@protocol MHGenericListViewControllerDelegate;

@interface MHGenericListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MHGenericCellDelegate>

@property (nonatomic, weak)	  id<MHGenericListViewControllerDelegate>	selectionDelegate;

@property (nonatomic, strong) NSString									*listTitle;

@property (nonatomic, assign) BOOL										multipleSelection;
@property (nonatomic, assign) BOOL										showSuggestions;
@property (nonatomic, assign) BOOL										showHeaders;
@property (nonatomic, assign) BOOL										showApplyButton;

- (void)refresh;
- (void)setDataFromRequestOptions:(MHRequestOptions *)options;
- (void)setDataArray:(NSArray *)dataArray;
- (void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options;
- (void)setSuggestions:(NSSet *)suggestionsArray andSelections:(NSSet *)selectedSet;
- (void)setSuggestions:(NSSet *)suggestionsArray andSelectionObject:(id)selectedObject;
- (void)setObjectsWithStateAllState:(NSArray *)allState someState:(NSArray *)someState;

@end

@protocol MHGenericListViewControllerDelegate <NSObject>

@optional
- (void)list:(MHGenericListViewController *)viewController didTapApplyButton:(UIBarButtonItem *)applyButton;
- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
//- (void)list:(MHGenericListViewController *)viewController didDeselectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)list:(MHGenericListViewController *)viewController didChangeObjectStateFrom:(MHGenericListObjectState)fromState toState:(MHGenericListObjectState)toState forObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end