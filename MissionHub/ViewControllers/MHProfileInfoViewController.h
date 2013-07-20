//
//  MHProfileInfoViewController.h
//  MissionHub
//
//  Created by Michael Harrison on 7/12/13.
//  Copyright (c) 2013 Cru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHProfileProtocol.h"

@interface MHProfileInfoViewController : UITableViewController <MHProfileProtocol> {
	
	NSMutableArray *_sectionTitles;
	NSMutableArray *_sections;
	
}

@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong) NSMutableArray *sections;


@end
