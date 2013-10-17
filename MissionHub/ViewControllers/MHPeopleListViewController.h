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
#import "MHNewInteractionViewController.h"
#import "MHCreatePersonViewController.h"
#import "MHPersonCell.h"
#import "MHGenericListViewController.h"
#import "MHActivityViewController.h"
#import "MHSortHeader.h"

@interface MHPeopleListViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MHPersonCellDelegate, MHGenericListViewControllerDelegate, UIPopoverControllerDelegate, MHCreatePersonDelegate, MHSortHeaderDelegate, MHActivityViewControllerDelegate>

-(void)setDataFromRequestOptions:(MHRequestOptions *)options;
-(void)setDataArray:(NSArray *)dataArray forRequestOptions:(MHRequestOptions *)options;

-(void)refresh;

@end



