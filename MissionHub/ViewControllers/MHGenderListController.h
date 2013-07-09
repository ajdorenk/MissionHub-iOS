//
//  MHGenderListController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/24/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHGenderListController : UIViewController <UITableViewDelegate>
{
}

//@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancel;
@property (strong, nonatomic) IBOutlet UIButton *done;
@property (strong, nonatomic) IBOutlet UIToolbar *genderToolbar;
@property (strong, nonatomic) IBOutlet UITableView *genderListCells;

@property(nonatomic, strong) NSArray *genders;

- (IBAction)donePressed:(id)sender;

@end
