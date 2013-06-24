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

/*
@class MHSublabel;
*/
@interface MHPeopleListViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate> {

    NSArray *_persons;
}


@property (nonatomic, strong) IBOutlet UIBarButtonItem *backMenuButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addPersonButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addLabelButton;
@property (nonatomic, strong) IBOutlet UIToolbar *peopleListToolbar;
@property (nonatomic, strong) IBOutlet UISearchBar *peopleSearchBar;

@property(nonatomic, strong) NSArray *persons;

- (IBAction)revealMenu:(id)sender;
/*
@property(nonatomic, retain) MHSublabel *Sublabel;
*/
@end



