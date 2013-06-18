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



@property (nonatomic, strong) IBOutlet UIBarButtonItem *menu;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addPerson;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *write;
@property(nonatomic, strong) NSArray *persons;

- (IBAction)revealMenu:(id)sender;


/*
@property(nonatomic, retain) MHSublabel *Sublabel;
*/
@end

