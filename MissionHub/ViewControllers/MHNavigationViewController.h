//
//  MHNavigationViewController.h
//  MissionHub
//
//  Created by Amarisa Robison on 6/26/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MHMenuViewController.h"
#import "MHPeopleListViewController.h"


@interface MHNavigationViewController : UINavigationController {
	
	MHPeopleListViewController *_peopleListViewController;
	
}

@property (nonatomic, strong) MHPeopleListViewController *peopleListViewController;

-(void)setDataArray:(NSArray *)dataArray;

@end
