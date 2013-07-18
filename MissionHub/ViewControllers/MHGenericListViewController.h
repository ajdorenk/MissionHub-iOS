//
//  MHGenericListViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MHGenericListViewControllerDelegate;

@interface MHGenericListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    id<MHGenericListViewControllerDelegate> _selectionDelegate;
    NSString *text;
    NSMutableArray *_objectArray;
}


@property (nonatomic, strong) IBOutlet UILabel *listName;
@property (nonatomic, strong) IBOutlet UITableView* tableViewList;

@property (nonatomic, strong) id<MHGenericListViewControllerDelegate> selectionDelegate;
@property (nonatomic, strong) NSMutableArray *objectArray;
//@property (nonatomic, strong) NSString *listTitle;

- (IBAction)setListTitle:(NSString *)title;

@end



@protocol MHGenericListViewControllerDelegate <NSObject>

- (void)list:(MHGenericListViewController *)viewController didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end