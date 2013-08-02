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

@protocol MHGenericListViewControllerDelegate;

@interface MHGenericListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	
    id<MHGenericListViewControllerDelegate>	_selectionDelegate;
    NSMutableArray							*_objectArray;
	MHRequestOptions						*_requestOptions;
	ODRefreshControl						*_refreshController;
	
	BOOL									_isLoading;
	BOOL									_refreshIsLoading;
	BOOL									_pagingIsLoading;
	BOOL									_hasLoadedAllPages;
	
    NSMutableArray							*_suggestionArray;
	id										_selectedObject;
	NSMutableSet							*_selectedSet;
	BOOL									_multipleSelection;
	
}


@property (nonatomic, strong) IBOutlet UILabel							*listName;
@property (nonatomic, strong) IBOutlet UITableView						*tableViewList;

@property (nonatomic, strong) id<MHGenericListViewControllerDelegate>	selectionDelegate;
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
@property (nonatomic, assign) BOOL										multipleSelection;

-(void)setListTitle:(NSString *)title;
-(void)refresh;
-(BOOL)isSelected:(id)object;
-(void)setDataFromRequestOptions:(MHRequestOptions *)options;
-(void)setDataArray:(NSArray *)dataArray;
-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options;
-(void)setSuggestions:(NSArray *)suggestionsArray andSelections:(NSSet *)selectedSet;
-(void)setSuggestions:(NSArray *)suggestionsArray andSelectionObject:(id)selectedObject;

@end



@protocol MHGenericListViewControllerDelegate <NSObject>

@required
- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)list:(MHGenericListViewController *)viewController didDeselectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end