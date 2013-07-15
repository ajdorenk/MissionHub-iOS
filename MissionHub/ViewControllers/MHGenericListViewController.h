//
//  MHGenericListViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/25/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MHGenericListViewControllerDelegate;

@interface MHGenericListViewController : UIViewController
{
    NSString *text;
    NSMutableArray *_peopleArray;
}

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, weak) id<MHGenericListViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView* tableViewList;
//@property (nonatomic, strong) IBOutlet UITableViewCell* initiatorCell;
@property (nonatomic, strong) NSMutableArray *peopleArray;

- (IBAction)handleChosenInitiator:(id)sender;


@end


@protocol MHGenericListViewControllerDelegate <NSObject>

- (void)MHGenericListViewController:(MHGenericListViewController*)viewController
                    tableCellPressed:(UIGestureRecognizer*)recognizer;

@end